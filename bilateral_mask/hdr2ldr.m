function [ Itonemapped ] = hdr2ldr( I_hdr )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
% normalize image
I = (I_hdr-min(I_hdr(:))) ./ (max(I_hdr(:))-min(I_hdr(:)));

% set gamma
gamma = 1/3;% Complete

% compute intensity channel by averaging the three color channels
Iintensity = (20*I(:,:,1)+40*I(:,:,2)+I(:,:,3)) ./61;
% chrominance channels 
Ichrominance = I./Iintensity; % Complete

% compute the log10 intensity: 
L = log10(Iintensity);% Complete

% Filter that with a bilateral filter: B = bf(L) xxx
averageFilterRadius = 5; 
sigma               = 3;
sigmaIntensity      = 2;
B = bilateral(L, averageFilterRadius, sigma, sigmaIntensity);

% Compute the detail layer: 
D = L-B;

% Apply an offset and a scale to the base 
% The offset is such that the maximum intensity of the base is 1. Since the values are in the log domain, o = max(B).
% The scale is set so that the output base has dR stops of dynamic range, i.e., s = dR / (max(B) - min(B)).
s = 1.6./(max(B(:)) - min(B(:)));
BB = s.*(B - max(B(:)));

% Reconstruct the log intensity: 
O = 10.^(BB +D);

% convert back to RGB 
Itonemapped = O.*Ichrominance;


end

