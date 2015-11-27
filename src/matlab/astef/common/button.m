%% Button
% This package contains information about how to plot buttons (i.e. size
% and background image), and methods to plot them.
%
% Buttons can be represented borderless, with only the background image.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
classdef button
    
    %% Background images
    % File name convention: filename_<width>x<height>.png
    
    properties (Constant)
        loadBackground_image = 'loadbackground_90x90.png';
        loadFix_image = 'loaddata_90x90.png';
        saveFix_image = 'saveheatmap_90x90.png';
        saveTS_image = 'savetimeseries_90x90.png';
        saveNNI_image = 'savegraph_90x90.png';
        save_image = 'save_90x90.png';
        cancel_image = 'cancel_90x90.png';
        rec_image = 'rec_90x90.png';
        back_image = 'back_50x50.png';
        fwd_image = 'fwd_50x50.png';
    end
    
    methods (Static)
        
        %% Plot a borderless button
        function h = borderless(h)
            figBgColor = get(gcf,'Color');
            pos = get(h,'Position');
            CData = ones(pos(4),pos(3),3);
            for i = 1:size(CData,1)
                for j = 1:size(CData,2)
                    CData(i,j,:) = figBgColor;
                end
            end
            set(h,'CDATA',CData);
        end
        
        %% Plot a rounded button
        % Background is the colour parameter (flat background).
        
        function h = rounded(h,col)
            figBgColor = get(gcf,'Color');
            pos = get(h,'Position');
            CData = ones(pos(3),pos(4),3);
            r = size(CData,1)/2;
            for i = 1:size(CData,1)
                for j = 1:size(CData,2)
                    x = i-r;
                    y = j-r;
                    %         r1=r;
                    %         r = r-1;
                    if x<sqrt(r*r-y*y) && x>-sqrt(r*r-y*y)
                        CData(i,j,:) = col;
                        %         end
                        %         if x<sqrt(r1*r1-y*y) && x>sqrt(r1*r1-y*y)
                        %             CData(i,j,:) = [0 0 0];
                    else
                        CData(i,j,:) = figBgColor;
                    end
                end
            end
            set(h,'CDATA',CData);
        end
        

        %% Plot a button with background image
        % Image has to be of the same size of the button
        function h = background(h,img)
            figBgColor = get(gcf,'Color');
            CData = imread(img,'BackgroundColor',figBgColor);
            set(h,'CDATA',CData);
        end

                % cannot use imresize because it's from image processing
                % toolbox. Precompute images at the right resolution
%         function h = background60(h,img)
%             figBgColor = get(gcf,'Color');
%             CData = imread(img,'BackgroundColor',figBgColor);
%             CData = imresize(CData, [60 60]);
%             set(h,'CDATA',CData);
%         end
        
        
    end
end

