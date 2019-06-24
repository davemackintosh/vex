local wibox = require("wibox")
local lain = require("lain")
local inspect = require("inspect")

local utils = require("utils")

local separators = lain.util.separators
local background = wibox.container.background

local colours = require(".vars").colourPalette

-- Create a power line style bar with automatic
-- colour setting based on X system colours
-- from a table of awesome WM widgets.
-- @param {wibox.widget[]} widgets to add with powerline separators.
-- @param {"arrow_left" | "arrow_right"} direction of the arrows.
function powerlineBarWidget(widgets, direction)
  local normalisedDirection = direction or "arrow_left"
  local arrow = separators[normalisedDirection]

  -- Set up the Wibox layout.
  local bar = {
    layout = wibox.layout.fixed.horizontal,
  }
  
  -- Loop over the widgets
  for index, widget in ipairs(widgets) do
    -- Get the colour for this index in our widget table.
    local colour = colours[index]
    local adjacentColour

    -- If the direction is left, we want to decrease the 
    -- index of the colour. Otherwise, we increase to get the
    -- next colour in the table.
    if normalisedDirection == "arrow_left" then
      adjacentColour = colours[index - 1]
    else
      adjacentColour = colours[index + 1]
    end

    -- Insert the widgets with the appropriate bg/fg colours.
    if normalisedDirection == "arrow_left" then
      if index == 0 then
        table.insert(bar, arrow("alpha", colour))
      else if index > 0 then
          table.insert(bar, arrow(adjacentColour or "alpha", colour))
        end
      end

      table.insert(bar, background(utils.wiBarMargin(widget), colour))
  else
    table.insert(bar, background(utils.wiBarMargin(widget), colour))
    if index ~= #widgets then
      table.insert(bar, arrow(colour, adjacentColour or "alpha"))
    else
      table.insert(bar, arrow(colour, "alpha"))
    end
  end


  end

  return bar
end

return powerlineBarWidget

