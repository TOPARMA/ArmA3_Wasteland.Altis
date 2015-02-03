//	@file Version: 1.0
//	@file Name: lock.sqf
//	@file Author: Cael817, based on stuff i found and a lot of help
//	@file Created: 20141020

private ["_vehicle","_nearvehicle"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Ship", "Air"], 7];
_vehicle = _nearvehicle select 0;
	
	if (local _vehicle) then
			{
				_vehicle lock true;
				//(hint "local";
			}
			else
			{
				[[netId _vehicle, 2], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Lock
				//hint "not local";
			};

	_vehicle setVariable ["objectLocked", true, true];
	_vehicle setVariable ["R3F_LOG_disabled",true,true];
		
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "client\sounds\carlock.ogg";
	playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 1, 1, 15];
	_vehicle engineOn false;
	player action ["lightOn", _vehicle];
	sleep 0.5;
	player action ["lightOff", _vehicle];
	titleText ["Vehicle Locked!","PLAIN DOWN"]; titleFadeOut 2;
	
