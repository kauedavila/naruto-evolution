mob/var/tmp/list/Effects=list()
mob/var/list/known_clans = list()
mob
	var
		exp_locked=0
		health=2500
		maxhealth=2500
		chakra=1800
		maxchakra=1800
		prestigelevel
		level=1
		exp=0
		maxexp=10
		statpoints_spent = 0

		ninjutsu = 1 						//NINJUTSU STATS
		ninjutsu_stated = 0
		ninexp=0
		maxninexp=100
		tmp/ninjutsu_total = 0
		tmp/ninjutsu_buffed = 0


		genjutsu = 1						//GENJUTSU STATS
		genjutsu_stated = 0
		tmp/genjutsu_total = 0
		tmp/genjutsu_buffed = 0
		genexp=0
		maxgenexp=100

		taijutsu = 1						//TAIJUTSU STATS
		taijutsu_stated = 0
		tmp/taijutsu_total = 0
		tmp/taijutsu_buffed = 0
		taijutsuexp=0
		maxtaijutsuexp=100

		defence=1							//DEFENCE STATS
		defence_stated = 0
		tmp/defence_total = 0
		tmp/defence_buffed = 0
		defexp=0
		maxdefexp=100

		agility=1							//AGILITY STATS
		agility_stated = 0
		agilityexp=0
		maxagilityexp=100
		tmp/agility_total = 0
		tmp/agility_buffed = 0

		precision=1							//PRECISION STATS
		precision_stated = 0
		precisionexp=0
		maxprecisionexp=100
		tmp/precision_total = 0
		tmp/precision_buffed = 0

		tmp/left_iron_fist
		tmp/right_iron_fist
		tmp/left_iron_fist_anchor
		tmp/right_iron_fist_anchor

		editing=0
		statpoints=0
		skillpoints=1
		kills=0
		village = ""
		rank = ""
		dead=0
		waterwalk
		mountainwalk
		mountainkit=1
		attkspeed=8
		weaponattk
		Element
		Element2
		Element3
		Element4
		Element5
		Kekkai
		Clan
		Clan2 = "No Clan"
		Specialist="strength"
		Specialist2
		ryo=0
		RyoBanked=0
		riconstate
		ricon
		rname
		Muted=0
		skiptut=0
		JashinSacrifices=0
		exp_reward = 0
		last_damage_taken_time
		last_hotspring_time
		hotspring_minutes = 0
		infamy_points = 0
		tmp
			AFK=0
			tenacity
			BeingThrown
			ThrowingMob
			Bugreported=0
			combo=0
			turfover
			likeaclone
			cranks
			arrow
			obj/ArrowTasked
			takeova
			amounthits=0
			screen_moved=0
			smokebomb
			Linkage
			byakugan=0
			burn=0
			laststep
			henge=0
			stepcounter=0
			wait
			rest=0
			fightlayer="Normal"
			respawntime=0
			mob/Owner
			controller
			defend=0
			dodge=0
			turf/mark
			turf/mark2
			kawarmi=0
			dashable=0
			Hand="Left"
			foot="Left"
			speeddelay=0
			speeding=0
			waterlow=0
			waterhigh=0
			snowlow=0
			infusing=0//chakrainfusionstuff
			bubbled=0//bubbleshieldstuff
			multisized=0//multisizestuff
			multisizestomp=0
			inshadowfield=0//shadowfieldstuff
			lungecounter=0
			sleephits=0
			ftgmarked=0
			ftgkunai=null
			healthregenmod=1
			dashcd=0
			foodpillcd=0
			dummylocation=0
			tagcd=0
var
	clonesturned=0
	worldmute=0
obj
	var
		health=100
		maxhealth=100
		level=1
		exp=0
		maxexp=100
		clan
		Owner
		tmp
			fightlayer="Normal"
			shootoverable
			Hit
			damage=0
			Linkage
			dead=0
turf
	var
		tmp
			fightlayer="Normal"