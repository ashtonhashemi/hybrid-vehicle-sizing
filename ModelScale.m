function mdl = ModelScale(nmdl,sf)
mdl.eng =  EngineScale(nmdl.eng,sf.e);
mdl.mot =  MotorScale(nmdl.mot,sf.m);
mdl.bat =  BatteryScale(nmdl.bat,sf.b);


end

function eng = EngineScale(neng,Scale)
eng     = neng;
eng.t   = Scale*neng.t;
eng.tm  = Scale*neng.tm;
end

function mot = MotorScale(nmot,Scale)

mot     = nmot;
mot.t   = Scale*nmot.t;
mot.tm  = Scale*nmot.tm;

end

function bat = BatteryScale(nbat,Scale)
bat.S = nbat.S;
bat.V = nbat.V;
bat.R = nbat.R/Scale;
bat.Q = Scale*nbat.Q;


end


