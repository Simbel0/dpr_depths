local Depths_5, super = Class(Map)

function Depths_5:onEnter()
    super.onEnter(self)

    if Game:getFlag("depths_stalac_assault") then
        Game.world:setBattle(true)
        Game.world.music:play("creepychase")
    end

    -- TODO:
    -- At least try to base the bullet position off a random point taken around the player, not the player itself
    self.timer:everyInstant(1, function()
        if Game.world:inBattle() then
            local obj = self:findObjectPlayerIsIn(Game.world.map:getShapeLayer("objects_stalaczones").objects)
            if not obj then
                print("NO OBJECT FOUND WTF")
                return
            end

            local max_i = 3
            if dir == "up" or dir == "down" then
                max_i = 1
            end

            for i=1,max_i do
                local x, y

                local player = Game.world.player
                local min_x, max_x, min_y, max_y
                local spawn_y

                local dir = obj.properties.dir
                if dir == "right" then
                    min_x = Utils.clamp(player.x-SCREEN_WIDTH/4, obj.x, obj.x+obj.width)
                    max_x = Utils.clamp(player.x+SCREEN_WIDTH, obj.x, obj.x+obj.width)

                    min_y = obj.y
                    max_y = obj.y+obj.height
                elseif dir == "left" then
                    min_x = Utils.clamp(player.x+SCREEN_WIDTH/4, obj.x, obj.x+obj.width)
                    max_x = Utils.clamp(player.x-SCREEN_WIDTH, obj.x, obj.x+obj.width)

                    min_y = obj.y
                    max_y = obj.y+obj.height
                elseif dir == "up" then
                    min_x = obj.x
                    max_x = obj.x+obj.width

                    min_y = Utils.clamp(player.y+SCREEN_HEIGHT/4, obj.y, obj.y+obj.height)
                    max_y = Utils.clamp(player.y-obj.height/2, obj.y, obj.y+obj.height)
                elseif dir == "down" then
                    min_x = obj.x
                    max_x = obj.x+obj.width

                    min_y = Utils.clamp(player.y-SCREEN_HEIGHT/4, obj.y, obj.y+obj.height)
                    max_y = Utils.clamp(player.y+obj.height/2, obj.y, obj.y+obj.height)
                else
                    print("The object doesn't have a dir property!")
                    return
                end

                local x = Utils.random(min_x, max_x)
                local y = Utils.random(min_y, max_y)

                if dir == "right" or dir == "left" then
                    spawn_y = y-SCREEN_HEIGHT+10
                else
                    spawn_y = y-SCREEN_HEIGHT
                end

                print("--SPAWN INFO--")
                print("RANGE X=["..min_x..", "..max_x.."]")
                print("RANGE Y=["..min_y..", "..max_y.."]")
                print("X="..x)
                print("Y="..y)
                print("SPAWN Y="..spawn_y)

                print("--PLAYER INFO--")
                print("X="..player.x)
                print("Y="..player.y)

                print("--OBJECT INFO--")
                print("X="..obj.x)
                print("Y="..obj.y)
                print("W="..obj.width)
                print("H="..obj.height)

                Game.world:spawnBullet("dark_stalactite", x, y, Utils.random(0.2, 0.6), i==1, spawn_y)
            end
        end
    end)
end

function Depths_5:findObjectPlayerIsIn(objects)
    local player = Game.world.player
    --print("---PLAYER INFO---")
    --print("X = "..player.x)
    --print("Y = "..player.y)
    for i,obj in ipairs(objects) do
        --print("---INFO ON OBJECT "..i.."---")
        --print("X = "..obj.x)
        --print("Y = "..obj.y)
        --print("W = "..obj.width)
        --print("H = "..obj.height)
        --print("X+W = "..obj.x+obj.width)
        --print("Y+H = "..obj.y+obj.height)
        if  player.x > obj.x and
            player.x < obj.x+obj.width and
            player.y > obj.y and
            player.y < obj.y+obj.height
            then

            return obj

        end
    end
end

return Depths_5