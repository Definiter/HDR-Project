function [ photo ] = take_photo( object , exp_time)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   Given object and exposure time, this function aims to show the final
%   image without gamma correction
photo = object*exp_time;
photo(photo>1) = 1;
end

