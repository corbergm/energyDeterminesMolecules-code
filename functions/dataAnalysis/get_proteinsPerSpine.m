function [sources, sourceDat] = get_proteinsPerSpine()

% author: CORNELIUS BERGMANN
% 
% last modified 16.11.2022

%% Load data from Helm et al., 2021

% (https://doi.org/10.1038/s41593-021-00874-w)
% read sheet 'Supplementary Table 2'
[~,~,helmProt]  = xlsread('protData_Helm_2021.xlsx','Supplementary Table 2');
% Load the protein count per spine in column F
helmSpine       = helmProt(2:end, 6);
% discard 'non-detected' in rows 11, 29, 48 and 'NaN' in the last two rows
helmSpine       = cellfun(@(x) strsplit(x, '±'), helmSpine([1:10, 12:29, 31:47, 49:77, 79:(end-2)]), 'UniformOutput', false);
% get count per spine
helmMean        = zeros(size(helmSpine));
for i = 1:size(helmSpine, 1)
    tmp         = helmSpine{i, :};
    helmMean(i) = str2double(tmp{1});
end

clear helmProt helmSpine i tmp

%% Set data sources and data

sources         = {'Helm et al., 2021'};
sourceDat       = {helmMean};
