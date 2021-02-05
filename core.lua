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

GuildGroupFinder.COMM_PREFIX = 'ggf'
GuildGroupFinder.DEBUG = true

-- init, enable, disable
function GuildGroupFinder:OnInitialize()
  self:InitOptions()
  -- Set up empty player status
  self.player_status = {}

  self:RegisterEvent('CHAT_MSG_GUILD', function(evt, msg, author) self:HandleMessage(msg, author) end)
  self:RegisterEvent('CHAT_MSG_WHISPER', function(evt, msg, author) self:HandleMessage(msg, author) end)
  self:RegisterEvent('CHAT_MSG_PARTY', function(evt, msg, author) self:HandleMessage(msg, author) end)
  self:RegisterEvent('CHAT_MSG_PARTY_LEADER', function(evt, msg, author) self:HandleMessage(msg, author) end)


  self:RegisterChatCommand('grclear', 'RollClear')
  self:RegisterChatCommand('grlist', 'RollList')
  self:RegisterChatCommand('grstart', 'RollStart')
  self:RegisterChatCommand('grend', 'RollEnd')
  self:RegisterChatCommand('groll', 'RollEnd')
  self:RegisterChatCommand('gradd', 'RollAdd')
  self:RegisterChatCommand('grdel', 'RollAdd')
  self:RegisterChatCommand('grremove', 'RollRemove')
end

function GuildGroupFinder:OnEnable()
  self.players = {}
  self.currentRoll = {}
  self.rolling = false
end

function GuildGroupFinder:OnDisable()
  -- No reason to undo anything right now
end

function GuildGroupFinder:HandleMessage(msg, author)
  if not self.rolling then
    return
  end
  -- self:Print('Got message', msg, author)
  if msg:find('^1') ~= nil then
    self:RegisterPlayer(author)
    ChatThrottleLib:SendChatMessage(
      'NORMAL', 'ggf',
      'Added you to the roll',
      'WHISPER', nil, player
    )
  elseif msg:find('^0') ~= nil then
    self:UnregisterPlayer(author)
      ChatThrottleLib:SendChatMessage(
      'NORMAL', 'ggf',
      'Removed you from the roll.',
      'WHISPER', nil, player
    )
  end
end

function GuildGroupFinder:RollClear()
  self.players = {}
  self:Print('Clearing the list of players')
end


function GuildGroupFinder:RollStart()
  self.rolling = true
  local message = 'Starting a guild roll. Post a message starting with 1 to join.'
  self:RollList()
  local name, realm = UnitName('player')
  self:RegisterPlayer(name)
  ChatThrottleLib:SendChatMessage(
    'NORMAL', 'ggf',
    'Starting a guild roll. Post a message starting with 1 to join, or 0 to leave if you change your mind.',
    'GUILD', nil, nil
  )
end

function GuildGroupFinder:RollList()
  local message = ''
  local count = 0
  for player, v in pairs(self.players) do
    message = message .. player .. ', '
    count = count + 1
    if (count >= 10) then
      self:Print(message)
      message = ''
    end
  end
  if (message ~= '') then
    self:Print(message)
  end
  self:Print('Currently there are ' .. count .. ' players in the roll')

end

function GuildGroupFinder:RollEnd(input)
  self.rolling = false

  local groupSize = tonumber(input:match('%d+'))
  if (groupSize == nil or groupSize < 2 or groupSize > 10) then
    groupSize = 5
  end

  self:RollList()
  -- make a list table
  local rollList = {}
  local i = 1
  for player, v in pairs(self.players) do
    rollList[i] = player
    i = i + 1
  end
  -- shuffle the list
  for i = 1, #rollList do
    local j = math.random(i)
		rollList[i], rollList[j] = rollList[j], rollList[i]
  end
  -- Print names equal to groupSize
  local message = 'Group:'
  for i = 1, math.min(groupSize, #rollList) do
    message = message .. ' ' .. rollList[i]
  end
  ChatThrottleLib:SendChatMessage(
    'NORMAL', 'ggf',
    message,
    'GUILD', nil, nil
  )
end

function GuildGroupFinder:RegisterPlayer(player)
  local name = player:match('^([^-]+)\\-')
  if name == nil then
    name = player
  end
  self.players[name] = true
  self:Print('Added ' .. name)
end

function GuildGroupFinder:UnregisterPlayer(player)
  local name = player:match('^([^-]+)\\-')
  if name == nil then
    name = player
  end
  self.players[name] = nil
  self:Print('Removed ' .. name)
end

function GuildGroupFinder:RollAdd(input)
  for player in input:gmatch('(%S+)%s*') do
    self:RegisterPlayer(player)
  end
end

function GuildGroupFinder:RollRemove(input)
  for player in input:gmatch('(%S+)%s*') do
    self:UnregisterPlayer(player)
  end
end

-- Utility methods
function GuildGroupFinder:Debug(...)
  if self.DEBUG then
    self:Print(...)
  end
end
