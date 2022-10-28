function rates = cognemo_CVrates(T_pr,T_TE,IDX_TE,options)
%% Preamble
%{
Computes performance measures for classification accuracy over a CV
partition set, outputting the average over the CV folds.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
T_pr:=      predicted target labels for test sets (different set for each
            CV fold in the partition)
T_TE:=      actual target labels for test sets (different set for each
            CV fold in the partition)
IDX_TE:=    indices of test sets (different set for each CV fold in the
            partition)
options:=   settings related to the CV partition (i.e. k, number of folds)
            and types of performance measures (pm_labels)
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
rates:=     matrix containing performance measure values averaged over CV
            folds
%}
k = options.k;
N_pm = length(options.pm_labels);
rates = zeros(1,N_pm);
n_te = floor(90/k);
for l = 1:k
    ind_l = (1 + (l-1)*n_te):(l*n_te);
    rates = rates + cognemo_classrates(T_pr(ind_l),...
                                       T_TE(ind_l),...
                                       IDX_TE(ind_l),...
                                       options);
end
rates = rates/k;
end