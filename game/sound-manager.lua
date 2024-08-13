local Ripple = require("assets.library.ripple")

local SoundManager = {}
SoundManager.__index = SoundManager
SoundManager.controls = {
    select = 'select'
}

function SoundManager:init()
    self.currentSound = nil
    self.nextSound = nil
    self.sounds = {
        simpleAlien = Ripple.newSound(love.audio.newSource('assets/sounds/simple_alien_loop.ogg', 'static'), {
            volume = .2,
            loop = true,
        }),
        alienAbduction = Ripple.newSound(love.audio.newSource('assets/sounds/alien_abduction.ogg', 'static'), {
            volume = .2,
            loop = true,
        }),
        selectionSound = Ripple.newSound(love.audio.newSource('assets/sounds/TN 26.ogg', 'static'), {
            volume = .2,
            loop = false,
        })
    }
    self.queue = {}
end

function SoundManager:playSound(soundKey)
    self.currentSound = self.sounds[soundKey]:play()
end

function SoundManager:queueSound(soundKey)
    if not self.currentSound then
        return
    end
    self.currentSound.loop = false
    self.nextSound = soundKey
end

function SoundManager:update(dt)
    if self.nextSound == nil or not self.currentSound == nil then
        return
    end
    if self.currentSound ~= nil and self.currentSound:isStopped() then
        if self.nextSound ~= nil then
            self.currentSound = self.sounds[self.nextSound]:play()
            self.nextSound = nil
        end
    end
end

return SoundManager
