local pvp = PvPness

local bg = pvp.bg
local pvpBar = pvp.pvpBar
local frames = {}

-- pvpBar:new -----------------------------------------------------------------
function pvpBar:new(id)
  obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj.id = id
  obj.bar = tremove(frames) or CreateFrame("Frame",nil,bg.anchor)
  bg.children[id] = obj
  obj.bar.Finished = obj.bar.Hide
  return obj
end

-- pvpBar:delete --------------------------------------------------------------
function pvpBar:delete()
  self.data = nil
  self.bar.status:SetMinMaxValues(0,1)
  self.bar.status:SetValue(1)
  self.bar.info:SetText("")
  self.bar.name:SetText("")
  self.bar.status:ClearAllPoints()
  self.bar.status:SetStatusBarColor(192/255,192/255,192/255)
  self.bar.status:SetAlpha(.9)
  self.bar:Hide()
  tinsert(frames,self.bar)
end

-- pvpBar:UpdateCountdown -----------------------------------------------------
function pvpBar:UpdateCountdown()
  local currentTime = GetTime()
 
  --self is pvpBar.bar
  if(currentTime < self.endTime) then
    local s = self.endTime - currentTime
    self.status:SetValue(s)
 
    s = floor(s + 0.5)
    local m = ''
    if(s > 59) then
      m = floor(s/60)
      s = s - (m*60)
      m = m..':'
      if(s == 60) then
        m = m..'00'
      elseif(s < 10) then
        m = m..'0'
      end
    end
    self.info:SetText(m..format('%.0f',s))
  else
    self:SetScript("OnUpdate",nil)
    self:Finished()
  end
end

-- pvpBar:Stop ----------------------------------------------------------------
function pvpBar:Stop()
  self.bar.endTime = GetTime()
end

-- pvpBar:SetColor ------------------------------------------------------------
function pvpBar:SetColor(r,g,b)
  self.bar.status:SetStatusBarColor(r,g,b,0.9)
end

-- pvpBar:SetAlpha ------------------------------------------------------------
function pvpBar:SetAlpha(a)
  self.bar.status:SetAlpha(a)
end

-- pvpBar:GetHeight -----------------------------------------------------------
function pvpBar:GetHeight()
  return self.bar:GetHeight()
end

-- pvpBar:Hide ----------------------------------------------------------------
function pvpBar:Hide()
  self.bar:Hide()
end

--pvpBar:Show -----------------------------------------------------------------
function pvpBar:Show()
  self.bar:Show()
end

-- pvpBar:GetPoint ------------------------------------------------------------
function pvpBar:GetPoint()
  return self.bar:GetPoint()
end

-- pvpBar:SetPoint ------------------------------------------------------------
function pvpBar:SetPoint(point,parent,x,y)
  self.bar:SetPoint(point,parent,x,y)
end

--pvpBar:SetTime --------------------------------------------------------------
function pvpBar:SetTime(t)
  self.bar.endTime = GetTime() + t
end

--pvpBar:SetValue -------------------------------------------------------------
function pvpBar:SetValue(v)
  self.bar.status:SetValue(v)
end

--pvpBar:SetMaxValue ----------------------------------------------------------
function pvpBar:SetMaxValue(v)
  self.bar.status:SetMinMaxValues(0,v)
end

--pvpBar:GetValue -------------------------------------------------------------
function pvpBar:GetValue()
  return self.bar.status:GetValue()
end

-- pvpBar:GetMaxValue ---------------------------------------------------------
function pvpBar:GetMaxValue()
  local _,v = self.bar.status:GetMinMaxValues()
  return v
end

-- pvpBar:GetName -------------------------------------------------------------
function pvpBar:GetName()
  return self.bar.name:GetText()
end

-- pvpBar:SetName -------------------------------------------------------------
function pvpBar:SetName(name)
  self.bar.name:SetText(name)
end

--pvpBar:SetInfo --------------------------------------------------------------
function pvpBar:SetInfo(info)
  self.bar.info:SetText(info)
end

-- pvpBar:GetInfo -------------------------------------------------------------
function pvpBar:GetInfo()
  return self.bar.info:GetText()
end

-- pvpBar:Countdown -----------------------------------------------------------
function pvpBar:Countdown(t,set)
  self.bar.status:SetMinMaxValues(0,t)
  self.bar.status:SetValue((set or t))  --create a bar in progress
  self.bar.endTime = GetTime() + (set or t)
  self.bar.info:Show()
  self.bar:SetScript("OnUpdate",self.UpdateCountdown)
