function [  ] = convertLegacyFix( fnameold, fnamenew )
%CONVERTFIXATION Convert fixation format into astef format

dataOld = importfile(fnameold);
    data = [dataOld(:,2) dataOld(:,4:5)];

    
fid=fopen(fnamenew,'w');
for i = 1:size(data,1)
    txt = sprintf('%8d %5d %5d\n',data(i,:));
    fprintf(fid,'%s',txt);
end
fclose(fid);


function TetrisGAMERfix = importfile(filename)

%% Initialize variables.
delimiter = '\t';
    startRow = 3;
    endRow = inf;

%% Format string for each line of text:
formatSpec = '%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Create output variable
TetrisGAMERfix = [dataArray{1:end-1}];
