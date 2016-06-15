% Launch this script to get started

%% Check matlab version
disp('Checking MATLAB version...');
if verLessThan('matlab','8.1')
    % -- MATLAB R2012b and earlier --
    error('matlab:version',['You need MATLAB R2013a or later to run ASTEF. Your version is ' version('-release')]);
else
    % -- MATLAB R2013a and later here --
    disp('OK');
end

%% Check working directory
[p,f] = fileparts(mfilename('fullpath'));
if ~isequal(p,pwd) 
    error('astef:workingdir',['Before starting the script ' f ', please change current folder to ' p]);
end

%%
projectPaths;
replay;