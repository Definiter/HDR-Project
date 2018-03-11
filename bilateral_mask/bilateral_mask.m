clear all
close all
clc

% read hdr image and benchmark image
object = hdrread('memorial.hdr');
I_std = im2double(imread('data_hdr/memorial0061.png'));
I_normal = im2double(imread('data_hdr/memorial0062.png'));

% Transmission of LCD
Tmax = 0.8; Tmin = 0.05;

t_best = best_exp_time(object,I_std);

% initialization 
I  =  take_photo(object,t_best);
sizeImage = size(I);
mask = ones(sizeImage)*Tmax;

% metering
while 1
   [mask, isoverexposured] = mask_metering(I,mask, 20,Tmax, Tmin);
   I = take_photo(object.*mask,t_best);
   if ~isoverexposured
       break;
   end
end

% recover hdr
I_hdr = recover_hdr(I,mask);

% bilateral tone mapping
I_ldr = hdr2ldr(I_hdr);

% calculate filter
mask_filter = I_ldr./I_hdr;
mask_filter(mask_filter>Tmax) = Tmax;
mask_filter(mask_filter<Tmin) = Tmin;
mask_filter = average_pooling(mask_filter,10);
% 

% image shown after mask
If = take_photo(object.*mask_filter, t_best);
If = If.^(1/2.2);


subplot(1,3,1)
imshow(I_normal)
title('without mask')
set(gca,'Fontsize',18)
subplot(1,3,2)
imshow(If)
title('with mask')
set(gca,'Fontsize',18)
subplot(1,3,3)
imshow(mask_filter)
title('mask')
set(gca,'Fontsize',18)

imwrite(uint8(If(3:end-3,3:end-3,:)*255),'result/withmask.png')
imwrite(uint8(I_normal(3:end-3,3:end-3,:)*255),'result/withoutmask.png')
imwrite(uint8(mask_filter(3:end-3,3:end-3,:)*255),'result/mask.png')
