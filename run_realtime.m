% Parameters.
%     rect = [70, 51, 1168, 774]; % Nikon Camera Control Pro 2 + 1440 * 900
rect = [581, 171, 278, 513]; % iPhone X + Camera + Reflector 3 + 1440 * 900 + Crop LCD
%     rect = [576, 146, 289, 532]; % iPhone X + QuickTime Player + 1440 * 900 + Crop LCD
display_size = [64, 128];

% Reset ports and open the device file.
instrreset;
lcd = serial('/dev/tty.usbmodem1441', 'BaudRate', 57600, 'OutputBufferSize', 1024);
fopen(lcd);
pause(2)

% Main loop.
last_mask = ones(display_size) * 255;
index = 0;
while true
    index = index + 1;
    tic; image = screencapture(rect); toc;
    image = postprocess(image, display_size, 1);
%     mask = generatemask(image, 'threshold', 200);
    mask = generatemask(image, 'threshold_on_off', 240, 160, last_mask); % threshold values are for constrast 0x18
%     mask = generatemask(image, 'threshold_inverse', 240, [0.9056, 0.8700, 0.7890], last_mask);
    last_mask = mask;
    write_to_ST7565(mask, lcd);
    pause(0.3)
    
    imwrite(image, ['results/', num2str(index), '.png'])
    imwrite(mask, ['results/', num2str(index), '_mask.png'])
end