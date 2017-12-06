clear all; clc;
close all;

%% EECS442 Final Project
% Group Lamborghini
% Composed by Jiongsheng Cai, Jingyao Hu, Yucheng Yin
% Generally, we solve the problem of license plate number recognition
% The examples are in the /dataset folder and the plate images are
% relatively well taken in terms of distance, angle, illumination, etc.

% Our general strategy is first crop out the images and use CNN to
% recognize the characters

% This script will focus on cropping the license plate and segment the 
% characters in the . Also, we will try some pre-processing techniques 
% like achieving rotation-invariance, reducing shading, and noise cancellation.

% Reference: 
% https://stackoverflow.com/questions/17987866/how-to-extract-and-recognize-the-vehicle-plate-number-with-matlab
% https://stackoverflow.com/questions/24731810/segmenting-license-plate-characters
% https://en.wikipedia.org/wiki/Sobel_operator


%% Read images from folder
origFiles = dir('dataset/*.jpg'); 
numfiles = length(origFiles);
%numfiles = 12; %% When testing, choose first 12 images
origImages = cell(1, numfiles);
edgeImages = cell(1, numfiles);
extractImages = cell(1, numfiles);
extractDigits = cell(20, numfiles);

for k = 1:numfiles 
  origImages{k} = imread(strcat('dataset/', origFiles(k).name)); 
end

%% convert image to grayscale, then binarization and perform edge detection
% The purpose of edge detection is to remove noise in the original image
for k = 1:numfiles
    test_image = rgb2gray(origImages{k});

    % edge detection is implemented in edge_detect.m using sobel filter
    test_image_BW = edge_detect(test_image);
    edgeImages{k} = test_image_BW;
    imwrite(test_image_BW, strcat('dataset_edge/', origFiles(k).name));
end

% [~, threshold] = edge(test_image, 'sobel');
% fudgeFactor = .5;
% BWs = edge(test_image,'sobel', threshold * fudgeFactor);
% figure, imshow(BWs), title('binary gradient mask');

%% determine license plate location by calculating vertical and horizontal histogram
% implemented in extract_plate.m
%numfiles = 3;
for k = 1:numfiles
    [I_plate, x1, x2, y1, y2] = extract_plate(rgb2gray(origImages{k}));
    %[I_plate, x1, x2, y1, y2] = extract_plate(edgeImages{k});
    % remove shade from the extracted plate
    I_gray = rgb2gray(origImages{k}(x1:x2, y1:y2, :));
%     I_filtered = remove_shade(origImages{k}(x1:x2, y1:y2, :));
%     I_extract = I_filtered;
    I_extract = imcomplement(imbinarize(I_gray));
    extractImages{k} = I_extract;
    imwrite(I_extract, strcat('dataset_extracted_plate/', origFiles(k).name));
end

%% segment the digits and characters
% implemented in segment.m
for k = 1:numfiles
    % make dir
    dir = sprintf('dataset_extracted_digits/%s', origFiles(k).name(1:end - 4));
    if exist(dir, 'dir') == 0
        mkdir('./dataset_extracted_digits', sprintf('%s', origFiles(k).name(1:end - 4)));
    end
    
    [xx1,xx2,yy1,yy2] = segment(extractImages{k});
    extractDigits(k,1) = {length(xx1)};
    count = 0;
    for j = 1:length(xx1)
        extractDigits(k,j+1) = {extractImages{k}(yy1(j):yy2(j),xx1(j):xx2(j))};
        im = cell2mat(extractDigits(k,j+1));
        [im_r,im_c] = size(im);
        ratio = im_r / im_c;
        
        if (max(ratio, 1/ratio) < 2 && sum(sum(im)) / (im_r * im_c) > 0.08)
            imwrite(im, sprintf('dataset_extracted_digits/%s/%d.jpg', origFiles(k).name(1:end - 4), count));
            count = count + 1;
        end
    end
end