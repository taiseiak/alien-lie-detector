local Text = require("assets.library.slog-text")

local SceneManager = require('scene-manager')
local InputManager = require('input-manager')
local ImageManager = require('image-manager')
local MouseManager = require('mouse-manager')

local FinalAnswerScene = {}
FinalAnswerScene.__index = FinalAnswerScene

function FinalAnswerScene.new()
    local self = {
        text = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.1,
                font = Fonts.comic_neue,
                shadow_color = Demichrome_palatte[2]
            }),
        dialogueBoxSprite = ImageManager.images.dialogueBoxSprite,
        skyShader = love.graphics.newShader("shaders/sky-shader.fs")
    }

    setmetatable(self, FinalAnswerScene)
    return self
end

function FinalAnswerScene:send(query)
    self.query = query
    if query == "Are you peaceful?" then
        self.text:send("[color=#ff0000]. [pause=0.7]. [pause=0.7]. YES.[/color]", 90)
    elseif query == "Do you need our resources?" then
        self.text:send("[color=#ff0000]. [pause=0.7]. [pause=0.7]. NO.[/color]", 90)
    elseif query == "Do you have weapons?" then
        self.text:send("[color=#ff0000]NO.[pause=0.7] WEAPONS.[/color]", 90)
    else
        self.text:send("[shake=1]. [pause=0.7]. [pause=0.7].[/shake]", 90)
    end
end

function FinalAnswerScene:update(dt)
    if not self.query then
        return
    end
    self.skyShader:send("time", G_currentTime)
    self.text:update(dt)
    if self.text:is_finished() then
        MouseManager:setHover(true)
    end
    if self.text:is_finished() and InputManager:released(InputManager.controls.select) then
        MouseManager:setHover(false)
        G_questionsAsked = G_questionsAsked + 1
        SceneManager:setScene(SceneManager.scenes.finalQuestions)
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
        love.graphics.translate(56, 15)
        self.text:draw(0, 0)
        -- love.graphics.rectangle("fill", 0, 0, self.text.get.width, self.text.get.height)
        if self.text:is_finished() then
            love.graphics.draw(ImageManager.images.nextMarker, 88, 23)
        end
    else
        love.graphics.translate(56, 20)
        self.text:draw(0, 0)
        -- love.graphics.rectangle("fill", 0, 0, self.text.get.width, self.text.get.height)
        if self.text:is_finished() then
            love.graphics.draw(ImageManager.images.nextMarker, 88, 18)
        end
    end
    love.graphics.pop()

    love.graphics.setShader(self.skyShader)
    love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    love.graphics.setShader()
end

return FinalAnswerScene
