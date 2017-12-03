function [I_filtered] = remove_shade(I)
% This function takes an image with shade and try to remove it before
% segmentation

% Basically, we consider the image as a product of illumination and
% reflectance. Then we filter the illumination using a low-pass filter, 
% while the reflectance with a high-pass filter. In the end we add those
% filtered results.

% Reference: https://stackoverflow.com/questions/24731810/segmenting-license-plate-characters
% Remove some columns from the beginning and end
% I = I(:,60:end-20);

% Cast to double and do log.  We add with 1 to avoid log(0) error.
I = im2double(I);
I = log(1 + I);

% Create Gaussian mask in frequency domain
% We must specify our mask to be twice the size of the image to avoid
% aliasing.
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;
sigma = 5;
[X, Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);
centerY = ceil(M/2);
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;

% Low pass and high pass filters
Hlow = exp(-gaussianNumerator./(2*sigma.^2));
Hhigh = 1 - Hlow;

% Move origin of filters so that it's at the top left corner to match with
% input image
Hlow = ifftshift(Hlow);
Hhigh = ifftshift(Hhigh);

% Filter the image, and crop
If = fft2(I, M, N);
Ioutlow = real(ifft2(Hlow .* If));
Iouthigh = real(ifft2(Hhigh .* If));

% Set scaling factors then add
gamma1 = 0.3;
gamma2 = 1.5;
Iout = gamma1*Ioutlow(1:size(I,1),1:size(I,2)) + ...
       gamma2*Iouthigh(1:size(I,1),1:size(I,2));

% Anti-log then rescale to [0,1]
Ihmf = exp(Iout) - 1;
Ihmf = (Ihmf - min(Ihmf(:))) / (max(Ihmf(:)) - min(Ihmf(:)));

% Threshold the image - Anything below intensity 65 gets set to white
Ithresh = Ihmf < 45/255;

% Remove border pixels
Iclear = imclearborder(Ithresh, 8);

% Eliminate regions that have areas below 160 pixels
Iopen = bwareaopen(Iclear, 160);

% Show all of the results
% figure;
% subplot(4,1,1);
% imshow(I);
% title('Original Image');
% subplot(4,1,2);
% imshow(Ihmf);
% title('Homomorphic Filtered Result');
% subplot(4,1,3);
% imshow(Ithresh);
% title('Thresholded Result');
% subplot(4,1,4);
% imshow(Iopen);
% title('Opened Result');

I_filtered = Ithresh;

end

