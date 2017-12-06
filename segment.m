function [x1, x2, y1, y2] = segment(plate)
%%
% The function will output the coordinates(matlab) for all the segmented
% characters or digits.
% Input: the extracted plate image
% Output: the four coordinates vector for the segmented digits
% Basically, we record the start position of a digit, and set a pass flag
% when its weight is great than the white threshold. 
% Finally, we record the end position of a digit when it passes the start_threshold.
% 

%%

[r,c] = size(plate);
start_point = 0;
front_edge = 0;
pass_flag = 0;
front_set_flag = 0;
white_threshold = 0.1 * r;
blank_threshold = 1;
start_threshold = 0.02 * r;
start_points = [];
width = [];
for i = 1:c
    white_weight = sum(plate(:,i));
    
    if ~pass_flag
        % set the pass_flag
        if white_weight > white_threshold
            pass_flag = 1;
        end
    else
        if ~front_set_flag
            % set the front edge between two digits when its weight is
            % greater than the blank_threshold
            if white_weight < blank_threshold
                front_edge = i;
                front_set_flag = 1;
            end
        else
            % set the back_edge between the two digits when its weight is
            % greater than the start_threshold and reset the parameters to
            % restart the process
            if white_weight > start_threshold || i == c
                back_edge = i - 1;
                width_i = ((back_edge + front_edge) / 2 - start_point);
                %center_i = start_point + width_i / 2; 
                width = [width width_i];
                start_points = [start_points start_point];
                
                start_point = (back_edge + front_edge) / 2;
                
                pass_flag = 0;
                front_set_flag = 0;
            end
        end
    end
end
% set the front boundary of the first digit
if length(start_points) > 2
    for i = 1:start_points(2)
       white_weight = sum(plate(:,i));
       if white_weight > start_threshold
            start_points(1) = (i + 1) / 2;
            break;
       end
    end
end
% set the back boundary of the last digit
pass_flag = 0;
if length(start_points) > 2
    for i = floor(start_points(end)):c
        white_weight = sum(plate(:,i));
        if ~pass_flag
            % set the pass_flag
            if white_weight > white_threshold
                pass_flag = 1;
            end
        else
            if white_weight < blank_threshold
                start_points = [start_points, i];
                break;
            end
        end
    end
end
%% debug output  
% for i = 1:length(start_points)
%     plate(:,floor(start_points(i)+1)) = 1;
% end
% for i = 1:length(start_points)-1
%     v_cut = v_seg(plate, [start_points(i), start_points(i+1)]);
%     plate(v_cut(1),floor(start_points(i)):floor(start_points(i+1))) = 1;
%     plate(v_cut(2),floor(start_points(i)):floor(start_points(i+1))) = 1;
% end
% figure;imshow(plate);
%%
x1 = zeros(length(start_points) - 1,1);
x2 = zeros(length(start_points) - 1,1);
y1 = zeros(length(start_points) - 1,1);
y2 = zeros(length(start_points) - 1,1);
% send the boundary information to the v_seg function which outputs the
% vertical boundaries
for i = 1:length(start_points) - 1
    x1(i) = max(floor(start_points(i)),1);
    x2(i) = floor(start_points(i+1));
    v_cut = v_seg(plate, [max(start_points(i),1), start_points(i+1)]);
    y1(i) = v_cut(1);
    y2(i) = v_cut(2);
end