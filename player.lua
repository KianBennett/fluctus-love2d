require('level_object')

Player = {}

function Player:new(x, y)
    local o = LevelObject:new(x, y, 50, 50, { 0.72, 1, 1, 1 })
    o.isFlipping = false
    o.rotOffset = 0
    self.__index = self
    return setmetatable(o, self)
end

function Player:update(dt)
    local initY = love.graphics.getHeight() / 2 + wave:getWavePointHeight(self.x)
    local targetY = initY + (wave.height / 2 - self.h / 2) * (self.up and -1 or 1)
    local flipSpeed = 1100;
    if self.isFlipping then
        if self.up then
            self.y = self.y - dt * flipSpeed;
            if self.y <= targetY then
                self.isFlipping = false;
                self.y = targetY;
            end
        else
            self.y = self.y + dt * flipSpeed;
            if self.y >= targetY then
                self.isFlipping = false;
                self.y = targetY;
            end
        end

        local dist = self.y - initY;
        self.rotOffset = math.rad(dist / (wave.height / 2 - self.h / 2) * 90)
        -- math.rad(self.rot) -- convert to radians
    else
        self.y = targetY;
        self.rotOffset = 0;
    end

    self.rot = wave:getWavePointAngle(self.x)
end

function Player:draw()
    love.graphics.setColor(self.colour);
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rot + self.rotOffset)
    love.graphics.rectangle('fill', -self.w / 2, -self.h / 2, self.w, self.h)
    love.graphics.origin() -- reset transformation
end

function Player:flip()
    if self.isFlipping then return end
    self.up = not self.up
    self.isFlipping = true
end

function Player:isColliding(other)
    return (self.x + self.w / 2) > (other.x - other.w / 2) and (self.x - self.w / 2) < (other.x + other.w / 2) and
        (self.y + self.h / 2 > other.y - other.h / 2) and (self.y - self.h / 2 < other.y + other.h / 2)
end