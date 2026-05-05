# Community Tutorials
This document is contains several community-written tutorials for various modding topics.

Sections:
- How to add a preview video for your map (lines 18-105)
- How to add an Era (lines 107-196)
- How to change the color of your mapname (lines 198-237)
- How to alter the Label, Icon, and Description of a Game Mode (lines 239-307)
- How to munge a custom LVL file (lines 309-339)
- Side and Jedi Creation Guide (lines 341-1031)
- Making Mods in SWBF2 (lines 1033-1382)
- Procedural Animations in ZeroEditor (lines 1384-1473)
- Sound Editing and You (lines 1475-1651)
- Custom Sound Effects Implementation (lines 1653-1802)

---

# How to add a preview video for your map (by Zerted)
## Video Suggestions:
- Keep it short
- Keep its file size small
- There is no audio, so don't include any
- Don't expect any viewers to be able to read any text
- The video will be displayed in a box of 150 by 150 pixels by default
- There is a one second fade in and a one second fade out.  If you do not want the fading, use 'preview-loop' instead of 'preview'
- The video loops until another map is selected
- If you can create the two video formats, both pre-movie.mvs and pre-moviepal.mvs should be used

## Tools Needed:
- A screen or video capture tool
- RAD Game Tools (free): https://www.radgametools.com/bnkdown.htm
- SWBF2 UnOfficial patch installed (so you can see your video ingame)

## Assumptions:
1) You have SWBF2 and its mod tools installed
2) You have done some modding before and you sort-of know what you are doing
3) You know how to pick your own video capture/recorder tool
4) You have a map you want to add a preview video to (this example uses a map named PVE, so whenever you see PVE or pve, replace it with your map's code)
5) Your map has had its 'Common' munged at least once
6) You are not using the PAL version of the game. If you are, `pre-movie.mvs` should be `pre-moviepal.mvs`

## Setup:
1) Have SWBF2 installed
2) Have the SWBF2 mod tools installed
4) Install RAD Game Tools

## Create the video:
1) Start Battlefront and load your map
2) Start your video capture tool and create whatever video you want to make

## Convert the video:

0) Note: the following values are only suggested values.  They may be changed for each video.  The goal is to make the video as small as possible without losing too much graphically quality
1) Open the RAD Video Tools
2) Select your video and click 'Bink it!'
3) Set 'Compress to data rate (bytes)' to 750000
4) Select the radio button 'multiple of the overall data rate:' and use 3.0
5) Set 'Scaling compression' to 'No scalling'
6) Set 'How many frames to preview during bandwidth allocation' to 12
7) Set the width to 150 and the height to 150
8) Set the contrast to 8
9) Set the 'Smooth %' to 3
10) Check 'De-interlace'
11) When you are done changing the settings, click 'Blink' to convert your video
12) Wait for the tool to finish converting your video.

## Munge the video:
1) Move and rename your bik video to `data_PVE/Shell/movies/PC/preview.bik`
2) Create a movie list text file called `pre-movie.mlst` in `/data_PVE/Shell/movies/PC`.  When munged, this file will turn into the `pre-movie.mvs`, which contains your preview movie embedded inside.
3) In `pre-movie.mlst`, type in the path to your video.  Example: `..\..\Shell\movies\PC\preview.bik`
4) Optional step (prevents a munge error): Create `shell.req` in `data_PVE/Shell`
5) Optional step (prevents a munge error): In `shell.req`, add: `ucft{}`
6) Run VisualMunge for you map
7) Click 'Unselect All'
8) Check 'Shell'
9) Click 'Munge'
10) When the munge has finished, you will find your new `pre-movie.mvs` in `data_PVE/_LVL_PC/Movies`

## Add the video:
1) Pick a location for your movie file.  It can be placed anywere, but the recommended location is `GameData/addon/PVE/data/_LVL_PC/movies`
2) Copy your munged video (pre-movie.mvs) to this location
3) Open the addme.lua `data_PVE/addme/addme.lua` file from your mod map
4) Around line 23 is the line that you edit to change your map's game modes. Edit this line to include the movie file, the movie name, and 'dnldable = 1' (dnldable is optional). An expanded example is shown below. Its important to note that the 'movieFile' does include the file name of the video, but does not include its '.mvs' extension or the 'pal' part for PAL users. Also, the 'movieName' is the name you used in movies.mcfg's `MovieProperties()` `Name` property:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
    movieFile = "..\\..\\addon\\PVE\\data\\_LVL_PC\\PVE\\movies\\pre-movie",
    movieName = "preview",
    dnldable = 1,
    isModLevel = 1,
    mapluafile = "PVE%s_%s",
    era_c = 1,
    mode_con_g = 1,
}
mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]
```
5) Run VisualMunge for you map
6) Click 'Unselect All'
7) Click 'Munge'

## Viewing your video in SWBF2 (v1.3):
1) Start the game
2) Go to the IA or MP map selection screen
3) Click on your map
4) Watch the preview video box for your video

# How to add an Era (by Zerted)
This tutorial will take you through the process of adding an example 'y' era with a Conquest game mode to the example 'LVL' map.

## Basic Era Support
1) In `data_LVL/addme/addme.lua`, add `era_y = 1,` to the `sp_missionselect_listbox_contents` table. This tells the game to display the Y era checkbox when the map is selected in the selection screen.
2) In the same addme.lua file, add `mode_con_y = 1,` to the `sp_missionselect_listbox_contents` table. This tells the game to display the Conquest mode checkbox when the map is selected in the selection screen. The "_y" allows the game to know that this game mode corresponds to the Y era.
3) As an example, these are the orginal listbox table lines:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
    isModLevel = 1,
    mapluafile = "LVL%s_%s",
    era_g = 1,
    era_c = 1,
    mode_con_g = 1,
    mode_con_c = 1,
}
```
    These are the *updated* listbox table lines:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
    isModLevel = 1,
    mapluafile = "LVL%s_%s",
    era_g = 1,
    era_c = 1,
    era_y = 1,
    mode_con_g = 1,
    mode_con_c = 1,
    mode_con_y = 1,
}
```
4) In the same addme.lua file, add the line `AddDownloadableContent("LVL","LVLy_con",4)`  before the `-- all done` comment
5) In `data_LVL/Common/mission/`, create the file `LVLy_con.req`. This file name corresponds to the `LVLy_con` in `AddDownloadableContent()` and the values entered into the listbox table.
6) In `data_LVL/Common/mission/LVLy_con.req`, insert the following code. The code tells VisualMunge what is needed when building the map's lvls. The "script" section tells what additional scripts to include and the "config" section deals with the movie configurations. The following code to insert is:
```
ucft
{
	REQN
   	{
        "config"
       	"cor_movies"
   	}
	REQN
	{
		"script"
		"LVLy_con"
	}
}
```
7) In `data_LVL/Common/mission.req`, add `"LVLy_con"` to the `"lvl"` section. This tells VistualMunge to include everything in our newly created `data_LVL/Common/mission/LVLy_con.req` file when munging the map's `mission.lvl`. The mission.lvl is where all of the map's game mode script files should end up.
8) In `data_LVL/Common/scripts/LVL/`, create the file `LVLy_con.lua`. It is easiest do this by copying an exist Conquest script, such as `LVLg_con.lua`. If you don't copy the file, you will need to manually add in all the Conquest scripting details. This tutorial does not cover the finer parts of game mode scripting, but only what changes are needed for a custom era. Our new `LVLy_con.lua` is the script we referrenced a few steps ago in the "script" section of `data_LVL/Common/mission/LVLy_con.req`. Following through the reqs, this is the actual lua script file which will be munged into the map's `mission.lvl`.
9) Munge Common
10) Thats it. If you only want basic era support for the map you are done. If you open up SWBF2, your map will now display a Y era Conquest mode. If thats all you wanted, you can stop reading this tutorial. However, if you want full era integeration there is still much to do...

## Full Era Integeration
1) The parts that are missing from basic era support are custom side icons, custom CP icons, and custom side names. This advanced part of the tutorial will help you enable or add these features to your map. Step-wise, it continues where the basic era support section left off.
2) In `data_LVL/Common/scripts/LVL/LVLy_con.lua`, add the line `SupportsCustomEraTeams = true` at the top of the file. This will tell the team selection screen to go around the game's orginal design and use your custom team/side names instead.
3) In `data_LVL/Common/scripts/LVL/LVLy_con.lua`, add the line `CustomEraTeam2 = "Era Team 2"` right below the SupportsCustomEraTeams line. Replace `Era Team 2` with the name of your second team's name.
4) In `data_LVL/Common/scripts/LVL/LVLy_con.lua`, add the line `CustomEraTeam1 = "Era Team 1"` right below the SupportsCustomEraTeams line. Replace `Era Team 1` with the name of your first team's name.
5) In `data_LVL/Common/scripts/LVL/LVLy_con.lua`, take a close look at the `SetupTeams` section. You will see something like:
```lua
SetupTeams{
	all = {
		team = ALL,
		units = 20,
		reinforcements = 150,
		soldier	= { "all_inf_rifleman",9, 25},
```
The lowercase `all` is the *real* team name. According to the docs, SWBF2 has nine predefined team names (neutral, neu, alliance, all, empire, imp, republic, rep, cis). Everything else maps to locals. This is not truly the case as "Villains" is also predefined, but those that are predefined and those that aren't has never been fully researched (would you like to be the first?). The team name manages the game's references for the team's name, team's icon, team's CP icons, and the team's unit names.
6) Make note of your two team names. `all` maps to `alliance`, `imp` maps to `imperial`, `rep` maps to `republic`, and 'cis' maps to `CIS`. The team names are *case-insenstive*.
7) Create your CP holo icon meshes. You can start from scratch or build off of an existing one like `data_LVL/Common/mshs/com_icon_cis.msh`. If needed, don't forget to create the msh's `.option` file too (com_icon_cis.msh.option).
8) The custom CP holo icons go in `data_LVL/Common/mshs/`. Depending on your team name mappings, each icon should have one of the following names: `com_icon_alliance`, `com_icon_imperial`, `com_icon_republic`, or `com_icon_CIS`. If your map is CTF based, you might also want to look into `com_icon_swap`.
9) Open `data_LVL/Common/ingame.req` and wipe everything out. We since are going to be creating a custom ingame.lvl for this map, we only want to override the elements which have been changed. If you try to include everything the game might crash, but you would also override any other `ingame.lvl` mods the user might have installed.
10) Put the following code in `data_LVL/Common/ingame.req`. Make sure to adjuest it for your team names. The example uses a `SetupTeams` section with `all` and `imp` team names:
```
ucft
{
	REQN
	{
		"model"
		"com_icon_alliance"
		"com_icon_imperial"
	}
}
```
11) Munge Common
12) In `data_LVL/_LVL_PC`, rename the new `ingame.lvl` to `y_con-ingame.lvl`.  The 'y_con' part stands for the Y era and game mode Conquest. The renaming is not required, but should be done if you want to override the icons with different icons in other era/game modes of your map.
13) In `data_LVL/Common/scripts/LVL/LVLy_con.lua`, add `ReadDataFile("dc:y_con-ingame.lvl")` right before the non-'dc:' version of the line. This tells the game to read your map's ingame.lvl before reading the default ingame.lvl. Since your ingame.lvl is read first, its CP icons will be the ones used.
14) You will need to remember to manually copy the munged `data_LVL/_LVL_PC/y_con-ingame.lvl` to your munged map's `GameData/addon/LVL/data/_LVL_PC/` folder any time you need to create a new `y_con-ingame.lvl`. A 'normal' mod map does not have a custom ingame.lvl, so VisualMunge will not move it for you. Do that copy now, so you don't forget to later.
15) Rename `data_LVL/Common/ingame.req` to `y_con-ingame.req`. This is so you always have a copy of the req that created the `y_con-ingame.lvl`. If you want to make a new `y_con-ingame.lvl`, rename that file back to `ingame.lvl`. VisualMunge does not build custom named lvls by you just creating a differently named req file.
16) Test your map

# How to change the color of your mapname in the map selection screens (by Zerted)
## Background Color Info:
SWBF2, like may other computer programs, deals with colors in terms of rgb or red, green, and blue.  Using different combinations of red, green, and blue allows you to make almost any color.  A value of zero means none of that color and a value of 255 means all of that color. For example: a r,g,b value of `0,255,0` would be shown as a pure green.

0) This guide will assume the mod map is named DMD.
1) Open up your `data_DMD/addme/addme.lua`
2) Search for your map's configuration line. It will look something like:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
    isModLevel = 1,
    mapluafile = "DMD%s_%s",
    era_g = 1,
    mode_con_g = 1,
}
```
3) To change the color of your map, just add in the color and its value. For example, the following line would cause your map name to become black:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
    red = 255, blue = 255, green = 255,
    isModLevel = 1,
    mapluafile = "DMD%s_%s",
    era_g = 1,
    mode_con_g = 1,
}
```
You don't have to include all of the colors (red, blue, green). You could just change the red or two of the three colors:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
    red = 151, green = 87,
    isModLevel = 1,
    mapluafile = "DMD%s_%s",
    era_g = 1,
    mode_con_g = 1,
}
```
4) Save the addme.lua
5) Munge your map (Common can be unchecked, but it doesn't really matter)

Tip: Some colors are hard to see in the selection screen. Try to use the easy to see colors.
> Note: Players can disable the custom map colors through the v1.3 patch's installer menu.

# How to alter the Label, Icon, and Description of a Game Mode (by Zerted)
This tutorial will take you through the process changing the displayed label, icon, and description of a Conquest, G era map.

## Backgound:
* The v1.3 patch supports over 38 game modes and 27 eras. If you want to add a new game mode or era, look at these predefined ones first. Checkout the change log for shell.lvl and common.lvl to see exactly what was added and is directly supported.
* This tutorial will assume you have created a basic LVLg_con map.

## Basic Era Support
1) In `data_LVL/addme/addme.lua`, expand your `sp_missionselect_listbox_contents` table. Meaning, put each element on a line by itself so the table is easier to read, like this:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
	isModLevel = 1,
	mapluafile = "LVL%s_%s",
	era_g = 1,
	mode_con_g = 1,
}
```
2) Edit the table to add the 'change' table:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
	isModLevel = 1,
	mapluafile = "LVL%s_%s",
	era_g = 1,
	mode_con_g = 1,
	change = {
	
	},
}
```
3) We want to change the Conquest game mode, so add another table inside the new 'change' table. The name/index of the new table has to match the game mode key. For Conquest, the key is 'mode_con'. So we will include that key in the change block like so:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
	isModLevel = 1,
	mapluafile = "LVL%s_%s",
	era_g = 1,
	mode_con_g = 1,
	change = {
		mode_con = {  },
	},
}
```
4) Add indexes for Conquest's new name ('name'), new icon ('icon'), and new description ('about'). You only need to add the indexes you want to change, but this tutorial changes all of them so:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
	isModLevel = 1,
	mapluafile = "LVL%s_%s",
	era_g = 1,
	mode_con_g = 1,
	change = {
		mode_con = { name="Candy Conquest", icon="mode_icon_holo", about="Drop off ten cubes of sugar at your ant hill (CP) to win.  Watch out for human overlords, kids with magnifying glasses, other ant colonies, and sticky traps..." },
	},
}
```
5) Munge your map. Since we only changed addme.lua, you don't need to check or select anything in VisualMunge. This will greatly decrease its munge time.
6) Start the game. In the map selection screens, your map's Conquest game mode checkbox will now be labeled 'Candy Conquest' and its icon and description will have changed too.
7) In addition to Conquest, we also wanted to chagne the era's name and icon (eras display no descriptions). The procedure is the same except we use the era's key instead of the game mode's key and an index of 'icon2' instead of 'icon'. Here is the completed example table:
```lua
sp_missionselect_listbox_contents[sp_n+1] = {
	isModLevel = 1,
	mapluafile = "LVL%s_%s",
	era_g = 1,
	mode_con_g = 1,
	change = {
		era_g = { name="Ant Wars", icon2="rvb_icon" },
		mode_con = { name="Candy Conquest", icon="mode_icon_holo", about="Drop off ten cubes of sugar at your ant hill (CP) to win.  Watch out for humans overlords, kids with magnifying glasses, other ant colonies, and sticky traps..." },
	},
}
```
8) In your map's readme, make sure to list that the 'v1.3 UnOfficial patch r112+' is required to correctly view the game mode/era. If the player doesn't have the v1.3 UnOfficial patch, then the map's mission will still be displayed, but it will show the original values (i.e. 'Conquest' instead of 'Candy Conquest').

