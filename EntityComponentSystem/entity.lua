return {
    new = function()
        local entity = {
            components = {},
            tags = {},
            remove = false,
            loaded = false
        }
    
        function entity:destroy()
            self.remove = true
        end

        function entity:add(component)
            assert(component.__id,"entity:add must have an __id")
            self.components[component.__id] = component
            return component
        end

        function entity:madd(component)
            self:add(component)
            return self
        end
        

        function entity:get(id)
            return self.components[id]
        end

        return entity
    end
}