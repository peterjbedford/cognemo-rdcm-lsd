function xset = cognemolsd_importtab(filename,xset,uset)
%% Preamble
%{
Extracts information from 'Trlabel.xlsx' excel file:
- reordered ROI indices, for displaying connectograms according to anatomy
- ROI 'area' labels, for excluding areas from output (e.g. Occipital)
%}
%%
% Extract new indices for connectogram plots
label_T = readtable(filename);
rlabel_ind = table2array(label_T(:,1));
xset.cgp.ind = cognemolsd_getcgind(rlabel_ind);
xset.cgp.label = xset.cgp.label(xset.cgp.ind);
% labels of region-areas
xset.label.arealabel = table2array(label_T(:,3));
[~,arealabel_ind] = sort(rlabel_ind,'ascend');
xset.label.arealabel = string(xset.label.arealabel(arealabel_ind,:));
% indices of excluded regions (due to excluded areas)
xset.area_ex.r_ind = []; xset.area_ex.label = uset.area_ex.label;
for i = 1:length(uset.area_ex.label)
    xset.area_ex.r_ind = [xset.area_ex.r_ind; ...
                          find(xset.label.arealabel==xset.area_ex.label(i))];
end
N_r = length(rlabel_ind); N_c = N_r*N_r;
c_ind = zeros(N_r); 
c_ind(xset.area_ex.r_ind,:) = 1; c_ind(:,xset.area_ex.r_ind) = 1;
xset.area_ex.c_ind = logical(reshape(c_ind,[1,N_c]));

end