# How to munge a custom LVL file (by Zerted)
## Overview
* This tutorial will guide you through munging a custom lvl file

## Requirements
* SWBF2 mod tools
* Basic understanding of modding
* Basic understanding of the munge process

## How To Do It
1) This guide will assume the mod map is XXX
2) Create the folder: `data_XXX\Shell`
3) Create the text file: `data_XXX\Shell\shell.req`
4) Create the folder `data_XXX\Shell\scripts`
5) Create the script file: `data_XXX\Shell\scripts\test.lua`
6) In `shell.req`, add:
```
ucft
{
    REQN
    {
        "script"
        "test"
    }
}
```
7) Open VisualMunge, click "Unselect All", check "Shell", click "Munge"
8) When VisualMunge finishes, it will have created the lvl file: `data_XXX\_LVL_PC\shell.lvl`
9) Rename `shell.lvl` to whatever name you need, then move it to where you need the file.

> Notes: The test.lua script is just an example script file. You should change the req file to reflect whatever it is you are trying to munging.

# Side and Jedi Creation Guide
by Someone Who Left Out All The Important Bits

Special Note:
  I will be avoiding all avoidable Star Wars references throughout this guide - not once will I refer to you as Young Padawan, for example.  Can’t stand that stuff.

Contents:
1 – Introduction
2 – Creating Your Own Side:  The Basics
3 – A Jedi:  Components and the Character ODF
4 – A Jedi Weapon ODF (Y’know, Those “Light”…Thingies…)
5 – The Combo File
6 – Final Notes


1 – Introduction
Hmm, it seems someone has gotten ahead of himself…I thought I heard somewhere that you want to create a Jedi.  Well, then you’ve come to the right place, Young Pada…..ha, gotcha.  In order to create a Jedi, or any other soldier, you will have to do a few things:  First, you will have to create a side for your Jedi to be part of, or if you have already created your own side, you will have to add the REQ files for a new character.  Then you will have to create the basic character for your Jedi - this means making sure everything important is included in the side, such as textures, models, and animations.  It also includes learning about cloth and tentacles – or perhaps you owned a Dress-Me-Up Squid™ as a child and already know all about both of those topics.  Then you craft your Jedi’s weapon, force powers, and moves - or more likely you steal them from other Jedi, since you, like me, don’t have a clue how to animate!  Unlike a “real” Jedi, this process doesn’t include a years-long quest for finding some type of crystal or other, sleeping outside under the stars and drinking nothing but Venti Lattes – no foam, soy milk and just a hint of cinnamon, and I swear if you put regular milk again in I’m going to have my severe gastrointestinal reactions in your face, you hear?!
Ahem.
Let’s get started, dudette.  Soon you will be just as confused as I am.

2 – Creating Your Own Side:  The Basics
	This assumes you already have a world in which to work – preferably one created by VisualMunge, which has a “Worlds” folder and an “addme” folder and all that chunky goodness.  
First thing you need to do is create a “sides” folder.  Into that folder, copy the “Common” folder from within the mod-tool “assets/sides” directory.  Note that this is NOT the same folder as “assets/common”, this is “assets/sides/common”!  This folder is necessary because it contains all the things that are used by every side in the game – the default soldier class, default effects and lightsaber meshes, and other things.  
Then you must create a sub-folder in that with the name of your side – it is not limited to 3 letters, I think, but I will keep with that convention and name my side “JDI”.  Within your side folder, several new folders must also be created.  These are: effects, munged, msh, odf, and req.  As shown:

	What’s the point of all these folders?  They contain things specific to your side, not found in the Common folder…
    • The Effects folder contains particle effects used by your side, such as explosions, powerups, and hit effects.
    • The MSH folder contains assets used by your soldiers, such as .MSH files (models/geometry), TGAs (textures), and the associated .option files for those models and textures.
    • The Munged folder contains munged animation data organized per skeleton, such as melee combo attacks, specialized weapon-firing animations, individual unit movement animations (walk/run/jump), etc.  Don’t worry too much about this yet.
    • The ODF folder contains .ODF files (“Object Definition File”) for your side’s soldiers, weapons, ordnance, and other objects.
    • The REQ folder contains .REQs, or requirement lists, for each unit on your side.  A unit’s REQ contains a list of the ODFs required or used by that unit, and additionally any textures, models, or effects not explicity mentioned in those ODFs.   A REQ is used by the munge process when packing data into a .LVL file, so that everything required by that unit is sure to be loaded when that unit is loaded into a game level.

Whew.  Now on to actually creating the files for your side.

Step 1 – The soldier’s ODF.
Off into the ODF directory we go.  An ODF is a soldier’s identity – it defines him (or her, to be fair), tells him (or her, to be fair) what he can do and what he (or she, tbf, okay I’ll stop) can use, and generally IS that unit.  For now, we don’t need to have anything in it, we just need to make one so we can reference it in the other side-creation steps.
Let’s decide on a name for our soldier – how about demojedi?  Sure, that may not do it for you, and really I’m not so keen on it either, but this IS a tutorial.  So everything that has to do with this soldier will be derived from this name.  Also, to prevent confusion, we will prepend the name of the side – so jdi_demojedi is his name-o.  Let’s create his ODF, which is blank for now:
    
Step 2 – The Soldier’s REQ.
	Now that the soldier exists, we must create a REQ file for him, in the “req” folder.  So far, this REQ will only include the soldier’s ODF, as that is all that must be included for the soldier to be loaded because the ODF directly references everything else – models, textures, weapons, etc.  In some cases this may not be true, but generally a soldier’s REQ only needs to include his ODF.
	So then, in the req folder we create the REQ:
 
And what goes in it:

ucft
{
    REQN
    {
        "class"
        "jdi_demojedi"
    }
}

All REQ files must begin with “ucft”, and each section is surrounded by curly braces {}.  REQN is a section title, and it means require these things.  The first line in a REQN section is the type of thing required – “class” means the files come from the ODF folder, and end in “.odf”.  So in this case, the REQ makes sure that “ODF/jdi_demojedi.odf” is included in the side.

Step 3 – The side’s REQ.
In the base directory of your side goes the main side REQ, called “[side’s name].req” – in our case, “jdi.req”.  This file will be a list of which REQ files from the req folder will be included in your final munged side LVL file.  Suffice it to say, if a soldier is completely made and has a REQ in the req folder, but that REQ is not included in the side’s REQ, that soldier won’t be available to load in the game.  The file:
 

And what’s inside:
ucft
{
    REQN
    {
        "lvl"
        "jdi_demojedi"
    }
}

The “lvl” line means that the files that are included end in “.req” and comes from the “req” folder.  Every .REQ file is munged into an LVL, with the soldier’s LVL (jdi_demojedi.req -> jdi_demojedi.lvl) being included in the final side’s LVL (jdi.req -> jdi.lvl).  The side’s LVL is what is actually loaded by the game, and sub-LVLs inside are accessed to load specific solder classes.  You can look in the “assets/sides” folder to see how the shipped game’s sides were organized.

Step 4 –The side’s munged-data folder.

	This is the final step for creating the framework of your side.  If you open up your mod’s directory (in our case, data_SID), then go into the _BUILD folder, there should be a Sides directory.  Inside this directory, we must create the folder where our side’s munged data will go.  It has the same name as our side’s main folder (“JDI”), and you will need to copy the clean.bat and munge.bat from one of the other sides’ munged-data folders into it.  Like so:

and then copy  _BUILD/Sides/ALL/clean.bat and munge.bat into that folder.  NOT clean.bat and munge.bat from _BUILD/Sides – those are different!  


Step 5 - All ready!

At this point, you should be able to open up your mod’s VisualMunge and see that in the “SIDES” box there is indeed a JDI side, ready and waiting to be munged.  Remember:  the first time you munge, you must munge your world with the Common check-box checked, as well as the JDI side.  After that, if you change your side, you can un-check the Common check-box and just munge your side (and your world, but there’s no escaping doing that).
If you do munge now, then it will create the folder “[your mod dir]/_LVL_PC” and inside that, “SIDES”, and inside that it will place “jdi.lvl”.  At this point jdi.lvl has nothing in it, but this means the framework is set up correctly.  Congratulations!  That’s the easy part.  =^.^=

3 – A Jedi:  Components and the Character ODF

***Important:  If your text-editing application likes to insert curly quotes “” instead of straight quotes "", USE A DIFFERENT ONE.  Curly quotes will break everything.  We recommend Notepad (^.^) or Ultraedit.  We de-recommend Microsoft Word and Wordpad.

So, now we’ve got a blank ODF and we want to create a Jedi from it.  MUCH of this section is going to assume you already have a model and texture and animations created, because creating those is outside the scope of this document.  If you need, for learning purposes, feel free to “borrow” models and animations and things from one of the shipped game’s sides.  Personally I like the Wampa, but for a more human feel we’re going to use Tatooine Luke (who was made, but never appeared in the game, unfortunately).

Assets and “.option” files:
For soldiers’ purposes, “assets” are models or textures, and they are generally placed in the “MSH” directory.  Each asset can have an associated “.option” file – for example, if I have test.msh, then I can create test.msh.option as well.  Option files are simply text files that contain various parameters to direct the munge process to treat those assets differently.  For example, a MSH option file can contain “-nocollision”, which will cause the munger not to generate collision for that mesh, or a TGA option file can contain “-maps 1” to direct the engine never to use a less-detailed mipmap for that texture.  Soldier MSHs generally do have “-nocollision”, and soldier TGAs generally do have “-maps 1”, but there are many other parameters that option files can provide.

For a  typical soldier, there is:
- A character model and texture – in our case all_inf_tatooinelukeskywalker.msh and .tga.
- A lowres model - all_inf_tatooinelukeskywalker_low1.msh and .tga.
- And any other models and textures needed (lightsaber model and texture, in our case).

These assets are all placed in the MSH directory and are reference by the soldier’s ODF, and various ODFs for weapons and other things.  Which brings us to...

A Soldier’s (or a Jedi’s) ODF

Note:  For lots of things, there are Jet parameters.  The only difference between a Jedi and a Jet Trooper (or Dark Trooper) is that a Jedi has a lightsaber as a weapon.  If your soldier has a lightsaber, they will force-jump or Vader-style hover.  If not, they will Dark- or Jet-Trooper-style jet-jump or hover.  There is no way around this, although you can control the action type (jump vs. hover) and you can provide a different animation for each one.

The Basics:
	A Jedi ODF will ALWAYS begin with the following lines, which I have commented so they can hopefully be understood:

