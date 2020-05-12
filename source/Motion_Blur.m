% Motion Blur filter: The user has to put   %
% his image that wants to be blurred in the %
% project directory and specify the strength%
% and the angle of the filter required      % 

% Reading the image and storing it %
image = imread ('test_sample.jpg');

% Converting it into the grey scale to be able to process it%
image=rgb2gray(image);

% Taking Filter Direction and Intensity from the user
intensity = input('Enter Filter Intensity: ', 's');
intensity = ceil(str2double(intensity));
angle = input('Enter Filter Angle: ', 's');
angle = str2double(angle);

           % Creating the Gaussian Kernel with the required inputs %
           
% while loops to make sure that the entered angle is in range of 0 ~ 360 %
while angle > 360
    angle = angle-360;
end

while angle < 0
    angle = angle + 360;
end

if (angle == 0 || angle == 90 || angle == -90 || angle == 180 || angle == -180 )
filter = ones(1,intensity);
filter = (1/intensity)*filter;
elseif (angle == 45 || angle == -45 || angle == 135 || angle == -135)
filter = ones (intensity,intesity);
end

% If the Intensity input is even number, we need to normalize the kernel
% To make sure the image remains still in the grayscale (0~255)
if (mod(intensity,2) == 0)
    filter(1)= filter(1)/2;
    filter(intensity) = filter(intensity)/2;
end

if (angle == 'y')
    filter = filter.';
end

output = conv2(double(image),double(filter));
imwrite(uint8(output),'out.png');