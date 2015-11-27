%% Style
% This package contains information about user interface appearance.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
classdef style

    properties (Constant)
        %% Whole figure
        background_color = [0.95 0.95 0.95];
        
        %% Scanpath
        LineColor = [0 0 0];
        LineWidth = 0.5;
        MarkerFaceColor = [1 0 0];
        MarkerEdgeColor = [0 0 0];
        MarkerSize = 8;
        
        %% NNI
        nniLineColor = [0 0 1];
        nniLineWidth = 0.5;
        % nniMarkerFaceColor is dynamic
        nniMarkerEdgeColor = [0 0 0];
        nniMarkerSize = 8;
    end
    
    
end

