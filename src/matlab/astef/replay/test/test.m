addpath('../');

inputFilesRelPath = '../../../../../demo_data/test/';
fname = 'source-ok.txt';

importFixation([inputFilesRelPath fname]);

fnames = {'source-err-1.txt'...
    'source-err-1.1.txt'...
    'source-err-1.2.txt'...
    'source-err-2.txt'...
    'source-err-3.txt'...
    'source-err-4.txt'...
    'source-err-5.txt'};

for f = fnames
    fullname = [inputFilesRelPath f{1}];
    if exist(fullname,'file')
        try
            importFixation(fullname);
            disp([f{1} ': test FAILED']);
        catch
            disp([f{1} ': test PASSED']);
        end
    else
        disp([f{1} ': test file does not exists']);
    end
end