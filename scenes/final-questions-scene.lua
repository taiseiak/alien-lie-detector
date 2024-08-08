local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local FinalQuestionsScene = {}
FinalQuestionsScene.__index = FinalQuestionsScene

function FinalQuestionsScene.new()
    local self = {
        selectionBoxes = {
            truth = SelectionBox.new(
                65,
                15,
                function() SceneManager:setScene(SceneManager.scenes.selectATruth) end),
            lie = SelectionBox.new(
                65,
                30,
                function() SceneManager:setScene(SceneManager.scenes.selectALie) end),
            real = SelectionBox.new(
                65,
                45,
                function() SceneManager:setScene(SceneManager.scenes.finalSelection) end),
        }
    }
    self.selectionBoxes.truth:send("Ask for [color=#00ff00]TRUTH[/color=#00ff00]", 90)
    self.selectionBoxes.lie:send("Ask for a [color=#ff0000]LIE[/color=#ff0000]", 90)
    self.selectionBoxes.real:send("FINAL QUESTIONS", 90)
    setmetatable(self, FinalQuestionsScene)
    return self
end

function FinalQuestionsScene:reset()
    self.selectionBoxes.truth:send("Ask for [color=#00ff00]TRUTH[/color=#00ff00]", 90)
    self.selectionBoxes.lie:send("Ask for a [color=#ff0000]LIE[/color=#ff0000]", 90)
    self.selectionBoxes.real:send("FINAL QUESTIONS", 90)
end

function FinalQuestionsScene:update(dt)
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
end

return FinalQuestionsScene
