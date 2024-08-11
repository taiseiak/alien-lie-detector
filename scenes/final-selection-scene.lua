local Timer = require("assets.library.timer")

local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local FinalSelectionScene = {}
FinalSelectionScene.__index = FinalSelectionScene

function FinalSelectionScene.new()
    local selection1 = SelectionBox.new(60, 13)
    selection1.callback = function()
        selection1.disabled = true
        SceneManager:setScene(SceneManager.scenes.finalAnswer, { query = "Are you peaceful?" })
    end

    local selection2 = SelectionBox.new(60, 25)
    selection2.callback = function()
        selection2.disabled = true
        SceneManager:setScene(SceneManager.scenes.finalAnswer,
            { query = "Do you need our resources?" })
    end

    local selection3 = SelectionBox.new(60, 47)
    selection3.callback = function()
        selection3.disabled = true
        SceneManager:setScene(SceneManager.scenes.finalAnswer,
            { query = "Do you have weapons?" })
    end

    local self = {
        selectionBoxes = {
            selection1 = selection1,
            selection2 = selection2,
            selection3 = selection3,
        }
    }
    self.selectionBoxes.selection1:send("Are you peaceful?", 100)
    self.selectionBoxes.selection2:send("Do you need our resources?", 100)
    self.selectionBoxes.selection3:send("Do you have weapons?", 100)
    Timer.tween(1, G_emotions, {
        lieness = .5,
        nervousness = 0.7,
        anger = 2.0,
    }, 'in-out-quad')
    setmetatable(self, FinalSelectionScene)
    return self
end

function FinalSelectionScene:fullReset()
    self.selectionBoxes.selection1.disabled = false
    self.selectionBoxes.selection2.disabled = false
    self.selectionBoxes.selection3.disabled = false
    self.selectionBoxes.selection1:send("Are you peaceful?", 100)
    self.selectionBoxes.selection2:send("Do you need our resources?", 100)
    self.selectionBoxes.selection3:send("Do you have weapons?", 100)
    Timer.tween(1, G_emotions, {
        lieness = .5,
        nervousness = 0.7,
        anger = 2.0,
    }, 'in-out-quad')
end

function FinalSelectionScene:reset()
    Timer.tween(1, G_emotions, {
        lieness = .5,
        nervousness = 0.7,
        anger = 2.0,
    }, 'in-out-quad')
    if self.selectionBoxes.selection1.disabled then
        self.selectionBoxes.selection1:send("[color=#555568]Are you peaceful?[/color]", 100)
    else
        self.selectionBoxes.selection1:send("Are you peaceful?", 100)
    end
    if self.selectionBoxes.selection2.disabled then
        self.selectionBoxes.selection2:send("[color=#555568]Do you need our resources?[/color]", 100)
    else
        self.selectionBoxes.selection2:send("Do you need our resources?", 100)
    end
    if self.selectionBoxes.selection3.disabled then
        self.selectionBoxes.selection3:send("[color=#555568]Do you have weapons?[/color]", 100)
    else
        self.selectionBoxes.selection3:send("Do you have weapons?", 100)
    end
end

function FinalSelectionScene:update(dt)
    Timer.update(dt)
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
    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return FinalSelectionScene
