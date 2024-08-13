local Timer = require("assets.library.timer")

local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local FinalQuestionsScene = {}
FinalQuestionsScene.__index = FinalQuestionsScene

function FinalQuestionsScene.new()
    local self = {
        selectionBoxes = {
            real = SelectionBox.new(
                63,
                30,
                function() SceneManager:setScene(SceneManager.scenes.finalSelection) end),
        }
    }

    self.selectionBoxes.real:send("FINAL QUESTIONS", 90)
    Timer.tween(1, G_emotions, {
        lieness = .5,
        nervousness = 0.5,
        anger = 2.0,
    }, 'in-out-quad')
    setmetatable(self, FinalQuestionsScene)
    return self
end

function FinalQuestionsScene:reset()
    Timer.tween(1, G_emotions, {
        lieness = .5,
        nervousness = 0.5,
        anger = 2.0,
    }, 'in-out-quad')
    self.selectionBoxes.real:send("FINAL QUESTIONS", 90)
end

function FinalQuestionsScene:update(dt)
    Timer.update(dt)
    for _, box in pairs(self.selectionBoxes) do
        box:update(dt)
    end
end

function FinalQuestionsScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    for _, box in pairs(self.selectionBoxes) do
        box:draw()
    end
    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return FinalQuestionsScene
