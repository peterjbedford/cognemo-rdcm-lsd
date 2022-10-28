function [SCORES,IMP,IDX_TE,T_TE] = cognemo_classRF(X,T,options)
%% Preamble
%{
Performs classification of connectivity datasets X with covariate
correction from vital parameter values in data (optional)
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
X:=         the 'preprocessed' (de-zeroed) versions of the datasets.
T:=         a N_o-by-1 vector of condition indices (boolean) which sort the
            data in X by condition.
options:=   contains settings for the classification procedure
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
SCORES:=    classification probabilities
IMP:=       feature importances
IDX_TE:=    index of 'test' datasets (in CV partition)
T_TE:=      actual condition label for 'test' datasets
%}
%% unpack options

% Number of CV folds
k = 10;     % DEFAULT
if isfield(options,'k')
    k = options.k;
end

% whether or not to perform covariate correction
if isfield(options,'cc')
    type = options.cc.type;
    V    = options.cc.V;
end
%% prep

rng(1234)

% Create CV partition
cvp = cvpartition(T,'kFold',k);
if options.by_S
    % Create CV partition based on subjects
    S = options.S; S_u = unique(S);
    cvp = cvpartition(S_u,'kFold',k);
end

% Create banks for prediction scores and feature importance
[N_o,N_c] = size(X); n_te = floor(N_o / k);
SCORES = zeros(1,N_o);
IMP    = zeros(k,N_c);
IDX_TE = zeros(1,N_o);

%% CV loop

if ~isfield(options,'cc')
    % if there is no covariate correction to be done
    for l = 1:k
        idx_l = (1 + (l-1)*n_te):(l*n_te);
        
        idx_tr = find(training(cvp,l)); idx_te = find(test(cvp,l));
 
        X_tr = X(idx_tr,:); X_te = X(idx_te,:);
        T_tr = T(idx_tr);   T_te = T(idx_te);

        % CLASSIFICATION
        mdl        = cognemo_RFtrain(X_tr,T_tr,options);
        [~,score0] = cognemo_RFtest(mdl,X_te);
        
        % EXTRACT IMPORTANT FEATURES
        imp = mdl.OOBPermutedPredictorDeltaError;
        
        % SAVE
        SCORES(idx_l) = score0;
        IMP(l,:)      = imp;
        IDX_TE(idx_l) = idx_te;
        T_TE(idx_l)   = T_te;
        
        clear idx_tr idx_te X_tr X_te T_tr T_te ...
              mdl score0 imp
    end  
else
    % if there is covariate correction to be done
    for l = 1:k
        idx_l = (1 + (l-1)*n_te):(l*n_te);
        
        if options.by_S
            S_tr = S_u(training(cvp,l));
            S_te = S_u(test(cvp,l));
           
            idx_tr = ismember(S,S_tr);
            idx_te = ismember(S,S_te);
        else
            idx_tr = find(training(cvp,l)); idx_te = find(test(cvp,l));
        end
        
        X_tr = X(idx_tr,:); X_te = X(idx_te,:);
        T_tr = T(idx_tr);   T_te = T(idx_te);
        
        % COVARIATE CORRECTION
        V_tr = V(idx_tr,:); V_te = V(idx_te,:);
        [beta,E_tr] = cognemo_cctrain(X_tr,V_tr,type);
        E_te        = cognemo_cctest(X_te,V_te,beta,type);
        
        % CLASSIFICATION
        mdl        = cognemo_RFtrain(E_tr,T_tr,options);
        [~,score0] = cognemo_RFtest(mdl,E_te);
        
        % EXTRACT IMPORTANT FEATURES
        imp = mdl.OOBPermutedPredictorDeltaError;    
        
        % SAVE
        SCORES(idx_l) = score0;
        IMP(l,:)      = imp;
        
        size(idx_l)
        sum(idx_te)
        IDX_TE(idx_l) = find(idx_te);
        T_TE(idx_l)   = T_te;
        
        clear idx_tr idx_te X_tr X_te T_tr T_te V_tr V_te E_tr E_te beta ...
              mdl score0 imp 
    end  
end

end