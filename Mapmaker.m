function Mat = Mapmaker(res,dypg)
prb = DPSetting;
Mat.X = prb.X.l:0.01:prb.X.h;
Mat.t = 0:1:length(res.X)-2;
% [XX, tt] = ndgrid(Mat.X, Mat.t);
for i=1:length(Mat.t)
	Mat.U(i,:) = interp1(dypg.XI{i},dypg.opt_cont{i},Mat.X,'pchip',NaN); 
end
% 
% Mat.dec = (Td>0).*((Te>0).*(Tm<0)*(0.4)  + ... % recharge mode
%              (Te>0).*(Tm==0)*(0.6) + ... % engine alone
%              (Te>0).*(Tm>0)*(0.8)  + ... % hybrid
%              (Te==0).*(Tm>0)*(1))+ ... % elctric mode
%      (Td<0).*((Te==0).*(Tm==0)*(0)  + ... % conv brake
%              (Te==0).*(Tm<0)*(0.2));    % regenerate   
             


end

