ESX 				= nil
local Users         = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('if_dead:getValue', function(source, cb, targetSID)
    if Users[targetSID] then
        cb(Users[targetSID])
    else
        cb({value = false, time = 0})
    end
end)

local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
ESX.RegisterServerCallback('if_dead:getOtherPlayerData', function(source, cb, target)

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name        = GetPlayerName(target),
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      money       = xPlayer.get('money'),
      weapons     = xPlayer.loadout

    }

      cb(data)

end)


RegisterServerEvent('if_dead:stealPlayerItem')
AddEventHandler('if_dead:stealPlayerItem', function(target, itemType, itemName, amount)

    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if itemType == 'item_standard' then
        print("item_standard")

        local label = sourceXPlayer.getInventoryItem(itemName).label
        local itemLimit = sourceXPlayer.getInventoryItem(itemName).limit
        local sourceItemCount = sourceXPlayer.getInventoryItem(itemName).count
        local targetItemCount = targetXPlayer.getInventoryItem(itemName).count

        if amount > 0 and targetItemCount >= amount then
    
            if itemLimit ~= -1 and (sourceItemCount + amount) > itemLimit then
                TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('ex_inv_lim_target'))
                TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('ex_inv_lim_source'))
            else

                targetXPlayer.removeInventoryItem(itemName, amount)
                sourceXPlayer.addInventoryItem(itemName, amount)

                TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. amount .. ' ' .. label .. ' ~w~' .. _U('from_your_target') )
                TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. amount .. ' ' .. label )

            end

        else
             TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
        end

    end

  if itemType == 'item_money' then

    if amount > 0 and targetXPlayer.get('money') >= amount then

      targetXPlayer.removeMoney(amount)
      sourceXPlayer.addMoney(amount)

      TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~$' .. amount .. ' ~w~' .. _U('from_your_target') )
      TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount )

    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    end

  end

  if itemType == 'item_account' then

    if amount > 0 and targetXPlayer.getAccount(itemName).money >= amount then

        targetXPlayer.removeAccountMoney(itemName, amount)
        sourceXPlayer.addAccountMoney(itemName, amount)

        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~r~$' .. amount .. ' ~w~' .. _U('black_money') .. ' ' .. _U('from_your_target') )
        TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount .. ' ~w~' .. _U('black_money') )

    else
        TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    end

  end

  if itemType == 'item_weapon' then
    print("Item_weapon")
    if amount == nil then amount = 0 end

        targetXPlayer.removeWeapon(itemName, amount)
        sourceXPlayer.addWeapon(itemName, amount)

        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. amount .. ' ' .. label .. ' ~w~' .. _U('from_your_target') )
        TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. amount .. ' ' .. label )
  end
end)

RegisterServerEvent("if_dead:update")
AddEventHandler("if_dead:update", function(bool)
	local source = source
	Users[source] = {value = bool, time = os.time()}
end)

RegisterServerEvent("if_dead:getValue")
AddEventHandler("if_dead:getValue", function(targetSID)
    local source = source
	if Users[targetSID] then
		TriggerClientEvent("if_dead:returnValue", source, Users[targetSID])
	else
		TriggerClientEvent("if_dead:returnValue", source, Users[targetSID])
	end
end)


---- HANDCUFFS + ROPE ----

ESX.RegisterServerCallback('if_dead:getItemQ', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count
    cb(quantity)
end)