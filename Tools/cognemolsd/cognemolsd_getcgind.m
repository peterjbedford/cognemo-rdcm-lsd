function cg_ind = cognemolsd_getcgind(rlabel_ind)
%% Preamble
%{
Reorders regions around ring according to anatomy, cgplot requirements
%}
%%
N_r = size(rlabel_ind);
cg_ind = ones(N_r);

N_r25 = floor(0.25*N_r); N_r75 = N_r - N_r25;
% first quarter becomes last quarter
cg_ind(N_r75+1:N_r) = rlabel_ind(1:N_r25);
% last 3/4 becomes first 3/4
cg_ind(1:N_r75) = rlabel_ind(N_r25+1:N_r);

end