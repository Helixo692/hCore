-- KEYBIND CHANGEMENT PLACE VEHICLE
Citizen.CreateThread(function()
	while true do
	local plyPed = PlayerPedId()
	if IsPedSittingInAnyVehicle(plyPed) then
	local plyVehicle = GetVehiclePedIsIn(plyPed, false)
CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
	if CarSpeed <= 40.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 60 km/h
	if IsControlJustReleased(0, 157) then -- conducteur
	SetPedIntoVehicle(plyPed, plyVehicle, -1)
Citizen.Wait(10)
end
	if IsControlJustReleased(0, 158) then -- avant droit
	SetPedIntoVehicle(plyPed, plyVehicle, 0)
Citizen.Wait(10)
end
	if IsControlJustReleased(0, 160) then -- arriere gauche
	SetPedIntoVehicle(plyPed, plyVehicle, 1)
Citizen.Wait(10)
end
	if IsControlJustReleased(0, 164) then -- arriere gauche
	SetPedIntoVehicle(plyPed, plyVehicle, 2)
Citizen.Wait(10)
		end
	end
end
Citizen.Wait(10) -- Fix Crash Client
	end
end)

-- ENLEVER LA POLICE
Citizen.CreateThread(function() -- Remove Police NPC
	while true do
			Citizen.Wait(10)
			local playerPed = GetPlayerPed(-1)
			local playerLocalisation = GetEntityCoords(playerPed)
			ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
			DisablePlayerVehicleRewards(PlayerId()) -- No drop weapon in car
	end
end)

-- LIMITEUR DE PNJ 

DensityMultiplier = 0.00
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetPedDensityMultiplierThisFrame(DensityMultiplier)
        SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
    end
end)

Désactiver le bunny hop (saut à plusieurs reprises) (coté client) 
local NumberJump = 15

Citizen.CreateThread(function()
  local Jump = 0
  while true do

      Citizen.Wait(1)

      local ped = PlayerPedId()

      if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then

        Jump = Jump + 1

          if Jump == NumberJump then

              SetPedToRagdoll(ped, 5000, 1400, 2)

              Jump = 0

          end

      else 

          Citizen.Wait(500)
          
      end
  end
end)

Citizen.CreateThread(function()
	while true do
			Citizen.Wait(5)
			if IsControlPressed(0, 25)
					then DisableControlAction(0, 22, true)
			end
	end
end) 


Citizen.CreateThread(function()
	while true do
			Citizen.Wait(0)
			SetPlayerLockon(PlayerId(), false)
	end
end)

-- PNJ NO DROP
function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false
repeat
	if not IsEntityDead(ped) then
	SetPedDropsWeaponsWhenDead(ped, false)
end
	finished, ped = FindNextPed(handle)
until not finished
	EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
	SetWeaponDrops()
Citizen.Wait(500)
  end
end)

-- PVP
AddEventHandler("playerSpawned", function()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
end)

