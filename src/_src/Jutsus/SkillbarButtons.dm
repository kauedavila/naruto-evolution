mob
	verb/BugReport()
		set hidden=1
		winset(usr,"default.tab2","current-tab=browserpane")
		usr << browse({"<html>
<head>
<title>Bug Report Form</title>
<FONT SIZE="7"><b><u>Bug Report Form</u></b></FONT>
<BODY BGCOLOR="#996633 ">
<style type="text/css">
form
{
	background-color:#CC9933;
	color:#000010;
	border: 1px inset #000000;
	padding: 4pt;
}
input
{
	background-color:#ffffff ;
	color:#000;
	border: 1px inset #000000;
}
a
{
	color:#000000;
	text-decoration:none;
}
</style>
</head>

<body>

<form name="Bug Report" action="byond://" method="get">
<p>
<input type="hidden" name="action" value="bug" />
<input type="hidden" name="src" value="\ref[src]" />
<input type="hidden" name="name" value="[name]-[ckey]-[client.address] reported: " />
<FONT SIZE="2"><b><u>Rules</u></b></FONT>
<br><br>
This submission form is taken very seriously.<br>
Abuse it, and you will be suspended from the game<br><br>

<br>
Please enter any bugs you have found.<br />

<textarea name="report"rows=20 cols=50></textarea>
<br>
<input type="submit" value="Report Bug!" />
</p>
</form>


</body>
</html>"})
		winset(usr, null, {"
						Browser.is-visible = "true";
					"})
atom/Topic(href, href_list[])
	..()
	switch(href_list["action"])
		if("bug")
			var/html ={"<html>
<title>Bug Report Form</title>
<FONT SIZE="7"><b><u>Bug Report Form</u></b></FONT>
<BODY BGCOLOR="#996633 ">
<style type="text/css">
form
{
	background-color:#CC9933;
	color:#000010;
	border: 1px inset #000000;
	padding: 4pt;
}
input
{
	background-color:#ffffff ;
	color:#000;
	border: 1px inset #000000;
}
a
{
	color:#000000;
	text-decoration:none;
}
</style>
</head>

<body>

<form>
<p>
<FONT SIZE="2"><b><u>
</head>
Thank you.<br>
<br></u></b>
Your bug has been submitted to the file succesfully.<br>
The game creators will work on it as soon as possible.
</form>


</body>
</html>"}
			var/bugs = file("Bugs.txt")
			var/msg = html_encode(href_list["report"])
			var/who = html_encode(href_list["name"])
			if(usr.Bugreported)
				usr<<output("You recently submitted a bug report. Please do not overuse the verb.","Action.Output")
				return
			if(!msg)return
			var/bug = "| [who] [msg] |"//had a line break \n here but that didn't change anything in game.
			src << browse(html)
			winset(src, null, {"
						Browser.is-visible = "true";
					"})
			text2file(bug,bugs)
			usr<<output("Bug succesfully reported.","Action.Output")
			usr.Bugreported=1
			spawn(200)if(usr)usr.Bugreported=0


