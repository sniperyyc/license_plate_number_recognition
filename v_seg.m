function row = v_seg(im,borders)
%%
% The function takes in the plate image and the horizontal boundaries of
% digits and outputs the vertical boundaries of each digit.
% Basically, it uses the same idea of the segment.m but changes the
% direction.

%%
    n = length(borders) - 1;
    [r,~] = size(im);
    row = ones(1,2);
    start_threshold = 0.08 * (borders(2) - borders(1));
    % set the top boundary
    for i = 1:r
        weight = sum(im(i,floor(borders(1)):floor(borders(2))));
        if (weight > start_threshold)
            row(1) = floor((i+1)/2);
            break;
        end
    end
    % set the bottom boundary
    for i = r:-1:1
        weight = sum(im(i,floor(borders(1)):floor(borders(2))));
        if (weight > start_threshold)
            row(2) = floor((i+r)/2);
            break;
        end
    end
    
end