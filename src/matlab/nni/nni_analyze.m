%% NNI Analyze
% Analyzes Near Ne Index data.
%
% [nniCh, nniSr, nFix] = nni_analyze(fixStats,plotData,outname), fixStats
% is a nx4 matrix [x y duration timestamp], plotData is a boolean to plot data, outname if present
% create a text file with nni analysis. nniCh is a mx2 matrix with nni
% computed for convex hull, first column is simple computation, second
% column is with Donnelly adjustment, m is the number of minutes. nniSr is like the previous but nni is
% computed with smallest rectangle. nFix is an n-array with the number of
% fixations used to compute nni per each minute.
%
%
% See also <matlab:doc('nni') nni>.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function [nniCh, nniSr, nFix] = nni_analyze(fixStats,plotData,outname,showWaitBar,nniMinuteRange)

%% Input parameter check
if nargin < 1
    error('nni:argChk','NNI Analyze: not enough input argument');
elseif nargin == 1
    plotData = false;
    outname = [];
    showWaitBar = true;
    nniMinuteRange = [];
elseif nargin == 2
    outname = [];
    showWaitBar = true;
    nniMinuteRange = [];
elseif nargin == 3
    showWaitBar = true;
    nniMinuteRange = [];
elseif nargin == 4
    nniMinuteRange = [];
end

if isempty(fixStats)
    warning('nni:data','Empty fixation array');
    nniCh = NaN;
    nniSr = NaN;
    nFix = 0;
    return;
end

%% Create fixation timeseries
ts_fixations = timeseries(fixStats(:,1:3),fixStats(:,4)./1000,'name','gazePoints');
ts_fixations.TimeInfo.Units='seconds';
ts_fixations.DataInfo.Units = 'seconds';
% shortcut
time = ts_fixations.Time;

%% Plot input data
if plotData
    f = figure('Name',['EyeTracker data plot: ' outname]);
    
    hold on;
    
    fixStats(:,1) = 1-fixStats(:,1); %flips x-coordinates to match plot axis
    fixStats(:,2) = 1-fixStats(:,2); %flips y-coordinates to match plot axis
    scatter (fixStats(:,1),fixStats(:,2),fixStats(:,3));
   % axis([0 1 0 1]);
    
    xlabel('x');
    ylabel('y');
end

%% NNI pre-computations

% Check data availabilty
t_nni_window = 60; % [s] time over compute nni
if time(end) < t_nni_window
    warning('nni:dataSamples',['Few time to compute nni (get ' num2str(time(end)) 's, need at least ' num2str(t_nni_window) 's). Computing anyway.']);
end

%Separate data according to time step
t_0 = 0; % you can consider also to use time(1)
t_set_step = 60; % [s] time between points on the plot
% n_points is the number of points in our plot, that is the number of minutes
% n_points = ceil((time(end)-t_0)./t_plot_step); % ceil: consider also last incomplete minute
n_points = round((time(end)-t_0)./t_set_step); % floor: dismiss last incomplete set
if showWaitBar
    hwb = waitbar(0,'Computing nni, please wait...');
end

% Consider only the minute range in input, if any
nniRange = nniMinuteRange;
if isempty(nniRange)
    % if input range is empty, analyze the whole timeseries
    nniRange = 1:n_points;
% elseif nniRange(1) > n_points
%     % if input range starts over the end of actual data, do nothing
%     nniRange = [];
% elseif nniRange(end) > n_points
%     % if input range ends over the end of actual data, truncate range
%     nniRange = nniRange(1):n_points;
end

% preallocate for speed
nniRangeLen = max(size(nniRange));
nniCh = zeros(nniRangeLen,2);
nniSr = zeros(nniRangeLen,2);
nFix = zeros(nniRangeLen,1);
tsRange(1:nniRangeLen) = timeseries();

%% Compute NNI
for idx = nniRange
    t_start = t_0 + (idx-1)*t_set_step;
    t_stop =  t_0 + (idx-1)*t_set_step + t_set_step;
    tsRange(idx) = getsampleusingtime(ts_fixations, t_start, t_stop);
    n_fix = size(tsRange(idx).Data,1);
    strAlert = [];
    if n_fix < 50
        strAlert = ' *';
    elseif n_fix < 40
        strAlert = ' **';
    end
    disp(['eye minute ' num2str(idx) ', ' num2str(n_fix) ' fixations.' strAlert]);
    try
        offIdx = idx-nniRange(1)+1;
        nniCh(offIdx,:) = nni(tsRange(idx).Data(:,1:2),'ch');
        nniSr(offIdx,:) = nni(tsRange(idx).Data(:,1:2),'sr');
        nFix(offIdx) = n_fix;
    catch
        warning('nni:data','Not enough data to compute nni');
    end
    if showWaitBar
        pause(0.2);
        waitbar(idx / n_points);
    end
end
if showWaitBar
    close(hwb);
end


%% Plot statistics
if plotData
    if size(nniCh,1) < 2
        warning('nni:dataSamples','Not enough data to plot.');
    else
        f2 = figure('Name',['NNI, convex hull: ' outname]);
        plot(nniCh);
        xlabel('minute ID');
        ylabel('nni');
        ylim([0.6 1.6]);
        legend('base','Donnelly');
        
%         f3 = figure('Name',['NNI, smallest rectangle: ' outname]);
%         plot(nniSr);
%         xlabel('minute ID');
%         ylabel('nni');
%         ylim([0.6 1.6]);
%         legend('base','Donnelly');
    end
end

%% Write data to file
% Minute ID | Starting time (date and time format) | NNI convex hull base | NNI ch Donnelly | NNI smallest rectangle base | NNI sr Donnelly |
if ~isempty(outname)
    meanEpochs = 5;
    nniChD = nniCh(:,2);
    nniMean = zeros(size(nniChD));
    nniStd = zeros(size(nniChD));
    [nniMean,nniStd] = computeMeanEpochs(nniChD,meanEpochs);
    
    devData = zeros(size(nniChD));
    for i=meanEpochs+1:length(nniChD)
       devData(i) = computeNNIDev(nniChD(1:i),nniMean,nniStd);
    end
    
    txt{1} = 'Minute ID | NNI Ch D | Dev';
    for i=1:length(nniChD)
        txt{i+1} = [num2str(i) ' ' num2str(nniChD(i)) ' ' num2str(devData(i))]; %#ok<AGROW>
    end
    
    fname = ['output/' outname '-nni-dev.txt'];
    fid = fopen(fname, 'w');
    for row=1:size(txt,2)
        fprintf(fid, '%s\n', txt{row});
    end
    fclose(fid);
    
% Old Style
%     filename = ['output/' outname '-eye-analysis.txt'];
%     fileID = fopen(filename,'w');
%     txt = 'Minute ID | Starting time [s] | NNI ch base | NNI ch Donnelly | NNI sr base | NNI sr Donnelly |';
%     fprintf(fileID,'%s\n',txt);
%     for i = 1:size(tsRange,2)
%         ts = tsRange(i);
%         sepChar = '    ';
%         txt = [num2str(i) sepChar num2str(ts(1).Time(1)) sepChar ...
%             num2str(nniCh(i,1)) sepChar num2str(nniCh(i,2))  sepChar ...
%             num2str(nniSr(i,1)) sepChar num2str(nniSr(i,2))];
%         fprintf(fileID,'%s\n',txt);
%     end
%     fclose(fileID);
    
end