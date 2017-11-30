% Andre Gradim     - 76480
% Joao Pandeirada  - 76482 
% Patricia Martins - 69754 
% Pedro Martins    - 76374

function [change] =select_spiral(candidatos, params)
    change= zeros(params.nBlocks,2);
    
    sel_order = spiral(params.Width8);
    
    n_sel_blocks = 0;
    p=1;

    while (p< params.Width8^2 && n_sel_blocks < params.nBlocks)
        pos = find(sel_order==p);

        if( candidatos(pos) == 1)
            [x, y] = ind2sub(params.Width8, pos);
            change(n_sel_blocks + 1, :) = [x y];
            n_sel_blocks=n_sel_blocks+1;
        end

        p= p+1;
    end
    
    change= uint32(change);
end
