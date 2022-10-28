% ** rDCM-Classification pipeline
% ** Part 2: Analysis

%% 1    TOOLS, DIRECTORIES, SOURCES

%  1.1  Add required tools

addpath('Tools/cognemo')

%  1.2  Output directory name

out_dir = 'Output_P2';
if not(isfolder(out_dir)); mkdir(out_dir); end

%  1.3 Supply source filenames

%  Input source
sources.in_dir = 'Output_P1';
%  Physiological correlate baseline measurement matrix (OPTIONAL)
sources.data.vital = 'vital1.mat';

%% 2    SETTINGS

%  2.2  User-chosen settings

uset.class.treestofeats = 1;       % ratio of N_trees to N_feats, for random forest
uset.class.N_perm       = 1000;    % number of permutations
uset.class.k            = 5;       % number of cross-validation folds

%  2.3  Data-specific settings

dset.label.cond0 = 'LSD';       % label for condition corresponding to 0
dset.label.cond1 = 'Placebo';   % label for condition corresponding to 1
dset.class.by_S  = 1;           % switch used for splitting up subjects 
                                % rather than datasets; needed when each
                                % subject is measured in two conditions

%  2.4  Extended settings

% t-test
xset.toptions.corr 	= "FDR"; % apply FDR correction for multiple comparisons
xset.toptions.alpha = 0.05; % alpha for ttests
% classification
xset.coptions.k            = uset.class.k;
xset.coptions.treestofeats = uset.class.treestofeats;
xset.coptions.N_perm       = uset.class.N_perm;
xset.coptions.by_S         = dset.class.by_S;
xset.coptions.mdl_labels   = ["RF"];
xset.coptions.condlabels   = [dset.label.cond0,dset.label.cond1];
xset.coptions.pm_labels    = ["ACC","SE","SP","BAC","PPV","NPV"];
cd(out_dir); save("xset.mat",'xset'); cd ..

%% 3    LOAD AND COLLECT DATA

%  3.1  Load and collect connectivity data into container

C = struct; Cnames = {};
if ~isempty(sources.in_dir)
    % Status message
    fprintf("Ready to run for the following:\n")
    % load
    cd(sources.in_dir)
    in_filenames = strsplit(ls('*.mat'));
    for i = 1:numel(in_filenames)
        if ~isempty(in_filenames{i})
            if contains(in_filenames{i},"C")
                Cnames{i} = erase(in_filenames{i},".mat");
                Csubs = load(in_filenames{i});
                C = setfield(C,Cnames{i},Csubs.(Cnames{i})); clear Csubs
                % Status message
                fprintf(Cnames{i}+"\n")
            else
                load(in_filenames{i});
            end
        end
    end; clear i in_filenames
    cd ..
else
    warning("Won't run anything. No connectivity data source found")
end

%  3.2  Load physiological correlate baseline measurement data (if supplied)

try load(sources.data.vital);
    data.vital = vital; clearvars vital
catch
    warning("(OPTIONAL) Won't run covariate correction. No vital parameter data source found")
end

%% 4    DATA PREP AND MASS-UNIVARIATE ANALYSIS

for i = 1:numel(Cnames)

    C.(Cnames{i}).inputname = Cnames{i};
    
    % 4.1 Data prep
    
    C.(Cnames{i}).pdata = cognemo_prepC(C.(Cnames{i}),data);
    
    % 4.2 Mass-univariate analysis
    
    C.(Cnames{i}) = cognemo_mass(C.(Cnames{i}),xset);
    
    % save
    savename = Cnames{i}+".mat";
    assignin('base',Cnames{i},C.(Cnames{i})); % create separate ws variable
    cd(out_dir); save(savename,Cnames{i}); cd .. ; clear savename ;
    clearvars(Cnames{i}); % delete separate ws variable
    
end; clear i

%% 5    CLASSIFICATION

for i = 1:numel(Cnames)
    
    % 4.1 Classification with covariate correction
    
    C.(Cnames{i}).class = cognemo_classcc(C.(Cnames{i}),data,xset);
    
    % save
    savename = Cnames{i}+".mat";
    assignin('base',Cnames{i},C.(Cnames{i})); % create separate ws variable
    cd(out_dir); save(savename,Cnames{i}); cd .. ; clear savename ;
    clearvars(Cnames{i}); % delete separate ws variable
    
end; clear i

%% END