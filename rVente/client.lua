
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)


local openedMenu = false
local mainMenu = RageUI.CreateMenu("Vendeur", "Menu")
local subMenu = RageUI.CreateSubMenu(mainMenu, "Pistolet", "Menu")
local subMenu2 = RageUI.CreateSubMenu(mainMenu, "Mitraillettes", "Menu")
local subMenu3 = RageUI.CreateSubMenu(mainMenu, "Fusil à Pompe", "Menu")
local subMenu4 = RageUI.CreateSubMenu(mainMenu, "Fusil d'Assaut", "Menu")
mainMenu.Closed = function() openedMenu = false FreezeEntityPosition(PlayerPedId(), false) end


function OpenMenu()
    if openedMenu then 
        openedMenu = false 
        return 
    else
        openedMenu = true 
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while openedMenu do 
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("~p~Pistolet", nil, {RightLabel = "→→"}, true, {}, subMenu)
                    RageUI.Button("~b~Mitraillettes", nil, {RightLabel = "→→"}, true, {}, subMenu2)
                    RageUI.Button("~p~Fusil à Pompe", nil, {RightLabel = "→→"}, true, {}, subMenu3)
                    RageUI.Button("~b~Fusil d'Assaut", nil, {RightLabel = "→→"}, true, {}, subMenu4)
                end)
                RageUI.IsVisible(subMenu, function()                 
                    if #Config.Categories.Pistol ~= 0 then 
                        RageUI.Separator("↓ Liste des Pistolets ↓")
                        for k, v in pairs(Config.Categories.Pistol) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("Memel:BuyWeapon", v.name, v.label, v.price)
                                end, 

                            })
                        end 
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Il n'y as pas de Pistolet")
                        RageUI.Separator("")
                    end       
                end)
                RageUI.IsVisible(subMenu2, function()
                    if #Config.Categories.Mitraillettes ~= 0 then 
                        RageUI.Separator("↓ Liste des Mitraillettes ↓")
                        for k, v in pairs(Config.Categories.Mitraillettes) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("Memel:BuyWeapon", v.name, v.label, v.price)
                                end, 

                            })
                        end                     
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Il n'y as pas de Mitraillettes")
                        RageUI.Separator("")
                    end                     
                end)  
                RageUI.IsVisible(subMenu3, function()
                    if #Config.Categories.Pompes ~= 0 then 
                        RageUI.Separator("↓ Liste des Fusils à Pompe ↓")
                        for k, v in pairs(Config.Categories.Pompes) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("Memel:BuyWeapon", v.name, v.label, v.price)
                                end, 

                            })
                        end                     
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Il n'y as pas de Fusil à Pompes")
                        RageUI.Separator("")
                    end                     
                end)
                RageUI.IsVisible(subMenu4, function()
                    if #Config.Categories.Fusils ~= 0 then 
                        RageUI.Separator("↓ Liste des Fusils d'Assaut ↓")
                        for k, v in pairs(Config.Categories.Fusils) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("Memel:BuyWeapon", v.name, v.label, v.price)
                                end, 

                            })
                        end                     
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Il n'y as pas de Fusil d'Assaut")
                        RageUI.Separator("")
                    end                     
                end)
                Wait(1.0)
            end
        end)
    end
end



Citizen.CreateThread(function()
    for k, v in pairs(Config.Position.Shops) do 
        while not HasModelLoaded(v.pedModel) do
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel), v.pedPos, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do 
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not openedMenu then 
            for k, v in pairs(Config.Position.Shops) do 
                if #(myCoords - v.pos) < 1.0 then 
                    nofps = true
                    Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour parler au ~b~vendeur", 1) 
                    if IsControlJustPressed(0, 38) then                  
                        OpenMenu()
                    end 
                end 
            end 
        end
        if nofps then 
            Wait(1)
        else 
            Wait(1500)
        end 
    end
end)
