%% Replay
% With this tool you can visualize and analyze fixations and NNI.
%
% Fixation data are read from a text file; optionally a background image
% could be loaded to provide a visual reference for fixations. Only
% fixations of the current minute ID are visualized.
%
% In a dedicated plot is represented the NNI values of the whole
% registration, focusing on the current minute ID.
%
% Fixation data could be saved as a heatmap. NNI data could be
% saved as text file or graph.
%
% See also <matlab:doc('nni') NNI>,
% <matlab:doc('plotFix') plotFix>,
% <matlab:doc('plotHeatmap') plotHeatmap>, 
% <matlab:doc('importFixation') importFixation>.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%% Initialize graphic interface
function varargout = replay(varargin)
% REPLAY MATLAB code for replay.fig
%      REPLAY, by itself, creates a new REPLAY or raises the existing
%      singleton*.
%
%      H = REPLAY returns the handle to a new REPLAY or the handle to
%      the existing singleton*.
%
%      REPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REPLAY.M with the given input arguments.
%
%      REPLAY('Property','Value',...) creates a new REPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before replay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to replay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help replay

% Last Modified by GUIDE v2.5 30-Mar-2016 12:21:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @replay_OpeningFcn, ...
    'gui_OutputFcn',  @replay_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before replay is made visible.
function replay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to replay (see VARARGIN)

% Choose default command line output for replay
handles.output = hObject;

[~, foldName] = fileparts(pwd);

projRoot = './';
if strcmp(foldName,'replay')
    projRoot = '../';
end
addpath(projRoot);
projectPaths(projRoot);

%background color
set(gcf,'Color',style.background_color);

%fixation data
if ~isfield(handles,'fixationData')
    handles.fixationData = [];
end;

uservar = userVariables();
handles.minFixPerMin = uservar.minimumFixationPerMinute;

x_lim = get(handles.dataAx,'xlim');
y_lim = get(handles.dataAx,'ylim');
handles.fixplot_size = [x_lim(2) y_lim(2)];
handles.fixdata_handle = [];

handles.bg_fname = [];
handles.bg_handle = [];

handles.timeStart = 0;
handles.timeStop = 0;
handles.timeMinute = -1;

handles = initFigure(handles);


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes replay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = replay_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function handles = initFigure(handles)
%tooltip = '<html>HTML-aware<br><b>tooltips</b><br><i>supported';
% labelTop= '<HTML><center><FONT color="red">Hello</Font> <b>world</b>';
% labelBot=['<div style="font-family:impact;color:green"><i>What a</i>'...
%           ' <Font color="blue" face="Comic Sans MS">nice day!'];
% set(handles.saveFixButton, 'tooltip',tooltip, 'string',[labelTop '<br>' labelBot]);
% jButton = java(findjobj(handles.saveFixButton));

% loadColor = [0 0 1];
% saveColor = [1 0 0];
bgColor = get(gcf,'Color');
handles.saveFixButton = button.background(handles.saveFixButton, button.saveFix_image);
set(handles.saveFixButton,'String','');

handles.loadBgButton = button.background(handles.loadBgButton, button.loadBackground_image);
set(handles.loadBgButton,'String','');

handles.loadFixButton = button.background(handles.loadFixButton, button.loadFix_image);
set(handles.loadFixButton,'String','');

handles.saveTSButton = button.background(handles.saveTSButton, button.saveTS_image);
set(handles.saveTSButton,'String','');

handles.saveNNIButton = button.background(handles.saveNNIButton, button.saveNNI_image);
set(handles.saveNNIButton,'String','');

handles.backButton = button.background(handles.backButton, button.back_image);
set(handles.backButton,'String','');

handles.fwdButton = button.background(handles.fwdButton, button.fwd_image);
set(handles.fwdButton,'String','');

% back/fwd minute
set(handles.minuteIdxText,'String','');
set(handles.minuteIdxText,'BackgroundColor',bgColor);


% Panel
set(handles.infoPanel,'BackgroundColor',bgColor);
handles.astefUrl = 'http://www.astef.info/';
label= '<HTML><a href="http://www.astef.info/">http://www.astef.info/</a>';
handles.astefButton = button.borderless(handles.astefButton);
set(handles.astefButton, 'tooltip',handles.astefUrl,'string',label);

%% Application menu functions

function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


%% Save NNI data as timeseries
% Save data as timeseries in a text file specified by user.

% --- Executes on button press in saveTSButton.
function saveTSButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveTSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile('*.txt','Save data as');
if isequal(filename,0) || isequal(pathname,0)
    %disp('User selected Cancel')
else
    saveTimeseries(handles.nniCh,fullfile(pathname,filename));
end

%% Save NNI data as a graph
% Save graph as png with filename specified by user.

% --- Executes on button press in saveNNIButton.
function saveNNIButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveNNIButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile('*.png','Save graph as');
if isequal(filename,0) || isequal(pathname,0)
    %disp('User selected Cancel')
else
    disp(['User selected ',fullfile(pathname,filename)])
    f = figure;
    ax = axes;
    refreshNNIPlot(handles,ax,0);
    xlabel('minutes');
    ylabel('NNI');
    title('NNI plot');
    print(f,'-dpng',fullfile(pathname,filename));
    close(f);
