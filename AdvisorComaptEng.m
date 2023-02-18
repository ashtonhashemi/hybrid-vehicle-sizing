function eng = AdvisorComaptEng(Name)
	run(Name);
	eng.w  = fc_map_spd;
	eng.t  = fc_map_trq;
	eng.tm = fc_max_trq;
	eng.gs = fc_fuel_map';
	eng.eff = (1000./(fc_fuel_map_gpkWh'*12.2))*100;
	eng.fc_g_kwh = fc_fuel_map_gpkWh';
	
end
