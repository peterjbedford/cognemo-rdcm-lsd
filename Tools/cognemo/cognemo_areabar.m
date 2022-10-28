function barax = cognemo_areabar(top,top_ind,options)
%% Preamble
%{

%}
%% Extract options

arealabel = options.arealabel;
arrow = '\leftrightarrow'; if options.dir == 1   arrow = '\rightarrow'; end
areacolors = options.areacolors;
areastr = options.areastr;

%% Bar colour

pcolor = [255 181 0]./255; ncolor = [0 201 239]./255;

%% Draw fig

N_top = length(top);
N_r = length(arealabel);

barax = axes();
hold on

%% Plot loop

top = flip(top); top_ind = flip(top_ind);

% do neat x-axis limits
decplace = ceil(abs(log10(max(abs(top)))));
if log10(max(abs(top))) > 0     decplace = -decplace;   end
xlim_u   = round(max(abs(top)),decplace);

xlim_l = 0;
if ~isempty(find(top<0))    xlim_l = -xlim_u;   end
xlim([xlim_l,xlim_u]);

for i = 1:N_top
    % set bar colour according to directionality
    facecolor = pcolor; if top(i) < 0   facecolor = ncolor;     end
    % set face colour according to area
    [to_ind, from_ind] = ind2sub([N_r,N_r],top_ind(i));
    from_area = arealabel(from_ind); to_area = arealabel(to_ind);
    from_color = areacolors((areastr == from_area),:);
    to_color = areacolors((areastr == to_area),:);
    bar_i = barh(i,top(i),'FaceColor',facecolor,'EdgeColor','none');
    
    from_colorstr = char(string(from_color(1)) + "," + ...
                    string(from_color(2)) + "," + ...
                    string(from_color(3)));
    to_colorstr   = char(string(to_color(1)) + "," + ...
                    string(to_color(2)) + "," + ...
                    string(to_color(3)));
    str = ['{\color[rgb]{' from_colorstr '}\bullet}' arrow '{\color[rgb]{' to_colorstr '}\bullet} '];
    text(xlim_l,bar_i.XData+0.3,str,'HorizontalAlignment','right',...
        'VerticalAlignment','middle','Color','w','FontSize',12,'FontWeight','bold','Interpreter','TeX')
end

%% Edit plot style

set(gca,'color','k','box','on','LineWidth',1,...
        'ytick',[],'xcolor','w','ycolor','w','TickDir','in')
%{
if legendon
    for j = 1:length(areastr)
        ypos = N_top-3*(j-1); xpos = xlim_u;
        color = char(string(areacolor(j,1)) + "," + ...
                      string(areacolor(j,2)) + "," + ...
                      string(areacolor(j,3)));
        txtcol = ['{\color[rgb]{' color '} \bullet} '];
        txtlab = char(areastr(j));
        txt = [txtcol txtlab];
        text(xpos,ypos,txt,'Color','w','FontSize',18);
    end
end
%}

end