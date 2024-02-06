function plot_CaMK2aDistributions(params, mRNASim, protSim, mRNAExp, protExp)

figure('FileName', [char(datetime('today', 'Format', 'yyyy_MM_dd')), '_CaMK2aDistributions'], ...
       'Name'    , 'CaMK2aDistributions', ...
       'Units'   , 'centimeter', ...
       'Position', [2, 2, 11.5, 5]);
% load colors
load('3Reds4Blues4Greens3Greys3Violets.mat');

%% mRNA on 100 microns, simulations and data from Fonkeu et al., 2019

% major axis
ax = axes('Units'   , 'centimeter', ...
          'Position', [1.75, 1.25, 3.5, 3], ...
          'Color'   , 'none', ...
          'Box'     , 'off', ...
          'XLim'    , [0, 100], ...
          'YLim'    , [0, 0.02]); hold on;
set(get(ax, 'XAxis'), 'Color', 'none')
set(get(ax, 'YAxis'), 'Color', 'none')
% panel label
text('String'             , 'C', ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 12, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'centimeter', ...
     'Position'           , [-1.5, ax.Position(4) + 0.2], ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment'  , 'bottom'); hold on;    

% x-axis
axes('Units'               , 'centimeter', ...
     'Position'            , ax.Position + [0, -0.1, 0, 0.1], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 10, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'XLim'                , ax.XLim, ...
     'XTick'               , ax.XTick);
set(get(gca, 'YAxis'), 'Color', 'none')
set(get(gca, 'XLabel'), 'String'     , 'Distance from soma [\mum]', ...
                        'Interpreter', 'tex', ...
                        'FontSize'   , 10, ...
                        'FontName'   , 'Arial')
% y-axis
axes('Units'               , 'centimeter', ...
     'Position'            , ax.Position + [-0.1, 0, 0.1, 0], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 10, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'YLim'                , ax.YLim, ...
     'YTick'               , ax.YLim);
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YLabel'), 'String'     , {'CaMK2\alpha mRNA', 'density, norm.'}, ...
                        'Interpreter', 'tex', ...
                        'FontSize'   , 10, ...
                        'FontName'   , 'Arial')

% plot experimental normalized mRNA density 
xDat = mRNAExp.x;
yDat = mRNAExp.y;
yDat = yDat./trapz(xDat, yDat);
plot(ax, xDat, yDat, ...
     'Color'          , colors.Grey, ...
     'LineWidth'      , 0.5, ...
     'Marker'         , 'none', ...
     'MarkerSize'     , 3, ...
     'MarkerEdgeColor', 'none', ...
     'MarkerFaceColor', colors.Grey); hold on; 
% simulated mRNA density
xDat     = mRNASim.x;
yDat     = mRNASim.y;
% normalize mRNA density with the integral over the first 100 microns
first100 = 0 <= mRNASim.x & mRNASim.x <= 100;
yDat     = yDat./trapz(xDat(first100), yDat(first100));
% keep the first 100 microns
xDat     = xDat(first100);
yDat     = yDat(first100);
% plot data
plot(ax, xDat, yDat, ...
     'Color'    , colors.Red, ...
     'LineWidth', 1.5); hold on;

%% mRNA inset with full dendrite length

% axis 
mat = [20,  0  ,  0,  0;
        0, 20  ,  0,  0;
        4,  0  , 12,  0;
        0,  2.5,  0,  6]./20;
axI = axes('Units'   , 'centimeter', ...
           'Position', ax.Position*mat, ...
           'Color'   , 'none', ...
           'Box'     , 'off', ...
           'XLim'    , [0, params.length], ...
           'XTick'   , [0, params.length/2, params.length], ...
           'YLim'    , [0, 0.02]); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')

% x-axis
axes('Units'               , 'centimeter', ...
     'Position'            , axI.Position + [0, -0.1, 0, 0.1], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 7, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'XLim'                , axI.XLim, ...
     'XTick'               , axI.XTick);
set(get(gca, 'YAxis'), 'Color', 'none')

% y-axis
axes('Units'               , 'centimeter', ...
     'Position'            , axI.Position + [-0.1, 0, 0.1, 0], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 7, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'YLim'                , axI.YLim, ...
     'YTick'               , axI.YLim);
set(get(gca, 'XAxis'), 'Color', 'none')

% simulated mRNA density
xDat     = mRNASim.x;
yDat     = mRNASim.y;
% normalize mRNA density with the integral over the first 100 microns
first100 = 0 <= mRNASim.x & mRNASim.x <= 100;
yDat     = yDat./trapz(xDat(first100), yDat(first100));
% plot data
plot(axI, xDat, yDat, ...
     'Color'    , colors.Red, ...
     'LineWidth', 1.5); hold on;

%% protein on 100 microns, simulations and data from Fonkeu et al., 2019

% major axis
ax = axes('Units'   , 'centimeter', ...
          'Position', [7.25, 1.25, 3.5, 3], ...
          'Color'   , 'none', ...
          'Box'     , 'off', ...
          'XLim'    , [0, 100], ...
          'YLim'    , [0, 0.02]); hold on;
