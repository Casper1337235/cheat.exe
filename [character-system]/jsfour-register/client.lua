local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local ESX	 = nil
local open = false
local cam  = nil
local inTutorial = false
-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Open the register form, (call from server)
RegisterNetEvent('jsfour-register:open')
AddEventHandler('jsfour-register:open', function()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end
	--SetCamActive(cam,  true)
	--RenderScriptCams(true,  false,  0,  true,  true)
	--SetCamCoord(cam, -288.92544555664, -2443.6701660156, 591.98687744141)
	--PointCamAtCoord(cam, -169.18321228027, -1056.4204101563, 129.99223327637)

	SetEntityCollision(GetPlayerPed(-1),  false,  false)
	SetEntityVisible(GetPlayerPed(-1),  false)
	FreezeEntityPosition(GetPlayerPed(-1), true);

	SetNuiFocus(true, true)
    open = true
	SendNUIMessage({
		action = "open"
	})
end)

-- Register the player (call from javascript > send to server < callback from server)
RegisterNUICallback('register', function(data, cb)
	cb('ok')
	ESX.TriggerServerCallback('jsfour-register:register', function( success )
		if success then
			SetNuiFocus(false, false)
			open = false

			SendNUIMessage({
				action = "close"
			})

			DoScreenFadeOut(1000)
            Wait(1000)
			SetCamActive(cam,  false)
			RenderScriptCams(false,  false,  0,  true,  true)
			SetEntityCollision(GetPlayerPed(-1),  true,  true)
			SetEntityVisible(GetPlayerPed(-1),  true)
			FreezeEntityPosition(GetPlayerPed(-1), false)
           -- SetEntityCoords(GetPlayerPed(-1), -205.9261, -1014.7672, 29.1380)
            
            TriggerEvent('esx_skin:openSaveableMenu')
            Wait(500)
			DoScreenFadeIn(1000)
            Wait(1000)
            
			

		end
	end, data)
end)




-- Freeze player movements
Citizen.CreateThread(function()
    while true do
			Citizen.Wait(0)
      if open then
	      DisableControlAction(0, 1, true) -- LookLeftRight
	      DisableControlAction(0, 2, true) -- LookUpDown
	      DisableControlAction(0, 24, true) -- Attack
	      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
	      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
	      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
      end
    end
end)
