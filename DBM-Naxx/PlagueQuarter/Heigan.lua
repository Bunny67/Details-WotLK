local mod	= DBM:NewMod("Heigan", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15936)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents()

local warnTeleportSoon	= mod:NewAnnounce("WarningTeleportSoon", 2, 46573)
local warnTeleportNow	= mod:NewAnnounce("WarningTeleportNow", 3, 46573)

local timerTeleport		= mod:NewTimer(90, "TimerTeleport", 46573)

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	DBM:FireCustomEvent("DBM_EncounterStart", 15936, "Heigan the Unclean")
	mod:BackInRoom(90 - delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 15936, "Heigan the Unclean", wipe)
end

function mod:DancePhase()
	self.vb.phase = self.vb.phase + 1
	timerTeleport:Show(47)
	warnTeleportSoon:Schedule(37, 10)
	warnTeleportNow:Schedule(47)
	self:ScheduleMethod(47, "BackInRoom", 88)
end

function mod:BackInRoom(time)
	self.vb.phase = self.vb.phase + 1
	timerTeleport:Show(time)
	warnTeleportSoon:Schedule(time - 15, 15)
	warnTeleportNow:Schedule(time)
	self:ScheduleMethod(time, "DancePhase")
end
