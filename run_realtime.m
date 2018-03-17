% Parameters.
rect = [581, 171, 278, 513]; % iPhone X + Camera + Reflector 3 + 1440 * 900 + Crop LCD
display_size = [64, 128];
port = '/dev/tty.usbmodem1461';
interval = 0.3; % seconds

% Reset ports and open the device file.
instrreset;
lcd = serial(port, 'BaudRate', 57600, 'OutputBufferSize', 1024);
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
    mask = generatemask(image, 'threshold_on_off', 240, 160, last_mask);
%     mask = generatemask(image, 'threshold_inverse', 240, [0.9056, 0.8700, 0.7890], last_mask);
    last_mask = mask;
    write_to_ST7565(mask, lcd);
    pause(interval)
    
%     imwrite(image, ['results/', num2str(index), '.png'])
%     imwrite(mask, ['results/', num2str(index), '_mask.png'])
end