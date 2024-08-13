local Text = require("assets.library.slog-text")
local Push = require("assets.library.push")

local InputManager = require("input-manager")
local MouseManager = require("mouse-manager")
local SceneManager = require("scene-manager")
local ImageManager = require("image-manager")
local SoundManager = require("sound-manager")

-- [Scenes] --
local IntroScene = require('scenes.intro-scene')
local SelectTruthOrLieScene = require("scenes.select-truth-or-lie-scene")
local TruthSelectionScene = require("scenes.truth-selection-scene")
local LieSelectionScene = require("scenes.lie-selection-scene")
local TruthAnswerScene = require("scenes.truth-answer-scene")
local LieAnswerScene = require("scenes.lie-answer-scene")
local FinalQuestionScene = require("scenes.final-questions-scene")
local FinalSelectionScene = require("scenes.final-selection-scene")
local FinalAnswerScene = require("scenes.final-answers-scene")
local IsThisTruthScene = require("scenes.is-this-truth-scene")
local OutroScene = require("scenes.outro-scene")
local EndScene = require("scenes.end-screen")

G_gameWidth, G_gameHeight = 160, 90
G_currentTime = 0
G_questionsAsked = 0
G_maxQuestions = 4
G_realQuestionsAsked = 0
G_answersCorrect = 0
G_shader = nil
G_emotions = {
    lieness = 0.5,
    nervousness = 0.1,
    anger = 1.0,
}

-- [Optimizing locals] --
local love = love

-- [Locals] --
local startTime

-- [2bit demichrome Palette](https://lospec.com/palette-list/2bit-demichrome)
Demichrome_palatte = {
    { 0.129, 0.118, 0.125, 1.0 }, -- #211e20
    { 0.333, 0.333, 0.408, 1.0 }, -- #555568
    { 0.627, 0.627, 0.545, 1.0 }, -- #a0a08b
    { 0.914, 0.937, 0.925, 1.0 }  -- #e9efec
}

Audio = {
    text = {
        defaultAlien = love.audio.newSource("assets/sounds/TN 39.ogg", "static"),
        ch20 = love.audio.newSource("assets/sounds/CH 20.ogg", "static"),
    }
}

love.mouse.setVisible(false)


function love.load()
    -- [Set up libraries] --
    Fonts = {
        another_dimention = love.graphics.newFont("assets/font/SdAnotherDimension.ttf", 9, "mono"),
        sparkly = love.graphics.newFont("assets/font/SparklyFontRegular.ttf", 8, "mono")
    }
    Text.configure.font_table("Fonts")
    Text.configure.add_text_sound(Audio.text.defaultAlien, 0.2)
    Text.configure.add_text_sound(Audio.text.ch20, 0.2)
    ImageManager:init()
    InputManager:init()
    MouseManager:init()
    SoundManager:init()
    SceneManager:init({
        introScene = IntroScene.new(),
        selectTruthOrLieScene = SelectTruthOrLieScene:new(),
        truthSelectionScene = TruthSelectionScene.new(),
        lieSelectionScene = LieSelectionScene.new(),
        truthAnswerScene = TruthAnswerScene.new(),
        lieAnswerScene = LieAnswerScene.new(),
        finalQuestionScene = FinalQuestionScene.new(),
        finalSelectionScene = FinalSelectionScene.new(),
        finalAnswerScene = FinalAnswerScene.new(),
        isThisTruthScene = IsThisTruthScene.new(),
        outroScene = OutroScene.new(),
        endScene = EndScene.new()
    })

    G_shader = love.graphics.newShader("shaders/lie-shader.fs")
    G_emotions = {
        lieness = 0.5,
        nervousness = 0.1,
        anger = 1.0,
    }

    startTime = love.timer.getTime()

    -- [Graphics]
    love.graphics.setDefaultFilter('nearest', 'nearest')
    for _, font in pairs(Fonts) do
        font:setFilter('nearest', 'nearest')
    end
    Fonts.sparkly:setFilter('nearest', 'nearest')

    local windowWidth, windowHeight = 160 * 5, 90 * 5
    Push:setupScreen(G_gameWidth, G_gameHeight, windowWidth, windowHeight,
        { fullscreen = false, highdpi = true, pixelperfect = false, resizable = false })

    -- [Calculate scaling factors] --
    local scaleX = windowWidth / G_gameWidth
    local scaleY = windowHeight / G_gameHeight

    -- [Calculate borders] --
    local borderWidth = (windowWidth - (G_gameWidth * scaleX)) / 2
    local borderHeight = (windowHeight - (G_gameHeight * scaleY)) / 2

    MouseManager:setBorders(borderWidth, borderHeight)

    Push:setupCanvas({ name = "main" })


    -- SceneManager:setScene(SceneManager.scenes.truthAnswer, { query = "Are you an alien?" })
end

function love.resize(w, h)
    return Push:resize(w, h)
end

function love.update(dt)
    G_currentTime = love.timer.getTime() - startTime

    -- [Inputs] --
    InputManager:update()
    MouseManager:update()
    SceneManager:update(dt)
    SoundManager:update(dt)

    G_shader:send("time", G_currentTime)
    G_shader:send("lieness", G_emotions.lieness)
    G_shader:send("nervousness", G_emotions.nervousness)
    G_shader:send("anger", G_emotions.anger)

    -- skyShader:send("time", G_currentTime)
end

function love.draw()
    love.graphics.clear(Demichrome_palatte[1])
    Push:apply("start")
    love.graphics.clear(Demichrome_palatte[1])

    SceneManager:draw()

    MouseManager:draw()
    Push:apply("end")
    -- Mouse
end
