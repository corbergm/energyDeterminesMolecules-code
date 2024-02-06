function Figure_3_D(x, y)
load('experimentalData\Figure_3\protein_halflife.mat')


somata_data=double(somata_cat(2:end,7));
neuropil_data=double(neuropil_cat(2:end,7));

somata_data(isnan(somata_data))=[];
neuropil_data(isnan(neuropil_data))=[];

somata_data((somata_data>40))=[];
neuropil_data((neuropil_data>40))=[];

[p,h]       =   ranksum(somata_data,neuropil_data);

ccode='p';
panel="D";

x_label=["Fornasiero et al., 2018", "Zappulo et al., 2017"];
y_label="Protein half-life [d]";

[somata,neuropil,clog,cbtstrp] = operation(somata_data,neuropil_data,3);

bplot_full(somata,neuropil,ccode,panel,y_label,x_label,p,x,y)
end