-- KO
local knockedOut = false
local wait = 15
local count = 60
Citizen.CreateThread(function()
	while true do
Citizen.Wait(5)
	local myPed = GetPlayerPed(-1)
	if IsPedInMeleeCombat(myPed) then
		if GetEntityHealth(myPed) < 115 then
			SetPlayerInvincible(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ShowNotification("~r~Vous êtes KO!")
		wait = 15
		knockedOut = true
	SetEntityHealth(myPed, 116)
	end
end
	if knockedOut == true then
			SetPlayerInvincible(PlayerId(), true)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
	if wait >= 0 then
		count = count - 1
	if count == 0 then
		count = 60
			wait = wait - 1
	SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
end
	else
		SetPlayerInvincible(PlayerId(), false)
		 knockedOut = false
	   end
	 end
   end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

--[Anti-Cross]
Citizen.CreateThread(function()
	while true do
Citizen.Wait(0)
	local ped = PlayerPedId()
		if IsPedArmed(ped, 6) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end
	end
end)


-- PAUSE MENU
function SetData()
	players = {}
	for _, player in ipairs(GetActivePlayers()) do
	local ped = GetPlayerPed(player)
	table.insert( players, player )
end
	local name = GetPlayerName(PlayerId())
	local id = GetPlayerServerId(PlayerId())
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', '~m~Template Helixo | ~c~Joueurs: '.. #players .."/1")
end
	Citizen.CreateThread(function()
		while true do
	Citizen.Wait(100)
		SetData()
	end
end)
	Citizen.CreateThread(function()
	AddTextEntry("PM_PANE_LEAVE", "Déconnecter")
end)
	Citizen.CreateThread(function()
	AddTextEntry("PM_PANE_QUIT", "Quitter FiveM")
end)


-- MODE DRIFT
local kmh = 3.6
local mph = 2.23693629
local carspeed = 0
local driftmode = true -- on/off speed
local speed = kmh -- or mph
local drift_speed_limit = 120.0 -- vitesse max
local toggle = 21 -- touche
Citizen.CreateThread(function()
	while true do
Citizen.Wait(1)
	if IsControlJustPressed(1, 118) then
		driftmode = not driftmode
	if driftmode then
         TriggerEvent("chatMessage", 'DRIFT', { 255,255,255}, '^2ON')
    else
         TriggerEvent("chatMessage", 'DRIFT', { 255,255,255}, '^1OFF')
     end
  end
	if driftmode then
		if IsPedInAnyVehicle(GetPed(), false) then
			CarSpeed = GetEntitySpeed(GetCar()) * speed
		if GetPedInVehicleSeat(GetCar(), -1) == GetPed() then
			if CarSpeed <= drift_speed_limit then  
		if IsControlPressed(1, 21) then
        	SetVehicleReduceGrip(GetCar(), true)
         else
        	SetVehicleReduceGrip(GetCar(), false)
        			   end
                    end
                end
            end
        end
    end
end)

function GetPed() return GetPlayerPed(-1) end
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end

-- RICH PRESENCE
Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(VOTRE APP ID)
		SetDiscordRichPresenceAsset('bouh')
        SetDiscordRichPresenceAssetText('Base Template by Helixo')
        SetDiscordRichPresenceAssetSmall('bouh')
        SetDiscordRichPresenceAssetSmallText('Coucou')
		Citizen.Wait(60000)
	end
end)
Citizen.CreateThread(function()
	while true do
		local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
		if VehName == "NULL" then VehName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) end
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		local pId = GetPlayerServerId(PlayerId())
		local pName = GetPlayerName(PlayerId())
		Citizen.Wait(15000)
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." court sur "..StreetName)
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." s'épuise sur "..StreetName)
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." marche sur "..StreetName)
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." est debout sur "..StreetName.."")
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
				if MPH > 50 then
					SetRichPresence("ID: "..pId.." | "..pName.." accélère sur "..StreetName.." à "..MPH.."KM/H dans un(e) "..VehName)
				elseif MPH <= 50 and MPH > 0 then
					SetRichPresence("ID: "..pId.." | "..pName.." est en croisière vers "..StreetName.." à "..MPH.."KM/H dans un(e) "..VehName)
				elseif MPH == 0 then
					SetRichPresence("ID: "..pId.." | "..pName.." est garé sur "..StreetName.." dans un(e) "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
					SetRichPresence("ID: "..pId.." | "..pName.." est en train de survoler "..StreetName.." dans un(e) "..VehName)
				else
					SetRichPresence("ID: "..pId.." | "..pName.." à atterri sur "..StreetName.." dans un(e) "..VehName)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence("ID: "..pId.." | "..pName.." nage")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("ID: "..pId.." | "..pName.." navigue dans un "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("ID: "..pId.." | "..pName.." est dans un sous-marin jaune")
			end
		end
	end
end)