# Virus LQP-79 (MSX)

![](docs/graphics/tiles/intro_menu/intro.png?raw=true)

*Port to MSX of the Arduboy game [VirusLQP-79](https://github.com/TEAMarg/ID-40-VIRUS-LQP-79) of Team Arg.*

*Submited to [MSXDev18 contest](https://www.msxdev.org/2018/05/10/msxdev18-3rd-entry-virus-lqp-79/)*

Latest release [download](https://github.com/Pentacour/viruslqp79_msx/releases/tag/v1.1)


## Story
"*Amy lived her happy life in a pretty normal town … until that fateful accident at the nearby research facility. Officials denied the incident at first, until the entire facility was abandoned. Neighbours started acting weird. Amy didn’t feel safe anymore. While trying to leave town, she found herself running from a hoard of zombies. What Amy didn't expect, was to find other survivors. Help her escape and rescue the ones not infected by the LQP-79 virus. Hurry!*"

## How to Play
Use cursors or Joystick to move Amy. Push fire button or space to shoot the zombies. Each shoot spends energy of Amy's weapon. If you have enough energy you can get a mega-shoot with M key or secondary fire button.

Contact with zombies quits Amy's hearts. If zombies hug you, move Amy fast in all directions shooting them!

Save the three survivors of each level and escape through the door before time outs.

Walk the 32 levels and if Amy is agile enough, you will save people of the epidemic. If you take a long time, maybe you will arrive later...

Pause the game with F1.

![](docs/graphics/tiles/intro_menu/sc1.png?raw=true)

![](docs/graphics/tiles/intro_menu/sc2.png?raw=true)

## Where to Play
Downloading the .ROM file and:

- With an MSX computer. 
- With an emulator like [BlueMSX](http://bluemsx.msxblue.com/download.html), [openMSX](https://openmsx.org/) or online [FileHunter](https://www.file-hunter.com/MSX/). 

## How to assemble

First I used XL2S [Sjasm assembler](http://www.xl2s.tk/) and then I moved to Pipagerardo [sjasmpg](https://github.com/pipagerardo/sjasmpg). I think the two assemblers can be used.

Download the executable sjasm or sjasmpg. Download Virus LQP-79 code and into src directory execute:

**Windows**
sjasmpg_win_eng.exe main.asm

**macOS**
./sjasmpg_mac_eng main.asm

**Linux**
./sjasmpg_linux_eng main.asm

An lqp79.rom file will be created.

## Credits
Arduboy Version: Team Arg (Fuopy, JO3RY, Justin Cyr and Castpixel).
Sprites (Amy, green zombies and survivors): Justin Cyr.
Sprites (Blue zombies): Yahring.
Tiles (Arduboy): JO3RY.
Tiles (MSX port): xmangel.
Splash Screen: Colored and enhanced for MSX by xmangel.
Rest screen, Half mission screen and ending screens: Yahring.
Soundtrack: Bitcaffe.
Coded in assembler for MSX: Pentacour.

## Tools & Thanks
Sjasm (Sjoerd Mastjin) and SjasmPG (PipaGerardo).
OpenMSX and BlueMSX.
WYZ Player and WYZ Tracker.
nMSXTiles.
Pletter.

Thanks to the knowledge database of Karoshi forums and MRC.

Thanks to Ranger7H (11 years old) and AlexBat777 (7 years old) for testing the difficulty :-)

This mini-game and this format (electronic .rom) is a definitive release. Only bytes to inject to your MSX or emulator. Nothing more, nothing less. 

Enjoy!

-2018- Pentacour.

