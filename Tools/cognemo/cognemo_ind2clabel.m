function clabel = cognemo_ind2clabel(ind,names,options)
%% Preamble
%{
Applies combined roi labels to indices ind to give connection labels.
---------------------------------------------------------------------------
INPUTS
---------------------------------------------------------------------------
ind:=               indices in linear form (1,N_v)
names:=             string array of names, raw from Y.name
options.exstr:=     a string which is to be stripped from all of the names
options.length:=    "short"=only allowed characters for tables etc;
                    else=no change
---------------------------------------------------------------------------
OUTPUTS
---------------------------------------------------------------------------
clabel:=            the names of the connections indicated by the indices
                    ind
%}
%%
N_r = length(names);
n = length(ind);

% convert indices from vector to indices in matrix
[row,col]=ind2sub([N_r,N_r],ind);

roirow = string(ones(1,n)); roicol = string(ones(1,n));
middle = "\leftrightarrow";
if options.dir
    middle = "\rightarrow";
end

takeout = [];
if isfield(options,'exstr')
    takeout = [takeout options.exstr];
end
if isfield(options,'length') && options.length == "short"
    takeout = [takeout " " "," "-"];
end


for i_n = 1:n
    if ~isempty(takeout)
        roirow(i_n) = erase(string(names(:,row(i_n))),takeout);
        roicol(i_n) = erase(string(names(:,col(i_n))),takeout);
    end
    if isfield(options,'length') && options.length == "short"
        roirowb4bkt = split(roirow(i_n),"(");
        roicolb4bkt = split(roicol(i_n),"(");
        roirow(i_n) = roirowb4bkt(1);
        roicol(i_n) = roicolb4bkt(1);
    end
end
clabel = roicol + middle + roirow;
clabel = erase(clabel," ");

end