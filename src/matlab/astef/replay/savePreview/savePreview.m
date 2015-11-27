%% Save preview
% Preview of fixation plot before saving.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function varargout = savePreview(varargin)
% SAVEPREVIEW MATLAB code for savePreview.fig
%      SAVEPREVIEW, by itself, creates a new SAVEPREVIEW or raises the existing
%      singleton*.
%
%      H = SAVEPREVIEW returns the handle to a new SAVEPREVIEW or the handle to
%      the existing singleton*.
%
%      SAVEPREVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVEPREVIEW.M with the given input arguments.
%
%      SAVEPREVIEW('Property','Value',...) creates a new SAVEPREVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before savePreview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to savePreview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help savePreview

% Last Modified by GUIDE v2.5 10-Dec-2013 14:12:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @savePreview_OpeningFcn, ...
                   'gui_OutputFcn',  @savePreview_OutputFcn, ...
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

%% Initialize graphic interface

% --- Executes just before savePreview is made visible.
function savePreview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to savePreview (see VARARGIN)

% Choose default command line output for savePreview
handles.output = hObject;

set(gcf,'Color',style.background_color);


handles.saveButton = button.background(handles.saveButton, button.save_image);
set(handles.saveButton,'String','');

handles.cancelButton = button.background(handles.cancelButton, button.cancel_image);
set(handles.cancelButton,'String','');


% compute heatmap
handles.fixdata_handle = [];
handles.hmap = [];
handles.plotStyle = 'Heatmap';
handles.fixationData = evalin('base','fixationData');
[handles.fixdata_handle,handles.hmap] = plotFix(handles.dataAx, handles.fixdata_handle,...
    handles.fixationData,...
    0, Inf, handles.plotStyle);

% load background file name
handles.bg_fname = evalin('base','bg_fname');
handles.bg_handle = [];

% plot background and heatmap
[handles.bg_handle,handles.bg_real_size] = refreshPlot(handles,handles.dataAx,handles.bg_handle);




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes savePreview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = savePreview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Save graph

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile('*.png','Save graph as');
if isequal(filename,0) || isequal(pathname,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ',fullfile(pathname,filename)]);
    f = figure;
    ax = axes;
    
    refreshPlot(handles,ax,[]);
    set(ax,'Projection','orthographic');
    set(ax,'View',[0 90]);
    xlim([0 800]);
    ylim([0 600]);
    print(f,'-dpng','-r72',fullfile(pathname,filename));
    close(f);
end


%handles = refreshPlot(handles,handles.dataAx, handles.fixdata_handle);

% Update handles structure
%guidata(hObject, handles);

%% Refresh plot
function [bg_handle,bg_real_size] = refreshPlot(handles,ax,bg_handle)
if ~isempty(handles.hmap)
    [bg_handle,bg_real_size] = set_background2(ax, bg_handle, handles.bg_fname, handles.hmap );
end


%handles = refreshPlot(handles,handles.dataAx, handles.fixdata_handle);
% Update handles structure
%guidata(hObject, handles);

%% Cancel button

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
