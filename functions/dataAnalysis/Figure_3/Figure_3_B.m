function Figure_3_B(x, y)

load("experimentalData\Figure_3\mrna_length.mat")

somata_data=double(somata_cat(3:end,8));
neuropil_data=double(neuropil_cat(3:end,8));

somata_data(isnan(somata_data))=[];
neuropil_data(isnan(neuropil_data))=[];

[p,h]       =   ranksum(somata_data,neuropil_data);

ccode='m';
panel="B";

x_label=["Zappulo et al., 2017"];
y_label="mRNA length";
    
[somata,neuropil,clog,cbtstrp]=operation(somata_data,neuropil_data,3);

bplot_full(somata,neuropil,ccode,panel,y_label,x_label,p,x,y)

end