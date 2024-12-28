local function SpawnPikminMenu(ply, cmd, args)
	local w, h = surface.ScreenWidth(), surface.ScreenHeight();
	local frame = vgui.Create("DFrame");
	frame:SetSize((w * .475), (h * .275));
	
	local W = frame:GetWide();
	local H = frame:GetTall();
	
	frame:SetPos(((w * .5) - (W * .5)), (h * .125));
	frame:SetVisible(true);
	frame:MakePopup();
	frame:SetTitle("Pikmin Color Chooser");
	
	--[[function frame:Paint()
		surface.SetDrawColor(0,0,0,255);
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
		surface.SetDrawColor(111,111,111,255);
		surface.DrawRect(2, 26, self:GetWide()-4, self:GetTall()-29);
		surface.SetDrawColor(83,83,83,255);
		surface.DrawRect(2, 2, self:GetWide()-4, 22);
		draw.SimpleText("Pikmin Color Chooser", "ConsoleText", 12, 12, Color(130,130,130,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		return true;
	end--]]
	
	local piktbl = {
		"red",
		"yellow",
		"blue"
	}
	
	local inc = 0;
	
	for i=1,#piktbl do
		local btn = vgui.Create("DImageButton", frame);
		btn:SetPos(W * .05 + inc, H * .175);
		btn:SetWide(W * .275);
		btn:SetTall(H * .575);
		function btn:Paint()
			surface.SetDrawColor(0,0,0,255);
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
			surface.SetDrawColor(255,255,255,255);
			surface.SetTexture(surface.GetTextureID("pikmin/" .. piktbl[i]));
			surface.DrawTexturedRect(1, 1, self:GetWide()-2, self:GetTall()-2);
			return true;
		end
		local bpx,bpy = btn:GetPos()
		local bw,bh = btn:GetWide(),btn:GetTall();
		function btn:DoClick()
			RunConsoleCommand("pikmin_create", piktbl[i]);
			btn:SetPos(bpx+2,bpy+2);
			btn:SetWide(bw-4);
			btn:SetTall(bh-4);
			timer.Simple(0.1,function() btn:SetWide(bw); btn:SetTall(bh); btn:SetPos(bpx,bpy); end)
		end
		inc = (inc + (28 + (w * .125)));
	end
	
	local rand = vgui.Create("DButton", frame);
	rand:SetPos((W * .1), (H * .8));
	rand:SetWide((W * .8));
	rand:SetTall((H * .1));
	rand:SetText("Random!");
	rand.DoClick = function()
		RunConsoleCommand("pikmin_create", "random");
	end
					
	frame:SizeToContents();
end
concommand.Add("pikmin_menu", SpawnPikminMenu);
