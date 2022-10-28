function class = cognemo_classcc(C,data,xset)
%% Preamble
%{
Performs classification on connectivity structure C with covariate
correction from vital parameter values in data (optional)
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
C:=     structure principally containing pdata.X, the 'preprocessed'
        versions of the datasets.
data:=  structure principally containing T, a N_o-by-1 vector of condition
        indices (boolean) which sort the data in X by condition.
xset:=  structure principally containing coptions, which contains settings
        for the classification procedure.
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
class:= structure containing the outputs of the classification procedure:
    class.time:=            time taken to complete classification
    class.coptions:=        settings
    class.ccout.SCORES:=    classification probabilities
    class.ccout.IMP:=       feature importances
    class.ccout.IDX_TE:=    index of 'test' datasets (in CV partition)
    class.ccout.T_TE:=      actual condition label for 'test' datasets
    class.ccout.T_pr:=      predicted condition label for 'test' datasets
    class.ccout.rates:=     performance measures
    class.ccout.m_conf:=    confidence matrices
    class.ccout.ROCx:=      x-values for ROC graph
    class.ccout.ROCy:=      y-values for ROC graph
    class.ccout.auc:=       area under the curve
    class.ccout.p:=         permutation test result
    class.ccout.IDX_TE_inv  sorted feature importances
    class.ccout.Tc:=        correct condition predictions
    class.ccout.Ti:=        incorrect condition predictions
    
%}
%%
coptions = xset.coptions;

class.ccoptions         = coptions;
class.ccoptions.N_tree  = floor(coptions.treestofeats*C.pdata.N_v);
class.ccoptions.cc.type = "const";
class.ccoptions.cc.V    = data.vital.V;
class.ccoptions.S       = data.S;

    class_start = tic;
[class.ccout.SCORES,...
 class.ccout.IMP,...
 class.ccout.IDX_TE,...
 class.ccout.T_TE] = cognemo_classRF(C.pdata.X,data.T,class.ccoptions);
    class.time = toc(class_start); clear class_start

% True performance
class.ccout.T_pr  = cognemo_score2class(class.ccout.SCORES,0.5);
class.ccout.rates = cognemo_CVrates(class.ccout.T_pr,...
                                    class.ccout.T_TE,...
                                    class.ccout.IDX_TE,...
                                    class.ccoptions);
                                   
% Confusion Matrix
[~,class.ccout.m_conf,~] = cognemo_classrates(class.ccout.T_pr,...
                                              class.ccout.T_TE,...
                                              class.ccout.IDX_TE,...
                                              class.ccoptions);
% ROC and AUC                                   
[class.ccout.ROCx,...
 class.ccout.ROCy,...
 ~,class.ccout.auc] = ...
 perfcurve(class.ccout.T_TE,class.ccout.SCORES,0);

% permutation test
class.ccout.p = cognemo_perm(class.ccout.T_pr,...
                             data.T,...
                             class.ccout.IDX_TE,...
                             class.ccout.rates,...
                             class.ccoptions);

% mcnemar test--need correct/incorrect
[~,class.ccout.IDX_TE_inv] = sort(class.ccout.IDX_TE,'ascend');
class.ccout.Tc = ...
    class.ccout.T_pr(class.ccout.IDX_TE_inv)' == data.T;
class.ccout.Ti = ...
    class.ccout.T_pr(class.ccout.IDX_TE_inv)' ~= data.T;

end