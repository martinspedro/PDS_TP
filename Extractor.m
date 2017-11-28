%% Watermark Extractor
% André Gradim - 
% João Pandeirada -
% Patrícia Martins - 
% Pedro Martins - 76374

%% Convert from RGB to YCbCr colour space
image.YCbCr_watermarked = conv_RGB2YCbCr(image.RGB_watermarked );
figure(5)
imshow(image.YCbCr_watermarked, [])
title('Image to be used in YC_bC_r colour space')

%% Average Luminance of the original image
[params.averageLuminance, results.blocksLuminance] = log_average(image.YCbCr, params);

%% Select the candidate blocks from the original image
data.candidateBlocks = block_selection_operation(results.blocksLuminance, params);

%% Choose Candidates Spirally (from the original image)
data.spirallyChoosenBlocks = select_spiral(data.candidateBlocks, params);

%% Extract Watermark
% Falta discutir com a Patricia as alterações
[image.YCbCr_clean, watermark.decode] = watermark_extract(image.YCbCr, image.YCbCr_watermarked ,data.spirallyChoosenBlocks, params);

%% Convert from YCbCr to RGB colour space
image.RGB_clean = conv_YCbCr2RGB(image.YCbCr_clean);
figure(4), imshow(image.RGB_clean, [])

