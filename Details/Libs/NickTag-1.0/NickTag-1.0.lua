--> Library NickTag is a small library for share individual nicknames and avatars.

--> Basic Functions:
-- NickTag:SetNickname(name) -> set the player nick name, after set nicktag will broadcast the nick over addon guild channel.
--

local major, minor = "NickTag-1.0", 11
local NickTag, oldminor = LibStub:NewLibrary(major, minor)

if not NickTag then
	return
end

--> fix for old nicktag version
if _G.NickTag then
	if _G.NickTag.OnEvent then
		_G.NickTag:UnregisterComm("NickTag")
		_G.NickTag.OnEvent = nil
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

local CONST_INDEX_NICKNAME = 1
local CONST_INDEX_AVATAR_PATH = 2
local CONST_INDEX_AVATAR_TEXCOORD = 3
local CONST_INDEX_BACKGROUND_PATH = 4
local CONST_INDEX_BACKGROUND_TEXCOORD = 5
local CONST_INDEX_BACKGROUND_COLOR = 6
local CONST_INDEX_REVISION = 7

local CONST_COMM_FULLPERSONA = 1

NICKTAG_DEFAULT_AVATAR =[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-Default]]
NICKTAG_DEFAULT_BACKGROUND =[[Interface\AddOns\Details\textures\PetBattles\Weather-ArcaneStorm]]
NICKTAG_DEFAULT_BACKGROUND_CORDS = {0.129609375, 1, 1, 0}

------------------------------------------------------------------------------------------------------------------------------------------------------
--> library stuff

_G.NickTag = NickTag --> nicktag object over global container

local pool = {default = true} --> pointer to the cache pool and the default pool if no cache
local siblingsPools = {} --> pools registered by other addons
--when this instance was the first to load
local isMaster = false

NickTag.debug = false

LibStub:GetLibrary("AceComm-3.0"):Embed(NickTag)
LibStub:GetLibrary("AceSerializer-3.0"):Embed(NickTag)
LibStub:GetLibrary("AceTimer-3.0"):Embed(NickTag)
local CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0")
NickTag.callbacks = NickTag.callbacks or CallbackHandler:New(NickTag)

NickTag.embeds = NickTag.embeds or {}

local embed_functions = {
	"SetNickname",
	"SetNicknameAvatar",
	"SetNicknameBackground",
	"GetNickname",
	"GetNicknameAvatar",
	"GetNicknameBackground",
	"GetNicknameTable",
	"NickTagSetCache",
	"ResetPlayerPersona"
}

function NickTag:Embed(target)
	for k, v in pairs(embed_functions) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function NickTag:Msg(...)
	if NickTag.debug then
		print("|cFFFFFF00NickTag:|r", ...)
	end
end

local enUS = LibStub("AceLocale-3.0"):NewLocale("NickTag-1.0", "enUS", true)
if enUS then
	enUS["STRING_ERROR_1"] = "Your nickname is too long, max of 12 characters is allowed."
	enUS["STRING_ERROR_2"] = "Only letters and two spaces are allowed."
	enUS["STRING_ERROR_3"] = "You can't use the same letter three times consecutively, two spaces consecutively or more then two spaces."
	enUS["STRING_ERROR_4"] = "Name isn't a valid string."
	enUS["STRING_INVALID_NAME"] = "Invalid Name"
end

local ptBR = LibStub("AceLocale-3.0"):NewLocale("NickTag-1.0", "ptBR")
if ptBR then
	ptBR["STRING_ERROR_1"] = "Seu apelido esta muito longo, o maximo permitido sao 12 caracteres."
	ptBR["STRING_ERROR_2"] = "Apenas letras, numeros e espacos sao permitidos no apelido."
	ptBR["STRING_ERROR_3"] = "Voce nao pode usar a mesma letra mais de 2 vezes consecutivas, dois espacos consecutivos ou mais de 2 espacos."
	ptBR["STRING_ERROR_4"] = "Nome nao eh uma string valida."
	ptBR["STRING_INVALID_NAME"] = "Nome Invalido"
end

NickTag.background_pool = {
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-ArcaneStorm]], "Arcane Storm", {0.129609375, 1, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Blizzard]], "Blizzard", {0.068704154, 1, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-BurntEarth]], "Burnt Earth", {0.087890625, 0.916015625, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Darkness]], "Darkness", {0.080078125, 0.931640625, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Moonlight]], "Moonlight", {0.02765625, 0.94359375, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Moonlight]], "Moonlight(reverse)", {0.94359375, 0.02765625, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Mud]], "Mud", {0.068359375, 0.94359375, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Rain]], "Rain", {0.078125, 0.970703125, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Sandstorm]], "Sand Storm", {0.048828125, 0.947265625, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-StaticField]], "Static Field", {0.1171875, 0.953125, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Sunlight]], "Sun Light", {0.1772721, 0.953125, 1, 0}},
	{[[Interface\AddOns\Details\textures\PetBattles\Weather-Windy]], "Windy", {0.9453125, 0.07421875, 0.8203125, 0}}
}

