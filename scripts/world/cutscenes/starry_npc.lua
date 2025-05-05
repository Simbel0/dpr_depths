return {
	depths_7 = function(cutscene, event)
		if event.interact_count == 1 then
            cutscene:text("* So uh, are you just staying there?", "nervous_side", "susie")
            cutscene:text("* Erm... To be honest with you two...")
            cutscene:text("* I'm not too sure how this \"helping\" thing works in the first place.")
            cutscene:text("* Oh, uh...", "shock_down", "susie")
            cutscene:text("* Well, helping people means... Making their life easier I think.", "nervous_side", "susie")
            cutscene:text("* Ohhh! That makes sense!")
        else
            cutscene:text("* So... Have you decided what to do to help us?", "smirk", "susie")
            cutscene:text("* Nope!")
            cutscene:text("* Right...", "neutral_side", "susie")
        end
	end
}