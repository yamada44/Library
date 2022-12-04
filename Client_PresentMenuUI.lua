require('Utilities');

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game)
	
	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.17")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end


	Game = game;
	SubmitBtn = nil;

	setMaxSize(450, 400);

	vert = UI.CreateVerticalLayoutGroup(rootParent);

	if (game.Us == nil) then
		UI.CreateLabel(vert).SetText("You cannot gift armies since you're not in the game");
		return;
	end

	local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText("Gift armies to this player: ");
	TargetPlayerBtn = UI.CreateButton(row1).SetText("Select player...").SetOnClick(TargetPlayerClicked);


	local row2 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row2).SetText("Gift armies from this territory: ");
	TargetTerritoryBtn = UI.CreateButton(row2).SetText("Select source territory...").SetOnClick(TargetTerritoryClicked);
	TargetTerritoryInstructionLabel = UI.CreateLabel(vert).SetText("").SetPreferredHeight(70); --give it a fixed height just so things don't jump around as we change its text

end


function TargetPlayerClicked()
	local playingplayers = filter(Game.Game.Players, function (p) return p.ID ~= Game.Us.ID end);
	local options = map(playingplayers, "kol", PlayerButton);
	UI.PromptFromList("Select the player you'd like to give armies to", options);
end
function PlayerButton(player)
	local name = player.DisplayName(nil, false);
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		TargetPlayerBtn.SetText(name);
		TargetPlayerID = player.ID;

		CheckCreateFinalStep();
	end
	return ret;
end

function TargetTerritoryClicked()
	UI.InterceptNextTerritoryClick(TerritoryClicked);
	TargetTerritoryInstructionLabel.SetText("Please click on the territory you wish to gift armies from.  If needed, you can move this dialog out of the way.");
	TargetTerritoryBtn.SetInteractable(false);
end

function TerritoryClicked(terrDetails)
	TargetTerritoryBtn.SetInteractable(true);

	if (terrDetails == nil) then
		--The click request was cancelled. 
		TargetTerritoryInstructionLabel.SetText("");
	else
		--Territory was clicked, remember it
		TargetTerritoryInstructionLabel.SetText("Selected territory: " .. terrDetails.Name);
		SelectedTerritory = terrDetails;
		CheckCreateFinalStep();
	end

	return ret;
end

function CheckCreateFinalStep()

	if (SelectedTerritory == nil or TargetPlayerID == nil) then return; end;

	if (SubmitBtn == nil) then

		local row3 = UI.CreateHorizontalLayoutGroup(vert);
		UI.CreateLabel(row3).SetText("How many armies would you like to gift: ");
		NumArmiesInput = UI.CreateNumberInputField(row3).SetSliderMinValue(1);

		SubmitBtn = UI.CreateButton(vert).SetText("Gift").SetOnClick(SubmitClicked);
	end

	local maxArmies = Game.LatestStanding.Territories[SelectedTerritory.ID].NumArmies.NumArmies;
	NumArmiesInput.SetSliderMaxValue(maxArmies).SetValue(maxArmies);
end

function SubmitClicked()
	if (SelectedTerritory == nil or TargetPlayerID == nil) then return; end;

	local msg = '(Local info) Gifting ' .. NumArmiesInput.GetValue() .. ' armies from ' .. SelectedTerritory.Name .. ' to ' .. Game.Game.Players[TargetPlayerID].DisplayName(nil, false);

	local payload = 'GiftArmies2_' .. NumArmiesInput.GetValue() .. ',' .. SelectedTerritory.ID .. ',' .. TargetPlayerID;

	local orders = Game.Orders;
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload));
	Game.Orders = orders;
end
