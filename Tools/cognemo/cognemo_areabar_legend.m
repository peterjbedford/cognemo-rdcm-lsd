function legax = cognemo_areabar_legend(dim,linespacing,fontsize)
%% Preamble
%{
%}
%% Define Colourmap

areastr = ["PFr" "Fr" "Ins" "Tem" "Par" "Occ" "SbC" "CeB" "Ver" "Bstem"];
areacolor = [[255 118 87];
             [255 198 109];
             [255 252 121];
             [140 239 195];
             [98 134 255];
             [156 198 255];
             [246 133 242];
             [226 93 154];
             [218 183 177];
             [148 91 53]]./255;

N_area = length(areastr);

%% Plot legend

figdim = get(gcf,'Position');

ywidth_pixels = figdim(4)*dim(4);
linewidth_points = linespacing*fontsize; pixels_points = 1;
linewidth_pixels = linewidth_points*pixels_points;
N_lines = floor(ywidth_pixels/linewidth_pixels);

ylim_u = dim(2)+dim(4); % normalized to figure


%areacolor = flip(areacolor); areastr = flip(areastr);

for j = 1:N_area
    ypos =  ylim_u - dim(4)*(j/N_lines);
    dim(2) = ypos;
    color = char(string(areacolor(j,1)) + "," + ...
                 string(areacolor(j,2)) + "," + ...
                 string(areacolor(j,3)));
    txtcol = ['{\color[rgb]{' color '} \bullet} '];
    txtlab = char(areastr(j));
    txt = [txtcol txtlab];
    annotation('textbox',dim,'String',txt,...
               'LineStyle','none',...
               'VerticalAlignment','bottom',...
               'Color','w','FontSize',fontsize);
end