// any text following two slashes is a comment
// the section following `[GameObjectClass]` is for 
// MUST include ClassParent, which is used
// by Battlefront 2 to determine which class
// this soldier derives from.
// Alternately to ClassParent, you may use
// ClassLabel = "soldier"
// however, the ODF for “com_jedi_default” sets up
// values we like, so we leave this class deriving from it.
`[GameObjectClass]`
ClassParent = "com_jedi_default"

// the Properties section defines everything else 
// about the soldier
`[Properties]`

// which type of connections this soldier will follow
// on the AI path graph for the level
// - soldiers are generally “SOLDIER”, but
// - those that can jet, jetjump, or forcejump are “HOVER”
AISizeType = "HOVER"

// Don't take damage from collisions with objects in the world
CollisionScale      = "0.0 0.0 0.0" // x, y, then z scales 

// the model (filename ends in .msh, and is located in the // MSH folder) to use for our character
// NOTE:  Omit the .msh from the name!
GeometryName = "all_inf_tatooinelukeskywalker"

// the model to use for our character when he is far away
// (Generally this model is cheaper to render)
// if this line is not present the model will disappear
// when viewed from far away, and this geometry CANNOT
// be the same file as the high-res geometry!
GeometryLowRes = "all_inf_tatooinelukeskywalker_low1"

// the next line can be one of 3 choices:
// - Not included (blank), if the model wants to use the
//   “human_sabre” skeleton and animations.
//   (Those are Luke Skywalker’s animations, but we
//   will be defining our own so we are going to 
//   use this line anyway).
// - AnimationName if this model uses the basic human 
//   skeleton, but wants to provide its own animations
//   as a set of files in the “munged” folder.
// - SkeletonName if this model wants to use its own
//   skeleton in addition to its own animations.

// NOTE – if this model’s animation set does not define
//        an animation, such as “stand_walkforward”, 
//        the default animation from the current weapon
//        will be used instead.  For example,
//        if he is carrying a rifle, it will use
//        human_rifle_stand_walkforward, and if he is
//        carrying a lightsaber it will use
//        human_sabre_stand_walkforward.
//        For specialized additional animations 
//        such as melee attacks, they MUST be defined 
//        by this model’s animation set.

// for the demo, we will be using the base skeleton
// but redefining SOME of the animations
AnimationName = "tat_luke"

// there may also optionally be a 
// SkeletonNameLowRes or an AnimationNameLowRes
// if the low-res animations are different from
// the high-res ones...

// **** The following lines are the default Jedi parameters.
// They are fairly straightforward and usually not changed,
// so mess with them if you see fit.
// Force Jump ignores the Jet numbers and just uses the Jump
// numbers, but they still must be defined.

//The initial jump-push given when enabling the jet
JetJump = "10.0"    
//The constant push given while the jet is enabled (20 is gravity)
JetPush = "0.0"
// for characters with jet jump, use this acceleration for 
// in-air control
JetAcceleration = "10.0"    
// the particle effect to show while jetting
JetEffect = ""
//Additional fuel per second (fuel is 0 to 1)
JetFuelRechargeRate = "0.0" 

// optional, tells this character to hover (Darth Vader, Jet Trooper)
// versus jump (Luke Skywalker, Dark Trooper)
//JetType = "hover"
// Vader used JetFuel to control how long he can hover, 
// even though it's not visible in the HUD

//Cost per second when hovering (only used for jet-hovers)
//(fuel is 0 to 1)
JetFuelCost = "0.0"
//initial cost when jet jumping(fuel is 0 to 1)
JetFuelInitialCost = "0.0"
//minimum fuel to perform a jet jump(fuel is 0 to 1)
JetFuelMinBorder = "0.0" 
// display the meter for jet fuel, or don’t display it
JetShowHud = 0
// How much Sprint energy to take away per jet activation or force-jump
JetEnergyDrain = 40.0

// the foley effects to use when walking around, falling, rolling, etc.
// generally this doesn’t deviate from rep_inf_soldier, 
// cis_inf_soldier, all_inf_soldier, imp_inf_soldier,
// or wok_inf_soldier (for Wookiees).
FoleyFXClass = "rep_inf_soldier"

// We are skipping the rest of the sound section (grunts, groans,
// hero voiceovers) for this guide.

// Tentacles and cloth go here, if any...
// (see below for an explanation of these lines)
ClothODF = “all_inf_tatooinelukeskywalker_cloth”

// Now for weapons – you can have up to 8 different weapons.
// Each one is defined in a WEAPONSECTION.
// Parameters include:
// - WeaponName – the name of the ODF that defines it.
// This ODF can come from common, sides/common, or the side itself.
// It can also come from a different side, but only if that side 
// is loaded before this soldier in your mission LUA.  Otherwise,
// BF2 will crash. 
// - WeaponAmmo – max number of ammo clips this weapon holds.
//   It will start with this much ammo.  Zero is infinite ammo,
//   used for lightsabers and force powers and such.
//   (The amount of Sprint energy a weapon drains, and how much ammo
//   is actually in each clip are defined in the weapon’s ODF.)
// - WeaponChannel = 1  //optional line
//   This line indicates that the weapon is part of the secondary
//   line of weapons (i.e. thermal detonators, force powers).  It
//   will be activated by the Secondary Fire button or the 
//   Force Power button, and the character will never be shown 
//   carrying it, only using it.

// NOTE:  “Bonus” weapons are equipped below as well, they lock or
//         unlock themselves based upon Medal-status values set in
//         the weapon’s ODF.

WEAPONSECTION = 1
WeaponName = "jdi_weap_demo_saber"
WeaponAmmo = 0

WEAPONSECTION = 2
WeaponName = "com_weap_inf_force_push"
WeaponAmmo = 0
WeaponChannel = 1

WEAPONSECTION = 3
WeaponName = "com_weap_inf_sabre_throw"
WeaponAmmo = 0
WeaponChannel = 1

// this is the end of the ODF...

Cloth…
	In Battlefront 2, cloth is a way to make a polygon mesh distort itself in real-time based on gravity and wind and things.  In layman’s terms, it makes good looking skirts and capes.  If your model has cloth on it, which our demo model does because Luke loves his skirt, then you will need to do 2 things to enable that cloth.  (If you don’t enable it, it will not appear in-game at all, which means you can see London, and you can see France…)

	Firstly, you need to create a cloth ODF for the cloth, in the ODFs directory.  The ODF name is simply the name of the cloth piece with “.odf” appended – in our case, “all_inf_tatooinelukeskywalker_cloth.odf”.   Inside, you will find…
// ****** A cloth ODF *******
// Top section, same as any other ODF
`[GameObjectClass]`       
// this is cloth, so...
ClassLabel          = "cloth"

// properties section – small for cloth
`[Properties]`

// This tells us the name of the model that the cloth piece is
// attached to.  In our case, “all_inf_tatooinelukeskywalker”
AttachedMesh = "all_inf_tatooinelukeskywalker"

Secondly, in our soldier’s ODF, you need to tell it that it uses this cloth ODF, which gives us this line in our ODF above:
ClothODF = “all_inf_tatooinelukeskywalker_cloth”

And that’s it!  Assuming your artist did the right thing and attached the cloth where it needed to be, as well as put in cloth collision for it (XSI primitives in the .msh, named c_whateverNameIWant) it should function.
Note: A soldier may have as many cloth ODFs as you wish – each one simply needs to be referenced.  One ODF must be created per cloth piece on the model, and they can each have different properties.

There are other properties that you may have in a cloth ODF – we have rarely had occasion to use them, but they are:
(Note that `[parameter]` means a number, like `20.4`, not `[20.4]`)

// ---list of optional cloth parameters---

// Angle of the wind, phi and theta
WindDirection = “[angle1 in degrees] [angle2 in degrees]” 

// Wind speed, in m/s
`WindSpeed = [speed]`

// Dampening coefficient – in some unit or other, default is 0.5
`Dampening = [number]`

// Drag coefficient, also in some unit – default is -2.0
`Drag = [number]`

// Mass of each cloth “particle” (in Kg?) – default is 1.0
`ParticleMass = [number]`

// Maximum world acceleration, in m/s/s – default is 20
`MaxAcceleration = [number]`

// Priority – cloth with lower priority is skipped, 
// if not enough time is left this frame – used for the Emperor
// Default is 0
`Priority = [number]`

// Does this cloth have an alpha channel?  1 or 0, Default is 0
`Transparent = [value]`

// BF2 has 3 different types of constraints it satisfies each frame
// when computing the cloth:
// “Bend” constraints keep the cloth’s shape.
// “Stretch” constraints keep the cloth’s size.
// “Cross” constraints keep individual pieces of cloth from shearing.
// You can turn these on or off individually by specifying a
// zero for the constraint.
// For example, if you turn off “stretch” constraints the cloth 
// can grow longer or shorter…
CrossConstraint = [zero or one]
BendConstraint = [zero or one]
StretchConstraint = [zero or one]

Tentacles…
Well, “tentacles” is a misnomer.  Technically, what these are is bones that are animated by the game engine (not the animator) according to physics and the model’s movement.  They can be used for hair (as on the Wookiee Warrior) or pouches that move (as on Chewbacca) or anything else you like…they can even be used to animate weapons.
Unfortunately, Luke is a plain old human, and he isn’t too fond of hippie hairdos or long belts, so there are no tentacles in this example.  But I will explain how they work, and encourage a look at the Wookiee Warrior or Ms. Secura as an edifying example.  Actual implementation is left as an exercise for the reader.
Tentacles are pretty simple, really.  The artist needs to include bones named bone_string1 through bone_string# (maximum is 45) and make sure they are in the base pose and properly parented to each other.  Then you, the all-powerful demigod of character creation, need to tweak the soldier’s ODF slightly:

Straight from Aayla (Aalya?  I always forget…) we have:
// NumTentacles * BonesPerTentacle = total bones, bone_string1 to N
// Note that the max tentacles is 9, and the max bones is 5.
// However if you have one long tentacle, as long as the bone number
// ends up correct, that’s okay too.  So a 12-bone tentacle can be
// done as 4 3-bone tentacles and it will work fine.
NumTentacles	    = "2"
BonesPerTentacle    = "3"
// TentacleCollType specifies which type of auto-generated collision
// the game should use.  0 is the one that works best, which is a
// sideways rectangular box centered around the shoulders.
// 1 and 2 are never used, but they are a sphere and a cylinder,
// respectively.  Good luck with that.
TentacleCollType    = "0"

And that’s it!  
Note:  If you want to test your Jedi, you can get rid of WeaponSections 2 and 3, and replace the weapon in WeaponSection 1 with “com_weap_inf_fusioncutter”, which is a weapon with no geometry or special things associated with it, that will enable your soldier to run around so you can see him.  Check the Final Notes for information on how to munge your soldier.

Now on to creation of the weapon, which is the important part…
4 – A Jedi Weapon ODF (Y’know, Those “Light”…Thingies…)

Remember the line:
WeaponName = "jdi_weap_demo_saber"
from our Jedi’s ODF?  Well, the other two weapons – com_weap_inf_sabre_throw and com_weap_inf_force_push, found in sides/common – already exist, but now we have to make our Jedi’s main weapon.
	First thing you have to do is create the ODF, in our case jdi_weap_demo_saber.odf in ODFs folder.  (No picture this time, you better know where it goes by now!)  You also need to place the geometry (msh) for the handle into the MSH folder.  It is possible to create a lightsaber just attached to the character’s bone, with no extra geometry – Darth Maul does this – but that is a black art.  For the Wampa and the Acklay, extra invisible lightsabre geometry was actually created to guarantee the blade goes the correct direction, so we’ll assume you have geometry.  Different geometry is required for each hand (for example, Ms. Secura has two) since the blades go different ways, and the geometry must contain a hard point (called hp_whatever) that you reference to determine where the blade comes from.  If there are to be multiple blades, then there must be multiple hardpoints, because two blades coming from the same point of the same geometry will be considered the same blade.
	In the case of this demo, I’ll be stealing Luke’s saber from the Alliance side, so I swiped all_weap_inf_lightsabre.msh and .option and put them into our MSH folder.  I also swiped the blade’s texture, greenlightsabre.tga and .option.

	Now, what goes into the ODF…?
`[WeaponClass]`

// this is always “melee” for a lightsaber
ClassLabel          = "melee"
ClassParent			= "com_weap_inf_lightsaber"

`[Properties]`

// three parameters here:
// First, the parent animation bank – usually “human_sabre” – this is
//     where any animation that we didn’t override will be taken from.
// Second, the parent weapon class – this is ALWAYS “melee”.
// Third, the name of the combo file without the “.combo”.  
// What’s a combo file?  That’s explained later, in its own section...
ComboAnimationBank	= "human_sabre melee jdi_demojedi"

// If the weapon has an explosion associated with it, like Mace’s
// or the Wampa, this is the name.
// In our case, there is an explosion just to demonstrate how to
// use one.  Explosions are specified in ODFs – in our case,
// it’s in jdi_demojedi_exp.odf.
ExplosionName = "jdi_demojedi_exp"

// How many blades – up to 4.
NumDamageEdges = 1

// From here on, everything is divided up, and the information for
// each blade is given separately.  We only have one blade, but
// I will put in a second section that is commented out, just for
// show.

// The sabre’s handle.  We are terribly inconsistent with saber/sabre.
GeometryName        = "all_weap_inf_lightsabre"

// The hardpoint in the geometry that the blade comes out from.
FirePointName       = "hp_fire"

