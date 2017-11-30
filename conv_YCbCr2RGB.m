% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

function [ RGB ] = conv_YCbCr2RGB( YCbCr )
%conv_RGB2YCbCr Convert RGB to YCbCr
%   Convert RGB to YCbCr

%   conversion in the paper
%     RGB(:,:,1)=YCbCr(:,:,1)+0.956*YCbCr(:,:,2)+0.620*YCbCr(:,:,3);
%     RGB(:,:,2)=YCbCr(:,:,1)-0.272*YCbCr(:,:,2)-0.647*YCbCr(:,:,3);
%     RGB(:,:,3)=YCbCr(:,:,1)-1.108*YCbCr(:,:,2)+1.705*YCbCr(:,:,3);
    YCbCr=double(YCbCr);

    RGB(:,:,1)=YCbCr(:,:,1)+0*YCbCr(:,:,2)+1.402*(YCbCr(:,:,3)-128);
    RGB(:,:,2)=YCbCr(:,:,1)-0.344136*(YCbCr(:,:,2)-128)-0.714136*(YCbCr(:,:,3)-128);
    RGB(:,:,3)=YCbCr(:,:,1)+1.772*(YCbCr(:,:,2)-128)+0*YCbCr(:,:,3);
    
    RGB=uint8(RGB);
end

