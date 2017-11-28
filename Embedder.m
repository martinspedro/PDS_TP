%% Watermark Embedding
% André Gradim - 
% João Pandeirada -
% Patrícia Martins - 
% Pedro Martins - 76374

%% Convert from RGB to YCbCr colour space
image.YCbCr = conv_RGB2YCbCr(image.uint8);
figure(4)
imshow(image.YCbCr, [])
title('Image to be used in YC_bC_r colour space')

%% Average Luminance
[params.averageLuminance, results.blocksLuminance] = log_average(image.YCbCr, params);

%% Select the blocks
data.candidateBlocks = block_selection_operation(results.blocksLuminance, params);

%% Choose Candidates Spirally
data.spirallyChoosenBlocks = select_spiral(data.candidateBlocks, params);

%% Embedded Watermark
% Falta discutir com a Patricia as alterações
image.watermarked = watermark_embedding(image.YCbCr, watermark.uint8 , data.spirallyChoosenBlocks, params);

%% Convert from YCbCr to RGB colour space
image.RGB_watermarked = conv_YCbCr2RGB(image.watermarked);
figure(5), imshow(image.RGB_watermarked, [])


%%
% figure(5)
% x = rgb2ycbcr(image.uint8);
% imshow(x,  [])
% 
% figure(6)
% y = ycbcr2rgb(x);
% imshow(y, [])

%%
