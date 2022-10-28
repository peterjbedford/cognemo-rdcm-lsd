function V_out = cognemolsd_importcovs_ba(excelfile,Yall)
%% Preamble
%{
This function extracts the covariate data from the excel file provided by
Felix "Vitalparameter-baseline". 
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
excelfile:=     the excel file which contains the physiological variable
                data.
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
V_out :=        A N_d-by-N_v matrix (N_d:=number of datasets required, 
                N_v:=number of variables) containing the data in the proper
                format to be handled by the classification script.
%}
%%
covs_raw = xlsread(excelfile);
%{
 PLA:   ID          sys         dia         HR          temp
        [47-91,1]   [47-91,3]   [47-91,4]   [47-91,5]   [47-91,6]
 LSD:   ID          sys         dia         HR          temp
        [47-91,1]   [47-91,9]   [47-91,10]  [47-91,11]  [47-91,12]
%}
obs = 47:91; No = 2*length(obs);

V(:,1) = zeros(No,1); % subject ID number
V(:,2) = zeros(No,1); % systolic BP
V(:,3) = zeros(No,1); % diastolic BP
V(:,4) = zeros(No,1); % heart rate
V(:,5) = zeros(No,1); % temperature

odds = [1:2:No-1];
evens = [2:2:No];
% Condition 1: LSD
V(odds,1) = covs_raw(obs,1);
V(odds,2) = covs_raw(obs,9);
V(odds,3) = covs_raw(obs,10);
V(odds,4) = covs_raw(obs,11);
V(odds,5) = covs_raw(obs,12);
% Condition 2: Placebo
V(evens,1) = covs_raw(obs,1);
V(evens,2) = covs_raw(obs,3);
V(evens,3) = covs_raw(obs,4);
V(evens,4) = covs_raw(obs,5);
V(evens,5) = covs_raw(obs,6);

%% Take only data for needed subjects

N_d = size(Yall,2);

V_out = ones(N_d,size(V,2)-1);
% store only data for included datasets
for i = 1:N_d
    subj_i = Yall{i}.subj;
    ind_i = find(V(:,1) == subj_i); ind_i = ind_i(1);
    V_out(i,:) = V(ind_i,2:size(V,2));
    V(ind_i,:) = [];
end

end