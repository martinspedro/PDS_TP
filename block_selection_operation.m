% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

function [ matrix_boleana_candidatos ] = block_selection_operation( average_luminance_8x8,params )
    matrix_boleana_candidatos = average_luminance_8x8 > params.averageLuminance;
end

