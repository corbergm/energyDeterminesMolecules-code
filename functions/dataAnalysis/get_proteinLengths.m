function [sources, sourceDat] = get_proteinLengths()

% author: CORNELIUS BERGMANN
% 
% last modified 16.11.2022

%% Load data from Fornasiero et al., 2018

% (https://doi.org/10.1038/s41467-018-06519-0)
%   -  "Info" contains header and descriptions
%   -  "Data" contains the protein data
% read 'Data' sheet
[~,~,fornProt] = xlsread('protData_Fornasiero_2018.xlsx','Data');
% Load the protein lengths (# of amino acids)
fornLen        = fornProt(2:end, contains(fornProt(1, :), 'Amino acid number (length)'));
fornLen        = cell2mat(fornLen(~cellfun(@ischar, fornLen)));

clear fornProt 

%% Set data sources and data

sources    = {'Fornasiero et al., 2018'};
sourceDat  = {fornLen};
