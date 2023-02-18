% clear;
PlotInitializeData;
% prb = DPSetting;
% C = 14;
% checkFeas = 0;
% mode = 1;
% dri = ReadDrivingCycle(C);
% sf.e = 1; sf.m =1; sf.b =1;
% gn = GearSelector(dri);
% dem            = DriveTrain(C,sf);
% mdl            = ModelScale(ReadNominal,sf);
% QQ = mdl.bat.Q;
% [res,dypg,~,~]= DynamicProgramming(@BatteryDynamic,prb,mdl,dem,mode,checkFeas);
% mdl.bat.Q = 2*QQ;
% [res2,~,~,~]    = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,mode,checkFeas);
% mdl.bat.Q = 3*QQ;
% [res3,~,~,~]    = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,mode,checkFeas);


%-------------------------------------------------------------------------%
% h1 = axes;
% area(dri.v*3.6,'FaceColor',[212 208 200]/256,'linestyle','none');
% set(h1,'Color','white','YAxisLocation','right');
% xlim(h1, [0 1800]);
% box on;
% xlabel('Time [s]');
% ylabel('V [km/h]');
% h2 = axes;
% hold on;
% plot(res.X,'linewidth',0.5,'Color','blue');
% plot(res2.X,'linewidth',0.5,'Color','red');
% plot(res3.X,'linewidth',0.5,'Color','green');
% a= legend('12 [Ah]' , '24 [Ah]', '36 [Ah]');
% set(a, 'Box', 'off','Color', 'none');
% ylim([0.35 0.55]);
% hold off;
% set(h2,'Color','none');
% xlim(h2, [0 1800]);
% % ylim([0.4 0.7])
% box on;
% set(h2,'linewidth',0.5);
% ylabel('SOC');
% xlabel('Time [s]');
% % set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 16 10]);
% xlimits = get(h1,'XLim');
% ylimits = get(h1,'YLim');
% xinc = (xlimits(2)-xlimits(1))/2;
% yinc = (ylimits(2)-ylimits(1))/2;
% set(h1,'YTick',[ylimits(1):yinc:ylimits(2)]);
% xlimits = get(h2,'XLim');
% ylimits = get(h2,'YLim');
% xinc = (xlimits(2)-xlimits(1))/2;
% yinc = (ylimits(2)-ylimits(1))/2;
% set(h2,'YTick',[ylimits(1):yinc:ylimits(2)]);
% set(h1, 'Position',[0.14 0.13 0.75 0.82]);
% set(h2, 'Position',[0.14 0.13 0.75 0.82]);
% % print(gcf,'-dpng','-r300','SOC');
% PrintToImage(gcf, 'Figure 6', [8.5 6]);

%-------------------------------------------------------------------------%
% figure;
% Th = axes;
% C= hsv();
% C=circshift(C,49+46)
% C(end,:)=[]
% C(end,:)=[]
% C(end,:)=[]
% C(end,:)=[]
% C(end,:)=[]
% hold on;
% colormap(C);
% Mat = Mapmaker(res,dypg);
% surf(Mat.t,Mat.X,Mat.U','LineStyle','none');
% t=0:1:length(res.X)-1;
% plot3(t,res.X,[res.U NaN],'linewidth',1,'Color','black');
% xlim([0 1800]);
% ylim([0.3 0.7]);
% xlabel('Time [s]');
% ylabel('SOC');
% box on;
% set(gca,'linewidth',0.5);
% set(gca, 'Position', [0.13 0.28 0.78 0.7],'YTick',[0.3 0.5 0.7],'YTickLabel',{'0.3','0.5','0.7'},'XTick',[0 600 1200 1800],...
%     'XTickLabel',{'0','600','1200','1800'});
% m = colorbar('Location','SouthOutside','Xlim',[-1 1],'XTick',[-1 0 1],'XTickLabel',...
%     {'Recharge/Brake','ICE/Brake', 'EM/Regen.'});
% set(m,'Position',[0.13 0.08 0.78 0.08]);
% % set(gca, 'clim', [0 0.5]);
% 
% set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 8.5 7]);
% print(gcf,'-dpng','-r600','Figure 8');
% PrintToImage(gcf, 'Figure 8', [8.5 7]);
%-------------------------------------------------------------------------

figure;
Lim = [0 1800];
subplot(6,1,1)
plot(dri.t,dri.v*3.6,'linewidth',0.5,'Color','blue');
box on;
ylabel({'Speed',' Profile [km/h]'});
xlim(Lim);
% set(gca,'XTick',[0 300 600 900 1200 1500 1800],'XTicklabel',{'0', '300', '600', '900', '1200', '1500', '1800'});

subplot(6,1,2)
hold on;
plot(res.R(:,1),'linewidth',0.5,'Color','blue');
plot(res.R(:,3),'linewidth',0.5,'Color','red');
plot(dem.T,'linewidth',0.5,'Color','green');
box on;
ylabel('Torque [N.m]');
a = legend('Engine','Motor','Demand');
set(a, 'Box', 'off','Color', 'none', 'orientation','horizontal');
xlim(Lim);
subplot(6,1,3)
hold on;
plot(res.R(:,2),'linewidth',0.5,'Color','blue');
plot(res.R(:,4),'--','linewidth',0.5,'Color','red');
a = legend('Engine','Motor');
% set(a, 'Box', 'off','Color', 'none','position',[0.16 0.57 0.2 0.1],'orientation','horizontal');
set(a, 'Box', 'off','Color', 'none','orientation','horizontal');
box on;
ylabel('Speed [rad/s]');
xlim(Lim);

