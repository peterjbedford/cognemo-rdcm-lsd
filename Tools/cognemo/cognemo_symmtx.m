function Xsym = cognemo_symmtx(X,method)
%% Preamble
%{
Turns vectorized matrix X into a symmetrical vectorized matrix, created in 
one of two ways determined by 'method'.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
X:=         N_o-by-N_c matrix where N_o is the number of observations and
            N_c is the number of variables. In our case the variables are
            connection strength parameters.
method:=    integer (must be 1 or 2) which should be set to 1 or 2 if X
            represents FC or EC, respectively
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
Xsym:=      N_o-by-N_c matrix which is a copy of X except, in the case of:
                method = 1: the upper or lower triangle input is added to
                            its conjugate (copying across diagonal)
                method = 2: the full-matrix input is added to
                            its conjugate and divided by 2 (averaging
                            across diagonal)
%}
%%
N_o = size(X,1);
N_c = size(X,2); N_r = sqrt(N_c);

Xsym = zeros(N_o,N_c);

for i = 1:N_o
    Xi = X(i,:);
    Xmtx = reshape(Xi,[N_r,N_r]);
    Xsymmtx = Xmtx + Xmtx';
    if method == 1
        % for when input is a triu or tril
        Xsym(i,:) = reshape(Xsymmtx,[1,N_c]);
    elseif method == 2
        % for when input is an asymmetrical matrix--gives average across triu,
        % tril
        Xsym(i,:) = reshape(Xsymmtx./2,[1,N_c]);
    else
        Xsym(i,:) = Xi;
    end
end
end