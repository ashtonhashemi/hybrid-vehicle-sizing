function  driving_cycle
clc;
clear;
PlotInitializeData

drilist = {'ECE-15','NEDC','EUDC','FTP-72','FTP-75','US06','HWFET','JP 10-15','CADC(130)','NYCC'};  

data    = [23.87, 0.183     % ECE-15
           42.24, 0.139     % NEDC
           68.60, 0.087     % EUDC
           36.6,  0.2       % FTP-72
           39.21, 0.19      % FTP-75
           79.62, 0.19      % US06 
           77.76, 0.062     % HWFET 
           30.73, 0.162     % JP 10-15
           62.89, 0.14];     % CADC(130)
%            16.63, 0.303];   % 'NYCC'

hold on;
for I   = [1 2 3 4 5 6 7 8 9]
    dat{I} = ReadDrivingCycle(I);
a{I}  = diff(dat{I}.v)./diff(dat{I}.t);
% v_ave(I) =  mean(dat{I}.v);
% a_rms(I) =  sqrt(trapz(dat{I}.t(1:end-1),a{I}.^2)/dat{I}.t(end));
% ellipsdraw(data(I,1),data(I,2),4,0.01);
rectangle('Position',[data(I,1)-8,data(I,2)-0.005,16,0.01],'Curvature',[1,1],...
          'FaceColor',[220 220 220]/256,'linestyle','none')
text(data(I,1),data(I,2),drilist(I),...
'HorizontalAlignment','center','VerticalAlignment','middle')
end
set(gca,'linewidth',2);
box on;
% grid;
xlabel('Average driving speed [km/h]') ;
ylabel('Acceleration RMS [m/s^2]');
grid;
% set(gcf,'Units','inches','Position',[4 1 4 3]);

% % Create ellipse
% annotation('ellipse',...
%     [0.35212298682284 0.636758321273516 0.0983645680819911 0.147612156295224],...
%     'LineWidth',2,'FaceColor','r');
end
function ellipsdraw(xc,yc,a,b)
x = -a+xc:0.01:a+xc;
y1 = yc + b*sqrt(1-((x-xc)/a).^2);
y2 = yc - b*sqrt(1-((x-xc)/a).^2);
plot([x x(end:-1:1)],[y1 y2],'linewidth',2,'Color','black');
% fill([x x(end:-1:1)],[y1 y2],'b');


end
