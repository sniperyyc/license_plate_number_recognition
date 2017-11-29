clear all; clc;

%% EECS442 Final Project
% Group Lamborghini
% Composed by Jiongsheng Cai, Jingyao Hu, Yucheng Yin
% Generally, we solve the problem of license plate number recognition
% The examples are in the /dataset folder and the plate images are
% relatively well taken in terms of distance, angle, illumination, etc.

% Our general strategy is first crop out the images and use CNN to
% recognize the characters

% This script will focus on finding the positions of the plate in
% the whole image and generate the cropped plate image. Also, we will
% perform some pre-processing techniques like achieving
% rotation-invariance, reducing shading, and noise cancellation.

% Reference: 
% https://stackoverflow.com/questions/17987866/how-to-extract-and-recognize-the-vehicle-plate-number-with-matlab
% https://stackoverflow.com/questions/24731810/segmenting-license-plate-characters
% https://en.wikipedia.org/wiki/Sobel_operator


%% Read images from folder
origFiles = dir('dataset/*.jpg'); 
numfiles = length(origFiles);
origImages = cell(1, numfiles);

for k = 1:numfiles 
  origImages{k} = imread(strcat('dataset/', origFiles(k).name)); 
end

%% convert image to grayscale, then binarization and perform edge detection
% The purpose of edge detection is to remove noise in the original image
for k = 1:numfiles
    test_image = rgb2gray(origImages{k});

    % edge detection is implemented in edge_detect.m using sobel filter
    test_image_BW = edge_detect(test_image);
    imwrite(test_image_BW, strcat('dataset_edge/', origFiles(k).name));
end

% [~, threshold] = edge(test_image, 'sobel');
% fudgeFactor = .5;
% BWs = edge(test_image,'sobel', threshold * fudgeFactor);
% figure, imshow(BWs), title('binary gradient mask');

%% determine license plate location by calculating vertical and horizontal histogram
% implemented in extract_plate.m

