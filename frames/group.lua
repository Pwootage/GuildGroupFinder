local addonName, addon = ...

local AceGUI = LibStub('AceGUI-3.0')

function PVEFrameTab4_OnClick(self)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
  GuildGroupFinder:ShowRollUI()
end

function GuildGroupFinder:ShowRollUI()
  local f = AceGUI:Create('Frame')
  f:SetCallback('OnClose',function(widget) AceGUI:Release(widget) end)
  f:SetTitle('Group Roll')
  f:SetStatusText('')
  f:SetLayout('List')

  local btn = AceGUI:Create('Button')
  btn:SetWidth(250)
  btn:SetText('Start registration (/grstart)')
  btn:SetCallback('OnClick', function() GuildGroupFinder:RollStart() end)
  f:AddChild(btn)

  local btn = AceGUI:Create('Button')
  btn:SetWidth(250)
  btn:SetText('Roll (/groll)')
  btn:SetCallback('OnClick', function() GuildGroupFinder:RollEnd() end)
  f:AddChild(btn)


  local btn = AceGUI:Create('Button')
  btn:SetWidth(250)
  btn:SetText('Print current list (/grlist)')
  btn:SetCallback('OnClick', function() GuildGroupFinder:RollList() end)
  f:AddChild(btn)

  local btn = AceGUI:Create('Button')
  btn:SetWidth(250)
  btn:SetText('Clear List (/grclear)')
  btn:SetCallback('OnClick', function() GuildGroupFinder:RollClear() end)
  f:AddChild(btn)

  local addGroup = AceGUI:Create('InlineGroup')
  addGroup:SetLayout('Flow')
  f:AddChild(addGroup)

  local addText = AceGUI:Create('EditBox')
  addText:DisableButton(true)
  addGroup:AddChild(addText)

  local btn = AceGUI:Create('Button')
  btn:SetWidth(250)
  btn:SetText('Add to list (/gradd <a> <b> <c>)')
  btn:SetCallback('OnClick', function() GuildGroupFinder:RollAdd(addText:GetText()) end)
  addGroup:AddChild(btn)

  local removeGroup = AceGUI:Create('InlineGroup')
  removeGroup:SetLayout('Flow')
  f:AddChild(removeGroup)

  local removeText = AceGUI:Create('EditBox')
  removeText:DisableButton(true)
  removeGroup:AddChild(removeText)

  local btn = AceGUI:Create('Button')
  btn:SetWidth(250)
  btn:SetText('Remove list (/grremove <a> <b> <c>)')
  btn:SetCallback('OnClick', function() GuildGroupFinder:RollRemove(removeText:GetText()) end)
  removeGroup:AddChild(btn)
end
