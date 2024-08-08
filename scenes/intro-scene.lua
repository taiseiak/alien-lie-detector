local Text = require("assets.library.slog-text")

local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local IntroScene = {}
IntroScene.__index = IntroScene
IntroScene.dialogue = require("intro-text")

function IntroScene.new()
    local self = {
        dialogue = {
            Text.new("center",
                {
                    color = Demichrome_palatte[4],
                    print_speed = 0.1,
                    font = Fonts.sparkly,
                    shadow_color = Demichrome_palatte[2]
                }),
        }
    }
    self.dialogue[1]:send(IntroScene.dialogue, G_gameWidth)
    setmetatable(self, IntroScene)
    return self
end

function IntroScene:reset()
    self.dialogue[1].truth:send(IntroScene.dialogue, G_gameWidth, true)
end

function IntroScene:update(dt)
    for _, box in ipairs(self.selectionBoxes) do
        box:update(dt)
    end
    if self.text:is_finished() then
        MouseManager:setHover(true)
    end
end

function IntroScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    for _, box in ipairs(self.selectionBoxes) do
        box:draw()
    end
end

return IntroScene
