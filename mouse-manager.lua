local Vector = require("assets.library.brinevector")
local Push = require("assets.library.push")

local ImageManager = require("image-manager")

local MouseManager = {}
MouseManager.__index = MouseManager

function MouseManager:init()
    self.vector       = Vector(0, 0)
    local w, h        = love.window.getDesktopDimensions()
    self.scaleFactor  = h * 0.7 / G_gameHeight
    self.hovering     = false
    self.borderWidth  = 0
    self.borderHeight = 0
    love.mouse.setVisible(false)
end

function MouseManager:update()
    local x, y = love.mouse.getPosition()
    x, y = Push:toGame(x + self.borderWidth, y + self.borderHeight)
    if self.vector.x == x and self.vector.y == y then
        return
    end

    if x == nil or y == nil then
        self.vector = Vector(-10, -10)
        return
    end

    self.vector = Vector(x, y)
end

function MouseManager:setHover(value)
    if value ~= self.hovering then
        self.hovering = value
    end
end

function MouseManager:setBorders(width, height)
    self.borderWidth, self.borderHeight = width, height
end

function MouseManager:draw()
    local ox, oy = love.mouse.getPosition()
    local x, y = Push:toGame(ox, oy)
    -- x, y = x + self.borderWidth, y + self.borderHeight
    -- if self.vector.x == -10 and self.vector.y == -10 then
    --     return
    -- end

    -- Mouse
    if self.vector.x and self.vector.y then
        -- love.graphics.draw(self.sprite, math.floor(self.vector.x), math.floor(self.vector.y))
        if self.hovering then
            love.graphics.draw(ImageManager.images.hoverCursor, x, y)
        else
            love.graphics.draw(ImageManager.images.cursor, x, y)
        end
    end
end

return MouseManager
