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
params.delta = 0.01;

% Number of pixels in each row/column of a image block
params.blockSize = 8;

params.Width8 = 8;

%% Read image
image.uint8 = imread('Pictures/Lenna.png');
figure(1)
imshow(image.uint8, []);

% Convert to double
image.double = im2double(image.uint8);
figure(2)
imshow(image.double, []);

%% Read Watermark
watermark.uint8 = imread('Pictures/watermark_pinterest.png');

% Convert RGB watermark to binary image
watermark.uint8 = (watermark.uint8(:, :, 1) +  watermark.uint8(:, :, 2) + watermark.uint8(:, :, 3) )> 0;

figure(3)
imshow(watermark.uint8 )
title('Watermark to be used');

%% Calculate simulation parameters
% Number of pixels in the image
params.N = size(image.uint8, 1) * size(image.uint8, 2);

% Number of blocks required to embedded the watermark
params.Nblock = numel(watermark.uint8) / params.blockSize.^2

%% Run Watermark Embedder
run Embedder

%% Calculate PSNR
image.PSNR_dB = PSNR(image.uint8, image.RGB)

%% Run Watermarker Extractor
run Extractor

%% Calculate Similarity
value = Quality_Measurement(watermark_original, watermark_extraida)

%% Results

%%% Tables

%%% Plots
