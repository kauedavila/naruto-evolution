obj
	events
		genin_exam
			genin_exam
				icon = 'building insides.dmi'
				icon_state = "paper"
				mouse_opacity = 2
				DblClick()
					. = ..()
					world.GeninExamWritten(usr)

		election
			ballot_box
				leaf_ballot_box
					icon = 'ballot_box.dmi'
					icon_state = "ballot_box"
					name = "Ballot Box"
					density = 1

					DblClick()
						..()
						if(hokage_election)
							if(usr.village == VILLAGE_LEAF)
								if(!hokage_election_votes.Find(usr.ckey) && !hokage_election_votes.Find(usr.client.computer_id) && !hokage_election_votes.Find(usr.client.address))
									var/election_ballot/ballot = input("Who would you like to vote for this election? <b><font color ='red'>You can only vote once per election.</font><b>", "Ballot Box") as null|anything in hokage_election_ballot
									if(ballot)
										if(ballot.ckey != usr.client.ckey)

											if(!hokage_election_votes.Find(usr.ckey) && !hokage_election_votes.Find(usr.client.computer_id) && !hokage_election_votes.Find(usr.client.address))
												hokage_election_votes.Add(usr.ckey)
												hokage_election_votes.Add(usr.client.computer_id)
												hokage_election_votes.Add(usr.client.address)
												ballot.votes++
												usr.client.prompt("You your vote for [ballot.character] has been accepted.", "Ballot Box")
											else
												usr.client.prompt("You have already cast your vote for the current [RANK_HOKAGE] election.", "Ballot Box")
										else
											usr.client.prompt("You cannot cast a vote for yourself in the [RANK_HOKAGE] election.", "Ballot Box")
								else
									usr.client.prompt("You have already cast your vote for the current [RANK_HOKAGE] election.", "Ballot Box")
							else
								usr.client.prompt("This ballot box is for the [VILLAGE_LEAF] elections.", "Ballot Box")
						else
							usr.client.prompt("There is not currently an on-going election for [RANK_HOKAGE].", "Ballot Box")

				sand_ballot_box
					icon = 'ballot_box.dmi'
					icon_state = "ballot_box"
					name = "Ballot Box"
					density = 1

					DblClick()
						..()
						if(kazekage_election)
							if(usr.village == VILLAGE_SAND)
								if(!kazekage_election_votes.Find(usr.ckey) && !kazekage_election_votes.Find(usr.client.computer_id) && !kazekage_election_votes.Find(usr.client.address))
									var/election_ballot/ballot = input("Who would you like to vote for this election? <b><font color ='red'>You can only vote once per election.</font><b>", "Ballot Box") as null|anything in kazekage_election_ballot
									if(ballot)
										if(ballot.ckey != usr.client.ckey)

											if(!kazekage_election_votes.Find(usr.ckey) && !kazekage_election_votes.Find(usr.client.computer_id) && !kazekage_election_votes.Find(usr.client.address))
												kazekage_election_votes.Add(usr.ckey)
												kazekage_election_votes.Add(usr.client.computer_id)
												kazekage_election_votes.Add(usr.client.address)
												ballot.votes++
												usr.client.prompt("You your vote for [ballot.character] has been accepted.", "Ballot Box")
											else
												usr.client.prompt("You have already cast your vote for the current [RANK_KAZEKAGE] election.", "Ballot Box")
										else
											usr.client.prompt("You cannot cast a vote for yourself in the [RANK_KAZEKAGE] election.", "Ballot Box")
								else
									usr.client.prompt("You have already cast your vote for the current [RANK_KAZEKAGE] election.", "Ballot Box")
							else
								usr.client.prompt("This ballot box is for the [VILLAGE_SAND] elections.", "Ballot Box")
						else
							usr.client.prompt("There is not currently an on-going election for [RANK_KAZEKAGE].", "Ballot Box")
