%% Watermark Extractor for grayscale
% André Gradim - 
% João Pandeirada -
% Patrícia Martins - 
% Pedro Martins - 76374

%% Average Luminance of the original image
[params.averageLuminance, results.blocksLuminance] = log_average(image.grayscale, params);

%% Select the candidate blocks from the original image
% blocks with luminance higher than the average luminance
data.candidateBlocks = block_selection_operation(results.blocksLuminance, params);

%% Choose Candidates Spirally (from the original image)
data.spirallyChoosenBlocks = select_spiral(data.candidateBlocks, params);

%% Extract Watermark
[image.grayscale_clean, watermark.decoded] = watermark_extract(image.YCbCr, image.grayscale ,data.spirallyChoosenBlocks, params);
