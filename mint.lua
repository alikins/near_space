--[[
@title Minimalistic Intervalometer
@param a Shooting interval, min
@default a 0
@param b ...sec
@default b 10
--]]
 
Interval = a*60000 + b*1000
logfile=io.open("A/paramdmp.log","wb")
 
function TakePicture()
	press("shoot_half")
        repeat sleep(50) until get_shooting() == true
	press("shoot_full")
	release("shoot_full")
	repeat sleep(50) until get_shooting() == false	
        release "shoot_half"
	a = get_temperature(0)
	b = get_temperature(1)
	c = get_temperature(2)
	logfile:write(string.format("%s %d %d %d\n", os.time(), a,b,c))
	logfile:flush()
	set_backlight(0)
end
 
repeat
	StartTick = get_tick_count()
	TakePicture()
	sleep(Interval - (get_tick_count() - StartTick))
until false
logfile:close()
