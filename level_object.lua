CollisionType = {
    Kill = 1, PickUp = 2
}

LevelObject = {}

function LevelObject:new(x, y, w, h, colour)
    local o = {
        x = x, y = y, w = w, h = h, colour = colour,
        rot = 0, up = false
    }
    self.__index = self
    return setmetatable(o, self)
end

function LevelObject:update(dt)
    self.rot = wave:getWavePointAngle(self.x)
end

Spike = {}

function Spike:new(x, y)
    local o = LevelObject:new(x, y, 80, 80, { 0.7, 0.7, 0.7 })
    o.collisionType = CollisionType.Kill
    self.__index = self
    return setmetatable(o, self)
end

function Spike:update() end

function Spike:draw()
    love.graphics.setColor(self.colour);
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rot)
    love.graphics.polygon('fill', -self.w / 2, 0, 0, self.h * (self.up and 1 or -1), self.w / 2, 0)
    love.graphics.origin() -- reset transformation
end

Coin = {}

function Coin:new(x, y)
    local o = LevelObject:new(x, y, 30, 30, { 1, 0.8, 0.5 })
    o.collisionType = CollisionType.PickUp
    self.__index = self
    return setmetatable(o, self)
end

function Coin:update()
    self.rot = self.rot + love.timer.getDelta() * 6
end

function Coin:draw()
    love.graphics.setColor(self.colour);
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rot)
    love.graphics.rectangle('fill', -self.w / 2, -self.h / 2, self.w, self.h)
    love.graphics.origin() -- reset transformation
end