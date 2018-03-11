% Generate mask for image by certain method with some optional parameters. 
% Args:
%     image: RGB image.
%     method: a string indicating method.
%     threshold_on: threshold for turning on mask when method is 'threshold_on_off'
%     threshold_off: threshold for turning off mask when method is 'threshold_on_off'
%     last_mask: mask in last cycle.
% Returns:
%     mask: a mask with the same size of the input image, where 0 indicates opaque and 255 indicates transparent.
function mask = generatemask(image, method, threshold_on, extra_arg1, extra_arg2)
    if strcmp(method, 'threshold')
        mask = uint8(rgb2gray(image) < threshold_on) * 255;
    end
    if strcmp(method, 'threshold_on_off')
        threshold_off = extra_arg1;
        last_mask = extra_arg2;
        
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
    if strcmp(method, 'grayscale')
        gray = uint8(rgb2gray(image));
        mask = 255 - gray;
        imwrite(mask, 'results/mask_ori.png');
        mask = imadjust(mask, [0.2, 0.8]);
    end
    if strcmp(method, 'threshold_inverse')
        transmission = extra_arg1;
        last_mask = extra_arg2;
        % Inverse
        original_image = image;
        for c = 1:3
            channel = original_image(:, :, c);
            channel(last_mask > 128) = channel(last_mask > 128) / transmission(c);
            original_image(:, :, c) = channel;
        end
        mask = generatemask(image, 'threshold', threshold_on);
    end
    if strcmp(method, 'threshold') || strcmp(method, 'threshold_on_off')  
        % Try to solve shrinking problem with gaussian blur.
        mask = uint8(imgaussfilt(mask, 2));
        mask = (mask > 200) * 255;
    end
end