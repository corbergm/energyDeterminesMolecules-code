**readme for the code associated to the manuscript 
"How energy determines spatial localisation and copy number of molecules in neurons"
by Cornelius Bergmann, Kanaan Mousaei, and Tatjana Tchumatchenko.**

# 1. System requirements 

The only required program is MATLAB 2022b with the "Parallel Computing Toolbox" installed. It can also be used without the latter with decreased performance by replacing every instance of "parofor" by "for".

For Supplementary Figure 11 (which is not related to the simulations of our model), the TREES toolbox (https://www.treestoolbox.org/) by Hermann Cuntz and colleagues is required.

Software has successfully been tested on various machines with Windows as operating system.

No specific hardware is necessary to run the code.

# 2. Installation guide 

If MATLAB2022b and the aforementioned toolboxes are installed, no additional installation procedure is required.

First, change the directory to "\energyDeterminesMolecules-code" and run "initPath_MATLAB". 
It adds the whole project folder with subfolders to the MATLAB path. 

# 3. Demo 

An exemplary simulation of mRNA and protein distributions and the associated costs can be found in "master_exampleSimulation.m". 
The expected run time is less than a minute on an average PC (depending on the chosen parameters).

# 4. Instructions for use

For Figures 1B, 1C, 3 and Supplementary Figures 1, 6, 11, 13
------------------------------------------------------------

To create a figure, execute the corresponding script in the folder "functions/figures". 
Note that Supplementary Figure 11 in addition requires the TREES toolbox (https://www.treestoolbox.org/) by Hermann Cuntz and colleagues.

For Figures 1E, 1F, 2, 4A-C, and Supplementary Figures 3-5, 7-10, 12
--------------------------------------------------------------------

To run the simulations on the full parameter space as described in the manuscript, execute "master_list" for a single dendrite length at a time. Parallelization is established within the function "run_list". 
Do not execute the script for two dendrite lengths in one run, because the output formats of the "costPerSeg" variable (encoding the cost per 10 micron of dendrite) depend on the respective dendrite length and their sizes are hence pairwise incompatible.

The run duration for one dendrite length is some minutes on an average PC when parallelized using the "Parallel Computing Toolbox".

For rapid access, the simulation output for 250, 500, 750, and 1000 micron dendrites with the parameters used throughout the manuscript is precomputed and can be found in the "files" folder under the date "2024_02_03" (without protein transport) and "2024_02_04" (with protein transport, used for Supplementary Figures 3, 4).

Finally, to create a figure, execute the corresponding script in the folder "functions/figures" (or the respective section in "master_suppFigs_5_7_8_9_10_12").

For Figure 5
------------

To simulate the temporal evolution of somatically labelled Shank3 protein in dendrites and spines, run the script "master_Shank3Dynamics". The actual implementation of the explicit and implicit finite difference scheme is in the function "run_Shank3Dynamics".

On a single computing node on an HPC, the run duration is some hours for both the explicit and the implicit numerical schemes.

For rapid access, the simulation output with the parameters used in the manuscript is precomputed and can be found in the "files" folder under the date "2023_05_04".

Finally, to create the figure, execute the corresponding script in the folder "functions/figures". 

For Supplementary Figure 2
--------------------------

To derive enesemble diffusion constants for a range of transport model and mRNA parameters, run the script "master_multipleDiffConstFit". 

For rapid access, the simulation output with the parameters used in the manuscript is precomputed and can be found in the "files" folder under the date "2023_02_01".

To create the figure, execute the corresponding script in the folder "functions/figures". 

# Project structure   

"initPath_MATLAB" adds the whole project folder with subfolders to the MATLAB path. 

"/experimentalData" contains all experimental data we retrieved from online databases and publications. Their origins are detailed below.

"/files" contains precomputed simulation outputs to recreate the manuscript figures.

"/functions" contains all scripts and functions used to perform simulations, analyze data or create figures.
  
> "/functions/figures" contains all scripts that create, when run, at least one of the manuscripts figures or figure panels.
  
> "/functions/model_core" contains all the core functions (i.e., those actually implementing or solving equations). 

>> "get_distribution" solves the main mRNA and protein equations

>> "get_cost" computes the associated metabolic cost,

>> and the remaining three functions fit an ensemble diffusion constant to the 3-state transport model as explained in the manuscript.
  
> "/functions/plotting" contains all functions that plot one or multiple panels of a figure.
  
> "/functions/dataAnalysis" contains all functions that plot one or multiple panels of a figure

# Data sources

"/experimentalData/2022_05_20_morphologies_rat_hippocampus_control_culture_complete/andreae"
> https://doi.org/10.1016/j.celrep.2015.01.032


"/experimentalData/2022_05_20_morphologies_rat_hippocampus_control_culture_complete/banerjee"
> https://doi.org/10.1016/j.neuroscience.2017.08.057


"/experimentalData/2022_05_20_morphologies_rat_hippocampus_control_culture_complete/bird"
> https://doi.org/10.1371/journal.pone.0079255


"/experimentalData/2022_05_20_morphologies_rat_hippocampus_control_culture_complete/firestein"
> https://doi.org/10.1093/cercor/bhy155


"/experimentalData/2022_05_20_morphologies_rat_hippocampus_control_culture_complete/opitz"
> https://doi.org/10.1016/j.brs.2021.09.004


"/experimentalData/2022_05_20_morphologies_rat_hippocampus_control_culture_complete/pozzo-miller"
> https://doi.org/10.1016/j.nbd.2009.05.001


"/experimentalData/mRNA_proteinData_Zappulo_2017", "/experimentalData/Figure_3/mrna_length"
> https://doi.org/10.1038/s41467-017-00690-6


"/experimentalData/cumulativeMitochondriaDensitySTD_Lopez-Domenech_2016"
> https://doi.org/10.1016/j.celrep.2016.09.004


"/experimentalData/mRNAData_Perez_2021"
> https://doi.org/10.7554/elife.63092


"/experimentalData/mRNAData_Schwanhaeusser_2011"
> https://doi.org/10.1038/nature10098


"/experimentalData/mRNAData_Sharova_2009"
> https://doi.org/10.1093%2Fdnares%2Fdsn030


"/experimentalData/mRNAData_Yang_2003"
> https://doi.org/10.1101/gr.1272403


"/experimentalData/mRNAData_Tushev_2018", "/experimentalData/Figure_3/mrna_halflife"
> https://doi.org/10.1016/j.neuron.2018.03.030

"/experimentalData/mRNAData_Zeisel_2015"
> https://doi.org/10.1126/science.aaa1934


"/experimentalData/protData_Doerrbaum_2018"
> https://doi.org/10.7554/eLife.34202


"/experimentalData/protData_Fornasiero_2018", "/experimentalData/Figure_3/protein_halflife", "/experimentalData/Figure_3/protein_length"
> https://doi.org/10.1038/s41467-018-06519-0


"/experimentalData/protData_Helm_2021", "/experimentalData/Figure_3/protein_copy_number"
> https://doi.org/10.1038/s41593-021-00874-w


"/experimentalData/protData_Mathieson_2018"
> https://doi.org/10.1038/s41467-018-03106-1


"/experimentalData/protData_Price_2010"
> https://doi.org/10.1073/pnas.1006551107


"/experimentalData/proteinDensity100Microns_Fonkeu_2019"
> https://doi.org/10.1016/j.neuron.2019.06.022


"/experimentalData/Shank3Dynamics_binned_Tsuriel_2006"
> https://doi.org/10.1371/journal.pbio.0040271


"/experimentalData/2023_09_25_proteinDiffConstants", "/experimentalData/Figure_3/protein_diffusion_coefficient"
> https://doi.org/10.1016/S0012-1606(89)80051-X


> https://doi.org/10.1073/pnas.1504762112


> https://doi.org/10.3389/fnmol.2014.00091


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.3389/fncel.2014.00151


> https://doi.org/10.1038/ncomms7872


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.3389/fncel.2014.00151


> https://doi.org/10.1038/ncomms7872


> https://doi.org/10.1038/ncomms7872


> https://doi.org/10.1371%2Fjournal.pone.0043032


> https://doi.org/10.1016/j.neuron.2009.04.023


> https://doi.org/10.1371%2Fjournal.pone.0043032


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.1371/journal.pone.0113916


> https://doi.org/10.1371%2Fjournal.pone.0043032


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.1016/j.cell.2012.06.029


> https://doi.org/10.1073/pnas.0605238103


> https://doi.org/10.1073/pnas.0605238103


> https://doi.org/10.1016/j.cell.2012.06.029


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.1523/JNEUROSCI.22-10-03910.2002


> https://doi.org/10.1093/brain/aws092


> https://doi.org/10.1083/jcb.200211011


> https://doi.org/10.1523/JNEUROSCI.4302-06.2007


> https://doi.org/10.1523/JNEUROSCI.4041-14.2015


> https://doi.org/10.1523/JNEUROSCI.4041-14.2015


> https://doi.org/10.1371/journal.pbio.0040271


> https://doi.org/10.1371/journal.pbio.0040271


> https://doi.org/10.3389/fnmol.2014.00091










