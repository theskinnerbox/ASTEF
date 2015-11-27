%% Plot NNI
% Plot NNI data, pointing out a given minute ID (focus point).
%
% When specifing a focus point, the point is coloured in green if the
% number of fixations are enough to compute NNI correctly (i.e. fixations >
% 50); point is red otherwise.
%
% See also <matlab:doc('nni') NNI>.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco



%%
function plotNNI(ax, nniData, focusPoint, fixOK, nniMean, nniDev, nniMeanEpochs)
%PLOTNNI Plot NNI data
% plotNNI(ax, nniData)
% plotNNI(ax, nniData, focusPoint)
% plotNNI(ax, nniData, focusPoint, fixOK)
% plotNNI(ax, nniData, focusPoint, fixOK, x_lim)
%   f = plotNNI(ax, nniData,focusPoint, fixOK ), nniData is an array with nni data, one value
%   per minute. focusfixOK is an logic array with the same length of nniData, that
%   is true if the relative data is computed on a sufficient number of data. fixations.
%   f is the figure handler
% shortcut
nElems = length(nniData);

%% Input argument check
if nargin < 2
    error('nniPlot:argChk','not enough input argument');
elseif min(size(nniData)) > 1
    error('nniPlot:argChk','nniData has to be a vector');
end

if nargin < 3
    focusPoint = [];
elseif focusPoint > nElems
    error('nniPlot:argChk','focusPoint exceeds nniData dimension');
end

if nargin < 4
    fixOK = [];
elseif max(size(fixOK)) == 1
    % if fixOK is scalar, build up a vector with all zeros and fixOK on the
    % position of focusPoint
    tmp = fixOK;
    fixOK = zeros(size(nniData));
    fixOK(focusPoint) = tmp;
elseif size(fixOK) ~= size(nniData)
    error('nniPlot:argChk','fixOK has to have the same size of nniData');
end

if nargin < 5
    nniMean = [];
    nniDev = [];
    nniMeanEpochs = 0;
end


%% Plot Data
hold(ax,'off');

% show always a multiple of 5 minutes on x axes
%nMinutes = ceil(nElems/5)*5;

nMinutes = max(nElems,2);

xData = 1:nElems;
xplot=linspace(0,nElems);
if nElems > 1
    % smooth curve
    fitResult=spline(xData,nniData);
    yplot=ppval(fitResult,xplot);
    plot(ax,xplot,yplot);
else
    plot(ax,0,0); % clear ax
end

% plot(ax,X,nniData);
xlim(ax,[1 nMinutes]);

hold(ax,'on');
grid(ax,'on');
%% Plot focus point

% children = get(ax,'children');
% if length(children) > 1
%     delete(children(1));
% end

% set last point color according to fixation data.
if ~isempty(focusPoint) && ~isempty(nniData)
    if ~isempty(fixOK)
        if fixOK(focusPoint)
            color = 'g'; % OK, green
        else
            color = 'r'; % not enough points, red
        end
    else
        color = [0.4 0.4 0.4]; % unknown, gray
    end
    S = style;
    stem(ax,xData(focusPoint),nniData(focusPoint),...
        'LineStyle','--',...
        'Color',S.nniLineColor,...
        'LineWidth',S.nniLineWidth,...
        'MarkerFaceColor',color,'MarkerEdgeColor',S.nniMarkerEdgeColor,...
        'MarkerSize',S.nniMarkerSize)
end

%% Draws the symbol of the deviation from the mean
if ~isempty(nniMean) && ~isempty(nniData)
    % draw symbols
    symStart = max(nniMeanEpochs,1);
    for i = symStart:length(nniData)
        dev = nniDev(i);
        str = [];
        if dev == 2
            %% FIXME the following is considered a wrong TeX text string
            str = ['\wedge' '\wedge'];
        elseif dev == 1
            str = '\wedge';
        elseif dev == -2
            str = 'vv';
        elseif dev == -1
            str = 'v';
        end
        if ~isempty(str)
            % draw symbol on the figure
            text(xData(i),nniData(i),str,'FontSize',18, 'Parent', ax);
        end
    end
end

end

