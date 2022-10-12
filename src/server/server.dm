var/build
var/pre_release = 0
var/server_capacity = 100

var/list/administrators = list("douglasparker", "illusiveblair")
var/list/moderators = list()
var/list/programmers = list("douglasparker")
var/list/pixel_artists = list("illusiveblair")

var/list/hokage = list()
var/list/kazekage = list()
var/list/kages_last_online = list(VILLAGE_LEAF = null, VILLAGE_SAND = null)

var/list/akatsuki = list()
var/akatsuki_last_online

var/list/alpha_testers = list("djinnythedjin", "lavenblade")
var/list/beta_testers = list("djinnythedjin", "lavenblade")

var/list/clients_connected = list()
var/list/clients_online = list()
var/list/clients_multikeying = list()
var/list/mobs_online = list()
var/list/names_taken = list()
var/list/npcs_online = list()

var/leaf_online = 0
var/sand_online = 0
var/missing_nin_online = 0
var/akatsuki_online = 0

var/squads[0]

world
	name = "Naruto Evolution"
	hub = "IllusiveBlair.NarutoEvolution"
	hub_password = "Z3qzsVoh46BuHSNC"
	status = "Naruto Evolution (Connecting...) | Ninjas Online (Connecting...)"
	fps = 20
	view = 16
	loop_checks = 1
	New()
		..()
		CreateLogs()

		log = file(LOG_ERROR)

		build = file2text("VERSION")
		if(!build) text2file("0.0.0", "VERSION")

		if(file2text("PRERELEASE")) pre_release = 1

		src.Load()

		spawn() UpdateHUB()
		spawn() GeninExam()
		spawn() ChuuninExam()
		spawn() AnimalPopulater()
		spawn() ZetsuEvent()
		spawn() Advert()
		spawn() RepopWorld()
		spawn() AutomaticExperienceLock()
		spawn() LinkWarps()
		spawn() HTMLlist()
		spawn() Kage_Inactivity_Check()
		spawn() Akatsuki_Inactivity_Check()
		spawn() Hotspring_Loop()
		spawn() Election()
		spawn() InfamyLoop()
		spawn() Maintenance()

	Del()
		src.FailMissions()
		src.Save()
		..()

	Error(exception/ex)
		text2file("<b>Timestamp:</b> [time2text(world.realtime , "YYYY-MM-DD hh:mm:ss")]<br /><b>Runtime Error:</b> [ex.name]<br /><b>File:</b> [ex.file]<br /><b>Line:</b> [ex.line]<br /><b><u>Description:</u></b><br />[ex.desc]<br /><br />", LOG_ERROR)

	proc/UpdateVillageCount()
		leaf_online = 0
		sand_online = 0
		missing_nin_online = 0
		akatsuki_online = 0

		for(var/mob/m in mobs_online)
			if(m.village == VILLAGE_LEAF) leaf_online++
			if(m.village == VILLAGE_SAND) sand_online++
			if(m.village == VILLAGE_MISSING_NIN) missing_nin_online++
			if(m.village == VILLAGE_AKATSUKI) akatsuki_online++

	proc/UpdateClientsMultikeying()
		clients_multikeying = list()

		for(var/client/source in clients_connected)
			for(var/client/target in clients_connected)
				if(source != target)
					if(source.address == target.address || source.computer_id == target.computer_id)
						clients_multikeying.Add(source)
						clients_multikeying.Add(target)

	proc/Kage_Inactivity_Check()
		set background = 1
		while(src)
			var/days = 3

			if(kages_last_online[VILLAGE_LEAF] && kages_last_online[VILLAGE_LEAF] + 864000 * days <= world.realtime)
				var/online
				for(var/mob/m in mobs_online)
					if(hokage[m.client.ckey] == m.character) online = 1

				// Don't demote Kages that are online because kage_last_online[] only updates on mob.Load() and mob.Save().
				// Otherwise, Kages will be demoted if they do not logout to update their kage_last_online[] timestamp.
				if(!online)
					world << output("The [RANK_HOKAGE] for the <font color='[COLOR_VILLAGE_LEAF]'>[VILLAGE_LEAF]</font> was forced out of office due to inactivity for [days] days.", "Action.Output")
					text2file("<font color = '[COLOR_CHAT]'>[time2text(world.realtime , "(YYYY-MM-DD hh:mm:ss)")] The [RANK_HOKAGE] ([global.GetHokage()]) for the <font color='[COLOR_VILLAGE_LEAF]'>[VILLAGE_LEAF]</font> was forced out of office due to inactivity for [days] days.</font><br />", LOG_KAGE)
					hokage = list()
					kages_last_online[VILLAGE_LEAF] = null

			if(kages_last_online[VILLAGE_SAND] && kages_last_online[VILLAGE_SAND] + 864000 * days <= world.realtime)
				var/online
				for(var/mob/m in mobs_online)
					if(kazekage[m.client.ckey] == m.character) online = 1

				// Don't demote Kages that are online because kage_last_online[] only updates on mob.Load() and mob.Save().
				// Otherwise, Kages will be demoted if they do not logout to update their kage_last_online[] timestamp.
				if(!online)
					world << output("The [RANK_KAZEKAGE] for the <font color='[COLOR_VILLAGE_SAND]'>[VILLAGE_SAND]</font> was forced out of office due to inactivity for [days] days.", "Action.Output")
					text2file("<font color = '[COLOR_CHAT]'>[time2text(world.realtime , "(YYYY-MM-DD hh:mm:ss)")] The [RANK_KAZEKAGE] ([global.GetKazekage()]) for the <font color='[COLOR_VILLAGE_SAND]'>[VILLAGE_SAND]</font> was forced out of office due to inactivity for [days] days.</font><br />", LOG_KAGE)
					kazekage = list()
					kages_last_online[VILLAGE_SAND] = null

			sleep(600)

	proc/Akatsuki_Inactivity_Check()
		set background = 1
		while(src)
			var/days = 3

			if(akatsuki_last_online && akatsuki_last_online + 864000 * days <= world.realtime)
				var/online
				for(var/mob/m in mobs_online)
					if(akatsuki[m.client.ckey] == m.character) online = 1

				// Don't demote Akatsuki that are online because akatsuki_last_online only updates on mob.Load() and mob.Save().
				// Otherwise, Akatsuki will be demoted if they do not logout to update their akatsuki_last_online timestamp.
				if(!online)
					world << output("The [RANK_AKATSUKI] for the <font color='[COLOR_VILLAGE_AKATSUKI]'>[VILLAGE_AKATSUKI]</font> was forced out of office due to inactivity for [days] days.", "Action.Output")
					text2file("<font color = '[COLOR_CHAT]'>[time2text(world.realtime , "(YYYY-MM-DD hh:mm:ss)")] The [RANK_AKATSUKI] ([global.GetAkatsuki()]) for the <font color='[COLOR_VILLAGE_AKATSUKI]'>[VILLAGE_AKATSUKI]</font> was forced out of office due to inactivity for [days] days.</font><br />", LOG_AKATSUKI)
					akatsuki = list()
					akatsuki_last_online = null

			sleep(600)

	proc/UpdateHUB()
		set background = 1
		while(world)
			status = "Naruto Evolution v[build] | Ninjas Online ([mobs_online.len]/[server_capacity])"
			sleep(600)

	proc/CreateLogs()

		if(!fexists(LOG_ERROR))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_ERROR)

		if(!fexists(LOG_BUGS))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_BUGS)

		if(!fexists(LOG_SAVES))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_SAVES)

		if(!fexists(LOG_CLIENT_SAVES))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_CLIENT_SAVES)

		if(!fexists(LOG_KILLS))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_KILLS)

		if(!fexists(LOG_STAFF))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_STAFF)

		if(!fexists(LOG_ADMINISTRATOR))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_ADMINISTRATOR)

		if(!fexists(LOG_MODERATOR))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_MODERATOR)

		if(!fexists(LOG_KAGE))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_KAGE)

		if(!fexists(LOG_AKATSUKI))
			text2file("<body bgcolor = '#414141'><font color = '[COLOR_CHAT]'>", LOG_AKATSUKI)

		if(!fexists(LOG_CHAT_LOCAL))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_LOCAL)

		if(!fexists(LOG_CHAT_VILLAGE))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_VILLAGE)

		if(!fexists(LOG_CHAT_SQUAD))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_SQUAD)

		if(!fexists(LOG_CHAT_FACTION))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_FACTION)

		if(!fexists(LOG_CHAT_GLOBAL))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_GLOBAL)

		if(!fexists(LOG_CHAT_WHISPER))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_WHISPER)

		if(!fexists(LOG_CHAT_STAFF))
			text2file("<body bgcolor = '#414141'>", LOG_CHAT_STAFF)

		if(!fexists(LOG_KAGE))
			text2file("<body bgcolor = '#414141'>", LOG_KAGE)

	proc/Save()
		var/savefile/F = new(SAVEFILE_STAFF)
		F["administrators"] << administrators
		F["moderators"] << moderators
		F["programmers"] << programmers
		F["pixel_artists"] << pixel_artists

		F = new(SAVEFILE_NAMES)
		F["names_taken"] << names_taken

		F = new(SAVEFILE_KAGES)
		F["hokage"] << hokage
		F["kazekage"] << kazekage
		F["kages_last_online"] << kages_last_online

		F = new(SAVEFILE_AKATSUKI)
		F["akatsuki"] << akatsuki
		F["akatsuki_last_online"] << akatsuki_last_online

		F = new(SAVEFILE_SQUADS)
		F["squads"] << squads

		F = new(SAVEFILE_ELECTIONS)
		F["hokage_election"] << hokage_election
		F["hokage_ballot_open"] << hokage_ballot_open
		F["hokage_election_ballot"] << hokage_election_ballot
		F["hokage_election_votes"] << hokage_election_votes
		F["kazekage_election"] << kazekage_election
		F["kazekage_ballot_open"] << kazekage_ballot_open
		F["kazekage_election_ballot"] << kazekage_election_ballot
		F["kazekage_election_votes"] << kazekage_election_votes

		F = new(SAVEFILE_WORLD)
		Factionnames = new/list()
		for(var/Faction/c in Factions)
			if(!c.name) continue
			var/path = "Factions/[c.name].sav"
			var/savefile/G = new(path)
			G << c
			Factionnames += c.name
		if(maps.len) F["Maps"] << maps
		F["Factions"] << Factionnames
		F["AkatInvites"] << AkatInvites
		F["WorldXp"] << WorldXp

	proc/Load()
		var/savefile/F = new(SAVEFILE_STAFF)
		if(!isnull(F["administrators"])) F["administrators"] >> administrators
		if(!isnull(F["moderators"])) F["moderators"] >> moderators
		if(!isnull(F["programmers"])) F["programmers"] >> programmers
		if(!isnull(F["pixel_artists"])) F["pixel_artists"] >> pixel_artists

		for(var/ckey in initial(administrators))
			if(!ckey in administrators) administrators += ckey

		for(var/ckey in initial(moderators))
			if(!ckey in moderators) moderators += ckey

		for(var/ckey in initial(programmers))
			if(!ckey in programmers) programmers += ckey

		for(var/ckey in initial(pixel_artists))
			if(!ckey in pixel_artists) pixel_artists += ckey

		if(!fexists(CFG_ADMIN))
			for(var/ckey in administrators) text2file("[ckey] role=root", CFG_ADMIN)
		if(!fexists(CFG_HOST)) text2file("",CFG_HOST)

		F = new(SAVEFILE_NAMES)
		if(F["names_taken"]) F["names_taken"] >> names_taken

		F = new(SAVEFILE_SQUADS)
		if(F["squads"]) F["squads"] >> squads

		F = new(SAVEFILE_KAGES)
		if(F["hokage"]) F["hokage"] >> hokage
		if(F["kazekage"]) F["kazekage"] >> kazekage
		if(F["kages_last_online"]) F["kages_last_online"] >> kages_last_online

		F = new(SAVEFILE_AKATSUKI)
		if(F["akatsuki"]) F["akatsuki"] >> akatsuki
		if(F["akatsuki_last_online"]) F["akatsuki_last_online"] >> akatsuki_last_online

		F = new(SAVEFILE_ELECTIONS)
		if(F["hokage_election"]) F["hokage_election"] >> hokage_election
		if(F["hokage_ballot_open"]) F["hokage_ballot_open"] >> hokage_ballot_open
		if(F["hokage_election_ballot"]) F["hokage_election_ballot"] >> hokage_election_ballot
		if(F["hokage_election_votes"]) F["hokage_election_votes"] >> hokage_election_votes
		if(F["kazekage_election"]) F["kazekage_election"] >> kazekage_election
		if(F["kazekage_ballot_open"]) F["kazekage_ballot_open"] >> kazekage_ballot_open
		if(F["kazekage_election_ballot"]) F["kazekage_election_ballot"] >> kazekage_election_ballot
		if(F["kazekage_election_votes"]) F["kazekage_election_votes"] >> kazekage_election_votes

		F = new(SAVEFILE_WORLD)
		if(!isnull(F["Factions"])) F["Factions"] >> Factionnames
		if(!isnull(F["Maps"])) F["Maps"] >> maps
		if(!isnull(F["AkatInvites"])) F["AkatInvites"] >> AkatInvites
		if(!isnull(F["WorldXp"])) F["WorldXp"] >> WorldXp

		for(var/c in Factionnames)
			var/path = "Factions/[c].sav"
			var/savefile/G = new(path)
			if(!fexists(path))
				Factionnames -= c
				continue
			var/Faction/Faction
			G >> Faction
			Factions += Faction

	proc/GetAdvert()
		return "<center><b><font color='#dd5800'>[world.name]</font> v[build] | <font color='#dd5800'>Ninjas Online</font> ([mobs_online.len]/[server_capacity])<br />\[<a href='https://www.byond.com/games/IllusiveBlair/NarutoEvolution'>Hub</a>] \[<a href='https://wiki.narutoevolution.com'>Wiki</a>] \[<a href='https://discord.gg/UW77xAhcTM'>Discord</a>]<br />\[<a href='https://github.com/douglasparker/naruto-evolution-community/issues/new?assignees=&labels=Type%3A+Feature+Request&template=feature-request.md&title='>Feature Requests</a>] \[<a href='https://github.com/douglasparker/naruto-evolution-community/issues/new?assignees=&labels=Type%3A+Bug&template=bug-report.md&title='>Bug Reports</a>]</b></center>"
	
	proc/Maintenance()
		while(world)
			switch(time2text(world.timeofday, "hh:mm"))
				if("11:50")
					world << "<center><font color='#BE1A0E'><b><u>The server will be going down for maintenance in 10 minutes.</u></b></font></center>"
				
				if("11:55")
					world << "<center><font color='#BE1A0E'><b><u>The server will be going down for maintenance in 5 minutes.</u></b></font></center>"
				
				if("11:56")
					world << "<center><font color='#BE1A0E'><b><u>The server will be going down for maintenance in 4 minutes.</u></b></font></center>"
				
				if("11:57")
					world << "<center><font color='#BE1A0E'><b><u>The server will be going down for maintenance in 3 minutes.</u></b></font></center>"
				
				if("11:58")
					world << "<center><font color='#BE1A0E'><b><u>The server will be going down for maintenance in 2 minutes.</u></b></font></center>"
				
				if("11:59")
					world << "<center><font color='#BE1A0E'><b><u>The server will be going down for maintenance in 1 minutes.</u></b></font></center>"
				
				if("12:00")
					world << "<center><font color='#BE1A0E'><b><u>The server is now going down for maintenance. The server should be back online in a couple of minutes.</u></b></font></center>"
			
			sleep(600)

	proc/Advert()
		set background = 1
		while(world)
			world << src.GetAdvert()
			sleep(600*30)

	proc/FailMissions()
		for(var/squad/squad in squads)
			if(squad.mission)
				switch(squad.mission.type)
					if(/mission/d_rank/deliver_intel)
						squad.mission.status = "Failure"
						squad.mission.complete = world.realtime

					if(/mission/a_rank/political_escort)
						squad.mission.status = "Failure"
						squad.mission.complete = world.realtime