%% Watermark Extractor
% André Gradim - 
% João Pandeirada -
% Patrícia Martins - 
% Pedro Martins - 76374

%% Convert from RGB to YCbCr color space
image.YCbCr_watermarked = conv_RGB2YCbCr(image.RGB_watermarked );

% Show watermarked image represented in YCbCr color space
figure(5)
imshow(image.YCbCr_watermarked, [])
title('Watermarked Image in YC_bC_r color space')

%% Average Luminance of the original image
[params.averageLuminance, results.blocksLuminance] = log_average(image.YCbCr, params);

%% Select the candidate blocks from the original image
% blocks with luminance higher than the average luminance
data.candidateBlocks = block_selection_operation(results.blocksLuminance, params);

%% Choose Candidates Spirally (from the original image)
data.spirallyChoosenBlocks = select_spiral(data.candidateBlocks, params);

%% Extract Watermark
[image.YCbCr_clean, watermark.decoded] = watermark_extract(image.YCbCr, image.YCbCr_watermarked ,data.spirallyChoosenBlocks, params);

% Show extracted watermark
figure(6)
imshow(watermark.decoded)
title('Extracted Watermark from test image')

%% Convert from YCbCr to RGB color space
image.RGB_clean = conv_YCbCr2RGB(image.YCbCr_clean);

% Show RGB image without watermark
figure(7), 
imshow(image.RGB_clean)
title('Test image after removing the watermark')

