
% This script compares the diffusion lengths of dendritic mRNA molecules
% using either passive diffusion without or with active transport.
% Diffusion lengths are calculated for a reasonable range of mRNA passive
% diffusion constants and half-lives. 
% In addition, two exemplary mRNA distributions with diffusion lengths 
% resembling median values for mRNAs either without (10\mum) or with 
% (80\mum) active transport are shown.

%% mRNA diffusion lengths with and without active transport

% instantaneous transport vleocity, switching rate out of the transport
% state and the fraction of transported mRNAs at any time are set to the
% default values from the manuscript
v           = 1;
beta        = 1;
transpProb  = 0.1;

% parameter ranges for mRNA (passive) diffusion constants and half-life
% in seconds
DList       = [0.0001:0.0001:0.0009, 0.001:0.001:0.009, 0.01];
lifeList    = (2:1:20).*3600;

% container for mRNA diffusion lengths with ("diffLenAct") and without
% ("diffLenPass") acive transport
diffLenPass = zeros(numel(DList), numel(lifeList));
diffLenAct  = zeros(numel(DList), numel(lifeList));
% iterate over mRNA (passive) diffusion constants and half-lives and
% determine ensemble diffusion constants and resulting diffusion lengths
for DInd = 1:numel(DList)
    for lifeInd = 1:numel(lifeList)
        % set mRNA parameters
        params                     = [];
        % MUST BE: vPlus = vMinus
        params.vPlus               = v;
        params.vMinus              = v;
        % MUST BE: bPlus = bMinus
        params.bPlus               = beta;
        params.bMinus              = beta;
        params.halflife            = 3600*lifeList(lifeInd);
        params.lambda              = log(2)/params.halflife;
        params.D                   = DList(DInd);
        params.transpProb          = transpProb; 
        params.alpha               = params.transpProb/(1 - params.transpProb)*(1/(1/params.bPlus + 1/params.bMinus));
        params.maxRuns             = 10;
        params.atSoma              = 100;
        % dendrite length used to fit diffusion constant
        params.length              = 100;
        % solve 3-state model and fit 1-state model
        out                        = get_ensembleDiffConstFit(params);
        % store diffusion lengths without and with active transport
        diffLenPass(DInd, lifeInd) = sqrt(lifeList(lifeInd)/log(2)*DList(DInd));
        diffLenAct(DInd, lifeInd)  = sqrt(lifeList(lifeInd)/log(2)*out.D_1State);
    end
end
% plot mRNA diffusion length with and without active transport
plot_mRNADiffusionLength(diffLenPass, diffLenAct)
clear DInd DList diffLenAct diffLenPass lifeInd lifeList out params
clear v beta transpProb

%% exemplary mRNA distributions for 10 and 80 microns diffusion length

% set parameters for exemplary normalized mRNA distributions with diffusion
% lengths 10 (passive) and 80 (active) microns
diffLenPass = 10;
diffLenAct  = 80;
L           = 250;
x           = 0:1:L;
y0          = 100;

% On the interval [0, L], the analytical solution of the ODE system
%
% (EQ I)   0 = D y'' - lambda y
% (BC I)   0 = y'(L)
% (BC II)  0 = y(0) - y0
%
% is given by:
%
%          y0 exp(-1/diffLen x) [ exp(2/diffLen L) + exp(2/diffLen x) ]
%  y(x) = --------------------------------------------------------------
%                            exp(2/diffLen L ) + 1
%
% with diffusion length 
%                                  __________
%                       diffLen = V D/lambda 
%
% The mRNA densities with diffusion length 10 (no transport) and 
% 70 (with transport) microns are hence given by
yPass       = y0.*(exp(-1/diffLenPass*x).*(exp(2/diffLenPass*L) + exp(2/diffLenPass.*x))./( exp(2/diffLenPass*L) + 1));
yAct        = y0.*(exp(-1/diffLenAct*x ).*(exp(2/diffLenAct*L ) + exp(2/diffLenAct.*x) )./( exp(2/diffLenAct*L ) + 1));

% plot exemplary mRNA distributions for 10 and 80 microns diffusion length
plot_exemplaryMRNADistr_withAndWithoutTransport(diffLenPass, diffLenAct, yAct, yPass, x)
clear diffLenAct diffLenPass L x y0 yAct yPass
