%% Spatial Domain watermarking Scheme for Colored Images Based on Log-average Luminance
% André Gradim - 
% João Pandeirada -
% Patrícia Martins - 
% Pedro Martins - 76374

clear; close all; clc;

%% Parameters
% Addition factor to watermark embedding
params.alpha = 3;

% Small value to avoid taking the log of a completely black pixel whose
% luminance is zero 
params.delta = 10^-5;

% Number of pixels in each row/column of a image block
params.blockSize = 8;


%% Read image
image.uint8 = imread('Pictures/Lenna.png');
figure(1)
imshow(image.uint8, []);
title('Original Test Image');

% % Convert to double
% image.double = im2double(image.uint8);
% figure(2)
% imshow(image.double, []);


%% Read Watermark
watermark.uint8 = imread('Pictures/watermark_pinterest.png');

% Convert the RGB watermark into a binary image (black and white)
watermark.uint8 = ( (rgb2gray(watermark.uint8) ) > 127).*255;

figure(2)
imshow(watermark.uint8 )
title('Original Test Watermark');

%% Calculate image dependent simulation parameters
% Image width
params.Width = size(image.uint8, 1);

% Image width normalized to the number of blocks
params.Width8 = params.Width / params.blockSize;

% Number of pixels in the image
params.N = size(image.uint8, 1) * size(image.uint8, 2);

% Number of blocks required to embedded the watermark
params.nBlocks = numel(watermark.uint8(:,:,1)) / params.blockSize.^2;

%% Run Watermark Embedder
run Embedder

%% Calculate PSNR
image.PSNR_dB = psnr(image.uint8, image.RGB_watermarked);

%% Run Watermarker Extractor
run Extractor

%% Calculate Similarity
value = Quality_Measurement(watermark.uint8, watermark.decode);

%% Results

%%% Tables

%%% Plots
