mob/moderator
	verb
		Teleport()
			set category = "Moderator"
			src.TeleportCommand()

mob/proc/TeleportCommand()
	switch(src.client.prompt("What kind of mob would you like to teleport to?", "Teleport", list("Player", "NPC", "Coordinates")))
		if("Player")
			var/mob/mob = src.client.prompt("Which player would you like to teleport to?", "Teleport", mobs_online)
			if(mob)
				if(src.client.prompt("Are you sure you want to teleport to [mob] ([mob.ckey])?", "Teleport", list("Yes", "No")) == "Yes")
					src.loc = mob.loc
					text2file("[time2text(world.realtime , "(YYYY-MM-DD hh:mm:ss)")] [src] ([src.ckey]) has teleported to [mob] ([mob.ckey]).<br />", LOG_ADMINISTRATOR)
			else
				src << "/teleport: A player mob was not found."

		if("NPC")
			var/mob/mob = src.client.prompt("Which NPC would you like to teleport to?", "Teleport", npcs_online)
			if(mob)
				if(src.client.prompt("Are you sure you want to teleport to [mob]?", "Teleport", list("Yes", "No")) == "Yes")
					src.loc = mob.loc
					text2file("[time2text(world.realtime , "(YYYY-MM-DD hh:mm:ss)")] [src] ([src.ckey]) has teleported to [mob].<br />", LOG_ADMINISTRATOR)
			else
				src << "/teleport: An NPC mob was not found."
		
		if("Coordinates")
			var/list/xyz = src.client.iprompt("What coordinates would you like to teleport to?<br /><br /><u>Example Format</u><br /><br />Hidden Leaf Village: 116,127,1<br />Hidden Sand Village: 102,95,2", "Teleport", list("Submit", "Cancel"))
			if(xyz[1] == "Submit")
				if(src.client.prompt("Are you sure you want to teleport to [xyz[2]]?", "Teleport", list("Yes", "No")) == "Yes")
					var/x = text2num(copytext(xyz[2], 1, findtext(xyz[2], ",")))
					var/y = text2num(copytext(xyz[2], findtext(xyz[2], ",")+1, findlasttext(xyz[2], ",")))
					var/z = text2num(copytext(xyz[2], findlasttext(xyz[2], ",")+1))
					src.loc = locate(x, y, z)
					text2file("[time2text(world.realtime , "(YYYY-MM-DD hh:mm:ss)")] [src] ([src.ckey]) has teleported to [x],[y],[z].<br />", LOG_ADMINISTRATOR)