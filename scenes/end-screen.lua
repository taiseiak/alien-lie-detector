local Text = require("assets.library.slog-text")

local ImageManager = require("image-manager")

local EndScreen = {}
EndScreen.__index = EndScreen
EndScreen.dialogue = require("scenes.intro-text")

function EndScreen.new()
    local self = {
        dialogue = Text.new("center",
            {
                color = Demichrome_palatte[4],
                print_speed = 0.02,
                font = Fonts.comic_neue,
                shadow_color = Demichrome_palatte[2],
            })
    }
    local text =
    "[rainbow=5][shake=2]THANKS FOR PLAYING[/shake][/rainbow]"
    self.text = text
    self.dialogue:send(self.text, 90)
    setmetatable(self, EndScreen)
    return self
end

function EndScreen:reset()
    local text =
    "[rainbow=5][shake=2]THANKS FOR PLAYING[/shake][/rainbow]"
    self.text = text
    self.dialogue:send(self.text, 90)
end

function EndScreen:update(dt)
    G_emotions = {
        lieness = 0.99,
        nervousness = 0.99,
        anger = 7.0,
    }
    self.dialogue:update(dt)
end

function EndScreen:draw()
    love.graphics.setShader(G_shader)
    love.graphics.rectangle("fill", 0, 0, G_gameWidth, G_gameHeight)
    love.graphics.setShader()
    love.graphics.draw(ImageManager.images.endScreen, 0, 0)
    love.graphics.push()
    love.graphics.translate(65, 9)
    self.dialogue:draw(0, 0)
    love.graphics.pop()
end

return EndScreen
