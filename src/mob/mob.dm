mob
	var
		character
		password
		password_salt
		creation_date
		playtime = 0
		last_online

		items=0
		maxitems=-1 // Max Satchel Slots: -1 = Unlimited
		equipped
		jutsus[0]
		jutsus_learned[0]

		set animate_movement = 2

		tmp
			jutsu_cooldowns[0]
			ninja_tool_selection = 0 // Selected ninja tool from Rotate_Ninja_Tool()

		#ifdef STATE_MANAGER
		tmp/list/state_manager = list()
		#endif

	New()
		pixel_x=-16
		..()
		sleep(1)
		if(src.client || istype(src, /mob/summonings) || istype(src, /mob/jutsus) || istype(src, /mob/training))
			src.mouse_over_pointer = /obj/cursors/target

	Del()
		..()

	Login()
		..()
		var/list/eye_locations = list()
		for(var/obj/login_screen_locations/location)
			eye_locations += location
		var/obj/login_screen_locations/random_location = pick(eye_locations)
		var/obj/login_eye = new(random_location.loc)
		src.client.eye = login_eye
		src.client.perspective = EYE_PERSPECTIVE
		src.client.screen += new/obj/Logos/Naruto_Evolution

		spawn()
			while(src && !mobs_online.Find(src))
				random_location = pick(eye_locations)
				login_eye.loc = random_location.loc
				sleep(250)

		spawn()
			while(src && !mobs_online.Find(src))
				step_rand(login_eye)
				sleep(3)
			del(login_eye)

	Logout()
		if(!src.key)
			world << "[src.name] has switched mobs."
		..()
		del(src)


	verb/LoginCharacter()
		set hidden = 1
		if(src.client && !mobs_online.Find(src) && !src.client.logging_in)
			src.client.logging_in = 1

			var/character = uppercase(winget(src.client, "Titlescreen.Username", "text"), 1)
			var/password = winget(src.client, "Titlescreen.Password", "text")

			if(!character && !password)
				src.client.prompt("Please enter your character name and password.")
				src.client.logging_in = 0
				return 0
			else if(!character)
				src.client.prompt("Please enter your character name.")
				src.client.logging_in = 0
				return 0
			else if(!password)
				src.client.prompt("Please enter your password.")
				src.client.logging_in = 0
				return 0

			winset(src,"Titlescreen.Password","text=")

			src.Load(character, password)

	proc/LogoutCharacter()
		if(src.client && mobs_online.Find(src))
			for(var/mob/m in mobs_online)
				if(administrators.Find(m.client.ckey) || moderators.Find(m.client.ckey))
					if(clients_multikeying.Find(src.client))
						m << "[src.name] ([src.client.ckey]) <sup>(Multikey)</sup> has logged out."
					else
						m << "[src.name] ([src.client.ckey]) has logged out."
				else
					m << "[src.name] has logged out."

			for(var/obj/Inventory/mission/deliver_intel/o in src.contents) src.DropItem(o, 1, src.loc)

			for(var/obj/O in world) if(O.IsJutsuEffect == src) del(O)

			for(var/mob/M in src.puppets) del(M)

			if(src.multisized)
				src.appearance_flags = PIXEL_SCALE | KEEP_TOGETHER

				var/matrix/m = matrix()
				m.Scale(1,1)
				src.transform = m

				src.bound_height = initial(src.bound_height)
				src.bound_width = initial(src.bound_width)
				src.bound_x = initial(src.bound_x)
				src.layer = initial(src.layer)

			if(src.dueling)
				src.loc = MapLoadSpawn()
				src.opponent.loc = MapLoadSpawn()
				src.opponent.dueling = 0
				arenaprogress = 0
				world<<"[src] has logged out during an Arena challenge. Match has become Null."

			if(Chuunins.Find(src))
				Chuunins -= src
				src.loc = MapLoadSpawn()
				for(var/obj/ChuuninExam/Scrolls/S in src) del(S)

			if(src.village != "Anbu Root")
				for(var/obj/Inventory/Clothing/Robes/Anbu_Suit/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/Masks/Absolute_Zero_Mask/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != RANK_AKATSUKI_LEADER)
				for(var/obj/Inventory/Clothing/Masks/Tobi_Mask/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != RANK_AKATSUKI && src.rank != RANK_AKATSUKI_LEADER)
				for(var/obj/Inventory/Clothing/Robes/Akatsuki_Robe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/HeadWrap/AkatsukiHat/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)



			/*if(src.rank != "ANBU")
				for(var/obj/Inventory/Clothing/Masks/Anbu/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/Masks/Anbu_Black/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/Masks/Anbu_Blue/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/Masks/Anbu_Purple/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)*/

			if(src.rank != "Sage")
				for(var/obj/Inventory/Clothing/Robes/Sage_Robe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != "Hokage")
				for(var/obj/Inventory/Clothing/Robes/HokageRobe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/HeadWrap/HokageHat/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != "Kazekage")
				for(var/obj/Inventory/Clothing/Robes/KazekageRobe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/HeadWrap/KazekageHat/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != "Otokage")
				for(var/obj/Inventory/Clothing/Robes/OtokageRobe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/HeadWrap/OtokageHat/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != "Mizukage")
				for(var/obj/Inventory/Clothing/HeadWrap/MizukageHat/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/Robes/MizukageRobe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			if(src.rank != "Tsuchikage")
				for(var/obj/Inventory/Clothing/HeadWrap/TsuchikageHat/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

				for(var/obj/Inventory/Clothing/Robes/TsuchikageRobe/O in src.contents)
					if(ClothingOverlays[O.section] == O.icon) RemoveSection(O.section)
					del(O)

			for(var/mob/Clones/C in src.Clones)
				del(C)

			var/Faction/c = getFaction(src.Faction)
			if(c)
				c.onlinemembers -= usr
				c.members[rname] = list(key, level, Factionrank)
				usr.verbs -= Factionverbs

			for(var/mob/jutsus/Summon_Spider/A in world)
				if(A.OWNER == src)
					del(A)

			for(var/mob/summonings/SnakeSummoning/B in world)
				if(B.OWNER == src)
					del(B)

			for(var/mob/jutsus/KazekagePuppet/C in world)
				if(C.OWNER == src)
					del(C)

			for(var/mob/summonings/DogSummoning/D in world)
				if(D.OWNER == src)
					del(D)


	proc/AddStarterJutsu()
		for(var/type in typesof(/obj/Jutsus))
			var/obj/Jutsus/jutsu = new type
			if(src && jutsu.starterjutsu)
				jutsu.owner = src.ckey
				src.jutsus += jutsu
				src.jutsus_learned += jutsu.type
				src.sbought += jutsu.name

	verb/CreateCharacter()
		set hidden = 1
		if(src.client && !mobs_online.Find(src) && !src.client.logging_in)
			src.client.logging_in = 1

			src.name = null
			var/list/prompt

			while(src && !src.character)
				prompt = src.client.iprompt("Please choose a character name...")
				src.character = prompt[2]

				if(length(src.character) < 3 || length(src.character) > 20)
					src.client.prompt("Your character name must be between 3 and 20 characters.")
					src.character = null

				else if(uppertext(src.character) == src.character)
					src.client.prompt("Your character name must not consist entirely of capital letters.")
					src.character = null

				else if(ffilter_characters(src.character) != src.character)
					src.client.prompt("\"[src.name]\" contains an invalid character.  Allowed characters are:\n[allowed_characters_name]")
					src.character = null

				else if(names_taken.Find(lowertext(src.character)))
					src.client.prompt("The character name <b>[src.character]</b> is already taken.")
					src.character = null

				sleep(1)

			while(src && !src.password)
				prompt = src.client.iprompt("Please select a password for this account.","Password", mask=1)
				src.password = prompt[2]
				if(length(src.password) < 3)
					src.client.prompt("Password must have atleast 3 characters.")
					src.password = null
				else
					var/list/password_confirmation = src.client.iprompt("Please confirm your password for this account.","Password", mask=1)
					if(src.password != password_confirmation[2])
						src.client.prompt("Your passwords do not match. Please try setting your password again.")
						src.password = null
					else
						src.password_salt = sha1(src.ckey)
						src.password = sha1("[src.password][src.password_salt]")

				sleep(1)

			src.SkinTone = src.client.prompt("Select a skin tone.", "Skin Tone", list("Pale", "White", "Dark", "Blue"))

			while(!src.SkinTone)
				src.SkinTone = src.client.prompt("Select a skin tone.", "Skin Tone", list("Pale", "White", "Dark", "Blue"))
				sleep(10)

			src.ResetBase()

			src.HairStyle = src.client.prompt("Select a hair style.", "Hairstyle", list("Long","Short","Tied Back","Bald","Bowl Cut","Deidara","Spikey","srcohawk","Neji Hair","Distance"))

			if(src.HairStyle != "Bald")
				src.HairColor = src.client.cprompt("What color hair would you like?", "Hair Dye", luminosity_max = 20)

			src.village = src.client.prompt("What village would you like to be born in?", "Village Selection", list(VILLAGE_LEAF, VILLAGE_SAND /*, VILLAGE_MIST, VILLAGE_SOUND, VILLAGE_ROCK*/))
			src.rank = RANK_ACADEMY_STUDENT

			_choosebloodline
			src.known_clans = list()
			switch(src.village)
				if(VILLAGE_LEAF)
					src.Clan = src.client.prompt({"What bloodline clan would you like to be born into?"}, "Clan Selection", list("[CLAN_ABURAME]", "[CLAN_AKIMICHI]", "[CLAN_HYUUGA]", "[CLAN_NARA]", "[CLAN_UCHIHA]", "No Clan"))
					src.known_clans.Add(src.Clan)

				if(VILLAGE_SAND)
					src.Clan = src.client.prompt({"What bloodline clan would you like to be born into?"}, "Clan Selection", list("[CLAN_PUPPET]", "[CLAN_SAND]","[CLAN_IRON]", "No Clan"))
					src.known_clans.Add(src.Clan)

			var/clan_description
			switch(src.Clan)
				if(CLAN_ABURAME)
					clan_description = "At birth a member of the Aburame clan is made host to chakra sensitive insects which reside under the skins surface. It's a symbiotic relationship where you the host provide chakra and the insects will respond as a weapon and tool for your personal use.<br /><br />It's a versatile bloodline with average binds, damage and utility however it is a master of none."
				if(CLAN_AKIMICHI)
					clan_description = "From a young age the Akimichi clan learn to utilize yang chakra to manipulate their bodyweight and size. A fledgeling can enhance their physical prowess but a master can grow to the size of mountains.<br /><br />Akimichi is a bloodline that boasts great defense and utility but with the option to buff their damage at the cost of their own health."
				if(CLAN_HYUUGA)
					clan_description = "The Hyuuga clan utilize the visual powers of the Byakugan which allows them to see the chakra networks of others. This in combination with their long history of precise martial arts makes them a serious threat in close range.<br /><br />Their damage is a bit on the low side but they have great defense and specialise in disabling their opponents chakra points."
				if(CLAN_NARA)
					clan_description = "Masters of shadows, Nara are able to control their own shadow to bind and assault their opponent. Members of this clan are known for their highly intellectual and strategic minds.<br /><br />They specialize in binding a single target to deal huge damage to them but they can provide some utility against groups as well."
				if(CLAN_UCHIHA)
					clan_description = "Members of the Uchiha clan are born with the ability to unlock the Sharingan. The clan has a dark history as to unlock it's full potential requires commiting grievious taboos.<br /><br />Uchiha are masters of all but have high chakra and health costs for their jutsu.<br /><br /><font color= #971e1e>ALL UCHIHA START WITH FIRE AS THEIR FIRST ELEMENT</Font>"
				if(CLAN_PUPPET)
					clan_description = "Master craftsmen capable of weaving their chakra into strings. They use these strings to manipulate puppets in combat.<br /><br />Puppet users boast strong jutsu all-round but require high technical skill to master their use."
				if(CLAN_SAND)
					clan_description = "Users of sand are capable of infusing sand particles with their chakra. They can manipulate this sand to entomb their opponents and protect themselves.<br /><br /> They deal high damage to single targets as well as having great defensive techniques.<br /><br /><font color= #971e1e>ALL SAND USERS START WITH EARTH AS THEIR FIRST ELEMENT</Font>"
				if(CLAN_IRON)
					clan_description = "Users of the Iron Sand control fine iron powder using lightning style magnetism. They can mould the sand into fists to attack or subdue. <br /><br /> They deal good damage with both single and multi-target attacks.<br /><br /><font color= #971e1e>ALL IRON SAND USERS START WITH LIGHTNING AS THEIR FIRST ELEMENT</Font>"
				if("No Clan")
					clan_description = "Not everyone is born into a powerful bloodline. Some must cultivate their own strength through various methods.<br /><br />With no bloodline you will start out with less jutsu than others but you will achieve combinations of jutsu that are otherwise impossible to achieve."

			switch(src.client.prompt({"[clan_description]"}, "[src.Clan]", list("I want this Bloodline.", "Go Back")))
				if("I want this Bloodline.")
					if(src.Clan == CLAN_UCHIHA) src.Element = "Fire"
					if(src.Clan == CLAN_SAND) src.Element = "Earth"
					if(src.Clan == CLAN_IRON) src.Element = "Lightning"
				if("Go Back")
					goto _choosebloodline

			_chooseelement
			if(!Element)
				src.Element = src.client.prompt("Please choose your primary elemental affinity.<br /><br />You will be able to obtain more elements later in the game.", "Elemental Affinity", list("Fire","Water","Wind","Earth","Lightning"))
			
				var/element_description
				switch(src.Element)
					if("Fire")
						element_description = "An offensive element with a primary focus on setting opponents on fire to deal damage over time."
					if("Water")
						element_description = "A balanced element with less focus on damage but good binds and ultility"
					if("Wind")
						element_description = "An offensive element focusing on long range attacks and mobility."
					if("Earth")
						element_description = "A defensive element which has many binds but virtually no damage at all"
					if("Lightning")
						element_description = "An offensive element with fast and difficult to avoid techniques."
				
				switch(src.client.prompt({"[element_description]"}, "[src.Element]", list("I want this Element", "Go Back")))
					if("Go Back")
						goto _chooseelement

			_choosespec
			src.Specialist = src.client.prompt({"What type of techniques do you want to specialize in?"<br /><br />Some jutsu will require a certain specialization to learn them. It will also decrease the total exp required to level the relevant stat to it's maximum value."}, "Combat Specialization", list("[SPECIALIZATION_NINJUTSU]", "[SPECIALIZATION_GENJUTSU]", "[SPECIALIZATION_TAIJUTSU]"))

			var/spec_description
			switch(src.Specialist)
				if(SPECIALIZATION_TAIJUTSU)
					spec_description = "Taijutsu is the mastery of physical strength and martial arts. Taking this will add a kick to your basic attacks increasing your overall hits per second."
				if(SPECIALIZATION_NINJUTSU)
					spec_description = "Ninjutsu is the mastery of chakra control and the elements. Taking this will reduce chakra costs by 15%."
				if(SPECIALIZATION_GENJUTSU)
					spec_description = "Genjutsu is the mastery of disrupting someones chakra to create illusion and discord within their mind. Taking these will also increase how many clones you can create with clone jutsu."

			switch(src.Specialist)
				if(SPECIALIZATION_TAIJUTSU)
					src.taijutsu+=10
				if(SPECIALIZATION_NINJUTSU)
					src.ninjutsu+=10
				if(SPECIALIZATION_GENJUTSU)
					src.genjutsu+=10

			switch(src.client.prompt({"[spec_description]"}, "[src.Specialist]", list("I want this Specialism", "Go Back")))
				if("Go Back")
					goto _choosespec

			for(var/jutsu in typesof(/obj/Jutsus))
				var/obj/Jutsus/j = new jutsu
				if(src && j.starterjutsu)
					j.owner = src.ckey
					src.jutsus += j
					src.jutsus_learned += j.type
					src.sbought += j.name


			src.creation_date = world.realtime
			names_taken += lowertext(src.character)
			src.name = src.character
			src.rname = src.name

			src.pixel_x = -16

			src.RestoreOverlays()
			spawn() src.Run()
			spawn() src.HealthRegeneration()
			spawn() src.WeaponryDelete()

			for(var/obj/Logos/Naruto_Evolution/L in src.client.screen) src.client.screen -= L

			winset(src, null, {"
				Main.NavigationChild.is-visible      = "true";
				Main.OutputChild.is-visible      = "true";
				Main.ActionChild.is-visible      = "true";
				Main.Child.right=Map;
			"})

			src.loc = locate(136,175,7)
			src.dir = NORTH
			src.client.eye = src
			src.client.perspective = MOB_PERSPECTIVE

			clients_online += src.client
			mobs_online += src

			spawn()
				var/database/query/query = new({"
					INSERT INTO `[db_table_character_login]` (`timestamp`, `key`, `character`, `action`, `result`, `reason`)
					VALUES(?, ?, ?, ?, ?, ?)"},
					time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, "login", "success", null
				)
				query.Execute(log_db)
				LogErrorDb(query)

				query.Add({"
					INSERT INTO `[db_table_character_creation]` (`timestamp`, `key`, `character`, `action`)
					VALUES(?, ?, ?, ?)"},
					time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, "create"
				)
				query.Execute(log_db)
				LogErrorDb(query)

			src << world.GetAdvert()

			for(var/mob/m in mobs_online)
				if(administrators.Find(m.client.ckey) || moderators.Find(m.client.ckey))
					if(clients_multikeying.Find(src.client))
						m << "[src.name] ([src.client.ckey]) <sup>(Multikey)</sup> has logged in."
					else
						m << "[src.name] ([src.client.ckey]) has logged in."
				else
					m << "[src] has logged in."

			src << output("<br /><b><u>Basic Controls:</u></b><br><b>A:</b> Attack<br><b>S:</b> Use weapon<br><b>D:</b> Block/Special<br><b>1</b>,<b>2</b>,<b>3</b>,<b>4</b>,<b>5</b>,<b>Q</b>,<b>W</b>,<b>E:</b> Handseals<br><b>Space:</b> Execute handseals<br><b>Arrows:</b> Move<br><b>F1 - F10:</b> Hotslots<br><b>R:</b> Recharge chakra<br><b>I:</b> Inventory<br><b>O:</b> Statpanel<br><b>P:</b> Jutsus<br>Press the <b>\[Enter]</b> key to talk. Type <i>/help</i> to view commands that can be spoken verbally.<br />","Action.Output")
			src << "Now speaking in channel: [src.client.channel]."

			spawn() src.client.StaffCheck()

			if(global.hokage_election)
				src << output("A <font color = '[COLOR_VILLAGE_LEAF]'>[RANK_HOKAGE]</font> election is currently in-progress.", "Action.Output")

				if(global.hokage_ballot_open)
					src << output("The <font color = '[COLOR_VILLAGE_LEAF]'>[RANK_HOKAGE]</font> election is currently <u>open ballot</u>.", "Action.Output")
					src << output("You may nominate yourself at the <font color = '[COLOR_VILLAGE_LEAF]'>Leaf Ballot Secretary</font> in the <font color = '[COLOR_VILLAGE_LEAF]'>[RANK_HOKAGE]</font> house.", "Action.Output")

				src << output("Ninja from the <font color = '[COLOR_VILLAGE_LEAF]'>[VILLAGE_LEAF]</font> village may cast their vote at their ballot box in the <font color = '[COLOR_VILLAGE_LEAF]'>[RANK_HOKAGE]</font> house.", "Action.Output")

			if(global.kazekage_election)
				src << output("A <font color = '[COLOR_VILLAGE_SAND]'>[RANK_KAZEKAGE]</font> election is currently in-progress.", "Action.Output")

				if(global.kazekage_ballot_open)
					src << output("The <font color = '[COLOR_VILLAGE_SAND]'>[RANK_KAZEKAGE]</font> election is currently <u>open ballot</u>.", "Action.Output")
					src << output("You may nominate yourself at the <font color = '[COLOR_VILLAGE_SAND]'>Sand Ballot Secretary</font> in the <font color = '[COLOR_VILLAGE_SAND]'>[RANK_KAZEKAGE]</font> house.", "Action.Output")

				src << output("Ninja from the <font color = '[COLOR_VILLAGE_SAND]'>[VILLAGE_SAND]</font> village may cast their vote at their ballot box in the <font color = '[COLOR_VILLAGE_SAND]'>[RANK_KAZEKAGE]</font> house.", "Action.Output")

			world.UpdateVillageCount()

			spawn() src.client.UpdateWhoAll()

			new/obj/Screen/Bar(src)
			switch(src.village)
				if("Hidden Leaf") new/obj/Screen/LeafSymbol(src)
				if("Hidden Sand") new/obj/Screen/SandSymbol(src)
				if("Hidden Mist") new/obj/Screen/MistSymbol(src)
				if("Hidden Sound") new/obj/Screen/SoundSymbol(src)
				if("Hidden Rock") new/obj/Screen/RockSymbol(src)
				if("Missing-Nin") new/obj/Screen/MissingSymbol(src)
				if("Akatsuki") new/obj/Screen/AkatsukiSymbol(src)
				if("Seven Swordsmen") new/obj/Screen/SsmSymbol(src)
				if("Anbu Root") new/obj/Screen/AnbuSymbol(src)
			new/obj/Screen/WeaponSelect(src)
			new/obj/Screen/Health(src)
			new/obj/Screen/Chakra(src)
			new/obj/Screen/EXP(src)
			new/obj/HotSlots/HotSlot1(src)
			new/obj/HotSlots/HotSlot2(src)
			new/obj/HotSlots/HotSlot3(src)
			new/obj/HotSlots/HotSlot4(src)
			new/obj/HotSlots/HotSlot5(src)
			new/obj/HotSlots/HotSlot6(src)
			new/obj/HotSlots/HotSlot7(src)
			new/obj/HotSlots/HotSlot8(src)
			new/obj/HotSlots/HotSlot9(src)
			new/obj/HotSlots/HotSlot10(src)
			new/obj/HotSlots/HotSlot11(src)
			new/obj/HotSlots/HotSlot12(src)
			new/obj/HotSlots/HotSlot13(src)
			new/obj/HotSlots/HotSlot14(src)
			new/obj/HotSlots/HotSlot15(src)
			new/obj/HotSlots/HotSlot16(src)
			new/obj/HotSlots/HotSlot17(src)
			new/obj/HotSlots/HotSlot18(src)
			var/obj/O=new/obj/Screen/healthbar
			var/obj/Mana=new/obj/Screen/manabar
			src.hbar.Add(O)
			src.hbar.Add(Mana)
			for(var/obj/Screen/healthbar/HB in src.hbar) src.overlays+=HB
			for(var/obj/Screen/manabar/HB in src.hbar) src.overlays+=HB

			for(var/obj/Screen/WeaponSelect/H in src.client.screen)
				switch(src.equipped)
					if("Kunais") H.icon_state="kunai"
					if("ExplodeKunais") H.icon_state="expl kunai"
					if("Shurikens") H.icon_state="shuriken"
					if("Needles") H.icon_state="needle"
					if("ExplosiveTags") H.icon_state="tag"
					if("SmokeBombs") H.icon_state="SmokeBombs"
					if("FoodPill") H.icon_state="Blood Pill"

			spawn() src.UpdateHMB()

			if(src.client.prompt("Do you wish to skip the tutorial? Only do this if you are familiar with the game. If you skip this you can't come back without making a new account.", "Skip Tutorial?", list("Yes", "No")) == "Yes")
				src.Tutorial = 7
				var/obj/Jutsus/jutsu = new/obj/Jutsus/BodyReplace
				src.sbought += jutsu.name
				src.jutsus.Add(jutsu)
				src.jutsus_learned.Add(jutsu.type)
				jutsu.owner = src.ckey
				src.skillpoints--
				src.loc=src.MapLoadSpawn()
			
			winset(usr , null , "command = .reconnect")

	proc/Playtime()
		while(src)
			if(mobs_online.Find(src)) src.playtime++
			sleep(10)

	verb
		Say(msg as text)
			set hidden=1
			winset(src, null, {"
				Map.Main.focus = "true";
				Main.InputChild.is-visible = false;
			"})

			var/message_trim

			if(!msg) return

			if(src.Muted)
				src << "You are currently muted."
				return

			else if(length(msg) > 600)
				message_trim = copytext(msg, 600)
				msg = copytext(msg, 1, 600)

			if(msg == "/restore-base")
				spawn() src.client.prompt("Your character base and overlays will be restored in 60 seconds.", "Naruto Evolution")
				sleep(600)
				if(src)
					for(var/obj/Inventory/Clothing/o in src.contents)
						o.suffix = ""

					src.ClothingOverlays = list("Vest"=null,"Shirt"=null,"Pants"=null,"Shoes"=null,"Mask"=null,"Headband"=null,"Sword"=null,"Gloves"=null,"Accessories"=null,"Robes"=null)
					src.ResetBase()
					src.RestoreOverlays()
					src.client.UpdateInventoryPanel()
					src.move_delay = max(0.5, 0.8-((src.agility_total/200)*0.3))

				return 0

			else if(msg == "/version")
				spawn() src.client.prompt("<b>Naruto Evolution:</b> v[global.build]<br /><b>BYOND Server:</b> v[world.byond_version].[world.byond_build]<br /><b>BYOND Client:</b> v[src.client.byond_version].[src.client.byond_build]", "Version Information")
				return
			
			else if(msg == "/leave-village")
				src.LeaveVillage()
				return

			var/command = "/level "
			var/command_alias = ""
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.level = value
				src.UpdateHMB()
				return

			command = "/experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.exp = value
				src.UpdateHMB()
				return

			command = "/max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxexp = value
				src.UpdateHMB()
				return

			command = "/health "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.health = value
				src.UpdateHMB()
				return

			command = "/max-health "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxhealth = value
				src.UpdateHMB()
				return

			command = "/chakra "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.chakra = value
				src.UpdateHMB()
				return

			command = "/max-chakra "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxchakra = value
				src.UpdateHMB()
				return

			command = "/ninjutsu "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.ninjutsu = value
				src.UpdateHMB()
				return

			command = "/genjutsu "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.genjutsu = value
				src.UpdateHMB()
				return

			command = "/taijutsu "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.taijutsu = value
				src.UpdateHMB()
				return

			command = "/precision "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.precision = value
				src.UpdateHMB()
				return

			command = "/defense "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.defence = value
				src.UpdateHMB()
				return

			command = "/agility "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.agility = value
				src.UpdateHMB()
				return

			command = "/ninjutsu-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.ninexp = value
				src.UpdateHMB()
				return

			command = "/ninjutsu-max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxninexp = value
				src.UpdateHMB()
				return

			command = "/genjutsu-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.genexp = value
				src.UpdateHMB()
				return

			command = "/genjutsu-max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxgenexp = value
				src.UpdateHMB()
				return

			command = "/taijutsu-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.taijutsuexp = value
				src.UpdateHMB()
				return

			command = "/taijutsu-max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxtaijutsuexp = value
				src.UpdateHMB()
				return

			command = "/precision-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.precisionexp = value
				src.UpdateHMB()
				return

			command = "/precision-max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxprecisionexp = value
				src.UpdateHMB()
				return

			command = "/defense-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.defexp = value
				src.UpdateHMB()
				return

			command = "/defense-max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxdefexp = value
				src.UpdateHMB()
				return

			command = "/agility-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.agilityexp = value
				src.UpdateHMB()
				return

			command = "/agility-max-experience "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.maxagilityexp = value
				src.UpdateHMB()
				return

			command = "/statpoints "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.statpoints = value
				src.UpdateHMB()
				return

			command = "/skillpoints "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.skillpoints = value
				src.UpdateHMB()
				return

			command = "/infamy "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.infamy_points = value
				return

			command = "/density"
			if(msg == command && administrators.Find(src.client.ckey))

				src.density = src.density ? 0 : 1
				return

			command = "/invisibility "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.invisibility = value
				return

			command = "/see-invisibility "
			if(findtext(msg, command) && administrators.Find(src.client.ckey))

				var/value = text2num(copytext(msg, findtext(msg, command) + length(command)))
				if(value != null) src.see_invisible = value
				return

			command = "/teleport "
			command_alias = "/tp "
			if(findtext(msg, command) || findtext(msg, command_alias) && administrators.Find(src.client.ckey) || moderators.Find(src.client.ckey))

				var/value = copytext(msg, findtext(msg, command) + length(command))
				if(findtext(msg, command_alias)) value = copytext(msg, findtext(msg, command_alias) + length(command_alias))
				if(value)
					for(var/mob/m in mobs_online)
						if(lowertext(m.character) == lowertext(value))
							src.loc = m.loc
							return

					for(var/mob/m in mobs_online)
						if(findtext(lowertext(m.character), lowertext(value)))
							src.loc = m.loc
							return

					for(var/mob/m in npcs_online)
						if(lowertext(m.name) == lowertext(value))
							src.loc = m.loc
							return

					for(var/mob/m in npcs_online)
						if(findtext(lowertext(m.name), lowertext(value)))
							src.loc = m.loc
							return

				src << "/teleport: A mob was not found matching the string \"[value]\"."
				return

			command = "/teleport"
			command_alias = "/tp"
			if(findtext(msg, command) || findtext(msg, command_alias) && administrators.Find(src.client.ckey) || moderators.Find(src.client.ckey))
				return src.TeleportCommand()
			
			command = "/summon "
			if(findtext(msg, command) && administrators.Find(src.client.ckey) || moderators.Find(src.client.ckey))

				var/value = copytext(msg, findtext(msg, command) + length(command))
				if(value)
					for(var/mob/m in mobs_online)
						if(lowertext(m.character) == lowertext(value))
							m.loc = src.loc
							return

					for(var/mob/m in mobs_online)
						if(findtext(lowertext(m.character), lowertext(value)))
							m.loc = src.loc
							return

					for(var/mob/m in npcs_online)
						if(lowertext(m.name) == lowertext(value))
							m.loc = src.loc
							return

					for(var/mob/m in npcs_online)
						if(findtext(lowertext(m.name), lowertext(value)))
							m.loc = src.loc
							return

					for(var/obj/Inventory/o in world)
						if(o && o.id == text2num(value))
							if(o in src.contents)
								src << "/summon: [o] is already located in your inventory."
								return

							src.RecieveItem(o, o.loc)
							return

				src << "/summon: A mob or item id was not found with the matching the string \"[value]\"."
				return

			command = "/summon"
			if(findtext(msg, command) && administrators.Find(src.client.ckey) || moderators.Find(src.client.ckey))
				return src.SummonCommand()
			
			command = "/profile"
			if(findtext(msg, command) && administrators.Find(src.client.ckey))
				winset(usr , null , "command = .profile")
				return

			else if(findtext(msg, "/stuck"))
				src.Stuck()
				return

			else if(findtext(msg, "/mute"))
				src.Vote_Mute()
				return

			else if(findtext(msg, "/boot"))
				src.Vote_Boot()
				return

			else if(findtext(msg, "/world"))
				src << output("World Address: byond://[world.internet_address]:[world.port]", "Action.Output")
				return

			else if(findtext(msg, "/help"))
				src.Help()
				return

			else
				var/obj/Symbols/Village/village = new(src)
				var/obj/Symbols/Rank/rank = new(src)
				var/obj/Symbols/Role/role = new(src)
				var/badges = ""
				if(role.icon) badges += "\icon[role] "
				if(village.icon) badges += "\icon[village]"
				if(rank.icon) badges += " \icon[rank]"

				var/whisper = winget(src, "InputPanel.WhisperInput", "text")
				if(whisper)
					if(src.character == whisper)
						src << "You cannot whisper to yourself. Try speaking in global chat to make some new friends."
						return

					var/whisper_target_online = 0
					for(var/mob/M in mobs_online)
						if(whisper == M.character)
							src << "<font color='[COLOR_CHAT]'>\[W]</font> [badges] <font color='[src.name_color]'>[src.character]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>"
							M << "<font color='[COLOR_CHAT]'>\[W]</font> [badges] <font color='[src.name_color]'>[src.character]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>"

							spawn()
								var/database/query/query = new({"
									INSERT INTO `[db_table_chat_whisper]` (`timestamp`, `key`, `character`, `identity`, `village`, `faction` `recipient_key`, `recipient_character`, `recipient_identity`, `recipient_village`, `recipient_faction`, `message`)
									VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"},
									time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, M.key, M.character, M.name, M.village, M.Faction, msg
								)
								query.Execute(log_db)
								LogErrorDb(query)

							whisper_target_online = 1
							break

					if(!whisper_target_online)
						src << "You cannot whisper <i>[whisper]</i> because they're no longer online or the character doesn't exist."

				else if(src.likeaclone)
					if(src.client.channel == "Local")
						var/mob/clone = src.likeaclone
						view(clone) << ffilter("[badges] <font color='[clone.name_color]'>[clone.name]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>")

						spawn()
							var/database/query/query = new({"
								INSERT INTO `[db_table_chat_local]` (`timestamp`, `key`, `character`, `identity`, `village`, `faction`, `message`)
								VALUES(?, ?, ?, ?, ?, ?, ?)"},
								time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, msg
							)
							query.Execute(log_db)
							LogErrorDb(query)
					else
						src << "Clones can only speak within the say channel."

				else
					switch(src.client.channel)
						if("Local")
							view() << ffilter("[badges] <font color='[src.name_color]'>[src.name]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>")

							spawn()
								var/database/query/query = new({"
									INSERT INTO `[db_table_chat_local]` (`timestamp`, `key`, `character`, `identity`, `village`, `faction`, `message`)
									VALUES(?, ?, ?, ?, ?, ?, ?)"},
									time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, msg
								)
								query.Execute(log_db)
								LogErrorDb(query)

						if("Village")
							for(var/mob/M in mobs_online)
								if(src.village == M.village || administrators.Find(M.client.ckey))
									M << ffilter("<font color='yellow'>\[V]</font> [badges] <font color='[src.name_color]'>[src.name]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>")
							
							spawn()
								var/database/query/query = new({"
									INSERT INTO `[db_table_chat_village]` (`timestamp`, `village`, `key`, `character`, `identity`, `village`, `faction`, `message`)
									VALUES(?, ?, ?, ?, ?, ?, ?, ?)"},
									time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, msg
								)
								query.Execute(log_db)

						if("Squad")
							var/squad/squad = src.GetSquad()
							if(squad)
								for(var/mob/M in mobs_online)
									if(squad && squad == M.GetLeader() || squad.members.Find(M.ckey) || administrators.Find(M.client.ckey))
										M << ffilter("<font color='white'>\[S]</font> [badges] <font color='[src.name_color]'>[src.name]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>")
								
								spawn()
									var/database/query/query = new({"
										INSERT INTO `[db_table_chat_squad]` (`timestamp`, `squad`, `key`, `character`, `identity`, `village`, `faction`, `message`)
										VALUES(?, ?, ?, ?, ?, ?, ?, ?)"},
										time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, msg
									)
									query.Execute(log_db)
									LogErrorDb(query)
							else
								src << "You cannot speak in the squad channel because you are not currently in a squad."

						if("Faction")
							if(src.Faction)
								var/Faction/F = src.Faction
								for(var/mob/M in mobs_online)
									if(src.Faction == M.Faction || administrators.Find(M.client.ckey))
										M << ffilter("<font color='[F.color]'>\[F] [F.name]</font> [badges] <font color='[src.name_color]'>[src.name]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>")
								
								spawn()
									var/database/query/query = new({"
										INSERT INTO `[db_table_chat_faction]` (`timestamp`, `key`, `character`, `identity`, `village`, `faction`, `message`)
										VALUES(?, ?, ?, ?, ?, ?, ?)"},
										time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, msg
									)
									query.Execute(log_db)
									LogErrorDb(query)

							else
								src << "You cannot speak in the faction channel because you are not currently in a faction."

						if("Global")
							if(worldmute)
								src << "You cannot speak in the global channel because it is currently muted."
							else
								world << ffilter("<font color='red'>\[G]</font> [badges] <font color='[src.name_color]'>[src.name]</font><font color='[COLOR_CHAT]'>: [html_encode(msg)]</font>")

								spawn()
									var/database/query/query = new({"
										INSERT INTO `[db_table_chat_global]` (`timestamp`, `key`, `character`, `identity`, `village`, `faction`, `message`)
										VALUES(?, ?, ?, ?, ?, ?, ?)"},
										time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"), src.client.ckey, src.character, src.name, src.village, src.Faction, msg
									)
									query.Execute(log_db)
									LogErrorDb(query)

				if(message_trim)
					src << "Your message was longer than 1000 characters and has been trimmed."
					src << "The following text was trimmed:"
					src << message_trim

		Create_Ryo_Pouch()
			set hidden = 1
			if(!src.ryo)
				src << output("You don't have any Ryo to create a Ryo Pouch.", "Action.Output")
			else
				var/list/response = src.client.iprompt("How much Ryo would you like to bundle in a Ryo Pouch?","Create Ryo Pouch")
				var/ryo = text2num(response[2])
				if(ryo)
					if(ryo > 0)
						if(src.ryo >= ryo)
							src.ryo -= ryo
							new/obj/Inventory/ryo_pouch(src, ryo)
							view() << "<i>[src] removes [ryo] Ryo from their satchel and bundles it into a Ryo Pouch.</i>"
							src.client.UpdateInventoryPanel()
						else
							src << output("You don't have [ryo] Ryo to drop.", "Action.Output")
					else 
						usr.client.prompt("As you try to put imaginary ryo into a pouch you're very dissapointed as it's still empty. You can't put negative amounts into a ryo pouch.", "Ryo Pouch")

		Rotate_Ninja_Tool()
			set name = "Rotate Ninja Tools"
			set category = "keybindable"
			set hidden = 1
			var/list/weaponry = list()
			for(var/obj/Inventory/Weaponry/o in src.contents)
				if(istype(o, /obj/Inventory/Weaponry/Kunai))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

				if(istype(o, /obj/Inventory/Weaponry/Exploding_Kunai))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

				if(istype(o, /obj/Inventory/Weaponry/Shuriken))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

				if(istype(o, /obj/Inventory/Weaponry/Needle))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

				if(istype(o, /obj/Inventory/Weaponry/Explosive_Tag))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

				if(istype(o, /obj/Inventory/Weaponry/Smoke_Bomb))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

				if(istype(o, /obj/Inventory/Weaponry/Food_Pill))
					if(!weaponry.Find(o)) weaponry.Add(o)
					else continue

			if(!src.ninja_tool_selection && weaponry.len)
				src.ninja_tool_selection = 1

			else if(src.ninja_tool_selection < weaponry.len)
				src.ninja_tool_selection++

			else if(weaponry.len)
				src.ninja_tool_selection = 1

			else
				src.ninja_tool_selection = 0

			if(src.ninja_tool_selection)
				var/obj/Inventory/Weaponry/o = weaponry[src.ninja_tool_selection]
				o.Click(src)

mob
	proc
		SetVillage(var/village)
			if(village)
				src.village = village
				if(village == VILLAGE_MISSING_NIN) src.rank = ""
				src.SetName(src.name)
				src.client.UpdateCharacterPanel()

		checkRank()
			switch(src.rank)
				if(RANK_ACADEMY_STUDENT) return 0
				if(RANK_GENIN) return 1
				if(RANK_CHUUNIN) return 2
				if(RANK_JOUNIN) return 3
				if(RANK_ANBU) return 4
				if(RANK_ANBU_LEADER) return 5
				if(RANK_HOKAGE) return 5
				if(RANK_KAZEKAGE) return 5
				if(RANK_MIZUKAGE) return 5
				if(RANK_OTOKAGE) return 5
				if(RANK_TSUCHIKAGE) return 5
				if(RANK_AKATSUKI) return 4
				if(RANK_AKATSUKI_LEADER) return 5
				if(RANK_SEVEN_SWORDSMEN_LEADER) return 5

		SetRank(var/RANK)
			if(RANK)
				if(RANK != RANK_AKATSUKI_LEADER)
					for(var/obj/Inventory/Clothing/Masks/Tobi_Mask/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_AKATSUKI || RANK != RANK_AKATSUKI_LEADER)
					for(var/obj/Inventory/Clothing/HeadWrap/AkatsukiHat/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

					for(var/obj/Inventory/Clothing/Robes/Akatsuki_Robe/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_HOKAGE)
					for(var/obj/Inventory/Clothing/HeadWrap/HokageHat/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

					for(var/obj/Inventory/Clothing/Robes/HokageRobe/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_KAZEKAGE)
					for(var/obj/Inventory/Clothing/HeadWrap/KazekageHat/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

					for(var/obj/Inventory/Clothing/Robes/KazekageRobe/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_TSUCHIKAGE)
					for(var/obj/Inventory/Clothing/HeadWrap/TsuchikageHat/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

					for(var/obj/Inventory/Clothing/Robes/TsuchikageRobe/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_MIZUKAGE)
					for(var/obj/Inventory/Clothing/HeadWrap/MizukageHat/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

					for(var/obj/Inventory/Clothing/Robes/MizukageRobe/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_OTOKAGE)
					for(var/obj/Inventory/Clothing/HeadWrap/OtokageHat/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

					for(var/obj/Inventory/Clothing/Robes/OtokageRobe/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				if(RANK != RANK_ANBU)
					for(var/obj/Inventory/Clothing/Masks/o in src.contents)
						if(src.ClothingOverlays[o.section] == o.icon)
							RemoveSection(o.section)
						o.loc = null

				switch(RANK)
					if(RANK_AKATSUKI_LEADER)
						akatsuki_leader[src.ckey] = src.character
						akatsuki_last_online = world.realtime

						if(!locate(/obj/Inventory/Clothing/Masks/Tobi_Mask) in src.contents)
							new /obj/Inventory/Clothing/Masks/Tobi_Mask(src)
						if(!locate(/obj/Inventory/Clothing/HeadWrap/AkatsukiHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/AkatsukiHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/Akatsuki_Robe) in src.contents)
							new /obj/Inventory/Clothing/Robes/Akatsuki_Robe(src)

					if(RANK_AKATSUKI)
						if(!locate(/obj/Inventory/Clothing/HeadWrap/AkatsukiHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/AkatsukiHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/Akatsuki_Robe) in src.contents)
							new /obj/Inventory/Clothing/Robes/Akatsuki_Robe(src)

					if(RANK_HOKAGE)
						hokage = list()
						hokage[src.ckey] = src.character
						kages_last_online[VILLAGE_LEAF] = world.realtime

						if(!locate(/obj/Inventory/Clothing/HeadWrap/HokageHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/HokageHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/HokageRobe) in src.contents)
							new /obj/Inventory/Clothing/Robes/HokageRobe(src)

					if(RANK_KAZEKAGE)
						kazekage = list()
						kazekage[src.ckey] = src.character
						kages_last_online[VILLAGE_SAND] = world.realtime

						if(!locate(/obj/Inventory/Clothing/HeadWrap/KazekageHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/KazekageHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/KazekageRobe) in src.contents)
							new /obj/Inventory/Clothing/Robes/KazekageRobe(src)

					if(RANK_TSUCHIKAGE)
						kages_last_online[VILLAGE_ROCK] = world.realtime

						if(!locate(/obj/Inventory/Clothing/HeadWrap/TsuchikageHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/TsuchikageHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/TsuchikageRobe) in src.contents)
							new /obj/Inventory/Clothing/Robes/TsuchikageRobe(src)

					if(RANK_MIZUKAGE)
						kages_last_online[VILLAGE_MIST] = world.realtime

						if(!locate(/obj/Inventory/Clothing/HeadWrap/MizukageHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/MizukageHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/MizukageRobe) in src.contents)
							new /obj/Inventory/Clothing/Robes/MizukageRobe(src)

					if(RANK_OTOKAGE)
						kages_last_online[VILLAGE_SOUND] = world.realtime

						if(!locate(/obj/Inventory/Clothing/HeadWrap/OtokageHat) in src.contents)
							new /obj/Inventory/Clothing/HeadWrap/OtokageHat(src)
						if(!locate(/obj/Inventory/Clothing/Robes/OtokageRobe) in src.contents)
							new /obj/Inventory/Clothing/Robes/OtokageRobe(src)

					if(RANK_ANBU)
						switch(src.village)
							if(VILLAGE_LEAF)
								if(!locate(/obj/Inventory/Clothing/Masks/Anbu) in src.contents)
									new /obj/Inventory/Clothing/Masks/Anbu(src)

							if(VILLAGE_SAND)
								if(!locate(/obj/Inventory/Clothing/Masks/Anbu_Black) in src.contents)
									new /obj/Inventory/Clothing/Masks/Anbu_Black(src)

							if(VILLAGE_ROCK)
								if(!locate(/obj/Inventory/Clothing/Masks/Anbu_Brown) in src.contents)
									new /obj/Inventory/Clothing/Masks/Anbu_Brown(src)

							if(VILLAGE_MIST)
								if(!locate(/obj/Inventory/Clothing/Masks/Anbu_Blue) in src.contents)
									new /obj/Inventory/Clothing/Masks/Anbu_Blue(src)

							if(VILLAGE_SOUND)
								if(!locate(/obj/Inventory/Clothing/Masks/Anbu_Purple) in src.contents)
									new /obj/Inventory/Clothing/Masks/Anbu_Purple(src)

					if(RANK_GENIN)
						switch(src.village)
							if(VILLAGE_LEAF)
								if(!locate(/obj/Inventory/Clothing/HeadWrap/LeafHeadBand) in src.contents)
									new/obj/Inventory/Clothing/HeadWrap/LeafHeadBand(src)

							if(VILLAGE_SAND)
								if(!locate(/obj/Inventory/Clothing/HeadWrap/SandHeadBand) in src.contents)
									new/obj/Inventory/Clothing/HeadWrap/SandHeadBand(src)

							if(VILLAGE_ROCK)
								if(!locate(/obj/Inventory/Clothing/HeadWrap/RockHeadBand) in src.contents)
									new/obj/Inventory/Clothing/HeadWrap/RockHeadBand(src)

							if(VILLAGE_MIST)
								if(!locate(/obj/Inventory/Clothing/HeadWrap/LeafHeadBand) in src.contents)
									new/obj/Inventory/Clothing/HeadWrap/MistHeadBand(src)

							if(VILLAGE_SOUND)
								if(!locate(/obj/Inventory/Clothing/HeadWrap/SoundHeadBand) in src.contents)
									new/obj/Inventory/Clothing/HeadWrap/SoundHeadBand(src)


				src.rank = RANK

				spawn() src.client.UpdateCharacterPanel()
				spawn() src.client.UpdateInventoryPanel()

		SetRyo(var/ryo)
			if(ryo)
				for(var/obj/Inventory/ryo_pouch/pouch in src.contents)
					ryo += pouch.ryo
					pouch.loc = null

				if(ryo < 0) ryo = 0
				src.ryo = ryo
				src.client.UpdateInventoryPanel()

		HealthRegeneration()
			while(src)
				if(!CheckState(src, new/state/cant_attack) && !CheckState(src, new/state/cant_attack))
					if(src.tenacity  > 0)
						src.tenacity -= 1
					else if(src.tenacity < 0)
						src.tenacity = 0
				if(src.last_damage_taken_time + 30 < world.timeofday)
					if(src.Gates == null && src.healthregenmod < 1) src.healthregenmod = 1
					if(src.rest) src.healthregenmod += 2
					src.health += round((src.maxhealth/100) * src.healthregenmod)
					src.health = min(src.health, src.maxhealth)
					if(src.chakra >= src.maxchakra) src.chakra = src.maxchakra
					else src.chakra += round(src.maxchakra/200)
					if(src.rest) src.healthregenmod -= 2
					spawn() src.UpdateHMB()
					spawn() src.client.UpdateStatTotals()
				sleep(10)

		Respawn()
			if(!src.revived)
				var/list/Spawns=RespawnSpawn()
				if(!Spawns.len) src.loc=locate(1,1,4)
				else src.loc=pick(src.RespawnSpawn())
			else src.revived=0

			src.dead=0
			src.density=1
			src.health=src.maxhealth
			src.chakra=src.maxchakra
			src.icon_state=""
			src.wait=0
			src.rest=0
			src.dodge=0
			src.overlays=0
			src.RestoreOverlays()

			RemoveState(src, new/state/water_walking, STATE_REMOVE_ALL)
			RemoveState(src, new/state/swimming, STATE_REMOVE_ALL)
			RemoveState(src, new/state/cant_attack, STATE_REMOVE_ALL)
			RemoveState(src, new/state/cant_move, STATE_REMOVE_ALL)
			
			spawn() src.UpdateHMB()
			spawn() src.Run()
			revived=0

proc
	DamageOverlay(mob/M, damage, color, outline=1)
		var/obj/O = locate() in damage_number_pool
		if(O)
			damage_number_pool-=O
			O.loc=M.loc
		else
			O=new(M.loc)

		O.layer = EFFECTS_LAYER
		O.maptext_width = 128
		O.maptext_height = 128
		O.pixel_y = 70
		O.pixel_x = (M.bound_width - O.maptext_width) / 2 + M.bound_x
		O.maptext = "<span style=\"-dm-text-outline: [outline]px black; color: [color]; font-family: 'Open Sans'; font-weight: bold; text-align: center; vertical-align: bottom;\">[damage]</span>"
		O.alpha = 255

		sleep(1)
		animate(O, alpha = 0, pixel_y = 102, time = 5)

		spawn(15)
			O.loc=null
			damage_number_pool += O
