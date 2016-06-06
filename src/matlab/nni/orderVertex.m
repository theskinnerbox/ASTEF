function out = orderVertex( M )
%ORDERVERTEX Summary of this function goes here
%   Detailed explanation goes here

if (ndims(M) ~= 2) || (size(M,1) < 3) || (size(M,2) ~= 2)
    error('perim:argChk','Input has to be a mx2 matrix with 2D vertex');
end

% centroid 
C = mean(M,1);

Mout = M(1,:);
M(1,:) = [];
while ~isempty(M)
    P0 = Mout(end,:)-C;
    ang = zeros(size(M,1),1);
    for i=1:size(M,1)
        P1 = M(i,:)-C;
        ang(i) = rad2deg(atan2((det([P1;P0])),dot(P1,P0)));
    end
    ang(ang<0) = ang(ang<0)+360;
    [~,idx] = min(ang);
    Mout = [Mout;M(idx(1),:)];
    M(idx(1),:) = [];
end
out = Mout;
end

