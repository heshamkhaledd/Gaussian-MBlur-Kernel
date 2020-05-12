% Motion Blur filter: The user has to put   %
% his image that wants to be blurred in the %
% project directory and specify the strength%
% and the angle of the filter required      % 

% Reading the image and storing its RGB Colors to be able to 
% be exported at last as an RGB Color
image = imread ('car.jpg');
red = image(:,:,1);
green = image(:,:,2);
blue = image(:,:,3);

% Converting it into the grey scale to be able to process it%
image=rgb2gray(image);

% Taking Filter Direction and Intensity from the user
intensity = input('Enter Filter Intensity: ', 's');
intensity = ceil(str2double(intensity));
angle = input('Enter Filter Angle: ', 's');
angle = str2double(angle);

           % Creating the Gaussian Kernel with the required inputs %
           
           
% We will assume the normalization weight and the standard deviation of all
% the pixels in order to make the best filter fitting without corrupting
% the original image.
std_deviation = 3.145;
normalize_weight = 1.2;
    
% while loops to make sure that the entered angle is in range of 0 ~ 360 %
while angle > 360
    angle = angle-360;
end

while angle < 0
    angle = angle + 360;
end

% If the directions are basic (+ve or -ve X-AXIS, +ve or -ve Y-AXIS)
% The Kernel will be only one dimentional, either a row or a column.
if (angle == 0 || angle == 90 || angle == -90 || angle == 180 || angle == -180 || angle == 270 || angle == -270)
filter = ones(1,intensity);
filter = (1/intensity)*filter;

        % If the Intensity input is even number, we need to normalize the kernel
        % edges to make sure the image remains still in the grayscale (0 ~ 255)
        if (mod(intensity,2) == 0)
            filter(1,1)= filter(1)/2;
            filter(intensity,intensity) = filter(intensity)/2;
        end
        if (angle == 90 || angle == -90 || angle == 270 || angle == -270)
            filter = filter.';
        end

% If the directions are on the diagonal, we need to create
% a two-dimensional Gaussian Kernel.

% At the +ve Diagonal
elseif (angle == 45 || angle == 225 || angle == -135 || angle == -315)
    kernel_size = ceil(intensity*cos(pi/4));
    filter = zeros(kernel_size,kernel_size);
    i=1;
    j=1;
    
    % If intensity is odd, the kernel is symmetric, so, 
    % we can average the kernel at the edges with low weighted 
    % coefficients with respect to the original image bitmap.
    if (mod(intensity,2) ~= 0)
        j=kernel_size;
        for i = 1:kernel_size
            if (i == 1)
                filter(i,j) = 1/(intensity*normalize_weight);
                filter(i+1,j) = 1/(intensity*std_deviation*normalize_weight);
            
            elseif (i == kernel_size)
                filter(i,j)=1/(intensity*normalize_weight);
                filter(i-1,j)= 1/(intensity*std_deviation*normalize_weight);
            else
                filter(i,j) = 1/intensity;
                filter(i+1,j) = 1/(intensity*std_deviation);
                filter(i-1,j) = 1/(intensity*std_deviation);
            end
            j = j - 1;
        end
   % If intensity is even, the kernel is asymmetric, so at the edges
   % it's better to neglect higher diagonal indices and make them zeroes
   % relative to the image bitmap.
    else
        j=kernel_size;
        for i= 1:kernel_size
            if (i == 1)
                filter(i,j) = 0;
                filter(i+1,j) = 1/(intensity*std_deviation*normalize_weight);
            elseif (i == kernel_size)
                filter(i,j) = 0;
                filter(i-1,j) = 1/(intensity*std_deviation*normalize_weight);
            else
                filter(i,j) = 1/intensity;
                filter(i+1,j) = 1/(intensity*std_deviation);
                filter(i-1,j) = 1/(intensity*std_deviation);
            end
            j = j - 1;
        end
    end
    
    
% At the +ve Diagonal
elseif (angle == 135 || angle == -45 || angle == 315 || angle == -225)
    kernel_size = ceil(intensity*cos(pi/4));
    filter = zeros(kernel_size,kernel_size);
	i=1;
    j=1;
    
    % If intensity is odd, the kernel is symmetric, so, 
    % we can average the kernel at the edges with low weighted 
    % coefficients with respect to the original image bitmap.
    if (mod(intensity,2) ~= 0)
        j=1;
        for i = 1:kernel_size
            if (i == 1)
                filter(i,j) = 1/(intensity*normalize_weight);
                filter(i+1,j) = 1/(intensity*std_deviation*normalize_weight);
            
            elseif (i == kernel_size)
                filter(i,j)=1/(intensity*normalize_weight);
                filter(i-1,j)= 1/(intensity*std_deviation*normalize_weight);
            else
                filter(i,j) = 1/intensity;
                filter(i+1,j) = 1/(intensity*std_deviation);
                filter(i-1,j) = 1/(intensity*std_deviation);
            end
            j = j + 1;
        end
   % If intensity is even, the kernel is asymmetric, so at the edges
   % it's better to neglect higher diagonal indices and make them zeroes
   % relative to the image bitmap.
    else
        j=1;
        for i= 1:kernel_size
            if (i == 1)
                filter(i,j) = 0;
                filter(i+1,j) = 1/(intensity*std_deviation*normalize_weight);
            elseif (i == kernel_size)
                filter(i,j) = 0;
                filter(i-1,j) = 1/(intensity*std_deviation*normalize_weight);
            else
                filter(i,j) = 1/intensity;
                filter(i+1,j) = 1/(intensity*std_deviation);
                filter(i-1,j) = 1/(intensity*std_deviation);
            end
            j = j + 1;
        end
    end
end

% Convoluting the the image with the saved bitmap of the RGB Colors
% to export an RGB image
red = conv2(double(filter),double(red));
green = conv2(double(filter),double(green));
blue = conv2(double(filter),double(blue)); 
output = cat(3,red,green,blue);
imwrite(uint8(output),'out.png');
