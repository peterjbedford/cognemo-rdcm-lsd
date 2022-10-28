function X = cognemo_getEC(data,C)
%% Preamble
%{
Computes effective connectivity, using rDCM, for BOLD data in Yall, with
settings in alloptions.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
data.Yall:=     cell of BOLD structs with Y = {Y.y, Y.dt, Y.name, Y.cond,
                Y.subj}
C:=             connectivity structure containing settings in
                C.xset.rDCM.alloptions.
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
X:=             matrix containing vectorized EC matrices

%}
%%
Yall = data.Yall; alloptions = C.xset.rDCM.alloptions;

N_d = size(Yall,2);
N_r = size(Yall{1,1}.y,2);
N_c = N_r*N_r;

X   = zeros(N_d,N_c);

for i=1:N_d
    clear Yi output Ai Vi
    
    % select Y
    Yi = Yall{1,i};
    
    % Estimate EC parameters
    [~,output,~] = cognemo_getEC_rDCM(Yi,alloptions);
    
    A = output.Ep.A; Vi = reshape(A,[1,N_c]);
    if output.inversion == "tapas_rdcm_sparse"
        % get inferred connections
        Ip_est  = tapas_rdcm_ep2par(output.Ip); % probability of connections
        Ip_est  = Ip_est(1:N_c);                % only values for A matrix
        lb      = log(odds);
        idx_nIp = log(Ip_est./(1-Ip_est)) < lb;
        Vi(idx_nIp) = 0;
    end
    X(i,:) = Vi;
end
end