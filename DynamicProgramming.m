%----------------------------------------------------------------------------%
%                         Dynamic Programing                                 %
% This function solve discrete time, optimal-control problems using bellmans %
% principles of optimality                                                   %
%----------------------------------------------------------------------------%


function    [res, dypg, bnd, grd] = DynamicProgramming(model,prb,mdl,dem,Flagmode,checkFeas)


% grid construction of control value %
grd.U = prb.U.h:-(prb.U.h-prb.U.l)/prb.U.n:prb.U.l;
grd.N = (max(dem.t)/prb.ts) + 1;

if checkFeas == 1
    [grd, bnd, FlagFea] = dpm_boundary(model,prb,mdl,dem,grd,Flagmode);
    
    res = FlagFea;
    dypg = 0;
    
else
    if mdl.mot.tm~=0
        % estimating feasible boundaries of states  %
        [grd, bnd, ~] = dpm_boundary(model,prb,mdl,dem,grd,Flagmode);
        
        % backward dynamic programming %
        dypg = dpm_backward(model,prb,mdl,dem,grd,bnd,Flagmode);
        
        % forward dynamic programming %
        res = dpm_forward(model,prb,mdl,dem,grd,dypg,Flagmode,bnd);
        
    else
        res = dpm_forward(model,prb,mdl,dem,grd,0,Flagmode,0);
        dypg  = 0;
        bnd   = 0;
    end
end
end
%-------------------------------------------------------------------------%
function             [grd, bnd, FlagFea] = dpm_boundary(model,prb,mdl,dem,grd,mode)




% setting fmincon option for a fixed point problem between bound and
% limit
options = optimset('Display','off','Algorithm','sqp','TolX',prb.X.r,...
    'TolFun',prb.X.r, 'MaxIter', 2000, 'MaxFuneval',2000);
lb = min(grd.U);
ub = max(grd.U);
u0 = 0;
FlagFea = 1; % possible solution


% initiation of values for boundary loop %
bnd.X.h{grd.N}    = prb.X.E;
bnd.X.l{grd.N}    = prb.X.E;
bnd.C.h{grd.N}    = 0;
bnd.C.l{grd.N}    = 0;
bound_high_active = 1;
bound_low_active  = 1;
if mode~=0
    h = waitbar(0,'Creating boundary Line');
end
% estimiating boudaries %
for k = grd.N-1:-1:1
    end_con_l = 0;     end_con_h = 0;
    U{k} = grd.U;
    
    %  upper boundary line %
    j = 1;
    if bound_high_active
        
        % determining upper boundary line using recursive formula unitl
        % reaching limit
        while ~end_con_h
            Xi_high(1)   = bnd.X.h{k+1};
            [upd_fun C]  = dpm_inv_model(model,prb,mdl,dem,Xi_high(1),U{k},k);
            [fk  Ind]    = max(upd_fun);
            Xi_high(j+1) = bnd.X.h{k+1} + fk;
            end_con_h    = abs(Xi_high(j+1)-Xi_high(j)) < prb.X.r;
            j = j+1;
        end
        bnd.X.h{k} = Xi_high(end);
        bnd.U.h{k} = U{k}(Ind);
        bnd.C.h{k} = C(Ind) + bnd.C.h{k+1};
        
        % in the case of reaching limit , fmincon is used for determinig u %
        if  bnd.X.h{k} > prb.X.h
            bnd.X.h{k} = prb.X.h;
            bnd.U.h{k} = fmincon(@(U)obj_function(U,model,prb,mdl,dem,prb.X.h,bnd.X.h{k+1},k),u0,[],[],[],[],lb,ub,[],options);
            [~,bnd.C.h{k},~,~] = model(bnd.X.h{k},bnd.U.h{k},prb,mdl,dem,k,0);
            bnd.C.h{k} =bnd.C.h{k} + bnd.C.h{k+1};
            bound_high_active = 0;
        end
        
    end
    
    
    
    
    % lower boundar line %
    j = 1;
    if bound_low_active
        
        % determining lower boundary line using recursive formula unitl
        % reaching limit
        while ~end_con_l
            Xi_low(1) = bnd.X.l{k+1};
            [upd_fun C] = dpm_inv_model(model,prb,mdl,dem,Xi_low(1),U{k},k);
            [fk Ind]    = min(upd_fun);
            Xi_low(j+1) = bnd.X.l{k+1} + fk;
            end_con_l = abs(Xi_low(j+1)-Xi_low(j)) < prb.X.r;
            j = j+1;
        end
        bnd.X.l{k} = Xi_low(end);
        bnd.U.l{k} = U{k}(Ind);
        bnd.C.l{k} = C(Ind) + bnd.C.l{k+1};
        
        % in the case of reaching limit , fmincon is used for determinig u %
        if  bnd.X.l{k} < prb.X.l
            bnd.X.l{k} = prb.X.l;
            bnd.U.l{k} = fmincon(@(U)obj_function(U,model,prb,mdl,dem,prb.X.l,bnd.X.l{k+1},k),u0,[],[],[],[],lb,ub,[],options);
            [~,bnd.C.l{k},~,~] = model(bnd.X.l{k},bnd.U.l{k},prb,mdl,dem,k,0);
            bnd.C.l{k} = bnd.C.l{k} + bnd.C.l{k+1};
            bound_low_active = 0;
        end
    end
    
    if mode~=0
        waitbar(k/(grd.N-1),h);
    end
