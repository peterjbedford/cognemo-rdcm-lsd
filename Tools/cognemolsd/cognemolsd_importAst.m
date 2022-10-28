function Ast = cognemolsd_importAst(Afilename)
%%
%{
This function imports a structural connectivity matrix from an excel table
%}
%%
Ast = xlsread(Afilename);
Ast = logical(Ast);

end