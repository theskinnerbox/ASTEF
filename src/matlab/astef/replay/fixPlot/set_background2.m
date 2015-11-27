function [ bg_handle, bg_real_size ] = set_background2(ax, bg_handle, ffname, hmap )
%SET_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here

axes(ax);
hold(ax,'on');

siz = [800 600];

%% Background
if ~isempty(ffname)
    % read selected image
    bgimg = imread(ffname);
    %remember the real size (to correct fixation data)
    real_size=size(bgimg);
    % resize
    % [X,Y]=meshgrid(1:real_size(2),1:real_size(1));
    % [XI,YI]=meshgrid(1:600,1:800);
    % for i = 1:3
    %    bgimg(:,:,i) = interp2(X,Y,bgimg(:,:,i),XI,YI);
    % end
    bgimg = imresize(bgimg,[siz(2) siz(1)]);
    % add a little transparence
    bgimg = min(bgimg+80,255);
else
    bgimg = uint8(ones([siz(2) siz(1) 3])).*255;
    real_size = [];
end

%% Heatmap
if ~isempty(hmap)
    % compute image
    mat = hmap.mat';
    %S = load('heatmapCM');
    %     if ~isempty(real_size)
    %         cm = S.heatmapCM1;
    %     else
    %         cm = S.heatmapCM2;
    %     end
    cm = colormap('jet');
    cm_length = max(size(cm))-1;
    cmin = 0;
    cmax = max(max(mat));
    sizhm = size(mat);  % should be 800x600!!!
    chmap = uint8(zeros([sizhm 3]));
    colormap_index = zeros(sizhm);
    for i = 1:sizhm(1)
        for j = 1:sizhm(2)
            colormap_index(i,j) = fix((mat(i,j)-cmin)/(cmax-cmin)*cm_length)+1;
            %disp([i j colormap_index(i,j)]);
            chmap(i,j,:) = uint8(cm(colormap_index(i,j),:).*255);
        end
    end
else
    chmap = uint8(zeros([siz(2) siz(1) 3]));
    colormap_index = ones([siz(2) siz(1)]);
    cm_length = 1;
end

%% Combine
img = uint8(zeros([siz(2) siz(1) 3]));
for i = 1:siz(2)
    for j = 1:siz(1)
        if colormap_index(i,j) < 2
            img(i,j,:) = bgimg(i,j,:);
            %img(i,j,:) = bgimg(i,j,:) + fix((colormap_index(i,j)/cm_length)*chmap(i,j,:));
        else
            img(i,j,:) = chmap(i,j,:);
        end
    end
end


img = flipdim(img,1);


delete(bg_handle);

%scale and display image
h = image(img);
% or just plot it
%     h = image(img);


% set the y-axis back to normal.
set(ax,'ydir','normal');

% make image a little transparent
%alpha(h,0.6);

%store image
bg_handle = h;
bg_real_size=real_size;

end

