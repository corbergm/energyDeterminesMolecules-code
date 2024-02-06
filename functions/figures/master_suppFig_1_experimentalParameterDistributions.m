
% This script loads and plots distributions of published databases on
% parameters of interest for our model, specifically protein and mRNA
% half-life, size and the protein copy number per spine. In addition, the
% values used in our model are highlighted in each panel.

%% model parameters

% protein lifetime [d]
protLifes     = [2, 8, 20]; 
% mRNA lifetime [h]
mRNALifes     = [2, 8, 20];
% # amino acids per protein
protLengths   = [100, 500, 2000]; 
% # proteins per spine
protPerSpine  = [10, 200, 5000];
% protein diffusion constants
protDiffConst = 10.^(-2.5:-0.5);

%% parameter distributions from databases

% get lifetime distributions for mRNA and protein
[sources_m, sourceDat_m] = get_mRNALifetimes();
[sources_p, sourceDat_p] = get_proteinLifetimes();
% get length distributions for protein
[sources_a, sourceDat_a] = get_proteinLengths();
% get number of proteins per spine
[sources_s, sourceDat_s] = get_proteinsPerSpine();
% get protein diffusion constants
[sources_d, sourceDat_d] = get_proteinDiffConsts();

%% plot parameter distributions and values used in model

plot_experimentalParameterDistributions(sources_m, sourceDat_m, mRNALifes   , ...
                                        sources_p, sourceDat_p, protLifes   , ...
                                        sources_a, sourceDat_a, protLengths , ...
                                        sources_s, sourceDat_s, protPerSpine, ...
                                        sources_d, sourceDat_d, protDiffConst)
