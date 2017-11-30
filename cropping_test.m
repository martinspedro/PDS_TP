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
image.PSNR_dB = zeros(length(images) * length(watermarks), 5);
image.Quality = zeros(length(images) * length(watermarks), 5);

for m = 1 : length(images)
    %% Read image
    image.croped100 = imread(['Pictures/' images(m).name]);
    
    if verbose_pic
        figure(1)
        imshow(image.croped100, []);
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
            imshow(watermark.uint8, [])
            title('Original Test Watermark');
            drawnow
        end;
        %% Crop image
        % Image width
        params.Width = size(image.croped100, 1);
        
        % Starting crop parameter
        params.crop = 1/64;

        for k = 1 : 5
            % Cropping parameter
            params.crop = params.crop * 2;
            
            % Crop image
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
T = table((2.^-(5:-1:1)')*100, image.Quality', image.PSNR_dB', ...
          'VariableNames', {'Cropping', 'QualityMeasurement','PSNR_dB'})

%%% Plots
figure(8)
subplot(121)
plot(2.^-(5:-1:1)*100, image.PSNR_dB, '-o', 'LineWidth', 3, 'MarkerSize', 10)
title('PSNR_{dB} dependence of cropping factor')
xlabel('Croping Factor (%)', 'FontSize', 30)
ylabel('PSNR_{dB}', 'FontSize', 30)
legend({'Lenna       | pinterest', 'Lenna       | smile', ...
       'Picasso     | pinterest', 'Picasso     | smile', ...
       'Van Gogh | pinterest', 'Van Gogh | smile'}, ...
        'FontSize', 20)
set(gca,'XTick',(2.^-(5:-1:1))*100)
set(gca,'XTickLabel',{num2str(((2.^-(5:-1:1))*100)')}, 'FontSize', 18);
ax = gca;
ax.XTickLabelRotation =  45;
grid on

%%% Plots
subplot(122)
plot((2.^-(5:-1:1))*100, image.Quality, '-o', 'LineWidth', 3, 'MarkerSize', 10)
title('Extracted watermark quality')
xlabel('Croping Factor (%)', 'FontSize', 30)
ylabel('Quality Measurement (\sigma)', 'FontSize', 30)
legend({'Lenna       | pinterest', 'Lenna       | smile', ...
       'Picasso     | pinterest', 'Picasso     | smile', ...
       'Van Gogh | pinterest', 'Van Gogh | smile'}, ...
        'FontSize', 20)
set(gca,'XTick',(2.^-(5:-1:1))*100)
set(gca,'XTickLabel',{num2str(((2.^-(5:-1:1))*100)')},'FontSize', 18);
ax = gca;
ax.XTickLabelRotation =  45;
grid on
ylim([0 1])
