local addonName, addon = ...

local AceGUI = LibStub('AceGUI-3.0')

function PVEFrameTab4_OnClick(self)
  -- blindly hide the old tabs (professional, I know)
  local tab1 = _G['GroupFinderFrame']
  local tab2 = _G['PVPUIFrame']
  local tab3 = _G['ChallengesFrame']
  if tab1 then tab1:Hide() end
  if tab2 then tab2:Hide() end
  if tab3 then tab3:Hide() end

  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);

  -- Code to show the tab copied from the original code
  ShowUIPanel(PVEFrame);
  PVEFrame.activeTabIndex = tabIndex
  PanelTemplates_SetTab(PVEFrame, 4)
  PVEFrame:SetWidth(PVE_FRAME_BASE_WIDTH)
  UpdateUIPanelPositions(PVEFrame)
  GuildGroupFinder_FinderFrame:Show()
end

-- Guild finder frame itself
GuildGroupFinder_FinderFrameMixin = {
  playerFrames = {}
}

function GuildGroupFinder_FinderFrameMixin:OnLoad()
  local frame = AceGUI:Create('SimpleGroup')

end

function GuildGroupFinder_FinderFrameMixin:OnShow()
  PVEFrame:SetPortraitToAsset('Interface\\Icons\\achievement_bg_wineos_underxminutes')
  PVEFrame.TitleText:SetText('Guild Finder')
  PVEFrame_HideLeftInset()
  -- GuildGroupFinder_FinderFrame_Update(self);

  self:Update()
end

function GuildGroupFinder_FinderFrameMixin:OnHide()
  PVEFrame_ShowLeftInset()
end

function GuildGroupFinder_FinderFrame_OnValueChanged(self, value)
  GuildGroupFinder_FinderFrame_ScrollToValue(self, value)
end

function GuildGroupFinder_FinderFrame_ScrollToValue(self, value)
  local height = GuildGroupFinder_FinderFrame_ScrollChild:GetHeight() - GuildGroupFinder_FinderFrame_ScrollFrame:GetHeight()
  local offset = height * (value / 1000)
  GuildGroupFinder:Debug('Height; ', height, offset)
  GuildGroupFinder_FinderFrame_ScrollFrame:SetVerticalScroll(offset)
end

function GuildGroupFinder_FinderFrame_OnScroll(self, value)
  local scroll = GuildGroupFinder_FinderFrame_ScrollFrame:GetVerticalScroll()
  local value = scroll + value * 16
  value = math.min(math.max(value, 0), 1000)

  GuildGroupFinder_FinderFrame_Slider:SetValue(value)
end

function GuildGroupFinder_FinderFrameMixin:Update()
  -- Create the most recent list
  -- hide existing list items
  for  index, frame in ipairs(self.playerFrames) do
    frame:Hide()
  end

  -- Build the list of players
  local players = {}
  for i = 1, 10, 1 do
    for player, status in pairs(GuildGroupFinder.player_status) do
        table.insert(players, {
          name = player,
          status = status
        })
    end
  end
  table.sort(players, function(a,b) return a.name < b.name end)

  -- Set up the UI
  local last = nil
  for index, player in ipairs(players) do
    local frame = self.playerFrames[index]
    if frame == nil then
      GuildGroupFinder:Debug('Creating frame for player', index, player.name, player.status)
      frame = CreateFrame('Frame', 'GuildGroupFinder_PlayerFrameTemplate'..index, GuildGroupFinder_FinderFrame_ScrollChild, 'GuildGroupFinder_PlayerFrameTemplate')
      self.playerFrames[index] = frame
    else
      GuildGroupFinder:Debug('Reusing frame for player', index, player.name, player.status)
    end

    frame.player = player.name
    frame.status = player.status
    frame:ClearAllPoints()
    frame:SetSize(50, 50)
    if last == nil then
      frame:SetPoint('TOPLEFT', GuildGroupFinder_FinderFrame_ScrollChild, 'TOPLEFT', 50, -50)
    else
      frame:SetPoint('TOPLEFT', last, 'BOTTOMLEFT', 0, -4)
    end
    frame:Show()
    last = frame
  end
end
