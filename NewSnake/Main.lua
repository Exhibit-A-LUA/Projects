TILE_SIZE = 32
WINDOW_WIDTH = 720
WINDOW_HEIGHT = 720

MAX_TILES_X = math.floor(WINDOW_WIDTH / TILE_SIZE)
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE)

TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
TILE_APPLE = 3
TILE_STONE = 4

SNAKE_SPEED = 0.1

local largeFont = love.graphics.newFont(32)
local hugeFont = love.graphics.newFont(64)

local score = 0
local gameOver = false
local gameStart = true

local tileGrid = {}


local snakeX, snakeY = 1,1
local snakeMoving = 'right'
local snakestatus = 0

local snakeTiles = {
    {snakeX, snakeY}
}

function love.load()

    love.window.setTitle('Snake New')

    love.graphics.setFont(largeFont)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false})

    math.randomseed(os.time())
    initializeGrid()
    initializeSnake()
    tileGrid[snakeTiles[1][2]][snakeTiles[1][1]] = TILE_SNAKE_HEAD
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if not gameOver then
        if key == 'left' and (snakeMoving ~= 'right' or #snakeTiles == 1) then
            snakeMoving = 'left'
        elseif key == 'right' and (snakeMoving ~= 'left' or #snakeTiles == 1) then
            snakeMoving = 'right'
        elseif key == 'up' and (snakeMoving ~= 'down' or #snakeTiles == 1) then
            snakeMoving = 'up'
        elseif key == 'down' and (snakeMoving ~= 'up' or #snakeTiles == 1) then
            snakeMoving = 'down'
        end
    end

    if gameOver or gameStart then
        if key == 'enter' or key == 'return' then
            initializeGrid()
            initializeSnake()
            score = 0
            gameOver = false
            gameStart = false
        end
    end
end    

function love.update(dt)
    if not gameOver then
        snakestatus = snakestatus + dt

        local priorHeadX, priorHeadY = snakeX, snakeY

        if snakestatus >= SNAKE_SPEED then
            if snakeMoving == 'left' then
                if snakeX <= 1 then
                    snakeX = MAX_TILES_X
                else
                    snakeX = snakeX - 1
                end
            elseif snakeMoving == 'right' then
                if snakeX >= MAX_TILES_X then
                    snakeX = 1
                else
                    snakeX = snakeX + 1
                end
            elseif snakeMoving == 'up' then
                if snakeY <= 1 then
                    snakeY = MAX_TILES_Y
                else
                    snakeY = snakeY - 1
                end
            elseif snakeMoving == 'down' then
                if snakeY >= MAX_TILES_Y then
                    snakeY = 1
                else
                    snakeY = snakeY + 1
                end
            end

            -- push new head onto snake data structure
            table.insert(snakeTiles, 1, {snakeX, snakeY})

            if  tileGrid[snakeY][snakeX] == TILE_SNAKE_BODY or
                tileGrid[snakeY][snakeX] == TILE_STONE then
                gameOver = true
            elseif tileGrid[snakeY][snakeX] == TILE_APPLE then

                score = score + 1
                generateObstacle(TILE_APPLE)

            else

                local tail = snakeTiles[#snakeTiles]
                tileGrid[tail[2]][tail[1]] = TILE_EMPTY
                table.remove(snakeTiles)

            end    

            if #snakeTiles > 1 then
                tileGrid[priorHeadY][priorHeadX] = TILE_SNAKE_BODY
            end

            tileGrid[snakeY][snakeX] = TILE_SNAKE_HEAD

            snakestatus = 0
        end
    end
end    

function drawGameOver()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('GAME OVER', 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')
    love.graphics.setFont(largeFont)
    love.graphics.printf('Press Enter to Restart', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDTH, 'center')
end    

function love.draw()
    if gameStart then
        love.graphics.setFont(hugeFont)
        love.graphics.printf('SNAKE', 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')
        love.graphics.setFont(largeFont)
        love.graphics.printf('Press Enter to Start', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDTH, 'center')
    else
        drawGrid()
        love.graphics.setColor(1,1,1,1)
        love.graphics.print('Score: ' .. tostring(score), 10, 10)
        if gameOver then
            drawGameOver()
        end
    end
end

function drawGrid()

    for y = 1, MAX_TILES_X do
        for x = 1, MAX_TILES_Y do
            if tileGrid[y][x] == TILE_EMPTY then
                -- love.graphics.setColor(1, 1, 1, 1)
                -- love.graphics.rectangle('line', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            elseif tileGrid[y][x] == TILE_APPLE then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            elseif tileGrid[y][x] == TILE_STONE then
                love.graphics.setColor(0.8, 0.8, 0.8, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            elseif tileGrid[y][x] == TILE_SNAKE_HEAD then
                love.graphics.setColor(0, 1, 0.5, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            elseif tileGrid[y][x] == TILE_SNAKE_BODY then
                love.graphics.setColor(0, 0.5, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function generateObstacle(obstacle)
    local obstacleX, obstacleY 
    repeat
        obstacleX, obstacleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
    until tileGrid[obstacleY][obstacleX] == TILE_EMPTY

    tileGrid[obstacleY][obstacleX] = obstacle
end    

function initializeSnake()
    snakeX, snakeY = 1, 1
    snakeMoving = 'right'
    snakeTiles = {
        {snakeX, snakeY}
    }
end    

function initializeGrid()
    tileGrid = {}
    for y = 1, MAX_TILES_X do

        table.insert(tileGrid, {})

        for x = 1, MAX_TILES_Y do
            table.insert(tileGrid[y], TILE_EMPTY)
        end
    end

    for i = 1, 10 do
        generateObstacle(TILE_STONE)
    end

    generateObstacle(TILE_APPLE)

end    