NickTag.avatar_pool = {
	{[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-Lord Marrowgar]], "Lord Marrowgar"},
	{[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-Lady Deathwhisper]], "Lady Deathwhisper"},
	{[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-Gunship Horde]], "Gunship Horde"},
	{[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-Gunship Alliance]], "Gunship Alliance"},
	{[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-Deathbringer Saurfang]], "Deathbringer Saurfang"},
	{[[Interface\AddOns\Details\textures\EncounterJournal\UI-EJ-BOSS-The Lich King]], "The Lich King"},
}
------------------------------------------------------------------------------------------------------------------------------------------------------
--> send and receive functions

function NickTag:OnReceiveComm(prefix, data, channel, source)
	if not source then
		return
	end

	local _type, serial, arg3, name, realm, version =  select(2, NickTag:Deserialize(data))

	--> 0x1: received a full persona
	if _type == CONST_COMM_FULLPERSONA then
		local receivedPersona = arg3
		version = name

		if(not receivedPersona or type(receivedPersona) ~= "table") then
			NickTag:Msg("FULLPERSONA received but it's invalid ", source)
			return
		end

		if(source ~= UnitName("player") and(version and version == minor) and receivedPersona) then

			local storedPersona = NickTag:GetNicknameTable(source)
			if(not storedPersona) then
				storedPersona = NickTag:Create(source)
			end

			storedPersona[CONST_INDEX_REVISION] = receivedPersona[CONST_INDEX_REVISION]

			--> we need to check if the received nickname fit in our rules.
			local allowNickName = NickTag:CheckName(receivedPersona[CONST_INDEX_NICKNAME])
			if(allowNickName) then
				storedPersona[CONST_INDEX_NICKNAME] = receivedPersona[CONST_INDEX_NICKNAME]
			else
				storedPersona[CONST_INDEX_NICKNAME] = LibStub("AceLocale-3.0"):GetLocale("NickTag-1.0")["STRING_INVALID_NAME"]
			end

			storedPersona[CONST_INDEX_NICKNAME] = receivedPersona[CONST_INDEX_NICKNAME]

			--> update the rest
			--avatar path
			storedPersona[CONST_INDEX_AVATAR_PATH] = type(receivedPersona[CONST_INDEX_AVATAR_PATH]) == "string" and receivedPersona[CONST_INDEX_AVATAR_PATH] or ""

			--avatar texcoord
			if(type(receivedPersona[CONST_INDEX_AVATAR_TEXCOORD]) == "boolean") then
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD] = {0, 1, 0, 1}

			elseif(type(receivedPersona[CONST_INDEX_AVATAR_TEXCOORD]) == "table") then
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD] = storedPersona[CONST_INDEX_AVATAR_TEXCOORD] or {}
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD][1] = type(receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][1]) == "number" and receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][1] or 0
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD][2] = type(receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][2]) == "number" and receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][2] or 1
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD][3] = type(receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][3]) == "number" and receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][3] or 0
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD][4] = type(receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][4]) == "number" and receivedPersona[CONST_INDEX_AVATAR_TEXCOORD][4] or 1
			else
				storedPersona[CONST_INDEX_AVATAR_TEXCOORD] = {0, 1, 0, 1}
			end

			--background texcoord
			if(type(receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD]) == "boolean") then
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD] = {0, 1, 0, 1}

			elseif(type(receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD]) == "table") then
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD] = storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD] or {}
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][1] = type(receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][1]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][1] or 0
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][2] = type(receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][2]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][2] or 1
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][3] = type(receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][3]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][3] or 0
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][4] = type(receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][4]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_TEXCOORD][4] or 1
			else
				storedPersona[CONST_INDEX_BACKGROUND_TEXCOORD] = {0, 1, 0, 1}
			end

			--background path
			storedPersona[CONST_INDEX_BACKGROUND_PATH] = type(receivedPersona[CONST_INDEX_BACKGROUND_PATH]) == "string" and receivedPersona[CONST_INDEX_BACKGROUND_PATH] or ""

			--background color
			if(type(receivedPersona[CONST_INDEX_BACKGROUND_COLOR]) == "table") then
				storedPersona[CONST_INDEX_BACKGROUND_COLOR] = storedPersona[CONST_INDEX_BACKGROUND_COLOR] or {}
				storedPersona[CONST_INDEX_BACKGROUND_COLOR][1] = type(receivedPersona[CONST_INDEX_BACKGROUND_COLOR][1]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_COLOR][1] or 1
				storedPersona[CONST_INDEX_BACKGROUND_COLOR][2] = type(receivedPersona[CONST_INDEX_BACKGROUND_COLOR][2]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_COLOR][2] or 1
				storedPersona[CONST_INDEX_BACKGROUND_COLOR][3] = type(receivedPersona[CONST_INDEX_BACKGROUND_COLOR][3]) == "number" and receivedPersona[CONST_INDEX_BACKGROUND_COLOR][3] or 1
			else
				storedPersona[CONST_INDEX_BACKGROUND_COLOR] = {1, 1, 1}
			end

			NickTag:SyncSiblings()
			NickTag:Msg("FULLPERSONA received and updated for character: ", source, "new nickname: ", receivedPersona[CONST_INDEX_NICKNAME])
		end

	end

