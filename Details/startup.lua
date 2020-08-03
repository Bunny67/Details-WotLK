
local UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned

--> check unloaded files:
if (
	not _G._detalhes.atributo_custom.damagedoneTooltip or
	not _G._detalhes.atributo_custom.healdoneTooltip
	) then

	local f = CreateFrame ("Frame", "DetaisCorruptInstall", UIParent)
	f:SetSize (370, 70)
	f:SetPoint ("CENTER", UIParent, "CENTER", 0, 0)
	f:SetPoint ("TOP", UIParent, "TOP", 0, -20)
	local bg = f:CreateTexture (nil, "background")
	bg:SetAllPoints (f)
	bg:SetTexture ([[Interface\AddOns\Details\images\welcome]])

	local image = f:CreateTexture (nil, "overlay")
	image:SetTexture ([[Interface\AddOns\Details\textures\DialogFrame\UI-Dialog-Icon-AlertNew]])
	image:SetSize (32, 32)

	local label = f:CreateFontString (nil, "overlay", "GameFontNormal")
	label:SetText ("Restart game client in order to finish addons updates.")
	label:SetWidth (300)
	label:SetJustifyH ("LEFT")

	local close = CreateFrame ("button", "DetaisCorruptInstall", f, "UIPanelCloseButton")
	close:SetSize (32, 32)
	close:SetPoint ("TOPRIGHT", f, "TOPRIGHT", 0, 0)

	image:SetPoint ("TOPLEFT", f, "TOPLEFT", 10, -20)
	label:SetPoint ("LEFT", image, "RIGHT", 4, 0)

	_G._detalhes.FILEBROKEN = true
end

function _G._detalhes:InstallOkey()
	if (_G._detalhes.FILEBROKEN) then
		return false
	end
	return true
end

