function perimeter = perim(V)

if (ndims(V) ~= 2) || (size(V,1) < 3) || (size(V,2) ~= 2)
    error('perim:argChk','Input has to be a mx2 matrix with 2D vertex');
end

% order the vertex
V = [V;V(1,:)];
[Vx,Vy] = poly2cw(V(:,1),V(:,2));

perimeter = 0;
n = size(V,1);
% last point is equal to the first
for i = 1:(n-1)
    perimeter = perimeter + norm([Vx(i) Vy(i)]-[Vx(i+1) Vy(i+1)]);
end
%perimeter = perimeter + norm([Vx(end) Vy(end)] - [Vx(1) Vy(1)]);