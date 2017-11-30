% André Gradim     - 76480
% João Pandeirada  - 76482
% Patrícia Martins - 69754
% Pedro Martins    - 76374

%% Test script for PSNR 
%image.PSNR_dB = PSNR(img_original, img_wmk)
totalpixels = prod(size(img_original));
max_pixvalue = max(max(img_original(:,:,1)));
error_r = img_original(:,:,1)-img_wmk(:,:,1);
error_g = img_original(:,:,1)-img_wmk(:,:,1);
error_b = img_original(:,:,3)-img_wmk(:,:,3);
MSE = sum(sum(error_r.^2+error_g.^2+error_b.^2))/(totalpixels*3);
PSNR = 10.*log10((max_pixvalue.^2)/MSE);
