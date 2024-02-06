function bplot_full(x1,x2,c,pl,y_info,x_info,pv,ax1,ax2)

% load colors
DarkRed      = [0.9137, 0.4157, 0.4392];
DarkBlue     = [0.4667, 0.6706, 0.7412];
% proteins: blue, mRNA: red
if strcmp(c,'m')
    color        = DarkRed;     
elseif strcmp(c,'p')
    color        = DarkBlue;     
end
% data
if length(x1(1,:))<length(x1(:,1))
    q={x1,x2};
elseif length(x1(1,:))>length(x1(:,1))
    q={x1',x2'};
end
% x-axis label
xLabel     = x_info;
% y-axis label
yLabel     = y_info;
% panel label
panelLabel = pl;

%%

% create axis
ax                             = axes;
ax.Units                       = 'centimeter';
ax.Position                    = [ax1, ax2, 2, 3];

% plot panel label
T                              = text; hold on;
T.String                       = panelLabel;
T.Interpreter                  = 'tex';
T.FontSize                     = 12;
T.FontName                     = 'Arial';
T.Units                        = 'centimeter';
T.Position                     = [-1.3, ax.Position(4) + 0.2];
T.HorizontalAlignment          = 'center';
T.VerticalAlignment            = 'bottom';

for i = 1:2
    if i == 1
        b                          = boxchart(i.*ones(size(q{i}, 1), 1), q{i}); hold on;
        b.BoxFaceColor             = color;
        b.BoxWidth                 = 0.5;
        b.BoxFaceAlpha             = 0;
        b.WhiskerLineColor         = color;
        b.LineWidth                = 1;
        b.MarkerColor              = 'none';
    elseif i == 2
        b                          = boxchart(i.*ones(size(q{i}, 1), 1), q{i}); hold on;
        b.BoxFaceColor             = color;
        b.BoxWidth                 = 0.5;
        b.BoxFaceAlpha             = 1;
        b.WhiskerLineColor         = color;
        b.LineWidth                = 1;
        b.MarkerColor              = 'none';

        p                     = plot(2 + (b.BoxWidth/2).*[-1, 1], median(q{i}).*[1, 1]); hold on;
        p.Color               = 'white';
        p.LineWidth           = 1;
    end
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'Color', 'w');   
end

% adjust axis layout
ax.Box                         = 'off';
ax.Color                       = 'none';
ax.FontSize                    = 10;
ax.FontName                    = 'Arial';
ax.LineWidth                   = 0.5;
ax.TickDir                     = 'out';
ax.TickLength                  = [0.02, 0.03];
ax.TickLabelInterpreter        = 'tex';
ax.XAxis.Color                 = 'none';
ax.XLim                        = [0.4, 2.6];
% ax.YLim                        = [];
ax.YLabel.String               = yLabel;
ax.YLabel.FontSize             = 10;
ax.YLabel.FontName             = 'Arial';
ax.YLabel.Interpreter          = 'tex';

% plot x-axis tick labels
T                          = text; hold on;
T.String                   = xLabel;
T.Interpreter              = 'tex';
T.FontSize                 = 10;
T.FontName                 = 'Arial';
T.Units                    = 'normalized';
T.Position                 = [0.5, -0.05];
T.HorizontalAlignment      = 'center';
T.VerticalAlignment        = 'top';

if pv >= 0.05
    str     =   "ns";
    nStars  = 0;
elseif 0.05 > pv && pv >= 0.01
    str     =   "*";
    nStars  = 1;
elseif 0.01 >= pv && pv >= 0.001
    str     =   "**";
    nStars  = 2;
elseif 0.001 > pv
    str     =   "***";
    nStars  = 3;
end

mat                            = [20,  0,  0,  0;
                                   0, 20,  0,  0;
                                   0,  0, 20,  0;
                                   0, 21,  0,  0]./20;
axS                            = axes('units', 'centimeter', 'Position', ax.Position*mat + [0, 0, 0, 0.3]);

% plot significance bar ...
p                              = plot([1, 2], [0.25, 0.25]); hold on;
p.Color                        = 'black';
p.LineWidth                    = 0.75;

T                              = text; hold on;
if nStars > 0
    T.String                   = repmat('\ast', 1, nStars);
else
    T.String                   = 'ns';
end
T.Interpreter                  = 'tex';
T.FontSize                     = 10;
T.FontName                     = 'Arial';
T.Units                        = 'data';
T.Position                     = [1.5, 0.25];
T.HorizontalAlignment          = 'center';
T.VerticalAlignment            = 'bottom';

% adjust axis layout
axS.Box                        = 'off';
axS.Color                      = 'none';
axS.XAxis.Color                = 'none';
axS.XLim                       = ax.XLim;
axS.YAxis.Color                = 'none';
axS.YLim                       = [0, 1];

end