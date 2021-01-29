local addonName, addon = ...

GuildGroupFinder = LibStub('AceAddon-3.0'):NewAddon(
  'GuildGroupFinder',
  'AceConsole-3.0',
  'AceComm-3.0',
  'AceSerializer-3.0',
  'AceEvent-3.0',
  'AceHook-3.0'
)
local AceGUI = LibStub('AceGUI-3.0')
addon.GuildGroupFinder = GuildGroupFinder

GuildGroupFinder.COMM_PREFIX = "ggf"
GuildGroupFinder.DEBUG = true

-- init, enable, disable
function GuildGroupFinder:OnInitialize()
  self:InitOptions()
  -- Set up empty player status
  self.player_status = {}
end

function GuildGroupFinder:OnEnable()
  -- Listen for our comms
  self:RegisterComm(self.COMM_PREFIX)

  -- Hack our frame into the PVEFrame
  self:Hook('PVEFrame_ShowFrame', function() GuildGroupFinder_FinderFrame:Hide() end, true)
  PVEFrame.tab4 = GuildGroupFinderTab
  PanelTemplates_SetNumTabs(PVEFrame, 4)
  PVEFrame.maxTabWidth = (PVEFrame:GetWidth() - 19) / 4;

  -- Sync data
  self:ForceFullSync()
end

function GuildGroupFinder:OnDisable()
  -- No reason to undo anything right now
end

-- Utility methods
function GuildGroupFinder:Debug(...)
  if self.DEBUG then
    self:Print(...)
  end
end