// ****NOTE****
// FirePointName can be replaced with OffhandFirePointName.
// What’s the difference?  FirePointName means that this
// geometry is attached to hp_weapons on the model.
// OffhandFirePointName takes an extra parameter, which is
// which hard point or bone to attach this weapon to.
// The first argument is still the hard point in the weapon
// from which the blade emanates.
// For example, the line we used is the same as:
// OffhandFirePointName = “hp_fire hp_weapons”

// How long, in meters, the blade is.
LightSaberLength	= "1.0"
// How wide.
LightSaberWidth		= "0.25"

// Optional.
// Which texture to use, from the MSH folder, for the blade.
// Note that it is not required for the blade to have a texture,
// in which case all you will get is damage, like for the Wampa.
LightSaberTexture 	= "greenlightsabre"

// Optional.
// In RGBA format, the color of the trail left by this edge.
// Edges only leave trails when they can hit things / are attacking.
LightSaberTrailColor = "82 255 7 128"

// One thing we did use is a blade with no texture, but a trail.
// This was, among other things, used for Kit Fisto’s punches and
// kicks.
// A blade with no texture and no trail was used for the Wampa and
// the Acklay – in fact, the Wampa has 3...

// The texture to use as the glow effect around the saber.
// This is generally left unchanged, because com_weap_inf_lightsaber
// has a glow on it which is kept, but if we wish to get rid of the
// glow on our saber, we can specify “notexture”.
// LightSaberGlowTexture 	= "notexture"

// And that’s the end of the ODF!  If we had more blades, we would
// repeat that section again for each blade.  However, 
// the 2nd, 3rd, and 4th weapons would use:
// OffhandGeometryName in place of GeometryName (same argument though)
// and OffhandFirePointName ALWAYS.  FirePointName is only used once!

// Additionally - wow, hard to explain – if you want two blades to be
// part of the same weapon, do not specify the OffhandGeometryName for
// the second blade, just the OffhandFirePointName.  See Darth Maul
// as an example.

And that’s the end of the ODF.  Almost.  There’s also a way to make a blade without all that nonsense, and with a whole new set of nonsense.  If you just want a blade to come off a character’s bone or hardpoint without creating your own geometry, you can do the following…please note that ONLY Darth Maul uses this, because he was one of the first Jedi created.  This method is very difficult, and if you can, have an artist create your invisible handle instead.

// Rather than saying GeometryName and FirePointName, you can simply
// use the following (“simply”, that is):  AttachedFirePoint
// The first parameter is the bone name.
// The next 3 are the X, Y, and Z components of the direction
// that the blade extends, in bone-local space.
// The last 3 are the X, Y, and Z offsets from the bone’s
// position, again in bone-local space.
// If you didn’t understand any of that, then this is 
// NOT something you want to use.

// Taken from Darth Maul.  Create an edge extending from
// bone_l_calf down the X-axis of the bone, offset by
// 0.35 meters (the X-length of the bone, in this case).
AttachedFirePoint	= "bone_l_calf 1.0 0.0 0.0 0.35 0.0 0.0"

Now that we’re finished specifying the weapon and how it looks, it’s time to make a combo file, which is where all the magic happens.
5 – The Combo File

Hopefully by now you really have become dedicated to finishing your character.  I know I told you the rest of it was the hard part, but this is where the real pain begins.  The combo system takes a little getting used to, a lot more getting to know, and a whole bunch of massaging to get it to do what you want.  It has evolved over time from Combo, to Comba, and finally to Combaga, and the subsequent increase in power has led to many unstable situations.  This section covers: the basic structure and organization of a combo file, and what the various parts do;  specifics that you usually want to have;  any and all parameters that can go into a state (unless I miss some), which ones have ended up being useful, which ones haven’t, and how things are intended to be used; and final words to help you get your soldier running, jumping, attacking, and possibly even look cool while doing it - especially in multiplayer which has its own set of special requirements.  While I will not be constructing an example combo file in this document, there is a completed one (hopefully with comments, unless I get lazy) in the ZIP that accompanies this document.  Additionally, with the information in here, you should be able to construct your own…after all, that’s what you’re here for, right?

I have also included the combo-file document prepared by the first guy who worked on the combo system – it is incomplete now, and somewhat hard to understand, but there might be something there for you.

The combo file is referenced by the weapon ODF, and goes in the ODFs directory – for this demo, it’s “jdi_demojedi.combo”, and yes, they always end in .combo.  As with all other ODFs, it’s just a text file.

Basics…
	Righto, so what’s this all for?  Well, a combo file determines how your Jedi can react to particular inputs and situations, and which attacks occur when.  If it’s not in your combo file, your Jedi can’t do it.
	If you don’t know what the term “frame” means in relation to video games or animation, go look it up right now.  This term is heavily used from here on out. In our game animations are played at 30 frames-per-second, so the time for one frame is 1/30th of a second.
	The basic structure of a combo file is a list of states.  Each state represents all (or part) of a particular animation that your character has.  The state can tell your character that he can hit his opponent at a particular time or times, play a sound at a particular time, play your weapon’s explosion, or do a bunch of other things.  Each state can also switch (from here on, “transition”) to another state depending on certain conditions, like the player pressing a button or your Sprint energy running out.  States can also have special properties like laser-bolt deflection or altered gravity.  These states are everything your character can do, and your character is always “in” exactly one of the states at a time.  The way you set up the states and transitions determines which attacks your character can do when, and what happens when you do them.
	If you need further explanation, you can look up a “finite state machine” (also called an FSM), because there are lots of examples of this sort of thing out there, and we have more important matters to deal with.

	Your soldier MUST always have a state called “IDLE”, which is the default state that he/she starts in.  This is also the state which they return to if something goes wrong and BF2 can’t figure out what to do.  Think about it as: when you aren’t doing anything special to a Jedi, you’re in IDLE state.  The IDLE state is the only state that does not have an animation defined for it - when your Jedi is in IDLE state they act as a normal soldier and can jump, run, sprite, crouch, Force Jump or Hover, roll, and do anything else a normal soldier can do.  If you make a combo file with just an IDLE state, your Jedi will be able to do everything except attack and block.  However, when the conditions are met for a transition from IDLE state, these override the normal soldier actions – so you can tell your soldier to do something different when you press the Jump button from IDLE state, but if you don’t then they will jump normally.

Animations…
	Right.  So.  You want to make a soldier, but you want to use your own animations.  This is a multi-part process, and really should have gotten its own section, but we’re already here, so here we go…

How do they work?
	There are basic sets of soldier animations (human_rifle, human_tool, human_sabre, human_bazooka and some others I may be forgetting).  “human” is the um, class I think, and “rifle” or “sabre" or “bazooka” is the weapon type.  These define many animations, for example _stand_idle_emote which is the basic standing-around animation.  Each animation set defines its own variation, so there is human_rifle_stand_idle_emote, human_sabre_stand_idle_emote, etc.
	There are also _full, _upper, and _lower that you can tack onto the end of an animation, which tells BF2 that this animation applies to the whole body, only the top, or only the bottom, respectively.  For our purposes all animations will be “_full”.  YOU MUST include “_full” at the end of the name, otherwise _upper is assumed.  
	So for example, there is human_sabre_stand_idle_emote_full, which is Luke’s idle animation, and there is human_sabre_stand_walkforward_full, which is Luke’s walking-forward animation.  Note that there are walk, run, and sprint – on PC, with no analog stick for walking, all you ever see are run (maximum speed without the Sprint key) and sprint forward, and walk backward.  There are also things like human_sabre_stand_attack1a, and _attack1a_end.  These are Luke’s attacks, and the basic fallback attacks for other Jedi.

Overriding animations...
	For a new animation set, there must be a parent animation set.  In our case, this is human_sabre.  Any animation that the new animation set has will be used.  However, any animation that is needed, but which the new animation set does not define, will be taken from the parent set.  So for example, if our new animation set doesn’t have a stand_idle_emote, then human_sabre_stand_idle_emote will be used.  Hopefully this is clear.  Our new animation set can also add unique animations, for example you could add _myattack_that_I_made_it_is_awesome_full and use it from your combo file, even though there is no human_sabre_myattack_that_I_made_it_is_awesome_full.

Setting up an animation set…
	When you set up a new animation set, at least for a Jedi, the weapon type is still the same, “sabre"…so you will be replacing the “human” part of “human_sabre” with your set’s name.  If you wanted to make Tatooine Luke, for example (wonder why I picked that one…) you could replace it with “tat_luke”, and all your animation names would begin with “tat_luke_sabre”.  (If you were making an animation set for a character whose weapon uses the rifle animation set instead, then it would be “tat_luke_rifle”, see?)

	The first step to setting up your animation set is to create a folder for it.  In your mod’s “data” folder, there should be a folder called “Animations”, containing a folder called “SoldierAnimationBank”, containing a folder called “template”.  What you must do is make a copy of that “template” folder and call it whatever your new animation set will be named.  And since you copied the folder, there should be a “munge.bat” batch file inside it.  Like so:
     

Unfortunately, you must edit munge.bat so it will munge your animations to the right directory.  So, open it in Notepad (remember to make it non-Read-Only if you have to!) and you should see something like this:
@call ..\munge_animation.bat "/keepframe0 /dest aalya.zaf" Sides\REP

	The bits you need to change are the “aalya.zaf” and the “Sides\REP”.  The first one is the name of your new animation set (for us, “tat_luke”) and the second one is the destination directory (which in our case is “sides\JDI\munged” but it automatically adds “\munged”, so it’s just “sides\JDI”).  Like so:
@call ..\munge_animation.bat "/keepframe0 /dest tat_luke.zaf" sides\JDI

	Save it, and that’s that.  When you add or remove animations from your animation set, you need to double-click this batch file to run it which updates the animation-set files the game uses. We’ll get to that in a minute.
	If you have the “assets” folder, which contains the entirety of the animations we used for BF2, then you can see what goes into an animation set.  Basically, there’s a basepose.msh, which is keyframed on frames 1 and 0, and sets up the skeleton and what is included in it.  Then there are individual animations, animSetName_weaponType_animation_name_full/upper/lower, animated as normal (I suppose, according to our animator).  
	Since this is a tutorial, we will be stealing Luke’s animations and putting them into our own animation set, which – even though it won’t look any different from human_sabre, will be our own to expand on as we wish.  So first we steal Luke’s basepose and stand_idle_emote_full, and put them into our folder.  Remember to rename the beginning to “tat_luke” or whatever your set is called:

All that is really necessary for your animation set is a basepose.msh.  This determines what your skeleton looks like – for example, the Wookiee and Ewok use human animations, and have only different skeletons, meaning their animation sets consist of simply a basepose (and specialized extra animations if they have any).  
	Now that your set has a basepose and an animation, if you double-click munge.bat, it should create some log files, and 3 files that BF2 uses for your animation set in \sides\JDI\munged:

You can open the .anims file in Notepad, and it will list what animations are defined by your set:
ucft
{
	ANIM
	{
		"tat_luke_sabre_stand_idle_emote_full"
	}
}

The name of the files that were created (“tat_luke.anims”, etc) is what is used in your soldier’s ODF (AnimationName = “tat_luke”).  Keep in mind that these files and your animation set need to have the same name – if “tat_luke.anims” has inside it obiwan_sabre_stand_idle_emote_full, this animation will not be able to be used by the game.

	That’s all for creating animations – as you add or remove animations in your set, you need to re-run munge.bat in order to recreate those files in your side’s \munged folder.  Then you need to run VisualMunge again and munge your side.  Those 3 files are eventually copied into your side’s .LVL file and loaded by the game.
	Keep in mind that you only need to re-run the animation munge.bat if you change your animation set – changing your soldier’s ODFs or combo file doesn’t require you to do that.

The Combo File Header…
	Each combo file begins with the same information, before we get to the state-definition part.  The usual commented example:

// The name an animation is always just the part after
// the class and weapon, because the class comes from your
// soldier ODF, and the weapon comes from the type of weapon
// that the animation is playing on – for the demo,
// the class and weapon are always tat_luke_sabre.
// You may also omit the _full/_upper/_lower, unless you
// explicitly need to use _lower.  I always leave off _full.

// When declaring that an animation exists, you can do so
// with just one line:
// Animation("anim_name");
// but this animation will have default parameters.
// In order to reference an animation, you have to have
// declared that it exists.  So if you want anim A to blend to
// anim B, you need to declare that both exist, then define
// A a bit more.  Hopefully that’s clear too, because it’s done 
// below.
// To further specify an animation, you can add descriptors:

// Loop();  done this way, the animation will loop as it plays, 
// restarting from the beginning.
// The default is not to loop.
// You can also use Loop("FinalFrame"); which will continue to loop
// the last frame of the animation forever when it is reached.
// FinalFrame is the useful one.

// Most of the rest of the parameters are explained in combo.txt...

// OffhandAnimation defines an animation that replaces weapon use
// animations.  For example, replacing the FIRE, FIRE2 or CHARGE
// animations with our own animations when a character has
// this lightsaber equipped means that, for example,
// we can replace the FIRE animation with a force-using
// animation, that the weapon will then play instead of
// rifle firing.  FIRE and FIRE2 are the 2 animations a weapon
// can use – look at com_weap_inf_force_pull or _push for
// an example (the “FireAnim =” line).

// If you are replacing FIRE and FIRE2 or CHARGE, they MUST
// be replaced IN ORDER or FIRE will override everything else.

OffhandAnimation("stand_useforce", "FIRE")
{
    Loop("FinalFrame");
    AimType("Torso");
    BlendInTime(0.15);
    BlendOutTime(0.15);
}
OffhandAnimation("stand_useforce", "FIRE2");
OffhandAnimation("stand_useforce", "CHARGE");

