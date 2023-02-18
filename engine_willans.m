function engine_willans
clc;
clear;

eng = Honda;
Hlv = 12.2;
S   = 55 * 1e-3;
Vd  = 1 * 1e-3;
Cm  = (S/pi)*eng.w;
Pme = 4*pi*eng.t/Vd;
for II = 1:length(eng.w)
    Pma(:,II) = eng.gs(:,II)*4*pi*Hlv/(Vd*eng.w(II));
end
options = optimset('Algorithm','trust-region-reflective','TolX',1e-45,...
    'TolFun',1e-45, 'MaxIter', 9000, 'MaxFuneval',9000,'display','off','LargeScale','off');
X = fminunc(@(X)funcerror(X,Cm,Pme,Pma)...
    ,[0 0 0 0 0 0 0],options);
e00 = X(1);
e01 = X(2);
e02 = X(3);
e10 = X(4);
e11 = X(5);
Pmloss0 = X(6);
Pmloss2 = X(7);

hold on;
for SS=1:1:length(eng.w)
    eng.gs(eng.t > eng.tm(SS),SS) = NaN;
end
sfc = 1000*3600*eng.gs./(eng.t'*eng.w);
eff = (1000./(sfc*12.2))*100;
Pindmax = (4*pi*eng.tm/Vd) + Pmloss0 + Pmloss2*Cm.^2;
% contour(eng.w,eng.t,eng.eff);
% contour(eng.w,eng.t,eng.gs,':','LevelStep',0.4,'LineColor',[0 0 0],'linewidth',2);





%-------------------------------------------------------------------------%

% eng.t = ;
Vd = 10*Vd;
Cm  = (S/pi)*eng.w;
maxt = (Pindmax*Vd/(4*pi)) - (Pmloss0 + Pmloss2*Cm.^2)*Vd/(4*pi);
eng.t = 10:1:max(maxt);
[T W]     = meshgrid(eng.t,eng.w);
Pme       = 4*pi*(T)/Vd;
Cm        = (S/pi)*W;
e0        = e00 + e01*Cm + e02*Cm.^2;
e1        =  e10 + e11*Cm;
Pmloss    = Pmloss0 + Pmloss2*Cm.^2;     
PmaNew    = (e0 - sqrt(e0.^2 - 4*e1.*(Pme + Pmloss)))./(2*e1);
mdotNew   =  W.*(PmaNew.*Vd)./(4*pi*Hlv);
 
% for SS=1:1:length(eng.w)
%     mdotNew(eng.t> eng.tm(SS),SS) = NaN;
% end
% [a,b] = contour(W,T,mdotNew,'LevelStep',0.4,'LineColor',[0 0 0],'linewidth',2);
% clabel(a,b);
sfc = 1000*3600*mdotNew'./(eng.t'*eng.w);
eff = (1000./(sfc*12.2))*100;
[a,b] = contour(W,T,eff',10);
clabel(a,b);
% for I = 1:length(eng.w)
% plot(eng.w(I),eng.t(:),'o');
% end

plot(eng.w,maxt,'linewidth',2)
box on;
xlabel('Engine Speed [rad/s]');
ylabel('Torque  [N.m]');
set(gca,'linewidth',2);
legend1 = legend('Engine','Willans','Ticemax');

set(legend1,'Orientation','horizontal','Location','Best');
end

function error =funcerror(X,Cm,Pme,Pma)
e00 = X(1);
e01 = X(2);
e02 = X(3);
e10 = X(4);
e11 = X(5);
Pmloss0 = X(6);
Pmloss2 = X(7);

error = 0;
for II = 1:length(Cm)
    for JJ = 1:length(Pme)
        e0     = e00 + e01*Cm(II) + e02*Cm(II)^2;
        e1     = e10 + e11*Cm(II);
        Pmloss = Pmloss0 + Pmloss2*Cm(II)^2;
        error = error + ((e0 -e1*Pma(JJ,II))*Pma(JJ,II) - Pmloss - Pme(JJ))^2;
    end
end

end
