


function [res, bnd, dypg] = ManagerControl(dricy,sf,W)
% UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dem    = DriveTrain(dricy,sf);
mdl    = ReadNominal;
mdl    = ModelScale(mdl,sf);
prb    = DPSetting;
checkfeas=0;
[res, dypg, bnd, grd] = DynamicProgramming(@BatteryDynamic,prb,mdl,dem,1,checkfeas);
sum(res.R(:,10))/3600
end