--> start funtion
function _G._detalhes:Start()
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> row single click

	--> single click row function replace
		--damage, dps, damage taken, friendly fire
			self.row_singleclick_overwrite [1] = {true, true, true, true, self.atributo_damage.ReportSingleFragsLine, self.atributo_damage.ReportEnemyDamageTaken, self.atributo_damage.ReportSingleVoidZoneLine, self.atributo_damage.ReportSingleDTBSLine}
		--healing, hps, overheal, healing taken
			self.row_singleclick_overwrite [2] = {true, true, true, true, false, self.atributo_heal.ReportSingleDamagePreventedLine}
		--mana, rage, energy, runepower
			self.row_singleclick_overwrite [3] = {true, true, true, true}
		--cc breaks, ress, interrupts, dispells, deaths
			self.row_singleclick_overwrite [4] = {true, true, true, true, self.atributo_misc.ReportSingleDeadLine, self.atributo_misc.ReportSingleCooldownLine, self.atributo_misc.ReportSingleBuffUptimeLine, self.atributo_misc.ReportSingleDebuffUptimeLine}

		function self:ReplaceRowSingleClickFunction (attribute, sub_attribute, func)
			assert (type (attribute) == "number" and attribute >= 1 and attribute <= 4, "ReplaceRowSingleClickFunction expects a attribute index on #1 argument.")
			assert (type (sub_attribute) == "number" and sub_attribute >= 1 and sub_attribute <= 10, "ReplaceRowSingleClickFunction expects a sub attribute index on #2 argument.")
			assert (type (func) == "function", "ReplaceRowSingleClickFunction expects a function on #3 argument.")

			self.row_singleclick_overwrite [attribute] [sub_attribute] = func
			return true
		end

		self.click_to_report_color = {1, 0.8, 0, 1}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialize

	--> build frames

		--> plugin container
			self:CreatePluginWindowContainer()
			self:InitializeForge() --to install into the container plugin
			self:InitializeRaidHistoryWindow()
			self:InitializeOptionsWindow()

			C_Timer.After (2, function()
				self:InitializeAuraCreationWindow()
			end)

			self:InitializeCustomDisplayWindow()
			self:InitializeAPIWindow()
			self:InitializeRunCodeWindow()
			self:InitializeMacrosWindow()

		--> bookmarks
			if (self.switch.InitSwitch) then
				--self.switch:InitSwitch()
			end

		--> custom window
			self.custom = self.custom or {}

		--> actor details window
			self.janela_info = self.gump:CriaJanelaInfo()
			self.gump:Fade (self.janela_info, 1)

		--> copy and paste window
			self:CreateCopyPasteWindow()
			self.CreateCopyPasteWindow = nil

	--> start instances
		if (self:GetNumInstancesAmount() == 0) then
			self:CriarInstancia()
		end
		self:GetLowerInstanceNumber()

	--> start time machine
		self.timeMachine:Ligar()

	--> update abbreviation shortcut

		self.atributo_damage:UpdateSelectedToKFunction()
		self.atributo_heal:UpdateSelectedToKFunction()
		self.atributo_energy:UpdateSelectedToKFunction()
		self.atributo_misc:UpdateSelectedToKFunction()
		self.atributo_custom:UpdateSelectedToKFunction()

	--> start instances updater

		self:CheckSwitchOnLogon()

		function _detalhes:ScheduledWindowUpdate (forced)
			if (not forced and _detalhes.in_combat) then
				return
			end
			_detalhes.scheduled_window_update = nil
			_detalhes:AtualizaGumpPrincipal (-1, true)
		end
		function _detalhes:ScheduleWindowUpdate (time, forced)
			if (_detalhes.scheduled_window_update) then
				_detalhes:CancelTimer (_detalhes.scheduled_window_update)
				_detalhes.scheduled_window_update = nil
			end
			_detalhes.scheduled_window_update = _detalhes:ScheduleTimer ("ScheduledWindowUpdate", time or 1, forced)
		end

		self:AtualizaGumpPrincipal (-1, true)
		_detalhes:RefreshUpdater()

		for index = 1, #self.tabela_instancias do
			local instance = self.tabela_instancias [index]
			if (instance:IsAtiva()) then
				self:ScheduleTimer ("RefreshBars", 1, instance)
				self:ScheduleTimer ("InstanceReset", 1, instance)
				self:ScheduleTimer ("InstanceRefreshRows", 1, instance)
			end
		end

		function self:RefreshAfterStartup()

			self:AtualizaGumpPrincipal (-1, true)

			local lower_instance = _detalhes:GetLowerInstanceNumber()

			for index = 1, #self.tabela_instancias do
				local instance = self.tabela_instancias [index]
				if (instance:IsAtiva()) then
					--> refresh wallpaper
					if (instance.wallpaper.enabled) then
						instance:InstanceWallpaper (true)
					else
						instance:InstanceWallpaper (false)
					end

					--> refresh desaturated icons if is lower instance
					if (index == lower_instance) then
						instance:DesaturateMenu()

						instance:SetAutoHideMenu (nil, nil, true)
					end

				end
			end

			--> refresh lower instance plugin icons and skin
			_detalhes.ToolBar:ReorganizeIcons()
			--> refresh skin for other windows
			if (lower_instance) then
				for i = lower_instance+1, #self.tabela_instancias do
					local instance = self:GetInstance (i)
					if (instance and instance.baseframe and instance.ativa) then
						instance:ChangeSkin()
					end
				end
			end

			self.RefreshAfterStartup = nil

			function _detalhes:CheckWallpaperAfterStartup()

				if (not _detalhes.profile_loaded) then
					return _detalhes:ScheduleTimer ("CheckWallpaperAfterStartup", 2)
				end

				for i = 1, self.instances_amount do
					local instance = self:GetInstance (i)
					if (instance and instance:IsEnabled()) then
						if (not instance.wallpaper.enabled) then
							instance:InstanceWallpaper (false)
						end

						instance.do_not_snap = true
						self.move_janela_func (instance.baseframe, true, instance, true)
						self.move_janela_func (instance.baseframe, false, instance, true)
						instance.do_not_snap = false
					end
				end
				self.CheckWallpaperAfterStartup = nil
				_detalhes.profile_loaded = nil

			end

			_detalhes:ScheduleTimer ("CheckWallpaperAfterStartup", 5)

		end
		self:ScheduleTimer ("RefreshAfterStartup", 5)


	--> start garbage collector

		self.ultima_coleta = 0
		self.intervalo_coleta = 720
		--self.intervalo_coleta = 10
		self.intervalo_memoria = 180
		--self.intervalo_memoria = 20
		self.garbagecollect = self:ScheduleRepeatingTimer ("IniciarColetaDeLixo", self.intervalo_coleta)

		--desativado, algo bugou no 7.2.5
		--self.memorycleanup = self:ScheduleRepeatingTimer ("CheckMemoryPeriodically", self.intervalo_memoria)

		self.next_memory_check = time()+self.intervalo_memoria

	--> role
		self.last_assigned_role = UnitGroupRolesAssigned ("player")

	--> start parser

		--> load parser capture options
			self:CaptureRefresh()
		--> register parser events

			self.listener:RegisterEvent ("PLAYER_REGEN_DISABLED")
			self.listener:RegisterEvent ("PLAYER_REGEN_ENABLED")
			--self.listener:RegisterEvent ("SPELL_SUMMON") --triggering error on 8.0
			self.listener:RegisterEvent ("UNIT_PET")

			self.listener:RegisterEvent ("PARTY_MEMBERS_CHANGED")
			self.listener:RegisterEvent ("RAID_ROSTER_UPDATE")
			--self.listener:RegisterEvent ("PARTY_CONVERTED_TO_RAID") --triggering error on 8.0

			self.listener:RegisterEvent ("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

			self.listener:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
			self.listener:RegisterEvent ("PLAYER_ENTERING_WORLD")

			self.listener:RegisterEvent ("ENCOUNTER_START")
			self.listener:RegisterEvent ("ENCOUNTER_END")

			self.listener:RegisterEvent ("CHAT_MSG_BG_SYSTEM_NEUTRAL")
			self.listener:RegisterEvent ("UNIT_NAME_UPDATE")

			self.listener:RegisterEvent ("PLAYER_ROLES_ASSIGNED")

			self.listener:RegisterEvent ("UNIT_FACTION")

			self.listener:RegisterEvent ("ACTIVE_TALENT_GROUP_CHANGED")
			self.listener:RegisterEvent ("PLAYER_TALENT_UPDATE")

			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			self.parser_frame:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")

	--> group
		self.details_users = {}
		self.in_group = IsInGroup() or IsInRaid()

	--> done
		self.initializing = nil

	--> scan pets
		_detalhes:SchedulePetUpdate (1)

	--> send messages gathered on initialization
		self:ScheduleTimer ("ShowDelayMsg", 10)

	--> send instance open signal
		for index, instancia in _detalhes:ListInstances() do
			if (instancia.ativa) then
				self:SendEvent ("DETAILS_INSTANCE_OPEN", nil, instancia)
			end
		end

	--> send details startup done signal
		function self:AnnounceStartup()

			self:SendEvent ("DETAILS_STARTED", "SEND_TO_ALL")

			if (_detalhes.in_group) then
				_detalhes:SendEvent ("GROUP_ONENTER")
			else
				_detalhes:SendEvent ("GROUP_ONLEAVE")
			end

			_detalhes.last_zone_type = "INIT"
			_detalhes.parser_functions:ZONE_CHANGED_NEW_AREA()

			_detalhes.AnnounceStartup = nil

		end
		self:ScheduleTimer ("AnnounceStartup", 5)

		if (_detalhes.failed_to_load) then
			_detalhes:CancelTimer (_detalhes.failed_to_load)
			_detalhes.failed_to_load = nil
		end

		--function self:RunAutoHideMenu()
		--	local lower_instance = _detalhes:GetLowerInstanceNumber()
		--	local instance = self:GetInstance (lower_instance)
		--	instance:SetAutoHideMenu (nil, nil, true)
		--end
		--self:ScheduleTimer ("RunAutoHideMenu", 15)

	--> announce alpha version
		function self:AnnounceVersion()
			for index, instancia in _detalhes:ListInstances() do
				if (instancia.ativa) then
					self.gump:Fade (instancia._version, "in", 0.1)
				end
			end
		end

	--> check version
		_detalhes:CheckVersion (true)

	--> restore cooltip anchor position
		DetailsTooltipAnchor:Restore()

	--> check is this is the first run
		if (self.is_first_run) then
			if (#self.custom == 0) then
				_detalhes:AddDefaultCustomDisplays()
			end

			_detalhes:FillUserCustomSpells()
		end

	--> send feedback panel if the user got 100 or more logons with details
		if (self.tutorial.logons == 100) then --  and self.tutorial.logons < 104
			if (not self.tutorial.feedback_window1 and not _detalhes.streamer_config.no_alerts) then
				--> check if isn't inside an instance
				if (_detalhes:IsInCity()) then
					self.tutorial.feedback_window1 = true
					_detalhes:ShowFeedbackRequestWindow()
				end
			end
		end

	--> check is this is the first run of this version
		if (self.is_version_first_run) then



			local enable_reset_warning = true

			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (lower_instance) then
				lower_instance = _detalhes:GetInstance (lower_instance)
				if (lower_instance and _detalhes.latest_news_saw ~= _detalhes.userversion) then
					C_Timer.After (10, function()
						if (lower_instance:IsEnabled()) then
							lower_instance:InstanceAlert (Loc ["STRING_VERSION_UPDATE"], {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, 60, {_detalhes.OpenNewsWindow}, true)
							Details:Msg ("A new version has been installed: /details news")
						end
					end)
				end
			end

			_detalhes:FillUserCustomSpells()
			_detalhes:AddDefaultCustomDisplays()

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 134 and enable_reset_warning) then
				C_Timer.After (10, function()
					for ID, instance in _detalhes:ListInstances() do
						if (instance:IsEnabled()) then
							local lineHeight = instance.row_info.height
							local textSize = instance.row_info.font_size
							if (lineHeight-1 <= textSize) then
							-- no need this, scheduled to code cleanup
							--	instance.row_info.height = 21
							--	instance.row_info.font_size = 16
							--	instance:ChangeSkin()
							end
						end
					end
				end)
			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < _detalhes.BFACORE and enable_reset_warning) then

				--> BFA launch

				C_Timer.After (5, function()

					--_detalhes:Msg ("Some settings has been reseted for 8.0.1 patch.")

					--> check and reset minimalistic skin to the new minimalistic
						local oldColor = {
							0.333333333333333, -- [1]
							0.333333333333333, -- [2]
							0.333333333333333, -- [3]
							0.3777777777777, -- [4]
						}

						for ID, instance in _detalhes:ListInstances() do
							if (instance:IsEnabled()) then
								local instanceColor = instance.color
								if (_detalhes.gump:IsNearlyEqual (instanceColor[1], oldColor[1])) then
									if (_detalhes.gump:IsNearlyEqual (instanceColor[2], oldColor[2])) then
										if (_detalhes.gump:IsNearlyEqual (instanceColor[3], oldColor[3])) then
											if (_detalhes.gump:IsNearlyEqual (instanceColor[4], oldColor[4])) then

												--_detalhes:Msg ("Updating the Minimalistic skin.")

												instance:ChangeSkin ("Minimalistic v2")
												instance:ChangeSkin ("Minimalistic")
											end
										end
									end
								end
							end
						end

					--> apply some new settings:
						_detalhes.show_arena_role_icon = false --don't  show the arena icon by default
						_detalhes.segments_amount = 18
						_detalhes.segments_amount_to_save = 18
						_detalhes.use_row_animations = true
						_detalhes.update_speed = math.min (0.33, _detalhes.update_speed)
						_detalhes.death_tooltip_width = math.max (_detalhes.death_tooltip_width, 350)
						_detalhes.use_battleground_server_parser = false

					--> wipe item level cache
						wipe (_detalhes.item_level_pool)

				end)

			end


			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 127 and enable_reset_warning) then
				if (not _detalhes:GetTutorialCVar ("STREAMER_FEATURES_POPUP1")) then
					_detalhes:SetTutorialCVar ("STREAMER_FEATURES_POPUP1", true)

					local f = CreateFrame ("Frame", "DetailsContentCreatorsAlert", UIParent)
					tinsert (UISpecialFrames, "DetailsContentCreatorsAlert")
					f:SetPoint ("CENTER")
					f:SetSize (785, 516)
					local bg = f:CreateTexture (nil, "background")
					bg:SetPoint ("CENTER", f, "CENTER")
					bg:SetTexture ([[Interface\GLUES\AccountUpgrade\upgrade-texture.blp]])
					bg:SetTexCoord (0/1024, 785/1024, 192/1024, 708/1024)
					bg:SetSize (785, 516)
					C_Timer.After (1, function ()f:Show()end)

					local logo = f:CreateTexture (nil, "artwork")
					logo:SetPoint ("TOPLEFT", f, "TOPLEFT", 40, -60)
					logo:SetTexture ([[Interface\Addons\Details\images\logotipo]])
					logo:SetTexCoord (0.07421875, 0.73828125, 0.51953125, 0.890625)
					logo:SetWidth (186*1.2)
					logo:SetHeight (50*1.2)

					local title = f:CreateFontString (nil, "overlay", "GameFontNormal")
					title:SetPoint ("TOPLEFT", f, "TOPLEFT", 120, -160)
					title:SetText ("Updates For Youtubers and Streamers")
					_detalhes.gump:SetFontSize (title, 16)

					local text1 = f:CreateFontString (nil, "overlay", "GameFontNormal")
					text1:SetPoint ("TOPLEFT", f, "TOPLEFT", 60, -210)
					text1:SetText ("Yeap, another popup window, but it's for a good cause: has been added new features for content creators, check it out at the options panel > Streamer Settings, thank you!")
					text1:SetSize (400, 200)
					text1:SetJustifyV ("TOP")
					text1:SetJustifyH ("LEFT")

					local ipad = f:CreateTexture (nil, "overlay")
					ipad:SetTexture ([[Interface\Addons\Details\images\icons2]])
					ipad:SetSize (130, 89)
					ipad:SetPoint ("TOPLEFT", bg, "TOPLEFT", 474, -279)
					ipad:SetTexCoord (110/512, 240/512, 163/512, 251/512)

					local playerteam = f:CreateTexture (nil, "overlay")
					playerteam:SetTexture ([[Interface\Addons\Details\images\icons2]])
					playerteam:SetSize (250, 61)
					playerteam:SetPoint ("TOPLEFT", bg, "TOPLEFT", 50, -289)
					playerteam:SetTexCoord (259/512, 509/512, 186/512, 247/512)

					local eventtracker = f:CreateTexture (nil, "overlay")
					eventtracker:SetTexture ([[Interface\Addons\Details\images\icons2]])
					eventtracker:SetSize (256, 50)
					eventtracker:SetPoint ("TOPLEFT", bg, "TOPLEFT", 50, -370)
					eventtracker:SetTexCoord (0.5, 1, 134/512, 184/512)

					local closebutton = _detalhes.gump:CreateButton (f, function() f:Hide() end, 100, 24, "CLOSE")
					closebutton:SetPoint ("TOPLEFT", bg, "TOPLEFT", 400, -405)
					closebutton:InstallCustomTexture()

					C_Timer.After (5, function()
						local StreamerPlugin = _detalhes:GetPlugin ("DETAILS_PLUGIN_STREAM_OVERLAY")
						if (StreamerPlugin) then
							local tPluginSettings = _detalhes:GetPluginSavedTable ("DETAILS_PLUGIN_STREAM_OVERLAY")
							if (tPluginSettings) then
								local bIsPluginEnabled = tPluginSettings.enabled
								if (bIsPluginEnabled and _detalhes.streamer_config) then
									_detalhes.streamer_config.use_animation_accel = true
								end
							end
						end
					end)
				end
			end
			--]]

			--> erase the custom for damage taken by spell
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 75 and enable_reset_warning) then
				if (_detalhes.global_plugin_database and _detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"]) then
					wipe (_detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"].encounter_timers_dbm)
					wipe (_detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"].encounter_timers_bw)
				end
			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 74 and enable_reset_warning) then
				function _detalhes:FixMonkSpecIcons()
					local m269 = _detalhes.class_specs_coords [269]
					local m270 = _detalhes.class_specs_coords [270]

					m269[1], m269[2], m269[3], m269[4] = 448/512, 512/512, 64/512, 128/512
					m270[1], m270[2], m270[3], m270[4] = 384/512, 448/512, 64/512, 128/512
				end
				_detalhes:ScheduleTimer ("FixMonkSpecIcons", 1)
			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 73 and enable_reset_warning) then
				local secure_func = function()
					for i = #_detalhes.custom, 1, -1 do
						local index = i
						local CustomObject = _detalhes.custom [index]

						if (CustomObject:GetName() == Loc ["STRING_CUSTOM_DTBS"]) then
							for o = 1, _detalhes.switch.slots do
								local options = _detalhes.switch.table [o]
								if (options and options.atributo == 5 and options.sub_atributo == index) then
									options.atributo = 1
									options.sub_atributo = 8
									_detalhes.switch:Update()
								end
							end

							_detalhes.atributo_custom:RemoveCustom (index)
						end
					end
				end
				pcall (secure_func)
			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 70 and enable_reset_warning) then
				local bg = _detalhes.tooltip.background
				bg [1] = 0.1960
				bg [2] = 0.1960
				bg [3] = 0.1960
				bg [4] = 0.8697

				local border = _detalhes.tooltip.border_color
				border [1] = 1
				border [2] = 1
				border [3] = 1
				border [4] = 0

				--> refresh
				_detalhes:SetTooltipBackdrop()
			end

			--> check elvui for the new player detail skin
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 71 and enable_reset_warning) then
				function _detalhes:PDWElvuiCheck()
					_detalhes:ApplyPDWSkin ("ElvUI")

					_detalhes.class_specs_coords[62][1] = (128/512) + 0.001953125
					_detalhes.class_specs_coords[70][1] = (128/512) + 0.001953125
					_detalhes.class_specs_coords[258][1] = (320/512) + 0.001953125
				end
				_detalhes:ScheduleTimer ("PDWElvuiCheck", 2)
			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 69 and enable_reset_warning) then
				function _detalhes:PDWElvuiCheck()
					local ElvUI = _G.ElvUI
					if (ElvUI) then
						_detalhes:ApplyPDWSkin ("ElvUI")
					end
				end
				_detalhes:ScheduleTimer ("PDWElvuiCheck", 1)
			end

			--> Reset for the new structure
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 66 and enable_reset_warning) then
				function _detalhes:ResetDataStorage()
					if (not IsAddOnLoaded ("Details_DataStorage")) then
						local loaded, reason = LoadAddOn ("Details_DataStorage")
						if (not loaded) then
							return
						end
					end

					local db = DetailsDataStorage
					if (db) then
						table.wipe (db)
					end

					DetailsDataStorage = _detalhes:CreateStorageDB()
				end
				_detalhes:ScheduleTimer ("ResetDataStorage", 1)

				_detalhes.segments_panic_mode = false

			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 47 and enable_reset_warning) then
				for i = #_detalhes.custom, 1, -1  do
					_detalhes.atributo_custom:RemoveCustom (i)
				end
				_detalhes:AddDefaultCustomDisplays()
			end

		end

	local lower = _detalhes:GetLowerInstanceNumber()
	if (lower) then
		local instance = _detalhes:GetInstance (lower)
		if (instance) then

			--in development
			local dev_icon = instance.bgdisplay:CreateTexture (nil, "overlay")
			dev_icon:SetWidth (40)
			dev_icon:SetHeight (40)
			dev_icon:SetPoint ("BOTTOMLEFT", instance.baseframe, "BOTTOMLEFT", 4, 8)
			dev_icon:SetAlpha (.3)

			local dev_text = instance.bgdisplay:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			dev_text:SetHeight (64)
			dev_text:SetPoint ("LEFT", dev_icon, "RIGHT", 5, 0)
			dev_text:SetTextColor (1, 1, 1)
			dev_text:SetAlpha (.3)

			if (self.tutorial.logons < 50) then
				--dev_text:SetText ("Details is Under\nDevelopment")
				--dev_icon:SetTexture ([[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]])
			end

			--version
			self.gump:Fade (instance._version, 0)
			instance._version:SetText ("Details! " .. _detalhes.userversion .. " (core " .. self.realversion .. ")")
			instance._version:SetTextColor (1, 1, 1, .35)
			instance._version:SetPoint ("BOTTOMLEFT", instance.baseframe, "BOTTOMLEFT", 5, 1)

			if (instance.auto_switch_to_old) then
				instance:SwitchBack()
			end

			function _detalhes:FadeStartVersion()
				_detalhes.gump:Fade (dev_icon, "in", 2)
				_detalhes.gump:Fade (dev_text, "in", 2)
				self.gump:Fade (instance._version, "in", 2)

				if (_detalhes.switch.table) then

					local have_bookmark

					for index, t in ipairs (_detalhes.switch.table) do
						if (t.atributo) then
							have_bookmark = true
							break
						end
					end

					if (not have_bookmark) then
						function _detalhes:WarningAddBookmark()
							instance._version:SetText ("right click to set bookmarks.")
							self.gump:Fade (instance._version, "out", 1)
							function _detalhes:FadeBookmarkWarning()
								self.gump:Fade (instance._version, "in", 2)
							end
							_detalhes:ScheduleTimer ("FadeBookmarkWarning", 5)
						end
						_detalhes:ScheduleTimer ("WarningAddBookmark", 2)
					end
				end

			end

			_detalhes:ScheduleTimer ("FadeStartVersion", 12)

		end
	end

	function _detalhes:OpenOptionsWindowAtStart()
		--_detalhes:OpenOptionsWindow (_detalhes.tabela_instancias[1])
		--print (_G ["DetailsClearSegmentsButton1"]:GetSize())
		--_detalhes:OpenCustomDisplayWindow()
		--_detalhes:OpenWelcomeWindow()
	end
	_detalhes:ScheduleTimer ("OpenOptionsWindowAtStart", 2)
	--_detalhes:OpenCustomDisplayWindow()

	--> minimap
	pcall (_detalhes.RegisterMinimap, _detalhes)

	--> hot corner
	function _detalhes:RegisterHotCorner()
		_detalhes:DoRegisterHotCorner()
	end
	_detalhes:ScheduleTimer ("RegisterHotCorner", 5)

	--> get in the realm chat channel
	if (not _detalhes.schedule_chat_enter and not _detalhes.schedule_chat_leave) then
		_detalhes:ScheduleTimer ("CheckChatOnZoneChange", 60)
	end

	--> open profiler
	_detalhes:OpenProfiler()

	--> start announcers
	_detalhes:StartAnnouncers()

	--> start aura
	_detalhes:CreateAuraListener()

	--> open welcome
	if (self.is_first_run) then
		C_Timer.After (1, function() --wait details full load the rest of the systems before executing the welcome window
			_detalhes:OpenWelcomeWindow()
		end)
	end

	--> load broadcaster tools
	_detalhes:LoadFramesForBroadcastTools()

	--_detalhes:OpenWelcomeWindow() --debug
	-- /run _detalhes:OpenWelcomeWindow()

	_detalhes:BrokerTick()

	--boss mobs callbacks
	_detalhes:ScheduleTimer ("BossModsLink", 5)

	--> limit item level life for 24Hs
	local now = time()
	for guid, t in pairs (_detalhes.item_level_pool) do
		if (t.time+86400 < now) then
			_detalhes.item_level_pool [guid] = nil
		end
	end

	--> dailly reset of the cache for talents and specs.
	local today = date ("%d")
	if (_detalhes.last_day ~= today) then
		wipe (_detalhes.cached_specs)
		wipe (_detalhes.cached_talents)
	end

	--> get the player spec
	C_Timer.After (2, _detalhes.parser_functions.ACTIVE_TALENT_GROUP_CHANGED)

	_detalhes.chat_embed:CheckChatEmbed (true)

	--_detalhes:SetTutorialCVar ("MEMORY_USAGE_ALERT1", false)
	if (not _detalhes:GetTutorialCVar ("MEMORY_USAGE_ALERT1") and false) then --> disabled the warning
		function _detalhes:AlertAboutMemoryUsage()
			if (DetailsWelcomeWindow and DetailsWelcomeWindow:IsShown()) then
				return _detalhes:ScheduleTimer ("AlertAboutMemoryUsage", 30)
			end

			local f = _detalhes.gump:CreateSimplePanel (UIParent, 500, 290, Loc ["STRING_MEMORY_ALERT_TITLE"], "AlertAboutMemoryUsagePanel", {NoTUISpecialFrame = true, DontRightClickClose = true})
			f:SetPoint ("CENTER", UIParent, "CENTER", -200, 100)
			f.Close:Hide()
			_detalhes:SetFontColor (f.Title, "yellow")

			local gnoma = _detalhes.gump:CreateImage (f.TitleBar, [[Interface\AddOns\Details\images\icons2]], 104, 107, "overlay", {104/512, 0, 405/512, 1})
			gnoma:SetPoint ("TOPRIGHT", 0, 14)

			local logo = _detalhes.gump:CreateImage (f, [[Interface\AddOns\Details\images\logotipo]])
			logo:SetPoint ("TOPLEFT", -5, 15)
			logo:SetSize (512*0.4, 256*0.4)

			local text1 = Loc ["STRING_MEMORY_ALERT_TEXT1"]
			local text2 = Loc ["STRING_MEMORY_ALERT_TEXT2"]
			local text3 = Loc ["STRING_MEMORY_ALERT_TEXT3"]

			local str1 = _detalhes.gump:CreateLabel (f, text1)
			str1.width = 480
			str1.fontsize = 12
			str1:SetPoint ("TOPLEFT", 10, -100)

			local str2 = _detalhes.gump:CreateLabel (f, text2)
			str2.width = 480
			str2.fontsize = 12
			str2:SetPoint ("TOPLEFT", 10, -150)

			local str3 = _detalhes.gump:CreateLabel (f, text3)
			str3.width = 480
			str3.fontsize = 12
			str3:SetPoint ("TOPLEFT", 10, -200)

			local textbox = _detalhes.gump:CreateTextEntry (f, function()end, 350, 20, nil, nil, nil, _detalhes.gump:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			textbox:SetPoint ("TOPLEFT", 10, -250)
			textbox:SetText ([[www.curse.com/addons/wow/addons-cpu-usage]])
			textbox:SetHook ("OnEditFocusGained", function() textbox:HighlightText() end)

			local close_func = function()
				_detalhes:SetTutorialCVar ("MEMORY_USAGE_ALERT1", true)
				f:Hide()
			end
			local close = _detalhes.gump:CreateButton (f, close_func, 127, 20, Loc ["STRING_MEMORY_ALERT_BUTTON"], nil, nil, nil, nil, nil, nil, _detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
			close:SetPoint ("LEFT", textbox, "RIGHT", 2, 0)

		end
		_detalhes:ScheduleTimer ("AlertAboutMemoryUsage", 30) --30
	end

	_detalhes.AddOnStartTime = GetTime()

	--_detalhes.player_details_window.skin = "ElvUI"
	if (_detalhes.player_details_window.skin ~= "ElvUI") then
		local reset_player_detail_window = function()
			_detalhes:ApplyPDWSkin ("ElvUI")
		end
		C_Timer.After (2, reset_player_detail_window)
	end

	--enforce to show 6 abilities on the tooltip
	_detalhes.tooltip.tooltip_max_abilities = 6

	--enforce to use the new animation code
	if (_detalhes.streamer_config) then
		_detalhes.streamer_config.use_animation_accel = true
	end

	--> auto run scripts
		local codeTable = _detalhes.run_code
		_detalhes.AutoRunCode = {}

		--from weakauras, list of functions to block on scripts
		--source https://github.com/WeakAuras/WeakAuras2/blob/520951a4b49b64cb49d88c1a8542d02bbcdbe412/WeakAuras/AuraEnvironment.lua#L66
		local blockedFunctions = {
			-- Lua functions that may allow breaking out of the environment
			getfenv = true,
			loadstring = true,
			pcall = true,
			xpcall = true,
			getglobal = true,

			-- blocked WoW API
			SendMail = true,
			SetTradeMoney = true,
			AddTradeMoney = true,
			PickupTradeMoney = true,
			PickupPlayerMoney = true,
			TradeFrame = true,
			MailFrame = true,
			EnumerateFrames = true,
			RunScript = true,
			AcceptTrade = true,
			SetSendMailMoney = true,
			EditMacro = true,
			SlashCmdList = true,
			DevTools_DumpCommand = true,
			hash_SlashCmdList = true,
			CreateMacro = true,
			SetBindingMacro = true,
			GuildDisband = true,
			GuildUninvite = true,
			securecall = true,

			--additional
			setmetatable = true,
		}

		local functionFilter = setmetatable ({}, {__index = function (env, key)
			if (key == "_G") then
				return env

			elseif (blockedFunctions [key]) then
				return nil

			else
				return _G [key]
			end
		end})

		--> compile and store code
		function _detalhes:RecompileAutoRunCode()
			for codeKey, code in pairs (codeTable) do
				local func, errorText = loadstring (code)
				if (func) then
					setfenv (func, functionFilter)
					_detalhes.AutoRunCode [codeKey] = func
				else
					--> if the code didn't pass, create a dummy function for it without triggering errors
					_detalhes.AutoRunCode [codeKey] = function() end
				end
			end
		end

		_detalhes:RecompileAutoRunCode()

		--> function to dispatch events
		function _detalhes:DispatchAutoRunCode (codeKey)
			local func = _detalhes.AutoRunCode [codeKey]
			_detalhes.gump:QuickDispatch (func)
		end

		--> auto run frame to dispatch scrtips for some events that details! doesn't handle
		local auto_run_code_dispatch = CreateFrame ("Frame")

		auto_run_code_dispatch:RegisterEvent ("ACTIVE_TALENT_GROUP_CHANGED")

		auto_run_code_dispatch.OnEventFunc = function (self, event)
			--> ignore events triggered more than once in a small time window
			if (auto_run_code_dispatch [event] and not auto_run_code_dispatch [event]._cancelled) then
				return
			end

			if (event == "ACTIVE_TALENT_GROUP_CHANGED") then
				--> create a trigger for the event, many times it is triggered more than once
				--> so if the event is triggered a second time, it will be ignored
				local newTimer = C_Timer.NewTicker (1, function()
					_detalhes:DispatchAutoRunCode ("on_specchanged")

					--> clear and invalidate the timer
					auto_run_code_dispatch [event]:Cancel()
					auto_run_code_dispatch [event] = nil
				end, 1)

				--> store the trigger
				auto_run_code_dispatch [event] = newTimer
			end
		end

		auto_run_code_dispatch:SetScript ("OnEvent", auto_run_code_dispatch.OnEventFunc)

		--> dispatch scripts at startup
		C_Timer.After (2, function()
			_detalhes:DispatchAutoRunCode ("on_init")
			_detalhes:DispatchAutoRunCode ("on_specchanged")
			_detalhes:DispatchAutoRunCode ("on_zonechanged")

			if (InCombatLockdown()) then
				_detalhes:DispatchAutoRunCode ("on_entercombat")
			else
				_detalhes:DispatchAutoRunCode ("on_leavecombat")
			end

			_detalhes:DispatchAutoRunCode ("on_groupchange")
		end)

	--> override the overall data flag on this release only (remove on the next release)
	--Details.overall_flag = 0x10
end

_detalhes.AddOnLoadFilesTime = GetTime()