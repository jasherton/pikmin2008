AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include('shared.lua');

ENT.Anim = "idle2";

function ENT:Initialize()
	self:SetModel("models/pikmin/onion.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	end
	
	if (self.Anim == "land") then
		self:SetNoDraw(true);
		timer.Simple(0.5, function()
			self:SetNoDraw(false);
		end);
		timer.Simple(4.5, function()
			self.Anim = "idle2";
		end);
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	
	local skins = {0,1,2}
	for k,v in ipairs(ents.FindByClass("pikmin_onion")) do
		local skin = v:GetSkin()
		if (table.HasValue(skins,skin)) then
			for i,n in ipairs(skins) do
				if n == skin then
					table.remove(skins,i);
					break;
				end
			end
		end
	end
	
	if (#skins == 0) then
		return;
	end
	
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 16));
	local ent = ents.Create("pikmin_onion");
	ent:SetPos(SpawnPos);
	ent:SetSkin(skins[math.random(1,#skins)]);
	
	local trace = util.QuickTrace(ent:GetPos(),Vector(0,0,100000),ents.GetAll());
	if trace.HitSky then
		ent.Anim = "land";
	end
	
	ent:Spawn();
	ent:Activate();
	undo.Create("Onion");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:Think()
	local anim = self.Anim;
	self:ResetSequence(self:LookupSequence(anim));
	self:NextThink(CurTime());
	return true;
end