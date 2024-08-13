local Text = require("assets.library.slog-text")
local Timer = require("assets.library.timer")

local SceneManager = require('scene-manager')
local InputManager = require('input-manager')
local ImageManager = require('image-manager')
local MouseManager = require('mouse-manager')
local SoundManager = require('sound-manager')

local FinalAnswerScene = {}
FinalAnswerScene.__index = FinalAnswerScene

function FinalAnswerScene.new()
    local self = {
        text = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.1,
                font = Fonts.another_dimention,
                shadow_color = Demichrome_palatte[2],
                character_sound = true,
                sound_every = 1,
                sound_number = 1,
            }),
        dialogueBoxSprite = ImageManager.images.dialogueBoxSprite,
    }

    setmetatable(self, FinalAnswerScene)
    return self
end

function FinalAnswerScene:send(query)
    self.query = query
    if query == "Are you peaceful?" then
        self.text:send("[warble=1][color=#ff0000]. [pause=0.7]. [pause=0.7]. YES.[/color][/warble]", 90)
        Timer.tween(1, G_emotions, {
            lieness = .2,
            nervousness = 0.99,
            anger = 5.0,
        }, 'in-out-quad')
    elseif query == "Do you need our resources?" then
        Timer.tween(1, G_emotions, {
            lieness = .8,
            nervousness = 0.85,
            anger = 3.0,
        }, 'in-out-quad')
        self.text:send("[warble=1][color=#ff0000]. [pause=0.7]. [pause=0.7]. NO.[/color][/warble]", 90)
    elseif query == "Do you have weapons?" then
        Timer.tween(1, G_emotions, {
            lieness = .3,
            nervousness = 0.95,
            anger = 8.0,
        }, 'in-out-quad')
        self.text:send("[color=#ff0000]NO.[pause=0.7] WEAPONS.[/color]", 90)
    else
        self.text:send("[shake=1]. [pause=0.7]. [pause=0.7].[/shake]", 90)
    end
end

function FinalAnswerScene:update(dt)
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
        G_realQuestionsAsked = G_realQuestionsAsked + 1
        SoundManager.sounds.selectionSound:play({ pitch = 0.5 })
        local answer
        if self.query == "Are you peaceful?" then
            answer = "truth"
        elseif self.query == "Do you need our resources?" then
            answer = "lie"
        elseif self.query == "Do you have weapons?" then
            answer = "truth"
        end
        SceneManager:setScene(SceneManager.scenes.isThisTruth, { answer = answer })
    end
end

function FinalAnswerScene:draw()
    -- Background
    love.graphics.draw(ImageManager.images.conceptSprite, 0, 0)
    if not self.query then
        return
    end
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.push()
    love.graphics.translate(40, 7)
    love.graphics.draw(self.dialogueBoxSprite, 0, 0)
    love.graphics.pop()

    love.graphics.push()
    if self.query == "Are you taking a lie detector?" then
        love.graphics.translate(55, 16)
        self.text:draw(0, 0)
        -- love.graphics.rectangle("fill", 0, 0, self.text.get.width, self.text.get.height)
        if self.text:is_finished() then
            love.graphics.draw(ImageManager.images.nextMarker, 88, 21)
        end
    else
        love.graphics.translate(55, 21)
        self.text:draw(0, 0)
        -- love.graphics.rectangle("fill", 0, 0, self.text.get.width, self.text.get.height)
        if self.text:is_finished() then
            love.graphics.draw(ImageManager.images.nextMarker, 88, 16)
        end
    end
    love.graphics.pop()

    love.graphics.setShader(G_shader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return FinalAnswerScene
