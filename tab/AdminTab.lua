require "tab.AbstractTab"
-------------------------------------------------------------------------------
-- Class to build tab
--
-- @module AdminTab
-- @extends #AbstractTab
--

AdminTab = newclass(AbstractTab)

-------------------------------------------------------------------------------
-- Return button caption
--
-- @function [parent=#AdminTab] getButtonCaption
--
-- @return #string
--
function AdminTab:getButtonCaption()
  return {"helmod_result-panel.tab-button-admin"}
end

-------------------------------------------------------------------------------
-- Get Button Sprites
--
-- @function [parent=#AdminTab] getButtonSprites
--
-- @return boolean
--
function AdminTab:getButtonSprites()
  return "database-white","database"
end

-------------------------------------------------------------------------------
-- Is visible
--
-- @function [parent=#AdminTab] isVisible
--
-- @return boolean
--
function AdminTab:isVisible()
  return Player.isAdmin()
end

-------------------------------------------------------------------------------
-- Is special
--
-- @function [parent=#AdminTab] isSpecial
--
-- @return boolean
--
function AdminTab:isSpecial()
  return true
end

-------------------------------------------------------------------------------
-- Has index model (for Tab panel)
--
-- @function [parent=#AdminTab] hasIndexModel
--
-- @return #boolean
--
function AdminTab:hasIndexModel()
  return false
end

-------------------------------------------------------------------------------
-- Get or create tab panel
--
-- @function [parent=#AdminTab] getTabPane
--
function AdminTab:getTabPane()
  local content_panel = self:getResultPanel()
  local panel_name = "tab_panel"
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[panel_name]
  end
  local panel = GuiElement.add(content_panel, GuiTabPane(panel_name))
  return panel
end

-------------------------------------------------------------------------------
-- Get or create tab panel
--
-- @function [parent=#AdminTab] getTab
--
function AdminTab:getTab(panel_name, caption)
  local content_panel = self:getTabPane()
  local scroll_name = "scroll-" .. panel_name
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[scroll_name]
  end
  local tab_panel = GuiElement.add(content_panel, GuiTab(panel_name):caption(caption))
  local scroll_panel = GuiElement.add(content_panel, GuiScroll(scroll_name):style(helmod_frame_style.scroll_pane):policy(true))
  content_panel.add_tab(tab_panel,scroll_panel)
  scroll_panel.style.horizontally_stretchable = true
  scroll_panel.style.vertically_stretchable = true
  return scroll_panel
end

-------------------------------------------------------------------------------
-- Get or create cache tab panel
--
-- @function [parent=#AdminTab] getCacheTab
--
function AdminTab:getCacheTab()
  return self:getTab("cache-tab-panel", {"helmod_result-panel.cache-list"})
end

-------------------------------------------------------------------------------
-- Get or create rule tab panel
--
-- @function [parent=#AdminTab] getRuleTab
--
function AdminTab:getRuleTab()
  return self:getTab("rule-tab-panel", {"helmod_result-panel.rule-list"})
end

-------------------------------------------------------------------------------
-- Get or create sheet tab panel
--
-- @function [parent=#AdminTab] getSheetTab
--
function AdminTab:getSheetTab()
  return self:getTab("sheet-tab-panel", {"helmod_result-panel.sheet-list"})
end

-------------------------------------------------------------------------------
-- Get or create mods tab panel
--
-- @function [parent=#AdminTab] getModTab
--
function AdminTab:getModTab()
  return self:getTab("mod-tab-panel", {"helmod_common.mod-list"})
end

-------------------------------------------------------------------------------
-- Get or create gui tab panel
--
-- @function [parent=#AdminTab] getGuiTab
--
function AdminTab:getGuiTab()
  return self:getTab("gui-tab-panel", {"helmod_common.gui-list"})
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AdminTab] updateData
--
function AdminTab:updateData()
  self:updateCache()
  self:updateRule()
  self:updateSheet()
  self:updateMod()
  self:updateGui()
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AdminTab] updateGui
--
function AdminTab:updateGui()
  -- Rule List
  local scroll_panel = self:getGuiTab()
  
  local table_panel = GuiElement.add(scroll_panel, GuiTable("list-table"):column(3):style("helmod_table_border"))
  table_panel.vertical_centering = false
  table_panel.style.horizontal_spacing = 5

  self:addCellHeader(table_panel, "location", {"",helmod_tag.font.default_bold, {"helmod_common.location"}, helmod_tag.font.close})
  self:addCellHeader(table_panel, "_name", {"",helmod_tag.font.default_bold, {"helmod_result-panel.col-header-name"}, helmod_tag.font.close})
  self:addCellHeader(table_panel, "mod", {"",helmod_tag.font.default_bold, {"helmod_common.mod"}, helmod_tag.font.close})

  local index = 0
  for _,location in pairs({"top","left","center","screen","goal"}) do
    for _, element in pairs(Player.getGui(location).children) do
      if element.name == "mod_gui_button_flow" or element.name == "mod_gui_frame_flow" then
        for _, element in pairs(element.children) do
          GuiElement.add(table_panel, GuiLabel("location", index):caption(location))
          GuiElement.add(table_panel, GuiLabel("_name", index):caption(element.name))
          GuiElement.add(table_panel, GuiLabel("mod", index):caption(element.get_mod() or "base"))
          index = index + 1
        end
      else
        GuiElement.add(table_panel, GuiLabel("location", index):caption(location))
        GuiElement.add(table_panel, GuiLabel("_name", index):caption(element.name))
        GuiElement.add(table_panel, GuiLabel("mod", index):caption(element.get_mod() or "base"))
        index = index + 1
      end
    end
  end
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AdminTab] updateMod
--
function AdminTab:updateMod()
  -- Rule List
  local scroll_panel = self:getModTab()
  
  local table_panel = GuiElement.add(scroll_panel, GuiTable("list-table"):column(2):style("helmod_table_border"))
  table_panel.vertical_centering = false
  table_panel.style.horizontal_spacing = 50

  self:addCellHeader(table_panel, "_name", {"",helmod_tag.font.default_bold, {"helmod_result-panel.col-header-name"}, helmod_tag.font.close})
  self:addCellHeader(table_panel, "version", {"",helmod_tag.font.default_bold, {"helmod_common.version"}, helmod_tag.font.close})

  for name, version in pairs(game.active_mods) do
    GuiElement.add(table_panel, GuiLabel("_name", name):caption(name))
    GuiElement.add(table_panel, GuiLabel("version", name):caption(version))
  end
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AdminTab] updateCache
--
function AdminTab:updateCache()
  -- Rule List
  local scroll_panel = self:getCacheTab()
  
  GuiElement.add(scroll_panel, GuiLabel("warning"):caption({"", helmod_tag.color.orange, helmod_tag.font.default_large_bold, "Do not use this panel, unless absolutely necessary", helmod_tag.font.close, helmod_tag.color.close}))
  GuiElement.add(scroll_panel, GuiButton(self.classname, "generate-cache"):sprite("menu", "settings-white", "settings"):style("helmod_button_menu_sm_red"):tooltip("Generate missing cache"))
  
  local table_panel = GuiElement.add(scroll_panel, GuiTable("list-table"):column(2))
  table_panel.vertical_centering = false
  table_panel.style.horizontal_spacing = 50

  if Model.countList(Cache.get()) > 0 then
    local translate_panel = GuiElement.add(table_panel, GuiFlowV("global-caches"))
    GuiElement.add(translate_panel, GuiLabel("translate-label"):caption("Global caches"):style("helmod_label_title_frame"))
    local result_table = GuiElement.add(translate_panel, GuiTable("list-data"):column(3))
    self:addCacheListHeader(result_table)
    
    for key1, data1 in pairs(Cache.get()) do
      self:addCacheListRow(result_table, "caches", key1, nil, nil, nil, data1)
      for key2, data2 in pairs(data1) do
        self:addCacheListRow(result_table, "caches", key1, key2, nil, nil, data2)
      end
    end
  end

  local users_data = global["users"]
  if Model.countList(users_data) > 0 then
    local cache_panel = GuiElement.add(table_panel, GuiFlowV("user-caches"))
    GuiElement.add(cache_panel, GuiLabel("translate-label"):caption("User caches"):style("helmod_label_title_frame"))
    local result_table = GuiElement.add(cache_panel, GuiTable("list-data"):column(3))
    self:addCacheListHeader(result_table)
    
    for key1, data1 in pairs(users_data) do
      self:addCacheListRow(result_table, "users", key1, nil, nil, nil, data1)
      for key2, data2 in pairs(data1) do
        self:addCacheListRow(result_table, "users", key1, key2, nil, nil, data2)
        if key2 == "cache" then
          for key3, data3 in pairs(data2) do
            self:addCacheListRow(result_table, "users", key1, key2, key3, nil, data3)
            if string.find(key3, "^HM.*") then
              for key4, data4 in pairs(data3) do
                self:addCacheListRow(result_table, "users", key1, key2, key3, key4, data4)
              end
            end
          end
        end
      end
    end
  end
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AdminTab] updateRule
--
function AdminTab:updateRule()
  -- Rule List
  local scroll_panel = self:getRuleTab()
  local count_rule = #Model.getRules()
  if count_rule > 0 then

    local result_table = GuiElement.add(scroll_panel, GuiTable("list-data"):column(8):style("helmod_table-rule-odd"))

    self:addRuleListHeader(result_table)

    for rule_id, element in spairs(Model.getRules(), function(t,a,b) return t[b].index > t[a].index end) do
      self:addRuleListRow(result_table, element, rule_id)
    end

  end
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AdminTab] updateSheet
--
function AdminTab:updateSheet()
  -- Sheet List
  local scroll_panel = self:getSheetTab()

  local count_model = Model.countModel()
  if count_model > 0 then

    local result_table = GuiElement.add(scroll_panel, GuiTable("list-data"):column(3):style("helmod_table-odd"))

    self:addSheetListHeader(result_table)

    local i = 0
    for _, element in spairs(Model.getModels(true), function(t,a,b) return t[b].owner > t[a].owner end) do
      self:addSheetListRow(result_table, element)
    end

  end
end

-------------------------------------------------------------------------------
-- Add cahce List header
--
-- @function [parent=#AdminTab] addTranslateListHeader
--
-- @param #LuaGuiElement itable container for element
--
function AdminTab:addTranslateListHeader(itable)
  -- col action
  self:addCellHeader(itable, "action", {"helmod_result-panel.col-header-action"})
  -- data
  self:addCellHeader(itable, "header-owner", {"helmod_result-panel.col-header-owner"})
  self:addCellHeader(itable, "header-total", {"helmod_result-panel.col-header-total"})
end

-------------------------------------------------------------------------------
-- Add cahce List header
--
-- @function [parent=#AdminTab] addCacheListHeader
--
-- @param #LuaGuiElement itable container for element
--
function AdminTab:addCacheListHeader(itable)
  -- col action
  self:addCellHeader(itable, "action", {"helmod_result-panel.col-header-action"})
  -- data
  self:addCellHeader(itable, "header-owner", {"helmod_result-panel.col-header-owner"})
  self:addCellHeader(itable, "header-total", {"helmod_result-panel.col-header-total"})
end

-------------------------------------------------------------------------------
-- Add row translate List
--
-- @function [parent=#AdminTab] addTranslateListRow
--
-- @param #LuaGuiElement itable container for element
-- @param #table model
--
function AdminTab:addTranslateListRow(gui_table, user_name, user_data)
  -- col action
  local cell_action = GuiElement.add(gui_table, GuiTable("action", user_name):column(4))

  -- col owner
  GuiElement.add(gui_table, GuiLabel("owner", user_name):caption(user_name))

  -- col translated
  GuiElement.add(gui_table, GuiLabel("total", user_name):caption(Model.countList(user_data.translated)))

end

-------------------------------------------------------------------------------
-- Add row Rule List
--
-- @function [parent=#AdminTab] addCacheListRow
--
-- @param #LuaGuiElement itable container for element
-- @param #string class_name
-- @param #table data
--
function AdminTab:addCacheListRow(gui_table, class_name, key1, key2, key3, key4, data)
  local caption = ""
  if type(data) == "table" then
    caption = Model.countList(data)
  else
    caption = data
  end

  -- col action
  local cell_action = GuiElement.add(gui_table, GuiTable("action", string.format("%s-%s-%s-%s", key1, key2, key3, key4)):column(4))
  if key2 == nil and key3 == nil and key4 == nil then
    if class_name ~= "users" then
      GuiElement.add(cell_action, GuiButton(self.classname, "delete-cache", class_name, key1):sprite("menu", "delete-white-sm", "delete-sm"):style("helmod_button_menu_sm_red"):tooltip({"helmod_button.remove"}))
      GuiElement.add(cell_action, GuiButton(self.classname, "refresh-cache", class_name, key1):sprite("menu", "refresh-white-sm", "refresh-sm"):style("helmod_button_menu_sm_red"):tooltip({"helmod_button.refresh"}))
      -- col class
      GuiElement.add(gui_table, GuiLabel("class", key1):caption({"", helmod_tag.color.orange, helmod_tag.font.default_large_bold, string.format("%s", key1), "[/font]", helmod_tag.color.close}))
    else
      -- col class
      GuiElement.add(gui_table, GuiLabel("class", key1):caption({"", helmod_tag.color.blue, helmod_tag.font.default_large_bold, string.format("%s", key1), "[/font]", helmod_tag.color.close}))
    end
  
    -- col count
    GuiElement.add(gui_table, GuiLabel("total", key1):caption({"", helmod_tag.font.default_semibold, caption, "[/font]"}))
  elseif key3 == nil and key4 == nil then
    if class_name == "users" and (key2 == "translated" or key2 == "cache") then
      GuiElement.add(cell_action, GuiButton(self.classname, "delete-cache", class_name, key1, key2):sprite("menu", "delete-white-sm", "delete-sm"):style("helmod_button_menu_sm_red"):tooltip({"tooltip.remove-element"}))
      -- col class
      GuiElement.add(gui_table, GuiLabel("class", key1, key2):caption({"", helmod_tag.color.orange, helmod_tag.font.default_bold, "|-" , key2, "[/font]", helmod_tag.color.close}))
    else
      -- col class
      GuiElement.add(gui_table, GuiLabel("class", key1, key2):caption({"", helmod_tag.font.default_bold, "|-" , key2, "[/font]"}))
    end
  
    -- col count
    GuiElement.add(gui_table, GuiLabel("total", key1, key2):caption({"", helmod_tag.font.default_semibold, caption, "[/font]"}))
  elseif key4 == nil then
    if class_name == "users" then
      GuiElement.add(cell_action, GuiButton(self.classname, "delete-cache", class_name, key1, key2, key3):sprite("menu", "delete-white-sm", "delete-sm"):style("helmod_button_menu_sm_red"):tooltip({"tooltip.remove-element"}))
      -- col class
      GuiElement.add(gui_table, GuiLabel("class", key1, key2, key3):caption({"", helmod_tag.color.orange, helmod_tag.font.default_bold, "|\t\t\t|-" , key3, "[/font]", helmod_tag.color.close}))
    else
      -- col class
      GuiElement.add(gui_table, GuiLabel("class", key1, key2, key3):caption({"", helmod_tag.font.default_bold, "|-" , key3, "[/font]"}))
    end
  
    -- col count
    GuiElement.add(gui_table, GuiLabel("total", key1, key2, key3):caption({"", helmod_tag.font.default_semibold, caption, "[/font]"}))
  else
    GuiElement.add(gui_table, GuiLabel("class", key1, key2, key3, key4):caption({"", helmod_tag.font.default_bold, "|\t\t\t|\t\t\t|-" , key4, "[/font]"}))
  
    -- col count
    GuiElement.add(gui_table, GuiLabel("total", key1, key2, key3, key4):caption({"", helmod_tag.font.default_semibold, caption, "[/font]"}))
  end

end

-------------------------------------------------------------------------------
-- Add rule List header
--
-- @function [parent=#AdminTab] addRuleListHeader
--
-- @param #LuaGuiElement itable container for element
--
function AdminTab:addRuleListHeader(itable)
  -- col action
  self:addCellHeader(itable, "action", {"helmod_result-panel.col-header-action"})
  -- data
  self:addCellHeader(itable, "header-index", {"helmod_result-panel.col-header-index"})
  self:addCellHeader(itable, "header-mod", {"helmod_result-panel.col-header-mod"})
  self:addCellHeader(itable, "header-name", {"helmod_result-panel.col-header-name"})
  self:addCellHeader(itable, "header-category", {"helmod_result-panel.col-header-category"})
  self:addCellHeader(itable, "header-type", {"helmod_result-panel.col-header-type"})
  self:addCellHeader(itable, "header-value", {"helmod_result-panel.col-header-value"})
  self:addCellHeader(itable, "header-excluded", {"helmod_result-panel.col-header-excluded"})
end

-------------------------------------------------------------------------------
-- Add row Rule List
--
-- @function [parent=#AdminTab] addRuleListRow
--
-- @param #LuaGuiElement itable container for element
-- @param #table model
--
function AdminTab:addRuleListRow(gui_table, rule, rule_id)
  -- col action
  local cell_action = GuiElement.add(gui_table, GuiTable("action", rule_id):column(4))
  GuiElement.add(cell_action, GuiButton(self.classname, "rule-remove", rule_id):sprite("menu", "delete-white-sm", "delete-sm"):style("helmod_button_menu_sm_red"):tooltip({"tooltip.remove-element"}))

  -- col index
  GuiElement.add(gui_table, GuiLabel("index", rule_id):caption(rule.index))

  -- col mod
  GuiElement.add(gui_table, GuiLabel("mod", rule_id):caption(rule.mod))

  -- col name
  GuiElement.add(gui_table, GuiLabel("name", rule_id):caption(rule.name))

  -- col category
  GuiElement.add(gui_table, GuiLabel("category", rule_id):caption(rule.category))

  -- col type
  GuiElement.add(gui_table, GuiLabel("type", rule_id):caption(rule.type))

  -- col value
  GuiElement.add(gui_table, GuiLabel("value", rule_id):caption(rule.value))

  -- col value
  GuiElement.add(gui_table, GuiLabel("excluded", rule_id):caption(rule.excluded))

end

-------------------------------------------------------------------------------
-- Add Sheet List header
--
-- @function [parent=#AdminTab] addSheetListHeader
--
-- @param #LuaGuiElement itable container for element
--
function AdminTab:addSheetListHeader(itable)
  -- col action
  self:addCellHeader(itable, "action", {"helmod_result-panel.col-header-action"})
  -- data owner
  self:addCellHeader(itable, "owner", {"helmod_result-panel.col-header-owner"})
  self:addCellHeader(itable, "element", {"helmod_result-panel.col-header-sheet"})
end

-------------------------------------------------------------------------------
-- Add row Sheet List
--
-- @function [parent=#AdminTab] addSheetListRow
--
-- @param #LuaGuiElement itable container for element
-- @param #table model
--
function AdminTab:addSheetListRow(gui_table, model)
  -- col action
  local cell_action = GuiElement.add(gui_table, GuiTable("action", model.id):column(4))
  if model.share ~= nil and bit32.band(model.share, 1) > 0 then
    GuiElement.add(cell_action, GuiButton(self.classname, "share-model", "read", model.id):style("helmod_button_selected"):caption("R"):tooltip({"tooltip.share-mod", {"helmod_common.reading"}}))
  else
    GuiElement.add(cell_action, GuiButton(self.classname, "share-model", "read", model.id):style("helmod_button_default"):caption("R"):tooltip({"tooltip.share-mod", {"helmod_common.reading"}}))
  end
  if model.share ~= nil and bit32.band(model.share, 2) > 0 then
    GuiElement.add(cell_action, GuiButton(self.classname, "share-model", "write", model.id):style("helmod_button_selected"):caption("W"):tooltip({"tooltip.share-mod", {"helmod_common.writing"}}))
  else
    GuiElement.add(cell_action, GuiButton(self.classname, "share-model", "write", model.id):style("helmod_button_default"):caption("W"):tooltip({"tooltip.share-mod", {"helmod_common.writing"}}))
  end
  if model.share ~= nil and bit32.band(model.share, 4) > 0 then
    GuiElement.add(cell_action, GuiButton(self.classname, "share-model", "delete", model.id):style("helmod_button_selected"):caption("X"):tooltip({"tooltip.share-mod", {"helmod_common.removal"}}))
  else
    GuiElement.add(cell_action, GuiButton(self.classname, "share-model", "delete", model.id):style("helmod_button_default"):caption("X"):tooltip({"tooltip.share-mod", {"helmod_common.removal"}}))
  end

  -- col owner
  local cell_owner = GuiElement.add(gui_table, GuiFrameH("owner", model.id):style(helmod_frame_style.hidden))
  GuiElement.add(cell_owner, GuiLabel(model.id):caption(model.owner or "empty"):style("helmod_label_right_70"))

  -- col element
  local cell_element = GuiElement.add(gui_table, GuiFrameH("element", model.id):style(helmod_frame_style.hidden))
  local element = Model.firstRecipe(model.blocks)
  if element ~= nil then
    GuiElement.add(cell_element, GuiButtonSprite(self.classname, "donothing", model.id):sprite("recipe", element.name):tooltip(RecipePrototype(element):getLocalisedName()))
  else
    GuiElement.add(cell_element, GuiButton(self.classname, "donothing", model.id):sprite("menu", "help-white", "help"):style("helmod_button_menu_selected"))
  end

end
