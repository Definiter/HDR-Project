function [ I_hdr ] = recover_hdr( photo, mask )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
I_hdr = photo./mask;
end

