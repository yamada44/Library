require('Utilities');

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'GiftArmies2_')) then  --look for the order that we inserted in Client_PresentMenuUI

		--in Client_PresentMenuUI, we comma-delimited the number of armies, the target territory ID, and the target player ID.  Break it out here
		local payloadSplit = split(string.sub(order.Payload, 13), ','); 
		local numArmies = tonumber(payloadSplit[1])
		local targetTerritoryID = tonumber(payloadSplit[2]);
		local targetPlayerID = tonumber(payloadSplit[3]);

		--Skip if we don't control the territory (this can happen if someone captures the territory before our gift order executes)
		if (order.PlayerID ~= game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID].OwnerPlayerID) then
			skipThisOrder(WL.ModOrderControl.Skip);
			return;
		end

		local armiesOnTerritory = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID].NumArmies.NumArmies;

		if (numArmies < 0) then numArmies = 0 end;
		if (numArmies > armiesOnTerritory) then numArmies = armiesOnTerritory end;

		--[[if (targetPlayerID == order.PlayerID) then  --can't gift yourself
			skipThisOrder(WL.ModOrderControl.Skip);
			return;
		end --]]

		--might get rid of
		--remove armies from the source territory
		local removeFromSource = WL.TerritoryModification.Create(targetTerritoryID);
		removeFromSource.SetArmiesTo = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID].NumArmies.NumArmies - numArmies;

		--Add armies to destination player

		local incomeMod = WL.IncomeMod.Create(targetPlayerID, numArmies, '(public info) An unknown amount of Armies was gifted from ' .. game.Game.Players[order.PlayerID].DisplayName(nil, false) .. ' to ' .. game.Game.Players[targetPlayerID].DisplayName(nil, false));
		

		
-- create 
		
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, order.Message ,  {targetPlayerID}, nil, nil, {})); 
		-- creates message for players with visibility and handles all modifications for territory
		
		
		-- --addneworder(game.ServerGame.SetPlayerResource(targetPlayerID, WL.ResourceType.Gold, 0);

		
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, incomeMod.Message , nil, {removeFromSource}, nil, {incomeMod}));
		-- creates a message for everyone else who can't see the territory. handles no modifications 
		-- this will create two messages for players who have visibility
		
	
		
		skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage); 
		--we replaced the GameOrderCustom with a GameOrderEvent, so get rid of the custom order.  
		--There wouldn't be any harm in leaving it there, but it adds clutter to the orders 
		--list so it's better to get rid of it.

	
	end

end
