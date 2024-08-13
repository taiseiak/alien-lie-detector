local Timer = require("assets.library.timer")

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
    Timer.tween(1, G_emotions, {
        lieness = 0.5,
        nervousness = 0.1,
        anger = 1.0,
    }, 'in-out-quad')
    self.selectionBoxes.selection1:send("Are you a fish?", 90)
    self.selectionBoxes.selection2:send("Do you like eggs?", 90)
    self.selectionBoxes.selection3:send("Are you standing?", 90)
    setmetatable(self, LieSelectionScene)
    return self
end

function LieSelectionScene:reset()
    Timer.tween(1, G_emotions, {
        lieness = 0.5,
        nervousness = 0.1,
        anger = 1.0,
    }, 'in-out-quad')
    self.selectionBoxes.selection1:send("Are you a fish?", 90)
    self.selectionBoxes.selection2:send("Do you like eggs?", 90)
    self.selectionBoxes.selection3:send("Are you standing?", 90)
end

function LieSelectionScene:update(dt)
    Timer.update(dt)
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
    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return LieSelectionScene
