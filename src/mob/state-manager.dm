proc
	AddState(mob/m, var/state/s, var/duration = 0, mob/owner)
		// var/duration = -1 for unlimited duration
		s.mob = m
		if(owner) s.owner = owner
		s.duration = duration
		s.expiration = world.timeofday + s.duration
		s.mob.state_manager.Add(s)
		spawn() s.Ticker()

	RemoveState(mob/m, var/state/s, var/remove_action = STATE_REMOVE_REF)
		switch(remove_action)
			if(STATE_REMOVE_REF)
				for(var/state/state in m.state_manager)
					if(state == s)
						m.state_manager.Remove(s)
						s.duration = 0
						break

			if(STATE_REMOVE_ANY)
				for(var/state/state in m.state_manager)
					if(state.type == s.type)
						m.state_manager.Remove(state)
						state.duration = 0
						break

			if(STATE_REMOVE_ALL)
				for(var/state/state in m.state_manager)
					if(state.type == s.type)
						m.state_manager.Remove(state)
						state.duration = 0

	CheckState(mob/m, var/state/s)
		if(locate(s.type) in m.state_manager) return 1
		else return 0

/state
	var/mob/mob
	var/mob/owner
	var/duration
	var/expiration

	New()
		..()
	
	proc/Ticker()
		while(src && src.mob && src.mob.state_manager.Find(src) && world.timeofday < src.expiration || src.duration == -1)
			sleep(world.tick_lag)
			src.OnTick()
		
		if(src && src.mob)
			src.mob.state_manager.Remove(src)
			src.mob = null
		
		if(src && src.owner)
			src.owner = null

	proc/OnTick()
		..()

	stunned
		OnTick()
			..()

	burning
		OnTick()
			..()

	knocked_down
		Ticker()
			var/mob/m = src.mob
			if(m) m.icon_state = "dead"
			..()
			if(m && !CheckState(m, new/state/casting_jutsu) && !CheckState(m, new/state/knocked_down) && !CheckState(m, new/state/knocked_back) && !CheckState(m, new/state/dead))
				m.icon_state = ""

		OnTick()
			..()

	knocked_back
		OnTick()
			..()

	casting_jutsu
		OnTick()
			..()

	dead
		OnTick()
			..()

	punching

	throwing
	
	blocking
		OnTick()
			..()

	walking
		OnTick()
			..()
	
	in_warp_dimension
		Ticker()
			var/mob/m = src.mob
			var/victims_previous_loc = m.loc
			m.loc = locate(165,183,8)
			..()
			if(m)
				m<<output("The warp dimension couldn't hold you any longer!","Action.Output")
				m.loc = victims_previous_loc
	
	in_combat

	nara_attack_delay

	poisoned
		var/delay
		OnTick()
			if(!delay) delay = world.timeofday + 10
			if(delay < world.timeofday)
				src.mob.DealDamage(src.mob.maxhealth / 200, src.owner, "NinBlue")
				delay = world.timeofday + 10
			..()
	
	dummy_was_hit

#ifdef STATE_MANAGER_DEBUG
mob
	verb
		State_Manager_Stress_Test()
			set category = "Debug"
			var/count = input("How many states would you like to add?") as null|num
			if(count)
				for(var/i = 0, i < count, i++)
					AddState(src, new/state/knocked_down, 10)

		Example()
			set category = "Debug"
			AddState(src, new/state/burning, 100)
			RemoveState(src, new/state/burning, STATE_REMOVE_ALL)

			AddState(src, new/state/stunned, 20)
			if(CheckState(src, new/state/stunned))
				src << "I'm stunned!"
			
			AddState(src, new/state/knocked_down, 600)
			RemoveState(src, new/state/knocked_down, STATE_REMOVE_ANY)

			var/state/knocked_back/e = new()
			AddState(src, e, 50)
			RemoveState(src, e, STATE_REMOVE_REF)
#endif