-- Get the libraries we need.
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")

-- Alias some sub-libraries.
local gfs = gears.filesystem
local dpi = xresources.apply_dpi
local sysTheme = xresources.get_current_theme()
local themes_path = gfs.get_themes_dir()
local separators = lain.util.separators
local markup = lain.util.markup

-- Set up our theme's main table.
local theme = {}
theme.name = string.gsub(debug.getinfo(1).short_src, "^(.+\\)[^\\]+$", "%1")
theme.dir = debug.getinfo( 1, "S" ).source:match( "/.*/" )

-- Update the package path so we can easily import our widgets
package.path = theme.dir .. '?.lua;' .. package.path

-- Import our widgets. These are found in {themeDirectory}/widgets.
local utils = require("utils")
local vars = require("vars")
local notificationStyles = require("notification-style")
local batteryWidget = require("widgets.battery")
local netWidget = require("widgets.net")
local clockWidget = require("widgets.clock")
local powerlineBarWidget = require(".widgets.powerline-widgets")
local taglistWidget = require("widgets.taglist")
local volumeWidget = require("widgets.volume")
local brightnessWidget = require("widgets.brightness")
--local systemUpdatesWidget = require("widgets.updates")

-- Other stuff. These are found {themeDirectory}/tools
local healthTools = require("tools.health")

theme.volumeWidget = volumeWidget
theme.brightnessWidget = brightnessWidget

-- typography
theme.font         = vars.mainFont
theme.taglist_font = vars.typography.mainFont

-- colours
theme.bg_normal     = vars.colourPalette[6]
theme.bg_focus      = vars.colourPalette[5]
theme.bg_urgent     = vars.colourPalette[2]
theme.bg_minimize   = vars.colourPalette[1]
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = vars.typographyColours.normal
theme.fg_focus      = vars.typographyColours.light
theme.fg_urgent     = vars.typographyColours.urgent
theme.fg_minimize   = vars.typographyColours.normal

theme.border_width  = dpi(4)
theme.border_normal = vars.colourPalette[6]
theme.border_focus  = vars.colourPalette[5]
theme.border_marked = vars.colourPalette[2]

-- Task list
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true

-- Pretty
theme.useless_gap = vars.windowMargin
theme.wallpaper = vars.wallpaper

-- Add the notification styles.
theme = gears.table.join(theme, notificationStyles)

awful.screen.connect_for_each_screen(function(s)
  -- Create a taglist widget
  s.mytaglist = taglistWidget(s)

  -- This will be the "middle" widget which has
  -- a transparent background so it looks like there
  -- are only actually two bars (there are 3 parts)
  s.mypromptbox = awful.widget.prompt({
    bg_cursor = vars.typographyColours.cursor,
    fg = vars.typographyColours.normal,
    font = vars.typography.mainFont,
  })

  -- Create the wibox
  s.mywibox = awful.wibar({ 
    position = "top", 
    screen = s,
    bg = "00000000"
  })

  -- Add widgets to the wibox
  s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      powerlineBarWidget({ s.mytaglist }, "arrow_right"), -- Left widgets
      wibox.container.margin(s.mypromptbox, 10), -- Centre widget
      powerlineBarWidget({ -- Right widgets
        clockWidget,
        batteryWidget.widget,
        brightnessWidget.widget,
        volumeWidget.widget,
        --systemUpdatesWidget.widget,
        netWidget,
      })
  }

end)

-- These will send small notifications to 
-- remind you to be healthy while working at your computer.
healthTools.waterReminder()
healthTools.walkReminder()

return theme

