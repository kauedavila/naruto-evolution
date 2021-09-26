mob
    npc
        mouse_over_pointer = /obj/cursors/speech
        var/tmp/list/conversations = list()
        var/npcowner
        var/ownersquad
        var/tmp/bark
        move=0

        New()
            ..()
            npcs_online.Add(src)

            if(!istype(src, /mob/npc/combat/animals/small))
                src.overlays += /obj/MaleParts/UnderShade

            src.SetName(src.name)

            OriginalOverlays = overlays.Copy()
            //spawn() src.RestoreOverlays()
            
            src.NewStuff()

        Move()
            if(istype(src, /mob/npc/combat)) ..()
            else return

        Death(killer)
            if(istype(src, /mob/npc/combat)) ..()
            else return
        
        banker
            name = "Banker"
            icon = 'WhiteMBase.dmi'
            density = 1
            pixel_x = -15

            leaf_banker
                village = VILLAGE_LEAF
            
            sand_banker
                village = VILLAGE_SAND
            
            missing_nin_banker
                village = VILLAGE_AKATSUKI
            
            akatsuki_banker
                village = VILLAGE_AKATSUKI

            New()
                src.overlays += pick('Short.dmi', 'Short2.dmi', 'Short3.dmi')
                src.overlays += 'Shirt.dmi'
                src.overlays += 'Sandals.dmi'
                ..()
                

            DblClick()
                if(src.conversations.Find(usr)) return 0
                if(get_dist(src,usr) > 2) return
                if(usr.dead) return

                src.conversations.Add(usr)

                if(src.village == usr.village)

                    view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Greetings [usr.name], would you like to make a deposit or a withdrawal from your bank?</font>"

                    switch(usr.client.Alert("You currently have <u>[usr.ryo]</u> Ryo in your satchel.<br /><br />You currently have <u>[usr.RyoBanked]</u> in your bank.", "Bank", list("Deposit","Withdraw","Cancel")))
                        if(1)
                            
                            view(usr) << "[HTML_GetName(usr)]<font color='[COLOR_CHAT]'>: I'd like to make a deposit to my bank account.</font>"
                            
                            if(!usr.ryo)
                                sleep(10)
                                view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I'm sorry, but your broke ass doesn't have any Ryo to deposit.</font>"
                            else
                                sleep(10)
                                view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Very well, how much would you like to deposit?</font>"

                                switch(usr.client.Alert("Would you like to deposit all of your Ryo?", "Bank", list("Yes", "No", "Cancel")))
                                    if(1)
                                        var/value = usr.ryo

                                        if(value)
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I'd like to deposit [value] Ryo into my bank account.</font>"

                                            usr.ryo -= value
                                            usr.RyoBanked += value

                                            spawn() usr.client.UpdateInventoryPanel()

                                            usr << output("You have deposited <u>[value]</u> Ryo into your bank.", "Action.Output")
                                            usr << output("You now have <u>[usr.ryo]</u> Ryo into your satchel and <u>[usr.RyoBanked]</u> in your bank.", "Action.Output")

                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Your transaction has been completed. Please come back again soon!</font>"

                                        else
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Actually, I've changed my mind.</font>"
                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"

                                    if(2)
                                        var/list/AlertInput = usr.client.AlertInput("How much Ryo would you like to deposit into your bank?<br /><br />You currently have <u>[usr.ryo]</u> Ryo in your satchel.<br />You currently have <u>[usr.RyoBanked]</u> in your bank.", "Bank")
                                        
                                        var/value = AlertInput[2]

                                        if(isnum(value) && value > 0 && usr.ryo >= value)
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I'd like to deposit [value] Ryo into my bank account.</font>"
                                        
                                            usr.ryo -= value
                                            usr.RyoBanked += value

                                            spawn() usr.client.UpdateInventoryPanel()

                                            usr << output("You have deposited <u>[value]</u> Ryo into your bank.", "Action.Output")
                                            usr << output("You now have <u>[usr.ryo]</u> Ryo into your satchel and <u>[usr.RyoBanked]</u> in your bank.", "Action.Output")

                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Your transaction has been completed. Please come back again soon!</font>"

                                        else
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Actually, I've changed my mind.</font>"
                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"
                                    
                                    if(3)
                                        view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Actually, I've changed my mind.</font>"
                                        sleep(10)
                                        view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"

                        if(2)

                            view(usr) << "[HTML_GetName(usr)]<font color='[COLOR_CHAT]'>: I'd like to make a withdrawal from my bank account.</font>"

                            if(!usr.RyoBanked)
                                sleep(10)
                                view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I'm sorry, but your broke ass doesn't have any Ryo to withdrawal.</font>"
                            else
                                sleep(10)
                                view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Very well, how much would you like to withdrawal?</font>"

                                switch(usr.client.Alert("Would you like to withdrawal all of your Ryo?", "Bank", list("Yes", "No", "Cancel")))
                                    if(1)
                                        var/value = usr.RyoBanked

                                        if(value)
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I'd like to withdrawal [value] Ryo into my bank account.</font>"

                                            usr.RyoBanked -= value
                                            usr.ryo += value
                                            
                                            spawn() usr.client.UpdateInventoryPanel()

                                            usr << output("You withdraw <u>[value]</u> Ryo into from your bank.", "Action.Output")
                                            usr << output("You now have <u>[usr.ryo]</u> Ryo into your satchel and <u>[usr.RyoBanked]</u> in your bank.", "Action.Output")

                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Your transaction has been completed. Please come back again soon!</font>"

                                        else
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Actually, I've changed my mind.</font>"
                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"

                                    if(2)
                                        var/list/AlertInput = usr.client.AlertInput("How much Ryo would you like to withdraw from your bank?<br /><br />You currently have <u>[usr.ryo]</u> Ryo in your satchel.<br />You currently have <u>[usr.RyoBanked]</u> in your bank.", "Bank")
                                        
                                        var/value = AlertInput[2]

                                        if(isnum(value) && value > 0 && usr.RyoBanked >= value)
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I'd like to withdraw [value] Ryo from my bank account.</font>"

                                            usr.RyoBanked -= value
                                            usr.ryo += value
                                            
                                            spawn() usr.client.UpdateInventoryPanel()

                                            usr << output("You withdraw <u>[value]</u> Ryo into from your bank.", "Action.Output")
                                            usr << output("You now have <u>[usr.ryo]</u> Ryo into your satchel and <u>[usr.RyoBanked]</u> in your bank.", "Action.Output")

                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Your transaction has been completed. Please come back again soon!</font>"

                                        else
                                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Actually, I've changed my mind.</font>"
                                            sleep(10)
                                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"
                                    
                                    if(3)
                                        view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Actually, I've changed my mind.</font>"
                                        sleep(10)
                                        view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"
                        if(3)
                            view(usr) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: No, thank you.</font>"
                            sleep(10)
                            view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: Please come back again soon!</font>"
                
                else
                    view(src) << "[HTML_GetName(src)]<font color='[COLOR_CHAT]'>: I only manage accounts for members of the [HTML_GetVillage(src)].</font>"

                src.conversations.Remove(usr)

        shady_man
            name = "Shady Looking Figure"
            icon = 'WhiteMBase.dmi'
            village = VILLAGE_MISSING_NIN
            New()
                src.overlays += pick('Short.dmi','Short2.dmi','Short3.dmi')
                src.overlays += 'Shade.dmi'
                src.overlays+='Shirt.dmi'
                src.overlays+='Sandals.dmi'
                ..()
                
            DblClick()
                if(usr.dead)return
                if(get_dist(src,usr)>2)return
                if(usr)usr.move=0
                if(usr.village == VILLAGE_MISSING_NIN)
                    var/obj/Inventory/mission/deliver_intel/O = locate(/obj/Inventory/mission/deliver_intel) in usr.contents
                    if(O && O.squad.mission)
                        O.squad.mission.Complete(usr)
                    else
                        usr.client.Alert("Psst, hey you there. If you can get me some intel on the shinobi villages I'll pay you handsomely.", src.name)
                else
                    usr.client.Alert("Buzz off, I don't speak with the likes of you.", src.name)
                usr.move=1

        zetsu //not to be confused with white zetsu
            name = "Zetsu"
            icon = 'Zetsu.dmi'
            village = VILLAGE_AKATSUKI
            //100,161,5

            DblClick()
                if(usr.dead)return
                if(get_dist(src,usr)>2)return
                if(usr)usr.move=0
                var/obj/Inventory/mission/deliver_intel/O = locate(/obj/Inventory/mission/deliver_intel) in usr.contents
                if(O && O.squad.mission)
                    O.squad.mission.Complete(usr)
                else if(usr.client.Alert("Be patient. In time, we'll create a whole new world. Would you like to use the secret exit?", src.name, list("Yes", "No")) == 1)
                    usr.loc = locate(100,32,4)
                usr.move=1


        onomari //reserved for prestige system
            name = "Onomari"
            icon = 'WhiteMBase.dmi'
            village = "Hidden Leaf"
        
        event_npc
            ballot_secretary
                New()
                    ..()
                    if(src.village == VILLAGE_LEAF) src.icon = src.icon
                    if(src.village == VILLAGE_SAND) src.icon = src.icon
                    src.overlays += pick('Short.dmi','Short2.dmi','Short3.dmi')
                    src.overlays+='Shirt.dmi'
                    src.overlays+='Sandals.dmi'
                
                DblClick()
                    ..()
                    if(src.conversations.Find(usr)) return 0
                    src.conversations.Add(usr)

                    switch(src.village)
                        if(VILLAGE_LEAF)
                            if(src.village == usr.village)
                                if(usr.checkRank() >= 2)
                                    if(global.hokage_election)
                                        if(global.hokage_ballot_open)
                                            view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: I see that you're at least a [RANK_CHUUNIN], would you like to nominate yourself for [RANK_HOKAGE]?</font>"
                                            if(usr.client.Alert("Would you like to nominate yourself as [RANK_HOKAGE]?", "Election", list("Yes", "No")) == 1)
                                                view(usr) << "<font color='[src.name_color]'>[usr.name]</font><font color='[COLOR_CHAT]'>: Yes, please accept my ballot.</font>"
                                                sleep(10)
                                                if(GetBallot(usr))
                                                    view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: I see that you have already nominated yourself for [RANK_HOKAGE]. As per policy, a nominee may only nominate themselves once.</font>"
                                                else
                                                    var/election_ballot/ballot = new()
                                                    ballot.name = "[usr.character] ([usr.ckey])"
                                                    ballot.ckey = usr.ckey
                                                    ballot.character = usr.character
                                                    hokage_election_ballot.Add(ballot)
                                                    view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: Thank you for your submission, [usr.character]. Your ballot has been accepted.</font>"
                                                    world << "<font color='red'>\[G]</font> <font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: [usr.character] has submitted their ballot as a nominee for the on-going [RANK_HOKAGE] election.</font>"
                                            else
                                                view(usr) << "<font color='[src.name_color]'>[usr.name]</font><font color='[COLOR_CHAT]'>: No, thank you.</font>"
                                                sleep(10)
                                                view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: I understand, feel free to come back if you'd like to nominate yourself for [RANK_HOKAGE].</font>"
                                        else
                                            view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: Sorry, the current on-going election has a closed ballot policy, due to the previous election resulting in a tie.</font>"
                                    else
                                        view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: There currently isn't an on-going election for [RANK_HOKAGE]. You can come back during the next election if you'd like to nominate yourself.</font>"
                                else
                                    view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: You must be at least a Chuunin to be allowed nominate yourself for [RANK_HOKAGE].</font>"
                            else
                                view(src) << "<font color = '[COLOR_VILLAGE_LEAF]'>[src.name]</font><font color='[COLOR_CHAT]'>: You can't nominate yourself for [RANK_HOKAGE]. You're from the Hidden Sand village, get out of here!</font>"

                        if(VILLAGE_SAND)
                            if(src.village == usr.village)
                                if(usr.checkRank() >= 2)
                                    if(global.kazekage_election)
                                        if(global.kazekage_ballot_open)
                                            view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: I see that you're at least a [RANK_CHUUNIN], would you like to nominate yourself for [RANK_KAZEKAGE]?</font>"
                                            if(usr.client.Alert("Would you like to nominate yourself as [RANK_KAZEKAGE]?", "Election", list("Yes", "No")) == 1)
                                                view(usr) << "<font color='[src.name_color]'>[usr.name]</font><font color='[COLOR_CHAT]'>: Yes, please accept my ballot.</font>"
                                                sleep(10)
                                                if(GetBallot(usr))
                                                    view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: I see that you have already nominated yourself for [RANK_KAZEKAGE]. As per policy, a nominee may only nominate themselves once.</font>"
                                                else
                                                    var/election_ballot/ballot = new()
                                                    ballot.name = "[usr.character] ([usr.ckey])"
                                                    ballot.ckey = usr.ckey
                                                    ballot.character = usr.character
                                                    kazekage_election_ballot.Add(ballot)
                                                    view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: Thank you for your submission, [usr.character]. Your ballot has been accepted.</font>"
                                                    world << "<font color='red'>\[G]</font> <font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: [usr.character] has submitted their ballot as a nominee for the on-going [RANK_KAZEKAGE] election.</font>"
                                            else
                                                view(usr) << "<font color='[src.name_color]'>[usr.name]</font><font color='[COLOR_CHAT]'>: No, thank you.</font>"
                                                sleep(10)
                                                view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: I understand, feel free to come back if you'd like to nominate yourself for [RANK_KAZEKAGE].</font>"
                                        else
                                            view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: Sorry, the current on-going election has a closed ballot policy, due to the previous election resulting in a tie.</font>"
                                    else
                                        view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: There currently isn't an on-going election for [RANK_KAZEKAGE]. You can come back during the next election if you'd like to nominate yourself.</font>"
                                else
                                    view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: You must be at least a Chuunin to be allowed nominate yourself for [RANK_KAZEKAGE].</font>"
                            else
                                view(src) << "<font color = '[COLOR_VILLAGE_SAND]'>[src.name]</font><font color='[COLOR_CHAT]'>: You can't nominate yourself for [RANK_KAZEKAGE]. You're from the Hidden Sand village, get out of here!</font>"

                    src.conversations.Remove(usr)
                
                leaf_ballot_secretary
                    icon = 'DarkMBase.dmi'
                    name = "Leaf Ballot Secretary"
                    village = VILLAGE_LEAF
                
                sand_ballot_secretary
                    icon = 'PaleMBase.dmi'
                    name = "Sand Ballot Secretary"
                    village = VILLAGE_SAND

        mission_npc
            mission_secretary
                New()
                    ..()
                    if(src.village=="Hidden Leaf") src.icon='Shizune-Leaf Secr.dmi'
                    if(src.village=="Hidden Sand") src.icon='Temari-Sand Secr.dmi'

                DblClick()
                    ..()
                    if(src.conversations.Find(usr)) return 0
                    src.conversations.Add(usr)

                    // Only speak to players in the same village
                    if(src.village == usr.village)
                        var/squad/squad = usr.GetSquad()
                        if(squad && squad.mission && !squad.mission.complete)
                            // Complete mission (original squad)
                            squad.mission.Complete(usr)
                        else
                            // Complete mission (another squad)
                            var/obj/Inventory/mission/deliver_intel/O = locate(/obj/Inventory/mission/deliver_intel) in usr.contents
                            if(O && O.squad.mission && !O.squad.mission.complete)
                                O.squad.mission.Complete(usr)

                            // Request mission (Squad leader only)
                            else if(squad && squad == usr.GetLeader())
                                // Check for mission cooldown
                                var/mission_delay = ((world.realtime - usr.client.last_mission)/10/60)
                                if(mission_delay < 20)
                                    usr.client.Alert("You must wait [round((mission_delay-20)*-1, 1)+1] more minutes until you can accept another mission.", src.name)

                                // Select mission
                                else if(usr.client.Alert("Hey [usr.name], are you here to pickup a mission for your squad?", src.name, list("Yes", "No")) == 1)
                                    var/list/excluded_missions = list()
                                    switch(usr.client.AlertList("What rank mission are you interested in?", src.name, list("D Rank", "C Rank", "B Rank", "A Rank", "S Rank")))
                                        if(1)
                                            if(usr.checkRank() >= 1)
                                                var/mission/d_rank/mission

                                                try
                                                    mission = pick(typesof(/mission/d_rank) - /mission/d_rank - excluded_missions)
                                                catch
                                                    usr.client.Alert("There are currently no D rank missions avaliable.", src.name)

                                                if(mission)
                                                    mission = new mission(usr)

                                                    if(usr.client.Alert(mission.html, src.name, list("Accept Mission", "Decline Mission")) == 1)
                                                        squad.mission = mission
                                                        squad.mission.Start(usr)

                                                        for(var/mob/m in mobs_online)
                                                            if(squad == m.GetSquad()) m.client.last_mission = squad.mission.start

                                                        for(var/ckey in squad.members)
                                                            var/savefile/F = new("[SAVEFILE_CLIENT]/[copytext(ckey, 1, 2)]/[ckey].sav")
                                                            F["last_mission"] << squad.mission.start

                                                        spawn() squad.Refresh()
                                            else
                                                usr.client.Alert("You must be at least Genin rank to take on D rank missions.", src.name)

                                        if(2)
                                            if(usr.checkRank() >= 2)
                                                if(!(VillageDefenders.Find(usr.village)) && !(VillageAttackers.Find(usr.village))) excluded_missions += /mission/c_rank/the_war_effort
                                                var/mission/c_rank/mission

                                                try
                                                    mission = pick(typesof(/mission/c_rank) - /mission/c_rank - excluded_missions)
                                                catch
                                                    usr.client.Alert("There are currently no C rank missions avaliable.", src.name)

                                                if(mission)
                                                    mission = new mission(usr)

                                                    if(usr.client.Alert(mission.html, src.name, list("Accept Mission", "Decline Mission")) == 1)
                                                        squad.mission = mission
                                                        squad.mission.Start(usr)

                                                        for(var/mob/m in mobs_online)
                                                            if(squad == m.GetSquad()) m.client.last_mission = squad.mission.start

                                                        for(var/ckey in squad.members)
                                                            var/savefile/F = new("[SAVEFILE_CLIENT]/[copytext(ckey, 1, 2)]/[ckey].sav")
                                                            F["last_mission"] << squad.mission.start

                                                        spawn() squad.Refresh()
                                            else
                                                usr.client.Alert("You must be at least Chunin rank to take on C rank missions.", src.name)

                                        if(3)
                                            if(usr.checkRank() >= 3)
                                                var/mission/b_rank/mission

                                                try
                                                    mission = pick(typesof(/mission/b_rank) - /mission/b_rank - excluded_missions)
                                                catch
                                                    usr.client.Alert("There are currently no B rank missions avaliable.", src.name)

                                                if(mission)
                                                    mission = new mission(usr)

                                                    if(usr.client.Alert(mission.html, src.name, list("Accept Mission", "Decline Mission")) == 1)
                                                        squad.mission = mission
                                                        squad.mission.Start(usr)

                                                        for(var/mob/m in mobs_online)
                                                            if(squad == m.GetSquad()) m.client.last_mission = squad.mission.start

                                                        for(var/ckey in squad.members)
                                                            var/savefile/F = new("[SAVEFILE_CLIENT]/[copytext(ckey, 1, 2)]/[ckey].sav")
                                                            F["last_mission"] << squad.mission.start

                                                        spawn() squad.Refresh()
                                            else
                                                usr.client.Alert("You must be at least Jonin rank to take on B rank missions.", src.name)

                                        if(4)
                                            if(usr.checkRank() >= 3)
                                                var/mission/a_rank/mission

                                                try
                                                    mission = pick(typesof(/mission/a_rank) - /mission/a_rank - excluded_missions)
                                                catch
                                                    usr.client.Alert("There are currently no A rank missions avaliable.", src.name)

                                                if(mission)
                                                    mission = new mission(usr)

                                                    if(usr.client.Alert(mission.html, src.name, list("Accept Mission", "Decline Mission")) == 1)
                                                        squad.mission = mission
                                                        squad.mission.Start(usr)

                                                        for(var/mob/m in mobs_online)
                                                            if(squad == m.GetSquad()) m.client.last_mission = squad.mission.start

                                                        for(var/ckey in squad.members)
                                                            var/savefile/F = new("[SAVEFILE_CLIENT]/[copytext(ckey, 1, 2)]/[ckey].sav")
                                                            F["last_mission"] << squad.mission.start

                                                        spawn() squad.Refresh()
                                            else
                                                usr.client.Alert("You must be at least Jonin rank to take on A rank missions.", src.name)

                                        if(5)
                                            if(usr.checkRank() >= 4)
                                                var/mission/s_rank/mission

                                                try
                                                    mission = pick(typesof(/mission/s_rank) - /mission/s_rank - excluded_missions)
                                                catch
                                                    usr.client.Alert("There are currently no S rank missions avaliable.", src.name)

                                                if(mission)
                                                    mission = new mission(usr)

                                                    if(usr.client.Alert(mission.html, src.name, list("Accept Mission", "Decline Mission")) == 1)
                                                        squad.mission = mission
                                                        squad.mission.Start(usr)

                                                        for(var/mob/m in mobs_online)
                                                            if(squad == m.GetSquad()) m.client.last_mission = squad.mission.start

                                                        for(var/ckey in squad.members)
                                                            var/savefile/F = new("[SAVEFILE_CLIENT]/[copytext(ckey, 1, 2)]/[ckey].sav")
                                                            F["last_mission"] << squad.mission.start

                                                        spawn() squad.Refresh()
                                            else
                                                usr.client.Alert("You must be at least ANBU rank to take on S rank missions.", src.name)

                            // Mission request denied: active mission
                            else if(squad && squad == usr.GetSquad() && squad.mission && !squad.mission.complete)
                                usr.client.Alert("Your squad already has an active mission.", src.name)

                            // Mission request denied: leader must request mission
                            else if(squad && squad == usr.GetSquad() && !squad.mission)
                                usr.client.Alert("Hey [usr.name], it's nice to see you! Have your squad leader stop by if you're ready to take on a mission.", src.name)

                            // Mission request denied: not in a squad
                            else if(!squad)
                                usr.client.Alert("I can't send you out on missions until you form a squad.", src.name)

                    // Rejection
                    else
                        usr.client.Alert("We don't work with your kind here.", src.name)

                    src.conversations.Remove(usr)

                proc/CompleteMissions()

                proc/GetMission()

                shizune
                    name = "Shizune"
                    icon = 'WhiteMBase.dmi'
                    village = "Hidden Leaf"

                temari
                    name = "Temari"
                    icon = 'WhiteMBase.dmi'
                    village = "Hidden Sand"

            deliver_intel
                New()
                    ..()
                    src.overlays += pick('Short.dmi','Short2.dmi','Short3.dmi')
                    src.overlays += 'Shade.dmi'
                    src.overlays+='Shirt.dmi'
                    src.overlays+='Sandals.dmi'

                DblClick()
                    ..()
                    if(src.conversations.Find(usr)) return 0
                    src.conversations.Add(usr)

                    var/squad/squad = usr.GetSquad()

                    if(squad && squad.mission && squad.mission.required_mobs.Find(src))
                        switch(squad.mission.type)
                            if(/mission/d_rank/deliver_intel)
                                if(squad.mission.required_items.Find(/obj/Inventory/mission/deliver_intel))
                                    squad.mission.required_items.Remove(/obj/Inventory/mission/deliver_intel)

                                    switch(usr.village)
                                        if("Hidden Leaf")
                                            var/obj/Inventory/mission/deliver_intel/leaf_intel/o = new(usr)
                                            usr.RecieveItem(o)
                                            spawn() usr.client.UpdateInventoryPanel()
                                            usr.client.Alert("I need you to deliver this intel to [squad.mission.complete_npc].", src.name)

                                        if("Hidden Sand")
                                            var/obj/Inventory/mission/deliver_intel/sand_intel/o = new(usr)
                                            usr.RecieveItem(o)
                                            spawn() usr.client.UpdateInventoryPanel()
                                            usr.client.Alert("I need you to deliver this intel to [squad.mission.complete_npc].", src.name)

                                else
                                    usr.client.Alert("I've already given your squad the intel. Quickly, on your way before the enemy show up.", src.name)

                    else
                        usr.client.Alert("Got a problem?", src.name)

                    src.conversations.Remove(usr)

                leaf
                    New()
                        ..()
                        src.overlays += 'SandChuninVest.dmi'
                    akirya
                        name = "Akirya"
                        icon = 'DarkMBase.dmi'
                        village="Hidden Sand"

                    obei
                        name = "Obei"
                        icon = 'DarkMBase.dmi'
                        village="Hidden Sand"

                    tsunai
                        name = "Tsunai"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Sand"

                    amatsi
                        name = "Amatsi"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Sand"

                sand
                    New()
                        ..()
                        src.overlays += 'Chunin Vest.dmi'
                    ayumi
                        name = "Ayumi"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Leaf"

                    emiraya
                        name = "Emiraya"
                        icon = 'DarkMBase.dmi'
                        village="Hidden Leaf"

                    aiko
                        name = "Aiko"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Leaf"

                    nevira
                        name = "Nevira"
                        icon = 'DarkMBase.dmi'
                        village="Hidden Leaf"

        combat
            New()
                ..()
                var/obj/hbar=new /obj/Screen/healthbar/
                var/obj/mbar=new /obj/Screen/manabar/
                src.mouse_over_pointer = /obj/cursors/target
                src.hbar.Add(hbar)
                src.hbar.Add(mbar)

            Death(killer)
                if(src.health <= 0)
                    walk(src,0)
                    spawn(50)
                        if(src)
                            del src
                ..()

            political_escort
                var/tmp/squad/squad
                var/tmp/squad_leader_ckey
                var/tmp/last_location
                var/tmp/last_location_time
                var/tmp/obj/next_node
                var/tmp/obj/last_node
                health=15000
                maxhealth=15000
                New()
                    ..()
                    src.overlays += pick('Short.dmi','Short2.dmi','Short3.dmi')
                    src.overlays += 'Shade.dmi'
                    src.overlays+='Shirt.dmi'
                    src.overlays+='Sandals.dmi'
                    src.move=1
                    src.injutsu=0
                    src.canattack=1
                    spawn(5) view() << ffilter("<font color='[src.name_color]'>[src.name]</font>: <font color='[COLOR_CHAT]'>[bark]</font>")
                    spawn()
                        while(src && !src.dead)
                            if(src.last_location != src.loc)
                                src.last_location = src.loc
                                src.last_location_time = world.realtime

                            else if(src.last_location == src.loc && src.last_location_time + 2000 <= world.realtime) //last_location_time may be innacurate make sure you test
                                src.loc = src.last_node.loc
                                step_away(src, src.last_node)
                                walk_to(src, src.last_node, 0, 5)

                            else if(src.move)
                                walk_to(src, src.next_node, 0, 5)

                            sleep(10)

                Death(mob/killer)
                    ..()
                    if(src.squad && src.health <= 0)
                        for(var/mob/m in mobs_online)
                            if(squad == m.GetSquad())
                                squad.mission.status = "Failure"
                                squad.mission.complete = world.realtime
                                m << output("<b>[squad.mission.name]:</b> The Daimyo has been killed! Our mission is a failure.", "Action.Output")
                                spawn() m.client.Alert("The Daimyo has been killed! Our mission is a failure.", "Mission Failed")
                                spawn() squad.RefreshMember(m)

                        if(killer && killer.village != src.village)
                            var/squad/ksquad = killer.GetSquad()
                            if(ksquad)
                                var/exp_reward = round(squad.mission.mission_exp_mod * squad.mission.A_reward)
                                var/ryo_reward = round(squad.mission.mission_ryo_mod * squad.mission.A_reward)
                                for(var/mob/m in mobs_online)
                                    if(ksquad == m.GetSquad())
                                        m.exp += exp_reward
                                        m.ryo += ryo_reward
                                        m.Levelup()
                                        m << output("<b>[squad.mission.name]:</b> [killer.name] killed an enemy Daimyo and have recieved [exp_reward] exp and [ryo_reward] ryo for your effort!", "Action.Output")

                            else
                                var/exp_reward = round(squad.mission.mission_exp_mod * squad.mission.A_reward)
                                var/ryo_reward = round(squad.mission.mission_ryo_mod * squad.mission.A_reward)
                                killer.exp += exp_reward
                                killer.ryo += ryo_reward
                                killer.Levelup()
                                killer << output("<b>[squad.mission.name]:</b> You've killed an enemy Daimyo and have recieved [exp_reward] exp and [ryo_reward] ryo for your effort!", "Action.Output")

                leaf
                    New()
                        ..()
                        walk_to(src, locate(/obj/escort/pel1), 0, 5)
                    haruna
                        name = "Daimyo Haruna"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Leaf"
                        bark = "Thank you for agreeing to this! Please don't let me get get kidnapped or worse!"

                    chikara
                        name = "Daimyo Chikara"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Leaf"
                        bark = "Let's get this over with quick, I can't wait to get home and have some Udon. I'm starving!"

                    toki
                        name = "Daimyo Toki"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Leaf"
                        bark = "Take good care of me, I don't want to end up like the daimyo before me."
                sand
                    New()
                        ..()
                        walk_to(src, locate(/obj/escort/pes1), 0, 5)
                    chichiatsu
                        name = "Daimyo Chichiatsu"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Sand"
                        bark = "You're supposed to be my escort? Well, don't go letting me down."
                    danjo
                        name = "Daimyo Danjo"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Sand"
                        bark = "I paid a lot for this so you better not waste my money."
                    tekkan
                        name = "Daimyo Tekkan"
                        icon = 'WhiteMBase.dmi'
                        village="Hidden Sand"
                        bark = "Hmph. That meeting was a waste of time. Oh well, so you'll be my bodyguards then?"

            white_zetsu
                name = "White Zetsu"
                icon='zettsu.dmi'
                var/punch_cd=0
                var/attacking = 0
                var/tmp/mob/target
                var/retreating = 0
                var/next_punch = "left"
                health=2500
                maxhealth=2500

                SetName() return

                Move()
                    ..()
                    if(!src.attacking)
                        src.FindTarget()

                New()
                    ..()
                    src.ryo = rand(50,150)
                    spawn() src.CombatAI()

    /*			Death(mob/killer)
                    ..()
                        if(zetsu_count > 1)
                            world << output("[killer] has slain a white zetsu! [zetsu_count] remain.", "Action.Output")
                            killer << output ("You gain 5 exp and 100 ryo for your efforts.", "Action.Output")
                            killer.exp += 5
                            killer.ryo += 100 */

                proc/CombatAI()
                    while(src)
                        if(src.target && src.attacking && !src.dead)
                            if(get_dist(src,src.target) <= 1 && !src.punch_cd) src.AttackTarget(src.target)
                            else if(get_dist(src,src.target) > 20) src.Idle()
                            else if(!src.punch_cd) src.ChaseTarget(src.target)
        //					else sleep(10) src.CombatAI()
                        else if(!src.dead) src.Idle()
                        sleep(3)

                proc/Idle()
                    src.attacking = 0
                    src.retreating = 0
                    src.target = null
                    walk_rand(src,10)

                proc/FindTarget()
                    if(src)
                        for(var/mob/M in orange(20))
                            if(istype(M,/mob/npc) || istype(M,/mob/training) || M.village == VILLAGE_AKATSUKI || M.dead) continue
                            if(M)
                                src.target = M
                                src.attacking = 1
                            else src.target = null
    //						spawn(1) src.CombatAI()

                proc/ChaseTarget(mob/M)
                    if(src && M)
                        src.retreating = 0
                        walk_towards(src,M,2)
    //					spawn(5) src.CombatAI()

                proc/AttackTarget(mob/M)
                    if(src && M)
                        switch(next_punch)
                            if("left")
                                next_punch="right"
                                flick("punchl",src)
                            if("right")
                                next_punch="left"
                                flick("punchr",src)
                        M.DealDamage(300,src,"TaiOrange",0,0,1)
                        M.UpdateHMB()
                        M.Death(src)
                        src.punch_cd=1
    //					spawn() CombatAI()
                        sleep(2)
                        src.Retreat(M)
                        spawn(4)
                        src.punch_cd=0

                proc/Retreat(mob/M)
                    if(src && M)
                        walk(src,0)
                        step_rand(src)
                        walk_away(src,M,10,2)
                        src.retreating = 1
                        src.FindTarget()
    //					spawn(1) src.CombatAI()


