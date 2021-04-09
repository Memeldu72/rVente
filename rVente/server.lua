ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("Memel:BuyWeapon")
AddEventHandler("Memel:BuyWeapon", function(name, label, price)
    if source then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getAccount("black_money").money <= price then return TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez d'argent") end 
        if xPlayer.getWeapon(name) then 
            return TriggerClientEvent("esx:showNotification", source, "~r~Vous avez déjà cette arme")
        else
            TriggerClientEvent("esx:showNotification", source, "Vous venez d'acheter ~b~1x "..label.."~s~ pour ~g~"..ESX.Math.GroupDigits(price).."$~s~ !")
            xPlayer.removeAccountMoney("black_money", price)
            xPlayer.addWeapon(name, 250)
        end       
    end
end)