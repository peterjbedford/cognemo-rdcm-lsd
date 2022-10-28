function labelall = cognemolsd_getlabelall(names,options)
%% Preamble
%{
%}
%%

N_r = length(names);
N_c = N_r*N_r;

%% Region Labels
% long form
rlabel.long.options = options;
rlabel.long.options.length = "long";
rlabel.long.label = cognemo_ind2rlabel(1:N_r,names,rlabel.long.options);
% short form
rlabel.short.options = options;
rlabel.short.options.length = "short";
rlabel.short.label = cognemo_ind2rlabel(1:N_r,names,rlabel.short.options);

%% Connection Labels
% long form, undirected
clabel.long.options = options; clabel.long.options.dir = 0;
clabel.long.options.length = "long";
clabel.long.label = cognemo_ind2clabel(1:N_c,names,clabel.long.options);
% short form, undirected
clabel.short.options = options; clabel.short.options.dir = 0;
clabel.short.options.length = "short";
clabel.short.label = cognemo_ind2clabel(1:N_c,names,clabel.short.options);
% long form, directed
clabeldir.long.options = options; clabel.long.options.dir = 1;
clabeldir.long.options.length = "long";
clabeldir.long.label = cognemo_ind2clabel(1:N_c,names,clabel.long.options);
% short form, directed
clabeldir.short.options = options; clabel.short.options.dir = 1;
clabeldir.short.options.length = "short";
clabeldir.short.label = cognemo_ind2clabel(1:N_c,names,clabel.short.options);
%% Prepare output

labelall = {rlabel, clabel, clabeldir};

end