end

%% Save fixation data as heatmap

% --- Executes on button press in saveFixButton.
function saveFixButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveFixButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','bg_fname',handles.bg_fname);
assignin('base','fixationData',handles.fixationData);
savePreview;


%% Load fixation data

% --- Executes on button press in loadFixButton.
function loadFixButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadFixButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile(...
    {'*.txt; *.TXT', 'Fixation data (*.txt)';
    '*.*',  'All Files (*.*)'}, ...
    'Select fixation data');

if filename ~= 0
    ffname = fullfile(pathname,filename);
    try
    [fixationData,scrsize] = importFixation(ffname);
    catch e
        msgbox({'Wrong file format for fixation data file.' 'See usermanual.txt for details.'}, 'Import file','error');
        error('astef:importFix','Wrong file format');
    end
    fixsize = handles.fixplot_size;
    pos=fixationData.Data;
    pos(:,1)=pos(:,1)./scrsize(1).*fixsize(1);
    pos(:,2)=pos(:,2)./scrsize(2).*fixsize(2);
    fixationData.Data=pos;
    
    handles = computeNNI(handles,fixationData);
    handles.fixationData = fixationData;
    maxMinutes = ceil(handles.fixationData.Time(end)/60);
    handles.timeMinute = 1;
    handles.timeMinuteMax = maxMinutes;
    handles = refreshFigure(handles);
    
    guidata(hObject,handles);
end

%% Load background
% Background image is resized to the dimension of axis

% --- Executes on button press in loadBgButton.
function loadBgButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadBgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pick from file
% ask to user
[filename, pathname] = uigetfile(...
    {'*.jpg; *.JPG; *.jpeg; *.JPEG; *.png; *.PNG; *.bmp; *.BMP', 'Pictures (*.jpg; *.jpeg; *.png; *.bmp)';
    '*.*',  'All Files (*.*)'}, ...
    'Select background image');

if filename ~= 0
    ffname = fullfile(pathname,filename);
    delete(handles.fixdata_handle);
    handles.fixdata_handle = [];
    [handles.bg_handle,handles.bg_real_size] = set_background(handles.dataAx, handles.bg_handle, ffname );
    handles=refreshFigure(handles);
    handles.bg_fname = ffname;
    guidata(hObject, handles);
end

%% Info box
% Visualize info about ASTEF. Open the ASTEF web page if clicked.

% --- Executes on button press in astefButton.
function astefButton_Callback(hObject, eventdata, handles)
% hObject    handle to astefButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.astefUrl;
web(handles.astefUrl,'-browser');


%% Navigate minute IDs

%%
% Move back

% --- Executes on button press in backButton.
function backButton_Callback(hObject, eventdata, handles)
% hObject    handle to backButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.fixationData)
    if handles.timeMinute > 1
        val = handles.timeMinute - 1;
        handles.timeMinute = val;
        handles = refreshFigure(handles);
        guidata(hObject, handles);
    end
end

%%
% Move forward

% --- Executes on button press in fwdButton.
function fwdButton_Callback(hObject, eventdata, handles)
% hObject    handle to fwdButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.fixationData)
    if handles.timeMinute < handles.timeMinuteMax
        val = handles.timeMinute + 1;
        handles.timeMinute = val;
        handles = refreshFigure(handles);
        guidata(hObject, handles);
    end
end

%% Refresh plots

%%
% Refresh fixplot
function handles = refreshFixPlot(handles)
if ~isempty(handles.fixationData)
    handles.fixdata_handle = plotFix(handles.dataAx, handles.fixdata_handle,...
        handles.fixationData,...
        handles.timeStart, handles.timeStop );
end

%%
% Refresh nniplot
function handles = refreshNNIPlot(handles,ax,m)
if ~isempty(handles.fixationData)
    if m > 0
        fixOK = handles.nniNumber(m) > handles.minFixPerMin;
        plotNNI(ax,handles.nniCh,m,fixOK);
    else
        plotNNI(ax,handles.nniCh);
    end
end

function handles = computeNNI(handles,fixationData)
if ~isempty(fixationData)
    time = fixationData.Time.*1000;
    data = fixationData.Data;
    duration = zeros(size(time));
    fixStats = [data duration time];
    [nniCh,~,nniNumber] = nni_analyze(fixStats);
    handles.nniCh = nniCh(:,2); % use Donelly (on the second column)
    handles.nniNumber = nniNumber; % number of fixation per minute
end

%%
% Refresh minute ID bar
function handles = refreshMinuteRange(handles)
val = handles.timeMinute;
handles.timeStart = (val-1)*60;
handles.timeStop = (val)*60;
set(handles.minuteIdxText,'String',['min ' num2str(val)]);

%%
% Refresh all figures at once
function handles = refreshFigure(handles)
handles = refreshMinuteRange(handles);
handles = refreshFixPlot(handles);
handles = refreshNNIPlot(handles,handles.nniAx,handles.timeMinute);
