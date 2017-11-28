%% Watermark Embedding
% André Gradim - 
% João Pandeirada -
% Patrícia Martins - 
% Pedro Martins - 76374

%% Convert from RGB to YCbCr color space
image.YCbCr = conv_RGB2YCbCr(image.uint8);

figure(3)
imshow(image.YCbCr, [])
title('Original Test Image in YC_bC_r color space')

%% Average Image Luminance
[params.averageLuminance, results.blocksLuminance] = log_average(image.YCbCr, params);

%% Select the candidate blocks
% blocks with luminance higher than the average luminance
data.candidateBlocks = block_selection_operation(results.blocksLuminance, params);

%% Choose Candidates Spirally
data.spirallyChoosenBlocks = select_spiral(data.candidateBlocks, params);

%% Embedded Watermark
image.watermarked = watermark_embedding(image.YCbCr, watermark.uint8 , data.spirallyChoosenBlocks, params);

%% Convert from YCbCr to RGB color space
image.RGB_watermarked = conv_YCbCr2RGB(image.watermarked);

% Show watermarked image with in RGB color space
figure(4), 
imshow(image.RGB_watermarked, [])
title('Original Image with the embedded watermark')