For the rest of this, due to time constraints I will simply be including notes that go along with combo.txt, or things that are not included in combo.txt.


// Sabre-throw stuff....
// This is the animation to use when we throw the sabre.
// human_sabre_stand_throw_full is present by default, so
// everyone uses that.
ThrowAnimation("stand_throw");

// If you have sabre throw as a weapon, you MUST
// have a CATCH_SABRE state.  This is a state like
// any other, but it is automatically entered when
// your character catches the sabre.  Normally
// it’s just a state that plays the catch animation
// then goes back to IDLE.
State("CATCH_SABRE")
{
    Posture("Stand");
   // Sound("saber_catch");
    Animation("stand_catch")
    {
        AimType("None");
        BlendOutTime(0.2);
    }

    InputLock("All", "!Thrust");
    AlignedToThrust();
}

Additional Notes – These Are Important!  (In no particular order)
- Generally, ground moves are NOT AlignedToThrust, and jumping moves are.  Sprint moves may also be aligned, but if they are not you have greater control – see Ki-Adi-Mundi’s sprint attack.
- Gravity() does NOT work in Multiplayer…
Use GravityVelocityTarget(number, “Impulse”); instead.  Also note that ZeroGravity DOES NOT WORK at all.
- PlayExplosion happens on the first frame of the state.
- The posture you are in for a given state is actually the real action – if it is Crouch, your collision is crouched.  If it is Sprint, you will move forward and drain energy.  If it is Jump (the useful one) your character will jump if he is standing.  If it is Roll, you will start a roll then be forced back to IDLE state – there is no controlling a character during a roll.  Posture Jump is a way to get your soldier to jump from a standing position.
- Normally, states can be entered and exited on the same frame – for example, if you transition to a state that is in Jump posture, then has a transition on posture “Stand” to landed, you will go through both right away and be in “landed” state because your character never jumped.  In this case, put “MustShowOneFrame();” in the Jump state, so that one frame goes by and the character actually jumps.
- Edge(0) Edge(1) etc are in the order they are defined in the weapon ODF – if you add a new edge and it changes the order, all these must be updated.
- Push(number); applies a push of that much force to the soldiers you hit with the attack.  Generally 3 is light, 6 is medium, 10 is large and 15 is very large.  Push may or may not produce a visible effect on the other person depending on what they are doing at the time, and where they are in relation to you.  No push = no hitstun.
- Some transitions may not work in multiplayer.  To get a transition to work in multiplayer, here’s an example:
	Say you have an animation that is 25 frames long, and if they hit a button you want to go to another state at the end of it.  Make a state that is 25 frames in Duration, and transition to the other state at frame 23.  Make the transition end at frame 24 (remember, the state ends at frame 25).  This will always be able to be used in multiplayer – other methods of timing-out your transitions may not be.
- If state A uses animation DoStuff, then goes to state B that also uses animation DoStuff, the animation will NOT restart, unless RestartAnimation(); is in state B.  A side-effect of this is that all time-related things are related to the TOTAL time the animation has been playing, meaning:  If state A is 10 frames long, and you want something to happen on the 5th frame of state B, then that has to happen on the *15th* frame, not the 5th, because by then the animation has been playing for 10 frames already.  Hopefully this is clear.  This also applies to the Duration of state B - if state A is 10 frames long, then state B is 25 frames, instead of 15, because it’s the total time, see?
- ***For some stupid reason, if you say “Reload” as a button in the combo file, that’s the SecondaryFire/Force Power button in-game.  If you say FireSecondary, that’s the Block button in-game.  Get used to it!  So doing a secret attack is a matter of transition on the press/hold/doubletap of Reload, NOT FireSecondary!***
- Putting in “secret” attacks is simply a matter of transitioning to some state on the Press of a different button, or the Hold or DoubleTap of the attack button.  (^.^)  Check Darth Maul for an example.
- I would do pretty much everything in “Frames”, it’s easier than in seconds.
- I like the way blocking works on the PSP, so I’ve designed the demo character to block by hold/release of the block button, rather than tap.  This also means not having to worry about breaking out of block by attacking and things, simplifying our state table.
- The demo character has a secret attack.
- If you use an animation that has the same name as something that already exists in human_sabre (for example, attack1a), then you CANNOT redefine the parameters (Loop, BlendTimeTo etc) for it!  Therefore, if you want to do this, make sure your animations are named something unique.  This is a bug.
- The infinite-block glitch is fixable by adding some transitions to your Deflect state.  This has been left as an exercise to the reader.  (^.~)
- If your character has secondary weapons (Force powers, etc), then you cannot use the Secondary Fire button as a condition of transitions from IDLE.  You can, however, use it from any other state – so from Attack1 you can go to SecretHiddenAttack if they press the Force Power button (“Reload” in the combo file, remember…) – BF2 used this quite a bit.  This limitation is because if you have a secondary weapon it will activate if you are in IDLE state, and “eat” the input of that button.  Also note that if you don’t have any secondary weapons, you are free to use this button from IDLE – meaning you can do cooler stuff, but don’t get to have force powers.
- If a state is an AnimatedMove, this means that the full body animation is always used – if not, then if the character can walk around and the player does move them, the legs will become a walking animation.  Therefore, AnimatedMove() with zero Z and X velocity, and normal walking speed VelocityFromThrust (12) and VelocityFromStrafe (3-8) can be used if you want a full body animation to play.  An example is most characters’ third attacks – the first two will be overridden by walking legs if the player moves, but the third attack is a kind of a grounded jump, so we use AnimatedMove() to make sure the legs play and the character will always perform the jump part.  AnimatedMove() is also used in the air to ensure that the legs aren’t playing the jump animation.
- A lot of times, you will notice a Jedi die and still complete their attack sequence with the sabre off, before collapsing.  This is because there is no transition out of that attacking state to IDLE, therefore the state finishes playing.  Due to constricted memory pools on the consoles, lots of these transitions had to be left out.  If you wish to fix this, simply have a transition to IDLE if the character’s Posture is not what the state sets it to.  For example, if your state is Posture(“Stand”);, then if you have a transition to IDLE if Posture(“!Stand”);, then the character will exit that state properly when they die.  Some states of the demo jedi include this to demonstrate.
- A melee weapon locks-out use of the secondary weapons from a given state if that state has InputLock() in it.  Generally, InputLock(“All”, “!Thrust”) is used because the soldier still wants to know about our thrust, but only the melee weapon wants to know about all the other buttons.  If you do NOT lock FireSecondary, then the user can press Force Power and interrupt that state with a secondary weapon.  An example of this is in normal BF2, if you select Luke and switch to Force Push, do his 3-attack combo, and hold down the Force Power button during the third attack, he will interrupt the end of the third attack (state RECOVER3, not state ATTACK3) into Force Push.  This was an oversight, the InputLock line from RECOVER3 was accidentally deleted so it can be interrupted in that manner.  (^.^)  So, don’t do this in your Jedi unless you want to because you think it’s neato.

I apologize for this part of the documentation, but after all there is an example combo file in the JDI side, and many in the assets folder.  Please remember to ask any further questions on the www.gametoast.com forums, and I’m sure it’ll find its way to me.  Making combos is an art, so just keep poking around until it does what you want.  =^.^=
6 – Final Notes

	When you munge now, “jdi.lvl” should contain your character.  How do you use it in the game?  Well, so you know, it’s in the SIDE folder of your mod’s _LVL_PC folder.  When you munge, this gets copied into your BF2 directory automagically…

 is copied to your BF2 directory’s

ending up with



From there, in your mod’s mission scripts, you can load your character into your level:
ReadDataFile(“dc:SIDE\\jdi.lvl”, “jdi_demojedi”)
The “dc:” tells the game that this lvl file is located in your mod’s folder, rather than in the normal game data folder.  The first parameter is the side’s lvl file to open, and the rest are individual soldiers to load from within that side’s lvl – in our case jdi_demojedi, and if we had made one, jdi_otherdemojedi or jdi_demojedi2, etc…

Now all you have to do is set your teams up to use that soldier, and ba-zam you’re done. So on to that….
Both of these should already be present with the default hero and soldiers in your mission LUA scripts, but:

Note:  Once a soldier class (ex. “jdi_demojedi”) is loaded by ReadDataFile, it can be used on ANY team.  It doesn’t matter where the soldier comes from, you can mix-and-match Republic soldiers and CIS soldiers on the same team if you decide to, as long as all the soldier classes you use are actually loaded.

To set your Jedi up as a team’s hero, use the following line:
`SetHeroClass([team], "hero_req_name")`
for example:
SetHeroClass(REP, “rep_hero_macewindu”)
or:
SetHeroClass(CIS, “jdi_demojedi”)

To set your Jedi or soldier up as a normally-selectable or points-unlocked soldier on a team, modify the SetupTeams section of your mission LUA and replace an ODF name with your own soldier’s loaded ODF name:
SetupTeams{
		rep = {
			team = REP,
			units = 20,
			reinforcements = 150,
			soldier  = { "rep_inf_ep3_rifleman",9, 25},
			assault  = { "rep_inf_ep3_rocketeer",1, 4},
			engineer = { "rep_inf_ep3_engineer",1, 4},
			sniper   = { "jdi_demojedi", 1, 4},
			officer = {"rep_inf_ep3_officer",1, 4},
			special = { "rep_inf_ep3_jettrooper",1, 4},
	        
		},
		[then CIS section]
}

For a more complete description of what the SetupTeams or SetHeroClass functions do, please see the LUA guide that’s supposed to have been written by someone else.  (^.^)

Extra console commands:
Useful console commands when debugging a Jedi are:
- “combo.damage” – toggles on and off the showing of a Jedi’s saber edges that can do damage as a red bar with a sphere at the end.  The bar indicates the length, while the sphere indicates the radius.  Note that this is the Length and Width that come from within the Attack() sections of a combo file, NOT the length and width from the weapon ODF.
- “anim.show” – toggles on and off display of the animation(s) that the player character’s legs and upper body are playing, the total length of the animation (in frames) as well as the current frame number, and the percentage of blending out of the last animation.  ESPECIALLY useful with:
- `slowmo [number]` (like “slowmo 5”).  The number is the number of times slower to play the entire game…um…it’s the denominator in the speed, so if you say “slowmo 5” then the game plays at 1/5 speed, if you say “slowmo 2” then it plays at ½ speed, etc.  “slowmo” by itself, or “slowmo 1” turns it off.  Note that you can also speed up gameplay with “slowmo .2” or “slowmo .5”, but this has no practical use for animation debugging.  After inputting a “slowmo”, turn off the console and check your character for bugs or animation pops.

Well, that’s the end.  
Hope you learned something.
May the Fo…um….Good luck!

# Making Mods in SWBF2
## Making Mods in Star Wars Battlefront II

So you’ve just picked yourself up a copy of Battlefront II, and want to make some new content…sit and relax, you’ve come to the right place.  This document will guide you through the process of creating new maps in Battlefront II using the new Visual Munge program which we’ve specifically designed for the would-be Battlefront II modders out there.  

ModTools VisualMunge.exe is a re-designed version of the tool that we used in creating Battlefront II, re-designed to make the process of creating a new mod directory, and setting up your new map as simple as a few mouse clicks.  This eliminates the 30 or 40 steps that we had to take when creating new maps while actually working on the game, so we hope you enjoy it.  And now the fun begins….

## Directory Structure

First, unzip your BF2_ModTools zip file into the root of your C: drive.  We can’t be held responsible should you put it somewhere else, and things don’t work, so just take our advice…this is where you want to put your BF2 Mod Tools files.  Inside, you’ll find the following folders:

\BF2_ModTools\assets
This folder contains many of the original assets from Battlefront II, many of which you’ll need to copy into your mod directory manually if you wish to make mods using these files.  Don’t worry, this will all be explained later. Note: it would be wise not to directly edit these files without copying them into your mod folder first.  Keep these as the original data

\BF2_ModTools\data
This folder contains most of the files actually needed to make a working level mod in Battlefront II.  These files will be copied to your new mod folder (which ModTools VisualMunge will create, this will also be explained later)  DO NOT MODIFY ANY FILES IN THIS FOLDER.  VisualMunge will create a copy of this database, and there will be the files that you’ll want to modify.

\BF2_ModTools\documentation
You guessed it.  This folder contains many useful documents which will help you along your way to creating some nifty Battlefront II mods.  Be sure to check out these docs as they will certainly be helpful when endeavoring to create some spiffy new Battlefront II content.  Many of the game’s systems are documented in these files. 

\BF2_ModTools\TEMPLATE
This folder contains the template files that VisualMunge uses to create your new world.  The game mode, world files, and script files are stored here.  Again….DO NOT MODIFY ANY FILES IN THIS FOLDER


\BF2_ModTools\ToolsFL
A bunch of tools related files that you don’t have to worry too much about in creating new levels for Battlefront II.  

