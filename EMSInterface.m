% GUIV is a graphical user interface designed for
% sizing and energy management of parralel hybid
% electric vehicles.
%

function  EMSInterface
clc;
clear;
PlotInitialize;
S.I    = 0;
dem.I  = 0;
sf.I   = 0;
mdl.I  = 0;
BackColor = [236 235 180]/256;
close;

% Creat Main GUI Properties
CreatPanels;
CreatDrivingCycleMenu;
CreatSolutionMode;
CreatControlConcern;
CreatDesignVariable;
CreatNominalScaled;
CreatDesignConstraint;
CreatCycleData;
CreatControlData;
CreatActionButtons;
CreatMinScaleData;
CreatCostData;


dcle_call;
mode_call;
cost_call;



    function  CreatPanels
        % creat main figure;
        S.Fh = figure('Visible','on','Position',[10,50,1270,680],'Name',...
            'HEV Sizing Interface','NumberTitle','off','color', BackColor,'MenuBar','none');
        % creat panel  A which is for general inputs
        S.PnlA = uipanel('parent',S.Fh,'Title','General Inputs','position',[0.01,0.1,0.2,0.89]);
        % creat panel B which is for sizing condition
        S.PnlB = uipanel('parent',S.Fh,'position',[0.215,0.1,0.2,0.89],'Title','Sizing Condition');
        % creat panel C for action buttons
        S.PnlC = uipanel('parent',S.Fh,'position',[0.01,0.01,0.405,0.085]);
        % creat panel D for graphical outputs
        S.PnlD = uipanel('parent',S.Fh,'position',[0.42,0.01,0.57,0.98],'Title','Graphical Outputs');
    end

    function  CreatDrivingCycleMenu
        S.dcle = uicontrol('parent',S.PnlA,'Style', 'listbox',...
            'String', 'US06-HWY|EUDC|NEDC|FTP-75|HWFET|ECE-15|FTP-HWY|UDDS|10-Mode|15-Mode|HWFET-MTN|WLTC1|WLTC2|WLTC3',...
            'Position', [0.05 0.78 0.9 0.2],'callback',{@dcle_call});
        set(S.dcle,'Value',1);
    end

    function  CreatSolutionMode
        % Create the button group for solution mode
        S.mode.bg = uibuttongroup('parent',S.PnlA,'visible','on','Position',[0.05 0.68 0.9 0.08],...
            'title','Mode','BackgroundColor','white');
        % Create two radio buttons in the button group.
        S.mode.ems = uicontrol('Style','Radio','String','EMB',...
            'pos',[0.1 0.3 0.3 0.5],'parent',S.mode.bg);
        S.mode.size = uicontrol('Style','Radio','String','HL',...
            'pos',[0.6 0.3 0.3 0.5],'parent',S.mode.bg);
        % Initialize some button group properties.
        set(S.mode.bg,'SelectionChangeFcn',@mode_call);
    end

    function  CreatControlConcern
        % Create the button group for control cost concern mode
        S.cost = uibuttongroup('parent',S.PnlA,'visible','on','Position',[0.05 0.52 0.9 0.13],...
            'title','Control Concern','BackgroundColor','white');
        % Create two radio buttons in the button group.
        uicontrol('Style','Radio','String','Fuel',...
            'pos',[0.05 0.5 0.3 0.5],'parent',S.cost,'Enable','off');
