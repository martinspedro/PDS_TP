% André Gradim     - 76480
% João Pandeirada  - 76482
% Patrícia Martins - 69754
% Pedro Martins    - 76374

function [img_clean, wmk_extraida] = watermark_extract(img_original,img_watermarked, choosenblocks, params)

dif_image = double(img_watermarked(:,:,1)) - double(img_original(:,:,1));
img_clean = img_watermarked;
img_clean(:,:,1) = double(img_watermarked(:,:,1)) - dif_image;
img_clean = uint8(img_clean);


theta= params.alpha/127;
bin_image = (dif_image./theta) + 127;

wmk_extraida = zeros(32,32);
nblocks = length(wmk_extraida)/params.blockSize;

i=1;
    for wmx=1:nblocks
        for wmy=1:nblocks
            x = choosenblocks(i,1);
            y = choosenblocks(i,2);
            wmk_extraida(8*wmx-7:8*wmx,8*wmy-7:8*wmy)=...
                bin_image(8*x-7:8*x,8*y-7:8*y);
            i=i+1;
        end
    end
   

wmk_extraida = uint8(wmk_extraida.*255./254);
    

end

