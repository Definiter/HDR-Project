function [ mask, isoverexposured ] = mask_metering( photo, mask, max_pixels, Tmax, Tmin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if sum(photo == 1) < max_pixels
    isoverexposured = 0;
else
    mask_old = mask;
    mask(photo == 1) = mask(photo == 1)*0.5;
   % mask = average_pooling(mask,10);
    mask(mask<Tmin) = Tmin;
    isoverexposured = 1;
    if mask == mask_old
        isoverexposured = 0;
    end
end

end

