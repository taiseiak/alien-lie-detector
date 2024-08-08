local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local SelectTruthOrLieScene = {}
SelectTruthOrLieScene.__index = SelectTruthOrLieScene

function SelectTruthOrLieScene.new()
    local self = {
        selectionBoxes = {
            truth = SelectionBox.new(
                75,
                20,
                function() SceneManager:setScene(SceneManager.scenes.selectATruth) end),
            lie = SelectionBox.new(
                75,
                40,
                function() SceneManager:setScene(SceneManager.scenes.selectALie) end)
        }
    }
    self.selectionBoxes.truth:send("Ask for [color=#00ff00]TRUTH[/color=#00ff00]", 70)
    self.selectionBoxes.lie:send("Ask for a [color=#ff0000]LIE[/color=#00ff00]", 70)
    setmetatable(self, SelectTruthOrLieScene)
    return self
end

function SelectTruthOrLieScene:reset()
    self.selectionBoxes.truth:send("Ask for [color=#00ff00]TRUTH[/color=#00ff00]", 70)
    self.selectionBoxes.lie:send("Ask for a [color=#ff0000]LIE[/color=#00ff00]", 70)
end

function SelectTruthOrLieScene:update(dt)
    for _, box in pairs(self.selectionBoxes) do
        box:update(dt)
    end
end

function SelectTruthOrLieScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    for _, box in pairs(self.selectionBoxes) do
        box:draw()
    end
end

return SelectTruthOrLieScene
