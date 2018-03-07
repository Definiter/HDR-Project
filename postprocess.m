% Convert the cropped image to size and orientation of the display.
% Args:
%     image: the cropped image.
%     display_size: size of the display.
%     image_orientation: orientation of the cropped image, 0 up / 1 right / 2 down, 3 left
% Returns:
%     result: the converted image.
function result = postprocess(image, display_size, image_orientation)
    result = rot90(image, image_orientation);
    result = imresize(result, display_size, 'nearest');
end