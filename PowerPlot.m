

function PowerPlot
clc;
PlotInitializeData;
p2w  = [85];
hl   = [0.05,0.95];
subplot(2,1,1)
hold on;
for J = 1:length(p2w)
for I = 1:length(hl)
    sf   = PowerSolution(p2w(J),hl(I));
    nmdl = ReadNominal;
    mdl  = ModelScale(nmdl,sf);
    P_m(I)  = (max(mdl.mot.w.*mdl.mot.tm)/1000);
    P_e(I)  = max(mdl.eng.w.*mdl.eng.tm)/1000/41;
    C_b(I)  = mdl.bat.Q;
    dem     = DriveTrain(1,sf);
    W_v(I)  = dem.M;
    plot(P_m(I),P_e(I),'--o','LineWidth',2,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor','none',...
    'MarkerSize',6,'Color','black');
end
plot(P_m, P_e,'linewidth',2,'Color','black');
text(P_m(1),P_e(1),'    \leftarrow HR = 5 %',...
     'HorizontalAlignment','left');
 text(P_m(end),P_e(end),'  HR = 95 %  \rightarrow    ',...
     'HorizontalAlignment','right');
 ylim([-0.5 3]);
end
set(gca,'linewidth',2);
box on;
xlabel('Pemax [Kw]');
ylabel('V_d [Liter]');

subplot(2,1,2)
plot(hl, C_b/3600,'linewidth',2,'Color','black');
set(gca,'linewidth',2);
box on;
xlabel('HL [%]');
ylabel('Q_b [Ah]');
figure;
plot(hl, W_v)
end

