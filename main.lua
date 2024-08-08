local Text = require("assets.library.slog-text")
local Push = require("assets.library.push")

local InputManager = require("input-manager")
local MouseManager = require("mouse-manager")
local SceneManager = require("scene-manager")
local ImageManager = require("image-manager")

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

G_gameWidth, G_gameHeight = 160, 90
G_currentTime = 0
G_questionsAsked = 0

-- [Optimizing locals] --
local love = love

-- [Locals] --
local skyShader
local startTime

-- [2bit demichrome Palette](https://lospec.com/palette-list/2bit-demichrome)
Demichrome_palatte = {
    { 0.129, 0.118, 0.125, 1.0 }, -- #211e20
    { 0.333, 0.333, 0.408, 1.0 }, -- #555568
    { 0.627, 0.627, 0.545, 1.0 }, -- #a0a08b
    { 0.914, 0.937, 0.925, 1.0 }  -- #e9efec
}

love.mouse.setVisible(false)


function love.load()
    -- [Set up libraries] --
    Fonts = {
        earth_illusion = love.graphics.newFont("assets/font/earth_illusion.fnt", "assets/font/earth_illusion.png"),
        comic_neue = love.graphics.newFont("assets/font/comic_neue_13.ttf", 10, "mono"),
        another_dimention = love.graphics.newFont("assets/font/SdAnotherDimension.ttf", 9, "mono"),
        sparkly = love.graphics.newFont("assets/font/SparklyFontRegular.ttf", 8, "mono")
    }
    Text.configure.font_table("Fonts")
    ImageManager:init()
    InputManager:init()
    MouseManager:init()
    SceneManager:init({
        introScene = IntroScene.new(),
        selectTruthOrLieScene = SelectTruthOrLieScene:new(),
        truthSelectionScene = TruthSelectionScene.new(),
        lieSelectionScene = LieSelectionScene.new(),
        truthAnswerScene = TruthAnswerScene.new(),
        lieAnswerScene = LieAnswerScene.new(),
        finalQuestionScene = FinalQuestionScene.new(),
        finalSelectionScene = FinalSelectionScene.new(),
        finalAnswerScene = FinalAnswerScene.new()
    })

    startTime = love.timer.getTime()

    -- [Graphics]
    love.graphics.setDefaultFilter('nearest', 'nearest')
    for _, font in pairs(Fonts) do
        font:setFilter('nearest', 'nearest')
    end
    Fonts.sparkly:setFilter('nearest', 'nearest')
    love.graphics.setFont(Fonts.another_dimention)

    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    windowWidth, windowHeight = windowWidth * 0.8, windowHeight * 0.8
    Push:setupScreen(G_gameWidth, G_gameHeight, windowWidth, windowHeight,
        { fullscreen = false, highdpi = true, pixelperfect = false, resizable = true })

    -- [Calculate scaling factors] --
    local scaleX = windowWidth / G_gameWidth
    local scaleY = windowHeight / G_gameHeight

    -- [Calculate borders] --
    local borderWidth = (windowWidth - (G_gameWidth * scaleX)) / 2
    local borderHeight = (windowHeight - (G_gameHeight * scaleY)) / 2

    MouseManager:setBorders(borderWidth, borderHeight)

    Push:setupCanvas({ name = "main" })

    skyShader = love.graphics.newShader("shaders/sky-shader.fs")

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

    -- skyShader:send("time", G_currentTime)
end

function love.draw()
    love.graphics.clear(Demichrome_palatte[1])
    Push:apply("start")
    love.graphics.clear(Demichrome_palatte[1])

    SceneManager:draw()

    -- love.graphics.setShader(skyShader)
    -- love.graphics.draw(ImageManager.images.detectorOutput, 51, 61)
    -- love.graphics.setShader()

    Push:apply("end")
    -- Mouse
    MouseManager:draw()
end
