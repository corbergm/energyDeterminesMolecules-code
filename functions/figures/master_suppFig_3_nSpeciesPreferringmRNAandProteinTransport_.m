
%% list of varied paramters 

varList      = cell2table({'D_m'                   , 'log_{10} D_m '             , '[\mum^2/s]';   
                           'D_p'                   , 'log_{10} D_p '             , '[\mum^2/s]';   
                           'halflife_m'            , 'mRNA half-life '           , '[h]'       ;  
                           'halflife_p'            , 'Protein half-life '        , '[d]'       ;  
                           'eta_p'                 , 'Protein copies/spine'      , ''          ; 
                           'aminoAcids'            , 'Amino acids/protein'       , ''          ; 
                           'nucleotides:aminoAcids', 'Non-coding:coding nucleot.', ''          ; 
                           'length'                , 'Dendrite length'           , '[\mum]'    });
% column heads
varList.Properties.VariableNames = {'Variable', 'Name for plots', 'Units for plots'};

%% load and prepare data

% date strings for the files with simulation results
dataStrList  = {'files\2024_02_03-dendriteLength250', ...
                'files\2024_02_03-dendriteLength500', ...
                'files\2024_02_03-dendriteLength750', ...
                'files\2024_02_03-dendriteLength1000', ...
                'files\2024_02_04-dendriteLength250', ...
                'files\2024_02_04-dendriteLength500', ...
                'files\2024_02_04-dendriteLength750', ...
                'files\2024_02_04-dendriteLength1000'};
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
clear dataStr dataStrList datTmp indDate

%% plot results

plot_nSpeciesPreferringmRNAandProteinTransport(data, varList)
clear data
