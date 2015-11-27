%% Plot Heatmap
% Plot fixation data as a heatmap.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function [ h ] = plotHeatmap(ax,x,y,mat)

[X,Y]=meshgrid(x,y);
X = X';
Y = Y';
h = mesh(ax,X,Y,mat);
%shading interp;

end

