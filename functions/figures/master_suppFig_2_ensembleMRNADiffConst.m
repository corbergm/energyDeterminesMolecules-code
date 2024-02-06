
% This script plots the effect of transport model parameters (velocity,
% beta, and transport probability) on the increase in mRNA mobility,
% quantified as ensemble divided by passive diffusion constant. This is
% done for a range of mRNA half-lives and diffusion constants.
% Note that instead of beta the inverse mean run duration is shown.

%% List of transport model parameters

% note that "beta" is the inverse of the mean run duration!
varList = cell2table({'v'                    , 'mRNA granule velocity '        , '[\mum/s]';   
                      'beta'                 , 'Mean run duration '            , '[s]'     ; 
                      'transport probability', 'Percentage of transported mRNA', ''        });
% column heads
varList.Properties.VariableNames = {'Variable', 'Name for plots', 'Units for plots'};

%% load mRNA ensemble diff. const. 

dataStr = '2024_02_01_transportModel'; 
load([dataStr, '_results.mat'], 'results')
load([dataStr, '_parameterList.mat'], 'refVals')

%% plot effect of transport model parameters on ensemble diff. const.

% order of variables to be analyzed
varsToShow = [3, 1, 2];
plot_analyzeEnsembleMRNADiffConst(results, refVals, varList, varsToShow)
clear varsToShow
