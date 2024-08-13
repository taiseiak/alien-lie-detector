local Text = require("assets.library.slog-text")
local Push = require("assets.library.push")
local Timer = require("assets.library.timer")

local MouseManager = require('mouse-manager')
local InputManager = require('input-manager')
local ImageManager = require("image-manager")
local SceneManager = require("scene-manager")
local SoundManager = require("sound-manager")

local IntroScene = {}
IntroScene.__index = IntroScene
IntroScene.dialogue = require("scenes.intro-text")

function IntroScene.new()
    local self = {
        dialogue = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.02,
                font = Fonts.sparkly,
                shadow_color = Demichrome_palatte[2],
                adjust_line_height = -2,
                character_sound = true,
                sound_every = 3,
                sound_number = 2,
            }),
        blackOverlayAlpha = { 0 }
    }
    self.dialogue:send(IntroScene.dialogue, G_gameWidth)
    SoundManager:playSound("simpleAlien")
    setmetatable(self, IntroScene)
    return self
end

function IntroScene:reset()
    self.dialogue:send(IntroScene.dialogue, G_gameWidth)
    SoundManager:queueSounds("simpleAlien")
end

function IntroScene:update(dt)
    Timer.update(dt)
    self.dialogue:update(dt)
    if self.dialogue:is_finished() then
        MouseManager:setHover(true)
        if InputManager:released(InputManager.controls.select) then
            MouseManager:setHover(false)
            self.dialogue:continue()
            SoundManager.sounds.selectionSound:play({ pitch = 0.5 })
            if self.dialogue:is_finished() then
                Timer.tween(0.5, self.blackOverlayAlpha, { 1 }, 'linear',
                    function() SceneManager:setScene(SceneManager.scenes.selectTruthOrLie, true) end)
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
    love.graphics.setColor(0, 0, 0, self.blackOverlayAlpha[1])
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

return IntroScene
