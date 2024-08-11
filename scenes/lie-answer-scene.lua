local Text = require("assets.library.slog-text")
local Timer = require("assets.library.timer")

local SceneManager = require('scene-manager')
local InputManager = require('input-manager')
local ImageManager = require('image-manager')
local MouseManager = require('mouse-manager')

local LieAnswerScene = {}
LieAnswerScene.__index = LieAnswerScene

function LieAnswerScene.new()
    local self = {
        text = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.1,
                font = Fonts.comic_neue,
                shadow_color = Demichrome_palatte[2]
            }),
        dialogueBoxSprite = ImageManager.images.dialogueBoxSprite,
    }

    setmetatable(self, LieAnswerScene)
    return self
end

function LieAnswerScene:send(query)
    self.query = query
    if query == "Are you a fish?" then
        self.text:send("[rainbow=1][shake=5]. [pause=0.7]. [pause=0.7]. YES.[/shake][/rainbow]", 90)
        Timer.tween(1, G_emotions, {
            lieness = .95,
            nervousness = 0.2,
            anger = 1.0,
        }, 'in-out-quad')
    elseif query == "Do you like eggs?" then
        Timer.tween(1, G_emotions, {
            lieness = .7,
            nervousness = 0.4,
            anger = 1.0,
        }, 'in-out-quad')
        self.text:send("[rainbow=1][shake=5]. [pause=0.7]. [pause=0.7]. NO.[/shake][/rainbow]", 90)
    elseif query == "Are you standing?" then
        Timer.tween(1, G_emotions, {
            lieness = .8,
            nervousness = 0.8,
            anger = 2.0,
        }, 'in-out-quad')
        self.text:send("[rainbow=1][shake=5]I AM STANDING.[/shake][/rainbow]", 90)
    else
        self.text:send("[shake=1]. [pause=0.7]. [pause=0.7]. What?[/shake]", 90)
    end
end

function LieAnswerScene:update(dt)
    if not self.query then
        return
    end
    Timer.update(dt)
    self.text:update(dt)
    if self.text:is_finished() then
        MouseManager:setHover(true)
    end
    if self.text:is_finished() and InputManager:released(InputManager.controls.select) then
        MouseManager:setHover(false)
        G_questionsAsked = G_questionsAsked + 1
        if G_questionsAsked >= G_maxQuestions then
            SceneManager:setScene(SceneManager.scenes.finalQuestions)
        else
            SceneManager:setScene(SceneManager.scenes.selectTruthOrLie)
        end
    end
end

function LieAnswerScene:draw()
    if not self.query then
        return
    end
    love.graphics.setColor(1, 1, 1, 1)
    -- Background
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)

    love.graphics.push()
    love.graphics.translate(40, 7)
    love.graphics.draw(self.dialogueBoxSprite, 0, 0)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.translate(56, 20)
    self.text:draw(0, 0)
    -- love.graphics.rectangle("fill", 0, 0, self.text.get.width, self.text.get.height)
    if self.text:is_finished() then
        love.graphics.draw(ImageManager.images.nextMarker, 88, 18)
    end
    love.graphics.pop()

    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return LieAnswerScene
