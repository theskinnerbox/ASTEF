function [ ret ] = closeto( f1,f2,thr )
%CLOSETO Summary of this function goes here
%   Detailed explanation goes here

ret = all(abs(f1-f2) < thr);

end

