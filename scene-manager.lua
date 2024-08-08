local SceneManager = {}
SceneManager.__index = SceneManager
SceneManager.scenes = {
    intro = 'intro',
    selectTruthOrLie = 'selectTruthOrLie',
    selectATruth = 'selectATruth',
    selectALie = 'selectALie',
    truthAnswer = 'truthAnswer',
    lieAnswer = 'lieAnswer'
}

function SceneManager:init(scenes)
    self.currentScene = 'selectTruthOrLie'
    for key, value in pairs(scenes) do
        self[key] = value
    end
end

function SceneManager:update(dt)
    local currentScene = self.currentScene
    -- [Scenes] --
    if currentScene == SceneManager.scenes.selectTruthOrLie then
        SceneManager.selectTruthOrLieScene:update(dt)
    elseif currentScene == SceneManager.scenes.selectATruth then
        SceneManager.truthSelectionScene:update(dt)
    elseif currentScene == SceneManager.scenes.selectALie then
        SceneManager.lieSelectionScene:update(dt)
    elseif currentScene == SceneManager.scenes.truthAnswer then
        SceneManager.truthAnswerScene:update(dt)
    elseif currentScene == SceneManager.scenes.lieAnswer then
        SceneManager.lieAnswerScene:update(dt)
    end
end

function SceneManager:getScene()
    return self.currentScene
end

function SceneManager:setScene(scene, variables)
    -- print("Scene switched from" .. self.currentScene .. " to " .. scene)
    self.currentScene = scene
    self.variables = variables

    if scene == SceneManager.scenes.selectTruthOrLie then
        self.selectTruthOrLieScene:reset()
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
end

function SceneManager:draw()
    if self.currentScene == SceneManager.scenes.selectTruthOrLie then
        SceneManager.selectTruthOrLieScene:draw()
    elseif self.currentScene == SceneManager.scenes.selectATruth then
        SceneManager.truthSelectionScene:draw()
    elseif self.currentScene == SceneManager.scenes.selectALie then
        SceneManager.lieSelectionScene:draw()
    elseif self.currentScene == SceneManager.scenes.truthAnswer then
        SceneManager.truthAnswerScene:draw()
    elseif self.currentScene == SceneManager.scenes.lieAnswer then
        SceneManager.lieAnswerScene:draw()
    else
        love.graphics.print("Error Empty Scene", 42, G_gameHeight / 2)
    end
end

return SceneManager