end

NickTag:RegisterComm("NickTag", "OnReceiveComm")

--frame for listening to event
NickTag.EventFrame = NickTag.EventFrame or CreateFrame("Frame")
NickTag.EventFrame.InfoSendCooldown = 0

function NickTag.OnEvent(self, event, ...)
	if(NickTag.EventFrame.InfoSendCooldown > time()) then
		if(not NickTag.EventFrame.ScheduledSend or NickTag.EventFrame.ScheduledSend._cancelled) then
			NickTag.EventFrame.ScheduledSend = C_Timer.NewTicker(30, NickTag.SendPersona, 1)
		end
	else
		NickTag:SendPersona()
	end
end

--when the roster changes or the player enters the game, send the persona to guild mates
--send on roster update can only happen every 30 seconds, if is on cooldown, it'll schedule an update
NickTag.EventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
NickTag.EventFrame:RegisterEvent("RAID_ROSTER_UPDATE")
NickTag.EventFrame:RegisterEvent("PLAYER_LOGIN")

NickTag.EventFrame:SetScript("OnEvent", NickTag.OnEvent)

--send the persona in the guild comm chanel
function NickTag:SendPersona()
	--check if the player has a persona
	local nickTable = NickTag:GetNicknameTable(UnitName("player"), true)
	if not nickTable then
		return
	end

	NickTag:Msg("SendPersona() -> broadcast")

	if NickTag.EventFrame.ScheduledSend and not NickTag.EventFrame.ScheduledSend._cancelled then
		NickTag.EventFrame.ScheduledSend:Cancel()
	end

	NickTag.EventFrame.ScheduledSend = nil
	NickTag.EventFrame.InfoSendCooldown = time() + 29

	--> updating my own persona
	NickTag.send_scheduled = false

	--> auto change nickname if we have an invalid nickname
	if NickTag:GetNickname(UnitName("player")) == LibStub("AceLocale-3.0"):GetLocale("NickTag-1.0")["STRING_INVALID_NAME"] then
		nickTable[CONST_INDEX_NICKNAME] = UnitName("player")
	end

	--> broadcast over guild channel
	if IsInGuild() then
		if isMaster then
			NickTag:SyncSiblings()
		end

		NickTag:SendCommMessage("NickTag", NickTag:Serialize(CONST_COMM_FULLPERSONA, 0, NickTag:GetNicknameTable(UnitName("player")), minor), "GUILD")
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--> cache stuff

--> this will clear the information about the player within nicktag cache
function NickTag:ResetPlayerPersona()
	local playerName = UnitName("player")

	if playerName then
		local playerPersona = NickTag:GetNicknameTable(playerName)
		if playerPersona then
			playerPersona[CONST_INDEX_NICKNAME] = playerName
			playerPersona[CONST_INDEX_AVATAR_PATH] = false
			playerPersona[CONST_INDEX_AVATAR_TEXCOORD] = false
			playerPersona[CONST_INDEX_BACKGROUND_PATH] = false
			playerPersona[CONST_INDEX_BACKGROUND_TEXCOORD] = false
			playerPersona[CONST_INDEX_BACKGROUND_COLOR] = false
			playerPersona[CONST_INDEX_REVISION] = playerPersona[CONST_INDEX_REVISION] + 1

			C_Timer.After(1, NickTag.SendPersona)
		end
	end
end

--> reset cache
function NickTag:ResetCache()
	local playerName = UnitName("player")
	if playerName then
		local player = NickTag:GetNicknameTable(playerName)
		if player and pool.last_version == minor then
			for thisPlayerName, _ in pairs(pool) do
				if thisPlayerName ~= playerName then
					pool[thisPlayerName] = nil
				end
			end
			--vardump(pool)
		else
			table.wipe(pool)
		end

		pool.nextreset = time() +(60*60*24*15) --> 15 days or 1296000 seconds
		pool.last_version = minor
	else
		--> sometimes player guid isn't available right after logon, so, just schedule until it become available.
		NickTag:ScheduleTimer("ResetCache", 0.3)
	end
end

