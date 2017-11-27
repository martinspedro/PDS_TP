function [img_clean, wmk_extraida] = watermark_extract(img_original,img_watermarked, choosenblocks, params)

dif_image = img_watermarked(:,:,1) - img_original(:,:,1);
img_clean = img_watermarked(:,:,1) - dif_image;

bin_image = (dif_image>=alpha).*255;

wmk_extraida = zeros(32,32);
nblocks = length(watermark.decoded)/params.blockSize;

for i=1:length(choosenblocks),
    x = choosenblocks(i,1);
    y = choosenblocks(i,2);
    
    for wmx=1:nblocks
        for wmy=1:nblocks
            wmk_extraida(8*wmx-7:8*wmx,8*wmy-7:8*wmy)=...
                bin_image(8*x-7:8*x,8*y-7:8*y);
        end
    end
   
end

end

