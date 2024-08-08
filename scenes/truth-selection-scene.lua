local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')


local TruthSelectionScene = {}
TruthSelectionScene.__index = TruthSelectionScene

function TruthSelectionScene.new()
    local self = {
        selectionBoxes = {
            selection1 = SelectionBox.new(65, 13,
                function() SceneManager:setScene(SceneManager.scenes.truthAnswer, { query = "Are you an alien?" }) end),
            selection2 = SelectionBox.new(65, 25,
                function()
                    SceneManager:setScene(SceneManager.scenes.truthAnswer,
                        { query = "Are you taking a lie detector?" })
                end),
            selection3 = SelectionBox.new(65, 47,
                function() SceneManager:setScene(SceneManager.scenes.truthAnswer, { query = "Are you having fun?" }) end),
        }
    }
    self.selectionBoxes.selection1:send("Are you an alien?", 90)
    self.selectionBoxes.selection2:send("[textspeed=0.01]Are you taking a lie detector?[/textspeed]", 90)
    self.selectionBoxes.selection3:send("Are you having fun?", 90)
    setmetatable(self, TruthSelectionScene)
    return self
end

function TruthSelectionScene:reset()
    self.selectionBoxes.selection1:send("Are you an alien?", 90)
    self.selectionBoxes.selection2:send("[textspeed=0.01]Are you taking a lie detector?[/textspeed]", 90)
    self.selectionBoxes.selection3:send("Are you having fun?", 90)
end

function TruthSelectionScene:update(dt)
    for _, box in pairs(self.selectionBoxes) do
        box:update(dt)
    end
end

function TruthSelectionScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- Background
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)

    for _, box in pairs(self.selectionBoxes) do
        box:draw()
    end
end

return TruthSelectionScene
