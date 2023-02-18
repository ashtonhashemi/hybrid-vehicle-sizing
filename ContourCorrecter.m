

function cnt = ContourCorrecter(W, T, Tm, E, Tmr, Model)
	switch Model
		case 'Engine'
			cnt.T = min(T):1:max(T);
			cnt.W = min(W):2:max(W);
			[WM, TM]=meshgrid(cnt.W, cnt.T);
			cnt.E  = interp2(W,T,E, WM,TM,'cubic');
			tm  = interp1(W,Tm,cnt.W);
			for SS=1:1:length(cnt.W)
				cnt.E(cnt.T > tm(SS),SS ) = NaN;
			end
		case 'Motor'
			cnt.T = min(T):10:max(T);
			cnt.W = min(W):1:max(W);
			[WM, TM]=meshgrid(cnt.W, cnt.T);
			cnt.E  = interp2(W,T,E, WM,TM);
			tm  = interp1(W,Tm,cnt.W);
			tmr = interp1(W,Tmr,cnt.W);
			for SS=1:1:length(cnt.W)
				cnt.E(cnt.T > tm(SS),SS) = NaN;
				cnt.E(cnt.T < tmr(SS),SS) = NaN;
			end
			
	end