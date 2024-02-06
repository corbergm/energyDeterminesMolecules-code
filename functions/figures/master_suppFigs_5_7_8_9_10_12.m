
%% list of varied paramters

varList      = cell2table({'D_m'                   , 'log_{10} D_m '                       , '[\mum^2/s]';   
                           'D_p'                   , 'log_{10} D_p '                       , '[\mum^2/s]';   
                           'halflife_m'            , 'mRNA half-life '                     , '[h]'       ;  
                           'halflife_p'            , 'Protein half-life '                  , '[d]'       ;  
                           'eta_p'                 , 'Protein copies/spine'                , ''          ; 
                           'aminoAcids'            , 'Amino acids/protein'                 , ''          ; 
                           'nucleotides:aminoAcids', {'# Non-coding/coding', 'nucleotides'}, ''          ; 
                           'length'                , 'Dendrite length'                     , '[\mum]'    });
% column heads
varList.Properties.VariableNames = {'Variable', 'Name for plots', 'Units for plots'};

%% load and prepare data

% date strings for the files with simulation results
dataStrList  = {'files\2024_02_03-dendriteLength250', ...
                'files\2024_02_03-dendriteLength500', ...
                'files\2024_02_03-dendriteLength750', ...
                'files\2024_02_03-dendriteLength1000'};
% consolidate simulation results
for indDate = 1:numel(dataStrList)
    % set date string
    dataStr  = dataStrList{indDate};
    % load data
    load([dataStr, '_results.mat'], 'results');
    % Consolidate and transform table to have one parameter combination per row
    datTmp   = get_consolidateParameterLists(results);
    clear results
    % remove cost per 50 microns, table concatenation with multiple
    % dendrite lengths does not allow it
    datTmp   = removevars(datTmp,{'totalCostPer10MicronSegment - som', 'totalCostPer10MicronSegment - den'});
    % Append data
    if indDate == 1
        data = datTmp;
    else
        data = [data; datTmp];
    end
end
clear dataStr datTmp indDate

%% Supplementary Figure 5

% take only one length
lengthToShow = 1000;
% limit of boxplot
yLim         = [-3, 14];
% show the share of cost factors (transcription, translation, transport 
% costs relative to total costs) for each parameter combination with either 
% somatic or dendritic mRNA
plot_translTranscrTranspCost(data(data.('length') == lengthToShow, :), yLim)
clear lengthToShow yLim

%% Supplementary Figure 7

% effects of single parameters on total cost
% -------------------------------------------------------------------------
% take only one length
lengthToShow = 1000;
% limit of boxplots
yLim         = [-1, 16];
% choose which parameters' panels should be shown and in which order. 
varsToShow   = [3, 7, 1, 5, 4, 6, 2];

plot_totalCostCheapestStrategy(data(data.('length') == lengthToShow, :), varList, varsToShow, yLim)
clear lengthToShow varsToShow

%% Supplementary Figure 8A

% take only one length
lengthToShow = 1000;
% plot cost ratio of somatic vs. dendritic mRNA
plot_somToDendrCostProtDiffConst(data(data.('length') == lengthToShow, :), varList)
clear lengthToShow varsToShow

%% Supplementary Figure 8B

% load list of protein diffusion constants
[~, ~, protDiffConstDat] = xlsread('2023_09_25_proteinDiffConstants.xlsx','data');
% get protein diffusion coefficients and mRNA enrichment scores from
% Zappulo et al., 2017
protDiffConsts    = protDiffConstDat(2:33, contains(protDiffConstDat(1, 1:7), 'D_microns_2_s'));
mRNAEnrichment    = protDiffConstDat(2:33, contains(protDiffConstDat(1, 1:7), 'log2_mRNA_neurite_soma_Zappulo_2017'));
% transform to double array
protDiffConstsAvg = cell2mat(protDiffConsts);
mRNAEnrichmentAvg = cell2mat(mRNAEnrichment);

% plot results
plot_protDiffConstVsMRNAEnrichment(protDiffConstsAvg, mRNAEnrichmentAvg)
clear mRNAEnrichment mRNAEnrichmentAvg protDiffConstDat protDiffConsts protDiffConstsAvg

%% Supplementary Figure 9

% plot total cost per supplied protein
yLim   = [-4, 5];
plot_totalCostPerSuppliedProtein_multLength(data, yLim)
clear yLim

%% Supplementary Figure 10

% set limits of box plots for mRNA and protein abundance
yLim_m = [-1, 9];
yLim_p = [ 3, 13];
% plot total mRNA and protein abundance for various dendrite lengths, 
% clustered along the cheapest strategy
plot_abundancesDendriticVsSomaticAllDendrLens(data, yLim_m, yLim_p)
clear yLim_m yLim_p

%% Supplementary Figure 12

plot_mRNAAndProteinCorrelationAllDendrLens(data)
