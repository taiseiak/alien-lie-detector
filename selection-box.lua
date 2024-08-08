local Text = require("assets.library.slog-text")

local InputManager = require("input-manager")
local MouseManager = require("mouse-manager")

local SelectionBox = {}
SelectionBox.__index = SelectionBox


function SelectionBox.new(x, y, callback)
    local self = {
        x = x,
        y = y,
        callback = callback,
        hovering = false,
        normalTextBox = Text.new("left",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.02,
                font = Fonts.sparkly,
                shadow_color = Demichrome_palatte[2]
            }),
        hoverTextBox = Text.new("left",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.02,
                font = Fonts.sparkly,
                shadow_color = Demichrome_palatte[2]
            }),
    }
    self.x1, self.y1 = x, y
    self.x2, self.y2 = x + self.normalTextBox.get.width, y + self.normalTextBox.get.height
    setmetatable(self, SelectionBox)
    return self
end

function SelectionBox:send(text, wrap_num, show_all)
    self.normalTextBox:send(text, wrap_num, show_all)
    self.hoverTextBox:send("[dropshadow=10]" .. text .. "[/dropshadow]", wrap_num, show_all)
    self.x2, self.y2 = self.x + self.normalTextBox.get.width, self.y + self.normalTextBox.get.height
end

function SelectionBox:update(dt)
    if MouseManager.vector.x > self.x1
        and MouseManager.vector.x < self.x2
        and MouseManager.vector.y > self.y1 - 14
        and MouseManager.vector.y < self.y2 - 14
    then
        if InputManager:released(InputManager.controls.select) and self.callback then
            MouseManager:setHover(false)
            self.callback()
        else
            self.hovering = true
            MouseManager:setHover(true)
        end
    elseif self.hovering then
        self.hovering = false
        MouseManager:setHover(false)
    end

    self.normalTextBox:update(dt)
    self.hoverTextBox:update(dt)
end

function SelectionBox:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    if self.hovering then
        self.hoverTextBox:draw(0, 0)
    else
        self.normalTextBox:draw(0, 0)
    end
    love.graphics.pop()
end

return SelectionBox
