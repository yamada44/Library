
function Client_PresentSettingsUI(rootParent)

	if Mod.Settings.GoldTax > 0 then
		UI.CreateLabel(rootParent).SetText('Tax Mode: Tax multiplier').SetColor('#4169E1')

	UI.CreateLabel(rootParent).SetText('Players gifted gold are Taxed 1 peice of gold every time they exceed this number ( ' .. Mod.Settings.GoldTax .. ' ) ');
	elseif Mod.Settings.Percent > 0 then
		UI.CreateLabel(rootParent).SetText('Tax Mode: Percent').SetColor('#4169E1')
		UI.CreateLabel(rootParent).SetText('Players gifted gold are Taxed ' .. Mod.Settings.Percent .. '% for every transfer');
	else
		UI.CreateLabel(rootParent).SetText('Tax Mode: None').SetColor('#4169E1')
		UI.CreateLabel(rootParent).SetText('Gifts are free to be handed out without Tax');

	end

end