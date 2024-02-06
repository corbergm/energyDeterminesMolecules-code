
% panel labels
fig3_labels = ['ABCDE'];
% databases for each panel
fig3_data = ["mrna_halflife.txt",...
             "mrna_length.mat", ...
             "protein_halflife.mat",...
             "protein_copy_number.mat",...
             "protein_length.mat"];

% initialise figure
f          = figure;
f.Units    = 'centimeter';
f.Position = [10, 10, 20, 13];

% panel positions
x_axis = [6, 10, 2, 6, 10];
y_axis = [8, 8, 2, 2, 2];

% create each panel
for panel = 1:length(fig3_labels)
    clearvars -except panel fig3_labels f x_axis y_axis
    x = x_axis(panel);
    y = y_axis(panel);
    eval("Figure_3_"+fig3_labels(panel)+"(x,y)")
end

