clear all; close all; clc;

I = cell(1,9);
w = cell(1,9);
t = 1./[640,400,160,80,40,25,10,6,4];

sumW = zeros(480,720,3);
sumWI = zeros(480,720,3);
for n = 1:9
    I{n} = im2double(imread(['test_data/IMG_',num2str(8134+n),'.jpg']));
    I{n} = I{n}.^2.2;
    w{n} = exp(-4*(I{n}-0.5).^2/0.5^2);
    sumW = sumW + w{n};
    sumWI = sumWI + w{n}.*(log(I{n}) - log(t(n))) ;
%     imwrite(w{n},['task1/weight_image/weight',num2str(60+n),'.png']);
end


I_hdr = exp(sumWI./sumW);
I_hdr = (I_hdr - min(I_hdr(:)))./(max(I_hdr(:)) - min(I_hdr(:)));
I_hdr = (3*I_hdr).^(1/4);
imwrite(I_hdr,'hdr.png')