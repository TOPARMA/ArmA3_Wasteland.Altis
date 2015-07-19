// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: onKeyPress.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_key", "_shift", "_ctrl", "_alt", "_handled"];

_key = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;

_handled = false;

// ********** Hardcoded keys **********
switch (true) do
{
	// U key
	case (_key == 22):
	{
		execVM "client\systems\adminPanel\checkAdmin.sqf";
	};

	// Tilde (key above Tab)
	case (_key == 41):
	{
		[] spawn loadPlayerMenu;
		_handled = true;
	};

	// Home & Windows keys
	case (_key in [199,219,220]):
	{
		showPlayerNames = if (isNil "showPlayerNames") then { true } else { !showPlayerNames };
	};

	// Earplugs - End Key
	case (_key == 207):
	{
		if (soundVolume > 0.5) then
		{
			0.5 fadeSound 0.2;
			["You've inserted your earplugs.", 5] call mf_notify_client;
		}
		else
		{
			0.5 fadeSound 1;
			["You've taken out your earplugs.", 5] call mf_notify_client;
		};
	};
};

// ********** Action keys **********

// Remove Locking On ability
if (!_handled && (inputAction "LockTarget" > 0 || inputAction "LockTargets" > 0)) then
{
	private["_pweapon","_vweapon","_locktarget","_maxLockonDistance"];
	_lockTarget = cursorTarget;
	_pweapon = currentWeapon player;
	_vweapon = currentWeapon (vehicle player);
	_maxLockonDistance = (["A3W_maxLockonDistance", 0] call getPublicVar) max 0;

	switch (true) do
	{
		case (_pweapon == "launch_Titan_short_F" || {_pweapon == "launch_I_Titan_short_F" || {_pweapon == "launch_O_Titan_short_F"}}): { systemChat format ["Locking Disabled for Titan AT/AP Missiles"]; _handled = true; };
		case (_vweapon == "missiles_DAGR" && (player distance _lockTarget) >= _maxLockonDistance): { systemChat format ["Locking Disabled for DAGR Missiles beyond %1M.",_maxLockonDistance]; _handled = true; };
		case (_vweapon == "missiles_SCALPEL" && (player distance _lockTarget) >= _maxLockonDistance): { systemChat format ["Locking Disabled for SCALPEL  Missiles beyond %1M.",_maxLockonDistance]; _handled = true; };
		case (_vweapon == "Missile_AGM_01_Plane_CAS_02_F" && (player distance _lockTarget) >= _maxLockonDistance): { systemChat format ["Locking Disabled for Sharur Missiles beyond %1M.",_maxLockonDistance]; _handled = true; };
		case (_vweapon == "Missile_AGM_02_Plane_CAS_01_F" && (player distance _lockTarget) >= _maxLockonDistance): { systemChat format ["Locking Disabled for Macer Missiles beyond %1M.",_maxLockonDistance]; _handled = true; };
		
		
	};	
};


// Parachute
if (!_handled && _key in actionKeys "GetOver") then
{
	if (alive player) then
	{
		_veh = vehicle player;

		if (_veh == player) then
		{
			if ((getPos player) select 2 > 2.5) then
			{
				true call fn_openParachute;
				_handled = true;
			};
		}
		else
		{
			if (_veh isKindOf "ParachuteBase") then
			{
				// 1s cooldown after parachute is deployed so you don't start falling again if you double-tap the key
				if (isNil "openParachuteTimestamp" || {diag_tickTime - openParachuteTimestamp >= 1}) then
				{
					moveOut player;
					_veh spawn
					{
						sleep 1;
						deleteVehicle _this;
					};
				};
			};
		};
	};
};

// Eject
if (!_handled && _key in actionKeys "GetOut") then
{
	_veh = vehicle player;

	if (alive player && _veh != player) then
	{
		if (_ctrl && {_veh isKindOf 'Air' && !(_veh isKindOf 'ParachuteBase')}) then
		{
			[] spawn
			{
				if !(["Are you sure you want to eject?", "Confirm", true, true] call BIS_fnc_guiMessage) exitWith {};
				[[], fn_emergencyEject] execFSM "call.fsm";
			};
		};
	};
};

// Scoreboard
if (!_handled && _key in actionKeys "NetworkStats") then
{
	if (_key != 25 || // 25 = P
	   ((!_ctrl || {!(486539289 in actionKeys "NetworkPlayers") && isNil "TFAR_fnc_TaskForceArrowheadRadioInit"}) && // 486539289 = Left Ctrl + P
	   (!_shift || {!(704643042 in actionKeys "NetworkPlayers")}))) then // 704643042 = Left Shift + P
	{
		if (alive player && isNull (uiNamespace getVariable ["ScoreGUI", displayNull])) then
		{
			call loadScoreboard;
		};

		_handled = true;
	};
};

// Push-to-talk
if (!_handled && _key in (actionKeys "PushToTalk" + actionKeys "PushToTalkAll")) then
{
	[true] call fn_voiceChatControl;
};

_handled
