local addonName, addon = ...

local GuildGroupFinder = LibStub('AceAddon-3.0'):NewAddon(
  'GuildGroupFinder',
  'AceConsole-3.0',
  'AceComm-3.0',
  'AceSerializer-3.0',
  'AceEvent-3.0',
  'AceHook-3.0'
)
local AceGUI = LibStub('AceGUI-3.0')

addon.GuildGroupFinder = GuildGroupFinder

local COMM_PREFIX = "ggf"
local DEBUG = true

-- init, enable, disable
function GuildGroupFinder:OnInitialize()
  local defaults = {
    profile = {
      hpScale = 4000,
      manaScale = 1000
    }
  }
  self.db = LibStub('AceDB-3.0'):New('GuildGroupFinderDB', defaults, true)

  local options = {
    name = 'GuildGroupFinder',
    handler = GuildGroupFinder,
    type = 'group',
    args = {
      profile = {},
      scale = {
        type = 'group',
        name = 'Config',
        args = {
          headerText = {
            type = 'header',
            name = 'There isn\'t any config at the moment',
          },
        }
      }
    }
  }
  options.args.profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)

  LibStub('AceConfig-3.0'):RegisterOptionsTable('GuildGroupFinder', options, {'GuildGroupFinder'})
  LibStub('AceConfigDialog-3.0'):AddToBlizOptions('GuildGroupFinder', nil, nil)
  self:RegisterChatCommand('ggf', 'ShowOptions')

  self:RegisterComm(COMM_PREFIX)

  local msg = self:Serialize('test', {name='lol'})
  self:SendCommMessage(COMM_PREFIX, msg, 'GUILD', nil, 'BULK')

  -- self:RegisterEvent("")
  self:HookScript(PVEFrame, 'OnShow', 'PveShow')
  self:HookScript(PVEFrame, 'OnHide', 'PveHide')
  self:Hook('PVEFrame_ShowFrame', 'OnFrameChange', true)

  PVEFrame.tab4 = GuildGroupFinderTab
  PanelTemplates_SetNumTabs(PVEFrame, 4)
  PVEFrame.maxTabWidth = (PVEFrame:GetWidth() - 19) / 4;
end

function GuildGroupFinder:OnEnable()

end

function GuildGroupFinder:OnDisable()

end

function GuildGroupFinder:PveShow(frame)
  self:Debug('PVE shown')
end

function GuildGroupFinder:PveHide(frame)
  self:Debug('PVE hidden')
end

function GuildGroupFinder:OnFrameChange()
  GuildGroupFinder_FinderFrame:Hide()
end

function GuildGroupFinder:OnCommReceived(prefix, text, distribution, sender)
  self:Debug('Got message '..text..' from '..sender)
  local success, type, body = self:Deserialize(text)
  if success then
    self:Debug(type, body)
  end
end

function GuildGroupFinder:Debug(...)
  if DEBUG then
    self:Print(...)
  end
end

-- Command handlers
function GuildGroupFinder:ShowOptions()
  self:ShowOptionsGUI()
end

-- Option handlers
function GuildGroupFinder:SetHPScale(info, msg)
  if (type(msg) == 'number') then
    self:SetHPScaleRaw(msg)
  else
    self:SetHPScaleRaw(tonumber(msg))
  end
end

function GuildGroupFinder:GetHPScale(info)
  return tostring(self.db.profile.hpScale)
end

-- Set based on params
function GuildGroupFinder:SetHPScaleRaw(scale)
  local maxHP = UnitHealthMax('player')
  self:Print('Max HP: ' .. maxHP .. ' scale ' .. scale .. ' new max hp ' .. (maxHP / scale))
  self.db.profile.hpScale = scale
  fastHPScale = scale
end

function GuildGroupFinder:SetManaScaleRaw(scale)
  local maxMana = UnitPowerMax('player')
  self:Print('Max HP: ' .. maxMana .. ' scale ' .. scale .. ' new max mana ' .. (maxMana / scale))
  self.db.profile.manaScale = scale
  fastManaScale = scale
  end