set(get(ax, 'XAxis'), 'Color', 'none')
set(get(ax, 'YAxis'), 'Color', 'none')
% panel label
text('String'             , '', ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 12, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'centimeter', ...
     'Position'           , [-1.5, ax.Position(4) + 0.2], ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment'  , 'bottom'); hold on;    

% x-axis
axes('Units'               , 'centimeter', ...
     'Position'            , ax.Position + [0, -0.1, 0, 0.1], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 10, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'XLim'                , ax.XLim, ...
     'XTick'               , ax.XTick);
set(get(gca, 'YAxis'), 'Color', 'none')
set(get(gca, 'XLabel'), 'String'     , 'Distance from soma [\mum]', ...
                        'Interpreter', 'tex', ...
                        'FontSize'   , 10, ...
                        'FontName'   , 'Arial')
% y-axis
axes('Units'               , 'centimeter', ...
     'Position'            , ax.Position + [-0.1, 0, 0.1, 0], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 10, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'YLim'                , ax.YLim, ...
     'YTick'               , ax.YLim);
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YLabel'), 'String'     , {'CaMK2\alpha protein', 'density, norm.'}, ...
                        'Interpreter', 'tex', ...
                        'FontSize'   , 10, ...
                        'FontName'   , 'Arial')

% experimental protein distribution
xDat = protExp.x;
yDat = protExp.y;
yDat = yDat./trapz(xDat, yDat);
plot(ax, xDat, yDat, ...
     'Color'          , colors.Grey, ...
     'LineWidth'      , 0.5, ...
     'Marker'         , 'none', ...
     'MarkerSize'     , 2, ...
     'MarkerEdgeColor', 'none', ...
     'MarkerFaceColor', colors.Grey); hold on; 
% simulated protein density
xDat     = protSim.x;
yDat     = protSim.y;
% normalize protein density with the integral over the first 100 microns
first100 = 0 <= protSim.x & protSim.x <= 100;
yDat     = yDat./trapz(xDat(first100), yDat(first100));
% keep the first 100 microns
xDat     = xDat(first100);
yDat     = yDat(first100);
% plot data
plot(ax, xDat, yDat, ...
     'Color'    , colors.Blue, ...
     'LineWidth', 1.5); hold on;

%% protein inset with full dendrite length

% axis 
mat = [20,  0  ,  0,  0;
        0, 20  ,  0,  0;
        4,  0  , 12,  0;
        0,  2.5,  0,  6]./20;
axI = axes('Units'   , 'centimeter', ...
           'Position', ax.Position*mat, ...
           'Color'   , 'none', ...
           'Box'     , 'off', ...
           'XLim'    , [0, params.length], ...
           'XTick'   , [0, params.length/2, params.length], ...
           'YLim'    , [0, 0.02]); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')

% x-axis
axes('Units'               , 'centimeter', ...
     'Position'            , axI.Position + [0, -0.1, 0, 0.1], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 7, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'XLim'                , axI.XLim, ...
     'XTick'               , axI.XTick);
set(get(gca, 'YAxis'), 'Color', 'none')

% y-axis
axes('Units'               , 'centimeter', ...
     'Position'            , axI.Position + [-0.1, 0, 0.1, 0], ...
     'Box'                 , 'off', ...
     'Color'               , 'none', ...
     'FontSize'            , 7, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'YLim'                , axI.YLim, ...
     'YTick'               , axI.YLim);
set(get(gca, 'XAxis'), 'Color', 'none')

% simulated protein density
xDat     = protSim.x;
yDat     = protSim.y;
% normalize protein density with the integral over the first 100 microns
first100 = 0 <= protSim.x & protSim.x <= 100;
yDat     = yDat./trapz(xDat(first100), yDat(first100));
% plot data
plot(axI, xDat, yDat, ...
     'Color'    , colors.Blue, ...
     'LineWidth', 1.5); hold on;

%% protein legend

% axis 
mat = [20,  0,  0,  0;
        0, 20,  0,  0;
        1,  0, 10,  0;
        0, 16,  0,  5]./20;
axes('Units'   , 'centimeter', ...
     'Position', ax.Position*mat, ...
     'Color'   , 'none', ...
     'Box'     , 'off', ...
     'XLim'    , [0, 1], ...
     'YLim'    , [0, 1]); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')
% legend marker experimental data
plot([0, 0.2], [0.75, 0.75], ...
     'Color'          , colors.Grey, ...
     'LineWidth'      , 0.5); hold on; 
plot(0.1, 0.75, ...
     'Color'          , colors.Grey, ...
     'LineWidth'      , 0.5, ...
     'Marker'         , 'none', ...
     'MarkerSize'     , 3, ...
     'MarkerEdgeColor', 'none', ...
     'MarkerFaceColor', colors.Grey); hold on; 
% legend label experimental data
text('String'             , 'Fonkeu et al., 2019', ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 10, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'normalized', ...
     'Position'           , [0.25, 0.75], ...
     'HorizontalAlignment', 'left', ...
     'VerticalAlignment'  , 'middle'); hold on;
% legend marker simulations
plot([0, 0.2], [0.2, 0.2], ...
     'Color'          , colors.Blue, ...
     'LineWidth'      , 1.5); hold on; 
plot([0, 0.2], [0.3, 0.3], ...
     'Color'          , colors.Red, ...
     'LineWidth'      , 1.5); hold on; 
% legend label simulations
text('String'             , 'Model prediction', ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 10, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'normalized', ...
     'Position'           , [0.25, 0.25], ...
     'HorizontalAlignment', 'left', ...
     'VerticalAlignment'  , 'middle'); hold on;
