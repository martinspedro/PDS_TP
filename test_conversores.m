% André Gradim     - 76480
% João Pandeirada  - 76482
% Patrícia Martins - 69754
% Pedro Martins    - 76374

%% Test Script for conversion functions
image= imread('thor.jpg');
% image= imread('circle.jpg');
figure
imshow(image);

% ycbcr= rgb2ycbcr(image);
ycbcr= conv_RGB2YCbCr(image);
% 
figure
imshow(ycbcr);

% image_final = conv_YCbCr2RGB(ycbcr);
image_final = ycbcr2rgb(ycbcr);

figure
imshow(image_final);

