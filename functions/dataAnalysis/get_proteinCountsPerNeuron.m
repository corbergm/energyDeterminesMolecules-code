function [sources, sourceDat] = get_proteinCountsPerNeuron()

% author: CORNELIUS BERGMANN
% 
% last modified 27.04.2023

%% Load data from Helm et al., 2021

% (https://doi.org/10.1038/s41593-021-00874-w)
% read sheet 'final copy numbers per cell'
[~,~,helmProt]  = xlsread('protData_Helm_2021.xlsx', 'final copy numbers per cell');
% Load the mean protein count per neuron in column Q 
helmProt         = helmProt(2:end, 17);
% discard 'NaN' rows 
helmProt         = helmProt(cell2mat(cellfun(@(x) ~ischar(x), helmProt, 'UniformOutput', false)));
% transform mean values to array
helmProt         = cell2mat(helmProt);

%% Set data sources and data

sources    = {'Helm et al., 2021'};
sourceDat  = {helmProt};
