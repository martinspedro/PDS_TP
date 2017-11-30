% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

function [value] = Quality_Measurement(wmk_original,wmk_extracted)
    s = (wmk_original==wmk_extracted);
    wmk_size = numel(wmk_original);
    value = sum(sum(s))/wmk_size;
end

