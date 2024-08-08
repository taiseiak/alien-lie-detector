local Text = require("assets.library.slog-text")
local Push = require("assets.library.push")

local MouseManager = require('mouse-manager')
local InputManager = require('input-manager')
local ImageManager = require("image-manager")
local SceneManager = require("scene-manager")

local IntroScene = {}
IntroScene.__index = IntroScene
IntroScene.dialogue = require("scenes.intro-text")

function IntroScene.new()
    local self = {
        dialogue = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.03,
                font = Fonts.sparkly,
                shadow_color = Demichrome_palatte[2]
            })
    }
    self.dialogue:send(IntroScene.dialogue, G_gameWidth)
    setmetatable(self, IntroScene)
    return self
end

function IntroScene:reset()
    self.dialogue:send(IntroScene.dialogue, G_gameWidth, true)
end

function IntroScene:update(dt)
    self.dialogue:update(dt)
    if self.dialogue:is_finished() then
        MouseManager:setHover(true)
        if InputManager:released(InputManager.controls.select) then
            MouseManager:setHover(false)
            self.dialogue:continue()
            if self.dialogue:is_finished() then
                SceneManager:setScene(SceneManager.scenes.selectTruthOrLie)
            end
        end
    else
        MouseManager:setHover(false)
    end
end

function IntroScene:draw()
    -- love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    local x, y = Push:toReal(0, 0)
    love.graphics.push()
    love.graphics.translate(0, 8)
    self.dialogue:draw(0, 0)

    love.graphics.pop()
    if self.dialogue:is_finished() then
        love.graphics.draw(ImageManager.images.nextMarker, G_gameWidth - 6, G_gameHeight - 6)
    end
end

return IntroScene
