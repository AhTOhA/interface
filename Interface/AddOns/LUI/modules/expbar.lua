local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists
local LUIHook = LUI:GetModule("LUIHook")
local module = LUI:NewModule("ExpBar", "AceHook-3.0")
local db

local fontflags = {'OUTLINE', 'THICKOUTLINE', 'MONOCHROME', 'NONE'}
local chatAlignments = {'LEFT', 'CENTER', 'RIGHT'}
local displayModes = {'PERCENT', 'VALUE', 'BOTH'}
local mmin, mmax, nmin, nmax, nval, nstad, vmin, vmax, vval

local UnitXP, UnitXPMax, GetWatchedFactionInfo = UnitXP, UnitXPMax, GetWatchedFactionInfo

local defaults = {
   ExpBar = {
	  Enable = true,
	  showPercent = true,
	  displayMode = 'PERCENT',
	  alwaysShow = true,
	  PercentFont = "Arial Narrow",
	  PercentFontSize = 14,
	  PercentFontFlag = "NONE",
	  PercentFontJustify = "CENTER",
	  PercentFontColors = {
		 r = 0,
		 g = 1,
		 b = 1,
		 a = 1,
	  },
   },
}
local function SetPercentFont(frame)
	if frame then
		if (frame.text) then
			frame.text:SetFont(LSM:Fetch("font", db.ExpBar.PercentFont), db.ExpBar.PercentFontSize, db.ExpBar.PercentFontFlag)
		end
	end
end
local function SetPercentJustify(frame)
	if frame then
		if (frame.text) then
			frame.text:SetJustifyH(db.ExpBar.PercentFontJustify);
		end
	end
end
local function SetPercentColor(frame)
	local r = db.ExpBar.PercentFontColors.r or 0;
	local g = db.ExpBar.PercentFontColors.g or 0;
	local b = db.ExpBar.PercentFontColors.b or 0;
	local a = db.ExpBar.PercentFontColors.a or 0;
	
	if frame then
		if (frame.text) then
			frame.text:SetTextColor(r, g, b, a);
		end
	end
