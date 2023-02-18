function ShiftStrategy()
clear;
PlotInitializeData;
a = [0 15 45 75 100];
b = [15 45 75 110 150];
c = [0 10 35 65 100];
d = [10 35 65 100];
X = [0.5 1.5 2.5 3.5 4.5];
w=1;
List={'st','nd','rd','th','th'};
Handel = axes;

xlim([0.5 5.5]);

ylabel('Vehicle speed [km/h]');

hold on;
for Gear = 1:5
M = [X(Gear),c(Gear),w,b(Gear) - c(Gear)];
rectangle('Position',M, 'FaceColor',[243 222 187]/256,'linewidth',0.5);
text(X(Gear) + 0.5,(b(Gear) + c(Gear))/2,[num2str(Gear),List{Gear}],'HorizontalAlignment','center');
end
box on;
P= [0.1300    0.1600    0.7750    0.8150];
set(Handel,'XTick',[1 2 3 4 5]);
set(Handel,'Position',P);

for Gear =1:5
if Gear~=5
[Xa, Ya] = XYConvert(X(Gear),b(Gear) + 2, P);
[Xb,  ~] = XYConvert(1+X(Gear),0,P);
annotation('arrow',[Xa,Xb],[Ya,Ya],'HeadWidth',5,'HeadLength',5); 	
end

if Gear~=1
[Xa, Ya] = XYConvert(X(Gear),c(Gear) - 2, P);
[Xb,  ~] = XYConvert(1+X(Gear),0,P);
annotation('arrow',[Xb,Xa],[Ya,Ya],'HeadWidth',5,'HeadLength',5); 	
end  
  
% set(Handel,'position',PP);
xlabel('Gear number');
end

% set(gcf,'')
% set(gcf,'PaperUnit','centimeters','PaperPosition',[0 0 12 9]);
% print(gcf,'-dpng','-r300','Dri');
% get(Handel,'Position')
PrintToImage(gcf, 'Figure 3', [8.5 5]);
% close all;
end


function [Xa, Ya] = XYConvert(X,Y,P)

Xl = 0.5;
% Xh = 5.5
% Yl = 0;
% Yh = 150;
Xa = P(1) + (X - Xl)*P(3)/5;
Ya = P(2) + Y*P(4)/150;
	
end
