% ** rDCM-Classification pipeline
% ** Part 1: rDCM

%% 1    TOOLS, DIRECTORIES, SOURCES

%  1.1  Add required tools

addpath('Tools/cognemo')
addpath('Tools/TAPAS-rDCM/code')
addpath('Tools/TAPAS-rDCM/misc')

%  1.2  Output directory name

out_dir = 'Output_P1';
if not(isfolder(out_dir)); mkdir(out_dir); end

%  1.3  Source filenames

% BOLD datasets
sources.data.Yall   = 'data.mat';  % BOLD data
% Structural prior matrix (OPTIONAL)
sources.data.Ast    = 'Ast.mat';   % structural prior matrix

%% 2    SETTINGS

%  2.1  User-chosen settings

% [ these were chosen based on usage in previous studies ]
uset.rDCM.SNR = 3;      % signal-to-noise ratio
% ECsp (sparsity-optimization method)
uset.rDCM.p0_all = [0.25 0.3 0.35]; % prior for probability of presence
uset.rDCM.odds   = 0.1;             % threshold for posterior odds (for pruning)

%  2.2  Data-specific settings

dset.y_dt = 1.8; % BOLD time-step

%  2.3  Extended settings

xset.rDCM.alloptions.options.SNR  = uset.rDCM.SNR;
xset.rDCM.alloptions.options.y_dt = dset.y_dt;
        
%% 3    LOAD AND COLLECT DATA

%  3.1  Load BOLD data

if ~isempty(sources.data.Yall); load(sources.data.Yall);
else
    fprintf("Warning: Won't run any. Enter BOLD data source above \n")
    return
end

%  3.2  Load structural prior matrix (if suplied)

if ~isempty(sources.data.Ast); load(sources.data.Ast); data.Ast = Ast; clearvars Ast
else
    fprintf("Warning: (OPTIONAL) Won't run ECst. Enter structural prior matrix source above \n")
end
clearvars sources

%  3.3  Get condition and subject labels for datasets

[data.T,data.S] = cognemo_getTS(data.Yall);
cd(out_dir); save('data.mat','data'); cd .. ;

%% 4    FC

%  4.1 Get FC matrices
FC.rdata.X = cognemo_getFC(data);

%  save
cd(out_dir); save('FC.mat','FC'); cd .. ; clearvars FC;

%% 5    EC (fully connected)

%  5.1  Settings
EC.xset.rDCM.alloptions = xset.rDCM.alloptions;
EC.xset.rDCM.alloptions.est_method = 1;

%  5.2  Get EC matrices
EC.rdata.X = cognemo_getEC(data,EC);

% save
cd(out_dir); save('EC.mat','EC'); cd .. ; clearvars EC;

%% 6    ECst (structural prior method)

%  6.1  Settings
ECst.xset.rDCM.alloptions            = xset.rDCM.alloptions;
ECst.xset.rDCM.alloptions.est_method = 1;
ECst.xset.rDCM.alloptions.Ast        = data.Ast;

%  6.2  Get EC matrices
ECst.rdata.X = cognemo_getEC(data,ECst);

% save
cd(out_dir); save('ECst.mat','ECst'); cd .. ; clearvars ECst;

%% 7    ECsp (sparsity optimization method)

%  7.1  Settings
ECsp.xset.rDCM.alloptions = xset.rDCM.alloptions;
ECsp.xset.rDCM.alloptions.options.p0_all          = uset.rDCM.p0_all;
ECsp.xset.rDCM.alloptions.options.iter            = 100;
ECsp.xset.rDCM.alloptions.options.filter_str      = 5;
ECsp.xset.rDCM.alloptions.options.restrictInputs  = 1;
ECsp.xset.rDCM.alloptions.est_method = 2;
ECsp.xset.rDCM.alloptions.odds = uset.rDCM.odds;

%  7.2  Get EC matrices
ECsp.rdata.X = cognemo_getEC(data,ECsp);

% save
cd(out_dir); save('ECsp.mat','ECsp'); cd .. ; clearvars ECsp;

%% DONE