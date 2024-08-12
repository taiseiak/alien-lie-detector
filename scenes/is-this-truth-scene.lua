local Text = require("assets.library.slog-text")
local Timer = require("assets.library.timer")

local SelectionBox = require('selection-box')
local SceneManager = require('scene-manager')
local ImageManager = require('image-manager')

local IsThisTruthScene = {}
IsThisTruthScene.__index = IsThisTruthScene

function IsThisTruthScene.new()
    local startPointX = (G_gameWidth - ImageManager.images.isThisTruth:getWidth()) / 2
    local startPointY = (G_gameHeight - ImageManager.images.isThisTruth:getHeight()) / 2

    local self = {
        blackOverlayAlpha = { 0 },
        x = startPointX,
        y = startPointY,
        alienTold = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.02,
                font = Fonts.sparkly,
                shadow_color = Demichrome_palatte[2],
                character_sound = true,
                sound_every = 2,
                sound_number = 2,
            }),
        truth = SelectionBox.new(startPointX + 15, startPointY + 35),
        lie = SelectionBox.new(startPointX + 80, startPointY + 35),
    }
    self.alienTold:send("The alien told", ImageManager.images.isThisTruth:getWidth())
    self.truth:send("the [color=#00ff00]TRUTH[/color]", 45, true)
    self.lie:send("a [color=#ff0000]LIE[/color]", 25, true)


    setmetatable(self, IsThisTruthScene)
    return self
end

function IsThisTruthScene:send(answer)
    self.blackOverlayAlpha = { 0 }
    self.answer = answer
    local correctCallback = function()
        G_answersCorrect = G_answersCorrect + 1
        if G_realQuestionsAsked >= 3 then
            Timer.tween(0.5, self.blackOverlayAlpha, { 1 }, 'linear',
                function() SceneManager:setScene(SceneManager.scenes.outro) end)
        else
            SceneManager:setScene(SceneManager.scenes.finalQuestions)
        end
    end
    local incorrectCallback = function()
        if G_realQuestionsAsked >= 3 then
            Timer.tween(0.5, self.blackOverlayAlpha, { 1 }, 'linear',
                function() SceneManager:setScene(SceneManager.scenes.outro) end)
        else
            SceneManager:setScene(SceneManager.scenes.finalQuestions)
        end
    end

    if answer == "truth" then
        self.truth.callback = correctCallback
        self.lie.callback = incorrectCallback
    elseif answer == "lie" then
        self.truth.callback = incorrectCallback
        self.lie.callback = correctCallback
    end
end

function IsThisTruthScene:update(dt)
    Timer.update(dt)
    if not self.answer then
        return
    end
    self.alienTold:update(dt)

    if self.alienTold:is_finished() then
        self.truth:update(dt)
        self.lie:update(dt)
    end
end

function IsThisTruthScene:draw()
    -- Background
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    if not self.answer then
        return
    end
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()

    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.draw(ImageManager.images.isThisTruth, 0, 0)
    self.alienTold:draw(0, 14)
    love.graphics.pop()
    if self.alienTold:is_finished() then
        self.truth:draw()
        self.lie:draw()
    end
    love.graphics.setColor(0, 0, 0, self.blackOverlayAlpha[1])
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

return IsThisTruthScene
