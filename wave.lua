Wave = {}

function Wave:new(amp, freq, speed, height)
    local o = {
        offset = 0, speed = speed, amp = amp, freq = freq, height = height
    }
    self.__index = self
    return setmetatable(o, self)
end

function Wave:update(dt)
    wave.offset = wave.offset + love.timer.getDelta() * self.speed
end

function Wave:draw()
    local segments = 30
    local segmentWidth = love.graphics.getWidth() / segments

    for i = 0, segments do
        local segX = i * segmentWidth
        local nextSegX = (i + 1) * segmentWidth
        local segY = love.graphics.getHeight() / 2 + self:getWavePointHeight(segX)
        local nextSegY = love.graphics.getHeight() / 2 + self:getWavePointHeight(nextSegX)

        local topLeft = {
            x = segX, y = segY - self.height / 2
        }
        local bottomRight = {
            x = nextSegX, y = nextSegY + self.height / 2
        }
        local bottomLeft = {
            x = segX, y = segY + self.height / 2
        }
        local topRight = {
            x = nextSegX, y = nextSegY - self.height / 2
        }

        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.polygon('fill', topLeft.x, topLeft.y, bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y)
        love.graphics.polygon('fill', topLeft.x, topLeft.y, topRight.x, topRight.y, bottomRight.x, bottomRight.y)
    end
end

function Wave:getWavePointHeight(x)
    return self.amp * math.sin(self.freq * (x + self.offset));
end

-- get tangent angle by getting the angle between two points on the curve slightly apart
function Wave:getWavePointAngle(x)
    local x1 = x - 1;
    local y1 = self:getWavePointHeight(x1);
    local x2 = x + 1;
    local y2 = self:getWavePointHeight(x2);
    return math.atan((y2 - y1) / (x2 - x1));
end