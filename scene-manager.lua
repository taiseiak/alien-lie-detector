local SceneManager = {}
SceneManager.__index = SceneManager
SceneManager.scenes = {
    intro = 'intro',
    selectTruthOrLie = 'selectTruthOrLie',
    finalQuestions = 'finalQuestions',
    finalSelection = 'finalSelection',
    finalAnswer = 'finalAnswer',
    selectATruth = 'selectATruth',
    selectALie = 'selectALie',
    truthAnswer = 'truthAnswer',
    lieAnswer = 'lieAnswer',
}

function SceneManager:init(scenes)
    self.currentScene = SceneManager.scenes.intro
    for key, value in pairs(scenes) do
        self[key] = value
    end
end

function SceneManager:update(dt)
    local currentScene = self.currentScene
    -- [Scenes] --
    if currentScene == SceneManager.scenes.intro then
        SceneManager.introScene:update(dt)
    elseif currentScene == SceneManager.scenes.selectTruthOrLie then
        SceneManager.selectTruthOrLieScene:update(dt)
    elseif currentScene == SceneManager.scenes.selectATruth then
        SceneManager.truthSelectionScene:update(dt)
    elseif currentScene == SceneManager.scenes.selectALie then
        SceneManager.lieSelectionScene:update(dt)
    elseif currentScene == SceneManager.scenes.truthAnswer then
        SceneManager.truthAnswerScene:update(dt)
    elseif currentScene == SceneManager.scenes.lieAnswer then
        SceneManager.lieAnswerScene:update(dt)
    elseif currentScene == SceneManager.scenes.finalQuestions then
        SceneManager.finalQuestionScene:update(dt)
    elseif currentScene == SceneManager.scenes.finalSelection then
        SceneManager.finalSelectionScene:update(dt)
    elseif currentScene == SceneManager.scenes.finalAnswer then
        SceneManager.finalAnswerScene:update(dt)
    end
end

function SceneManager:getScene()
    return self.currentScene
end

function SceneManager:setScene(scene, variables)
    -- print("Scene switched from" .. self.currentScene .. " to " .. scene)
    self.currentScene = scene
    self.variables = variables

    if scene == SceneManager.scenes.intro then
        self.introScene:reset()
    end

    if scene == SceneManager.scenes.selectTruthOrLie then
        self.selectTruthOrLieScene:reset()
    end

    if scene == SceneManager.scenes.finalQuestions then
        self.finalQuestionScene:reset()
    end

    if scene == SceneManager.scenes.finalSelection then
        self.finalSelectionScene:reset()
    end
    if scene == SceneManager.scenes.selectATruth then
        self.truthSelectionScene:reset()
    end

    if scene == SceneManager.scenes.selectALie then
        self.lieSelectionScene:reset()
    end

    if scene == SceneManager.scenes.truthAnswer then
        self.truthAnswerScene:send(variables.query)
    end

    if scene == SceneManager.scenes.lieAnswer then
        self.lieAnswerScene:send(variables.query)
    end



    if scene == SceneManager.scenes.finalAnswer then
        self.finalAnswerScene:send(variables.query)
    end
end

function SceneManager:draw()
    if self.currentScene == SceneManager.scenes.intro then
        SceneManager.introScene:draw()
    elseif self.currentScene == SceneManager.scenes.selectTruthOrLie then
        SceneManager.selectTruthOrLieScene:draw()
    elseif self.currentScene == SceneManager.scenes.selectATruth then
        SceneManager.truthSelectionScene:draw()
    elseif self.currentScene == SceneManager.scenes.selectALie then
        SceneManager.lieSelectionScene:draw()
    elseif self.currentScene == SceneManager.scenes.truthAnswer then
        SceneManager.truthAnswerScene:draw()
    elseif self.currentScene == SceneManager.scenes.lieAnswer then
        SceneManager.lieAnswerScene:draw()
    elseif self.currentScene == SceneManager.scenes.finalQuestions then
        SceneManager.finalQuestionScene:draw()
    elseif self.currentScene == SceneManager.scenes.finalSelection then
        SceneManager.finalSelectionScene:draw()
    elseif self.currentScene == SceneManager.scenes.finalAnswer then
        SceneManager.finalAnswerScene:draw()
    else
        love.graphics.print("Error Empty Scene", 42, G_gameHeight / 2)
    end
end

return SceneManager
