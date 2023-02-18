
clc;
clear;
PlotInitializeData;
prb       =  DPSetting;
Cycle     =  1;
MbunH     = 220;
EbndH     = 220;

% %------------------------ undersized torque ------------------------------%
checkfeas =  1;
flagmode  =  0;
p2w       =  105;
sf        =  PowerSolution(p2w,0);
mdl       =  ModelScale(ReadNominal,sf);
Pm(1)     =  0;
Pe(1)     =  max(mdl.eng.w.*mdl.eng.tm)/1000;
res       =  1;
HR        =  0;
while res == 1
	HR           = HR + 0.05;
	sf           = PowerSolution(p2w,HR);
	dem          = DriveTrain(Cycle,sf);
	mdl          = ModelScale(ReadNominal,sf);
	[res,~,~,~]  = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,flagmode,checkfeas);
end
sf     = PowerSolution(p2w,HR - 0.01);
mdl    = ModelScale(ReadNominal,sf);
Pm(2)  = max(mdl.mot.w.*mdl.mot.tm)/1000;
Pe(2)  = max(mdl.eng.w.*mdl.eng.tm)/1000;
%
%
% %--------------------- undersized energy ---------------------------------%
res       =  1;
nmdl      =  ReadNominal;
sf        =  ScaleSolution(MbunH,EbndH);

while res == 1
	sf.e         = sf.e - 0.1;
	dem          = DriveTrain(Cycle,sf);
	mdl          = ModelScale(ReadNominal,sf);
	[res,~,~,~]  = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,flagmode,checkfeas);
end
sf.e = sf.e + 0.1;
mdl    = ModelScale(ReadNominal,sf );
Pm(3)  = MbunH;
Pe(3)  = max(mdl.eng.w.*mdl.eng.tm)/1000;


%--------------------------plotting constant p2w lines--------------------%
hold on;
p2w  = 110:20:170;
for Ip2w = 1:length(p2w)
	sf  = PowerSolution(p2w(Ip2w),0);
	mdl = ModelScale(ReadNominal,sf);
	Pmm  = max(mdl.mot.w.*mdl.mot.tm)/1000;
	Pee  = max(mdl.eng.w.*mdl.eng.tm)/1000;
	
	for HrIndex = 0.5:0.01:1
		sf  = PowerSolution(p2w(Ip2w),HrIndex);
		mdl = ModelScale(ReadNominal,sf);
		if interp1(Pm, Pe, max(mdl.mot.w.*mdl.mot.tm)/1000)>max(mdl.eng.w.*mdl.eng.tm)/1000
			break;
		end
		Pmm  = [Pmm, max(mdl.mot.w.*mdl.mot.tm)/1000];
		Pee  = [Pee, max(mdl.eng.w.*mdl.eng.tm)/1000];
		
	end
	plot(Pmm,Pee,'Color','red','linestyle','--','linewidth',0.5);
	sf  = PowerSolution(p2w(Ip2w),0.5);
	mdl = ModelScale(ReadNominal,sf);
	Pmtext  = max(mdl.mot.w.*mdl.mot.tm)/1000;
	Petext  = max(mdl.eng.w.*mdl.eng.tm)/1000;
	text(Pmtext,Petext,[num2str(p2w(Ip2w)),' [W/kg]'],'HorizontalAlignment','center','VerticalAlignment','middle','Color',[29 102 29]/256,'FontSize',6)
end

%--------------------------plotting infeasible area-----------------------%
area([Pm Pm(end:-1:1)],[Pe, 0 0 0 ],'FaceColor',[204 204 204]/256,'LineWidth',0.5);


% %  creatin grids for design variables phase 3
mot_map = 0:Pm(end)/10:Pm(end);
for IM = 1:length(mot_map)
	EbndL = interp1(Pm, Pe, mot_map(IM),'linear');
	PeGrid{IM} = EbndL:(EbndH-EbndL)/10:EbndH;
end
xlim([0 Pm(end)]);

%  calculatiing fuel consumption
h = waitbar(0,'calculatiing fuel consumption on grid');
checkfeas = 0;
for IM = 1:length(mot_map)
	waitbar(IM/length(mot_map),h);
	for IE = 1:length(PeGrid{IM})
		sf = ScaleSolution(mot_map(IM),PeGrid{IM}(IE));
		dem          = DriveTrain(Cycle,sf);
		mdl          = ModelScale(ReadNominal,sf);
		[res,~,~,~]  = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,flagmode,checkfeas);
		GridFC{IM}(IE) = res.fc;
	end
end
delete(h);
eng_map = 0:1:EbndH;
for IM = 1:length(mot_map)
	FuelMat(IM,:) = interp1(PeGrid{IM}, GridFC{IM}, eng_map,'linear',NaN)*100000/dem.S;
end
[a,b] = contour( mot_map,eng_map, FuelMat',6.8:0.3:10,'linewidth',0.5,'LineColor','black');
clabel(a,b,'Color','blue', 'FontSize',6);
set(gca,'linewidth',0.5);
box on;
xlim([0 MbunH]);
ylim([0 EbndH]);
xlabel('Peak motor power [kW]');
ylabel('Peak ICE power [kW]');
set(gcf,'Color','white');
text(160,20,'Infeasible area');
title('Fuel economy [l/100km]/US06');

set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 9 6]);
print(gcf,'-dpng','-r300','US06');
PrintToImage(gcf, 'Figure 11-B', [9 6]);


