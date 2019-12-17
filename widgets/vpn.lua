local awful = require("awful")
local watch = awful.widget.watch
local wibox = require("wibox")
local markup = require("lain.util.markup")
local vars = require("vars")
local utils = require("utils")

local getVPNStatus = "ps auxww | sed -n '/openvpn/p' | sed -n 1p"
local disableVPNCmd = "termite -e \"echo 'Enter your Sudo password to disable your VPN\n' && sudo surfshark-vpn down\""
local VPNConnectCmd = "termite -e \"echo 'Enter your Sudo password to enable your VPN\n' && sudo surfshark-vpn multi\""

local vpnWidget = {}

local vpnIcon = wibox.widget.imagebox(vars.icons.vpnOff)

vpnWidget.widget = wibox.widget {
  layout = wibox.layout.align.horizontal,
  utils.iconMargin(vpnIcon),
}

vpnWidget.widget:connect_signal("button::press", function(_,_,_,button)
  if button == 1 then
    vpnWidget:getStatus(function(connected)
      print("CONNECTED?", connected)
      if connected then
        awful.spawn(disableVPNCmd)
      else
        awful.spawn(VPNConnectCmd)
      end
    end)
  end
end)

function vpnWidget:getStatus(callback)
awful.spawn.easy_async_with_shell(getVPNStatus, function(status, stderr)
  print("GOT", status)
  if status:sub(-9) == "sed -n 1p" then
    print("VPN Not connected!")
    callback(0)
  else
    print("VPN connected!")
    callback(1)
  end
  end)
end

function vpnWidget:updateIcon(connected)
  if connected == 1 then
    vpnIcon:set_image(vars.icons.vpnOn)
  else
    vpnIcon:set_image(vars.icons.vpnOff)
  end
end

vpnWidget:getStatus(function(connected) vpnWidget:updateIcon(connected) end)

return vpnWidget
