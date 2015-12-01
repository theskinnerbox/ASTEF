% Launch this script to get started

%%
disp('Checking MATLAB version...');
if verLessThan('matlab','8.1')
    % -- MATLAB R2012b and earlier --
    error('matlab:version',['You need MATLAB R2013a or later to run ASTEF. Your version is ' version('-release')]);
else
    % -- MATLAB R2013a and later here --
    disp('OK');
end

%%
projectPaths;
replay;