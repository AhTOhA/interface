local pvp = PvPness
local lsm = LibStub("LibSharedMedia-3.0")

local options = {
  name = "PvPness",
  handler = pvp,
  type = 'group',
  args = {
    gui = {
      name = "Options Menu",
      type = 'execute',
      func = function() InterfaceOptionsFrame_OpenToCategory("PvPness") end,
      guiHidden = true,
      order = 1,
    },  
    options = {
      name = "Options",
      desc = "General options for PvPness.",
      type = 'group',
      order = 2,
      args = {
        lock = {
        name = "Lock Frame",
        desc = "Toggle locking of the main PvPness frame.",
        type = 'toggle',
        get = function() return pvp:GetSettings("lock") end,
        set = function(self,value)
               pvp:SetSettings("lock",value)
               pvp:ToggleAnchorMove()
              end,
        order = 1
        },
        hp = {
          name = "Honor Point Threshold",
          desc = "Print a notice when your Honor Point total meets this threshold.",
          type = 'range',
          width = 'full',
          min = 0,
          max = 4000,
          step = 1,
          bigStep = 100,
          get = function() return pvp:GetSettings("hp") end,
          set = function(self,value) pvp:SetSettings("hp",value) end,
          order = 3,
        },       
        cpTotal = {
          name = "Total Conquest Point Threshold",
          desc = "Print a notice when your total Conquest Point total meets this threshold.",
          type = 'range',
          width = 'full',
          min = 0,
          max = 4000,
          step = 1,
          bigStep = 100,
          get = function() return pvp:GetSettings("cp") end,
          set = function(self,value) pvp:SetSettings("cp",value) end,
          order = 5,
        },
        cpWeekly = {
          name = "Weekly Notice",
          desc = "Print a notice for your weekly Conquest Point progess.",
          type = 'toggle',
          get = function() return pvp:GetSettings("cpWeekly") end,
          set = function(self,value) pvp:SetSettings("cpWeekly",value) end,
          order = 7,
        },
      }
    },  
    appearance = {
      name = "Appearance",
      desc = "Adjust the appearance of PvPness.",
      type = 'group',
      order = 3,
      args = {      
        notice = {
          name = "The following options will take effect in the next BG you enter.\n",
          fontSize = 'medium',
          type = 'description',
          width = 'full',
          order = 1,        
        },
        texture = {
          name = "Texture",
          desc = "Select the texture to use for status bars.",
          type = 'select',
          width = 'full',
          dialogControl = "LSM30_Statusbar",
          values = lsm:HashTable('statusbar'),
          get = function() return pvp:GetSettings("textKey") end,
          set = function(self,key)
                 pvp:SetSettings("textKey",key)
                 pvp:SetSettings("texture",lsm:Fetch('statusbar',key))
                end,
          order = 3
        },
        font = {
          name = "Font",
          desc = "Select the font to use for status bars.",
          type = 'select',
          width = 'full',
          dialogControl = "LSM30_Font",
          values = lsm:HashTable('font'),
          get = function() return pvp:GetSettings("fontKey") end,
          set = function(self,key)
                  pvp:SetSettings("fontKey",key)
                  pvp:SetSettings("font",lsm:Fetch('font',key))
                end,
          order = 5
        },
        fontSize = {
          name = "Font Size",
          desc = "Select the font size to use for status bars.",
          type = 'range',
          width = 'full',
          min = 6,
          max = 20,
          step = 1,
          get = function() return pvp:GetSettings("fontSize") end,
          set = function(self,value) pvp:SetSettings("fontSize",value) end,
          order = 7
        },
        titleSize = {
          name = "Title Size",
          desc = "Select the font size to use for the frame title.",
          type = 'range',
          width = 'full',
          min = 10,
          max = 30,
          step = 1,
          get = function() return pvp:GetSettings("titleSize") end,
          set = function(self,value) pvp:SetSettings("titleSize",value) end,
          order = 9,
        }
      }
    }    
  }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("PvPness",options, {"pvpness"})
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PvPness")

--*eof