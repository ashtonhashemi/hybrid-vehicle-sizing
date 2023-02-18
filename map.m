function map
	
	clc;
	clear;
	PlotInitializeData;
	mdl.eng = AdvisorComaptEng('FC_SI95');
	mdl.mot = MC_PRIUS_JPN;
	%-------------------------------------%
	engfc = axes;
	hold on;
	cnt = ContourCorrecter(mdl.eng.w(2:end), mdl.eng.t(2:end), mdl.eng.tm(2:end), mdl.eng.fc_g_kwh(2:end,2:end), 0, 'Engine');
	[Cx,h]=contour(engfc, cnt.W,  cnt.T , cnt.E ,[650 500 400 350 325 300 280 260 250 245 240],'LineWidth',0.5);
		colormap('Lines');
	plot(engfc, mdl.eng.w(2:end) , mdl.eng.tm(2:end) ,'--','linewidth',0.5,'color','black');
	clabel(Cx,h,'LabelSpacing',1672,'FontSize',6);
	xlabel('Speed (rad/s)');
	ylabel('Engine torque (N.m)');
	a=legend(engfc,'BSFC(g/kWh)','Max torque');
	set(a, 'Box', 'off','Color', 'none');
	set(engfc,...
		'linewidth',0.5,'XLim',[min(mdl.eng.w(2:end)) max(mdl.eng.w)],...
		'YLim',[min(mdl.eng.t(2:end)) max(mdl.eng.t)+30]);
	box on; hold off;
% 	set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 16 12]);
% 	print(gcf,'-dpng','-r300','Engine');
PrintToImage(gcf, 'Figure 4-A', [8.5 6]);
	close all;
	%-------------------------------------%
	figure;
	motfc = axes;
	hold on;
	cnt = ContourCorrecter(mdl.mot.w, mdl.mot.t, mdl.mot.tm, mdl.mot.eff, -mdl.mot.tm, 'Motor');
	[Cx,h]=contour(motfc, cnt.W,  cnt.T , cnt.E ,'LineWidth',0.5);
	plot(motfc, mdl.mot.w, mdl.mot.tm,'--','linewidth',0.5,'color','black');
	plot(motfc, mdl.mot.w, -mdl.mot.tm,'--','linewidth',0.5,'color','black');
	clabel(Cx,h,'LabelSpacing',300,'FontSize',6);
	colormap('Lines');
	xlabel('Speed (rad/s)');
	ylabel('Electric machine torque (N.m)');
	a=legend(motfc,'Efficiency','Limit torque');
	set(a, 'Box', 'off','Color', 'none');
	set(motfc,...
		'linewidth',0.5,'XLim',[min(mdl.eng.w(2:end)) max(mdl.eng.w)],...
		'YLim',[-max(mdl.mot.t)-10 max(mdl.mot.t)+10]);
	box on; hold off;
% 	set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 16 12]);
% 	print(gcf,'-dpng','-r400','Motor');
PrintToImage(gcf, 'Figure 4-B', [8.5 6]);
	close all;

end