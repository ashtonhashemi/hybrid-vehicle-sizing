%----------------------------------------------------------------------------%
%                         Parallel Hybrid Electric Model                     %
%  This function simulate HEV for evaluation of fuel consumption and emission%
%  for dynamic programming algorithm                                         %
%----------------------------------------------------------------------------%



function [Xj, C, R, I] = BatteryDynamic(Xi,U,prb,mdl,dem,k,flg)

if mdl.mot.tm~=0
    % mover torque %
    [mo_t, en_t] = spt_fcr(U,dem.T(k),dem.W(k),mdl);
    tc_r        = 1;
    mo_w        = ones(size(U)).*tc_r * dem.W(k);
    en_w        = ones(size(U)).*dem.W(k);
    
    % determine demanded battery power %
    mo_eff   = interp2(mdl.mot.w,mdl.mot.t,mdl.mot.eff,mo_w,mo_t,'linear');
    Pb       = (mo_t>=0).*(mo_t.*mo_w)./mo_eff + (mo_t<0).*(mo_t.*mo_w).*mo_eff;
    
    Voc         = interp1(mdl.bat.S,mdl.bat.V,Xi);
    Ri          = interp1(mdl.bat.S,mdl.bat.R,Xi);
    Ibatt       = (Voc - sqrt(Voc.^2-4*Ri.*Pb))./(2*Ri);
    Xj          = Xi - prb.ts*Ibatt/mdl.bat.Q;
    
    
    
    % engine model %
    fc_g_kwh     = (en_t~=0).*interp2(mdl.eng.w,mdl.eng.t,mdl.eng.fc_g_kwh,en_w,en_t,'linear',0);
%     co2_g_kwh    = (en_t~=0).*interp2(mdl.eng.w,mdl.eng.t,mdl.eng.co2_g_kwh,en_w,en_t,'linear',0);
    fc_gs         = (en_w.*en_t).*(fc_g_kwh/(1e+3*3600));
%     co2_gs        = (en_w.*en_t).*(co2_g_kwh/(1e+3*3600));
%     C             = ((1-prb.W)*fc_gs + (prb.W)*0.47*0)*prb.ts; % gram
   C             = (fc_gs )*prb.ts; % gram
    
    
    % total infeasible operating points %
    I = 0;
    
    % save data in forward motion %
    if flg == 2
        Lit     = fc_gs./(1e+3*0.74);
        R = [en_t en_w mo_t mo_w Pb Lit fc_g_kwh 0 fc_gs Ri*Ibatt^2];
        
    else
        R = 0;
    end
else
    en_t = (dem.T(k)>0)*dem.T(k);
    en_w = dem.W(k);
    fc_g_kwh     = (en_t~=0).*interp2(mdl.eng.w,mdl.eng.t,mdl.eng.fc_g_kwh,en_w,en_t,'linear',mdl.eng.fc_g_kwh(3,end));
%     co2_g_kwh    = (en_t~=0).*interp2(mdl.eng.w,mdl.eng.t,mdl.eng.co2_g_kwh,en_w,en_t,'linear');
    fc_gs        = (en_w.*en_t).*(fc_g_kwh/(1e+3*3600));
%     co2_gs       = (en_w.*en_t).*(co2_g_kwh/(1e+3*3600));
    Lit          = fc_gs./(1e+3*0.74);
    R = [en_t en_w 0 0 0 Lit fc_g_kwh 0 0 0];
    Xj=0;
    C =0;
    I = 0;
end
end


function [Tmot, Teng] = spt_fcr(U,Tdem,Wdem,mdl)
I = 0;
MotMax = interp1(mdl.mot.w,mdl.mot.tm,Wdem,'linear');
EngMax = interp1(mdl.eng.w,mdl.eng.tm,Wdem,'linear',0);
Tm_u_1p = min(Tdem,MotMax);
Tm_u_0  = max(Tdem-EngMax,0);
Tm_u_1n = max(Tdem-EngMax,-MotMax);
Tm_u_1p_n = max(-MotMax,Tdem);

UU      = [-1 0 1];
TTp     = [Tm_u_1n Tm_u_0 Tm_u_1p];
TTn     = [0 0 Tm_u_1p_n];

Tmot    = (Tdem>0).*interp1(UU,TTp,U) + (Tdem<0).*interp1(UU,TTn,U);
if Tmot > MotMax
    disp('Warning: driving cycle demand is more than the total available power');
end
Teng = (Tdem>0).*(Tdem - Tmot);


end





