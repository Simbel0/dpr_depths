return {
	prestart = function(cutscene)
		Game.world.camera:shake(5, 0, 0.1)

		cutscene:wait(function()
			return Game.world.camera.shake_x == 0
		end)

		cutscene:wait(0.5)

		cutscene:text("* ...You're sure there's nothing that's gonna kill us?", "shocked", "hero")
		cutscene:text("* I think??", "shock_nervous", "susie")
	end,
	start = function(cutscene)
		Game.world.music:stop()
		Game.world.camera:shake(5, 0, 0.1)

		cutscene:wait(function()
			return Game.world.camera.shake_x == 0
		end)

		local susie = cutscene:getCharacter("susie")

		local stalac = Sprite("bullets/stalac", susie.x, -50)

		local stalac_dest = susie.y
		stalac:setPhysics({
			gravity = 0.2,
		})

		cutscene:wait(function()
			return stalac.y >= susie.y-100
		end)
		Assets.playSound("sussurprised")
		local wait = cutscene:slideTo(susie, susie.x-100, susie.y, "outCubic")

		cutscene:wait(function()
			return stalac.y >= stalac_dest
		end)

		stalac:remove()

		cutscene:wait(2)

		cutscene:text("* Oh no.", "shocked", "hero")

		Game.world.camera:shake(5, 0, 1)

		cutscene:wait(function()
			return Game.world.camera.shake_x == 0
		end)
	end
}