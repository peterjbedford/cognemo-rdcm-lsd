function pdata = cognemo_prepC(C,data)
%% Preamble
%{
Creates condensed versions of the connectivity data by eliminating
variables which are zero across all datasets, and in the case of FC, taking
advantage of symmetry by eliminating all but the upper triangle matrices.It
also computes means and stds for each condition and symmetrical versions of
the connectivity data for the purpose of plotting later.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
C:=     structure principally containing rdata.X, a N_o-by-N_c matrix of
        'unprepared' (raw data--hence 'rdata' vs 'prepared'--'pdata)
        vectorized connectivity matrices. Receives a 'symmethod'--depending
        on whether the connectivity is EC or FC, this tells the script to
        average across the diagonal or to copy across the diagonal, 
        respectively.
data:=  structure principally containing T, a N_o-by-1 vector of condition
        indices (boolean) which sort the data in X by condition.
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
pdata:= structure containing:
    pdata.X:= condensed, zero-less version of X (size N_o-by-N_v)
    pdata.N_v:= number of variables after de-zeroing
    pdata.N_c:= number of variables before de-zeroing (number of connections)
    pdata.f_ind:= 1-by-N_c vector flagging indices of nonzero variables
    pdata.X0:= pdata.X, but only condition-0 data sets
    pdata.X0_f:= a 'full' version of pdata.X0 (i.e. N0-by-N_c)
    pdata.MX0:= dataset-wise mean of X0 
    pdata.MX0_f:= a 'full' version of pdata.MX0 (i.e. N0-by-N_c)
    pdata.MX0_f_sym:= a 'forced symmetrical' version of pdata.MX0_f
    pdata.SX0:= dataset-wise std of X0
    pdata.SX0_f:= a 'full' version of pdata.SX0 (i.e. N0-by-N_c)
    pdata.SX0_f_sym:= a 'forced symmetrical' version of pdata.SX0_f
    following the pattern of the last 8 lines, but for condition-1 are:
        pdata.X1, pdata.X1_f, pdata.MX1, pdata.MX1_f, pdata.MX1_f_sym, 
        pdata.SX1, pdata.SX1_f, pdata.SX1_f_sym 
%}
%% Prepare data for analysis

Xin = C.rdata.X; T = data.T;

[~,N_c] = size(Xin);

if C.inputname == "FC"
    % get only triu off-diag
    [Xin_tu,~,~,~,~,~] = cognemo_splitmtx(Xin);
    % eliminate all-zero connections
    [Xin_dz,~,nz_f_ind,~,~] = cognemo_dezero(Xin_tu);
    % copy lower to upper triangle for symmetry
    C.xset.symmethod = 1;
else
    % eliminate all-zero connections
    [Xin_dz,~,nz_f_ind,~,~] = cognemo_dezero(Xin);
    % average across upper triangle for symmetry
    C.xset.symmethod = 2;
end

f_ind = nz_f_ind;
% data to be used in analysis
X = Xin_dz; N_v = size(X,2);
X0 = X(~T,:); X1 = X(T,:);

% 'full' vectors (i.e. all connections have an entry)
X0_f = zeros(length(find(~T)),N_c); X0_f(:,f_ind) = X0;
X1_f = zeros(length(find(T)),N_c);  X1_f(:,f_ind) = X1;

%% Means, stds

MX0 = mean(X0,1); MX1 = mean(X1,1);
SX0 = std(X0,1);  SX1 = std(X1,1);

% 'full' vectors (i.e. all connections have an entry)
MX0_f = zeros(1,N_c); MX0_f(f_ind) = MX0;
MX1_f = zeros(1,N_c); MX1_f(f_ind) = MX1;
SX0_f = zeros(1,N_c); SX0_f(f_ind) = SX0;
SX1_f = zeros(1,N_c); SX1_f(f_ind) = SX1;

% 'full' vectors, symmetrical for plotting
MX0_f_sym = cognemo_symmtx(MX0_f,C.xset.symmethod);
MX1_f_sym = cognemo_symmtx(MX1_f,C.xset.symmethod);
SX0_f_sym = cognemo_symmtx(SX0_f,C.xset.symmethod);
SX1_f_sym = cognemo_symmtx(SX1_f,C.xset.symmethod);

%% Package output

pdata.X = X; pdata.N_v = N_v; pdata.N_c = N_c;
pdata.f_ind = f_ind;
pdata.X0 = X0; pdata.X0_f = X0_f;
pdata.MX0 = MX0; pdata.MX0_f = MX0_f; pdata.MX0_f_sym = MX0_f_sym;
pdata.SX0 = SX0; pdata.SX0_f = SX0_f; pdata.SX0_f_sym = SX0_f_sym;
pdata.X1 = X1; pdata.X1_f = X1_f;
pdata.MX1 = MX1; pdata.MX1_f = MX1_f; pdata.MX1_f_sym = MX1_f_sym;
pdata.SX1 = SX1; pdata.SX1_f = SX1_f; pdata.SX1_f_sym = SX1_f_sym;

end
