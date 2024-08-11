local Text = require("assets.library.slog-text")
local Push = require("assets.library.push")

local MouseManager = require('mouse-manager')
local InputManager = require('input-manager')
local ImageManager = require("image-manager")
local SceneManager = require("scene-manager")

local OutroScene = {}
OutroScene.__index = OutroScene
OutroScene.dialogue = require("scenes.intro-text")

function OutroScene.new()
    local self = {
        dialogue = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.02,
                font = Fonts.sparkly,
                shadow_color = Demichrome_palatte[2],
                adjust_line_height = -2
            })
    }
    setmetatable(self, OutroScene)
    return self
end

function OutroScene:reset()
    local text =
        "You got " ..
        G_answersCorrect ..
        " out of " ..
        G_realQuestionsAsked ..
        " answers correct[waitforinput]\n"
    if G_answersCorrect >= G_realQuestionsAsked then
        text = text ..
            "By figuring out the true intentions of the alien you have [rainbow=5]saved earth[/rainbow][waitforinput]\n" ..
            "[shake=10]Thanks for playing[/shake]"
    else
        text = text ..
            "By not finding the truth [dropshadow=10]inside[/dropshadow] the alien [color=#ff0000]earth is destoryed[/color][waitforinput]\n" ..
            "[shake=10]Click to restart[/shake]"
    end
    self.text = text
    self.dialogue:send(self.text, G_gameWidth)
end

function OutroScene:update(dt)
    self.dialogue:update(dt)
    if self.dialogue:is_finished() then
        MouseManager:setHover(true)
        if InputManager:released(InputManager.controls.select) then
            MouseManager:setHover(false)
            self.dialogue:continue()
            if self.dialogue:is_finished() and G_answersCorrect < G_realQuestionsAsked then
                SceneManager:fullReset()
                SceneManager:setScene(SceneManager.scenes.selectTruthOrLie)
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
end

return OutroScene
