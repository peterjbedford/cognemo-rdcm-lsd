function T_pr = cognemo_score2class(SCORES,th)
%% Preamble
%{
Converts classification scores (probabilities that test datasets belong to
target label group 0) to the corresponding target label.
The natural threshold (th) to use would be 0.5, but this can be varied.
Ties are assigned randomly.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
SCORES:=    classification scores (probabilities that test datasets belong
            to target label group 0); vector of length N
th:=        threshold probability (i.e. if SCORE>th, then this index is
            assigned target label 0--see first three lines of code)
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
T_pr:=      predicted target labels; vector of length N
%}
%% 
ind0 = SCORES>th;
ind1 = SCORES<th;
indt = SCORES==th;

%randomly assign target labels to indices that have score==th
ties = randi([0,1],size(find(indt)));

T_pr = zeros(size(SCORES));
T_pr(ind0) = 0;
T_pr(ind1) = 1;
T_pr(indt) = ties;

end