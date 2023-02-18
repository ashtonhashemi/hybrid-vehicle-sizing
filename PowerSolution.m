function sf = PowerSolution(p2w,hl)
nmdl = ReadNominal;
BP0  =  min(nmdl.bat.V)^2/(4*max(nmdl.bat.R));
% MP0  =  max(nmdl.mot.tm.*nmdl.mot.w)/min(min(nmdl.mot.eff));
MP0  =  max(nmdl.mot.tm.*nmdl.mot.w);
d    = BP0\MP0;
p2w  = p2w/1000; 
A    = [(1-hl)            -hl;
    (1-3*p2w-p2w*d*(nmdl.bat.W/MP0)) (1-3.2*p2w)];
    B = [0; 1000*p2w];
    X = A\B;
    MP     = X(1);
    EP     = X(2);
    sf.m   = MP*1000/max(nmdl.mot.w.*nmdl.mot.tm);
    sf.e   = EP*1000/max(nmdl.eng.w.*nmdl.eng.tm);
    sf.b   = d*sf.m;    

end

