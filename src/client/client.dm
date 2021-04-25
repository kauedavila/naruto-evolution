client
	var/tmp/channel = "Local"
	New()
		..()
		clients_connected += src
		winset(src, null, {"
			Main.is-maximized=true
			Main.Child.right=Titlescreen;
			Main.OutputChild.is-visible=false;
			Main.ActionChild.is-visible=false;
			Main.NavigationChild.is-visible=false;
			Titlescreen.Child.left=Map;
			Character.is-visible=false;
			Inventory.is-visible=false;
			Settings.is-visible=false;
			Browser.is-visible=false;
			Leader.is-visible=false;
			Main.UnlockChild.is-visible = "false";
		"})

	Del()
		..()
		clients_connected -= src
		clients_online -= src

	Topic(href, href_list)
		if(href_list["changelog"] && href_list["changelog"] == "current")
			src << browse("[CHANGELOG]")
			winset(src, "Browser", "is-visible = 'true'")

		else if(href_list["changelog"] && href_list["changelog"] == "previous")
			src << browse("[CHANGELOG_PREVIOUS]")
			winset(src, "Browser", "is-visible = 'true'")
		..()

	verb
		Tab()
			set hidden=1
			world << winget(src, null, "focus")