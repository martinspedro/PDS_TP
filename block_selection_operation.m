function [ matrix_boleana_candidatos ] = block_selection_operation( average_luminance_8x8,params )
    matrix_boleana_candidatos = average_luminance_8x8 > params.averageLuminance;
end

