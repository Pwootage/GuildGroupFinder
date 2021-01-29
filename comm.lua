local addonName, addon = ...

local MESSAGE_IDS = {
  HELLO = '0',
  STATUS_UPDATE = '1'
}

-- Recieve dispatch
function GuildGroupFinder:OnCommReceived(prefix, text, distribution, sender)
  -- self:Debug('Got message '..text..' from '..sender)
  local success, type, body = self:Deserialize(text)
  if success then
    self:OnCommReceived_Dispatch(sender, type, body)
  else
    self:Debug('Error with message from ', sender, type)
  end
end

function GuildGroupFinder:OnCommReceived_Dispatch(sender, type, body)
  if type == MESSAGE_IDS.HELLO then
    self:RecvComm_Hello(sender, body)
  elseif type == MESSAGE_IDS.STATUS_UPDATE then
    self:RecvComm_StatusUpdate(sender, body)
  end
end

-- Recieve types
function GuildGroupFinder:RecvComm_Hello(sender, body)
  self:Debug('Got HELLO from '..sender..', replying with a STATUS_UPDATE')
  self:UpdatePlayerStatus(sender, body)
  self:SendComm_StatusUpdate(sender, self:GetMyStatus())
end

function GuildGroupFinder:RecvComm_StatusUpdate(sender, body)
  self:Debug('Got status update from '..sender)
  self:UpdatePlayerStatus(sender, body)
end

-- Send
function GuildGroupFinder:SendComm_Hello(body)
  self:Debug('Sending HELLO')
  local msg = self:Serialize(MESSAGE_IDS.HELLO, body)
  self:SendCommMessage(self.COMM_PREFIX, msg, 'GUILD', nil, 'BULK')
end

function GuildGroupFinder:SendComm_StatusUpdate(target, body)
  self:Debug('Sending STATUS_UPDATE to '..target)
  local msg = self:Serialize(MESSAGE_IDS.STATUS_UPDATE, body)
  self:SendCommMessage(self.COMM_PREFIX, msg, 'WHISPER', target, 'BULK')
end
