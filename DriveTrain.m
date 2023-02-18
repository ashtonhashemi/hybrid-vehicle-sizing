    

function dem = DriveTrain(drivIndex,sf)

% read driving cycle %
dri = ReadDrivingCycle(drivIndex);
nmdl = ReadNominal;
mdl = ModelScale(nmdl,sf);

% vehicle mass and aerodynamic data %
rho   = 1.202;         
cd    = 0.32;
af    = 2.13; 
rt    = 0.282;
mio   = 0.015;
g     = 9.8;
mbody = 1000;
me    = 3.2*max(mdl.eng.tm.*mdl.eng.w)/1000;
mm    = 3*max(mdl.mot.tm.*mdl.mot.w)/1000;
mb    = nmdl.bat.W*sf.b;
ma    = mbody + me + mm + mb;  
m     = ma;
dem.M = m ;


% calculating demaned power and force %
dem.A     =  diff(dri.v)./diff(dri.t);
Finertial =  m*(diff(dri.v)./diff(dri.t));
Faero     =  0.5*rho*cd*af*((dri.v(1:end-1) + dri.v(2:end))/2).^2 ;
Ffri      =  m*g*mio*ones(size(Faero));
Fgrade    =  m*g*sin(dri.e); 
dem.t     =  dri.t;
dem.V     =  dri.v;
dem.F     =  Finertial + Faero + Ffri + Fgrade;
dem.P     =  [dem.F.*(dri.v(1:end-1) + dri.v(2:end))/2 0];
% sum(dem.P)/3600
dem.S     =  trapz(dem.t,dem.V);
dem.E(1)  = 1000;
dem.Sp(1) = 0;
for I = 2:length(dri.t)-1
dem.s(I) = trapz(dri.t(I:I+1), dri.v(I:I+1));
dem.Sp(I)= dem.Sp(I-1) + dem.s(I);   
dem.E(I) =  dem.E(I-1) + dem.s(I-1)*dri.e(I-1);
dem.h(I) = diff(dri.e(I-1:I));
end




% transmision model and calculating demand torque at torque coupler %
gr      = (19/79)*[0.2895 0.5349 0.7812 1.0513 1.3428];
regeff  = 0.3;
dem.T   = dem.F*rt.*gr(GearSelector(dri));
dem.W   = dem.V(1:end-1)./(rt.*gr(GearSelector(dri)));
DeltaWt = [0];
dem.T   = (dem.T>=0).*(dem.T + DeltaWt) + (regeff)*(dem.T<0).*(dem.T);


end




