mob
	proc
		Earth_Disruption()
			for(var/obj/Jutsus/Earth_Disruption/J in src.jutsus)
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))//XPGAIN
					flick("groundjutsuse",src)
					src.PlayAudio('Skill_BigRoketFire.wav', output = AUDIO_HEARERS)
					AddState(src, new/state/cant_attack, 2)
					var/TimeAsleep
					if(J.level==1) TimeAsleep=5
					if(J.level==2) TimeAsleep=10
					if(J.level==3) TimeAsleep=15
					if(J.level==4) TimeAsleep=20
					if(J.level==1) J.damage=0.4*((jutsudamage*J.Sprice)/2)
					if(J.level==2) J.damage=0.4*((jutsudamage*J.Sprice)/1.5)
					if(J.level==3) J.damage=0.4*((jutsudamage*J.Sprice)/1.25)
					if(J.level==4) J.damage=0.4*(jutsudamage*J.Sprice)
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					for(var/mob/M in oview(J.level))
						if(!istype(M,M)||!M) continue
						M.icon_state="dead"
						M.DealDamage(J.damage+round((src.ninjutsu_total / 200)*2*J.damage),src,"NinBlue")
						var/bind_time = TimeAsleep
						TimeAsleep -= (TimeAsleep/100)*M.tenacity
						Bind(M, bind_time, src)
						spawn(TimeAsleep)
							M.icon_state = ""

		Earth_Release_Mud_River()
			for(var/obj/Jutsus/Earth_Release_Mud_River/J in src.jutsus)
				var/mob/c_target=src.Target_Get(TARGET_MOB)
				if(!c_target)
					src << output("This jutsu requires a target","Action.Output")
					return
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					flick("jutsuse",src)
					Bind(src, 3)
					src.PlayAudio('man_fs_l_mt_wat.ogg', output = AUDIO_HEARERS)
					var/TimeAsleep
					if(J.level==1) TimeAsleep=15
					if(J.level==2) TimeAsleep=20
					if(J.level==3) TimeAsleep=25
					if(J.level==4) TimeAsleep=30
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					new/obj/Jutsus/Effects/mudslide(src.loc)
					var/mob/M = c_target
					spawn(10)
						M=src.Target_Get(TARGET_MOB)
						if(M)
							new/obj/Jutsus/Effects/mudslide(M.loc)
							M.icon_state="dead"
							var/bind_time = TimeAsleep
							TimeAsleep -= (TimeAsleep/100)*M.tenacity
							Bind(M, bind_time, src)
							spawn(TimeAsleep)
								if(!M||M.dead)continue
								M.icon_state=""
						else src<<output("The jutsu did not connect.","Action.Output")

		Dango()
			for(var/obj/Jutsus/Dango/J in src.jutsus)
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					flick("groundjutsu",src)
					if(J.level==1) J.damage=2
					if(J.level==2) J.damage=4
					if(J.level==3) J.damage=7
					if(J.level==4) J.damage=10
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					var/obj/Dango/p1/A = new/obj/Dango/p1(src.loc)
					A.IsJutsuEffect=src
					A.Owner=src
					A.layer=src.layer
					A.fightlayer=src.fightlayer
					A.damage=J.damage
					A.level=J.level
					walk(A,src.dir)

		Doryuusou()
			for(var/obj/Jutsus/Doryuusou/J in src.jutsus)
				var/mob/c_target=src.Target_Get(TARGET_MOB)
				if(!c_target)
					src << output("This jutsu requires a target","Action.Output")
					return
				if(src.PreJutsu(J))
					if(J.level==1) J.damage=0.6*((jutsudamage*J.Sprice)/2)
					if(J.level==2) J.damage=0.6*((jutsudamage*J.Sprice)/1.5)
					if(J.level==3) J.damage=0.6*((jutsudamage*J.Sprice)/1.25)
					if(J.level==4) J.damage=0.6*(jutsudamage*J.Sprice)
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					flick("groundjutsu",src)
					Bind(src, 3)
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					var/mob/M = c_target
					src.PlayAudio('rumble_rocks.wav', output = AUDIO_HEARERS)
					spawn(20)
						M=src.Target_Get(TARGET_MOB)
						if(M)
							var/obj/Y = new/obj
							Y.icon='newdoton.dmi'
							Y.icon_state=""
							Y.pixel_x=-55
							Y.loc=M.loc
							Y.layer=MOB_LAYER+1
							flick("dead",M)
							src.PlayAudio('rock_blast.wav', output = AUDIO_HEARERS)
							spawn(25)
								if(Y)
									del(Y)
							M.DealDamage(J.damage+round((src.ninjutsu_total / 200)*2*J.damage),src,"NinBlue")
							spawn() if(M) M.Bleed()
						else src<<output("The jutsu did not connect.","Action.Output")

		Mud_Dragon_Projectile()
			for(var/obj/Jutsus/Mud_Dragon_Projectile/J in src.jutsus)
				if(src.PreJutsu(J))
					var/mob/c_target=src.Target_Get(TARGET_MOB)
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					if(J.level==1) J.damage=((jutsudamage*J.Sprice)/2)
					if(J.level==2) J.damage=((jutsudamage*J.Sprice)/1.5)
					if(J.level==3) J.damage=((jutsudamage*J.Sprice)/1.25)
					if(J.level==4) J.damage=(jutsudamage*J.Sprice)
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					flick("jutsuse",src)
					Bind(src, 10)
					sleep(10)
					flick("2fist",src)
					src.PlayAudio('man_fs_r_mt_wat.ogg', output = AUDIO_HEARERS)
					if(c_target)src.dir=get_dir(src,c_target)
					var/obj/Projectiles/Effects/JinraiBack/Aa=new(get_step(src,src.dir))
					Aa.icon = 'Mud Dragon Projectile.dmi'
					Aa.IsJutsuEffect=src
					Aa.dir = src.dir
					Aa.layer = src.layer+1
					Aa.pixel_y=16
					Aa.pixel_x=-16
					var/obj/Projectiles/Effects/JinraiHead/A=new(get_step(src,src.dir))
					A.icon = 'Mud Dragon Projectile.dmi'
					A.dir = src.dir
					A.Owner=src
					A.layer=src.layer+2
					A.fightlayer=src.fightlayer
					A.pixel_y=16
					A.pixel_x=-16
					A.damage=0.9*(J.damage+round((src.ninjutsu_total / 200)*2*J.damage))
					A.level=J.level
					walk(A,dir,0)
					icon_state=""
					Aa.dir = src.dir

		Earth_Style_Dark_Swamp()
			for(var/obj/Jutsus/Earth_Style_Dark_Swamp/J in src.jutsus)
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					var/mob/c_target=src.Target_Get(TARGET_MOB)
					flick("groundjutsu",src)
					src.icon_state = "groundjutsuse"
					var/mob/M
					Bind(src, 3)
					spawn(3) src.icon_state = ""
					if(c_target)M = c_target
					else M = src
					for(var/turf/T in view(0,M))new/obj/ESDS(T)
					spawn(1)
						for(var/turf/T in view(1,M))new/obj/ESDS(T)
						spawn(1)for(var/turf/T in view(2,M))new/obj/ESDS(T)
						

		Earth_Release_Earth_Cage()
			for(var/obj/Jutsus/Earth_Release_Earth_Cage/J in src.jutsus)
				var/mob/c_target=src.Target_Get(TARGET_MOB)
				if(!c_target||!istype(c_target))
					src<<output("You must have a target to use this technique.","Action.Output")
					return

				if(src.PreJutsu(J))
					J.density = 1
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					flick("jutsuse",src)
					src.PlayAudio('wind_leaves.ogg', output = AUDIO_HEARERS)
					Bind(src, 4)
					if(J.level==1)J.damage=2
					if(J.level==2)J.damage=4
					if(J.level==3)J.damage=5
					if(J.level==4)J.damage=6
					if(J.level<4)if(loc.loc:Safe!=1)J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					if(c_target)
						flick("groundjutsu",src)
						sleep(4)
						src.icon_state="groundjutsuse"
						if(c_target)
							if(c_target.health==0) return
							src.dir=get_dir(src,c_target)
							var/obj/A = new(c_target.loc)
							A.IsJutsuEffect=src
							A.Owner=src
							A.density=1
							A.layer=MOB_LAYER+1
							var/I=J.damage*8
							A.icon='doton cage.dmi'
							A.icon_state="stay"
							A.pixel_x=-48
							A.pixel_y=-16
							flick("create",A)
							I = I+round(src.ninjutsu_total/16)
							I -= (I/100)*c_target.tenacity
							spawn(I+1)
								if(A)
									flick("delete",A)
									sleep(4)
									del(A)
							var/oldhealth=c_target.health
							var/I2=1
							while(I && A)
								I--
								I2+=1
								if(A)
									for(var/mob/F in A.loc)
										if(F.health==0) return
										F.health=oldhealth
										if(I2==8)
											I2=0
											if(F)
												F.DealDamage(J.damage,src,"NinBlue")
												Bind(F, 10)
												oldhealth=(oldhealth-J.damage)
												F.health=oldhealth
									sleep(1)
							if(src)
								flick("delete",A)
								sleep(4)
								del(A)
								src.icon_state=""

		MudWall()
			for(var/obj/Jutsus/MudWall/J in src.jutsus)
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					var/obj/Projectiles/Effects/mudwall/A=new/obj/Projectiles/Effects/mudwall(src.loc)
					A.Owner=src
					var/mob/forjutsu/mudwallmob/B=new/mob/forjutsu/mudwallmob(src.loc)
					B.health+=1



		EarthBoulder()
			for(var/obj/Jutsus/EarthBoulder/J in src.jutsus)
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					flick("2fist",src)
					var/obj/earth/dotondango/A=new/obj/earth/dotondango(src.loc)
					A.ooowner=src
					A.dir=src.dir
					if(J.level==1) A.dmg=120
					if(J.level==2) A.dmg=140
					if(J.level==3) A.dmg=160
					if(J.level==4) A.dmg=180
					walk(A,A.dir)
					src.copy=null


