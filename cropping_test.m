%% Spatial Domain watermarking Scheme for Colored Images Based on Log-average Luminance
% André Gradim     - 
% João Pandeirada  -
% Patrícia Martins - 
% Pedro Martins    - 76374

clear; close all; clc;

%% Parameters
% Addition factor to watermark embedding
params.alpha = 3;

% Small value to avoid taking the log of a completely black pixel whose
% luminance is zero 
params.delta = 10^-5;

% Number of pixels in each row/column of a image block
params.blockSize = 8;

verbose_pic = 1;

%% Read image
image.croped100 = imread('Pictures/Lenna.png');

figure(1)
imshow(image.croped100, []);
title('Original Test Image');
drawnow
%% Read Watermark
watermark.uint8 = imread('Pictures/watermark_pinterest.png');

% Convert the RGB watermark into a binary image (black and white)
watermark.uint8 = ( (rgb2gray(watermark.uint8) ) > 127).*255;

figure(2)
imshow(watermark.uint8 )
title('Original Test Watermark');
drawnow

%% Crop image
% Image width
params.Width = size(image.croped100, 1);
params.crop = 1/64;

crop.crop12 = [params.Width * 0.4375  params.Width * 0.5625];
crop.crop25 = [params.Width * 0.375  params.Width * 0.625];
crop.crop50 = [params.Width * 0.25  params.Width * 0.75];
crop.crop75 = [params.Width * 0.125  params.Width * 0.875];

image.croped75 = imcrop(image.croped100,[crop.crop75 crop.crop75]);
image.croped50 = imcrop(image.croped100,[crop.crop50 crop.crop50]);
image.croped25 = imcrop(image.croped100,[crop.crop25 crop.crop25]);
image.croped12 = imcrop(image.croped100,[crop.crop12 crop.crop12]);

image.cropped = {image.croped100, image.croped75, image.croped50, image.croped25, image.croped12};

for k = 1 : 5
    params.crop = params.crop * 2;
    params.cropping_idx = [params.Width*params.crop  params.Width * (1 - params.crop)];
    image.uint8 = imcrop(image.croped100,[params.Width*params.crop params.Width*params.crop ...
                         params.Width * (1 - params.crop) params.Width * (1 - params.crop)]);
    
    %% Calculate image dependent simulation parameters
    % Image width
    params.Width = size(image.uint8, 1);

    % Image width normalized to the number of blocks
    params.Width8 = floor(params.Width / params.blockSize);

    % Number of pixels in the image
    params.N = size(image.uint8, 1) * size(image.uint8, 2);

    % Number of blocks required to embedded the watermark
    params.nBlocks = numel(watermark.uint8(:,:,1)) / params.blockSize.^2;


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
        image.quality(k) = Quality_Measurement(watermark.uint8, watermark.decoded);
end;
%% Results

%%% Tables
T = table(2.^-(5:-1:1)', image.quality', image.PSNR_dB', ...
          'VariableNames', {'Cropping', 'QualityMeasurement','PSNR_dB'})

%%% Plots
figure(8)
plot(2.^-(5:-1:1), image.PSNR_dB)
title('PSNR_{dB} Dependence of \alpha')
xlabel('\alpha')
ylabel('PSNR_{dB}')

figure(9)
plot(2.^-(5:-1:1), image.quality)
title('Quality of the Extracted Watermark Dependence of \alpha')
xlabel('\alpha')
ylabel('Quality Measurement')

