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
    isThisTruth = 'isThisTruth',
    outro = 'outro',
}

function SceneManager:init(scenes)
    self.currentScene = SceneManager.scenes.finalQuestions
    for key, value in pairs(scenes) do
        self[key] = value
    end
    -- self.isThisTruthScene:send("truth")
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
    elseif currentScene == SceneManager.scenes.isThisTruth then
        SceneManager.isThisTruthScene:update(dt)
    elseif currentScene == SceneManager.scenes.outro then
        SceneManager.outroScene:update(dt)
    end
end

function SceneManager:getScene()
    return self.currentScene
end

function SceneManager:fullReset()
    print("fully resetting")
    self.finalSelectionScene:fullReset()
    G_currentTime = love.timer.getTime()
    G_questionsAsked = 0
    G_realQuestionsAsked = 0
    G_answersCorrect = 0
    G_emotions = {
        lieness = 0.5,
        nervousness = 0.1,
        anger = 1.0,
    }
end

function SceneManager:setScene(scene, variables)
    -- print("Scene switched from" .. self.currentScene .. " to " .. scene)
    self.currentScene = scene
    self.variables = variables

    if scene == SceneManager.scenes.intro then
        self.introScene:reset()
    elseif scene == SceneManager.scenes.selectTruthOrLie then
        self.selectTruthOrLieScene:reset()
    elseif scene == SceneManager.scenes.finalQuestions then
        self.finalQuestionScene:reset()
    elseif scene == SceneManager.scenes.finalSelection then
        self.finalSelectionScene:reset()
    elseif scene == SceneManager.scenes.selectATruth then
        self.truthSelectionScene:reset()
    elseif scene == SceneManager.scenes.selectALie then
        self.lieSelectionScene:reset()
    elseif scene == SceneManager.scenes.truthAnswer then
        self.truthAnswerScene:send(variables.query)
    elseif scene == SceneManager.scenes.lieAnswer then
        self.lieAnswerScene:send(variables.query)
    elseif scene == SceneManager.scenes.finalAnswer then
        self.finalAnswerScene:send(variables.query)
    elseif scene == SceneManager.scenes.isThisTruth then
        self.isThisTruthScene:send(variables.answer)
    elseif scene == SceneManager.scenes.outro then
        self.outroScene:reset()
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
    elseif self.currentScene == SceneManager.scenes.isThisTruth then
        SceneManager.isThisTruthScene:draw()
    elseif self.currentScene == SceneManager.scenes.outro then
        SceneManager.outroScene:draw()
    else
        love.graphics.print("Error Empty Scene", 42, G_gameHeight / 2)
    end
end

return SceneManager
