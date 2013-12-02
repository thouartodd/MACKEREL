function x = add_intercept(x)
    
    % Add intercept (column of 1's) to the left side of a matrix.
    %
    % USAGE: y = add_intercept(x)
    
    N = size(x,1);
    x = [ones(N,1) x];