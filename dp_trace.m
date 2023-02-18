function dp_trace
clc;
clear;
PlotInitializeData;
load('trajectory');

PlotInitializeData;
% main axes creation
hold on;
box on;
set(gcf,'Units','inches','Position',[4 4 3.5 2.5]);

main = gca;
line([0,362],[0.3 0.3],'LineStyle','-.','Linewidth',0.5,'Color',[27 79 53]/256);
line([0,362],[0.7 0.7],'LineStyle','-.','Linewidth',0.5,'Color',[27 79 53]/256);
plot(res.X,'linewidth',0.5);
for k=1:length(res.X)-2
    line([k k+1],[min(dypg.XI{k}) min(dypg.XI{k+1})],'linewidth',0.5,'color','green')
end
for k=1:1:length(res.X)-1
    if ~isempty(bnd.X.l{k}) && ~isempty(bnd.X.l{k+1})
        line([k k+1],[bnd.X.l{k} bnd.X.l{k+1}],'color','red','linewidth',0.5);
    end
end
for k=1:1:length(res.X)-1
    if ~isempty(bnd.X.h{k}) && ~isempty(bnd.X.h{k+1})
        line([k k+1],[bnd.X.h{k} bnd.X.h{k+1}],'color','red','linewidth',0.5);
    end
end
xlabel('Time index [k]'); ylabel('State variable');
set(gca,'linewidth',0.5,'XLim',[0 length(res.X)],'Ylim',[0.28 0.72],'YTick',[0.3 0.5 0.7],...
'XTick',[0 363],'XTickLabel',{'0','N'},'ActivePositionProperty','Position','YTick',0.5,'YTickLabel','  ');
rectangle('Parent',main,'Position',[350,0.48,13,0.04],'LineStyle','-','linewidth',0.5);
hold off;


% creat focused area
zhdl = axes;
box on;
hold on;
bnd.X.l{1,361} = bnd.X.l{1,362} - 0.000001;  
set(zhdl,'position',[0.4 0.71 0.2 0.2],'linewidth',0.5);
for k=1:1:length(res.X)-1
    if ~isempty(bnd.X.l{k}) && ~isempty(bnd.X.l{k+1})
        line([k k+1],[bnd.X.l{k} bnd.X.l{k+1}],'color','red','linewidth',0.5,'parent',zhdl);
    end
end
for k=1:1:length(res.X)-1
    if ~isempty(bnd.X.h{k}) && ~isempty(bnd.X.h{k+1})
        line([k k+1],[bnd.X.h{k} bnd.X.h{k+1}],'color','red','linewidth',0.5,'parent',zhdl);
    end
end
plot(zhdl,362*ones(1,3),dypg.XI{1,362}([70 150 230]),'o','MarkerEdgeColor','black',...
                'MarkerFaceColor','black',...
                'MarkerSize',1.5);  
plot(zhdl,[362 363],[dypg.XI{1,362}(70) 0.5],'LineStyle','--','linewidth',0.5)
plot(zhdl,[362 363],[dypg.XI{1,362}(150) 0.5],'LineStyle','--','linewidth',0.5)
plot(zhdl,[362 363],[dypg.XI{1,362}(230) 0.5],'LineStyle','--','linewidth',0.5)
            
set(zhdl,'XLim',[length(res.X)-1.5 length(res.X)],'YLim',[0.49997 0.500005],...
    'XTick',[362 363],'YTick',[],'YTickLabel','x_0','XTickLabel','');


text(361.56,dypg.XI{1,362}(150),'x_N_-_1^i','Interpreter','tex','parent',zhdl...
    );


hLine(1)= line([1 1],[1 1],'LineStyle','--','Color','black','Parent',main);
hLine(2)= line([1 1],[1 1],'LineStyle','--','Color','black','Parent',main);
hLine(3)= line([1 1],[1 1],'LineStyle','--','Color','black','Parent',main);

set(gcf, 'ResizeFcn', @(Src, Event) ResizeFCN(Src, Event, zhdl, main, hLine));
hR=get(gcf, 'ResizeFcn'); hR(gcf, []);

text(305,0.33,{'Terminal constraint',' violation'},'Interpreter','tex','parent',main,'HorizontalAlignment','Center','Fontsize',7);
text(220,0.585,{'N'},'Interpreter','tex','parent',main,'HorizontalAlignment','Center','Fontsize',7,'Color','r');
text(170,0.585,{'N-1'},'Interpreter','tex','parent',main,'HorizontalAlignment','Center','Fontsize',7,'Color','r');
annotation('textarrow',[0.65,0.75],[0.4 0.35], 'String','Lower BL','Fontsize',7,'HeadWidth',5,'HeadLength',5)
annotation('textarrow',[0.79,0.75],[0.76 0.83], 'String','Upper BL','Fontsize',7,'HeadWidth',5,'HeadLength',5)
annotation('textarrow',[0.41,0.5],[0.4 0.2], 'String',{'Inequality',' constraints violation'},'Fontsize',7,'HeadWidth',5,...
    'HeadLength',5,'HorizontalAlignment','Center')

annotation('textbox',[0.07 0.48 0.1 0.1],'String','x_0','LineStyle','none','Fontsize',7);
annotation('textbox',[0.89 0.48 0.1 0.1],'String','x_f','LineStyle','none','Fontsize',7);

annotation('textbox',[0.04 0.83 0.1 0.1],'String','X_m_a_x','LineStyle','none','Fontsize',7);
annotation('textbox',[0.04 0.12 0.1 0.1],'String','X_m_i_n','LineStyle','none','Fontsize',7);

PrintToImage(gcf, 'Figure 5', [8.5 6]);
close all;
end

function ResizeFCN(Src, Event, zhdl, main, hLine)

ZhdlPos = get(zhdl,'position');
MainPos = get(main,'position');

CoefX = 363/(MainPos(3));
CoefY = 0.44/(MainPos(4));

A = [(ZhdlPos(1) - MainPos(1))*CoefX, (ZhdlPos(2) - MainPos(2))*CoefY + 0.28];
B = [(ZhdlPos(1) + ZhdlPos(3)- MainPos(1))*CoefX, (ZhdlPos(2) - MainPos(2))*CoefY + 0.28];
C = [(ZhdlPos(1) + ZhdlPos(3)- MainPos(1))*CoefX, (ZhdlPos(2) + ZhdlPos(4)- MainPos(2))*CoefY + 0.28];


set(hLine(1), 'XData', [350, A(1)]);
set(hLine(1), 'YData', [0.48, A(2)]);

set(hLine(2), 'XData', [350 B(1)]);
set(hLine(2), 'YData', [0.48 + 0.04,  B(2)]);

set(hLine(3), 'XData', [350+13, C(1)]);
set(hLine(3), 'YData', [0.48 + 0.04,  C(2)]);


end




