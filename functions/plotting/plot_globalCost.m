function plot_globalCost(data, yLim)

% boolean encoding which parameter combination prefers dendritic mRNA
denIsCheapest = data.('totalCost - den') < data.('totalCost - som');
% get total cost per parameter combination, take cost of cheapest option
totalCost     = data.('totalCost - den').*( denIsCheapest) ...
              + data.('totalCost - som').*(~denIsCheapest);
% get total protein (dendrite + spine) per parameter combination, take 
% cheapest option
totalProtein  = data.('proteinDendrTotal - den').*( denIsCheapest) ...
              + data.('proteinSpineTotal - den').*( denIsCheapest) ...
              + data.('proteinDendrTotal - som').*(~denIsCheapest) ...
              + data.('proteinSpineTotal - som').*(~denIsCheapest);

%%

% load colors
load('3Reds4Blues4Greens3Greys3Violets.mat');
% initialise figure
figure('FileName', [char(datetime('today', 'Format', 'yyyy_MM_dd')), '_globalCost'], ...
       'Name'    , 'globalCost', ...
       'Units'   , 'centimeter', ...
       'Position', [2, 2, 6, 5]);

%%

% major axis
ax = axes('Units'               , 'centimeter', ...
          'Position'            , [1.75, 1.25, 3, 3], ...
          'Color'               , 'none', ...
          'Box'                 , 'off', ...
          'FontSize'            , 10, ...
          'FontName'            , 'Arial', ...
          'LineWidth'           , 0.5, ...
          'TickDir'             , 'out', ...
          'TickLength'          , [0.02, 0.02], ...
          'TickLabelInterpreter', 'tex', ...
          'XLim'                , [3, 12], ...
          'XTick'               , 3:3:12, ...
          'YLim'                , yLim); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')
% panel label
text('String'             , 'E', ...
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
     'XTickLabelRotation'  , 0, ...
     'XLim'                , ax.XLim, ...
     'XTick'               , ax.XTick);
set(get(gca, 'YAxis'), 'Color', 'none')
set(get(gca, 'XLabel'), 'String'     , 'log_{10} total protein count', ...
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
     'YTick'               , ax.YTick);
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YLabel'), 'String'     , 'log_{10} total cost [ATP/s]', ...
                        'Interpreter', 'tex', ...
                        'FontSize'   , 10, ...
                        'FontName'   , 'Arial')

cDat = repmat(colors.DarkBlue , [size(denIsCheapest, 1), 1]) .*      denIsCheapest ...
     + repmat(colors.LightBlue, [size(denIsCheapest, 1), 1]) .* (1 - denIsCheapest);
scatter(ax, log10(totalProtein), log10(totalCost), ...
        'SizeData'       , 7, ...
        'CData'          , cDat, ...
        'XJitter'        , 'randn', ...
        'MarkerFaceColor', 'flat', ...
        'MarkerFaceAlpha', 1, ...
        'MarkerEdgeColor', 'white', ...
        'MarkerEdgeAlpha', 0.1); hold on;

%% upper left legend

% axis 
mat = [20,  0,  0,  0;
        0, 20,  0,  0;
        0,  0,  5,  0;
        0, 18,  0,  3]./20;
axes('Units'   , 'centimeter', ...
     'Position', ax.Position*mat, ...
     'Color'   , 'none', ...
     'Box'     , 'off', ...
     'XLim'    , [0, 1], ...
     'YLim'    , [0, 1]); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')
% label for "dendritic mRNA"
text('String'             , {'Dendr. mRNA'}, ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 10, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'data', ...
     'Position'           , [0.1, 0.9], ...
     'HorizontalAlignment', 'left', ...
     'VerticalAlignment'  , 'middle'); hold on;
% label for "dendritic mRNA"
text('String'             , {'preferred'}, ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 10, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'data', ...
     'Position'           , [0.1, 0.1], ...
     'HorizontalAlignment', 'left', ...
     'VerticalAlignment'  , 'middle'); hold on;

%% lower right legend

% axis 
mat = [20,  0,  0,  0;
        0, 20,  0,  0;
       15,  0,  5,  0;
        0,  1,  0,  3]./20;
axes('Units'   , 'centimeter', ...
     'Position', ax.Position*mat, ...
     'Color'   , 'none', ...
     'Box'     , 'off', ...
     'XLim'    , [0, 1], ...
     'YLim'    , [0, 1]); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')
% label for "dendritic mRNA"
text('String'             , {'Som. mRNA'}, ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 10, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'data', ...
     'Position'           , [0.9, 0.9], ...
     'HorizontalAlignment', 'right', ...
     'VerticalAlignment'  , 'middle'); hold on;
% label for "dendritic mRNA"
text('String'             , {'preferred'}, ...
     'Interpreter'        , 'tex', ...
     'FontSize'           , 10, ...
     'FontName'           , 'Arial', ...
     'Units'              , 'data', ...
     'Position'           , [0.9, 0.1], ...
     'HorizontalAlignment', 'right', ...
     'VerticalAlignment'  , 'middle'); hold on;


%% density 

% axis
axes('Units'               , 'centimeter', ...
     'Position'            , [5, 1.25, 0.5, 3], ...
     'Color'               , 'none', ...
     'Box'                 , 'off', ...
     'FontSize'            , 10, ...
     'FontName'            , 'Arial', ...
     'LineWidth'           , 0.5, ...
     'TickDir'             , 'out', ...
     'TickLength'          , [0.02, 0.02], ...
     'TickLabelInterpreter', 'tex', ...
     'YLim'                , yLim); hold on;
set(get(gca, 'XAxis'), 'Color', 'none')
set(get(gca, 'YAxis'), 'Color', 'none')

% plot the density of total cost per species distribution but only for
% species energetically preferring somatic mRNA localization
distr          = log10(totalCost(~denIsCheapest));
[densY, densX] = ksdensity(distr);
% normalize density to its share of all species
densY          = densY .* (sum(~denIsCheapest)/numel(denIsCheapest));
patch(densY ,densX, ...
      colors.LightBlue, ...
      'FaceAlpha', 0.8, ...
      'EdgeAlpha', 0); hold on;
plot(densY, densX, ...
     'Color', colors.LightBlue, ...
     'LineWidth', 1); hold on;
% plot the density of total cost per species distribution but only for
% species energetically preferring dendritic mRNA localization
distr          = log10(totalCost(denIsCheapest));
[densY, densX] = ksdensity(distr);
% normalize density to its share of all species
densY          = densY .* (sum(denIsCheapest)/numel(denIsCheapest));
patch(densY, densX, ...
      colors.DarkBlue    , ...
      'FaceAlpha', 0.4, ...
      'EdgeAlpha', 0); hold on;
plot(densY, densX, ...
     'Color'    , colors.DarkBlue, ...
     'LineWidth', 1); hold on;
clear densX densY distr