Under the root of the mod tools folder, you’ll find the EULA (End User Licensing Agreement), Readme.txt, and a file called jedi side example.zip.  This file contains some reference files useful for looking at how to create a new side for your mod (more on this in BF2 Jedi Creation.doc.
ModTools VisualMunge – Creating your new world

To begin, browse to your \BF2_ModTools\data\_BUILD folder, and run the program called ModTools VisualMunge.exe  

The first time you run ModTools VisualMunge.exe, it will try to automatically detect your Battlefront II install folder.  If it fails to auto-detect, you’ll get a pop-up dialog asking you to enter your Battlefront II directory.

If this popup should rear it’s ugly head, simply browse to your \Star Wars Battlefront II\GameData directory, and click ok.  It is very important that VisualMunge knows this path, as this is where your mod data will be copied to for being run in the game.  

The first thing you’ll need to do to put you on the path of getting your very own Battlefront II map up and running, and choose a 3-letter name for your mod.  I’ll use ABC as the example for this document.  Note: the 3-letter name thing is unfortunately required by many systems in the game, so this was something we were unable to change.  

Once you’ve entered a 3-letter world name, you’ll need to enter a Full World Name, and a World Description for your new map.  The Full World Name and World Description are what will show up in the shell when you go to select your new map to play it.  

Now that that’s all our of the way, all that’s left to do, is check the boxes for the game modes you want to include on your new map (the choices are Conquest, 2-flag CTF, 1-flag CTF, and Hero Assault) and click “Create World”.

What this has now done, is create a mod directory under your BF2_ModTools directory for your new mod.  So if, for example, you were to create a world called ABC, you will now find a data_abc directory in your BF2_ModTools folder.  All the files from \data have been copied into your new folder, and the files in \TEMPLATE have been modified, and renamed automatically, and placed in your mod directory to create your new map according to the options you specified.  

Once VisualMunge is done working it’s magic (copying and modifying files) you’ll get a pop-up message.
This means that all the copying, and modifying is done, and you’ll now need to:

    1. Close VisualMunge, 
    2. Browse to \BF2ModTools\data_abc\_Build 
    3. Run ModTools VisualMunge.exe from inside this folder.  

This is very important.  The steps I just outlined are the only time that you’ll run VisualMunge from the main \data directory.  Once you’ve created your new level, you’ll run VisualMunge from inside your \data_abc\_BUILD mod folder, which VisualMunge has created for you.  Always be sure that you’re running VisualMunge from the correct folder, to avoid problems.  To make things at least somewhat foolproof, you’ll notice that the Munge options have been grayed out when you run VisualMunge from the main data folder, and conversely, the Create New World options are grayed out when you run VisualMunge from inside your new mod folder.  

## ModTools VisualMunge – Munging and running your new world

The term “munge” is the term that we use for basically compiling your data for use in the game.  We’ll get to actually modifying your new world in a bit, first I’m going to cover munging, and running your new level in the game.  

So, by now you should have opened VisualMunge from inside your new mod folder, and you’ll notice that all the Munge options have been enabled, and the Create World options disabled.  Your new level will automatically show up in the Worlds drop-down menu, and the only other option that should be selected by default is Common.  You can leave everything as is when you run the program.  Note: you MUST have your world selected in the worlds list in order for everything to munge and copy correctly.

Click Munge.

Once VisualMunge finishes working it’s magic, you’re all done.  You have a level that you can run, and play in the game.  Visual Munge copies all the necessary files for running your level into your Battlefront II folder in the following location: \Star Wars Battlefront II\GameData\Addon\ABC (where ABC is the 3-letter name that you gave to your level).  Run the game, and your new map should show up in the Instant Action, and Multiplayer playlists.  

## Template Game Modes

Here’s a brief rundown of what is included when you select each game mode to be included in your new Battlefront II map:

## Conquest

In Conquest, there are 4 CPs (each with spawn paths, and capture regions), 2 for each team.  You can ,of course, add more CPs, and move any of the CPs and their spawn points and capture regions wherever you like.

## 2 Flag CTF

2 Flag CTF will have 2 CPs for each team to spawn at (these use non-capturable CPs used only as spawn points) with spawn paths included.  Also included are the flags for each team, and the capture region (the cylindrical object that serves as the visual representation of the capture location) for each team.  

## 1 Flag CTF

1 Flag CTF will have all the same things as 2 flag CTF, except there is only 1 flag placed in the middle.

## Hero Assault

Hero Assault will have 4 CPs, 2 for each team (again using non-capturable CPs) and that’s about it.

## Game Mode Scripts

We’ve gone to the trouble of pre-arranging the scripts for each game mode, so when you select the game modes you want to include in your new map, you don’t have to worry about any manual setup for the scripts.  Everything is arranged for you.   You can, of course, change the scripts to suit your purposes (add vehicles, additional characters if you want, etc.)  The scripts will be located in data_ABC\common\scripts\ABC (where ABC is the 3-letter name that you gave your map).  The naming convention for the scripts is as follows:

ABCc_con.lua – Clone wars era, Conquest
ABCg_con.lua – Galactic Civil War era, Conquest
ABCc_ctf.lua – Clone Wars era, 2 flag CTF
ABCg_ctf.lua – Galactic Civil War era, 2 flag CTF
ABCc_1flag.lua – Clone Wars era, 1 flag CTF
ABCg_1flag.lua – Galactic Civil War era, 1 flag CTF
ABCg_eli.lua – Hero Assault

Detailed information about the scripts can be found in the documents folder in Lua_scripting_guide.doc.  Also, for a more comprehensive technical overview of LUA and it’s workings in Battlefront II, check out Battlefront2_scripting_system.doc.

Modifying your new Battlefront II level

## Game scripts

You can modify the game scripts directly in any text editor (I suggest using a more advanced editor such as UltraEdit, or EditPad).  See above for the location of the scripts.  

## Level Assets

To modify your new Battlefront II map, we’ve included our proprietary level editor, ZeroEditor.  An important note, is that you need to run ZeroEditor from your new mod directory (data_abc) in order for things to work properly (do we see a pattern emerging here?), so browse to data_abc and run zeroeditor.exe.  This will load up the editor.  Load up your level, and you’re ready to go.  For more detailed information on the workings of ZeroEditor, see ZeroEditor_guide.doc in the documentation folder.  We’ve added tooltips to the editor for most every feature in the editor, so just hover your mouse over any of the buttons, or text in the interface, and it will pop up a tooltip explaining exactly what that feature does.  

It is important to note, that when creating your new world through VisualMunge, we create, and set up all the files needed to run your level, and have the game mode functionality work.  You will, however,  have to go into your world and add Planning Paths, Barriers, Boundaries, any Lighting you want to add, along with any new Objects or terrain features you want to add.  All of these things are covered in the ZeroEditor_guide.doc which is found in the documentation folder.  

## Adding assets from shipped worlds to your new level

We’ve packaged up the shipped worlds from Battlefront II, to allow you to use assets from the shipped game to make your new levels with.  In order to use these assets you’ll have to copy some files around.  Below, I’ll describe how to get new objects, textures, or sky files into your new map.  

## Adding New Objects

In order to use objects from the shipped worlds (I’ll use Kashyyyk as our example here), you’ll need to copy those assets from the \BF2_ModTools\assets\worlds\KAS\msh and \BF2_ModTools\assets\worlds\KAS\odf folders.  You can copy one object at a time, or you can just copy these entire folders into your new world folder.  Just keep in mind that the more files are in there, the bigger your level download will be, and the more memory will be required to run your level, so it’s best not to have too many files in these folders that aren’t being used.  These files need to go in a corresponding folder inside your new mod folder.  For example, if you want to copy some objects from the Kashyyyk world into your new world, you could either just copy the entire msh and odf folders into \data_abc\worlds\abc\, or you can create the odf and msh folders manually, and just copy single assets over.  It’s important to note, that when you copy over a mesh, you need to copy over all the textures, option files (.option) and the odfs, otherwise the objects that you copy over won’t work properly.  (For more info on placing, and manipulating objects, see ZeroEditor_guide.doc in the documents folder).

## Adding New Terrain Textures

To add new textures to the terrain, just find the terrain texture you want to use in one of the shipped world assets folders, and copy it into your \data_abc\worlds\abc\world1\ folder.  Once you’ve done this, load up your map in ZeroEditor, and open your map.  Click on the Texture edit mode button, and you’ll see your list of textures on the right hand side.  Select a box that you want to add a new texture to (you can replace existing textures, or you can start by adding a new texture to a blank box).  You’ll see the texture name appear on the left side where it says Texture.  The box will be blank if you choose a blank texture slot.  Click the Browse button below the Texture box, browse to the texture you just copied into your world folder, and voila…your new texture is ready to be used.  (For more info on using the texture painting tools, see ZeroEditor_guide.doc in the documents folder).

## Changing the Default Sky

By default, the template map uses the sky file from Yavin.  Changing this is a fairly simple thing to do.  Browse to the world that you want to use the sky file from (again, I’ll use Kashyyyk as our example) in \BF2_ModTools\assets\worlds\KAS\world2 and copy the sky file (kas2.sky) into your mod worlds folder (\data_abc\worlds\abc\world1) and rename it to abc.sky (where abc is the 3-letter name that you gave your world when you first created it).  Open up that sky file, and search for which assets are used by the sky file, and you’ll need to copy those assets into your mod level’s world folder (\data_abc\worlds\abc\world1).  They will be a/some sky .msh files, and some textures.  Only worry about files that are actually located in the assets\worlds\KAS\world2 folder.  If there are files that the sky file is looking for that aren’t located there, then don’t worry about those.

## Adding new CPs to your map

Since most of you will want to have more than just the 4 default CPs in conquest, here is a quick tutorial on how to add more CPs to your map.  

The key things that every CP needs in Conquest:

SpawnPath – This is where you will spawn if you select this CP
CaptureRegion – The region that you need to be inside in order to capture the CP
ControlRegion – This region controls vehicle spawns, more on this later

The first thing you need to do is open the editor, and open your new world.  Continuing with the example of ABC, go to \BF2_ModTools\data_abc\ and run zeroeditor.exe from here.  Once the editor is loaded, click the LOAD button, and browse to your map (\BF2_MofTools\data_abc\worlds\ABC\world1\ABC.wld)

The first thing you’ll see when you go to load up your map is the Load Layers dialog.  For the sake of keeping things clean, and simple, always click Select All and make sure all the layers are loaded.  You can hide layers later if you want to, but it’s best if they are all always loaded.  

As an aside, there is a checkbox at the bottom called Build accurate object collision.  What this does, is builds auto-generated collision for all the objects, based on the actual mesh.  I would recommend using this, as it makes placing, selecting, and manipulating objects MUCH easier.  Otherwise, the editor will use a bounding box for collision which makes selecting objects a pain, and it makes placing objects on top of other objects much more difficult.  

Once you’ve clicked Select All and check the box to build accurate object collision, click OK.

Now, at the top-middle of the screen, you’ll see a section called Active Layer, with a button underneath it that says CHANGE.  Click that button, and it will take you into the layers dialog.  Click on conquest and then close that window.  

Now you’re going to want to go into Object edit mode.

Click on the Object edit mode button.

Click the Browse button.  Browse to the following location: \BF2_ModTools\data_abc\common\odfs, and select com_bldg_controlezone

The browse dialog will automatically close, and you be back in your editor view.  Drag your mouse around the 3D view, and notice there is now a small object that is always under your mouse cursor.  This is the CP object.  Simply click on a spot on the terrain and it will place a new CP object in your level.

Now that the CP is placed, we need to set up the name of the CP, and a few other things like what spawn path it will use, and what capture region it will use.

Click on the Select button on the upper-left part of the Object edit panel.  Move your mouse cursor over the CP object you just placed, and you’ll see it turns green when the mouse cursor is over it.  Click on it, and it will turn blue.  This means the CP is now selected.  

Now that you have the CP selected, we need to change it’s name.  I recommend keeping with the naming scheme that we used in the template files, so your new CP should be named cp5 (as we already have CPs 1 through 4 that were automatically placed when you created your level).  I also recommend always using lower case in anything you type in any of these fields, just because it eliminates the possibility of having mis-matched capitalization across associated objects.  

So let’s name this CP, cp5.  Simply click on the auto-generated name in the name field, which will highlight the name, type your new name, and hit enter.

Next, click on the 0 in the Team field, enter a 1, or 2, and hit enter.  This makes this CP belong to team 1, or 2, whichever you select, at the beginning of the match.  

The Label field isn’t really important, so you can just leave it blank.  

Notice also, that once the CP is selected, you’ll notice some new information has appeared in the Object Instance box on the right side of the Zero interface.  

The fields we want to modify are the CaptureRegion, ControlRegion, and SpawnPath fields.

In the CaptureRegion field, enter cp5_capture
In the ControlRegion field, enter cp5_control
In the SpawnPath field, enter cp5_spawn

Note: The CaptureRegion is the region that you need to be standing in in order to capture the CP.  The ControlRegion is a region that controls the spawning of vehicles associated with a CP.  Vehicle Spawns are placed inside the Control Region, and once they leave the Control Region, if they are abandoned, they will eventually self-destruct, and respawn.

Repeat the above process with however many CPs you want to add to your map.  Continue the naming scheme of cp6, cp6, etc.  And make sure to use cp6_capture, cp6_control, etc.  You can, if you like, start some CPs on team 0.  This will make them Neutral at the beginning of the match.  You need to have at least one CP start team 1, and team 2 at the beginning so the teams both have an initial CP to spawn in at. 

Now that you have your CPs in your level, with all the appropriate namings, and associations set up, we’ll move on to creating the spawn paths, and capture/control regions.  

On the Edit Mode toolbar, click on the Region button.  Notice the interface has changed slightly to show the region editing tools.

On the left side of the Zero Editor interface, you’ll now see the following tool panel:

First, click on the New Group button.  Then click on the Cylinder button under the Shape section.  This will allow you to place a cylindrical region in your level.  As with Object Mode, simply move your cursor to where you want to place your region (the regions should be placed in the same location as the CP that they are going to be used for), and left-click.  

Once your region is placed in the world, click on Select Region under the Action section.  Move your cursor over the region you just placed and click on it to select it.  

You’ll notice that just as with objects, a name is automatically filled in, in the Region ID boxes.  

At the top of the screen, next to the top Region ID box (there are 2 Region ID boxes, one on the tool panel as you can see in the image on the left, and one at the top of the screen to the right of the tool panel)  there is a box titled Class Properties.  I know this is confusing, but this is where you need to type the name of your region (I know it’s weird, but trust me, it works  )

Click in the Class Properties box, and enter the name “cp5_capture” (without the quotes).  You should then copy that name into the Region ID box to avoid any confusion later on.  It will also make the region easier to select from it’s Region ID in the list.  

Now that you have the region created, you’ll want to move it so that it is centered over cp5 that we created earlier.  To move a region, select it, as described above, and hold the C key.  You’ll see a set of axis appear on the object.  One red, green, and blue.  While you’re holding the C key, you can move the region by using the Left Mouse Button to move on the X-axis (red), the Right Mouse Button to move on the Y-axis(green), and Middle Mouse Button to move up and down on the Z-axis (blue).  Position the region so that it is centered over cp5 and sunken slightly into the ground to make sure there are no places you could stand and have your feet not be inside the region.  

That’s that.  Now when a unit enters this region, they will begin capturing the CP.

The next thing we’re going to do, is create the Control Region for this CP.  

First, click on New Group in the region tool panel.  This time, we’re going to make a box region, so under Shape, click Box.  

Now just click where you want to place the region.  Note: It should also be slightly sunken into the terrain

Select the region (click on Select Region and then click to select) and enter the name “cp2_control” into the Class Properties and Region ID fields, the same as we did on the Capture Region.  

Now we’re going to need to scale the region up a bit.  The region should already be selected.  Press and hold the Z key.  You’ll see a set of axis identical to the ones that you saw when moving objects, and regions.  But now, the Left, Middle, and Right mouse buttons will scale the region on each axis.  Scale the region up about twice as big as it is to begin with.  On the X and Y axis, while leaving the height the same.  Center this new region over the CP as well.  
  
Now, you have a cylindrical Capture Region and a rectangular Control Region.  The Control Region is used for vehicle spawns, which I’ll explain later on.  

Now that we have our CPs set up, and the capture and control regions in place, we’ll need to place our spawn points so that we can spawn in at our new CPs.  

First, click on the Path button under Edit Modes.  You’ll see a new panel on the right that looks like this:

(insert pic)

First, click New Path.  The first thing we’ll do is rename the path to “cp5_spawn”.  To do this, click on the auto-generated name in the Path Name box, and type “cp5_spawn” (no quotes) and hit enter.  

Now, to place path points, just click on the terrain where you want to place your node.  Each CP should have at least 6 or 8 spawn points.  Click on the terrain, and place 6 nodes on the ground around cp5.  

Notice that there are a set of axis visible on each path node.  There is a blue, red and green axis.  Players will spawn into the world facing in the direction of the green axis.  To rotate this axis, first click on the Move button under the Action tab, and then click on the node you want to rotate.  

Once you have the node selected, press and hold the X key to go into rotate mode.  Click and drag with your Middle Mouse Button to rotate the green axis into the position that you want players to face when they spawn in.  Repeat this process for each node.

Just to keep everything all in one place, I’ll go over quickly how to make your new CPs actually count in conquest.  You’ll need to open up your abcc_con.lua and abcg_con.lua which is located in \BF2_ModTools\data_abc\common\scripts\ABC\.  At the top you’ll see this function:

function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)    
    
    conquest:Start()

    EnableSPHeroRules()
    
 end

