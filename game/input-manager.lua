local Baton = require("assets.library.baton")

local InputManager = {}
InputManager.__index = InputManager
InputManager.controls = {
    select = 'select'
}

function InputManager:init()
    self.input = Baton.new({
        controls = {
            select = { 'mouse:1' }
        }
    })
end

function InputManager:update()
    self.input:update()
end

function InputManager:pressed(control)
    return self.input:pressed(control)
end

function InputManager:released(control)
    return self.input:released(control)
end

return InputManager