obj/escort
    pel1
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel2), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel2)
            ..()
    pel2
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel3), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel3)
            ..()
    pel3
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel4), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel4)
            ..()

    pel4
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel5), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel5)
            ..()

    pel5
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel6), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel6)
            ..()

    pel6
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                m.loc = locate(101,200,3)
                walk_to(m, locate(/obj/escort/pel7), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel7)
            ..()

    pel7
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel8), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel8)
            ..()

    pel8
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel9_haruna), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel9_haruna)
            ..()

    pel9_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))
                if(!istype(m, /mob/npc/combat/political_escort/leaf/haruna))
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pel10), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pel10)
                else
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pel10_haruna), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pel10_haruna)
                ..()

    pel10_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/haruna))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel11_haruna), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel11_haruna)
            ..()

    pel11_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/haruna))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel12_haruna), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel12_haruna)
            ..()

    pel12_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/haruna))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel13_haruna), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel13_haruna)
            ..()

    pel13_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/haruna))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel14_haruna), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel14_haruna)
            ..()

    pel14_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/haruna))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel_end_haruna), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel_end_haruna)
            ..()

    pel_end_haruna
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                if(political_escort.squad && political_escort.squad.mission)
                    for(var/mob/s_leader in mobs_online)
                        if(political_escort.squad == s_leader.GetLeader())
                            political_escort.squad.mission.Complete(s_leader)
                            del political_escort
                            break
            ..()
    pel10
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel11), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel11)
            ..()
    pel11
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                m.loc = locate(200,101,5)
                walk_to(m, locate(/obj/escort/pel12_chikara), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel12_chikara)
            ..()
    pel12_chikara
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))
                if(!istype(m, /mob/npc/combat/political_escort/leaf/chikara))
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pel13_toki), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pel13_toki)
                else
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pel13_chikara), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pel13_chikara)
                ..()
    pel13_chikara
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/chikara))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel14_chikara), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel14_chikara)
            ..()

    pel14_chikara
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/chikara))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel15_chikara), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel15_chikara)
            ..()

    pel15_chikara
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/chikara))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel_end_chikara), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel_end_chikara)
            ..()

    pel_end_chikara
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/chikara))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                if(political_escort.squad && political_escort.squad.mission)
                    for(var/mob/s_leader in mobs_online)
                        if(political_escort.squad == s_leader.GetLeader())
                            political_escort.squad.mission.Complete(s_leader)
                            del political_escort
                            break
            ..()
    pel13_toki
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/toki))
                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel14_toki), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel13_toki)
            ..()

    pel14_toki
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/leaf/toki))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pel_end_toki), 0, 5)
                political_escort.next_node = locate(/obj/escort/pel_end_toki)
            ..()

    pel_end_toki
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                if(political_escort.squad && political_escort.squad.mission)
                    for(var/mob/s_leader in mobs_online)
                        if(political_escort.squad == s_leader.GetLeader())
                            political_escort.squad.mission.Complete(s_leader)
                            del political_escort
                            break
            ..()

