%% Spatial Domain watermarking Scheme for Colored Images Based on Log-average Luminance
% André Gradim     - 76480
% João Pandeirada  - 76482
% Patrícia Martins - 69754
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

% Compression Factor of JPG images
params.compressFactor = 100:-25:25;

%% Read Images
images = dir('Pictures/');
images = images(3:end);

watermarks = dir('Watermarks/');
watermarks = watermarks(3:end);

%% Init matrix
% Vectors to store data
image.PSNR_dB = zeros(length(images) * length(watermarks), length(params.compressFactor));
image.Quality = zeros(length(images) * length(watermarks), length(params.compressFactor));

for m = 1 : length(images)
    %% Read image
    image.uint8 = imread(['Pictures/' images(m).name]);
    
    if verbose_pic
        figure(1)
        imshow(image.uint8, []);
        title('Original Test Image');
        drawnow
    end
    for n = 1:length(watermarks)
        %% Read Watermark
        watermark.uint8 = imread(['Watermarks/' watermarks(n).name]);

        % Convert the RGB watermark into a binary image (black and white)
        watermark.uint8 = ( (rgb2gray(watermark.uint8) ) > 127).*255;

        if verbose_pic
            figure(2)
            imshow(watermark.uint8, [])
            title('Original Test Watermark');
            drawnow
        end;
        %% Crop image
        % Image width
        params.Width = size(image.uint8, 1);

        for k = 1 : length(params.compressFactor)
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

            %% Compress the JPEG Image
            imwrite(image.RGB_watermarked, 'test.jpg', 'Quality', params.compressFactor(k))
            image.RGB_watermarked = imread('test.jpg');

            %% Calculate PSNR
            image.PSNR_dB(2*(m-1) + n, k) = psnr(image.uint8, image.RGB_watermarked);

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
            image.Quality(2*(m-1) + n, k) = Quality_Measurement(watermark.uint8, watermark.decoded);
            
        end;
    end;
end;

%% Results
%%% Tables
T = table(params.compressFactor', image.Quality', image.PSNR_dB', ...
          'VariableNames', {'Cropping', 'QualityMeasurement','PSNR_dB'})

%%% Plots
figure(8)
subplot(121)
plot(params.compressFactor, image.PSNR_dB, '-o', 'LineWidth', 3, 'MarkerSize', 10)
title('PSNR_{dB} dependence of the JPEG compression factor')
xlabel('Compression Factor (%)', 'FontSize', 30)
ylabel('PSNR_{dB}', 'FontSize', 30)
set(gca,'XTick', params.compressFactor(end:-1:1))
set(gca,'XTickLabel', {params.compressFactor(end:-1:1)'},'FontSize', 18);
grid on
legend({'Lenna       | pinterest', 'Lenna       | smile', ...
       'Picasso     | pinterest', 'Picasso     | smile', ...
       'Van Gogh | pinterest', 'Van Gogh | smile'}, ...
        'FontSize', 20)
    
% figure(9)
subplot(122)
plot(params.compressFactor, image.Quality, '-o', 'LineWidth', 3, 'MarkerSize', 10)
title('Quality of the extracted watermak')
xlabel('Compression Factor (%)', 'FontSize', 30)
ylabel('Quality Measurement (\sigma)', 'FontSize', 30)
set(gca,'XTick', params.compressFactor(end:-1:1))
set(gca,'XTickLabel',{params.compressFactor(end:-1:1)'},'FontSize', 18);
legend({'Lenna       | pinterest', 'Lenna       | smile', ...
       'Picasso     | pinterest', 'Picasso     | smile', ...
       'Van Gogh | pinterest', 'Van Gogh | smile'}, ...
        'FontSize', 20)
ylim([0 1])
grid on
