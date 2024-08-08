local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local FinalSelectionScene = {}
FinalSelectionScene.__index = FinalSelectionScene

function FinalSelectionScene.new()
    local self = {
        selectionBoxes = {
            selection1 = SelectionBox.new(60, 13,
                function() SceneManager:setScene(SceneManager.scenes.finalAnswer, { query = "Are you peaceful?" }) end),
            selection2 = SelectionBox.new(60, 25,
                function()
                    SceneManager:setScene(SceneManager.scenes.finalAnswer,
                        { query = "Do you need our resources?" })
                end),
            selection3 = SelectionBox.new(60, 47,
                function() SceneManager:setScene(SceneManager.scenes.finalAnswer, { query = "Do you have weapons?" }) end),
        }
    }
    self.selectionBoxes.selection1:send("Are you peaceful?", 100)
    self.selectionBoxes.selection2:send("Do you need our resources?", 100)
    self.selectionBoxes.selection3:send("Do you have weapons?", 100)
    setmetatable(self, FinalSelectionScene)
    return self
end

function FinalSelectionScene:reset()
    self.selectionBoxes.selection1:send("Are you peaceful?", 100)
    self.selectionBoxes.selection2:send("Do you need our resources?", 100)
    self.selectionBoxes.selection3:send("Do you have weapons?", 100)
end

function FinalSelectionScene:update(dt)
    for _, box in pairs(self.selectionBoxes) do
        box:update(dt)
    end
end

function FinalSelectionScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- Background
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    for _, box in pairs(self.selectionBoxes) do
        box:draw()
    end
end

return FinalSelectionScene
