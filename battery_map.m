function battery_map
PlotInitializeData;
nmdl.bat = Safra;
hold on;
[AX,H1,H2]=plotyy(nmdl.bat.S,nmdl.bat.V/75,nmdl.bat.S,(3/75)*nmdl.bat.R*1000);
% area(AX(1),[0.3 0.7 0.7 0.3],[3.75 3.75 3.25 3.25],'FaceColor',[250 250 250 ]/256,'Linewidth',2)
% rectangle('parent',AX(1),'Position',[0.3 3.35 0.4 0.3],'Curvature',[0.4,0.4],'FaceColor',[212 208 200]/256);
set(H2,'LineStyle','--')
set(AX,'linewidth',2);
set(get(AX(1),'Ylabel'),'String','Voltage [v]');
set(get(AX(2),'Ylabel'),'String','Resistance[m\Omega]');
set(H1,'Color','black','linewidth',2);
set(H2,'Color','black','linewidth',2);
xlabel('SOC [-]');
box on;
plot(AX(1),nmdl.bat.S,nmdl.bat.V/75,'linewidth',2,'Color','black')
% legend('Volt','Resistance');
% xlim([0 1])
set(AX(2),'ActivePositionProperty','OuterPosition','YColor','black');
set(AX(1),'ActivePositionProperty','OuterPosition','YColor','black');
% ','Ylim',[0.009 0.015]
grid;
% text(0.5,3.6,'Primary Usage','HorizontalAlignment','Center')
% set(gcf,'Units','inches','Position',[4 4 3.69 2.5]);
m = get(AX(1),'Position');
% set(AX,'Position',[m(1) m(2) m(3)-0.05 m(4)])


end