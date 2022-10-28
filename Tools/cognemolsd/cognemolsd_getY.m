function Y = cognemolsd_getY(names,data,conditionweights,y_dt,identifier)
%% Preamble
%{
This function handles the data structure (specifically the one from Felix)
returning the rs-fMRI time series necessary for rDCM.

---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
names:=         the list of ROI names provided in each of Felix' datasets
identifier:=    a char/string which indicates inclusion of an ROI
                > for original Felix data, identifier = 'atlas'
                > for Harvard Felix data, identifier = 'Atlas'
data:=          the BOLD data provided in the datasets
y_dt:=          the repetition time
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
Y:=             the fMRI data, in a form required for rDCM analysis
%}
%%

% this bit added Feb 22 on Daniel's suggestion
idx = find( conditionweights{1}>0 );
data_r = cellfun(@(x)x(idx,:), data, 'uni',0);
    
% Get data from proper regions
N_n = length(names);
%{
the following seems inefficient because better functions are unavailable in
R2016a (SCC)
%}
namesid = strfind(names,identifier);
I_r = [];
for i_n=1:N_n
    if ~isempty(cell2mat(namesid(i_n)))
        I_r = [I_r i_n];
    end
end
names_r = names(I_r); N_r = length(I_r);
y_r = data_r(I_r);

% Prep input for DCM specification
Y.y = cell2mat(y_r);
Y.dt = y_dt;        %TR--repetition time
Y.name = names_r;
end
