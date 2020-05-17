local World = require("world")
local Component = require("component")
local System = require("system")
local coms = require("common_components")

-- SHOVED THESE INTO coms
-- function new_body(x, y)
--     local body = Component.new("body")
--     body.x = x
--     body.y = y
--     return body
-- end

-- function new_rectangle_component()
--     return Component.new("rect")
-- end

function new_renderer_system()
    local renderer = System.new({"body", "rect"})

    function renderer:load(entity)
    end

    function renderer:draw(entity)
        local body = entity:get("body")
        love.graphics.rectangle('fill', body.x, body.y, 32, 32)
    end

    return renderer
end    

function new_functional_system()
    local system = System.new({"functional"})

    function system:load(entity)
    end

    function system:update(dt, entity)
        local fn = entity:get("functional").fn
        fn(entity, dt)
    end

    return system
end    


-- local player_type = {
--     {new_body, 300, 100},
--     {new_rectangle_component}
-- }

function love.load()
--    local r_sys = World:register(new_renderer_system())
    World:register(new_renderer_system())
    World:register(new_functional_system())
    
    -- use this format ....
    -- local entity = World:create()
    -- entity:add(new_body(100,100))
    -- entity:add(new_rectangle_component())
    -- or this format ....
    World:create()
        :madd(coms.new_body(100,100))
        :madd(coms.new_rectangle_component())

    local test = World:assemble {
        {coms.new_body, 300, 100},
        {coms.new_rectangle_component}
    }
    -- test:add(coms.functional(function(self, dt)
    --     local body = self:get("body")
    --     body.x = body.x + dt * 100
    -- end))
end

function love.update(dt)
    World:update(dt)
end

function love.draw()
    World:draw()
end