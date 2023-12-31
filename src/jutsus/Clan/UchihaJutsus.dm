mob
	proc
		Tsukuyomi()
			for(var/obj/Jutsus/Tsukuyomi/J in src.jutsus)
				if(Sharingan<=3) // things like this come first
					src<<output("You must have Mangekyou Sharingan or higher activated in order to use this.","Action.Output")
					return
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Genjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					flick("jutsuse",src)
					Bind(src, 3)
					if(J.level==1) J.damage=((jutsudamage*J.Sprice)/2)/2.5
					if(J.level==2) J.damage=((jutsudamage*J.Sprice)/1.5)/2.5
					if(J.level==3) J.damage=((jutsudamage*J.Sprice)/1.25)/2.5
					if(J.level==4) J.damage=(jutsudamage*J.Sprice)/2.5
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					for(var/mob/M in orange(20,src))
						var/mob/M_target=M.Target_Get(TARGET_MOB)
						if(M_target == src)

							var/state/cant_attack/e = new()
							AddState(M, e, -1)

							var/state/cant_move/f = new()
							AddState(M, f, -1)
							if(M.client)
								new/obj/TsukuyomiHUD(M.client)
								M.client.eye=locate(161,35,9)
								M.client.perspective = EYE_PERSPECTIVE
							spawn()
								var/Timer= round((J.level+2) - ((J.level+2/100) * M.tenacity))
								while(Timer&&M&&!M.dead)
									if(M)
										M.DealDamage(J.damage+round((src.genjutsu_total / 200)*2*J.damage)/16, src, "white")
									Timer--
									sleep(4)
								if(M.client)
									M.client.eye=M
									M.client.perspective = EYE_PERSPECTIVE
									for(var/obj/TsukuyomiHUD/H in M.client.screen)del H
								RemoveState(M, e, STATE_REMOVE_REF)
								RemoveState(M, f, STATE_REMOVE_REF)


		Amaterasu()
			for(var/obj/Jutsus/Amaterasu/J in src.jutsus)
				if(Sharingan<=3)
					src<<output("You need to have Mangekyou Sharingan or higher activated to use this.","Action.Output")
					return
				var/mob/c_target=src.Target_Get(TARGET_MOB)
				if(!c_target)
					src<<output("You require a targeted player to use this technique.","Action.Output")
					return
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
					if(J.level==1) J.damage=((jutsudamage*J.Sprice)/2)
					if(J.level==2) J.damage=((jutsudamage*J.Sprice)/1.5)
					if(J.level==3) J.damage=((jutsudamage*J.Sprice)/1.25)
					if(J.level==4) J.damage=(jutsudamage*J.Sprice)
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					var/mob/M = c_target
					var/image/i = new('amatbuild.dmi')
					i.pixel_x=16
					i.pixel_y=16
					M.overlays+=i
					spawn(10)
						M.overlays-=i
					spawn(10)
						M=src.Target_Get(TARGET_MOB)
						if(M)
							var/obj/O = new(M.loc)
							O.IsJutsuEffect=src
							O.icon='Amat.dmi'
							O.pixel_x=-15
							O.layer=MOB_LAYER+1
							O.name="AmaterasuFire"
							var/Timer=J.level*5
							O.linkfollow(M)
							while(Timer&&c_target&&!M.dead)
								Timer--
								var/area/A=M.loc.loc
								if(A.Safe) break
								M.DealDamage((J.damage+round((src.ninjutsu_total / 200)*2*J.damage))/20,src,"NinBlue")
								sleep(5)
							if(O)del(O)
						else
							src<<output("The jutsu did not connect.","Action.Output")

		Susanoo()
			for(var/obj/Jutsus/Susanoo/J in src.jutsus)
				if(src.Sharingan<=3)
					src<<output("You need to have Mangekyou Sharingan or higher activated to use this.","Action.Output")
					return
				if(src.PreJutsu(J))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/20)*jutsustatexp))
					if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/20)*jutsustatexp))
					if(J.level==1) J.damage=((jutsudamage*J.Sprice)/2)
					if(J.level==2) J.damage=((jutsudamage*J.Sprice)/1.5)
					if(J.level==3) J.damage=((jutsudamage*J.Sprice)/1.25)
					if(J.level==4) J.damage=(jutsudamage*J.Sprice)
					if(J.level<4) if(loc.loc:Safe!=1) J.exp+=jutsumastery*(J.maxcooltime/20); J.Levelup()
					var/mob/M = new/mob/Untargettable/Susanoo(src)
					M.Follow(src)
					M.name = src.key
					M.level = J.level
					M.taijutsu_total = (J.damage+round(((src.ninjutsu_total / 450)+(src.taijutsu_total / 450))*2*J.damage))/6
					src.Susanoo=1
					spawn(100) src.Susanoo=0 //requires changing in ninjutsu.dm line 389



		Sharingan()
			for(var/obj/Jutsus/Sharingan/J in src.jutsus)
				if(src.Sharingan)
					src.Sharingan=0
					if(src.jutsucopy)src.jutsucopy=0
					src << output("<font color=[colour2html("red")]><b>You deactivate your Sharingan.","Action.Output")
					return
				if(!src.Sharingan)
					if(src.PreJutsu(J))
						var/Text
						switch(J.level)
							if(1)
								Text="a one tomoe"
								J.name="Sharingan One Tomoe"
								J.icon_state="Sharingan 1 tomoe"
								var/obj/A = new/obj(usr.loc)
								A.icon='ClanEyes.dmi'
								A.icon_state="1t"
								A.layer=MOB_LAYER+1
								var/matrix/m = matrix()
								m.Translate(-16,16)
								A.transform = m
								A.linkfollow(src)
								spawn(10) del(A)
							if(2)
								Text="a two tomoe"
								J.name="Sharingan Two Tomoe"
								J.icon_state="Sharingan 2 tomoe"
								var/obj/A = new/obj(usr.loc)
								A.icon='ClanEyes.dmi'
								A.icon_state="2t"
								A.layer=MOB_LAYER+1
								var/matrix/m = matrix()
								m.Translate(-16,16)
								A.transform = m
								A.linkfollow(src)
								spawn(10) del(A)
							if(3)
								Text="a three tomoe"
								J.name="Sharingan Three Tomoe"
								J.icon_state="Sharingan 3 tomoe"
								var/obj/A = new/obj(usr.loc)
								A.icon='ClanEyes.dmi'
								A.icon_state="3t"
								A.layer=MOB_LAYER+1
								var/matrix/m = matrix()
								m.Translate(-16,16)
								A.transform = m
								A.linkfollow(src)
								spawn(10) del(A)
							if(4)
								Text="the legendary Mangekyou"
								J.name="Mangekyou Sharingan"
								J.icon_state="Mangekyou Sharingan"
								src.DealDamage(round((src.health*0.01)*15),src,"white")
								var/obj/A = new/obj(usr.loc)
								A.icon='ClanEyes.dmi'
								A.icon_state="Mangekyo"
								A.layer=MOB_LAYER+1
								var/matrix/m = matrix()
								m.Translate(-16,16)
								A.transform = m
								A.linkfollow(src)
								spawn(10) del(A)
							if(5)
								Text="the almighty Eternal Mangekyou"
								J.name="Eternal Mangekyou Sharingan"
								J.icon_state="Eternal Mangekyou"
								var/obj/A = new/obj(usr.loc)
								A.icon='ClanEyes.dmi'
								A.icon_state="Mangekyo"
								A.layer=MOB_LAYER+1
								var/matrix/m = matrix()
								m.Translate(-16,16)
								A.transform = m
								A.linkfollow(src)
								spawn(10) del(A)
						if(loc.loc:Safe!=1) src.LevelStat("Ninjutsu",((J.maxcooltime*3/10)*jutsustatexp))
						view(src)<<output("<font color=[colour2html("red")]><b>[src] says: Sharingan!","Action.Output")
						view(src)<<output("<font color=[colour2html("red")]><b>[src]'s eyes swirl to form [Text] Sharingan.","Action.Output")

						AddState(src, new/state/cant_attack, 2)

						src.Sharingan=J.level

						while(src && src.Sharingan)
							sleep(1)
							if(src && src.Sharingan)
								src.DealDamage(10, src, "aliceblue", 0, 1)

							if(src.chakra<=0)
								src.chakra=0
								src.Sharingan=0
								src << output("<font color=[colour2html("red")]><b>Your sharingan has been deactivated.","Action.Output")
								//if(src.jutsucopy)src.jutsucopy=0

							sleep(12)
