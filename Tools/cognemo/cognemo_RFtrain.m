function mdl = cognemo_RFtrain(X,T,options)
%% Preamble
%{
Trains a random forest classification model (mdl) given 
training data X (datasets) and T (target labels).
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
X:=         connectivity datasets; matrix of size N_tr-by-N_v (tr=training sets)
T:=         target labels corresponding to the connectivity datasets; vector of
            length N_tr
options:=   settings for the classification (including N_tree:= the ratio
            of the number of trees to the number of features
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
mdl:=       a structure containing MATLAB's random forest model output (see
            TreeBagger documentation for a detailed list of the output 
            items)
%}
%% unpack options

% number of trees in forest
N_tree = 100; % DEFAULT
if isfield(options,'N_tree')
    N_tree = options.N_tree;
end

%% train model

mdl = TreeBagger(N_tree,X,T,...
                'Method','classification',...
                'PredictorSelection','curvature',...
                'OOBPredictorImportance','on');
            
end