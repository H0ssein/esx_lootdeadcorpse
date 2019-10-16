ESX                           = nil

local PlayerData = {}
local target_id = GetPlayerServerId(player)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)
    
Citizen.CreateThread(function()
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)
		while true do
			Citizen.Wait(20)
			if PlayerData.job and ( PlayerData.job.name == "jobname-here" or PlayerData.job.name == "jobname-here" then -- comment this line if you want to allow all player to loot
				if IsControlJustReleased(0, 38) then		
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if IsPlayerDead(closestPlayer) then 
						if closestPlayer ~= -1 and closestDistance <= 5.0 then
						OpenBodySearchMenu(closestPlayer)
						end
					end
				end
			end -- comment this line if you want to allow all player to loot
		end
	
end)

	function OpenBodySearchMenu(target, target_id)
	loadAnimDict('amb@medic@standing@kneel@base')
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')
	TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	Citizen.Wait(5000)
	StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search", 1.0)
    ESX.TriggerServerCallback('if_dead:getOtherPlayerData', function(data)

        local elements = {}

        
            table.insert(elements, {
                label      = '[' .. _U('cash') .. '] $' .. data.money,
                value      = 'money',
                type       = 'item_money',
                amount     = data.money,
            })
        
		
            local blackMoney = 0
            for i=1, #data.accounts, 1 do
              if data.accounts[i].name == 'black_money' then
                blackMoney = data.accounts[i].money
              end
            end

            table.insert(elements, {
              label          = '[' .. _U('black_money') .. '] $' .. blackMoney,
              value          = 'black_money',
              type           = 'item_account',
              amount         = blackMoney,
            })

            table.insert(elements, {label = '--- ' .. _U('inventory') .. ' ---', value = nil})

            for i=1, #data.inventory, 1 do
              if data.inventory[i].count > 0 then
                table.insert(elements, {
                  label          = data.inventory[i].label .. ' x' .. data.inventory[i].count,
                  value          = data.inventory[i].name,
                  type           = 'item_standard',
                  amount         = data.inventory[i].count,
                })
              end
            end

            table.insert(elements, {label = '=== ' .. _U('gun_label') .. ' ===', value = nil})

            for i=1, #data.weapons, 1 do
                table.insert(elements, {
                    label    = ESX.GetWeaponLabel(data.weapons[i].name) .. ' x' .. data.weapons[i].ammo,
                    value    = data.weapons[i].name,
                    type     = 'item_weapon',
                    amount   = data.weapons[i].ammo
                })
            end
        

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'steal_inventory',
        {
            title  = _U('target_inventory'),
            elements = elements,
            align = 'bottom-right'
        },
        function(data, menu)

            if data.current.value ~= nil then

                local itemType = data.current.type
                local itemName = data.current.value
                local amount   = data.current.amount
                local elements = {}
                table.insert(elements, {label = _U('steal'), action = "steal", itemType, itemName, amount})
                table.insert(elements, {label = _U('return'), action = "return"})
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'steal_inventory_item',
                    {
                        title = _U('action_choice'),
                        align = "bottom-right",
                        elements = elements
                    },
                    function(data2, menu2)

                        if data2.current.action == 'steal' then

                            if itemType == 'item_standard' then
                                ESX.UI.Menu.Open(
                                    'dialog', GetCurrentResourceName(), 'steal_inventory_item_standard',
                                    {
                                      title = _U('amount')
                                    },
                                    function(data3, menu3)
                                        local quantity = tonumber(data3.value)
                                        TriggerServerEvent('if_dead:stealPlayerItem', GetPlayerServerId(target), itemType, itemName, quantity)
                                        OpenBodySearchMenu(target)
                                    
                                        menu3.close()
                                        menu2.close()
                                    end,
                                    function(data3, menu3)
                                      menu3.close()
                                    end
                                  )

                            else
                                TriggerServerEvent('if_dead:stealPlayerItem', GetPlayerServerId(target), itemType, itemName, amount)
                                OpenBodySearchMenu(target)
                            end

                        elseif data2.current.action == 'return' then

                            ESX.UI.Menu.CloseAll()
                            OpenBodySearchMenu(target)

                        end

                    end,
                    function(data2, menu2)
                        menu2.close()
                    end
                )

            end

        end,
        function(data, menu)
		StopAnimTask(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base", 1.0)
            menu.close()
        end
        )
        
    end, GetPlayerServerId(target))

end

function loadAnimDict(dict)
	  while (not HasAnimDictLoaded(dict)) do
		  RequestAnimDict(dict)
		  Citizen.Wait(1)
	  end
end