end
function module:LoadOptions()
   local options = {
	  ExpBar = {
		 name = "ExpBar",
		 type = "group",
		 order = 50,
		 disabled = function() return not db.ExpBar.Enable end,
		 childGroups = "select",
		 args = {
			Enabled = {
			   name = "Show XP / Rep",
			   desc = "Show's the players current experience or reputation depending on level.",
			   disabled = function() return not db.ExpBar.Enable end,
			   type = "toggle",
			   get = function() return db.ExpBar.showPercent end,
			   set = function(self, ShowPer)
				  db.ExpBar.showPercent = not db.ExpBar.showPercent;
				  module:HandleUpdate("percent");
			   end,
			   order = 1,
			},
			DisplayMode = {
			   name = "Display Mode",
			   desc = "Select how the XP / Rep should be displayed\nDefault: "..LUI.defaults.profile.ExpBar.displayMode,
			   disabled = function() return not db.ExpBar.Enable end,
			   type = "select",
			   values = displayModes,
			   get = function()
				  for k,v in pairs(displayModes) do
					 if (db.ExpBar.displayMode == v) then
						return k
					 end
				  end
			   end,
			   set = function(self, DisplayMode)
				  db.ExpBar.displayMode = displayModes[DisplayMode];
				  if module.frame ~= nil then
					  if (module.frame.text) then
						 mmin, mmax = UnitXP("player"), UnitXPMax("player");
						 LUI_ExpBar_Update(nil, "player", mmin, mmax);
					  end
				  end
				  if module.frame2 ~= nil then
					  if (module.frame2.text) then
						 if GetWatchedFactionInfo() == nil then
							nstand, nmin, nmax, nval = "", 0, 1, 0
						 else
							_, nstand, nmin, nmax, nval = GetWatchedFactionInfo();
						 end
						 LUI_RepBar_Update(nil, "player", nil, nstand, nmin, nmax, nval);
					  end
				  end
			   end,
			   order = 2,
			},
			AlwaysShow = {
			   name = "Keep bar visible always.",
			   desc = "Keeps the bar visible at all times.",
			   disabled = function() return not db.ExpBar.Enable end,
			   type = "toggle",
			   width = "full",
			   get = function() return db.ExpBar.alwaysShow end,
			   set = function(self, Sho)
				  db.ExpBar.alwaysShow = not db.ExpBar.alwaysShow;
				  module:HandleUpdate("visible");
			   end,
			   order = 3,
			},
			PercentFont = {
			   name = "PercentFont",
			   desc = "Choose your font!\nDefault: "..LUI.defaults.profile.ExpBar.PercentFont,
			   type = "select",
			   disabled = function() return not db.ExpBar.showPercent; end,
			   dialogControl = "LSM30_Font",
			   values = widgetLists.font,
			   get = function() return db.ExpBar.PercentFont end,
			   set = function(self, font)
				  db.ExpBar.PercentFont = font;
				  SetPercentFont(module.frame);
				  SetPercentFont(module.frame2);
			   end,
			   order = 4,
			},
			PercentFontSize = {
			   name = "PercentFontSize",
			   desc = "Choose your font size!\nDefault: "..LUI.defaults.profile.ExpBar.PercentFontSize,
			   type = "range",
			   disabled = function() return not db.ExpBar.showPercent; end,
			   min = 6,
			   max = 20,
			   step = 1,
			   get = function() return db.ExpBar.PercentFontSize; end,
			   set = function(self, font)
				  db.ExpBar.PercentFontSize = font;
				  SetPercentFont(module.frame);
				  SetPercentFont(module.frame2);
			   end,
			   order = 5,
			},
			PercentFontFlag = {
			   name = "PercentFontFlag",
			   desc = "Choose your font flag!\nDefault: "..LUI.defaults.profile.ExpBar.PercentFontFlag,
			   disabled = function() return not db.ExpBar.showPercent; end,
			   type = "select",
			   values = fontflags,
			   get = function()
				  for k,v in pairs(fontflags) do
					 if (db.ExpBar.PercentFontFlag == v) then
						return k;
					 end
				  end
			   end,
			   set = function(self, FontFlag)
				  db.ExpBar.PercentFontFlag = fontflags[FontFlag];
				  SetPercentFont(module.frame);
				  SetPercentFont(module.frame2);
			   end,
			   order = 6,
			},
			PercentFontColor = {
			   name = "Choose font color",
			   desc = "Choose the color for the percent font.",
			   disabled = function() return not db.ExpBar.showPercent; end,
			   type = "color",
			   width = "full",
			   hasAlpha = true,
			   get = function() return db.ExpBar.PercentFontColors.r, db.ExpBar.PercentFontColors.g, db.ExpBar.PercentFontColors.b, db.ExpBar.PercentFontColors.a end,
			   set = function(_, r, g, b, a)
				  db.ExpBar.PercentFontColors.r = r
				  db.ExpBar.PercentFontColors.g = g
				  db.ExpBar.PercentFontColors.b = b
				  db.ExpBar.PercentFontColors.a = a
				  SetPercentColor(module.frame);
				  SetPercentColor(module.frame2)
			   end,
			   order = 7,
			},
			PercentFontJustify = {
			   name = "Choose Alignment",
			   desc = "Choose the Alignment for your percentage.\nDefault: "..LUI.defaults.profile.ExpBar.PercentFontJustify,
			   disabled = function() return not db.ExpBar.showPercent; end,
			   type = "select",
			   values = chatAlignments,
			   get = function()
				  for k, v in pairs(chatAlignments) do
					 if db.ExpBar.PercentFontJustify == v then
						return k
					 end
				  end
			   end,
			   set = function(self, ChatJustify)
				  db.ExpBar.PercentFontJustify = chatAlignments[ChatJustify]
				  SetPercentJustify(module.frame)
				  SetPercentJustify(module.frame2)
			   end,
			   order = 8,
			},
		 },
	  },
   }
   return options
