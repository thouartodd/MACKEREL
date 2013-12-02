function W = train_ridge(x,y,lambda)
    
    % Fit L2-regularized mass-univariate GLM (ridge regression).
    %
    % USAGE: [ypred U] = fit_glm(x,y,[lambda])
    %
    % INPUTS:
    %   x - inputs
    %   y - outputs
    %   lambda (optional) - L2 regularization parameter (default: 0)
    %
    % OUTPUTS:
    %   W - weight matrix
    
    if nargin < 3
        lambda = 0; % regularization parameter
    end
    
    D = size(x,2);
    W = (x'*x + lambda*eye(D))\x'*y;