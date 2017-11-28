function [ imagem_com_watermark ] = watermark_embedding( original_image, original_watermark, xy, params)
    
    
    sizeWM=size(original_watermark(:,:,1));
    sizexy=size(xy);
    imagem_com_watermark=double(original_image);
    teta=params.alpha/127;
    
    for i=1:sizexy(1)
        
        y=ceil(i/(sizeWM(2)/8));
        x=i-(y-1)*(sizeWM(2)/8);
        
        imagem_com_watermark(xy(i,1)*8-7:xy(i,1)*8,xy(i,2)*8-7:xy(i,2)*8,1)= ...
        double(original_image(xy(i,1)*8-7:xy(i,1)*8,xy(i,2)*8-7:xy(i,2)*8,1))+...
        (double(original_watermark((y*8-7):(y*8),(x*8-7):(x*8),1))-127).*teta;
    end
    
    imagem_com_watermark=uint8(imagem_com_watermark);
    
end

