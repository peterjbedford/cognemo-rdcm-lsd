function X = cognemo_getFC(data)
%%
%{
Computes the functional connectivity matrix as the pearson
correlation of the BOLD signals between pairs of regions.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
data.Yall:=      cell of BOLD structs with Y = {Y.y, Y.dt, Y.name, Y.cond,
                 Y.subj}
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
X:=              matrix containing vectorized correlation matrices
%}
%%
Yall = data.Yall;

N_d = size(Yall,2);
N_r = size(Yall{1,1}.y,2);
N_c = N_r*N_r;

X = zeros(N_d,N_c);

for i=1:N_d
    clear yi Si Xi
    
    % Compute FC
    yi = Yall{1,i}.y;
    Si = std(yi);
    Xi = cov(yi)./(Si'*Si);
    
    % Reshape
    X(i,:) = reshape(Xi,[1,N_c]);
end

end