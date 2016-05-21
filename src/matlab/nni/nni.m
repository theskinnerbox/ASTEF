%% NNI
% Compute Nearest Neighbor Index (NNI)
%
% For more information about the NNI algorithm, see dedicated web page on
% <http://theskinnerbox.net/astef/ theskinnerbox>.
%
% [2015] Francesco Di Nocera, Simon Mastrangelo, Claudio Capobianco

%%
function [ nni, area, d_nn, d_ran ] = nni( fixations, method )
%NNI Compute Nearest Neighbor Index (NNI)
% INPUT
%   fixations: a nx2 matrix with x y coordinates of fixations
%   method: could be 'convexhull' ('ch') or 'smallestrectangle' ('sr')
% OUTPUT
%   nni: 2x1 vector with Nearest Neighbor Index, computed without and with 
%             Donnelly effect adjustment
%   area: area of convex hull or smallest rectangle
%   d_nn: avarage minimum distance between points
%   d_ran: 2x1 vector with theoretical avarage minimum distance, computed 
%              without and with Donnelly effect adjustment

% For C# implementation see from NNIForm.cs (ASTEF1.0beta)

% TODO set a minimum point of 50 fixations per minute

if nargin ~= 2
    error('nni:argChk','Wrong number of input arguments');
end

if size(fixations,2) ~= 2
        error('nni:argChk','fixations has to be a Mx2 matrix');
end

if strcmp(method,'convexhull') || strcmp(method,'ch')
    [perimeter,area] = compute_convexHull(fixations);
elseif strcmp(method,'smallestrectangle') || strcmp(method,'sr')
    [perimeter,area] = compute_smallestRectangle(fixations);
else
        error('nni:argChk','Unknown method');
end

nni = [];
d_ran = [];

N = size(fixations,1);
avgDistance = compute_avarageDistance(fixations);
denom =  0.5 * sqrt(area/N);
nni = [nni; avgDistance/denom];
d_ran = [d_ran; denom];

% Donnelly effect adjustment
denom = denom + (0.0514 + 0.041 / sqrt(N)) * (perimeter / N);
nni = [nni; avgDistance/denom];
d_ran = [d_ran; denom];


d_nn = avgDistance;

    function [perimeter,area] = compute_smallestRectangle(fixations)
        minX = min(fixations(:,1));
        minY = min(fixations(:,2)); 
        maxX = max(fixations(:,1));
        maxY = max(fixations(:,2));
        d1 = (maxX-minX);
        d2 = (maxY-minY);
        area = d1*d2;
        perimeter = 2*(d1+d2);
    end

    function [perimeter,area] = compute_convexHull(fixations)
        fixationsUnique = unique(fixations,'rows');
        %M=[]; % debug
        %S=0;  % debug
        try
            DT = delaunayTriangulation(fixationsUnique);
            [K,area] = convexHull(DT);
            fixationsUniqVertex = fixationsUnique(K,:);
            perimeter = perim(fixationsUniqVertex);
        catch
            area = 0;
            perimeter = 0;
            warning('nni:data','Empty fixations array');
        end
    end


    function d = compute_avarageDistance(fixations)
        
        % iterative method 
        n = size(fixations,1);
        totDistance = 0;
        for i = 1:n
            minDistance = Inf;
            for j = 1:n
                if i ~= j
                    m = norm([fixations(i,:) - fixations(j,:)]);
                    minDistance = min(minDistance,m);
                end
            end
            totDistance = totDistance + minDistance;
        end
        
        d = totDistance / n;
    end



end



