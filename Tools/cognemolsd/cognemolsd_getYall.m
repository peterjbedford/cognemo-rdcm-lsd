function Yall = cognemolsd_getYall(dataloc,xset)
%% Preamble
%{
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
dataloc:=       a char/string of the folder path
y_dt:=          TR; time interval for BOLD series
                > for LSD data, y_dt = 1.8
identifier:=    a char/string which indicates inclusion of an ROI
                > for LSD data, identifier = 'Atlas'
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
Yall:=          a cell which consists of structs Y = Y.y, Y.dt, Y.names

%}
%%

y_dt = xset.BOLD.y_dt; identifier = xset.BOLD.identifier;

fnames = cognemo_unpack_data(dataloc);
fnames = sort(split(fnames));
fnames = fnames(fnames~="");
N_f = length(fnames);
Yall = cell(1,N_f);
varnames = {'names','data','conditionname','conditionweights'};

cd(dataloc)
for i=1:N_f
    clearvars(varnames{:})
    
    % Load Data File
    datasetfile = char(fnames(i));
    load(datasetfile,varnames{:})
    
    % Prepare Y = {Y.y, Y.dt, Y.names}
    Yall{i} = cognemolsd_getY(names,data,conditionweights,...                          
                                y_dt,identifier);
    % Condition for dataset
    Yall{i}.cond = string(conditionname) == "Placebo";
    
    % Subject ID for dataset
    Yall{i}.subj = str2num(datasetfile(28:29));
                        
end
cd ..

end