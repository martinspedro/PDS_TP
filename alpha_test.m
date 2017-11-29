%% Spatial Domain watermarking Scheme for Colored Images Based on Log-average Luminance
% André Gradim     - 
% João Pandeirada  -
% Patrícia Martins - 
% Pedro Martins    - 76374

clear; close all; clc;

%% Parameters
% Addition factor to watermark embedding
params.alpha = 10;

% Small value to avoid taking the log of a completely black pixel whose
% luminance is zero 
params.delta = 10^-5;

% Number of pixels in each row/column of a image block
params.blockSize = 8;

verbose_pic = 0;
%% Read image
image.uint8 = imread('Pictures/unnamed.png');

figure(1)
imshow(image.uint8, []);
title('Original Test Image');
drawnow
%% Read Watermark
watermark.uint8 = imread('Watermarks/pinterest.png');

% Convert the RGB watermark into a binary image (black and white)
watermark.uint8 = ( (rgb2gray(watermark.uint8) ) > 127).*255;

figure(2)
imshow(watermark.uint8 )
title('Original Test Watermark');
drawnow
%% Calculate image dependent simulation parameters
% Image width
params.Width = size(image.uint8, 1);

% Image width normalized to the number of blocks
params.Width8 = params.Width / params.blockSize;

% Number of pixels in the image
params.N = size(image.uint8, 1) * size(image.uint8, 2);

% Number of blocks required to embedded the watermark
params.nBlocks = numel(watermark.uint8(:,:,1)) / params.blockSize.^2;

alpha = 1:255;

image.PSNR_dB = zeros(1, length(alpha));
value = zeros(1, length(alpha));

for k = 1:length(alpha)
    params.alpha = alpha(k);
    
    %% Run Watermark Embedder
    run Embedder

    if verbose_pic
        % Show test image in YCbCr color space
        figure(3)
        imshow(image.YCbCr, [])
        title('Original Test Image in YC_bC_r color space')
        drawnow
        
        % Show watermarked image with in RGB color space
        figure(4), 
        imshow(image.RGB_watermarked, [])
        title('Original Image with the embedded watermark')
        drawnow
    end;

    %% Calculate PSNR
    image.PSNR_dB(k) = psnr(image.uint8, image.RGB_watermarked);

    %% Run Watermarker Extractor
    run Extractor
    
    if verbose_pic
        % Show watermarked image represented in YCbCr color space
        figure(5)
        imshow(image.YCbCr_watermarked, [])
        title('Watermarked Image in YC_bC_r color space')
        drawnow

        % Show extracted watermark
        figure(6)
        imshow(watermark.decoded)
        title('Extracted Watermark from test image')
        drawnow

        % Show RGB image without watermark
        figure(7), 
        imshow(image.RGB_clean)
        title('Test image after removing the watermark')
        drawnow
	end;

    %% Calculate Similarity
    value(k) = Quality_Measurement(watermark.uint8, watermark.decoded);
end;
%% Results

%%% Tables
T = table(alpha', value', image.PSNR_dB', ...
          'VariableNames', {'alpha', 'QualityMeasurement','PSNR_dB'})

%%% Plots
figure(8)
plot(alpha, image.PSNR_dB)
xlim([alpha(1) alpha(end)])
title('PSNR_{dB} Dependence of \alpha')
xlabel('\alpha')
ylabel('PSNR_{dB}')

figure(9)
plot(alpha, value)
xlim([alpha(1) alpha(end)])
title('Quality of the Extracted Watermark Dependence of \alpha')
xlabel('\alpha')
ylabel('Quality Measurement')

