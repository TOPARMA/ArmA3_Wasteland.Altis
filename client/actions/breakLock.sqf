//	@file Version: 1.0
//	@file Name: breakLock.sqf
//	@file Author: Cael817, based on stuff i found and a lot of help
//	@file Created: 20141020

private ["_vehicle","_nearvehicle"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Ship", "Air"], 7];
_vehicle = _nearvehicle select 0;

 for "_i" from 360 to 0 step -1 do
 {
    hint str _i;
	player action ["lightOn", _vehicle];
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "client\sounds\horn.ogg";
	playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 1, 1, 0];
    sleep 0.5;
	player action ["lightOff", _vehicle];
	sleep 0.5;
	
	if (player distance _vehicle >6 ) then
	{
	hint "Attempt aborted. You need to stay close to the vehicle in order to break in.";
	breakOut "_i";
	};	
};
	
	if (local _vehicle) then
			{
				_vehicle lock 1;
				//hint "local";
			}
			else
			{
				[[netId _vehicle, 1], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Unlock
				//hint "not local";
			};

	_vehicle setVariable ["objectLocked", false, true]; 
	_vehicle setVariable ["R3F_LOG_disabled",false,true];
		
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "client\sounds\carlock.ogg";
	playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 1, 1, 15];
	player action ["lightOn", _vehicle];
	sleep 0.5;
	player action ["lightOff", _vehicle];
	titleText ["You broke in to the vehicle!","PLAIN DOWN"]; titleFadeOut 2;
	player removeItem "ToolKit"; // Added by LouD
