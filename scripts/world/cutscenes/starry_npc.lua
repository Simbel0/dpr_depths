return {
	depths_7 = function(cutscene, event)
		if event.interact_count == 1 then
            cutscene:text("* So uh, are you just staying there?", "nervous_side", "susie")
            cutscene:text("* Erm... To be honest with you two...", "neutral", "starry")
            cutscene:text("* I'm not sure how this \"helping\" thing even works.", "neutral", "starry")
            cutscene:text("* Oh, uh...", "shock_down", "susie")
            cutscene:text("* Well, helping people means... Making their life easier I think.", "nervous_side", "susie")
            cutscene:text("* Ohhh! That makes sense!", "neutral", "starry")
        else
            cutscene:text("* So... Have you figured how to help us?", "smirk", "susie")
            cutscene:text("* Nope!", "neutral", "starry")
            cutscene:text("* Right...", "neutral_side", "susie")
        end
	end
}