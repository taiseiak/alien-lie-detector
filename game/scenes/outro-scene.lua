local Text = require("assets.library.slog-text")
local Timer = require("assets.library.timer")

local MouseManager = require('mouse-manager')
local InputManager = require('input-manager')
local ImageManager = require("image-manager")
local SceneManager = require("scene-manager")
local SoundManager = require("sound-manager")

local OutroScene = {}
OutroScene.__index = OutroScene
OutroScene.dialogue = require("scenes.intro-text")

function OutroScene.new()
    local self = {
        blackOverlayAlpha = { 1 },
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
            })
    }
    setmetatable(self, OutroScene)
    return self
end

function OutroScene:reset()
    self.blackOverlayAlpha = { 1 }
    self.dialogue = Text.new("center",
        {
            color = Demichrome_palatte[4],
            print_speed = 0.02,
            font = Fonts.sparkly,
            shadow_color = Demichrome_palatte[2],
            adjust_line_height = -2,
            character_sound = true,
            sound_every = 3,
            sound_number = 2,
        })
    local text =
        "You got " ..
        G_answersCorrect ..
        " out of " ..
        G_realQuestionsAsked ..
        " answers correct[waitforinput]\n"
    if G_answersCorrect >= G_realQuestionsAsked then
        text = text ..
            "By figuring out the true intentions of the alien you have [rainbow=5]saved earth[/rainbow][waitforinput]"
    else
        text = text ..
            "By not finding the truth [dropshadow=10]inside[/dropshadow] the alien [color=#ff0000]earth is destoryed[/color][waitforinput]\n" ..
            "[shake=10]Click to restart[/shake]"
    end
    if SoundManager.currentSound ~= nil then SoundManager.currentSound:pause() end
    self.text = text
    Timer.tween(0.5, self.blackOverlayAlpha, { 0 }, 'linear',
        function() self.dialogue:send(self.text, G_gameWidth) end)
end

function OutroScene:update(dt)
    Timer.update(dt)
    self.dialogue:update(dt)
    if self.dialogue:is_finished() then
        MouseManager:setHover(true)
        if InputManager:released(InputManager.controls.select) then
            MouseManager:setHover(false)
            self.dialogue:continue()
            SoundManager.sounds.selectionSound:play({ pitch = 0.5 })
            if self.dialogue:is_finished() and G_answersCorrect < G_realQuestionsAsked then
                SceneManager:fullReset()
                Timer.tween(0.5, self.blackOverlayAlpha, { 1 }, 'linear',
                    function()
                        SceneManager:setScene(SceneManager.scenes.selectTruthOrLie, true)
                        SoundManager.currentSound:resume()
                    end)
            elseif self.dialogue:is_finished() then
                Timer.tween(0.5, self.blackOverlayAlpha, { 1 }, 'linear',
                    function() SceneManager:setScene(SceneManager.scenes.endScene) end)
            end
        end
    else
        MouseManager:setHover(false)
    end
end

function OutroScene:draw()
    -- love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    love.graphics.push()
    love.graphics.translate(0, 30)
    self.dialogue:draw(0, 0)

    love.graphics.pop()
    if self.dialogue:is_finished() then
        love.graphics.draw(ImageManager.images.nextMarker, G_gameWidth - 6, G_gameHeight - 6)
    end
    love.graphics.setColor(0, 0, 0, self.blackOverlayAlpha[1])
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

return OutroScene
