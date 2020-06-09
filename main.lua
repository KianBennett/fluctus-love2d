require('player')
require('wave')
require('level')

GameState = {
    PreGame = 1, InGame = 2, PostGame = 3
}

font = love.graphics.newFont("Nunito-Bold.ttf", 50)
scoreFont = love.graphics.newFont("Nunito-Bold.ttf", 60)
endScoreFont = love.graphics.newFont("Nunito-Bold.ttf", 80)
titleFont = love.graphics.newFont("Nunito-Bold.ttf", 120)

wave = Wave:new(40, 0.005, 400, 300)
state = GameState.PreGame
level = Level:new(wave)
score = 0

function love.load()
    love.graphics.setBackgroundColor(0.15, 0.15, 0.15)

    -- setState(GameState.InGame)
end

function love.update(dt)
    wave:update(dt)
    -- player.y = love.graphics.getHeight() / 2 + 100 * math.sin(love.timer.getTime() * 10)
    if state == GameState.InGame then
        level:update(dt)
    end
end

function love.draw()
    wave:draw()

    if state == GameState.PreGame then
        printTitle()
    elseif state == GameState.InGame then
        printScore(math.floor(score), -15, 0, scoreFont, 'right')
        level:draw()
    elseif state == GameState.PostGame then
        printEndScore()
    end
end

function love.keypressed(key)
    if(key == 'escape') then
        love.event.quit()
    elseif key == 'f' then
        love.window.setFullscreen(not love.window.getFullscreen());
    elseif state == GameState.PreGame then
        setState(GameState.InGame)
    elseif state == GameState.InGame and level.player then
        level.player:flip()
    elseif state == GameState.PostGame then
        setState(GameState.InGame)
    end
end

function setState(newState)
    state = newState
    level:cleanup()

    if newState == GameState.InGame then
        score = 0
        level:spawnPlayer()
    end
end

function printScore(score, x, y, font, align)
    local scoreText = {
        { 1, 1, 1, 1},
        math.floor(score)
    }

    local leadingZeros = 8 - string.len(tostring(math.floor(score)))

    -- insert leading zeros until so there are 8 total characters
    for i = 1, leadingZeros do
        table.insert(scoreText, 1, '0')
        table.insert(scoreText, 1, { 1, 1, 1, 0.3 })
    end

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 0.4)

    if align == 'right' then
        love.graphics.printf(score, x + 4, y + 4, love.graphics.getWidth(), align)
    elseif align == 'center' then
        love.graphics.printf(score, font:getWidth(string.format("%0" .. tostring(leadingZeros) .. "d", tostring(score))) / 2 + x + 4, y + 4, love.graphics.getWidth(), align)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(scoreText, x, y, love.graphics.getWidth(), align)
end

function printTitle()
    local titleText = "FLUCTUS"
    local spacing = 120

    love.graphics.setFont(titleFont)

    for i = 1, string.len(titleText) do
        local x = -string.len(titleText) / 2 * spacing + (i - 1) * spacing + spacing / 2
        local y = love.graphics.getHeight() / 2 - wave:getWavePointHeight(x) - titleFont:getHeight() / 2
        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.printf(titleText:sub(i, i), x + 6, y + 6, love.graphics.getWidth(), 'center') -- shadow
        love.graphics.setColor(0.72, 1, 1, 1)
        love.graphics.printf(titleText:sub(i, i), x, y, love.graphics.getWidth(), 'center')
    end

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf("Press any key to start", 3, love.graphics.getHeight() / 2 + 223, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Press any key to start", 0, love.graphics.getHeight() / 2 + 220, love.graphics.getWidth(), 'center')
end

function printEndScore()
    printScore(math.floor(score), 0, love.graphics.getHeight() / 2 - 80, endScoreFont, 'center')

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf("Press any key to restart", 3, love.graphics.getHeight() / 2 + 223, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Press any key to restart", 0, love.graphics.getHeight() / 2 + 220, love.graphics.getWidth(), 'center')
end