%% Plot Fix
% Plot fixations using dots or heatmap.
%
% Fixation data has to be provided as a timeseries; start time and stop
% time can be specified to limit the number of points to be plotted.
%
% See also <matlab:doc('plotHeatmap') plotHeatmap>.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function [ plotHandle, hmap ] = plotFix(ax, plotHandle, fixationData, timeStart, timeStop, plotMode )
% plotFix plot fixation data
% [ plotHandle ] = plotFix(ax, plotHandle, fixationData, timeStart, timeStop )
% [ plotHandle, hmap ] = plotFix(ax, plotHandle, fixationData, timeStart, timeStop )
% Plot fixation on axis ax; before plotting, delete the previous graphic
% object contained in plotHandle. Fixations are stored in fixationData as a
% timeseries, and data to be plotted could be limited using timeStart and
% timeStop [seconds]. plotMode could be: 'Points' (default) or 'Heatmap'.
% If mode is 'heatmap', data is not actually plotted but hmap output variable
% contains a struct with the heatmap matrix and x, y values.

%%
% Check input parameters
if ~exist('plotMode','var')
    plotMode = 'Points';
end

hmap = [];

if ~isempty(fixationData)
    axes(ax);
    hold on;
    
    %%
    % Get data interval to be plotted
    ts1 = getsampleusingtime(fixationData, timeStart, timeStop);
    data = ts1.Data;
    
    if ~isempty(data)
        S = style;
        %%
        % delete previous graphic object
        delete(plotHandle);
        
        %% Plot fixations as points
        if strcmpi(plotMode,'POINTS')
            y_lim = ylim;
            ymax = y_lim(2);
            y = ymax-data(:,2);
            h = plot(ax,data(:,1),y,...
                'MarkerFaceColor',S.MarkerFaceColor,...
                'MarkerEdgeColor',S.MarkerEdgeColor,...
                'Color',S.LineColor,...
                'LineWidth',S.LineWidth,...
                'MarkerSize',S.MarkerSize,...
                'Marker','o');
            %% Plot fixations as heatmap
        elseif strcmpi(plotMode,'HEATMAP')
            [mat,x,y] = heatmap(data);
            mat = mat./max(max(mat));
            h = 0;%plotHeatmap(ax,x,y,mat);
            hmap.mat = mat;
            hmap.x = x;
            hmap.y = y;
        end
        plotHandle = h;
    end
end

%% Heatmap computation
% Each fixation generate a 2D gaussian distribution. The heatmap is the sum
% of these gaussians.
function [mat,x,y] = heatmap(data)
x = 1:800;
y = 1:600;
mat = zeros([length(x) length(y)]);

h = waitbar(0,'Computing heatmap, please wait...');
steps = size(data,1);
for i = 1:steps
    mat = mat + gauss2d(mat,20,data(i,:));
    waitbar(i / steps)
end
close(h)

%%
% Compute two-dimensinal gaussian distribution
function mat = gauss2d(mat, sigma, center)
gsize = size(mat);
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));
mat = gaussC(R,C, sigma, center);

function val = gaussC(x, y, sigma, center)
xc = center(1);
yc = center(2);
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
val       = (exp(-exponent));

