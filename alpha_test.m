%% Spatial Domain watermarking Scheme for Colored Images Based on Log-average Luminance
% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

clear; close all; clc;

%% Parameters
% Small value to avoid taking the log of a completely black pixel whose
% luminance is zero 
params.delta = 10^-5;

% Number of pixels in each row/column of a image block
params.blockSize = 8;

% (Dis)enable showing processed images
verbose_pic = 0;

% Addition factor to watermark embedding
alpha = 1:255;

%% Read Images from specific directorues
images = dir('Pictures/');
images = images(3:end);

watermarks = dir('Watermarks/');
watermarks = watermarks(3:end);

%% Init matrix
% Vectors to store data
image.PSNR_dB = zeros(length(images) * length(watermarks), length(alpha));
image.Quality = zeros(length(images) * length(watermarks), length(alpha));

for m = 1 : length(images)
    %% Read test image
    image.uint8 = imread(['Pictures/' images(m).name]);

    if verbose_pic
        figure(1)
        imshow(image.uint8, []);
        title('Original Test Image');
        drawnow
    end;

    for n = 1:length(watermarks)
        %% Read test Watermark
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
        params.Width8 = params.Width / params.blockSize;

        % Number of pixels in the image
        params.N = size(image.uint8, 1) * size(image.uint8, 2);

        % Number of blocks required to embedded the watermark
        params.nBlocks = numel(watermark.uint8(:,:,1)) / params.blockSize.^2;

        for k = 1:length(alpha)
            % Alpha for the desired simulation
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
            image.PSNR_dB(2*(m-1) + n,k) = psnr(image.uint8, image.RGB_watermarked);

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

            %% Calculate Similarity between the embedded and Extracted Watermarks
            image.Quality(2*(m-1) + n, k) = Quality_Measurement(watermark.uint8, watermark.decoded);
            
        end;
    end;
end;

%% Results
%%% Tables
T = table(alpha', image.Quality', image.PSNR_dB', ...
         'VariableNames', {'alpha', 'QualityMeasurement','PSNR_dB'})

%%% Plots
figure(8)
subplot(121)
plot(alpha, image.PSNR_dB, 'LineWidth', 6)
xlim([alpha(1) alpha(end)])
title('PSNR_{dB} dependence of \alpha', 'FontSize', 30)
xlabel('\alpha',  'FontSize', 30)
ylabel('PSNR_{dB}',  'FontSize', 30)
legend({'Lenna       | pinterest', 'Lenna       | smile', ...
       'Picasso     | pinterest', 'Picasso     | smile', ...
       'Van Gogh | pinterest', 'Van Gogh | smile'}, ...
        'FontSize', 20)
grid on
ax = gca;
ax.FontSize = 18;

% figure(9)
subplot(122)
plot(alpha, image.Quality, 'LineWidth', 6)
xlim([alpha(1) alpha(end)])
title('Quality of the extracted watermark',  'FontSize', 30)
xlabel('\alpha',  'FontSize', 30)
ylabel('Quality Measurement (\sigma)',  'FontSize', 30)
legend({'Lenna       | pinterest', 'Lenna       | smile', ...
       'Picasso     | pinterest', 'Picasso     | smile', ...
       'Van Gogh | pinterest', 'Van Gogh | smile'}, ...
        'FontSize', 20)
grid on
ax = gca;
ax.FontSize = 18;
