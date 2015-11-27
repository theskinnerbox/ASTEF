%% Import fixations
%
% Function for importing data from a text file. Data is stored as a
% timeseries.
%
% File has the following format:
% 
%  
%  SCREEN_WIDTH SCREEN_HEIGHT
%  HEADER
%  DATA
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function [fixationTS,screensiz] = importFixation(filename)
%% 
% Initialize variables.
startRow = 3;
endRow = inf;

%% Format string for each line of text
% 
% * column1: double (%f)
% * column2: double (%f)
% * column3: double (%f)
%
% For more information, see the TEXTSCAN documentation.
formatSpec = '%8f%6f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', {' ','\t'}, 'WhiteSpace', '', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
%% Close the text file.
fclose(fileID);

%% Create timeseries
time = dataArray{:, 1}./1000;

% ts_id = timeseries(dataArray{:, 1},time,'name','ID');
% ts_id.TimeInfo.Units='milliseconds';

% ts_duration = timeseries(dataArray{:, 3},time,'name','FixDuration');
% ts_duration.TimeInfo.Units='milliseconds';
% ts_duration.DataInfo.Units = 'milliseconds';

ts_pos = timeseries([dataArray{:, 2} dataArray{:,3}],time,'name','FixCenterPos');
ts_pos.TimeInfo.Units='seconds';
ts_pos.DataInfo.Units = 'pixels';

fixationTS = ts_pos;


fileID = fopen(filename,'r');
screensiz = fscanf(fileID,'%d %d');
fclose(fileID);

end


