function [sources, sourceDat] = get_proteinLifetimes()

% author: CORNELIUS BERGMANN
% 
% last modified 16.11.2021

%% Load data from Fornasiero et al., 2018

% (https://doi.org/10.1038/s41467-018-06519-0)
%   -  "Info" contains header and descriptions
%   -  "Data" contains the protein data
% read 'Data' sheet
[~,~,fornProt] = xlsread('protData_Fornasiero_2018.xlsx','Data');
% Load uniprot identifiers and gene names
fornNames      = fornProt(2:end, contains(fornProt(1, :), 'Gene name(s)'));
% Get genes (not 'NaN')
isGene         = cellfun(@ischar, fornNames);
% Load the protein halflifes in cortex homogenate
fornCrtx       = fornProt(2:end, contains(fornProt(1, :), 'Protein half-life in brain cortex homogenate control (days)'));
% Load the protein halflifes in cerebellum homogenate
fornCrbl       = fornProt(2:end, contains(fornProt(1, :), 'Protein half-life in cerebellum homogenate control (days)'));
% Delete empty cells and store as IDs, gene names and data in matrices 
isNumeric      = ~cellfun(@ischar, fornCrtx);
% There can be multiple genes which are responsible for one protein!
fornCrtx       = cell2mat(fornCrtx(isNumeric & isGene));  

isNumeric      = ~cellfun(@ischar, fornCrbl);
fornCrbl       = cell2mat(fornCrbl(isNumeric & isGene));

clear fornNames fornProt isNumeric isGene

%% Load data from Price et al., 2010

% (https://doi.org/10.1073/pnas.1006551107)
%   -  "TableS1" contains general information
%   -  "TableS2-... peptides" contains data for brain, liver and blood
%      peptides
%   -  "TableS2-... proteins" contains data for brain, liver and blood
%      proteins
% read 'TableS2-brain proteins' sheet
[~,~,priceProt] = xlsread('protData_Price_2010.xlsx', 'TableS2-brain proteins');
% Load the protein identifiers and the decay constants "k0"
priceAll        = cell2mat(priceProt(3:end, cellfun(@(x) contains(x, 'k0'), priceProt(2, 1:14))));
priceAll        = log(2)./priceAll(priceAll > 0);

clear priceProt

%% Load data from Mathieson et al., 2018

% (https://doi.org/10.1038/s41467-018-03106-1)
% read "protein half lives high qual" sheet
[~,~,mathProt] = xlsread('protData_Mathieson_2018.xlsx', 'protein half lives high qual');
% Get the gene names 
% Get the data of the first replicate and the correpsonding recording
% qualities
rep3           = mathProt(2:end, contains(mathProt(1, :), 'Mouse Neurons, replicate 3 half_life'));
rep3qual       = mathProt(2:end, contains(mathProt(1, :), 'Mouse Neurons, replicate 3 dataQual'));
% Get the data of the second replicate and the correpsonding recording
% qualities
rep4           = mathProt(2:end, contains(mathProt(1, :), 'Mouse Neurons, replicate 4 half_life'));
rep4qual       = mathProt(2:end, contains(mathProt(1, :), 'Mouse Neurons, replicate 4 dataQual'));
% Derive the proteins with two 'good' qualities within both replicates
isGoodQual     = intersect(find(contains(rep3qual, 'good')), find(contains(rep4qual, 'good')));
rep3           = cell2mat(rep3(isGoodQual));
rep4           = cell2mat(rep4(isGoodQual));
% Average between replicates
mathAll        = (rep3 + rep4)./2;
% Transform units from hours to days
mathAll        = mathAll./24;

clear isGoodQual mathProt rep3 rep3qual rep4 rep4qual 

%% Load data from Doerrbaum et al., 2018

% (https://doi.org/10.7554/eLife.34202)
%   -  "Doerrbaum_Mixed" contains all proteins
%   -  "Doerrbaum_Neuron-enriched" contains proteins enriched in neurons
%   -  "Doerrbaum_Glia-enriched" contains proteins enriched in glia
% read "Doerrbaum_Neuron-enriched" sheet
[~,~,doerrProt] = xlsread('protData_Doerrbaum_2018.xlsx', 'Doerrbaum_Neuron-enriched');
% Get the protein half lifes
doerrMix        = cell2mat(doerrProt(5:end, cellfun(@(x) contains(x, 'Half-life [days]'), doerrProt(4, 1:8))));

clear doerrProt

%% Set data sources and data

sources    = {'Mathieson et al., 2018' , 'in vitro'; ...
              'Dörrbaum et al., 2018'  , 'in vitro';  ...
              'Fornasiero et al., 2018', 'in vivo' ; ...
              'Fornasiero et al., 2018', 'in vivo' ; ...
              'Price et al., 2010'     , 'in vivo' ; ...
             };
sourceDat  = {mathAll, doerrMix, fornCrtx , fornCrbl, priceAll};
