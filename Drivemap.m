clear;
PlotInitializeData;
C =[1 3 4 14];

subplot(4,1,1)
dri = ReadDrivingCycle(1);
plot(dri.t,dri.v*3.6);
ylabel({'US06', 'V [km/h]'});

subplot(4,1,2)
dri = ReadDrivingCycle(3);
plot(dri.t,dri.v*3.6);
ylabel({'NEDC', 'V [km/h]'});

subplot(4,1,3)
dri = ReadDrivingCycle(4);
plot(dri.t,dri.v*3.6);
ylabel({'FTP75', 'V [km/h]'});

subplot(4,1,4)
dri = ReadDrivingCycle(14);
plot(dri.t,dri.v*3.6);
xlabel('Time [s]');
ylabel({'WLTC-Class 3', 'V [km/h]'});

PrintToImage(gcf, 'Figure 17', [8.5 9]);

close all;
