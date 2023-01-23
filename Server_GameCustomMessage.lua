require('Utilities');
require("Utilities2");
require("WLUtilities");

function Server_GameCustomMessage(game, playerID, payload, setReturnTable)


local targetTerritoryID = payload.targetTerritoryID;
local armiesOnTerritory = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID].NumArmies.NumArmies;
local ArmySending = payload.Armies; --converting armies to gold


	--Skip if we don't control the territory (this can happen if someone captures the territory before our gift order executes)
	if (playerID ~= game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID].OwnerPlayerID) then
		setReturnTable({ Message = 'You dont control the territory' });
		return;
	end

-- if selected armies are higher then armies on territory then set selected armies to amount on map
	if (ArmySending < 0) then ArmySending = 0 end;
	if (ArmySending > armiesOnTerritory) then ArmySending = armiesOnTerritory end;

	--remove armies from the source territory
	--local removeFromSource = WL.TerritoryModification.Create(targetTerritoryID);
	--removeFromSource.SetArmiesTo = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID].NumArmies.NumArmies - ArmySending;


	local goldHave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold);


	local targetPlayer = game.Game.Players[payload.TargetPlayerID];
	local targetPlayerHasGold = game.ServerGame.LatestTurnStanding.NumResources(targetPlayer.ID, WL.ResourceType.Gold);
	
	-- add goldSending to target

	game.ServerGame.SetPlayerResource(targetPlayer.ID, WL.ResourceType.Gold, targetPlayerHasGold + ArmySending);

	setReturnTable({ Message = "Sent " .. targetPlayer.DisplayName(nil, false) .. ' ' .. ArmySending .. ' gold. You now have ' .. (goldHave - ArmySending) .. '.'  });
 --]]
end



--[[  do not use anymore

--[[	if (goldHave < goldSending) then
		setReturnTable({ Message = "You can't gift " .. goldSending .. " when you only have " .. goldHave });
		return;
	end 
	--]]

	--game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldHave - goldSending);

--]]
