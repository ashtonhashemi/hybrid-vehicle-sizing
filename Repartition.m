clc;
% clear;
PlotInitializeData;
% % read dynamic programming settings
% prb     =  DPSetting;
% HR      = 0.05:0.1:0.75; % NEDC
% Number  = length(HR);
% design constraint
% p2w   = 85;
% Cycle = 14;
% flagcheck = 0;
% h = waitbar(0,'torque repartition');
% k = 1;
% for Ihr = 1:length(HR)
%     waitbar(k/Number,h);
%     sf          = PowerSolution(p2w,HR(Ihr));
%     dem         = DriveTrain(Cycle,sf);
%     mdl         = ModelScale(ReadNominal,sf);
%     [res,~,~,~] = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,0,flagcheck);
%     
%     OptZ        = sum(res.R(res.fcgkwh<260,1).*res.R(res.fcgkwh<260,2));
%     NunZ        = sum(res.R(res.fcgkwh>260,1).*res.R(res.fcgkwh>260,2));
%     
%     k           = k + 1;
%     MatPar(Ihr,:)=[OptZ, NunZ]/(OptZ+NunZ);
%     Energy(Ihr)= OptZ+NunZ;
% end
% delete(h);
% MatParDime = MatPar; 
colormap('Summer')
hold on;
bar_handle1 = bar(HR*100,100*MatPar,'EdgeColor','black','LineStyle','-','linewidth',0.5,'BaseValue',0,'BarLayout','Stacked','barwidth',0.4);
% set(bar_handle1,'YTick',[0 25 50 75 100],'YTickLabel',{'0','25','50','75','100'})
baseline_handle = get(bar_handle1,'BaseLine');      
box on;   
set(gca,'linewidth',0.5);
xlabel('HR [%]');
ylabel('ICE efficiency repartition [%]');
% legend('opt area','Other Load');
line([65 65],[0 100],'linewidth',0.5);
xlim([0 80]);
set(gca,'Position',[0.12 0.17 0.75 0.77]);
% PP = get(gca,'position');
h = axes;
plot(HR*100,Energy/1000/3600,'-o','linewidth',0.5,'Color','red',...
        'MarkerEdgeColor','red',...
        'MarkerFaceColor','white',...
        'MarkerSize',4);
set(h,'Color','none','YAxisLocation','right');
xlabel('HR [%]');
ylabel('ICE delivered energy [kWh]');
xlim([0 80]);
ylim([3.2 3.7])
% set(gca,'Position',PP);
set(gca,'Position',[0.12 0.17 0.75 0.77]);
% set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 16 9]);
% print(gcf,'-dpng','-r300','Partition');
PrintToImage(gcf, 'Figure 13', [8.5 5]);
close all;