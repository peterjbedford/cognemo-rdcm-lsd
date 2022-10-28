function tstat = cognemo_tstat(X0,X1,N_c,f_ind,toptions)
%% Preamble
%{
Wraps a comparison by t-test and packages pertinent output data and info.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
X0:=        condition-0 datasets from X, the N_o-by_N_v matrix of
            vectorized connectivity matrices (N_o:= number of observations,
            N_v:= number of variables after dezeroing)
X1:=        condition-1 datasets from X
N_c:=       Number of variables before dezeroing
f_ind:=     1-by-N_c vector flagging indices of nonzero variables
toptions:=  options (or 'settings') for the t-test analysis
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
tstat:=     structure containing output from the t-test analysis:
    tstat.MXD:= mean of the difference across conditions (dezeroed)
    tstat.MXD_f:= mean of the difference across conditions (un-dezeroed)
    tstat.MXD_f_sym:= 'forced symmetrical' mean of the difference across
        conditions (un-dezeroed
    following the pattern above, but for:
        std of the difference across conditions:
            tstat.SXD, tstat.SXD_f, tstat.SXD_f_sym
        t-statistic of the difference across conditions:
            tstat.TXD, tstat.TXD_f, tstat.TXD_f_sym
    tstat.sig.sig_ind:= 1-by-N_v vector flagging indices of significant
        variables (dezeroed)
    tstat.sig.sig_f_ind:= 1-by-N_c vector flagging indices of significant
        variables (un-dezeroed)
    tstat.sig.N_v_sig:= number of variables which were statistically
        significant
    tstat.sig.percent_sig:= percent of variables which were statistically
        significant (out of N_v)
%}
%% Perform t-test of difference and collect results

% perform tstat
[MXD,SXD,TXD,sig_ind] = cognemo_compare(X0,X1,toptions);

% proportion of statistically-significantly-different connections
N_v         = size(X0,2);
N_v_sig     = size(sig_ind,2);
percent_sig = N_v_sig / N_v;
% indices of significant connections (just upper triangle)
sig_f_ind = zeros(1,N_c);
ind = find(f_ind); sig_up_ind = ind(sig_ind);
sig_f_ind(sig_up_ind) = 1; sig_f_ind = logical(sig_f_ind);

% 'full' vectors (i.e. all connections have an entry)
MXD_f = zeros(1,N_c); MXD_f(sig_f_ind) = MXD;
SXD_f = zeros(1,N_c); SXD_f(sig_f_ind) = SXD;
TXD_f = zeros(1,N_c); TXD_f(sig_f_ind) = TXD;

% 'full' vectors, symmetrical for plotting
MXD_f_sym = cognemo_symmtx(MXD_f,1);
SXD_f_sym = cognemo_symmtx(SXD_f,1);
TXD_f_sym = cognemo_symmtx(TXD_f,1);

%% Package output

tstat.MXD = MXD; tstat.MXD_f = MXD_f; tstat.MXD_f_sym = MXD_f_sym;
tstat.SXD = SXD; tstat.SXD_f = SXD_f; tstat.SXD_f_sym = SXD_f_sym;
tstat.TXD = TXD; tstat.TXD_f = TXD_f; tstat.TXD_f_sym = TXD_f_sym;
tstat.sig.sig_ind = sig_ind; tstat.sig.sig_f_ind = sig_f_ind;
tstat.sig.N_v_sig = N_v_sig;
tstat.sig.percent_sig = percent_sig;

end
