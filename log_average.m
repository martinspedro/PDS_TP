function [ im_ave_lum ,block_ave_lum ] = log_average( Y, params )
%LOG_AVERAGE Calculate the log average of the image and for each block
    Y=double(Y(:,:,1));
    im_ave_lum = exp(sum(sum(log(params.delta+Y(:,:)))/params.N));
    
    block_ave_lum= zeros(params.Width8);
    for i = 1: params.Width8
        for j =1: params.Width8
            block_ave_lum(i,j) = exp(sum(sum(log(params.delta+Y(8*i-7:8*i,8*j-7:8*j)))/64));
        end
    end
end