subplot(6,1,4)
plot(res.R(:,5)/1000,'linewidth',0.5,'Color','blue');
box on;
ylabel({'Battery', 'power [kW]'});
xlim(Lim);

subplot(6,1,5)
plot(res.R(:,9),'linewidth',0.5,'Color','blue');
box on;
ylabel('Fuel flow [g/s]');
xlim(Lim);

subplot(6,1,6)
plot(gn,'linewidth',0.5,'Color','blue');
box on;
xlabel('Time [s]');
ylabel('Gear number');
xlim(Lim);
PrintToImage(gcf, 'Figure 9', [17 20]);
%-------------------------------------------------------------------------%
% clc;
% % Create Color Map %
% figure;
% A= hot();
% A= A(end:-1:1,:);
% B= jet();
% B= B(end:-1:1,:);
% ClrMap= [A ; B];
% colormap(ClrMap);
% mdl= ModelScale(ReadNominal,sf);
% 
% 
% 
% % Draw Primary Propulsion Histogram %
% res.R(res.R(:,1)== 0,1) = NaN;
% hist3(res.R(:,[2,1]),[50 50]);
% Frq = hist3(res.R(:,[2,1]),[50 50]);
% view([-45 45])
% set(get(gca,'child'),'FaceColor','interp','CDataMapping', 'scale', 'CDataMode', 'auto');
% h= get(gca,'child');
% zdata = get(h,'ZData');
% 		
% 		
% 		% Remove Column From Draw %
% 		for i=1:size(Frq,1)
% 		for j=1:size(Frq,2)
% 			
% 			if (Frq(i,j)==0)
% 				
% 				% Remove Up & Down Vertex %
% 				zdata(5*(i-1)+[1:5],5*(j-1)+[1:5])= NaN;
% 				zdata(5*(i-1)+[1:5],5*(j-1)+[1:5])= NaN;
% 			end
% 		end
% 		end
% 		
% 		set(h,'ZData', zdata);
% 
% set(gca, 'clim', [0 130])
% 
% 
% hold on;
% Wvector = mdl.eng.w(2):5:mdl.eng.w(end);
% Tvector = mdl.eng.t(2):5:mdl.eng.t(end);
% T = interp1(mdl.eng.w,mdl.eng.tm,Wvector);
% 
% % Draw Engine Full Trottle Torque Curve %
% plot3(Wvector,T,zeros(1,length(Wvector)),'linewidth',0.5,'Color','black'); 
% 
% 
% % Draw Torque Curve Border Line %
% TMin= min(Tvector);
% TMin= 0;
% 
% plot3([Wvector(1) Wvector(1)],[TMin T(1)],zeros(1,2),'linewidth',0.5,'Color','black'); 
% plot3([Wvector(end) Wvector(end)],[TMin T(end)],zeros(1,2),'linewidth',0.5,'Color','black'); 
% plot3([Wvector(1) Wvector(end)],[TMin TMin],zeros(1,2),'linewidth',0.5,'Color','black'); 
% 
% xlabel('Speed [rad/s]');
% ylabel('Torque [N.m]');
% zlabel('Operation Frequency [%]');
% grid;
% ylim([TMin max(Tvector)+4]);
% xlim([min(Wvector) max(Wvector)]);
% view(-20, 60);
% view(-45, 45);
% 
% XL= xlim;
% YL= ylim;
% % ZL= zlim;
% ZL= [0 60];
% plot3([XL(1) XL(2)],[YL(2) YL(2)],zeros(1,2),'linewidth',0.5,'Color','black'); 
% plot3([XL(2) XL(2)],[YL(1) YL(2)],zeros(1,2),'linewidth',0.5,'Color','black'); 
% plot3([XL(2) XL(2)],[YL(2) YL(2)],[ZL(1) ZL(2)],'linewidth',0.5,'Color','black'); 
% plot3([XL(1) XL(2)],[YL(2) YL(2)],[ZL(2) ZL(2)],'linewidth',0.5,'Color','black'); 
% plot3([XL(2) XL(2)],[YL(1) YL(2)],[ZL(2) ZL(2)],'linewidth',0.5,'Color','black'); 
% plot3([XL(2) XL(2)],[YL(1) YL(1)],[ZL(1) ZL(2)],'linewidth',0.5,'Color','black'); 
% 
% % Draw Efficiency Contour In XY Plane %
% 
% set(gca, 'Color', 'None')
% hHist= gca;
% hContour= copyobj(gca,gcf);
% 
% % colormap(hHist, 'Copper')
% % colormap(hContour, 'HSV')
% 
% axis(hContour)
% % figure
% 
% W= mdl.eng.w(2:end);
% T= mdl.eng.t;
% Tm = mdl.eng.tm(2:end);
% E= mdl.eng.eff(:,2:end);
% cnt = ContourCorrecter(W, T, Tm, E, 0, 'Engine');
% h = pcolor(cnt.W, cnt.T, cnt.E);
% 
% set(h, 'EdgeColor', 'None')
% 
% Emax= max(max(E));
% Emin= min(min(E));
% 
% CL = [Emax- 2*(Emax- Emin)-15 Emax];
% set(gca, 'clim', CL);
% set(gca, 'clipping', 'on');
% % zlim(ZL);
% 
% % set(gcf,'PaperUnit','centimeters');
% set(gcf,'Color','white');
% set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 8.5 7]);
% print(gcf,'-dpng','-r300','Figure 7');
% PrintToImage(gcf, 'Figure 7', [8.5 7]);
