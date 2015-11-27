function resizeAll( Dbig,  Dsmall, figBgColor)
%RESIZEALL Resize astef buttons to specified size [pixel] with background color
% resizeAll( Dbig,  Dsmall, figBgColor) reseize all big buttons to Dbig and
% small buttons to Dsmall, replacing transparence with figBgColor 

H = Dbig;
V = Dbig;

P=mfilename('fullpath');
[pathstr] = fileparts(P);
fileList={'loadbackground','loaddata','savegraph','saveheatmap','savetimeseries','save','cancel'};

for i=1:length(fileList)
    file = fileList{i};
    filename = sprintf('%s/%s.png',pathstr,file);
    IM = imread(filename,'BackgroundColor',figBgColor);
    IM = imresize(IM,[H V]);
    newfilename = sprintf('%s/%s_%dx%d.png',pathstr,file,H,V);
    imwrite(IM,newfilename);
end


H = Dsmall;
V = Dsmall;

P=mfilename('fullpath');
[pathstr] = fileparts(P);
fileList={'fwd','back'};

for i=1:length(fileList)
    file = fileList{i};
    filename = sprintf('%s/%s.png',pathstr,file);
    IM = imread(filename,'BackgroundColor',figBgColor);
    IM = imresize(IM,[H V]);
    newfilename = sprintf('%s/%s_%dx%d.png',pathstr,file,H,V);
    imwrite(IM,newfilename);
end
end