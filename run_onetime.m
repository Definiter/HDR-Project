% Parameters.
rect = [581, 171, 278, 513]; % iPhone X + Camera / Slow Shutter + Reflector 3 + 1440 * 900 + Crop LCD
rect_button_center = [715, 755, 12, 12]; % A region in the center of the button.
display_size = [64, 128];
port = '/dev/tty.usbmodem1461';
shutter_speed = 15.0; % seconds
interval = 0.5; % seconds

% Reset ports and open the device file.
instrreset;
lcd = serial(port, 'BaudRate', 57600, 'OutputBufferSize', 1024);
fopen(lcd);

% Wait for the initial image to create grayscale mask.
write_to_ST7565(ones(display_size) * 255, lcd);
pause(5)
beep
image = screencapture(rect);
image = postprocess(image, display_size, 1);
imwrite(image, 'results/image.png');

% Wait until the shutter button is pressed. Then the mask will be displayed.
while true
    button = screencapture(rect_button_center);
    button_pressed = mean(button(:)) > 128;
    if button_pressed
        break;
    end
end
beep

% Calculate mask.
mask = generatemask(image, 'grayscale');
imwrite(mask, 'results/mask.png');

% Show mask.
level = shutter_speed / interval;
masks = zeros(size(mask, 1), size(mask, 2), level);
for t = 1:level
    masks(:, :, t) = uint8((mask > 255 * ((t - 1) / level)) * 255);
    imwrite(masks(:, :, t), ['results/mask_', num2str(t), '.png']);
end
for t = 1:level    
    write_to_ST7565(masks(:, :, t), lcd, false);
    pause(interval);
end
write_to_ST7565(ones(display_size) * 255, lcd);

mean_mask = uint8(mean(masks, 3));
imwrite(mean_mask, 'results/mask_mean.png');
