function Figure_3_A(x, y)

%% read merged table
data = readMergedTable("experimentalData\Figure_3\mrna_halflife.txt");

%% compare models per compartments
% define filters
geneFeature = '3pUTR';
cellType = 'neuron-enriched';
halfLifeRange = [0, 24];
rSquareMin = 0.5;

%% recreate figure 7D
halfLife = data.smodel26Feb2017.halfLife;
idxUse = strncmp('3pUTR', data.geneFeature, 5) & ...
         strcmp('neuron-enriched', data.cellTypeClass) & ...
         (0 < halfLife) & (halfLife < 24);
labelLocalisation = {'somata','neuropil'};
nBootstrap = 10000;
 

for l = 1 : length(labelLocalisation)

    idxNext = strcmp(labelLocalisation{l}, data.localisationClass) & ...
              idxUse;
    Y = halfLife(idxNext);
    Yavg = mean(Y);
    
    nSample = floor(0.9 * length(Y));
    Ysmp = zeros(nBootstrap, 1);
    for b = 1 : nBootstrap
        Ysmp(b) = mean(datasample(Y, nSample));
    end
    
    ary = [prctile(Ysmp,5),...
           prctile(Ysmp,25),...
           Yavg,...
           prctile(Ysmp,75),...
           prctile(Ysmp,95)];
    if l==1
        somata_data_bt=Ysmp;
        somata_data=Y;
        somata_name=data.geneSymbol(idxNext);
    end
    if l==2
        neuropil_data_bt=Ysmp;
        neuropil_data=Y;
    end

end

%% ===============================================

ccode='m';
panel='A';
x_label={'Tushev et al., 2018'};
y_label='mRNA half-life [h]';
[p,h]       =   ranksum(somata_data,neuropil_data);
bplot_full(somata_data_bt,neuropil_data_bt,ccode,panel,y_label,x_label,p,x,y)

%%===============================================
%% functions

function data = readMergedTable(fname)
    fh = fopen(fname, 'r');
    tableHeader = fgetl(fh);
    tableHeader = regexp(tableHeader, '\t', 'split');
    fmt = repmat({'%s'}, length(tableHeader), 1);
    fmt(6:10) = {'%n'};
    fmt = sprintf('%s ', fmt{:});
    fmt(end) = [];
    txt = textscan(fh, fmt, 'delimiter', '\t');
    fclose(fh);
    data.passid = txt{1};
    data.geneSymbol = txt{2};
    data.geneFeature = txt{3};
    data.cellTypeClass = txt{4};
    data.localisationClass = txt{5};
    data.upstreamLength = txt{6};
    data.smodel26Feb2017.halfLife = txt{7};
    data.smodel26Feb2017.rSquare = txt{8};
    data.smodel12Jun2017.halfLife = txt{9};
    data.smodel12Jun2017.rSquare = txt{10};
end
end