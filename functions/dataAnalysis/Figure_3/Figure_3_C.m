function Figure_3_C(x, y)
load("experimentalData\Figure_3\protein_copy_number.mat")

% [somata_enriched,neuropil_enriched] = separate_it(prot_copy_number_per_spine_full);
%% ============================
somata_enriched=[prot_copy_number_per_spine_full(1,:)];
neuropil_enriched=[prot_copy_number_per_spine_full(1,:)];
for i=2:length(prot_copy_number_per_spine_full)
    if double(prot_copy_number_per_spine_full(i,9)) < 0
        somata_enriched=[somata_enriched;prot_copy_number_per_spine_full(i,:)];
    elseif double(prot_copy_number_per_spine_full(i,9)) > 0
        neuropil_enriched = [neuropil_enriched;prot_copy_number_per_spine_full(i,:)];
    end
end
%% ============================





somata_data=double(somata_enriched(2:end,5));
neuropil_data=double(neuropil_enriched(2:end,5));

[p,h] = ranksum(somata_data,neuropil_data);



ccode='p';
panel="C";
x_label={'Helm et al., 2021', 'Zappulo et al., 2017'};
y_label='Proteins/Spine';

bplot_full(somata_data,neuropil_data,ccode,panel,y_label,x_label,p,x,y)


% function [somata_enriched,neuropil_enriched] = separate_it(data)
% somata_enriched=[data(1,:)];
% neuropil_enriched=[data(1,:)];
% 
% for i=2:length(data)
%     if double(data(i,9)) < 0
%         somata_enriched=[somata_enriched;data(i,:)];
%     elseif double(data(i,9)) > 0
%         neuropil_enriched = [neuropil_enriched;data(i,:)];
%     end
% end
% end 
% 
% end