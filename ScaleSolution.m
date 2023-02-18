function sf = ScaleSolution(Pm,Pe)
nmdl = ReadNominal;
BP0  =  min(nmdl.bat.V)^2/(4*max(nmdl.bat.R));
MP0  =  max(nmdl.mot.tm.*nmdl.mot.w);
d    = BP0\MP0;
sf.m   = Pm*1000/max(nmdl.mot.w.*nmdl.mot.tm);
sf.e   = Pe*1000/max(nmdl.eng.w.*nmdl.eng.tm);
sf.b   = d*sf.m;

end

