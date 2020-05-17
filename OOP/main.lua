Vector = {}
Figure = {}

function Vector:new(x, y)
    local object = {}
    object.x = x or 0
    object.y = y or 0
    setmetatable(object, self)
    self.__index = self
    return object
end

function Vector:__add(v)
    return Vector:new(self.x + v.x, self.y + v.y)
end

function Figure:new(position)
    local object = {}
    setmetatable(object, self)
    self.__index = self
    object.position = position or Vector:new()
    return object
end

function Figure:moveBy(x, y)
    self.position = self.position + Vector:new(x, y)
end

Ellipse = Figure:new()
function Ellipse:new(position, radiusX, radiusY)
    local object = Figure:new(position)
    setmetatable(object, self)
    self.__index = self
    object.radiusX = radiusX or 40
    object.radiusY = radiusY or 20
    return object
end

Rectangle = Figure:new()
function Rectangle:new(position, width, height)
    local object = Figure:new(position)
    setmetatable(object, self)
    self.__index = self
    object.position = position or Vector:new()
    object.width = width or 20
    object.height = height or 20
    return object
end

Text = Figure:new()
function Text:new(position, text)
    local object = Figure:new(position)
    setmetatable(object, self)
    self.__index = self
    object.text = text or "Text"
    return object
end

function Ellipse:draw()
    love.graphics.ellipse("fill", self.position.x, self.position.y, self.radiusX, self.radiusY)
end

function Rectangle:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end

function Text:draw()
    love.graphics.print(self.text, self.position.x, self.position.y)
end

local figures = {}

function love.load()
    table.insert(figures, Ellipse:new(Vector:new(50, 40)))
    table.insert(figures, Rectangle:new(Vector:new(400, 80)))
    table.insert(figures, Rectangle:new(Vector:new(100, 200), 80, 50))
    table.insert(figures, Text:new(Vector:new(150, 150), "Hello World"))
end

function love.update(dt)
    for i=1,#figures do
        figures[i]:moveBy(dt * 10, dt * 4)
    end
end

function love.draw()
    for i=1,#figures do
        figures[i]:draw()
    end
end