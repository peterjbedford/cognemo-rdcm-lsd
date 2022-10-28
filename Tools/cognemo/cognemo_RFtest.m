function [T_pr,score0] = cognemo_RFtest(mdl,X_te)
%% Preamble
%{
Predicts target labels (T_pr) for test data (X_te) using a classification
model (mdl). 
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
mdl:=   classification model (an object produced by MATLAB's classification
        functions e.g. TreeBagger)
X_te:=  connectivity datasets in the test group; a matrix of size
        N_te-by-N_v (N_te:= number of test datasets)
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
T_pr:=      predicted target labels for the input datasets; boolean vector 
            of length N_te
score0:=    the probability that each dataset belongs to target group 0 
            (score0 > 0.5 assigns target label 0, score0 < 0.5 assigns
            target label 1)--changing the threshold is useful for ROC
            curves
%}
%% predict values and scores

[T_pr,score] = predict(mdl,X_te);
score0 = score(:,1);

end