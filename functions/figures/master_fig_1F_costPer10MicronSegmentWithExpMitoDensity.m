
addpath(genpath('energyDeterminesMolecules-code'))

%% load and prepare data

% date strings for the files with simulation results
dataStrList  = {'files\2024_02_03-dendriteLength250'};
% consolidate simulation results
for indDate = 1:numel(dataStrList)
    % set date string
    dataStr  = dataStrList{indDate};
    % load data
    load([dataStr, '_results.mat'], 'results');
    % Consolidate and transform table to have one parameter combination per row
    datTmp   = get_consolidateParameterLists(results);
    clear results
    % Append data
    if indDate == 1
        data = datTmp;
    else
        data = [data; datTmp];
    end
end
clear dataStr dataStrList datTmp indDate

%% plot cumulative energy need vs experimentally observed mitochondria distribution

% get dendrite length
len = categories(categorical(data.('length')));
len = str2double(len{:});
% plot results
plot_costPer10MicronSegmentWithExpMitoDensity(data, len)
clear len
