function [T,S] = cognemo_getTS(Yall)
%% Preamble
%{
Gets condition (T) and subject (S) labels for datasets in Yall.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
Yall:=  cell of BOLD structs with Y = {Y.y, Y.dt, Y.name, Y.cond,Y.subj}
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
T:=     vector containing condition labels for the datasets (boolean)
S:=     vector containing subject labels for the datasets (integers)

%}
%%
N_d = size(Yall,2);

T = zeros(N_d,1); S = zeros(N_d,1);
for i = 1:N_d
    T(i) = Yall{1,i}.cond;
    S(i) = Yall{1,i}.subj;
end

T = logical(T);

end