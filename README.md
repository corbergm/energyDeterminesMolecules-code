# Tree_distributions


This project aims to build a MATLAB-written tool to model transport processes of mRNA and protein in dendrites and the corresponding energetic costs.

@Kanaan:

The main script to get distributions and energies with the current (06/05/2022) model is "\functions_linDendrModel4_2\master_distributionAndCost_linDendrModel4_3.m". 

The variable "kappa" contains three numbers in [0, 1], defining the fraction of actively transported mRNA (kappa_1), actively transported protein (kappa_2), and of mRNA retained in the soma (kappa_3). Extreme cases are kappa_3 = 0 (dendritic translation) and kappa_3 = 1 (somatic translation).

Fitting an ensemble diffusion coefficient to a mRNA or protein population experiencing active transport is done within "\functions_linDendrModel4_2\get_ensembleDiffFrom1StateFitTo3StateModel.m".

mRNA and protein distributions are calculated within "get_distribution_linDendrModel4_3.m". This function implements the differential equations defining mRNA and protein dynamics and the corresponding boundary conditions. Finally, it returns the soultion of the defined ODE system.

Resulting energy costs (in total ATP per second) are determined within "\functions_linDendrModel4_2\get_cost_linDendrModel4_2.m" (the version 4_2 is correct here). Costs incorporate transcription, translation, and transport.

Parameters for the proteins of interest (Gria1, Gria2, CamkIIa, CamkIIb, Adam22) are summarized in "\functions_permeability\master_proteinsOfInterest.m".

The script "\functions_permeability\master_permeabAnalysisForProteinsOfInterest.m" analyses the effect of permeability and protein diffusion on the spine-to-dendrite ratio for Gria1 and CamkIIa.

mRNA and protein data tables from external sources lie in the folder "\files_externalData", and the functions extracting and plotting data thereof in "\functions_paramsFromExternalData".

All created figures are saved as MATLAB figures with a data stamp in "\figures_matlab", other formats can be derived from those.

Cornelius Bergmann, 06.05.2022