--register a table where data can be saved
function NickTag:NickTagSetCache(_table)
	if not pool.default then
		--already have a place to save
		--save the new table as sibling
		--so all addons using nicktag can have the data synchronized
		siblingsPools[#siblingsPools + 1] = _table

		--copy all players into the sibling table
		for key, value in pairs(pool) do
			_table[key] = value
		end

		return
	end

	pool = _table
	isMaster = true --> this instance of nicktag will save data

	if not pool.nextreset then
		pool.nextreset = time() +(60*60*24*15)
	end

	if not pool.last_version then
		pool.last_version = minor
	end

	if pool.last_version < minor then
		pool.nextreset = 1
	end

	if time() > pool.nextreset then
		NickTag:ResetCache()
	end
end

function NickTag:SyncSiblings()
	--copy all data into siblings table
	for _, syblingTable in ipairs(siblingsPools) do
		for key, value in pairs(pool) do
			syblingTable[key] = value
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--> basic functions

--> trim from from http://lua-users.org/wiki/StringTrim
function trim(s)
	local from = s:match"^%s*()"
	return from > #s and "" or s:match(".*%S", from)
end
--
local titlecase = function(first, rest)
	return first:upper()..rest:lower()
end
--
local have_repeated = false
local count_spaces = 0
local check_repeated = function(char)
	if char == "  " then
		have_repeated = true
	elseif string.len(char) > 2 then
		have_repeated = true
	elseif char == " " then
		count_spaces = count_spaces + 1
	end
end


--> we need to keep game smooth checking and formating nicknames.
--> SetNickname and names comming from other player need to be check.
function NickTag:CheckName(name)
	--> as nicktag only work internally in the guild, we think that is not necessary a work filter to avoid people using bad language.
	if(type(name) ~= "string") then
		return false, LibStub("AceLocale-3.0"):GetLocale("NickTag-1.0")["STRING_ERROR_4"] --> error 4 = name isn't a valid string
	end

	name = trim(name)

	--> limit nickname to 12 characters, same as wow.
	local len = string.len(name)
	if len > 12 then
		return false, LibStub("AceLocale-3.0"):GetLocale("NickTag-1.0")["STRING_ERROR_1"] --> error 1 = nickname is too long, max of 12 characters.
	end

	--> check if contain any non allowed characters, by now only accpet letters, numbers and spaces.
	--> by default wow do not accetp spaces, but here will allow.
	--> tested over lua 5.2 and this capture was okey with accents, not sure why inside wow this doesn't work.
	local notallow = string.find(name, "[^a-zA-Z�������%s]")
	if notallow then
		return false, LibStub("AceLocale-3.0"):GetLocale("NickTag-1.0")["STRING_ERROR_2"] --> error 2 = nickname only support letters, numbers and spaces.
	end

	--> check if there is sequencial repeated characters, like "Jasooon" were repeats 3 times the "o" character.
	--> got this from http://stackoverflow.com/questions/15608299/lua-pattern-matching-repeating-character
	have_repeated = false
	count_spaces = 0
	string.gsub(name, '.', '\0%0%0'):gsub('(.)%z%1','%1'):gsub('%z.([^%z]+)', check_repeated)
	if count_spaces > 2 then
		have_repeated = true
	end
	if have_repeated then
		return false, LibStub("AceLocale-3.0"):GetLocale("NickTag-1.0")["STRING_ERROR_3"] --> error 3 = cant use the same letter three times consecutively, 2 spaces consecutively or 3 or more spaces.
	end

	return true
end

--> set the "player" nickname and schedule for send updated persona
function NickTag:SetNickname(name)
	--> check data before
	assert(type(name) == "string", "NickTag 'SetNickname' expects a string on #1 argument.")

	--> check if the nickname is okey to allowed to use.
	local okey, errortype = NickTag:CheckName(name)
	if not okey then
		NickTag:Msg("SetNickname() invalid name ", name)
		return false, errortype
	end

	--> here we format the text to match titles, e.g converts name like "JASON NICKSHOW" into "Jason Nickshow".
	name = name:gsub("(%a)([%w_']*)", titlecase)

	local playerName = UnitName("player")

	--> get the full nick table.
	local nickTable = NickTag:GetNicknameTable(playerName)
	if not nickTable then
		nickTable = NickTag:Create(playerName, true)
	end

	--> change the nickname for the player nick table.
	if nickTable[CONST_INDEX_NICKNAME] ~= name then
		nickTable[CONST_INDEX_NICKNAME] = name

		--increase the table revision
		NickTag:IncRevision()

		--> send the update for script which need it.
		NickTag.callbacks:Fire("NickTag_Update", CONST_INDEX_NICKNAME)

		--> schedule a update for revision and broadcast full persona.
		--> this is a kind of protection for scripts which call SetNickname, SetColor and SetAvatar one after other, so scheduling here avoid three revisions upgrades and 3 broadcasts to the guild.
		if not NickTag.send_scheduled then
			NickTag.send_scheduled = true
			NickTag:ScheduleTimer("SendPersona", 1)
		end
	else
		NickTag:Msg("SetNickname() name is the same on the pool ", name, nickTable[CONST_INDEX_NICKNAME])
	end

	return true
end

function NickTag:SetNicknameAvatar(texture, l, r, t, b)
	if not l then
		l, r, t, b = 0, 1, 0, 1
	elseif type(l) == "table" then
		l, r, t, b = unpack(l)
	end

	--> check data before
	assert(texture and l and r and t and b, "NickTag 'SetNicknameAvatar' bad format. Usage NickTag:SetAvatar(texturepath[, L, R, T, B] or texturepath[, {L, R, T, B}])")

	local playerName = UnitName("player")

	local nickTable = NickTag:GetNicknameTable(playerName)
	if not nickTable then
		nickTable = NickTag:Create(playerName, true)
	end

	if nickTable[CONST_INDEX_AVATAR_PATH] ~= texture then
		nickTable[CONST_INDEX_AVATAR_PATH] = texture

		--increase the table revision
		NickTag:IncRevision()

		--> by default, CONST_INDEX_AVATAR_TEXCOORD comes as boolean false
		if type(nickTable[CONST_INDEX_AVATAR_TEXCOORD]) == "boolean" then
			nickTable[CONST_INDEX_AVATAR_TEXCOORD] = {}
		end

		nickTable[CONST_INDEX_AVATAR_TEXCOORD][1] = l
		nickTable[CONST_INDEX_AVATAR_TEXCOORD][2] = r
		nickTable[CONST_INDEX_AVATAR_TEXCOORD][3] = t
		nickTable[CONST_INDEX_AVATAR_TEXCOORD][4] = b

		NickTag.callbacks:Fire("NickTag_Update", CONST_INDEX_AVATAR_PATH)

		if not NickTag.send_scheduled then
			NickTag.send_scheduled = true
			NickTag:ScheduleTimer("SendPersona", 1)
		end
	end

	return true
end

--> set the background
function NickTag:SetNicknameBackground(path, texcoord, color, silent)
	if not silent then
		assert(type(path) == "string", "NickTag 'SetNicknameBackground' expects a string on #1 argument.")
	else
		if type(path) ~= "string" then
			return
		end
	end

	if not texcoord then
		texcoord = {0, 1, 0, 1}
	end

	if not color then
		color = {1, 1, 1}
	end

	local playerName = UnitName("player")

	local nickTable = NickTag:GetNicknameTable(playerName)
	if not nickTable then
		nickTable = NickTag:Create(playerName, true)
	end

	local need_sync = false
	if nickTable[CONST_INDEX_BACKGROUND_PATH] ~= path then
		nickTable[CONST_INDEX_BACKGROUND_PATH] = path
		need_sync = true
	end

	if nickTable[CONST_INDEX_BACKGROUND_TEXCOORD] ~= texcoord then
		nickTable[CONST_INDEX_BACKGROUND_TEXCOORD] = texcoord
		need_sync = true
	end

	if nickTable[CONST_INDEX_BACKGROUND_COLOR] ~= color then
		nickTable[CONST_INDEX_BACKGROUND_COLOR] = color
		need_sync = true
	end

	if need_sync then
		--increase the table revision
		NickTag:IncRevision()

		NickTag.callbacks:Fire("NickTag_Update", CONST_INDEX_BACKGROUND_PATH)

		if not NickTag.send_scheduled then
			NickTag.send_scheduled = true
			NickTag:ScheduleTimer("SendPersona", 1)
		end
	end

	return true
end

function NickTag:GetNickname(playerName, default, silent)
	if not silent then
		assert(type(playerName) == "string", "NickTag 'GetNickname' expects a string or string on #1 argument.")
	end

	local _table = pool[playerName]
	if not _table then
		return default or nil
	end

	return _table[CONST_INDEX_NICKNAME] or default or nil
end

--> return the avatar and the texcoord.
function NickTag:GetNicknameAvatar(playerName, default, silent)
	if not silent then
		assert(type(playerName) == "string", "NickTag 'GetNicknameAvatar' expects a string or string on #1 argument.")
	end

	local _table = pool[playerName]

	if not _table and default then
		return default, {0, 1, 0, 1}
	elseif not _table then
		return "", {0, 1, 0, 1}
	end
	return _table[CONST_INDEX_AVATAR_PATH] or default or "", _table[CONST_INDEX_AVATAR_TEXCOORD] or {0, 1, 0, 1}
end

function NickTag:GetNicknameBackground(playerName, default_path, default_texcoord, default_color, silent)
	if not silent then
		assert(type(playerName) == "string", "NickTag 'GetNicknameBackground' expects a string or string on #1 argument.")
	end

	local _table = pool[playerName]
	if not _table then
		return default_path, default_texcoord, default_color
	end

	return _table[CONST_INDEX_BACKGROUND_PATH] or default_path, _table[CONST_INDEX_BACKGROUND_TEXCOORD] or default_texcoord, _table[CONST_INDEX_BACKGROUND_COLOR] or default_color
end

--> get the full nicktag table
function NickTag:GetNicknameTable(playerName, silent)
	--> check data before
	if not silent then
		assert(type(playerName) == "string", "NickTag 'GetNicknameTable' expects a string on #1 argument.")
	else
		if not playerName or type(playerName) ~= "string" then
			return
		end
	end

	return pool[playerName]
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

--> create a empty nick table for the player
function NickTag:Create(playerName, isSelf)
	--> check data before
	assert(type(playerName) == "string", "NickTag 'Create' expects a string on #1 argument.")

	--> check if alredy exists
	local alredyHave = pool[playerName]
	if alredyHave then
		return alredyHave
	end

	--> create the table:
	local newTable = {
		UnitName("player"), --[1] player nickname
		false, --[2] avatar texture path
		false, --[3] avatar texture coord
		false, --[4] background texture path
		false, --[5] background texcoord
		false, --[6] background color
		1 --[7] revision
	}

	--> if not my persona, set revision to 0, this make always get update after creation
	if not isSelf then
		newTable[CONST_INDEX_REVISION] = 0
	end

	pool[playerName] = newTable
	return newTable
end

--> inc the revision of the player persona after update nick or avatar
function NickTag:IncRevision()
	local playerName = UnitName("player")
	local nickTable = NickTag:GetNicknameTable(playerName)
	if not nickTable then
		nickTable = NickTag:Create(playerName, true)
	end

	nickTable[CONST_INDEX_REVISION] = nickTable[CONST_INDEX_REVISION] + 1

	return true
end

--> convert GUID into serial number(deprecated, it uses player name - realm name)
function NickTag:GetSerial(serial, silent)
	return 0
end

	--> choose avatar window
do
	local avatar_pick_frame = CreateFrame("Frame", "AvatarPickFrame", UIParent)
	avatar_pick_frame:SetFrameStrata("DIALOG")
	avatar_pick_frame:SetBackdrop({
		bgFile =[[Interface\FrameGeneral\UI-Background-Marble]],
		edgeFile =[[Interface\DialogFrame\UI-DialogBox-Border]],
		tile = true, tileSize = 256, edgeSize = 32,
		insets = {left = 11, right = 12, top = 12, bottom = 11}
	})
	avatar_pick_frame:SetBackdropColor(.3, .3, .3, .9)
	avatar_pick_frame:SetWidth(460)
	avatar_pick_frame:SetHeight(240)

	avatar_pick_frame.selected_avatar = 1
	avatar_pick_frame.selected_background = 1
	avatar_pick_frame.selected_color = {1, 1, 1}
	avatar_pick_frame.selected_texcoord = {0, 1, 0, 1}

	avatar_pick_frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
	---
	local avatar_texture = avatar_pick_frame:CreateTexture("AvatarPickFrameAvatarPreview", "overlay")
	avatar_texture:SetPoint("TOPLEFT", avatar_pick_frame, "TOPLEFT", 167, -10)
	avatar_texture:SetTexture(NICKTAG_DEFAULT_AVATAR)
	--
	local background_texture = avatar_pick_frame:CreateTexture("AvatarPickFrameBackgroundPreview", "artwork")
	background_texture:SetPoint("TOPLEFT", avatar_pick_frame, "TOPLEFT", 167, 2)
	background_texture:SetWidth(290)
	background_texture:SetHeight(75)
	background_texture:SetTexture(NickTag.background_pool[1][1])
	background_texture:SetTexCoord(unpack(NickTag.background_pool[1][3]))
	--
	local name = avatar_pick_frame:CreateFontString("AvatarPickFrameName", "overlay", "GameFontNormalHuge")
	name:SetTextColor(1, 1, 1)
	name:SetPoint("LEFT", avatar_texture, "RIGHT", -11, -17)
	name:SetText(UnitName("player"))
	---

	local OnClickFunction = function(button)
		if button.isAvatar then
			local avatar = NickTag.avatar_pool[button.IconID]
			_G.AvatarPickFrameAvatarPreview:SetTexture( avatar[1] )
			avatar_pick_frame.selected_avatar = avatar[1]
		elseif button.isBackground then
			local background = NickTag.background_pool[button.IconID]
			_G.AvatarPickFrameBackgroundPreview:SetTexture( background[1] )
			_G.AvatarPickFrameBackgroundPreview:SetTexCoord(unpack(background[3]))
			avatar_pick_frame.selected_background = background[1]
			avatar_pick_frame.selected_texcoord = background[3]
		end
	end

	local selectedColor = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		background_texture:SetVertexColor(r, g, b)
		avatar_pick_frame.selected_color[1] = r
		avatar_pick_frame.selected_color[2] = g
		avatar_pick_frame.selected_color[3] = b
	end

	local okey = CreateFrame("button", "AvatarPickFrameAccept", avatar_pick_frame, "OptionsButtonTemplate")
	okey:SetPoint("BOTTOMRIGHT", avatar_pick_frame, "BOTTOMRIGHT", -37, 12)
	okey:SetText("Accept")
	okey:SetFrameLevel(avatar_pick_frame:GetFrameLevel()+2)
	okey:SetScript("OnClick", function(self)
		avatar_pick_frame:Hide()
		if avatar_pick_frame.callback then
			avatar_pick_frame.callback(avatar_pick_frame.selected_avatar, {0, 1, 0, 1}, avatar_pick_frame.selected_background, avatar_pick_frame.selected_texcoord, avatar_pick_frame.selected_color)
		end
	end)
	local change_color = CreateFrame("button", "AvatarPickFrameColor", avatar_pick_frame, "OptionsButtonTemplate")
	change_color:SetPoint("BOTTOMRIGHT", avatar_pick_frame, "BOTTOMRIGHT", -205, 12)
	change_color:SetText("Color")
	change_color:SetFrameLevel(avatar_pick_frame:GetFrameLevel()+2)

	change_color:SetScript("OnClick", function(self)
		ColorPickerFrame.func = selectedColor
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetParent(avatar_pick_frame)
		ColorPickerFrame:SetColorRGB(_G.AvatarPickFrameBackgroundPreview:GetVertexColor())
		ColorPickerFrame:ClearAllPoints()
		ColorPickerFrame:SetPoint("LEFT", avatar_pick_frame, "RIGHT", 0, -10)
		ColorPickerFrame:Show()
	end)

	local buttons = {}
	for i = 0, 2 do
		local newbutton = CreateFrame("button", "AvatarPickFrameAvatarScrollButton"..i+1, avatar_pick_frame)
		newbutton:SetScript("OnClick", OnClickFunction)
		newbutton:SetWidth(128)
		newbutton:SetHeight(64)
		newbutton:SetPoint("TOPLEFT", avatar_pick_frame, "TOPLEFT", 15,(i*70*-1) - 20)
		newbutton:SetID(i + 1)
		newbutton.isAvatar = true
		buttons[#buttons + 1] = newbutton
	end

	local buttonsbg = {}
	for i = 0, 2 do
		local newbutton = CreateFrame("button", "AvatarPickFrameBackgroundScrollButton"..i+1, avatar_pick_frame)
		newbutton:SetScript("OnClick", OnClickFunction)
		newbutton:SetWidth(275)
		newbutton:SetHeight(60)
		newbutton:SetPoint("TOPLEFT", avatar_pick_frame, "TOPLEFT", 157,(i*50*-1) - 80)
		newbutton:SetID(i+1)
		newbutton.isBackground = true
		buttonsbg[#buttonsbg+1] = newbutton
	end

	local avatar_list = CreateFrame("ScrollFrame", "AvatarPickFrameAvatarScroll", avatar_pick_frame, "FauxScrollFrameTemplate")
	avatar_list:SetPoint("TOPLEFT", avatar_pick_frame, "TOPLEFT", 10, -10)
	local background_list = CreateFrame("ScrollFrame", "AvatarPickFrameBackgroundScroll", avatar_pick_frame, "FauxScrollFrameTemplate")
	background_list:SetPoint("TOPLEFT", avatar_pick_frame, "TOPLEFT", 147, -85)

	avatar_list:SetWidth(128)
	avatar_list:SetHeight(220)
	background_list:SetWidth(275)
	background_list:SetHeight(140)

	local avatar_scroll_update = function(self)
		local numMacroIcons = #NickTag.avatar_pool
		local macroPopupIcon, macroPopupButton, index, texture
		local macroPopupOffset = FauxScrollFrame_GetOffset(avatar_list)

		for i = 1, 3 do
			macroPopupIcon = _G["AvatarPickFrameAvatarScrollButton"..i]
			macroPopupButton = _G["AvatarPickFrameAvatarScrollButton"..i]
			index = (macroPopupOffset * 1) + i

			texture = NickTag.avatar_pool[index][1]
			if index <= numMacroIcons and texture then
				macroPopupButton:SetNormalTexture(texture)
				macroPopupButton:SetPushedTexture(texture)
				macroPopupButton:SetDisabledTexture(texture)
				macroPopupButton:SetHighlightTexture(texture, "ADD")
				macroPopupButton.IconID = index
				macroPopupButton:Show()
			else
				macroPopupButton:Hide()
			end
		end

		FauxScrollFrame_Update(avatar_list, numMacroIcons , 3, 64)
	end

	local background_scroll_update = function(self)
		local numMacroIcons = #NickTag.background_pool
		local macroPopupIcon, macroPopupButton, index, texture
		local macroPopupOffset = FauxScrollFrame_GetOffset(background_list)

		for i = 1, 3 do
			macroPopupIcon = _G["AvatarPickFrameBackgroundScrollButton"..i]
			macroPopupButton = _G["AvatarPickFrameBackgroundScrollButton"..i]
			index = (macroPopupOffset * 1) + i

			texture = NickTag.background_pool[index][1]
			if index <= numMacroIcons and texture then
				macroPopupButton:SetNormalTexture(texture)
				macroPopupButton:SetPushedTexture(texture)
				macroPopupButton:SetDisabledTexture(texture)
				macroPopupButton:SetHighlightTexture(texture, "ADD")
				macroPopupButton.IconID = index
				macroPopupButton:Show()
			else
				macroPopupButton:Hide()
			end
		end

		FauxScrollFrame_Update(background_list, numMacroIcons , 3, 40)
	end

	avatar_list:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(avatar_list, offset, 64, avatar_scroll_update)
	end)
	background_list:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(background_list, offset, 40, background_scroll_update)
	end)

	avatar_scroll_update(avatar_list)
	background_scroll_update(background_list)

	function avatar_pick_frame:SetAvatar(n)
		if type(n) ~= "number" then
			n = 1
		end

		if n > #NickTag.avatar_pool then
			n = 1
		end

		local avatar = NickTag.avatar_pool[n]
		_G.AvatarPickFrameAvatarPreview:SetTexture( avatar[1] )
		avatar_pick_frame.selected_avatar = avatar[1]
	end

	function avatar_pick_frame:SetBackground(n)
		if type(n) ~= "number" then
			n = 1
		end

		if n > #NickTag.background_pool then
			n = 1
		end

		local background = NickTag.background_pool[n]
		_G.AvatarPickFrameBackgroundPreview:SetTexture( background[1] )
		_G.AvatarPickFrameBackgroundPreview:SetTexCoord(unpack(background[3]))
		_G.AvatarPickFrameBackgroundPreview:SetVertexColor(unpack(avatar_pick_frame.selected_color))
		avatar_pick_frame.selected_background = background[1]
	end

	function avatar_pick_frame:SetColor(r, g, b)
		if type(r) ~= "number" or r > 1 then
			r = 1
		end

		if type(g) ~= "number" or g > 1 then
			g = 1
		end

		if type(b) ~= "number" or b > 1 then
			b = 1
		end

		_G.AvatarPickFrameBackgroundPreview:SetVertexColor(r, g, b)
		avatar_pick_frame.selected_color[1] = r
		avatar_pick_frame.selected_color[2] = g
		avatar_pick_frame.selected_color[3] = b
	end

	local CONST_INDEX_NICKNAME = 1
	local CONST_INDEX_AVATAR_PATH = 2
	local CONST_INDEX_AVATAR_TEXCOORD = 3
	local CONST_INDEX_BACKGROUND_PATH = 4
	local CONST_INDEX_BACKGROUND_TEXCOORD = 5
	local CONST_INDEX_BACKGROUND_COLOR = 6

	avatar_pick_frame:SetScript("OnShow", function()
		--get player avatar
		local avatar = NickTag:GetNicknameTable(UnitGUID("player"))
		if avatar then
			_G.AvatarPickFrameName:SetText( avatar[1] or UnitName("player"))

			_G.AvatarPickFrameAvatarPreview:SetTexture( avatar[CONST_INDEX_AVATAR_PATH] or NICKTAG_DEFAULT_AVATAR )
			avatar_pick_frame.selected_avatar = avatar[CONST_INDEX_AVATAR_PATH] or NICKTAG_DEFAULT_AVATAR

			_G.AvatarPickFrameAvatarPreview:SetTexCoord(0, 1, 0, 1) --> always

			_G.AvatarPickFrameBackgroundPreview:SetTexture( avatar[CONST_INDEX_BACKGROUND_PATH] or NICKTAG_DEFAULT_BACKGROUND )
			avatar_pick_frame.selected_background = avatar[CONST_INDEX_BACKGROUND_PATH] or NICKTAG_DEFAULT_BACKGROUND

			if avatar[CONST_INDEX_BACKGROUND_TEXCOORD] then
				_G.AvatarPickFrameBackgroundPreview:SetTexCoord( unpack(avatar[CONST_INDEX_BACKGROUND_TEXCOORD]) )
				avatar_pick_frame.selected_texcoord = avatar[CONST_INDEX_BACKGROUND_TEXCOORD]
			else
				_G.AvatarPickFrameBackgroundPreview:SetTexCoord( 0.129609375, 1, 1, 0 )
				avatar_pick_frame.selected_texcoord = {0.129609375, 1, 1, 0}
			end

			if avatar[CONST_INDEX_BACKGROUND_COLOR] then
				_G.AvatarPickFrameBackgroundPreview:SetVertexColor( unpack(avatar[CONST_INDEX_BACKGROUND_COLOR]) )
				avatar_pick_frame.selected_color = avatar[CONST_INDEX_BACKGROUND_COLOR]
			else
				_G.AvatarPickFrameBackgroundPreview:SetVertexColor( 1, 1, 1 )
				avatar_pick_frame.selected_color = {1, 1, 1}
			end
		else
			--> if none
			_G.AvatarPickFrameAvatarPreview:SetTexture( NICKTAG_DEFAULT_AVATAR )
			avatar_pick_frame.selected_avatar = NICKTAG_DEFAULT_AVATAR

			local background = NickTag.background_pool[1]

			if background then
				_G.AvatarPickFrameBackgroundPreview:SetTexture( background[1] )
				avatar_pick_frame.selected_background = background[1]
				_G.AvatarPickFrameBackgroundPreview:SetTexCoord(unpack(background[3]))
				avatar_pick_frame.selected_texcoord = background[3]
				_G.AvatarPickFrameBackgroundPreview:SetVertexColor(unpack(avatar_pick_frame.selected_color))
				avatar_pick_frame.selected_color = avatar_pick_frame.selected_color
			end
		end
	end)

	avatar_pick_frame:Hide()
end