All you have to do to get your new CPs working in conquest, is to add entries for cp5, cp6, etc…for however many CPs you add to your level.  So let’s say you added cp5 and cp6.  You’re new ScriptPostLoad function will look like this (I’ve put in bold the additions that I made):

function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}


    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)    
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    
    conquest:Start()

    EnableSPHeroRules()
    
 end

…and that’s it.  You’re new CPs are now functional.  Note: if you don’t make these changes to your script, you’re new CPs will show up just fine in the game, and will be capturable, but they will not contribute to the conquest functionality, meaning that if CPs 1-4 are all captured, the game will still end even if CPs 5 and 6 haven’t been.  Get it?
CPs for CTF and Hero Assault

For CTF and Hero assault instead of using the object com_bldg_controlzone, which is meant for conquest CPs, you’ll use (from the same directory) com_bldg_controlzone_CTF.  The rest of the process is the same, except these CPs do not need capture regions (and in fact should never have capture regions).  In fact, control regions are only needed if you are going to have vehicle spawns associated with that CP.  The only requirements are the name, team, and spawnpath has to be set properly.  CPs in CTF (1 flag and 2 flag) and Hero Assault are ONLY used as spawn points, and will not be capturable.  

A note about layers

Be sure that you select the proper Layer when you add CPs, or any other objects to your level.

If, for example, you are in the ctf layer, and you are trying to place CPs for conquest, you’re going to get new CPs showing up in CTF, and no new CPs in conquest.  So always be mindful of which layer you are currently editing.  Objects, regions, paths, etc, that are placed in any of the game mode layers (conquest, ctf, 1flag, or eli) will only show up in that game mode.  If you want objects to show up in all game modes, you can either create a new layer (which by default will show up in all game modes) or you can just add these objects to the Base layer.  

See ZeroEditor_GameModes.doc for more info about layers and game modes.

Vehicle Spawns

In this section I’ll go over (as promised) the process of adding a vehicle into your map.
Open Zero Editor, and open your map.  (Remember to run zero editor from inside your mod directory, \BF2_ModTools\data_ABC\zeroeditor.exe )  

The first thing you need to understand about adding vehicles to your level is that all vehicles are added with the same object in the editor.  With that in mind, let’s continue.  

First, you’ll need to go to Object edit mode.  Once in object edit mode, click on Browse as pictured below:



This will open the browse window.  Browse to \BF2_ModTools\data_ABC\common\odfs\com_item_vehicle_spawn.odf

Once you select this object, you will be brought back to the Object edit mode.  To place the vehicle spawn, click on Place and simply click on the terrain where you want to place your vehicle spawn.  You should now have an object in your level that looks like this:


This is your vehicle spawn.  The arrow indicates which direction the vehicle will be facing when it spawns in.  

Select your vehicle spawn (click Select and then click on the vehicle spawn) and you’ll see the Object Instance box appear to the right.  It looks something (exactly like, actually) this:


The first parameter, ControlZone refers to what CP this vehicle is associated to.  The value that should be entered here is the name of the CP, NOT THE NAME OF THE CONTROL REGION, that you want this vehicle to be associated to.  For example, cp1, or cp5.  NOT cp1_control, or cp5_control.  

The second parameter specifies how many of these vehicles you want to spawn from this vehicle spawn.  I recommend always keeping this set to 1, and just add more vehicle spawns if you want more vehicles at a given CP.  

ExpireTimeEnemy specifies how long a vehicle will sit idle, un-manned once the enemy has taken over the associated CP, before the vehicle will begin to decay.

ExpireTimeField specifies how long a vehicle will sit idle, un-manned in the field once it has left it’s control region.  

DecayTime specifies how long a vehicle will take to decay and self-destruct once the expire time has been reached.  

 The vehicle that will spawn from this vehicle spawn is determined by what you enter in the Class fields.  For example, if you wanted this vehicle spawn to spawn a rebel combat speeder when the rebels own this CP, you would enter all_hover_combatspeeder into the ClassAllATK field.  This is assuming that the rebels are set as team 1.  Whether a team is ATK or DEF is determined by what team they are set as.  ATK will spawn vehicles when that team is set as team 1, DEF will spawn vehicles if that team is set as team 2.  

Note: 2 values that are no longer used are ClassHisATK and ClassHisDEF.  Entering values in this field will accomplish nothing, so….just don’t bother.  

If you click Page DN you’ll see that there are more Class fields.  As another example, if you want this vehicle spawn to spawn an ATST on a map where the rebels are team 1, and the empire is team 2, then you would click Page DN and enter imp_walk_atst into the ClassImpDEF field.  

You can also have vehicle spawns spawn vehicles when either team owns the CP.  If this is the case, you could enter both all_hover_combatspeeder under ClassAllATK AND imp_walk_atst under ClassImpDEF.  

Additionally, you can use a vehicle spawn to spawn vehicles for both eras, you just need to specify the vehicle classes in the corresponding Class parameters. 
Distributing your new level/mod

Once you have spent endless hours perfecting your new creation, to distribute your new level to other Battlefront II players, all you have to do is go to your mod folder in your Battlefront II folder; \Star Wars Battlefront II\GameData\Addon\ABC, zip all the data in there up, and SHIP IT!  Note: you want your zip file to contain ONLY the path info from Addon forward, so in winzip, your file should look like this(pay particular attention to the Path section):

## BF2_modtools.exe
Along with the Mod tools, we’ve released an executable that you can use to run Star Wars Battlefront 2 in a mode that will allow you access to the dev console (press ~ when in the game) which will help make debugging, and developing your mod easier.  This executable still has a CD check, and has been crippled in some ways so as not to be used as a stand-alone exe to run and play the game.  BF2_modtools.exe can be found in the root of the BF2_ModTools folder.  This .exe is completely unsupported, as is everything else in this mod tools release.  See the mod tools EULA for more info.  

# Procedural Animations in ZeroEditor
**Author:** Mike Z (Production Manager)
**Editor:** Joe Shackelford (Developer)

Procedural Animation (PA) is a method of defining movement for static objects using keyframes to add life to levels. 

## Core Concepts
A PA consists of a series of keyframes storing either a position or rotation (in degrees) at a specific time (in seconds). Position and rotation are handled separately.

### Capabilities
*   Move static objects over time.
*   Associate animations with specific objects.
*   Combine multiple animation/object pairs into an **Animation Group**.
*   Control groups in-game via Lua (Play, Pause, Restart, Sections).

### Limitations
*   Cannot move regions or dynamic objects (players, bots, spawned vehicles).
*   No fine-grained sound control.

## Entering Animation Mode
1.  Select **Animation Mode** from the bottom of the **Object Mode** menu.
2.  To exit, click **Back to Object Mode** in the top-center.
3.  **Note:** Changes made to objects in Animation Mode are non-permanent; objects revert to their Object Mode positions upon exit.

### Display Options
*   **Show Path:** Toggles the visual path of the object over time.
*   **Show Ghosts:** Toggles "ghost" instances of the object at regular time intervals.
*   **Toggle Graph:** Displays X, Y, and Z position/rotation curves.

## The Animation Side Menu
| Field | Purpose |
| :--- | :--- |
| **Animation Name** | Name of the current animation definition. |
| **Object Name** | Name of the selected object being animated. |
| **Frame Time** | Current time in the timeline (Slider/Box). |
| **Run Time** | Total duration of the animation in seconds. |
| **Loop** | If enabled, restarts from 0s upon completion. |
| **Local Translation** | If enabled, moves the object relative to its current rotation (useful for "forward" movement while turning). |

### Keyframe Control
| Control | Description |
| :--- | :--- |
| **Add / Delete** | Creates or removes a keyframe at the current Frame Time. |
| **X, Y, Z Fields** | Manually adjust coordinates or degrees. |
| **Transition Type** | **Pop** (instant), **Linear** (standard), or **Spline** (smooth curve). |
| **Spline Slopes** | 6 fields to define "In" and "Out" slopes for smooth curves (best used with the Graph visible). |

## Creating a New Animation
1.  Click **Add** and provide a descriptive name.
2.  Enter the total **Run Time**.
3.  Select an object (must be named in Object Mode).
4.  **Important:** PA coordinates are relative to the object's position when you entered Animation Mode.
5.  Move the **Time Slider** to your desired time.
6.  Move/Rotate the object, then click **Add** under the Position or Rotation menus.
7.  Click **Play From Start** to review.

## Animation Groups
An Animation Group is a collection of animation/object pairs. Only Groups can be played in-game.

1.  **Add Group:** Create and name a new group.
2.  **Add Pair:** Click Add in the Animation/Object Pairs section.
3.  **Define Pair:** Enter the name of the Animation and the Object it applies to.
4.  **Plays When Level Begins:** If checked, the animation starts automatically on load.
5.  **Disable Hierarchies:** Temporarily ignores parent/child relationships for that group.

## Creating Hierarchies
Hierarchies allow one "Root" object to control the movement of "Child" objects.

1.  Select the **Hierarchies** panel.
2.  Click **Add** under the Hier List.
3.  Enter the **Root Name** (Parent).
4.  Click **Add** under the Obj List and enter the **Child** object names.
5.  **Tip:** Animate the parent; children will follow automatically.

## In-Game Control (Lua)

### Lua Functions
| Function | Description |
| :--- | :--- |
| `PlayAnimation("GroupName")` | Resumes playback from the current time. |
| `PauseAnimation("GroupName")` | Pauses playback; objects remain in place. |
| `RewindAnimation("GroupName")` | Resets the timeline to 0s. |
| `PlayAnimationFromTo("GroupName", start, end)` | Plays a specific slice of the timeline (in seconds). |
| `SetAnimationStartPoint("GroupName")` | Sets the current world positions as the new reference "0" for the group. |

### Understanding Start Points
By default, objects use their level-load positions as the starting point. 

*   **Repeating relative movement:** If you have an animation that moves an object +10m on X, calling `PlayAnimation`, pausing at the end, and calling `SetAnimationStartPoint` before playing it again will move the object to +20m.
*   **Sequential groups:** Start points are per-group. To make "GroupB" start where "GroupA" finished, call `SetAnimationStartPoint("GroupB")` after GroupA finishes.

