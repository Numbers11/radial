local RadialMenu = {}
RadialMenu.__index = RadialMenu

function RadialMenu:create(radius, width)
   local o = {}             
   setmetatable(o,RadialMenu)  

   -- init our object
    o._radius = radius
    o._width = width
    o.segments = {}
    o.showing = false
   return o
end

function RadialMenu:show(x, y)
    self.showing = true
    self.x = x
    self.y = y
    flux.to(self, 0.2, { radius = self._radius, width = self._width }):ease("cubicinout")
    self.radius = 0
    self.width = 0
end

function RadialMenu:close()
    self.selected = nil
    self.closing = true
    local r, w = self.radius, self.width
    flux.to(self, 0.15, { radius = 0, width = 0 }):oncomplete(function() 
        self.showing = false
        self.closing = false
    end)
end

function RadialMenu:update(dt)
    if not self.showing or self.closing then return end

    local x, y = love.mouse.getPosition()
    --uncomment this if you only want to set selection if the cursos is inside the circle
    --if (x - self.x)^2 + (y - self.y)^2 < self.radius^2 then
        --print("inside circle!")
        x = x - self.x
        y = y - self.y
        local angle = math.atan2(y, x)
        if angle < 0 then
            angle = angle + 2 * math.pi
        end
        
        local segment =  math.ceil((angle * #self.segments) / (2 * math.pi))
        if segment == 0 then return end

        self.selected = segment
    --else
    --    self.selected = nil
    --end
end

function RadialMenu:draw()
    if not self.showing then return end

    local function myStencilFunction()
        love.graphics.circle("fill", self.x, self.y, self.radius - self.width)   
    end

    love.graphics.stencil(myStencilFunction, "increment")
    love.graphics.setStencilTest("less", 1)

    local angle =  math.pi*2/#self.segments
    for k, v in ipairs(self.segments) do
        --filling the arc
        love.graphics.setColor(v.color[1], v.color[2], v.color[3], (self.selected == k) and 1 or v.color[4])
        love.graphics.arc("fill", self.x, self.y, self.radius, angle * (k - 1), angle * (k) , 100)
        
        --the separation line
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.line(self.x, self.y, self.x + math.cos(angle * k) * self.radius, self.y + math.sin(angle * k) * self.radius)
        
        -- the image
        if v.img then
            local _, _, w, h = v.quad:getViewport()
            love.graphics.draw(v.img, v.quad, self.x + math.cos(angle * (k - 0.5)) * self.radius * 0.75, self.y + math.sin(angle * (k  - 0.5)) * self.radius * 0.75, 0, 1, 1, w  / 2, h / 2)
        end
    end
    love.graphics.setStencilTest()
    
    --the accents around the inner and outer circle
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.circle("line", self.x, self.y, self.radius)
    love.graphics.circle("line", self.x, self.y, self.radius - self.width)
    love.graphics.setColor(1, 1, 1, 1)
    
    --the text in the middle
    if self.selected and #self.segments > 0 then
        love.graphics.printf(self.segments[self.selected].text, self.x - self.width, self.y, self.width * 2, "center")
    end
end

return RadialMenu