end
function module:HandleUpdate(t)
   if (t == "percent") then
	  if (db.ExpBar.showPercent) then
		 if module.frame then
		    if (not module.frame.text) then
			   module:CreatePercent();
		    end
		 end
		 if module.frame2 then
		    if (not module.frame2.text) then
			   module:CreatePercent2();
		    end
		 end
	  else
	     if module.frame then
		    if (module.frame.text) then
			   module.frame.text:Hide();
			   module.frame.text = nil;
		    end
		 end
		 if module.frame2 then
		    if (module.frame2.text) then
			   module.frame2.text:Hide();
			   module.frame2.text = nil;
		    end
		 end
	  end
   elseif (t == "visible") then
	  if (db.ExpBar.alwaysShow) then
		 module:SetupVisible();
	  else
		 module:DisableVisible();
	  end
   end
end
function module:LoadModule()
   local module = {
	  ExpBar = {
		 order = LUI:GetModuleCount(),
		 type = "execute",
		 name = function()
			if db.ExpBar.Enable then
			   return "|cff00ff00ExpBar Enabled|r"
			else
			   return "|cffFF0000ExpBar Disabled|r"
			end
		 end,
		 func = function(self, ExpBar)
			db.ExpBar.Enable = not db.ExpBar.Enable
			StaticPopup_Show("RELOAD_UI");
		 end
	  },
   }
   return module;
end
function module:OnInitialize()
   LUI:MergeDefaults(LUI.db.defaults.profile, defaults)
   LUI:RefreshDefaults()
   LUI:Refresh()
   
   self.db = LUI.db
   db = self.db.profile
end

function LUI_ExpBar_Update(self, unit, vmin, vmax)
   if not db.ExpBar.showPercent or unit ~= "player" then
	  return;
   end
   
   if (IsAddOnLoaded("oUF_Experience")) then
	  if (module.frame) then
		 if (module.frame.text) then
			if db.ExpBar.displayMode == 'PERCENT' then
				local prct = math.floor(((vmin/vmax)*100)+.5);
				module.frame.text:SetText(prct.."%");
			elseif db.ExpBar.displayMode == 'BOTH' then
				local prct = math.floor(((vmin/vmax)*100)+.5);
				local txt = vmin .. " / " .. vmax;
				module.frame.text:SetText(prct .. "% - " .. txt);
			else
				module.frame.text:SetText(vmin.." / "..vmax);
			end
		 end
	  end
   end
end
function LUI_RepBar_Update(self, unit, name, nstand, nmin, nmax, nval)
	if not db.ExpBar.showPercent then
		return;
	end
	
	if (IsAddOnLoaded("oUF_Reputation")) then
		if module.frame2 then
			if (module.frame2.text) then
				if nstand == 1 then vstand = "Hated"
				elseif nstand == 2 then vstand = "Hostile"
				elseif nstand == 3 then vstand = "Unfriendly"
				elseif nstand == 4 then vstand = "Neutral"
				elseif nstand == 5 then vstand = "Friendly"
				elseif nstand == 6 then vstand = "Honored"
				elseif nstand == 7 then vstand = "Revered"
				elseif nstand == 8 then vstand = "Exalted"
				else vstand = ""
				end
				vmax = nmax-nmin
				vval = nval-nmin
				if db.ExpBar.displayMode == 'PERCENT' then
					local prct = math.floor(((vval/vmax)*100)+.5);
					module.frame2.text:SetText(prct.."% ("..vstand..")");
				else
					module.frame2.text:SetText(vval.." / "..vmax.." ("..vstand..")");
				end
			end
		end
	end
end

