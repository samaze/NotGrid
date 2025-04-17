# NotGrid
NotGrid is a party and raid frame addon for Vanilla World of Warcraft (1.12.1). While heavily based off of the original addon Grid, it both lacks some Grid features as well as adds new ones. It supports Clique keybinds & macros, Lazyspell, healcomm, eight buff/debuff icons around the unit frame, low mana & aggro warning, proximity checking, pets, and a simple config menu for general resizing/coloring options.

![Screenshot](media/screenshot.jpg)

## Usage
Use */notgrid* or */ng* to show the config menu.  
Use */notgrid grid* to generate a style similar to the original grid.  
Use */notgrid reset* to restore the default settings.  
Use / for separating multiple Buffs/Debuffs to track on one icon.  
Use */ngcast spellname(Rank X)* in macros for mouseover casting.

## Optional Dependencies
Clique: Enables click-casting on your unit frames.  
LazySpell: Enables Clique and /ngcast auto spell rank scaling depending on unit health deficit.

## Additional Note
If you're having issues with the frame borders/edges being un-uniformly sized or appearing clipped by the healthbar make sure to have a proper [UI scale](http://wow.gamepedia.com/UI_Scale) set.  
TLDR: If you play with a 1920x1080 resolution, the correct UI scale would be 768/1080 = 0.7111..., and you would set that by typing */console UIScale 0.7111111111* in the chat.

## README FIRST - What Have I Changed from the Origin Repo?
/ngcast macros will now check targets in the following order:
- mouseover
- selected target (Friendly)
- player

This makes the /ngcast command a much more useful one-stop option for casting. 

Note: 
To get the same effect as **#showtooltip** on your WoW 1.12 macros, add the following line on the end of the macro:
```
if 1==2 then CastSpellByName("SPELL_NAME"); end
```

The UI will see the use of `CastSpellByName` and add the tool tip, *but* we don't actually want to call it, so it's wrapped in an if statement that will always be false. If we don't wrap it, it will work, but it will make an annoying error noise every time because you're effectively trying to run two spell casts at the same time. 

