function [ mask ] = average_pooling( mask, stride )
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here
kerl = ones(stride)/stride^2;

for c = 1:3
    mask(:,:,c) = conv2(mask(:,:,c),kerl,'same');
end
[m,n,~] = size(mask);
mask = mask(1:stride:end,1:stride:end,:);
mask = imresize(mask,[m,n],'nearest');

end

