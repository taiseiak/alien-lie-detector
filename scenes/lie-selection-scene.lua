local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local LieSelectionScene = {}
LieSelectionScene.__index = LieSelectionScene

function LieSelectionScene.new()
    local self = {
        selectionBoxes = {
            selection1 = SelectionBox.new(65, 15,
                function() SceneManager:setScene(SceneManager.scenes.lieAnswer, { query = "Are you a fish?" }) end),
            selection2 = SelectionBox.new(65, 30,
                function() SceneManager:setScene(SceneManager.scenes.lieAnswer, { query = "Do you like eggs?" }) end),
            selection3 = SelectionBox.new(65, 45,
                function() SceneManager:setScene(SceneManager.scenes.lieAnswer, { query = "Are you standing?" }) end),
        }
    }
    self.selectionBoxes.selection1:send("Are you a fish?", 90)
    self.selectionBoxes.selection2:send("Do you like eggs?", 90)
    self.selectionBoxes.selection3:send("Are you standing?", 90)
    setmetatable(self, LieSelectionScene)
    return self
end

function LieSelectionScene:reset()
    self.selectionBoxes.selection1:send("Are you a fish?", 90)
    self.selectionBoxes.selection2:send("Do you like eggs?", 90)
    self.selectionBoxes.selection3:send("Are you standing?", 90)
end

function LieSelectionScene:update(dt)
    for _, box in pairs(self.selectionBoxes) do
        box:update(dt)
    end
end

function LieSelectionScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- Background
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    for _, box in pairs(self.selectionBoxes) do
        box:draw()
    end
end

return LieSelectionScene
