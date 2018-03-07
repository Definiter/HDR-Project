% Parameters.
%     rect = [190, 62, 1408, 932]; % Nikon Camera Control Pro 2 + 1920 * 1080
%     rect = [70, 51, 1168, 774]; % Nikon Camera Control Pro 2 + 1440 * 900
%     rect = [520, 159, 401, 536]; % iPhone X + Reflector 3 + 1440 * 900
    rect = [581, 171, 278, 513]; % iPhone X + Reflector 3 + 1440 * 900 + Crop LCD
display_size = [64, 128];
DEBUG = false;

% Reset ports and open the device file.
instrreset;
lcd = serial('/dev/tty.usbmodem1461', 'BaudRate', 57600, 'OutputBufferSize', 1024);
fopen(lcd);
pause(1)

% Main loop.
last_mask = ones(display_size) * 255;
index = 0;
while true
    index = index + 1;
    tic; image = screencapture(rect); toc;
    image = postprocess(image, display_size, 1);
%     mask = generatemask(image, 'threshold', 200);
    mask = generatemask(image, 'threshold_on_off', 200, 160, last_mask); % threshold values are for constrast 0x18
    last_mask = mask;
    write_to_ST7565(mask, lcd);
    pause(0.3)
    
%     imwrite(image, ['results/', num2str(index), '.png'])
%     imwrite(mask, ['results/', num2str(index), '_mask.png'])
end