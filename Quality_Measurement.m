function [value] = Quality_Measurement(wmk_original,wmk_extracted)
    s = (wmk_original==wmk_extracted);
    wmk_size = numel(wmk_original);
    value = sum(sum(s))/wmk_size;
end

