function [X_tu,X_tl,X_di,tu_ind,tl_ind,di_ind] = cognemo_splitmtx(X)
%% Preamble
%{
Splits a set of connectivity matrices into their upper and lower triangles,
leaving the other triangle as zeros. Both input and output remain
vectorized.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
X:=         N_o-by-N_c matrix where N_o is the number of observations and
            N_c is the number of variables. In our case the variables are
            connection strength parameters.
---------------------------------------------------------------------------
OUTPUT
---------------------------------------------------------------------------
X_tu:=      Matrix of same shape as X, but with the lower triangle of each
            row of vectorized matrices set to zeros.
X_tl:=      Matrix of same shape as X, but with the upper triangle of each
            row of vectorized matrices set to zeros.
tu_ind:=    1-by-N_c vector of 0s and 1s where 1s correspond to the 'upper
            triangle' indices
tl_ind:=    1-by-N_c vector of 0s and 1s where 1s correspond to the 'lower
            triangle' indices
di_ind:=    1-by-N_c vector of 0s and 1s where 1s correspond to the 
            'diagonal' indices 
%}
%%
N_c = size(X,2); N_r = sqrt(N_c);

% construct indices, for convenience
tu_mtx = triu(ones(N_r),1);  tu_ind = logical(reshape(tu_mtx,[1,N_c]));
tl_mtx = tril(ones(N_r),-1); tl_ind = logical(reshape(tl_mtx,[1,N_c]));
di_mtx = eye(N_r);           di_ind = logical(reshape(di_mtx,[1,N_c]));

% divide data
X_tu = zeros(size(X)); X_tu(:,tu_ind) = X(:,tu_ind);
X_tl = zeros(size(X)); X_tl(:,tl_ind) = X(:,tl_ind);
X_di = zeros(size(X)); X_di(:,di_ind) = X(:,di_ind);

end
    