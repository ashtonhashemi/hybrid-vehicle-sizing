function UU = modefinder(Te,Tm,Td)
	
	
	
UU = (Td>0).*((Te>0).*(Tm<0)*(0.4)  + ... % recharge mode
             (Te>0).*(Tm==0)*(0.6) + ... % engine alone
             (Te>0).*(Tm>0)*(0.8)  + ... % hybrid
             (Te==0).*(Tm>0)*(1))+ ... % elctric mode
     (Td<0).*((Te==0).*(Tm==0)*(0)  + ... % conv brake
             (Te==0).*(Tm<0)*(0.2));    % regenerate   
             


end


% function U = ufinder(U,Tdem,Wdem,mdl)
% I = 0;
% MotMax = interp1(mdl.mot.w,mdl.mot.tm,Wdem,'linear');
% EngMax = interp1(mdl.eng.w,mdl.eng.tm,Wdem,'linear',0);
% Tm_u_1p = min(Tdem,MotMax);
% Tm_u_0  = max(Tdem-EngMax,0);
% Tm_u_1n = max(Tdem-EngMax,-MotMax);
% Tm_u_1p_n = max(-MotMax,Tdem);
% 
% UU      = [-1 0 1];
% TTp     = [Tm_u_1n Tm_u_0 Tm_u_1p];
% TTn     = [0 0 Tm_u_1p_n];
% 
% Tmot    = (Tdem>0).*interp1(UU,TTp,U) + (Tdem<0).*interp1(UU,TTn,U);
% Teng    = (Tdem>0).*(Tdem - Tmot);
% 
% 
% end

