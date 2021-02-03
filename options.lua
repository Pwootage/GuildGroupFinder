function GuildGroupFinder:InitOptions()
  -- load db
  local defaults = {
    -- none as of yet
  }
  self.db = LibStub('AceDB-3.0'):New('GuildGroupFinderDB', defaults, true)

  -- options UI definitions
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
  -- Hook up to db
  options.args.profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
  -- Hook up to UI
  LibStub('AceConfig-3.0'):RegisterOptionsTable('GuildGroupFinder', options, {'GuildGroupFinder'})
  LibStub('AceConfigDialog-3.0'):AddToBlizOptions('GuildGroupFinder', nil, nil)
  -- Register a command to open settings
  self:RegisterChatCommand('ggf', 'ShowOptions')
end

function GuildGroupFinder:ShowOptions()
  self:ShowOptionsGUI()
end

-- Option handlers (examples, for the moment)
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
