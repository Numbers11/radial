flux = require "lib.flux"
local RadialMenu = require "radial_menu"
------------------------------------

NAMES = {
    "Alepsi Druit",
    "Eter lus",
    "Line",
    "Logoogoo",
    "Mega Team",
    "Mikken",
    "Noctors",
    "Thomominate",
    "Vulumb",
    "remies Exchang",
}

function love.load()
    math.randomseed(os.time())
    spritesheet = love.graphics.newImage("assets/sprites14c.png")
    font = {}
    font["mono16"] = love.graphics.newImageFont("assets/font1.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_", 0)
    font["mono16"]:setLineHeight(1)
    

    radMen = RadialMenu:create(100, 50)
end

function love.update(dt)
    flux.update(dt)
    radMen:update(dt)
end

function love.draw()
    love.graphics.setFont(font["mono16"])
    radMen:draw()
end

function love.mousereleased( x, y, button, istouch, presses )
    if radMen.selected then
        print(radMen.selected, radMen.segments[radMen.selected].text)
    end
end

function love.keypressed( key, scancode, isrepeat )
    if key == "f" then
        radMen:show(love.mouse.getPosition())
    elseif key == "g" then
        radMen:close()
    elseif key == "r" then
        table.insert(radMen.segments, {img = spritesheet,
                    quad = love.graphics.newQuad(math.random(0, 12) * 18, math.random(0, 16) * 18, 18, 18, spritesheet:getDimensions()),
                    text = NAMES[math.random(#NAMES)],
                    color = {math.random(), math.random(), math.random(), 0.7}
                })
    elseif key == "t" then
        table.remove(radMen.segments)
    elseif key == "escape" then
        love.event.quit()
    end

end