# (FAQ) Sound editing and you (by Maveritchell)
Custom sounds? No problem. This tutorial will explain the layout you should use for any custom sound and explain why you are doing what you are doing instead of laying out the steps for any specific type of sound editing (although a little bit here or there may be touched on).

This is not a comprehensive tutorial! To refer to specifics of how each type of sound is set up, you should reference the stock sounds. Once you know what each thing means (which is the goal of this tutorial), understanding should flow easily.

Sounds are all set up in a hierarchy. There are two main branches to this hierarchy: streams and effects.

Streams are, for the most part, going to be the "longer" pieces of music/audio that you'd use for ambient environment sounds, voices, or ambient music.

Effects are the shorter sounds used for ordnance and vehicles.

There are four "types" of files loaded in sound .req files:
"str" files (which are all .stm [and maybe .st4; that might be used more for ambient envfx or might be obsolete] files), "bnk" files (which are all .sfx and .asfx files), "config" files (which is most everything else, .snd, .mus) and then "lvl" (other .req files; "children").

Both of these (streams and effects)- if you've correctly set up a sound folder (or looked at stock sound folders for example) - will have corresponding folders of their own in your "data_ABC\Sound\worlds\ABC" folder.

In each of those folders you will need to put your .wav files, formatted to: 352 kbps, 16 bit, mono, 22 kHz PCM
Weapon sounds need to go in "effects", ambient sounds need to go in "streams".

The streams hierarchy works like this:
.wav files -> .stm file -> config file(s)
What does this mean? Here is an example "ABC.req" (main .req file)
```
ucft
{
    REQN
    {
        "str"
        "align=2048"
        "ABC_stream"
    }
    REQN
    {
        "lvl"
        "ABCgcw"
    }
}
```

In this file, "ABC_stream" (under "str") is the `.stm file` and "ABCgcw" is the "child" `.req` (specific to the gcw era). "ABC_stream.stm" references our `.wav` file (named "ABC_amb_1.wav") like this: `streams\ABC_amb_1.wav ABC_stream_name -resample xbox 22050 pc 22050`
You can see that it "renames" it to "ABC_stream_name" (an alias) which is referenced later.

Next, inside the "ABCgcw.req" file, you'll see something like this:
```
ucft
{
    REQN
    {
        "bnk"
        "align=2048"
    }
    REQN
    {
        "config"
        "ABCgcw_music_config"
        "ABCgcw_music"
    }
}
```
In this file, nothing is loaded under "bnk" (no .sfx or .asfx for streams). "ABCgcw_music_config" is a .snd file and "ABCgcw_music" is an .mus file - for ambient music, these must be loaded in this order in the .req (as the .mus file references the .snd file).

"ABCgcw_music_config.snd" references "ABC_stream.snd" here:
```
SoundStream()
{
    Name("ABC_stream_name");
    Pitch(1.0);
    PitchDev(0.0);
    Gain(1.0);
    GainDev(0.0);
    ReverbGain(0.0);
    Bus("ingamemusic");
    Looping(0);
    Pan(0.0);
    Mode3D(0);
    Stream("ABC_stream");
    SegmentList()
    {
        Segment("ABC_stream_name", 1.0);
    }
}
```

Then, "ABCgcw_music.mus" references "ABCgcw_music_config.snd" here:
```
Music()
{
    Name("ABC_stream_name");
    Priority(1.0);
    FadeInTime(0.0);
    FadeOutTime(1.5);
    MinPlaybackTime(20.0);
    MaxPlaybackTime(300.0);
    MinInactiveTime(2.0);
    SoundStream("ABC_stream_name");
}
```
Your name here is going to be the one referenced in the .lua in "SetAmbientMusic". So you can see how each reference trickles down.

The same happens with effects. The hierarchy for effects is this:
.wav files -> .asfx (what you will use for custom effects) files -> config files
Our .wav sound will be the explosion sound "combust.wav" for this example. Here is your parent "ABC.req;" note that all this does for us right now is load the child .req:
```
ucft
{
    REQN
    {
        "str"
        "align=2048"
    }
    REQN
    {
        "lvl"
        "ABCgcw"
    }
}
```

In the child "ABCgcw.req", we have this:
```
ucft
{
    REQN
    {
        "bnk"
        "align=2048"
        "ABC_effects"
    }

    REQN
    {
        "config"
        "ABC_wconfig"
    }
}
```
Note that now we load the next in the hierarchy - "ABC_effects.asfx" - next. It references our "combust.wav" here:
`effects\combust.wav -resample xbox 22050 pc 22050`

Next loaded is the config file "ABC_wconfig.snd". It references the "ABC_effects.asfx" file here:
```
SoundProperties()
{
    Name("combust");
    Group("explosion");
    Inherit("explosion_template");
    MinDistance(5.0)
    MaxDistance(60)
    MuteDIstance(60)
    RollOff(1.0)
    SampleList()
    {
        Sample("combust", 1.0);
    }
}
```
The name given up top (also "combust") is the name to be referenced in an .odf.

The last part of setting up sounds (and separate from the hierarchy above) is going to be loading them in the .lua. Effects can always be loaded simply by the basic dc:sound call, e.g. `ReadDataFile("dc:sound\\ABC.lvl;ABCgcw")`

This is mentioned in greater detail in every other tutorial on the site, make sure you look at them too.
Streams (since the .stm file is referenced in the main .req and not in the child .req like everything else) need to have an additional reference (they also need the above reference) in the .lua. This is usually further down in the .lua (and is also mentioned in greater detail in other tutorials on the site). It looks something like this: `OpenAudioStream("dc:sound\\ABC.lvl", "ABC_stream")`

*One final word!*
All of this can be done in the SWBF2 tools, but by default this is not made available to you.
There are three files you need to fix to make your tools work.
Download the following .zip file and place the files inside where directed below: http://www.mediafire.com/?1ytavf2dxzkddt9

First: "munge.bat" to "data_ABC\_BUILD\Sound".

Second: "soundmungedir.bat" to "data_ABC".

Third: "soundmunge.bat" to "data_ABC" - edit this first, though:
You will need to edit "soundmunge.bat":
Open it and replace all instances of "ABC" with your three-letter map name.

Once you've done those three, you're good to go.

# [TUTORIAL] Custom SFX implementation (by giftheck)
I'll be referring to the mod folder as MOD or DataMOD in this tutorial, but it'll be whatever you have named yours.

So, first off, there's two file formats you'll need to implement custom SFX:
SND - this is the actual configuration file that stores what samples are called, pitch, volume, etc.
ASFX - this is where the samples called by the SND are stored.

Create a folder inside DataMOD/Sounds/worlds and name it whatever you want (most likely the three letter MOD name)
Inside that, you'll also need two folders - effects, and streams.
Basically, this is what the folder will look like:
- base REQ file (the MOD id)
- REQ file for effects and streams called for CW (MODcw)
- ASFX file for effects and streams called for CW (MODcw)
- Same as above, but for GCW
- SND files - doesn't have to be for both, and you can have as many of these as you like. The best practice here is to have an SND file for shared SFX (in this instance it would be the LEGO brick explosions upon death) and a separate one for each era. These can be called whatever you want but for simplicity's sake I'll go with MODcw, MODgcw, and shared.

First, you'll need your sound effects placed into the effects folder. These sounds, ideally, should be saved as 22kHz mono wav files.
Next, you'll need to set up the REQ files. Open MOD.req. This is what needs to be inside:
```
ucft
{
    REQN
    {
        "str"
        "align=2048"
    }
    REQN
    {
        "lvl"
        "MODcw"
        "MODgcw"
    }
 }
```

Now open MODgcw.req. This is what needs to be inside that:
```
ucft
{
    REQN
    {
        "bnk"
        "align=2048"
        "MODgcw"
    }
    REQN
    {
        "config"
        "MODgcw"
        "shared"
    }
}
```
Same would go for MODcw.

The bnk section will look for ASFX and SFX files. However, SFX files are not useful in this instance since we're not making a new common.bnk, these sounds are to be munged and loaded directly from the sound.lvl and not the shared PC sound bank.

The next step is top open up the ASFX file in Notepad. It should be blank. All this will be is a list referring to the .wav files. All that needs to be is thus: `effects\whatever_the_sound_is_called.wav`
You can also add ` -resample pc 22050` (changing 22050 to whatever you want) but if the wavs are already 22khz this is not needed.

Now comes the 'fun' part - the SND files. Open shared.snd. Windows will try to open these in Windows Media Player, but they are, in fact, just text files, so you open these with Notepad also.

This is the 'fun' part because you have to figure out which settings are appropriate for the sound you want to implement.
In this instance I find it much easier to just find one of the stock SND files, open it, look for a sound that is similar to the one you're looking for. In this example we are going to implement a custom death sound SFX.
So find `imp_unit.snd` in the sound/gcw folder. Any of the sounds that inherit from `"imp_inf_pain_vo"` will be fine to copy into your snd file. As an example:
```
SoundProperties()
{
    Name("imp_inf_com_chatter_death");
    Group("imp_inf_pain_vo");
    Inherit("pain_chatter_template");
    PlayInterval(0.0);
    PlayIntervalDev(0.0);
    PlayProbability(1.0);
    SampleList()
    {
        Sample("IICOM419", 0.33);
        Sample("IICOM420", 0.33);
        Sample("IICOM421", 0.33);
    }
}
```
Now, generally, the settings don't need to be messed with. You will need to change two things though:
- The 'name' of the sound
- The samples called in the list.

Name is easy. Just change it to whatever you want to. You can then paste that name into your ODF files' DeathSound line.

The sample list is a tad more complicated.
You have these values bracketed under it:
```
    ...
        Sample("IICOM419", 0.33);
        Sample("IICOM420", 0.33);
        Sample("IICOM421", 0.33);
    ...
```
Sample is obvious as this refers to the file names as defined in the ASFX file. The number defines the 'weight' of the sound - basically, it randomizes the sound called. The number should always be 1 divided by the number of samples in the list, rounded to 2 decimal places.

Let's say this is what's in the ASFX file:
```
effects\LEGO_FALLAPART1.wav
effects\LEGO_FALLAPART2.wav
effects\LEGO_FALLAPART3.wav
effects\LEGO_FALLAPART4.wav
effects\LEGO_FALLAPART5.wav
```
You'll want all of those to be called into the SND, and all equally 'weighted'.
So your sample list will end up looking like this:
```
    ...
        Sample("LEGO_FALLAPART1", 0.2);
        Sample("LEGO_FALLAPART2", 0.2);
        Sample("LEGO_FALLAPART3", 0.2);
        Sample("LEGO_FALLAPART4", 0.2);
        Sample("LEGO_FALLAPART5", 0.2);
    ...
```
That should conclude the setting up of the ASFX, SND and REQ files, but if you try to munge now, you'll get nothing. Unlike the SWBF1 mod tools, the SWBF2 Mod Tools aren't automatically set to allow for munging of custom sounds. So, there is a bit of tinkering left to do before you're ready.

Open up the soundmungedir.bat file
Find this line: `for /R %%A in (*.sfx) do @echo Munging %%~nA%%~xA & @soundflmunge -platform %4 -banklistinput %%A -bankoutput %MUNGEDIR%\ %CHECKDATE% -resample %CHECKID% noabort %SOUNDOPT% %BANKOPT% 2>>%MUNGE_LOG% 1>>%SOUNDLOGOUT%`

Paste this under that line:
`for /R %%A in (*.asfx) do @echo Munging %%~nA%%~xA & @soundflmunge -platform %4 -banklistinput %%A -bankoutput %MUNGEDIR%\ %CHECKDATE% -resample -checkid noabort %SOUNDOPT% 2>>%MUNGE_LOG% 1>>%SOUNDLOGOUT%`

You will also need to do this for the original Data folder (BF2_ModTools\Data)

Next find BF2_ModTools\data\ _BUILD\sound\munge.bat, open that, find this line: `@for /R %%A in (*.sfx) do @set BANKLIST=!BANKLIST! %%A`
Under that, pop this in:
`@for /R %%A in (*.asfx) do @set BANKLIST=!BANKLIST! %%A`

Lastly, you'll need to edit an entry in soundmunge.bat inside your DataMOD folder. Find this line:
`@call soundmungedir _BUILD\sound\worlds\snd\%MUNGE_DIR% sound\worlds\snd sound\worlds\snd\%MUNGE_PLATFORM% %MUNGE_PLATFORM% _BUILD _LVL_%MUNGE_PLATFORM%\sound _BUILD\sound snd`
Change snd to whatever your base REQ file is (which assumedly is your MOD id)

The last step is calling it in your LUA. Find this line: `ReadDataFile("sound\\tat.lvl;tat2gcw")`
Then add this above: `ReadDataFile("dc:sound\\MOD.lvl;MODgcw")`
One other thing is that it seems the Sound folder won't copy over to the addon folder, at least not when I test munged, so you will have to do that manually.

Munge, test... and if your sounds work (there is a chance that a sound will not play if it's not in the correct format but usually the munger catches that), then that's it!
(NOTE: I am not able to test the munged sounds directly myself since I cannot get munged maps to even run in SWBF2 - however, the steps I have outlined produce a functioning sound file)

Extra Info on Recommended Sound Specifications by Marth8880:
| Sound Type | Specs |
| :--- | :--- |
| Ambient/music streams | Stereo, 44,100 to 48,000 Hz |
| Voice over streams | Mono, 22,050 Hz to 32,000 Hz |
| Effects | Mono, 22,050 to 44,100 Hz |
| Low-frequency effects | Mono, 10 Hz to 8,000 Hz |
