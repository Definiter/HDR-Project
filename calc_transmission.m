% Parameters.
rect = [581, 171, 278, 513]; % iPhone X + Camera + Reflector 3 + 1440 * 900 + Crop LCD
display_size = [64, 128];
small_rect = [35, 42, 200, 167];

% Reset ports and open the device file.
instrreset;
lcd = serial('/dev/tty.usbmodem1441', 'BaudRate', 57600, 'OutputBufferSize', 1024);
fopen(lcd);
pause(2)

all_on = ones(display_size) * 255;
all_off = zeros(display_size);

on = cell(3, 1);
off = cell(3, 1);
for c = 1:3
    on{c} = [];
    off{c} = [];
end

stop = 2;

index = 0;
while true
    write_to_ST7565(all_on, lcd);
    beep
    pause(stop);
    image = screencapture(rect);
    image = imcrop(image, small_rect);
    image = im2double(image);
    image = image .^ (1/2.2);
    for c = 1:3
        on{c} = cat(1, on{c}, reshape(image(:, :, c), [], 1));
    end
    disp('on')
    
    write_to_ST7565(all_off, lcd);
    pause(stop);
    image = screencapture(rect);
    image = imcrop(image, small_rect);
    image = im2double(image);
    image = image .^ (1/2.2);
    for c = 1:3
        off{c} = cat(1, off{c}, reshape(image(:, :, c), [], 1));
    end
    disp('off')
    
    index = index + 1;
    if index == 5
        break
    end
end

for c = 1:3
    k = off{c} ./ on{c};
    k = k(~isnan(k));
    k = k(~isinf(k));
    k = mean(k);
    disp(k)
end