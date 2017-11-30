%% Spatial Domain watermarking Scheme for Colored Images Based on Log-average Luminance
% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
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

% (Dis)enable showing processed images
verbose_pic = 0;

%% Read Images
images = dir('Pictures/');
images = images(3:end);

watermarks = dir('Watermarks/');
watermarks = watermarks(3:end);

%% Init matrix
% Vectors to store data
image.Quality = zeros(1, length(images) * length(watermarks));

for m = 1 : length(images)
    %% Read image
    image.uint8 = imread(['Pictures/' images(m).name]);

    if verbose_pic
        figure(1)
        imshow(image.uint8, []);
        title('Original Test Image');
        drawnow
    end;
    
    for n = 1:length(watermarks)
        %% Read Watermark
        watermark.uint8 = imread(['Watermarks/' watermarks(n).name]);

        % Convert the RGB watermark into a binary image (black and white)
        watermark.uint8 = ( (rgb2gray(watermark.uint8) ) > 127).*255;

        if verbose_pic
            figure(2)
            imshow(watermark.uint8 )
            title('Original Test Watermark');
            drawnow
        end;
        
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


        %% Convert image to gray scale
        image.grayscale = rgb2gray(image.RGB_watermarked);

        %% Calculate PSNR
        % Cannot be applied with grayscale images

        %% Run Watermarker Extractor
        run Extractor_grayscale

        if verbose_pic
            % Show watermarked image represented in YCbCr color space
            figure(5)
            imshow(image.grayscale, [])
            title('Watermarked Image in Grayscale color space')
            drawnow

            % Show extracted watermark
            figure(6)
            imshow(watermark.decoded)
            title('Extracted Watermark from test image')
            drawnow

            % Show RGB image without watermark
            figure(7) 
            imshow(image.grayscale_clean)
            title('Grayscaled Test image after removing the watermark')
            drawnow
        end;

        %% Calculate Similarity
        image.Quality(1, 2*(m-1) + n) = Quality_Measurement(watermark.uint8, watermark.decoded);
        
    end;
end;
%% Results

%%% Tables
Quality_Factor = table(image.Quality(1:2:end)', image.Quality(2:2:end)', ...
                       'VariableNames', {'Pinterest', 'Smile'}, ...
                       'RowNames', {'Lenna', 'Picasso', 'Van Gogh'})

%%% Plots
figure(8)
plot(1:length(images) * length(watermarks),image.Quality', '-o', ...
     'LineWidth', 3, 'MarkerSize', 10)
ylim([0 1])
title('Quality of the Extracted Watermark')
xlabel('Image + Watermark', 'FontSize', 30)
ylabel('Quality Measurement (\sigma)', 'FontSize', 30)
set(gca,'XTick',1:length(images) * length(watermarks))
set(gca,'XTickLabel',{'Lenna + pinterest', 'Lenna + smile', 'Picasso + pinterest', ...
    'Picasso + smile', 'Van Gogh + pinterest', 'Van Gogh + smile'},'FontSize', 18);
grid on
