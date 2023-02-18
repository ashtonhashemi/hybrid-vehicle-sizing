clc;
clear;
PlotInitializeData;
% read dynamic programming settings
prb     =  DPSetting;
% drilist = {'US06','EUDC','NEDC','FTP-75','HWFET',...
%     'ECE-15','FTP-HWY','UDDS','10-Mode','15-Mode'};
drilist = {'US06-HWY','EUDC','NEDC','FTP-75','HWFET',...
           'ECE-15','FTP-HWY','UDDS','10-Mode','15-Mode', 'HWFET-MTN','WLTC1','WLTC2','WLTC3'};  
% driving cycles applicable hybridization ratio
% HR{1}  = [0.1:0.05:0.5 , 0.52:0.02:0.6, 0.65 ];  % US06WHY
HR{1}  = [0.1:0.05:0.6,0.65];  % US06WHY
HR{2}  = 0.1:0.05:0.8;   % EUDC
HR{3}  = [0.1:0.05:0.4,0.6:0.05:0.7 , 0.72:0.02:0.8, 0.85];  % NEDC
% HR{4}  = [0.1:0.05:0.7 , 0.72:0.02:0.8, 0.85];  % FTP-75
HR{4}  = [0.1:0.05:0.8];  % FTP-75
HR{5}  = 0.1:0.05:0.8;   % HWFET
HR{6}  = [0.1:0.05:0.7 , 0.72:0.02:0.8, 0.85];   % ECE-15
HR{14} = [0.1:0.05:0.75];
% design constraint
p2w   = 85;
Cycle = [1 3 4 14];
checkFeas = 0;
h = waitbar(0,'Sizing');
k = 1; Number = 0;
for C = Cycle 
Number = length(HR{C}) + Number;
end
for C = Cycle
    fc  = [];
    sf             = PowerSolution(p2w,0);
    dem            = DriveTrain(C,sf);
    mdl            = ModelScale(ReadNominal,sf);
    [baseres,~,~,~] = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,0,checkFeas);
    
    for Ihr = HR{C}
        waitbar(k/Number,h);
        sf             = PowerSolution(p2w,Ihr);
        dem            = DriveTrain(C,sf);
        mdl            = ModelScale(ReadNominal,sf);
        [result,~,~,~] = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,0,checkFeas);
        fc         = [fc result.fc];
        k              = k + 1;
    end
    if isnan(baseres.fc)
        baseres.fc = 1.48;
    end
    Out{C}.hr       = HR{C};
    Out{C}.fuel     = (fc/baseres.fc)*100;
    [~, I]          = min(Out{C}.fuel);
    Out{C}.hropt    = HR{C}(I);
end
delete(h)
hold on;
for C = Cycle
%     plot(100*Out{C}.hr, Out{C}.fuel,'linewidth',2,'Color','black');
	plot(100*(min(Out{C}.hr):0.01:max(Out{C}.hr)), csaps(Out{C}.hr,Out{C}.fuel,0.99999,min(Out{C}.hr):0.01:max(Out{C}.hr))...
		,'linewidth',0.5,'Color','black');
    [V, I] = min(Out{C}.fuel);
    plot(100*Out{C}.hr(I), V, 'o','linewidth',0.5,...
        'MarkerEdgeColor','blue',...
        'MarkerFaceColor','white',...
        'MarkerSize',4);
    text(100*Out{C}.hr(end) + 6, Out{C}.fuel(end),drilist(C),...
        'HorizontalAlignment','center','VerticalAlignment','bottom','Color','blue')
end
box on;
xlabel('HR[%]');
ylabel('FC/FC_C_o_n_v[%]');
% set(gcf,'Units','inches','Position',[4 4 3.69 2.5]);
set(gca,'linewidth',0.5);
xlim([0 100]);
Valmat = [];
% figure;
% for C = Cycle
% sf     = PowerSolution(p2w,Out{C}.hropt);
% mdl    = ModelScale(ReadNominal,sf);
% Motor  = max(mdl.mot.tm.*mdl.mot.w)/1000;
% Engine = max(mdl.eng.tm.*mdl.eng.w)/1000; 
% Valmat = [Valmat; Engine Motor];
% end
% bar(Valmat);
% set(gca,'XTick',[1 2 3 4],'XTickLabel',{drilist{1},drilist{3},drilist{4},drilist{6}});
% ylabel('Power [kw]');

% set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 16 9]);
% print(gcf,'-dpng','-r300','HROptimal');
PrintToImage(gcf, 'Figure 13', [8.5 5]);

% text(0.9,Valmat(1,1) + 1, [num2str(round(Valmat(1,1))),'%'],'HorizontalAlignment','center');
% text(1.1,Valmat(1,2) + 1, [num2str(round(Valmat(1,2))),'%'],'HorizontalAlignment','center');
% 
% text(1.9,Valmat(2,1) + 1, [num2str(round(Valmat(2,1))),'%'],'HorizontalAlignment','center');
% text(2.1,Valmat(2,2) + 1, [num2str(round(Valmat(2,2))),'%'],'HorizontalAlignment','center');
% 
% text(2.9,Valmat(3,1) + 1, [num2str(round(Valmat(3,1))),'%'],'HorizontalAlignment','center');
% text(3.1,Valmat(3,2) + 1, [num2str(round(Valmat(3,2))),'%'],'HorizontalAlignment','center');
% 
% text(3.9,Valmat(4,1) + 1, [num2str(round(Valmat(4,1))),'%'],'HorizontalAlignment','center');
% text(4.1,Valmat(4,2) + 1, [num2str(round(Valmat(4,2))),'%'],'HorizontalAlignment','center');
% 
% text(4.9,Valmat(5,1) + 1, [num2str(round(Valmat(5,1))),'%'],'HorizontalAlignment','center');
% text(5.1,Valmat(5,2) + 1, [num2str(round(Valmat(5,2))),'%'],'HorizontalAlignment','center');
% 



