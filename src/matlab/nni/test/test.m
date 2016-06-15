%% This script test that nni compute correct values for known distribution 

addpath('../');

thr = 0.001;

% NNI_TEST contains distributions and expected nni values
TESTS = load('NNI_TEST');

% exagonal (regular) distributions
T_EX0 = nni(TESTS.EX0,'ch');
if closeto(TESTS.RV_EX,T_EX0,thr)
    disp('EX test OK');
else
    disp('EX test FAILED');
end

% random distribution
T_RND = nni(TESTS.RND,'ch');
if closeto(TESTS.RV_RND,T_RND,thr)
    disp('RND test OK');
else
    disp('RND test FAILED');
end

% clustered distribution
T_CLST = nni(TESTS.CLST,'ch');
if closeto(TESTS.RV_CLST,T_CLST,thr)
    disp('CLST test OK');
else
    disp('CLST test FAILED');
end

    