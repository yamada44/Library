
function Client_PresentSettingsUI(rootParent)

	local percent = Mod.Settings.Percent -- for games that are already running
	if percent == nil then percent = 0 end

	if Mod.Settings.GoldTax > 0 then
		UI.CreateLabel(rootParent).SetText('Tax Mode: Tax multiplier').SetColor('#00F4FF')

	UI.CreateLabel(rootParent).SetText('Players gifted gold are Taxed 1 peice of gold every time they exceed this number ( ' .. Mod.Settings.GoldTax .. ' ) ');
	elseif percent > 0 then
		UI.CreateLabel(rootParent).SetText('Tax Mode: Percent').SetColor('#00F4FF')
		UI.CreateLabel(rootParent).SetText('Players gifted gold are Taxed ' .. percent .. '% for every transfer');
	else
		UI.CreateLabel(rootParent).SetText('Tax Mode: None').SetColor('#00F4FF')
		UI.CreateLabel(rootParent).SetText('Gifts are free to be handed out without Tax');

	end

end