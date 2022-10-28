function [MDXkeep,SDXkeep,tstatkeep,keep_ind] = cognemo_compare(X0,X1,toptions)
%% Preamble
%{
Wraps a comparison of connectivity by t-test and outputs
means, stds, t-statistic values, and indices of statistically significant
variables.
toptions contains a setting 'n' which limits the number of 
'kept' variables (replacing 'p' in the role of filtering) if the number of
statistically significant variables exceeds 'n'. If n is unspecified, the
'kept' variables are those whose p values do not exceed toptions.alpha
(which is alpha=0.05 by default)
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
MDXkeep:=   mean of the difference across conditions
SDXkeep:=   std of the difference across conditions
tstatkeep:= t-statistic of the difference across conditions
keep_ind:=  1-by-N_v vector flagging indices of kept variables (dezeroed)
%}
%% Default n_keep 

n = size(X0,2);
if isfield(toptions,'n')
    n = toptions.n;
end

%% Mean, std

DX = X0 - X1; % (+) implies increased EC in Condition 0 than in Condition 1
MDX = mean(DX,1); SDX = std(DX,1);

%% Significance

toutput = cognemo_ttest(X0,X1,toptions);
% t-values
tstat   = toutput.tstat;
% h=1 if null rejected, h=0 if not
h = toutput.h;
if isfield(toutput,'hc')
    % change to corrected version if indicated
    h = toutput.hc;
end
% choose output to keep
if length(find(h)) <= n
    % choose top values if provided n_keep is less than number significant
    keep_ind = find(h);
else
    % otherwise, must take those that are 'most' significant
    tstath = tstat(h);
    [~,t_sort_ind] = sort(abs(tstath),'descend');
    keep_ind_unsort     = t_sort_ind(1:n);
    [keep_ind,~]        = sort(keep_ind_unsort,'ascend');
end

tstatkeep = tstat(keep_ind);
MDXkeep = MDX(keep_ind); SDXkeep = SDX(keep_ind);

end