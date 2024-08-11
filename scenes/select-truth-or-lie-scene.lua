local Timer = require("assets.library.timer")
local Text = require("assets.library.slog-text")


local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local SelectTruthOrLieScene = {}
SelectTruthOrLieScene.__index = SelectTruthOrLieScene

function SelectTruthOrLieScene.new()
    local self = {
        selectionBoxes = {
            questionsLeft = Text.new("center",
                {
                    color = Demichrome_palatte[4],
                    print_speed = 0.02,
                    font = Fonts.sparkly,
                    shadow_color = Demichrome_palatte[2]
                }),
            askAlien = Text.new("center",
                {
                    color = Demichrome_palatte[4],
                    print_speed = 0.02,
                    font = Fonts.sparkly,
                    shadow_color = Demichrome_palatte[2]
                }),
            truth = SelectionBox.new(
                60,
                40,
                function() SceneManager:setScene(SceneManager.scenes.selectATruth) end),
            lie = SelectionBox.new(
                120,
                40,
                function() SceneManager:setScene(SceneManager.scenes.selectALie) end),
        }
    }
    Timer.tween(1, G_emotions, {
        lieness = 0.5,
        nervousness = 0.1,
        anger = 1.0,
    }, 'in-out-quad')
    self.selectionBoxes.questionsLeft:send(
        "[color=#a0a08b]" .. G_maxQuestions - G_questionsAsked .. " questions left[/color]", 100)
    self.selectionBoxes.askAlien:send("Ask the alien to tell", 100)
    self.selectionBoxes.truth:send("the [color=#00ff00]TRUTH[/color=#00ff00]", 45)
    self.selectionBoxes.lie:send("a [color=#ff0000]LIE[/color=#00ff00]", 25)
    setmetatable(self, SelectTruthOrLieScene)
    return self
end

function SelectTruthOrLieScene:reset()
    Timer.tween(1, G_emotions, {
        lieness = 0.5,
        nervousness = 0.1,
        anger = 1.0,
    }, 'in-out-quad')
    if G_maxQuestions - G_questionsAsked > 1 then
        self.selectionBoxes.questionsLeft:send(
            "[color=#a0a08b]" .. G_maxQuestions - G_questionsAsked .. " questions left[/color]", 100)
    elseif G_maxQuestions - G_questionsAsked == 1 then
        self.selectionBoxes.questionsLeft:send(
            "[color=#a0a08b]" .. G_maxQuestions - G_questionsAsked .. " question left[/color]", 100)
    end
    self.selectionBoxes.askAlien:send("Ask the alien to tell", 100)
    self.selectionBoxes.truth:send("the [color=#00ff00]TRUTH[/color=#00ff00]", 45)
    self.selectionBoxes.lie:send("a [color=#ff0000]LIE[/color=#00ff00]", 25)
end

function SelectTruthOrLieScene:update(dt)
    Timer.update(dt)
    for _, box in pairs(self.selectionBoxes) do
        box:update(dt)
    end
end

function SelectTruthOrLieScene:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    love.graphics.push()
    love.graphics.translate(55, 20)
    self.selectionBoxes.questionsLeft:draw(0, -5)
    self.selectionBoxes.askAlien:draw(0, 5)
    love.graphics.pop()
    self.selectionBoxes.truth:draw()
    self.selectionBoxes.lie:draw()
    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return SelectTruthOrLieScene
