%% Watermark Extractor
% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

%% Convert from RGB to YCbCr color space
image.YCbCr_watermarked = conv_RGB2YCbCr(image.RGB_watermarked );

%% Average Luminance of the original image
[params.averageLuminance, results.blocksLuminance] = log_average(image.YCbCr, params);

%% Select the candidate blocks from the original image
% blocks with luminance higher than the average luminance
data.candidateBlocks = block_selection_operation(results.blocksLuminance, params);

%% Choose Candidates Spirally (from the original image)
data.spirallyChoosenBlocks = select_spiral(data.candidateBlocks, params);

%% Extract Watermark
[image.YCbCr_clean, watermark.decoded] = watermark_extract(image.YCbCr, image.YCbCr_watermarked ,data.spirallyChoosenBlocks, params);

%% Convert from YCbCr to RGB color space
image.RGB_clean = conv_YCbCr2RGB(image.YCbCr_clean);

