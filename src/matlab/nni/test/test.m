addpath('../');

TESTS = load('NNI_TEST');

T_EX0 = nni(TESTS.EX0,'ch');
if isequal(TESTS.RV_EX,T_EX0)
    disp('EX test OK');
else
    disp('EX test FAILED');
end

T_RND = nni(TESTS.RND,'ch');
if isequal(TESTS.RV_RND,T_RND)
    disp('RND test OK');
else
    disp('RND test FAILED');
end

T_CLST = nni(TESTS.CLST,'ch');
if isequal(TESTS.RV_CLST,T_CLST)
    disp('CLST test OK');
else
    disp('CLST test FAILED');
end