local addonName, addon = ...

function GuildGroupFinderTab_OnClick(self)
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


function GuildGroupFinder_FinderFrame_OnShow(self)
  PVEFrame:SetPortraitToAsset('Interface\\Icons\\achievement_bg_wineos_underxminutes')
  PVEFrame.TitleText:SetText('Guild Finder')
  PVEFrame_HideLeftInset()
  -- GuildGroupFinder_FinderFrame_Update(self);
end

function GuildGroupFinder_FinderFrame_OnHide(self)
  PVEFrame_ShowLeftInset()
end
