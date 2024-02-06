
% It is necessary to load the TREES toolbox by Hermann Cuntz: 
% https://www.treestoolbox.org/

% Start TREES toolboxes
start_trees;

% Overview
% -------------------------------------------------------------------------
% webpage         : neuromorpho.org
% search keywords : hippocampus & rat & control & culture & complete
% retrieval date  : 20/05/2022

% morphs found    :  21  from (Chapleau  , 2009)  , folder "pozzo-miller"
%                    10  from (Shirinpour, 2021)  , folder "opitz"
%                    27  from (Andreae   , 2015)  , folder "andreae"
%                    45  from (Kumari    , 2017)  , folder "banerjee"
%                   (32) from (Bird      , 2013)* , folder "bird"
%                   (94) from (Liang     , 2019)**, folder "firestein"
%                   ---
%                   104 (230) 
%
% *  We discarded the 32 cells from (Bird. 2013), because they contain no
%    dendrites, only axons and somata. 
% ** Furthermore, we also discarded the 94 cells from (Liang, 2019) because
%    their cells were embryonic cells of less than or equal 18d age.
%
% included sources
% -------------------------------------------------------------------------
% (Chapleau  , 2009) : https://doi.org/10.1016/j.nbd.2009.05.001
% (Shirinpour, 2021) : https://doi.org/10.1016/j.brs.2021.09.004
% (Andreae   , 2015) : https://doi.org/10.1016/j.celrep.2015.01.032
% (Kumari    , 2017) : https://doi.org/10.1016/j.neuroscience.2017.08.057
%
% discarded sources
% -------------------------------------------------------------------------
% (Bird      , 2013) : https://doi.org/10.1371/journal.pone.0079255
% (Liang     , 2019) : https://doi.org/10.1093/cercor/bhy155

%% derive dendritic pathlengths

% list of directories with .swc files
dirList                      = {'pozzo-miller', ...
                                'opitz'       , ...
                                'andreae'     , ...
                                'banerjee'    };
% ... and the corresponding papers
dirPaperList                 = {'Chapleau et al., 2009'  , ...
                                'Shirinpour et al., 2021', ...
                                'Andreae et al., 2015'   , ...
                                'Kumari et al., 2017'    };
% number of directories
nDirs                        = numel(dirList);
% Container for 104 pathlengths and source id's
pathLen                      = zeros(104, 2);
% running dendrite index
dendrInd                     = 1;
% get dendritic pathlength for all morphologies
for i = 1:nDirs
    theFiles                 = dir(['C:\Users\Pluto\INS_FFM\C12_Tchumatchenko', ...
                                    '\code\tree-distributions\files\experimentalData', ...
                                    '\2022_05_20_morphologies_rat_hippocampus_control_culture_complete\', ...
                                    dirList{i}, '\CNG version\*.CNG.swc']);
    for j = 1:numel(theFiles)
        % load morphology
        tree                 = load_tree(theFiles(j).name);
        % get axons
        isAxon               = cellfun(@(x) strcmp(x, '2'), tree.rnames(tree.R));
        % delete axons
        tree                 = delete_tree(tree, isAxon);
        % get and store maximal pathlength
        pathLen(dendrInd, 1) = max(Pvec_tree(tree));
        % store dendrite source
        pathLen(dendrInd, 2) = i;
        % increase counter
        dendrInd             = dendrInd + 1;
    end
end
clear dendrInd dirList i isAxon j nDirs theFiles tree

%% plot dendrite pathlengths

plot_experimentalDendriticPathlength(pathLen, dirPaperList)
