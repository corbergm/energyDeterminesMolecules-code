function [sources, sourceDat] = get_mRNALifetimes()

% authors: CORNELIUS BERGMANN and GEORGI TUSHEV*
% * Max-Planck-Institute for Brain Research, Frankfurt am Main, Germany
% 
% last modified 27.04.2023

%% Load data from Tushev et al., 2018

% load supplementary data with both lifetime fits
data = readMergedTable('mRNAData_Tushev_2018.txt');
% transform into table
tushDat = table(data.passid, ...
                data.geneSymbol, ...
                data.geneFeature, ...
                data.cellTypeClass, ...
                data.localisationClass, ...
                data.upstreamLength, ...
                data.smodel26Feb2017.halfLife, ...
                data.smodel26Feb2017.rSquare, ...
                data.smodel12Jun2017.halfLife, ...
                data.smodel12Jun2017.rSquare);
clear data
tushDat.Properties.VariableNames = {'passid - Tushev et al.', ...
                                    'geneSymbol - Tushev et al.', ...
                                    'geneFeature - Tushev et al.', ...
                                    'cellTypeClass - Tushev et al.', ...
                                    'localisationClass - Tushev et al.', ...
                                    'upstreamLength - Tushev et al.', ...
                                    'halfLife_26Feb2017 - Tushev et al.', ...
                                    'rSquare_26Feb2017 - Tushev et al.', ...
                                    'halfLife_12Jun2017 - Tushev et al.', ...
                                    'rSquare_12Jun2017 - Tushev et al.'};
% define filters and apply them:
% - only 3'-UTRs
% - only neuron-enriched
% - both halflfe fits in [0, 24] hours range
% - both halflfe fits R^2 >= 0.5
idxUse  = strncmp('3pUTR', tushDat.("geneFeature - Tushev et al."), 5) & ...
          strcmp('neuron-enriched', tushDat.("cellTypeClass - Tushev et al.")) & ...
          (0 < tushDat.("halfLife_26Feb2017 - Tushev et al.")) & (tushDat.("halfLife_26Feb2017 - Tushev et al.") < 24) & ...
          (0 < tushDat.("halfLife_12Jun2017 - Tushev et al.")) & (tushDat.("halfLife_12Jun2017 - Tushev et al.") < 24) & ...
          (0.5 <= tushDat.("rSquare_26Feb2017 - Tushev et al.")) & ...
          (0.5 <= tushDat.("rSquare_12Jun2017 - Tushev et al."));
tushDat = tushDat(idxUse, :); 
% get lifetimes from first measurement
tushAll = tushDat.('halfLife_26Feb2017 - Tushev et al.');
clear idxUse tushDat

%% Load data from Schwanhauesser et al., 2011

% (https://doi.org/10.1038/nature10098)
%   -  "Supplemental Table S3" contains protein and mRNA data
% read 'Supplemental Table S3'
[~,~,schwaMRNA] = xlsread('mRNAData_Schwanhaeusser_2011.xls','Supplemental Table S3');
% Load the protein decay constants "k0"
schwaAll        = schwaMRNA(3:end, cellfun(@(x) contains(x, 'mRNA half-life average [h]'), schwaMRNA(1, :)));
schwaAll        = cell2mat(schwaAll(~cellfun(@ischar, schwaAll)));
clear schwaMRNA

%% Load data from Sharova et al., 2009

% (https://dx.doi.org/10.1093%2Fdnares%2Fdsn030)
%  -  "Supplementary Table S2" contains all mRNAs. Species where different 
%     probes showed different halflives are marked with an asterisk
% read 'Supplementary Table S2'
[~,~,sharoMRNA] = xlsread('mRNAData_Sharova_2009.xls', 'Supplementary Table S2');
% Load the mRNA lifetimes in column "P". 
sharoAll        = cell2mat(sharoMRNA(7:end, 16)); 
% Load the gene names
genes           = sharoMRNA(7:end, cellfun(@(x) contains(x, 'geneSymbol'), sharoMRNA(6, :)));
genes           = genes(:, 1);
% exclude species where different probes showed different halflives 
% (marked with an asterisk)
sharoAll        = sharoAll(~contains(genes, '*'));
clear genes sharoMRNA 

%% Load data from Yang et al., 2003

% (https://doi.org/10.1101/gr.1272403)
%  -  "Supplementary Table 9" contains all mRNAs. 
% read 'Supplementary Table 9'
[~,~,yangMRNA] = xlsread('mRNAData_Yang_2003.xlsx', 'Supplementary Table 9');
% Load the mRNA decay rates
yangAll        = str2double(yangMRNA(2:end, 3));
% Load the information on the consistency among several probes
consistency    = yangMRNA(2:end, 5);
% Exclude mRNA with incosistencies
yangAll        = yangAll(~contains(consistency, 'inconsistent'));
% Only keep trials with positive decay rates, the authors use the
% definition "decay rate = 1/halfilfe" and give no explanation for zero and
% negative values.
yangAll        = yangAll(yangAll > 0);
% Calculate the lifetimes
yangAll        = 1./yangAll;
clear consistency yangMRNA

%% Set data sources and data

sources    = {
              'Tushev et al., 2018'       , 'rat hippocampus';
              'Sharova et al., 2009'      , 'mouse embryonic stem cells';
              'Yang et al., 2003'         , 'human HepG2 and Bud8 cells';
              'Schwanhäusser et al., 2011', 'mouse fibroblast';
             };
sourceDat  = {tushAll, sharoAll, yangAll, schwaAll};

%% local function (from GEORGI TUSHEV)

    function data = readMergedTable(fname)
        % read text file
        fh          = fopen(fname, 'r');
        tableHeader = fgetl(fh);
        tableHeader = regexp(tableHeader, '\t', 'split');
        fmt         = repmat({'%s'}, length(tableHeader), 1);
        fmt(6:10)   = {'%n'};
        fmt         = sprintf('%s ', fmt{:});
        fmt(end)    = [];
        txt         = textscan(fh, fmt, 'delimiter', '\t');
        fclose(fh);
        % store as MATLAB structure
        data.passid                   = txt{1};
        data.geneSymbol               = txt{2};
        data.geneFeature              = txt{3};
        data.cellTypeClass            = txt{4};
        data.localisationClass        = txt{5};
        data.upstreamLength           = txt{6};
        data.smodel26Feb2017.halfLife = txt{7};
        data.smodel26Feb2017.rSquare  = txt{8};
        data.smodel12Jun2017.halfLife = txt{9};
        data.smodel12Jun2017.rSquare  = txt{10};
    end

end
