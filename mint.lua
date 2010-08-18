--[[
@title Minimalistic Intervalometer
@param a Shooting interval, min
@default a 0
@param b ...sec
@default b 15
--]]
 
Interval = a*60000 + b*1000
--logfile=io.open("A/baloon_temp.log","wb")
 
function TakePicture()
	logfile=io.open("A/baloon_temp.log", "ab")
	logfile:seek("end")
	press("shoot_half")
        repeat sleep(50) until get_shooting() == true
	press("shoot_full")
	release("shoot_full")
	repeat sleep(50) until get_shooting() == false	
        release "shoot_half"
	opt_temp = get_temperature(0)
	ccd_temp = get_temperature(1)
	batt_temp = get_temperature(2)
	-- write out vaguely csv style
	batt_voltage = get_vbatt()
	logfile:write(string.format("%s,%d,%d,%d,%d\n", os.time(), opt_temp,ccd_temp,batt_temp,batt_voltage))
	logfile:flush()
	logfile:close()
	-- probably need a delay here, but using a jack in the av port
	-- is probably even better battery wise
	set_backlight(0)
end
 
repeat
	StartTick = get_tick_count()
	TakePicture()
	sleep(Interval - (get_tick_count() - StartTick))
until false
