require('level_object')

Level = {}

function Level:new()
    local o = {
        spawnedObjects = {},
        player = nil,
        spawnIntervalMinInit = 1, spawnIntervalMaxInit = 2,
        spawnIntervalMin = 1, spawnIntervalMax = 2, spawnIntervalNext = 0,
        spawnTick = 0, timeElapsed = 0,
        waveAmp = 0, waveFreq = 0, waveHeight = 0, waveSpeed = 0,
        waveAmpInit = 40, waveFreqInit = 0.005, waveSpeedInit = 400, waveHeightInit = 300
    }
    self.__index = self
    return setmetatable(o, self)
end

function Level:update(dt)
    self.player:update(dt)
    self:updateWaveValues()

    if state == GameState.InGame then
        score = score + dt * 8
        self.timeElapsed = self.timeElapsed + dt
        self:adjustDifficulty()
    end

    local objectsToRemove = {}

    for i, value in ipairs(self.spawnedObjects) do
        value.x = value.x - dt * wave.speed
        value:update(dt)
        if value.x < -50 then
            table.insert(objectsToRemove, i)
        end

        if self.player:isColliding(value) then
            print(value.collisionType)
            if value.collisionType == CollisionType.Kill then
                setState(GameState.PostGame)
            elseif value.collisionType == CollisionType.PickUp then
                score = score + 20
            end
            table.insert(objectsToRemove, i)
        end
    end

    for i, value in ipairs(objectsToRemove) do
        table.remove(self.spawnedObjects, value)
    end

    self.spawnTick = self.spawnTick + dt
    if self.spawnTick > self.spawnIntervalNext then
        self:spawnObject()
        self.spawnTick = 0
        self.spawnIntervalNext = self.spawnIntervalMin + math.random() * (self.spawnIntervalMax - self.spawnIntervalMin)
    end
end

function Level:draw()
    for i, value in ipairs(self.spawnedObjects) do
        value:draw()
    end

    if self.player then
        self.player:draw()
    end
end

function Level:spawnPlayer()
    self.player = Player:new(200, love.graphics.getHeight() / 2)
end

function Level:spawnObject()
    local up = math.random() > 0.5
    local x = love.graphics.getWidth() + 50
    local y = love.graphics.getHeight() / 2 + wave:getWavePointHeight(x) + wave.height / 2 * (up and -1 or 1)

    local object = nil

    local r = math.random()
    if r > 0.2 then
        object = Spike:new(x, y)
    else
        object = Coin:new(x, y - 30 * (up and -1 or 1))
    end

    object.rot = wave:getWavePointAngle(x)
    object.up = up
    -- if not up then object.rot = object.rot + 180 end

    if object then
        table.insert(self.spawnedObjects, 1, object)
    end
end

function Level:cleanup()
    self.player = nil
    self.spawnedObjects = {}
    self.timeElapsed = 0
    self.waveAmp = self.waveAmpInit
    self.waveFreq = self.waveFreqInit
    self.waveSpeed = self.waveSpeedInit
    self.waveHeight = self.waveHeightInit
    self:updateWaveValues()
end

function Level:updateWaveValues()
    wave.amp = self.waveAmp
    wave.freq = self.waveFreq
    wave.speed = self.waveSpeed
    wave.height = self.waveHeight
end

function Level:adjustDifficulty()
    if self.timeElapsed > 1 then
        local time = self.timeElapsed - 1
        self.spawnIntervalMin = math.max(self.spawnIntervalMinInit - time / 60, 0.3)
        self.spawnIntervalMax = math.max(self.spawnIntervalMaxInit - time / 50, 0.6)
        self.waveSpeed = math.min(self.waveSpeedInit + time * 4, 900)
        self.waveAmp = math.min(self.waveAmpInit + time / 3.0, 80.0)
        self.waveFreq = math.min(self.waveFreqInit + time * 0.00005, 0.005)
        self.waveHeight = math.max(self.waveHeightInit - time, 220)
    end
end