function module:CreatePercent()
	if (module.frame.text) then
		return;
	end
	module.frame.text = module.frame:CreateFontString(nil, "OVERLAY");
	module.frame.text:SetFont(LSM:Fetch("font", db.ExpBar.PercentFont), tonumber(db.ExpBar.PercentFontSize), db.ExpBar.PercentFontFlag);
	module.frame.text:SetJustifyH(db.ExpBar.PercentFontJustify);
	module.frame.text:SetShadowColor(0, 0, 0);
	module.frame.text:SetShadowOffset(1.25, -1.25);
	module.frame.text:SetWidth(module.frame:GetWidth());
	module.frame.text:SetPoint("CENTER", module.frame, "CENTER", 0, 0);
	mmin, mmax = UnitXP("player"), UnitXPMax("player");
	LUI_ExpBar_Update(nil, "player", mmin, mmax);
	module.frame.text:Show();
	module.frame.PostUpdate = LUI_ExpBar_Update;
	SetPercentColor(module.frame);
	SetPercentFont(module.frame);
	SetPercentJustify(module.frame);
end
function module:CreatePercent2()
	module.frame2.text = module.frame2:CreateFontString(nil, "OVERLAY");
	module.frame2.text:SetFont(LSM:Fetch("font", db.ExpBar.PercentFont), tonumber(db.ExpBar.PercentFontSize), db.ExpBar.PercentFontFlag);
	module.frame2.text:SetJustifyH(db.ExpBar.PercentFontJustify);
	module.frame2.text:SetShadowColor(0, 0, 0);
	module.frame2.text:SetShadowOffset(1.25, -1.25);
	module.frame2.text:SetWidth(module.frame2:GetWidth());
	module.frame2.text:SetPoint("CENTER", module.frame2, "CENTER", 0, 0);
	if GetWatchedFactionInfo() == nil then
		nstand, nmin, nmax, nval = "", 0, 1, 0
	else
		_, nstand, nmin, nmax, nval = GetWatchedFactionInfo();
	end
	LUI_RepBar_Update(nil, "player", nil, nstand, nmin, nmax, nval);
	module.frame2.text:Show();
	module.frame2.PostUpdate = LUI_RepBar_Update;
	SetPercentColor(module.frame2);
	SetPercentFont(module.frame2);
	SetPercentJustify(module.frame2);
end
function module:DisableVisible()
	if module.frame then
		module.frame:SetAlpha(0);
		module.frame:SetScript("OnEnter", function() module.frame:SetAlpha(1); end);
		module.frame:SetScript("OnLeave", function() module.frame:SetAlpha(0); end);
	end
	if module.frame2 then
		module.frame2:SetAlpha(0);
		module.frame2:SetScript("OnEnter", function() module.frame:SetAlpha(1); end);
		module.frame2:SetScript("OnLeave", function() module.frame:SetAlpha(0); end);
	end
end
function module:SetupVisible()
	if module.frame then
		module.frame:SetAlpha(1);
		module.frame:SetScript("OnEnter", nil);
		module.frame:SetScript("OnLeave", nil);
	end
	if module.frame2 then
		module.frame2:SetAlpha(1);
		module.frame2:SetScript("OnEnter", nil);
		module.frame2:SetScript("OnLeave", nil);
	end
end
function module:OnEnable()
	LUI:RegisterOptions(self:LoadOptions());
	LUI:RegisterModule(self:LoadModule());
	local loaded1, loaded2 = false, false;
	if IsAddOnLoaded("oUF_Experience") then
		module.frame = _G["oUF_LUI_player_Experience"];
		if (not module.frame) then
			return;
		else
			loaded1 = true;
		end
		if (db.ExpBar.Enable) and (loaded1) then
			if (db.ExpBar.showPercent) then
				module:CreatePercent();
			end
			if (db.ExpBar.alwaysShow) then
				module:SetupVisible();
			end
		end
	end
	if IsAddOnLoaded("oUF_Reputation") then
		module.frame2 = _G["oUF_LUI_player_Reputation"];
		if (not module.frame2) then
			return;
		else
			loaded2 = true;
		end
		if (db.ExpBar.Enable) and (loaded2) then
			if (db.ExpBar.showPercent) then
				module:CreatePercent2();
			end
			if (db.ExpBar.alwaysShow) then
				module:SetupVisible();
			end
		end
	end
	if (not loaded1) and (not loaded2) then
		db.ExpBar.Enable = false;
	end
end
