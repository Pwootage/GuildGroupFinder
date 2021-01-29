function GuildGroupFinder:ForceFullSync()
  -- Clear known data
  self.player_status = {}

  -- Send a hello to guild
  local hello = self:GetMyStatus()
  self:SendComm_Hello(hello)
end

function GuildGroupFinder:UpdatePlayerStatus(player, status)
  self.player_status[player] = status
end

function GuildGroupFinder:GetMyStatus()
  local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
  local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
  local ilvl, ilvlEquipped = GetAverageItemLevel()

  return {
    map = keystoneMapID,
    level = keystoneLevel,
    ilvl = ilvlEquipped
  }
end
