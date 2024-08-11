local ImageManager = {}
ImageManager.__index = ImageManager

function ImageManager:init(images)
    self.images = {
        alien = love.graphics.newImage("assets/sprites/alien.png"),
        computer = love.graphics.newImage("assets/sprites/computer.png"),
        cursor = love.graphics.newImage("assets/sprites/mouse_sprite.png"),
        hoverCursor = love.graphics.newImage("assets/sprites/hover_mouse_sprite.png"),
        smallTextBox = love.graphics.newImage("assets/sprites/small_text_box.png"),
        bigTextBox = love.graphics.newImage("assets/sprites/big_text_box.png"),
        rightArrow = love.graphics.newImage("assets/sprites/right_arrow.png"),
        conceptSprite = love.graphics.newImage("assets/sprites/concept_sprite.png"),
        dialogueBoxSprite = love.graphics.newImage("assets/sprites/dialogue_box.png"),
        nextMarker = love.graphics.newImage("assets/sprites/next_marker.png"),
        detectorOutput = love.graphics.newImage("assets/sprites/detector_output.png"),
        isThisTruth = love.graphics.newImage("assets/sprites/is_this_truth_lie.png"),
    }
    for _, image in pairs(self.images) do
        image:setFilter('nearest', 'nearest')
    end
end

return ImageManager
