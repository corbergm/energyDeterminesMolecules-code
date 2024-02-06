function [sources, sourceDat] = get_proteinDiffConsts()

% author: CORNELIUS BERGMANN
% 
% last modified 29.04.2023

%% load data

% load list with protein diffusion constants
data  = readtable('2023_09_25_proteinDiffConstants.xlsx', 'Sheet', 'data');
% get protein diffusion constants
DpAll = data.('D_microns_2_s');
clear data

%% Set data sources and data

sources   = {'various sources'};
sourceDat = {DpAll};