%         uicontrol('Style','Radio','String','Dual',...
%             'pos',[0.35 0.5 0.4 0.5],'parent',S.cost,'Enable','off');
        uicontrol('Style','Radio','String','Emission',...
            'pos',[0.65 0.5 0.35 0.5],'parent',S.cost,'Enable','off');
        % Initialize some button group properties.
        %         set(S.cost,'SelectionChangeFcn','callback',@cost_call);
        % creat slidebar for dual control concern
        S.slide = uicontrol('Style','slider',...
            'pos',[0.05 0.1 0.9 0.25],'parent',S.cost,...
            'BackgroundColor',BackColor,'Enable','on','callback',@cost_call);
        
        
    end

    function  CreatDesignVariable
        
        % Create the button group for design and ems minimum scaling module design
        % variable
        %         S.desvar.bg = uibuttongroup('parent',S.PnlA,'visible','on','Position',[0.05 0.21 0.9 0.15],...
        %             'title','Design Variable','BackgroundColor','white');
        %         % Create two radio buttons in the button group.
        %         S.desvar.both = uicontrol('Style','Radio','String','Both',...
        %             'pos',[0.05 0.01 0.3 0.3],'parent',S.desvar.bg);
        %         S.desvar.elec = uicontrol('Style','Radio','String','Electric Set',...
        %             'pos',[0.05 0.35 0.6 0.3],'parent',S.desvar.bg);
        %         S.desvar.eng = uicontrol('Style','Radio','String','Engine',...
        %             'pos',[0.05 0.7 0.35 0.3],'parent',S.desvar.bg);
        %
        
    end

    function  CreatNominalScaled
        % Create the button group for nominal scaled value for single run
        S.nomscle.bg = uibuttongroup('parent',S.PnlA,'visible','on','Position',[0.05 0.28 0.9 0.21],...
            'title','EMS Scale','BackgroundColor','white');
        S.nomscle.batttext = uicontrol('Style','text','String','Battery:',...
            'pos',[0.05 0.09 0.25 0.14],'parent',S.nomscle.bg);
        S.nomscle.battedit = uicontrol('Style','edit','String','1',...
            'pos',[0.35 0.09 0.25 0.19],'parent',S.nomscle.bg,'BackgroundColor',BackColor,'callback',@nomscle_call);
        
        S.nomscle.mottext = uicontrol('Style','text','String','Motor:',...
            'pos',[0.05 0.47 0.2 0.14],'parent',S.nomscle.bg);
        S.nomscle.motedit = uicontrol('Style','edit','String','1',...
            'pos',[0.35 0.47 0.25 0.19],'parent',S.nomscle.bg,'BackgroundColor',BackColor,'callback',@nomscle_call);
        
        S.nomscle.engtext = uicontrol('Style','text','String','Engine:',...
            'pos',[0.05 0.78 0.2 0.15],'parent',S.nomscle.bg);
        S.nomscle.engedit = uicontrol('Style','edit','String','1',...
            'pos',[0.35 0.78 0.25 0.19],'parent',S.nomscle.bg,'BackgroundColor',BackColor,'callback',@nomscle_call);
        
        S.nomscle.text = uicontrol('Style','text','String','X nominal',...
            'pos',[0.6 0.47 0.4 0.19],'parent',S.nomscle.bg);
        
        
        
    end

    function  CreatDesignConstraint
        % Create the button group for design constrain
        %         S.descsn.bg = uibuttongroup('parent',S.PnlA,'visible','on','Position',[0.05 0.01 0.9 0.18],...
        %             'title','Design Constraint','BackgroundColor','white');
        %         % Create design constrain checkboxes in the button group.
        %         S.descsn.hl = uicontrol('Style','checkbox','String','Hybrid Level',...
        %             'pos',[0.05 0.01 0.6 0.3],'parent',S.descsn.bg);
        %         S.descsn.acc = uicontrol('Style','checkbox','String','Accelertion',...
        %             'pos',[0.05 0.25 0.6 0.3],'parent',S.descsn.bg);
        %         S.descsn.p2w  = uicontrol('Style','checkbox','String','Power to Weight',...
        %             'pos',[0.05 0.46 0.6 0.3],'parent',S.descsn.bg);
        %         S.descsn.op = uicontrol('Style','checkbox','String','Overall Power',...
        %             'pos',[0.05 0.7 0.6 0.3],'parent',S.descsn.bg);
        S.descsn.bg = uibuttongroup('parent',S.PnlA,'visible','on','Position',[0.05 0.05 0.9 0.18],...
            'title','EMS Scale','BackgroundColor','white');
        
        S.descsn.p2wtext = uicontrol('Style','text','String','Power2Weight:',...
            'pos',[0.05 0.27 0.4 0.2],'parent',S.descsn.bg);
        S.descsn.p2wval = uicontrol('Style','edit','String','100',...
            'pos',[0.55 0.27 0.25 0.19],'parent',S.descsn.bg,'BackgroundColor',BackColor,'callback',@nomscle_call);
        
        S.descsn.hltext = uicontrol('Style','text','String','Hybrid Level:',...
            'pos',[0.05 0.67 0.4 0.15],'parent',S.descsn.bg);
        S.descsn.hlval = uicontrol('Style','edit','String','0.5',...
            'pos',[0.55 0.67 0.25 0.19],'parent',S.descsn.bg,'BackgroundColor',BackColor,'callback',@nomscle_call);
        
    end

    function  CreatCycleData
        rnames = {'','','','',''};
        cnames = {'Parameter','Low','High'};
        S.cycledata = uitable('parent', S.PnlB,'position',[0.05 0.72 0.9 0.257],...
            'backgroundcolor',[236/256 235/256 180/256; 1 1 1;],'ColumnWidth',{92,47,47},'ColumnName',cnames...
            ,'RowName',rnames);
    end

    function  CreatControlData
        rnames = {''};
        cnames = {'Control','Fuel','Emission'};
        S.controldata = uitable('parent', S.PnlB,'position',[0.05 0.57 0.9 0.1],...
            'backgroundcolor',[236/256 235/256 180/256; 1 1 1;],'ColumnWidth',{50,66,70},'ColumnName',cnames...
            ,'RowName',rnames);
        SetControlData;
    end

    function  CreatMinScaleData
        rnames = {''};
        cnames = {'Compt','Power [Kw]','Torque [N.m]'};
        S.minscaledata = uitable('parent', S.PnlB,'position',[0.05 0.39 0.9 0.138],...
            'backgroundcolor',[236/256 235/256 180/256; 1 1 1;],'ColumnWidth',{43,67,76},'ColumnName',cnames...
            ,'RowName',rnames);
        SetMinScaleData;
    end

    function  CreatCostData
        rnames = {''};
        cnames = {'Cost','Value'};
        S.costdata = uitable('parent', S.PnlB,'position',[0.05 0.175 0.9 0.15],...
            'backgroundcolor',[236/256 235/256 180/256; 1 1 1;],'ColumnWidth',{90,96},'ColumnName',cnames...
            ,'RowName',rnames);
        %         SetCostData(0);
    end

    function  CreatActionButtons
        % creat exit action button
        S.ex = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.01 0.1 0.1 0.8],'CData',imread('Accesories\Icon\exit.png','png'),'callback',@exit_call);
        % creat run action button
        S.run = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.12 0.1 0.1 0.8],'CData',imread('Accesories\Icon\play.png','png'),'callback',{@run_call});
        % creat dp setting action buttons
        S.settdpfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.23 0.1 0.1 0.8],'CData',imread('Accesories\Icon\set.png','png'),'callback',@settdpfile_call);
        S.settdesfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.34 0.1 0.1 0.8],'CData',imread('Accesories\Icon\set.png','png'),'callback',@settdesfile_call);
        S.vehmodelfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.45 0.1 0.1 0.8],'CData',imread('Accesories\Icon\veh.jpg','jpg'),'callback',@vehmodelfile_call);
        S.vehmodelfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.56 0.1 0.1 0.8],'CData',imread('Accesories\Icon\batt.jpg','jpg'),'callback',@battmodelfile_call);
		
		S.vehmodelfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
            'String', '',...
            'Position', [0.67 0.1 0.1 0.8],'CData',imread('Accesories\Icon\batt.jpg','jpg'),'callback',@PrintFunction_call);
        %         S.battmodelfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
        %             'String', '',...
        %             'Position', [0.67 0.1 0.1 0.8],'CData',imread('Icon\set.png','png'),'callback',@settdesfile_call);
        % %         S.settdesfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
        %             'String', '',...
        %             'Position', [0.78 0.1 0.1 0.8],'CData',imread('Icon\set.png','png'),'callback',@settdesfile_call);
        %         S.settdesfile = uicontrol('parent',S.PnlC,'Style', 'pushbutton',...
        %             'String', '',...
        %             'Position', [0.89 0.1 0.1 0.8],'CData',imread('Icon\set.png','png'),'callback',@settdesfile_call);
    end

    function  dcle_call(~,~)
        dricy  = get(S.dcle,'Value');
        if get(S.mode.ems,'Value') % EMS Mode
            sf.b   = str2double(get(S.nomscle.battedit,'String'));
            sf.m   = str2double(get(S.nomscle.motedit,'String'));
            sf.e   = str2double(get(S.nomscle.engedit,'String'));
        else
            p2w    = str2double(get(S.descsn.p2wval,'String'));
            hl     = str2double(get(S.descsn.hlval,'String'));
            sf = PowerSolution(p2w,hl);
        end
        dem    = DriveTrain(dricy,sf);
        nmdl    = ReadNominal;
        mdl     = ModelScale(nmdl,sf);
        ClearPlot;
        SetCycleData;
        res.fc=0; res.co2 =0;
        SetCostData(res);
        SetMinScaleData;
        PostProcess(0,0,0,0)
    end

    function  exit_call(~,~)
        
        close;
        
    end

    function  mode_call(~,~)
        
        if get(S.mode.ems,'Value') % EMS Mode
            
            set(S.descsn.hlval,'Enable','off');
            set(S.descsn.hltext,'Enable','off');
            set(S.descsn.p2wval,'Enable','off');
            set(S.descsn.p2wtext,'Enable','off');
            set(S.nomscle.batttext,'Enable','on');
            set(S.nomscle.battedit,'Enable','on');
            set(S.nomscle.mottext,'Enable','on');
            set(S.nomscle.motedit,'Enable','on');
            set(S.nomscle.engtext,'Enable','on');
            set(S.nomscle.engedit,'Enable','on');
            set(S.nomscle.text,'Enable','on');
            dcle_call;
            
        else
            set(S.descsn.hlval,'Enable','on');
            set(S.descsn.hltext,'Enable','on');
            set(S.descsn.p2wval,'Enable','on');
            set(S.descsn.p2wtext,'Enable','on');
            set(S.nomscle.batttext,'Enable','off');
            set(S.nomscle.battedit,'Enable','off');
            set(S.nomscle.mottext,'Enable','off');
            set(S.nomscle.motedit,'Enable','off');
            set(S.nomscle.engtext,'Enable','off');
            set(S.nomscle.engedit,'Enable','off');
            set(S.nomscle.text,'Enable','off');
            dcle_call;
        end
    end

    function  cost_call(~,~)
        
        Fuel = (1- get(S.slide,'Value'))*100;
        Co2  = (get(S.slide,'Value'))*100;
        dat    = {'Cost', [num2str(Fuel),'%'], [num2str(Co2),'%']};
        set(S.controldata,'Data',dat);
        
        
    end

    function  run_call(~,~)
        
        % read driving cycle and nominal sclaed value from interface %
        dricy  = get(S.dcle,'Value');
        if get(S.mode.ems,'Value')
            sf.b   = str2double(get(S.nomscle.battedit,'String'));
            sf.m   = str2double(get(S.nomscle.motedit,'String'));
            sf.e   = str2double(get(S.nomscle.engedit,'String'));
        else
            p2w    = str2double(get(S.descsn.p2wval,'String'));
            hl     = str2double(get(S.descsn.hlval,'String'));
            sf     = PowerSolution(p2w,hl);
        end
        % call manager control to solve and plot the result %
        W = get(S.slide,'Value');
        [res, bnd, dypg]= ManagerControl(dricy,sf,W);
        ClearPlot;
        SetCostData(res);
        PostProcess(res,bnd,dypg,1);
        %             PostProcess2(res,bnd,dypg,1);
        
    end

    function  settdpfile_call(~,~)
        
        open('DPSetting.m');
        
        
        
    end

    function  settdesfile_call(~,~)
        
        open('DesignSetting.m');
        
    end

    function  vehmodelfile_call(~,~)
        
        open('DriveTrain.m');
        
    end

    function  battmodelfile_call(~,~)
        
        open('BatteryDynamic.m');
        
    end

    function  nomscle_call(~,~)
        dcle_call;
        
    end

    function  SetCycleData
        
        dat    = {'Power [kw]',min(dem.P)/1000,max(dem.P)/1000;...
            'Speed [m/s]','0',max(dem.V);...
            'Acc [m/s^2]',min(dem.A),max(dem.A);...
            'Torque',min(dem.T),max(dem.T);...
            'Distance [Km]','---',dem.S/1000;
            'Weight [m]','---',dem.M};
        set(S.cycledata,'Data',dat);
    end

    function  SetControlData
        %         dat    = {'Cost','100%','0%'};
        %         set(S.controldata,'Data',dat);
    end

    function  SetMinScaleData
        dricy  = get(S.dcle,'Value');
        if get(S.mode.ems,'Value') % EMS Mode
            sf.b   = str2double(get(S.nomscle.battedit,'String'));
            sf.m   = str2double(get(S.nomscle.motedit,'String'));
            sf.e   = str2double(get(S.nomscle.engedit,'String'));
        else
            p2w    = str2double(get(S.descsn.p2wval,'String'));
            hl     = str2double(get(S.descsn.hlval,'String'));
            sf = PowerSolution(p2w,hl);
        end
        dem    = DriveTrain(dricy,sf);
        nmdl   = ReadNominal;
        mdl    = ModelScale(nmdl,sf);
        dat    = {'Engine',max(mdl.eng.tm.*mdl.eng.w)/1000,max(mdl.eng.tm);
            'Motor',max(mdl.mot.w.*mdl.mot.tm)/1000,max(mdl.mot.tm);
            'Battery',min(mdl.bat.V)^2/(4*max(mdl.bat.R)*1000),[num2str(mdl.bat.Q/3600),'[Ah]']};
        
        set(S.minscaledata,'Data',dat);
        
    end

    function  SetCostData(res)
        
        dat    = {'Co2 [g/km]',res.co2*1000/dem.S;
            'Fuel [Lit/100km]',res.fc*100000/dem.S};
        set(S.costdata,'Data',dat);
        
    end

    function  ClearPlot
        
        delete(get(S.PnlD,'children'));
        
    end

    function  CopyPlot(AxesHdl,~)
        S.J = figure ;
        New_hdl = copyobj(AxesHdl,S.J);
        set(New_hdl,'outerposition',[0 0 1 1]);
		legend('BSFC(g/kWh)','Max Torque');
		
        
    end

    function  PostProcess(res,bnd,dypg,flg)
        
        
        % plot demand power and cycle speed
        spd = axes;
        plot(dem.t, dem.V,'linewidth',2);
        set(spd,'linewidth',2);
        ylabel('Speed [m/s]');
        set(spd,'parent',S.PnlD,'position',[0.08,0.76,0.4,0.2],'ButtonDownFcn',{@CopyPlot});
        set(spd,'linewidth',2,'XLim',[0 length(dem.t)]);
        xlabel('Time [s]');
        box on;
        grid;
        
        

        % plot state of charge
        soc = axes;
        hold on;
        if flg == 1
            plot(res.X,'linewidth',2);
            for k=1:length(res.X)-2
                line([k k+1],[min(dypg.XI{k}) min(dypg.XI{k+1})],'linewidth',2,'color','green')
            end
            for k=1:1:length(res.X)-1
                if ~isempty(bnd.X.l{k}) && ~isempty(bnd.X.l{k+1})
                    line([k k+1],[bnd.X.l{k} bnd.X.l{k+1}],'color','red','linewidth',2);
                end
            end
            for k=1:1:length(res.X)-1
                if ~isempty(bnd.X.h{k}) && ~isempty(bnd.X.h{k+1})
                    line([k k+1],[bnd.X.h{k} bnd.X.h{k+1}],'color','red','linewidth',2);
                end
            end
            
        end
        xlabel('Time [s]'); ylabel('SOC (%)');
        box on; grid;
        set(soc,'parent',S.PnlD,'position',[0.08,0.5,0.4,0.2],...
            'linewidth',2,'XLim',[0 length(dem.t)],'Ylim',[0.3 0.7],...
            'ButtonDownFcn',{@CopyPlot});
        hold off;
        
        
        % plot demand and available torque
        pwr = axes;
        hold on;
        maxx = (interp1(mdl.eng.w,mdl.eng.tm,dem.W,'linear',0) + interp1(mdl.mot.w,mdl.mot.tm,dem.W));
        plot(1:length(dem.W),dem.T,1:length(dem.W),maxx,'linewidth',2);
        legend('demand','available','Orientation','Horizental');
        xlabel('Time [s]'); ylabel('Torque [N.m]');
        box on; grid;
        set(pwr,'parent',S.PnlD,'position',[0.5,0.76,0.42,0.2],...
            'linewidth',2,'XLim',[0 length(dem.t)],...
            'YAxisLocation','right','ButtonDownFcn',{@CopyPlot});
        hold off;
        
        % plot engine operating points
        engfc = axes;
        hold on;
        if flg == 1
            plot(res.R(:,2),res.R(:,1),'O');
        end
        
		cnt = ContourCorrecter(mdl.eng.w(2:end), mdl.eng.t(2:end), mdl.eng.tm(2:end), mdl.eng.fc_g_kwh(2:end,2:end), 0, 'Engine');
        [Cx,h]=contour(engfc, cnt.W,  cnt.T , cnt.E ,[650 500 450 400 350 325 300 280 260 250 245 240],'LineWidth',2);
		plot(engfc, mdl.eng.w(2:end) , mdl.eng.tm(2:end) ,'linewidth',2,'color','r');
        clabel(Cx,h,'LabelSpacing',1672,'FontSize',8);
		xlabel('Speed (rad/s)');
        ylabel('Engine Torque (N.m)');
		set(engfc,'parent',S.PnlD,'position',[0.08,0.1,0.4,0.34]);
