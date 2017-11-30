% André Gradim     - 76480
% João Pandeirada  - 76482
% Patrícia Martins - 69754
% Pedro Martins    - 76374

%% Test Script for watermark extract
%[image.YCbCr_clean, watermark.decode] = 
%watermark_extract(image.YCbCr, image.YCbCr_watermarked , choosenBlocks , params);

dif_image = image.YCbCr_watermarked(:,:,1) - image.YCbCr(:,:,1);
image.YCbCr_clean = image.YCbCr_watermarked(:,:,1)-dif_image;

bin_image = (dif_image>=alpha).*255;

watermark.decoded = zeros(32,32);
nblocks = length(watermark.decoded)/params.blockSize;
for i=1:length(choosenblocks),
    x = choosenblocks(i,1);
    y = choosenblocks(i,2);
    
    for wmx=1:nblocks
        for wmy=1:nblocks
            watermark.decoded(8*wmx-7:8*wmx,8*wmy-7:8*wmy)=...
                bin_image(8*x-7:8*x,8*y-7:8*y);
        end
    end
   
end
