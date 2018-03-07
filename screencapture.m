% Capture current activated screen.
% Args:
%     rect: region to capture.
% Returns:
%     image: captured image.
function image = screencapture(rect)
    % Take screen capture
    robot = java.awt.Robot();
    tool = java.awt.Toolkit.getDefaultToolkit();
    if nargin == 0  
        area = java.awt.Rectangle(tool.getScreenSize());
    else
        area = java.awt.Rectangle(rect(1), rect(2), rect(3), rect(4));
    end
    capture = robot.createScreenCapture(area);

    % Convert to an RGB image
    rgb = typecast(capture.getRGB(0, 0, capture.getWidth, capture.getHeight, ...
        [], 0, capture.getWidth), 'uint8');
    image = zeros(capture.getHeight, capture.getWidth, 3, 'uint8');
    image(:, :, 1) = reshape(rgb(3:4:end), capture.getWidth, [])';
    image(:, :, 2) = reshape(rgb(2:4:end), capture.getWidth, [])';
    image(:, :, 3) = reshape(rgb(1:4:end), capture.getWidth, [])';
end