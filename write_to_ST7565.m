% Convert a single channel image to data format in ST7565 LCD and write it.
% Args:
%     image: a single channel image.
% Returns:
%     bytes: data ready for input buffer of ST7565 LCD.
function bytes = write_to_ST7565(image, lcd, bug)    
    if nargin < 3
        bug = true;
    end
    if bug
        % Solve a mysterious bug when pasued time is between 0.3s and 1.0s.
        image = circshift(image, [0, 64]);
        temp = image(:, 65:128);
        temp = circshift(temp, [8, 0]);
        image(:, 65:128) = temp;
    end

    image = flipud(image);
    image = image < 128; % Binarization.

    bin = 7:-1:0;
    bin = 2 .^ bin;

    bytes = zeros(1, numel(image) / 8, 'uint8');
    
    i = 0;
    for y = 1:64/8
        for x = 1:128
            i = i + 1;
            bytes(i) = bin * image((y - 1) * 8 + 1:(y - 1) * 8 + 8, x);
        end
    end
    
    fwrite(lcd, bytes, 'uint8');
end