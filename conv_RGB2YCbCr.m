% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

function [ YCbCr ] = conv_RGB2YCbCr( RGB )
%conv_RGB2YCbCr Convert RGB to YCbCr
%   Convert RGB to YCbCr

%   conversion in the paper
%     YCbCr(:,:,1)=0.299*RGB(:,:,1)+0.587*RGB(:,:,2)+0.114*RGB(:,:,3);
%     YCbCr(:,:,2)=0.596*RGB(:,:,1)-0.275*RGB(:,:,2)-0.321*RGB(:,:,3);
%     YCbCr(:,:,3)=0.212*RGB(:,:,1)-0.523*RGB(:,:,2)-0.311*RGB(:,:,3);
    RGB=double(RGB);
    
    YCbCr(:,:,1)=0 + 0.299*RGB(:,:,1)+0.587*RGB(:,:,2)+0.114*RGB(:,:,3);
    YCbCr(:,:,2)=128 - 0.168736*RGB(:,:,1)-0.331264*RGB(:,:,2)+0.5*RGB(:,:,3);
    YCbCr(:,:,3)=128 + 0.5*RGB(:,:,1) - 0.418688*RGB(:,:,2) - 0.081312*RGB(:,:,3);
    
    YCbCr=uint8(YCbCr);
end

