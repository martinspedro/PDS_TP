% André Gradim     - 76480
% João Pandeirada  - 76482
% Patrícia Martins - 69754
% Pedro Martins    - 76374

%% Test script for log-average
% image= imread('thor.jpg');
% image= imread('circle.jpg');
image= imread('black.jpg');
figure
imshow(image);

% ycbcr= rgb2ycbcr(image);
ycbcr= conv_RGB2YCbCr(image);
% 
figure
imshow(ycbcr);

params.Width=size(image,1);
params.N=size(image,1)^2;
params.Width8=params.Width/8;
params.delta = 0.0001;

[average_im, block_average] = log_average(ycbcr(:,:,1),params);

average_im



image_final = conv_YCbCr2RGB(ycbcr);
% image_final = ycbcr2rgb(ycbcr);

figure
imshow(image_final);