end

-- pvpBar:SetFinished ---------------------------------------------------------
function pvpBar:SetFinished(func)
  self.bar.Finished = func
end

-- pvpBar:Finished ------------------------------------------------------------
function pvpBar:Finished()
  self.bar:Finished()
end

-- pvpBar:CreateBar -----------------------------------------------------------
function pvpBar:CreateBar(w,h,buf,offset)

  self.bar:SetFrameStrata("BACKGROUND")
  self.bar:SetWidth(w)
  self.bar:SetHeight(h)
 
  local bg = bg
  if(not offset) then
    offset = 0
    for child in pairs(bg.children) do
      if(child ~= "Start") then --should save buf, call GetOffset or something that returns height+buf to space bars better
        offset = offset - (bg.children[child]:GetHeight() + (buf or 2))
      end
    end
  end
  self.bar:SetPoint("BOTTOM",bg.anchor,0,offset)
 
  --saved settings
  local settings = pvp:GetSettings()
  local texture = settings.texture
  local font = settings.font
  local fontSize = settings.fontSize
  
  if(not self.bar.status) then  
    self.bar.status = CreateFrame("StatusBar", nil, self.bar)
    self.bar.status:SetStatusBarTexture(texture)
    self.bar.status:SetStatusBarColor(192/255,192/255,192/255)
 
    local info = self.bar.status:CreateFontString(nil, "ARTWORK")
	info:SetFont(font,fontSize)
    info:SetTextColor(1,1,1)
    info:SetPoint("LEFT", self.bar, 1, 0)
	info:SetWidth(40)
	info:SetHeight(h)
 
    local name = self.bar.status:CreateFontString(nil, "ARTWORK")
	name:SetFont(font,fontSize)
    name:SetTextColor(1,1,1)
    --name:SetPoint("LEFT", self.bar,43,0)
	name:SetPoint("RIGHT",info,122,0)
	name:SetWidth(w-43) --trunc overly long names... spaces shorter names kinda weird though :|
	name:SetHeight(h)
  
    local background = self.bar:CreateTexture(nil,"BACKGROUND")
	--"Interface\\Addons\\PvPness\\texture\\Flat.tga"
    background:SetTexture(texture)
    background:SetVertexColor(0.5, 0.5, 0.5, 0.33)
    background:SetAllPoints(self.bar.status)
 
    self.bar.info = info
    self.bar.name = name
	self.bar.background = background
	
	self.bar.status:SetMinMaxValues(0,1)
    self.bar.status:SetValue(1)
	self.bar.status:SetAlpha(.9)  
  else --check if settings have changed
    if(self.bar.status:GetStatusBarTexture():GetTexture() ~= texture) then
      --pvp:Print("updating texture")
	  self.bar.status:SetStatusBarTexture(texture)
	  self.bar.background:SetTexture(texture)
	end
	local current,size = self.bar.info:GetFont()
	if(current ~= font or size ~= fontSize) then
	  --pvp:Print("updating font")
	  self.bar.info:SetFont(font,fontSize)
	  self.bar.name:SetFont(font,fontSize)
	end	  
  end
 
  
  self.bar.status:SetAllPoints(self.bar)
 
  self.bar.name:SetText(self.id) --bar name is id by default
  self.bar.info:SetText("") --don't want this to be nil

  self.bar:Hide()
end

-- pvpBar:SetTarget -----------------------------------------------------------
function pvpBar:SetTarget(target)
  local t = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate")
  t:SetAllPoints(self.bar)
  t:SetAttribute("type","macro")
  t:SetAttribute("macrotext","/tar "..target)
  t:Hide()
  return t
end

-- pvpBar:IsRunning -----------------------------------------------------------
function pvpBar:IsRunning()
  if(self:GetInfo() ~= "") then return true else return false end
end

-- pvpBar:SetData -------------------------------------------------------------
function pvpBar:SetData(data)
  self.data = data --misc storage depending on bg
end

-- pvpBar:GetData -------------------------------------------------------------
function pvpBar:GetData()
  return self.data
end

-- pvpBar:SetHealth -----------------------------------------------------------
function pvpBar:SetHealth(health,maxHealth)
  if(not maxHealth) then
    self:SetInfo("??")
    self:SetMaxValue(1)
    self:SetValue(1)
  else
    if(health == 0) then
      self:SetInfo("")
    else
      self:SetInfo(floor( health/maxHealth*100 ).."%")
    end
    self:SetMaxValue(maxHealth)
    self:SetValue(health)
  end
end

--*eof