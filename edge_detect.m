function [I_BW] = edge_detect(I_gray)

% perform edge detection using sobel filter
% Basically, we apply two kernels in x and y direction separately.
% Sx = [-1 -2 -1; 0 0 0; 1 2 1]
% Sy = [-1 0 1; -2 0 2; -1 0 1]

[m, n] = size(I_gray);
Ix = zeros(m, n);
Iy = zeros(m, n);

% apply filter to the image element by element
% Note that we divide calculated derivate by 8 to achieve normalization
for i = 2:m-1
    for j = 2:n-1
        Ix(i, j) = (I_gray(i+1, j-1)-I_gray(i-1, j-1)...
            +2*I_gray(i+1, j)-2*I_gray(i-1, j)...
            +I_gray(i+1, j+1)-I_gray(i-1, j+1))/8;
        Iy(i, j) = (I_gray(i-1, j+1)-I_gray(i-1, j-1)...
            +2*I_gray(i, j+1)-2*I_gray(i, j-1)...
            +I_gray(i+1, j+1)-I_gray(i+1, j-1))/8;
    end
end

I_BW = sqrt(Ix.*Ix + Iy.*Iy);

threshold = max(max(I_BW)) * 0.6;

[m, n] = size(I_BW);
for i = 1:m
    for j = 1:n
        if I_BW(i, j) <= threshold
            I_BW(i, j) = 0;
        end
    end
end

end

