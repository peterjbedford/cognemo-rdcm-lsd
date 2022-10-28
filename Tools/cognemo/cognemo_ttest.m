function toutput = cognemo_ttest(X0,X1,toptions)
%% Preamble
%{
Performs a ttest across conditions for a matrix of vectorized connectivity
matrices.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
X0:=        condition-0 datasets from X, the N_o-by_N_v matrix of
            vectorized connectivity matrices (N_o:= number of observations,
            N_v:= number of variables after dezeroing)
X1:=        condition-1 datasets from X
toptions:=  options (or 'settings') for the t-test analysis
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
toutput:=   structure containing:
    toutput.h:=         1-by-N_v vector flagging indices of significant
                        variables (dezeroed)
    toutput.p:=         1-by-N_v vector of p-values
    toutput.tstat:=     1-by-N_v vector of t-statistic values (where h=1)
    toutput.sd:=        1-by-N_v vector of std of the difference
                        (where h=1)
    toutput.hc:=        1-by-N_v vector flagging indices of significant
                        variables, correcting for multiple comparisons 
                        (dezeroed)
    toutput.crit_p:=    adjusted critical value (i.e. variables for which 
                        unadjusted p-values do not exceed crit_p are
                        significant)
    toutput.adj_p:=     1-by-N_v vector of p-values adjusted after multiple
                        comparisons correction
%}
%%
% Split dataset into observations in condition 1, condition 2
alpha = 0.05;
if isfield(toptions,'alpha')
    alpha = toptions.alpha;
end
[toutput.h,toutput.p,~,stats] = ttest(X0,X1,'alpha',alpha);
toutput.tstat = stats.tstat;
toutput.sd    = stats.sd;
if isfield(toptions,'corr') && (toptions.corr == "FDR")
    % FDR correction for multiple comparisons
    [toutput.hc,toutput.crit_p,~,toutput.adj_p] = fdr_bh(toutput.p);
end
end