% 		legend(engfc, 'BSFC(g/kWh)','Max Torque');
        set(engfc,...
            'linewidth',2,'XLim',[min(mdl.eng.w(2:end)) max(mdl.eng.w)],...
			'YLim',[min(mdl.eng.t(2:end)) max(mdl.eng.t)+10],'ButtonDownFcn',{@CopyPlot});
		box on; hold off;
        
        
        
       
        engco2 = axes;
        hold on;
        plot(dem.E ,'linewidth',2,'color','r');
        box on; grid; hold off;
        
        set(engco2,'parent',S.PnlD,'position',[0.5,0.5,0.42,0.2],...
            'linewidth',2,'YAxisLocation','right','ButtonDownFcn',{@CopyPlot});
        
         % plot motor operating points
        mot = axes;
            hold on;
%             xlabel('Speed (rad/s)');
            ylabel('Motor Torque (N.m)');
            plot(mdl.mot.w , mdl.mot.tm , mdl.mot.w, -mdl.mot.tm ,'linewidth',2,'color','r');
            for SS=1:1:length(mdl.mot.w)
                mdl.mot.eff( mdl.mot.t > mdl.mot.tm(SS) | mdl.mot.t < -mdl.mot.tm(SS) , SS) = NaN;
            end
            [Cx,h]=contour(mdl.mot.w , mdl.mot.t , mdl.mot.eff ,':','LineWidth',1);
%             clabel(Cx,h);
            if flg == 1
                plot(res.R(:,4),res.R(:,3),'O');
            end
            hold off; box on; 
            xlim([0 600]);
            set(mot,'parent',S.PnlD,'position',[0.50,0.1,0.42,0.34],...
                'linewidth',2,'YAxisLocation','right','ButtonDownFcn',{@CopyPlot});
	end
	
	function  PrintFunction_call(~,~)
		print(S.J,'-dpng','-r300');
	end


end