//SAND escort nodes

    pes1
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes2), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes2)
            ..()
    pes2
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes3), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes3)
            ..()
    pes3
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes4), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes4)
            ..()

    pes4
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes5), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes5)
            ..()

    pes5
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes6), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes6)
            ..()

    pes6
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                m.loc = locate(100,1,6)
                walk_to(m, locate(/obj/escort/pes7), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes7)
            ..()

    pes7
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes8), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes8)
            ..()

    pes8
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes9_chichiatsu), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes9_chichiatsu)
            ..()

    pes9_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))
                if(!istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pes10), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pes10)
                else
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pes10_chichiatsu), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pes10_chichiatsu)
                ..()

    pes10_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes11_chichiatsu), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes11_chichiatsu)
            ..()

    pes11_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes12_chichiatsu), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes12_chichiatsu)
            ..()

    pes12_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes13_chichiatsu), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes13_chichiatsu)
            ..()

    pes13_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes14_chichiatsu), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes14_chichiatsu)
            ..()

    pes14_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes_end_chichiatsu), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes_end_chichiatsu)
            ..()

    pes_end_chichiatsu
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/chichiatsu))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                if(political_escort.squad && political_escort.squad.mission)
                    for(var/mob/s_leader in mobs_online)
                        if(political_escort.squad == s_leader.GetLeader())
                            political_escort.squad.mission.Complete(s_leader)
                            del political_escort
                            break
            ..()
    pes10
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes11), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes11)
            ..()
    pes11
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                m.loc = locate(1,103,4)
                walk_to(m, locate(/obj/escort/pes12_danjo), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes12_danjo)
            ..()
    pes12_danjo
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))
                if(!istype(m, /mob/npc/combat/political_escort/sand/danjo))
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pes13_tekkan), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pes13_tekkan)
                else
                    var/mob/npc/combat/political_escort/political_escort = m
                    political_escort.last_node = src

                    walk_to(m, locate(/obj/escort/pes13_danjo), 0, 5)
                    political_escort.next_node = locate(/obj/escort/pes13_danjo)
                ..()
    pes13_danjo
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/danjo))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes14_danjo), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes14_danjo)
            ..()

    pes14_danjo
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/danjo))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes15_danjo), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes15_danjo)
            ..()

    pes15_danjo
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/danjo))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes_end_danjo), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes_end_danjo)
            ..()

    pes_end_danjo
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/danjo))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                if(political_escort.squad && political_escort.squad.mission)
                    for(var/mob/s_leader in mobs_online)
                        if(political_escort.squad == s_leader.GetLeader())
                            political_escort.squad.mission.Complete(s_leader)
                            del political_escort
                            break
            ..()
    pes13_tekkan
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort))
                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes14_tekkan), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes14_tekkan)
            ..()

    pes14_tekkan
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/tekkan))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                walk_to(m, locate(/obj/escort/pes_end_tekkan), 0, 5)
                political_escort.next_node = locate(/obj/escort/pes_end_tekkan)
            ..()

    pes_end_tekkan
        icon = 'placeholdertiles.dmi'
        icon_state = "escortnode"
        New()
            ..()
            src.icon_state = "blank"
        Crossed(mob/m)
            if(istype(m, /mob/npc/combat/political_escort/sand/tekkan))

                var/mob/npc/combat/political_escort/political_escort = m
                political_escort.last_node = src

                if(political_escort.squad && political_escort.squad.mission)
                    for(var/mob/s_leader in mobs_online)
                        if(political_escort.squad == s_leader.GetLeader())
                            political_escort.squad.mission.Complete(s_leader)
                            del political_escort
                            break
            ..()