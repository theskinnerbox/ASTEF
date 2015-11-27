function projectPaths(projectRoot)
%% projectPaths
% add paths and create folders used in current project

if nargin == 0
    projectRoot = './';
end

nniPath = [projectRoot './nni/'];
astefPath = [projectRoot './astef/'];

addpath(genpath(projectRoot));
addpath(genpath(astefPath));
addpath(nniPath);
end