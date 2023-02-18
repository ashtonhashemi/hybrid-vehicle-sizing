function control_method

clc;
X = [-250 -100 0  80 100 180];
Y1 = [-100 -100 0  80 100 100];
Y0 = [0 0 0 0 20 100];
Y_11 = [0 0 0];
Y_12  =[-80 0 20 100] ;

hold on;
% plot([-300 300],[100 100],'--','color','black','linewidth',1);
% plot([-300 300],[-100 -100],'--','color','black','linewidth',1);
% plot([180 180],[-120 120],'--','color','black','linewidth',1);
% plot([-250 -250],[-120 120],'--','color','black','linewidth',1);
% plot([80 80],[-120 120],'--','color','black','linewidth',1);
plot(X-430,Y1,'linewidth',2,'color','black');
plot(X,Y0,'linewidth',2,'color','black');
plot(X(1:3)+430,Y_11,X(3:6)+430,Y_12,'linewidth',2,'color','black');
plot([0 0]+430,[-80 0],'--','linewidth',2,'color','black');
plot([-250 -250],[-120 120],'linewidth',2,'color','black')
plot([180 180],[-120 120],'linewidth',2,'color','black')
box on;
% set(gcf,'Csolor','white');
set(gca,'linewidth',2);
ylim([-120 120]);
xlim([-680 610]);
xlabel('Tc');
ylabel('Tm');
% % hold on;
% clear;
% clc;
% % clc;
%  = [-250 -100 0  80 100 180];
% Y1 = [-100 -100 0  80 100 100];
% 
% Y0    = [0 0 0 0 20 100];
% Y_11  = [0 0 0];
% Y_12  = [-80 0 20 100];
% 
% hold on;
% plot(X,Y1,'linewidth',2,'color','blue');
% plot(X,Y0,'linewidth',2,'color','red');
% plot(X(1:3),Y_11,X(3:6),Y_12,'linewidth',2,'color',[0 127 0]/256);
% % set(gcf,'Csolor','white');



% plot([0 0],[-80 0],'--','linewidth',2,'color',[0 127 0]/255);









% clc;
% hold on;
% set(gca,'linewidth',2);
% Td     = [-250 -100 0  80 100 180];
% U      = [1 1 1 1 1 1];
% Tm     = [-100 -100 0  80 100 100];
% 
% plot3(Td,U,Tm,'linewidth',2,'color','red');
% 
% Td     = [-250 -100 0  80 100 180];
% U      = [0 0 0 0 0 0];
% Tm     = [0 0 0 0 20 100];
% 
% plot3(Td,U,Tm,'linewidth',2);
% 
% Td     = [-250 -100 0  0  80 100 180];
% U      = [-1 -1 -1 -1 -1 -1 -1];
% Tm     = [0 0 0 -80 0 20 100];
% plot3(Td,U,Tm,'linewidth',2,'color',[0 127 0]/256);
% 
% grid;
% xlabel('Td');
% ylabel('U');
% zlabel('Tm');
% xlim([-250 180]);
% zlim([-120 120])
% % box on;
end