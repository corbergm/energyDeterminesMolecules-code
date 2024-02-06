function [sources, sourceDat] = get_mRNALengths()

% author: CORNELIUS BERGMANN
% 
% last modified 16.11.2022

%% Load data from Sharova et al., 2009

% (https://dx.doi.org/10.1093%2Fdnares%2Fdsn030)
%  -  "Supplementary Table S2" contains all mRNAs. Species where different 
%     probes showed different halflives are marked with an asterisk
% read 'Supplementary Table S2'
[~,~,sharoMRNA] = xlsread('mRNAData_Sharova_2009.xls', 'Supplementary Table S2');
% Load the mRNA lengths in column "X". 
sharoLen        = cell2mat(sharoMRNA(7:end, 24)); 

clear sharoMRNA

%% Set data sources and data

sources    = {'Sharova et al., 2009'};
sourceDat  = {sharoLen};
