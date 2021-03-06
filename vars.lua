local xresources = require("beautiful.xresources")
local thisDir = debug.getinfo( 1, "S" ).source:match( "/.*/" )
local iconBase = thisDir .. "icons/"
local sysTheme = xresources.get_current_theme()
local inspect = require("inspect")
local vars = {}

-- vars.wallpaper = "~/Downloads/white-wallpaper.jpeg"
vars.wallpaper = "#2e3440"

vars.windowMargin = 14

-- Used throughout the theme.
vars.themeRoot = thisDir

-- Colours used throughout the theme.
vars.colourPalette = {}

-- Update the colour pallette to the system resources.
-- These colours come from $HOME/.Xdefaults or $HOME/.Xresources
for colourIndex=0,15 do
  vars.colourPalette[colourIndex + 1] = sysTheme["color" .. colourIndex]
end

table.insert(vars.colourPalette, sysTheme.background)
table.insert(vars.colourPalette, sysTheme.foreground)
  
-- Lets set up the typography for the theme.
vars.typography = {}

-- Primary font face.
vars.typography.mainFontFamily = "Iosevka"
vars.mainFont = vars.typography.mainFontFamily .. " 11"

-- Secondary font face.
vars.typography.secondaryFontFamily = "Overpass"
vars.typography.secondaryFont = vars.typography.secondaryFontFamily .. " 11"

-- Text colours.
vars.typographyColours = {
  normal = "#1d1f21",
  light = vars.colourPalette[1],
  bright = vars.colourPalette[#vars.colourPalette],
  unfocused = vars.colourPalette[2],
  urgent = vars.colourPalette[1],
  cursor = "#DA70D6",
}

vars.icons = {
  vpnOn = iconBase .. "lock-24px.svg",
  vpnOff = iconBase .. "lock_open-24px.svg",
  batteryFull = iconBase .. "baseline-battery_full-24px.svg",
  battery20 = iconBase .. "baseline-battery_20-24px.svg",
  battery50 = iconBase .. "baseline-battery_50-24px.svg",
  battery90 = iconBase .. "baseline-battery_90-24px.svg",
  batteryCharging = iconBase .. "baseline-battery_charging_full-24px.svg",
  brightness = iconBase .. "baseline-brightness_high-24px.svg",
  wifiWeak = iconBase .. "baseline-signal_wifi_0_bar-24px.svg",
  wifiMid = iconBase .. "baseline-signal_wifi_2_bar-24px.svg",
  wifiGood = iconBase .. "baseline-signal_wifi_4_bar-24px.svg",
  wifiOff = iconBase .. "baseline-signal_wifi_off-24px.svg",
  volumeOn = iconBase .. "baseline-volume_up-24px.svg",
  volumeOff = iconBase .. "baseline-volume_off-24px.svg",
  ethernetConnected = iconBase .. "ethernet-cable.svg",
  systemUpdates = iconBase .. "baseline-update-24px.svg"
}

return vars