end
if mode~=0
    delete(h);
end
grd.U = U;

if (~isempty(bnd.X.l{k}))
    if prb.X.I < bnd.X.l{1}
        FlagFea = 0;
    end
end
end
%-------------------------------------------------------------------------%
function                  dypg = dpm_backward(model,prb,mdl,dem,grd,bnd,mode)
flag = 0;

% setting fsolve option for a fixed point problem between the time before
% final-time and final time %
options = optimset('display','off','TolX',prb.X.r,...
    'TolFun',prb.X.r, 'MaxIter',5000, 'MaxFuneval',5000);
u0    = 0.5;
if mode~=0
    h = waitbar(0,'Backward DP');
end
% backward dynamic programing %
for k = grd.N-1:-1:1
    
    % creat feasible grid (do not contain boundary) %
    LowBound     = bnd_limit(bnd.X.l{k},prb.X.l);
    HighBound    = bnd_limit(bnd.X.h{k},prb.X.h);
    %     prb.X.nd{k}  = floor((HighBound - LowBound)/prb.X.d) + 20;
    prb.X.nd{k}  = prb.X.n;
    raw_grd     = LowBound:(HighBound-LowBound)/prb.X.nd{k}:HighBound;
    grd.X{k}    = raw_grd(cell_comp(raw_grd,'~=',bnd.X.l{k}) & cell_comp(raw_grd,'~=',bnd.X.h{k}))';
    
    % first time instance before final time (only 1 possible control value) %
    if k == grd.N-1
        %         for J=1:1:length(grd.X{k})
        
        % opt_cont{k}(J) = (fmincon(@(U)obj_function(U,model,prb,grd.X{k}(J),bnd.X.h{k+1},k),u0,...
        % [],[],[],[],lb,ub,[],options));
        %             opt_cont{k}(J) = fsolve(@(U)obj_function(U,model,prb,mdl,dem,grd.X{k}(J),bnd.X.h{k+1},k),u0,options);
        opt_cont{k} = interp1([bnd.X.l{k} bnd.X.h{k}],[bnd.U.l{k} bnd.U.h{k}],grd.X{k});
        [~,opt_cost{k}] = model(grd.X{k},opt_cont{k},prb,mdl,dem,k,0);
        
        %         end
        opt_cost{k} = [bnd.C.l{k}; opt_cost{k}; bnd.C.h{k}];
        opt_cont{k} = [bnd.U.l{k}; opt_cont{k}; bnd.U.h{k}];
        XI{k}       = [bnd.X.l{k}; grd.X{k};     bnd.X.h{k}];
    end
    
    % all time instances execept the one before final time %
    if k ~= grd.N-1
        
        [Xi U]             = meshgrid(grd.X{k},grd.U{k});
        [Xj,StageCost,~,~] = model(Xi,U,prb,mdl,dem,k,flag);
        Costogo            = interp1(XI{k+1},opt_cost{k+1},Xj,'linear',Inf);
        [CC UU]            = min(StageCost  + Costogo,[],1);
        opt_cont{k}        = [bnd.U.l{k}; grd.U{k}(UU)'; bnd.U.h{k}];
        opt_cost{k}        = [bnd.C.l{k}; CC';           bnd.C.h{k}];
        XI{k}              = [bnd.X.l{k}; grd.X{k};      bnd.X.h{k}];
        
        % omit extra infeasible states compeled by model contraint
        fls_State{k}       = isinf(opt_cost{k});
        opt_cont{k}        = opt_cont{k}(~fls_State{k});
        opt_cost{k}        = opt_cost{k}(~fls_State{k});
        XI{k}              = XI{k}(~fls_State{k});
        if isempty(XI{k})
            
        end
    end
    
    if mode~=0
        waitbar(k/(grd.N-1),h)
    end
end
if mode~=0
    delete(h);
end
dypg.opt_cont  = opt_cont ;
dypg.opt_cost  = opt_cost;
dypg.XI        = XI;
dypg.fls_State = fls_State;


end
%-------------------------------------------------------------------------%
function                   res = dpm_forward(model,prb,mdl,dem,grd,dypg,mode,bnd)
flg  = 2;
if mdl.mot.tm~=0
    % pre allocation of memory %
    U  = zeros(1,grd.N-1);
    C  = zeros(1,grd.N-1);
    % R  = zeros(1,grd.N-1);
    X  = zeros(1,grd.N);
    if mode~=0
        h = waitbar(0,'Forward DP');
    end
    % forward dynamic programing %
    X(1) = prb.X.I;
    for k = 1:grd.N-1
        if (~isempty(bnd.X.l{k}))
            if X(k)<bnd.X.l{k}
                if X(1)<bnd.X.l{k}
                    break;
                end
                disp('Warninig: Lower Bound crossing ocurred');
                Ucorrect = bnd.U.l{k};
            else
                Ucorrect = NaN;
            end
        else
            Ucorrect = NaN;
        end
        U(k)  = interp1(dypg.XI{k},dypg.opt_cont{k},X(k),'linear',Ucorrect);
        [X(k+1),C(k),R(k,:),~]  = model(X(k),U(k),prb,mdl,dem,k,flg);
        if mode~=0
            waitbar(k/(grd.N-1),h)
        end
    end
    if mode~=0
        delete(h);
    end
    res.X = X;
    res.U = U;
    res.C = C;
    res.fc = sum(R(:,6))
    res.fcgkwh  = (R(:,7));
    res.co2gkwh = (R(:,8));
    res.co2     = sum(R(:,10));
    res.R = R;
else
    if mode~=0
        h = waitbar(0,'Forward DP');
    end
    for k = 1:grd.N-1
        [~,~,R(k,:),~]  = model(0,0,prb,mdl,dem,k,flg);
        if mode~=0
            waitbar(k/(grd.N-1),h)
        end
        
    end
    res.fc      = sum(R(:,6));
    res.fcgkwh  = (R(:,7));
    res.co2gkwh = (R(:,8));
    res.co2     = sum(R(:,10));
    res.X = 0;
    res.R = R;
    if mode~=0
        delete(h);
    end
end



end
%-------------------------------------------------------------------------%
function               [f_k, C] = dpm_inv_model(model,prb,mdl,dem,Xi,U,k)


[Xj,C,~,I] = model(Xi,U,prb,mdl,dem,k,0);

f_k        = Xi - Xj;
% f_k (C==Inf) = NaN;



end
%-------------------------------------------------------------------------%
function                objval = obj_function(U,model,prb,mdl,dem,Xi,Xj,k)

[Xjj,~,~,~] = model(Xi,U,prb,mdl,dem,k,0);

% value = (Xjj - Xj)^2;
objval = abs(Xjj - Xj);

end
%-------------------------------------------------------------------------%
function                   ans = cell_comp(mat,op,cel)
op;
if isempty(cel)
    ones(1,length(mat));
else
    (mat~=cel);
end

end
%-------------------------------------------------------------------------%
function                   ans = bnd_limit(bound,X)

if isempty(bound)
    X;
else
    bound;
end

end
%-------------------------------------------------------------------------%


















