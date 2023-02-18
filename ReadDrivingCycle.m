%

function dri = ReadDrivingCycle(Index)
prb     = DPSetting;
drilist = {'US06-HWY','EUDC','NEDC','FTP-75','HWFET',...
           'ECE-15','FTP-HWY','UDDS','10-Mode','15-Mode', 'HWFET-MTN','WLTC1','WLTC2','WLTC3'};  
data    = load(['Model\-DrivingCycle\' drilist{Index}]);
dri.t   = 0:prb.ts:max(data.t);
dri.v   = interp1(data.t,data.v,dri.t);
if Index == 11 
dri.e   = 10*interp1(data.t,data.e,dri.t(1:end-1));
else
dri.e   = zeros(1, length(dri.t)-1);    
end

