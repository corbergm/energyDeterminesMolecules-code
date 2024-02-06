
% author: CORNELIUS BERGMANN
%
% modified 03.02.2024
%
% This function calculates the distribution of mRNA and protein on a linear
% dendrite of length L using a discrete and the standard continuous uptake 
% function.

%% set parameters

% generic parameters
params              = [];
params.v            = 1;
params.beta         = 1;
params.tRate        = 0.01;
params.permeability = 1000;
params.phi          = 0.95;
params.maxRuns      = 10;

% linear dendrite with given spine numbers
params.length       = 250;
nSpineList          = [50, 125, 250];

% pick medium values for protein and mRNA parameter
params.D_m          = 0.001;
params.D_p          = 0.01;
params.halflife_m   = 8*3600;
params.halflife_p   = 8*24*3600;
params.eta_p        = 500;

% use dendritic mRNA
params.somaRet      = 0;
params.transp_m     = 0.1;

% no protein transport
params.transp_p     = 0;
params.DEns_p       = params.D_p;

%% fit ensemble mRNA diffusion coefficient 

tmp            = [];
% MUST BE: vPlus = vMinus
tmp.vPlus      = params.v;
tmp.vMinus     = params.v;
% MUST BE: bPlus = bMinus
tmp.bPlus      = params.beta;
tmp.bMinus     = params.beta;
tmp.D          = params.D_m;
tmp.transpProb = params.transp_m;
tmp.alpha      = tmp.transpProb/(1 - tmp.transpProb)*(1/(1/tmp.bPlus + 1/tmp.bMinus));
tmp.halflife   = params.halflife_m;
tmp.lambda     = log(2)/tmp.halflife;
tmp.maxRuns    = params.maxRuns;
% value at soma always set to 100
tmp.atSoma     = 100;
% for diffusion constant fit always set dendrite length to 100
tmp.length     = 100;
% solve 3-state model and fit 1-state model
out            = get_ensembleDiffConstFit(tmp);
% store results in table
params.DEns_m  = out.D_1State;
clear out tmp

%% solve discrete spine uptake model

% number of simulations
nReps = numel(nSpineList);

% container for spine locations, x-values, length vector, mRNA and protein
% distributions
discr = cell(5, nReps);

% iterate over spine numbers
for rep = 1:nReps
    
    % get number of spines, their locations, and distances
    nSpines   = nSpineList(rep);
    spineLocs = params.length./(nSpines+1)*(1:1:nSpines);
    spineLocs = spineLocs';
    spineDist = [spineLocs; params.length] - [0; spineLocs];
    clear nSpines
    
    % solve the ODE system
    solution = get_distribution_discreteSpines(spineDist, params);

    % number of segments between neighbouring spines and interval boundaries
    nEdges = numel(spineDist);
    % Set the points at which the distributions should be evaluated. 
    xval   = linspace(0, 1, 2*params.length);
    % Derive the mRNA and protein distributions. Round to 10 digits to 
    % remove errors below mass conservation accuracy that disturb the plots.
    mRNA         = [];
    mRNA.data    = round(deval(solution, xval, 2:4:4*nEdges-2), 10);
    protein      = [];
    protein.data = round(deval(solution, xval, 4:4:4*nEdges  ), 10);
    clear nEdges solution
    
    % store spine locations, x-values, spine distances, mRNA and protein
    % distributions
    discr{1, rep} = spineLocs;
    discr{2, rep} = xval;
    discr{3, rep} = spineDist;
    discr{4, rep} = mRNA;
    discr{5, rep} = protein;
    clear mRNA protein spineDist spineLocs xval
end
clear nReps rep

%% solve continuous spine uptake model

% list of spine densities, corresponding to spine numbers
rhoList = nSpineList./params.length;
% container for x-values, mRNA and protein distributions
contin  = cell(3, numel(rhoList));

% iterate over spine densities
for rep = 1:numel(rhoList)
    
    params.rhoSpines = rhoList(rep); 
    % get ode solution
    solution = get_distribution(params);
    % Set the points at which the distributions should be evaluated. 
    xval     = linspace(0, params.length, 2*params.length);
    % initialise structures for mRNA and protein
    mRNA     = [];
    protein  = [];
    % Derive the mRNA and protein distributions. Round to 10 digits to 
    % delete errors below mass conservation accuracy that disturb the plots.
    mRNA.data    = round(deval(solution, xval, 2), 10);
    protein.data = round(deval(solution, xval, 4), 10);
    clear solution
    
    % store x-values, mRNA and protein distributions
    contin{1, rep} = xval;
    contin{2, rep} = mRNA;
    contin{3, rep} = protein;
    clear mRNA protein xval
end
clear rep

%% plot discrete and continuous uptake model

plot_equidistSpineDistr(discr, contin, rhoList, params)

