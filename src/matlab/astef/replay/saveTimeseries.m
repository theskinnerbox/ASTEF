%% Save timeseries
% Save NNI data as timeseries.
%
% File has the following format:
% 
% Minute ID | NNI ch Donnelly
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function [ ] = saveTimeseries( nniData, outname )
%SAVETIMESERIES Save NNI data as timeseries
%   Detailed explanation goes here

% Write data to file
% Minute ID | NNI ch Donnelly
if ~isempty(outname)
    filename = outname;
    fileID = fopen(filename,'w');
    txt = 'Minute ID | NNI convex hull Donnelly';
    fprintf(fileID,'%s\n',txt);
    for i = 1:length(nniData)
        txt = [num2str(i) ' ' num2str(nniData(i))];
        fprintf(fileID,'%s\n',txt);
    end
    fclose(fileID);
end

end

