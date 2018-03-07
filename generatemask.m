% Generate mask for image by certain method with some optional parameters. 
% Args:
%     image: RGB image.
%     method: a string indicating method.
%     threshold_on: threshold for turning on mask when method is 'threshold_on_off'
%     threshold_off: threshold for turning off mask when method is 'threshold_on_off'
%     last_mask: mask in last cycle.
% Returns:
%     mask: a mask with the same size of the input image, where 0 indicates opaque and 255 indicates transparent.
function mask = generatemask(image, method, threshold_on, threshold_off, last_mask)
    if strcmp(method, 'threshold')
        mask = uint8(rgb2gray(image) < threshold_on) * 255;
    end
    if strcmp(method, 'threshold_on_off')
        gray = rgb2gray(image);
        mask = zeros(size(gray));
        for i = 1:size(image, 1)
            for j = 1:size(image, 2)
                if last_mask(i, j) == 255 % no mask
                    mask(i, j) = (gray(i, j) < threshold_on) * 255;
                else % has mask
                    if threshold_on < gray(i, j)
                        mask(i, j) = 0;
                    elseif threshold_off < gray(i, j)
                        mask(i, j) = 0;
                    else
                        mask(i, j) = 255;
                    end
                end
            end
        end
    end
    
%     % Try to solve shrinking problem with image dilatation.
%     mask = imgaussfilt(mask, 2);
%     imwrite(mask, ['results/', num2str(index), '_mask_ori.png'])
%     mask = 255 - imdilate(255 - mask, strel('ball', 3, 3));

%     % Try to solve shrinking problem with image crop.
%     imwrite(mask, ['results/', num2str(index), '_mask_ori.png'])
%     new_mask = imresize(mask, 1.1);
%     new_mask = imcrop(new_mask, [(size(new_mask, 2) - size(mask, 2)) / 2, ...
%                                  (size(new_mask, 1) - size(mask, 1)) / 2, ...
%                                  size(mask, 2) - 1, size(mask, 1) - 1]);
%     mask = new_mask;
end