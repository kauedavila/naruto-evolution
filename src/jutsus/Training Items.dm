obj
	Training
		var/Good=1
		Hengable=1
		LogT
			icon='MiscEffects.dmi'
			icon_state="logt"
			iconstateset="logt"
			name="Log"
			layer=MOB_LAYER+2
			pixel_y=32
		LogB
			icon='MiscEffects.dmi'
			icon_state="logb"
			iconstateset="logb"
			name="Log"
			health=1000
			maxhealth=1000
			density=1
			New()
				..()
				src.overlays+=/obj/MiscEffects/LogT/
		LogBB
			icon='MiscEffects.dmi'
			icon_state="logb"
			iconstateset="logb"
			name="Log"
			health=300
			maxhealth=300
			Good=0
			density=1
			New()
				..()
				src.overlays+=/obj/MiscEffects/LogT/
		BDLogB
			icon='MiscEffects.dmi'
			icon_state="logb"
			iconstateset="logb"
			name="Log"
			health=20
			maxhealth=20
			hitsound='crashwood.wav'
			density=1
			New()
				..()
				src.overlays+=/obj/MiscEffects/LogT/
				spawn(80)if(src)del(src)
obj
	var
		tmp
			iconstateset
	proc
		Break(mob/X)
			if(src.health<=0&&src.dead==0)
				X.loc=src.loc
				src.density=0
				//if(istype(src,/obj/Training/LogB))
				src.health=0
				src.dead=1
				src.PlayAudio(src.hitsound, output = AUDIO_HEARERS)
				src.overlays=0
				flick("[src.name]break",src)
				spawn(7)
					src.icon_state="blank"
					if(istype(src,/obj/Training/LogB)||istype(src,/obj/Training/LogBB))
						..()
					else del(src)
				spawn(800)
					if(istype(src,/obj/Training/LogB)||istype(src,/obj/Training/LogBB))
						src.density=1
						src.dead=0
						src.health=src.maxhealth
						src.icon_state="[src.iconstateset]"
						src.New()
					//if(istype(src,/obj/Training/LogB))
					//	src.overlays+=/obj/MiscEffects/LogT/
