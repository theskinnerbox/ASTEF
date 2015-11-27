function [ bg_handle, bg_real_size ] = set_background(ax, bg_handle, ffname )
%SET_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here

axes(ax);
hold(ax,'on');

% read selected image
img = flipdim(imread(ffname),1);

%remember the real size (to correct fixation data)
real_size=size(img);

% set the range of the axes
% The image will be stretched to this.
min_x = 0;
max_x = 800;    % pixel
min_y = 0;
max_y = 600;    % pixel

delete(bg_handle);

%scale image
h = imagesc([min_x max_x], [min_y max_y], img);
% or just plot it
%     h = image(img);


% set the y-axis back to normal.
set(ax,'ydir','normal');

% make image a little transparent
alpha(h,0.6);

%store image
bg_handle = h;
bg_real_size=real_size;

end

