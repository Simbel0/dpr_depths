return function(cutscene)
	cutscene:text("* !!!")
	cutscene:text("* (The pupil of the eye can be pressed on!)")
	cutscene:text("* (You pressed the pupil...)")

	Game.world.camera:shake(20, 0)
	Assets.playSound("dtrans_flip")

	Game:setFlag("eyes_puzzle_solved", true)
	Game.world.map:updatePuzzleState()
end