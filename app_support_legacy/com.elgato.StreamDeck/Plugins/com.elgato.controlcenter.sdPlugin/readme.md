

2023-01-11 (269)

# Changes:
-----------
- fixed a problem where `sceneId` was not set correctly in Windows 

2023-01-05 (268)

# Changes:
-----------
- flipped `Set Scene` and `Brightness` actions in the PI (as the `Set Scene` action is more important)
- force `Set Scene` action to switch scenes as default behaviour
- added final touches to the `Scene` feature
- fixed another issue where `temperatureMin` and `temperatureMax` were flipped (please note: this is a bug in CC.exe)
- fixed an issue, where the icon of a `KeyLight Air` showed a wrong background color

# Known issues:
---------------
- `Adjust scene/brightness` string is not yet localized


2022-12-30 (267) - Hotfix

# Changes:
-----------
- compatibility fixes for Control Center Windows (range-slider couldn't be moved)
- fixes some minor issues found since the last release
- adds latest localizations


2022-12-12 (263)
# Changes:
-----------
- fixed scene without name (or without scene.id) to show 'Untitled' instead of 'undefined'
- fixed a problem where the step size was not saved
- fixed a problem where deviceConfigurationChanged events were not properly applied
- fixed a long-standing bug where on/off state of a light was removed when setting a color
- fixed a problem where the device-updates where not properly shown on the touch-panel
- changed a scene's property inspector to now support layout switching (via radio-buttons)
- changed the way the plugin detect 'dead' scenes and handles those in the PI
- better handling of scenes with no name
- reworked scene overlay icons to show the type of dial-action
- new action icon for 'Set scene' action
- slightly changed the way/sequence the touch-panels are updated, to help with flickering and responsiveness
- added firmware-checks, if a completely new device is added
- re-activated old layout data via string-templates (to be able to use layout-switching with current code)
- removed lots of encoding for svgs to reduce traffic & cpu
- enhanced svg-caching
- enhanced device-communication (to potentially help with random disconnects)


2022-12-10 (262)
----------------
- fixed a problem where deviceConfigurationChanged events were not properly applied
- fixed a long-standing bug where on/off state of a light was removed when setting a color
- fixed a problem where the device-updates where not properly shown on the touch-panel
- changed the way the plugin detect 'dead' scenes and handles those in the PI
- better handling of scenes with no name
- slightly changed the way/sequence the touch-panels are updated, to help with flickering and responsiveness
- added firmware-checks, if a completely new device is added

2022-12-08 (259)
----------------
- fixed scene without name (or without scene.id) to show 'Untitled' instead of 'undefined'
- fixed a problem where the step size was not saved
- changed a scene's property inspector to now support layout switching (via radio-buttons)
- re-activated old layout data via string-templates (to be able to use layout-switching with current code)
- reworked scene overlay icons to show the type of dial-action
- removed lots of encoding for svgs to reduce traffic & cpu
- enhanced svg-caching
- enhanced device-communication (to potentially help with random disconnects)

2022-12-06 (256/257)
-----------
- fixed a problem, where a deviceConfigurationChanged event was sent when hue was 0 (zero), which CC doesn't like....
- fixed some more occurrences where temperatureMin and temperatureMax were flipped (this should finally fix the 'stuck' range-slider :beten:)
- fixed a problem where the sceneId was not set correctly
- changed 'Adjust scene' wording to 'Rotate dial to switch scenes' (as it is more accurate, but also much longer)
- fixed a problem where the 'Rotate dial to switch scenes' setting was not saved correctly
- improved colors of the indicator on the touchpanel
- improved rendering of the scene icon on touchpanel AND key
- improved/reduced (drastically) sending data send over websockets (which hopefully reduces the disconnects experienced earlier)

2022-12-05
-----------
- Lights On/Off action now shows the first color of a scene, if the lightstrip runs a scene
- Render the Key Icon smaller
- Smaller indicator for the current scene
- Now tapping the touchpanel or pressing the dial will switch the light on or off AND set the scene
- -> Q: When switching the light OFF, still activate the scene? Or only when switching ON? (default is the latter)
- Test: Long-pressing a KEY for a Scene action, now toggles the light on/off
- Moved scene-rendering to a SD+ layout ($B1)
- rotating the dial now sets the overall brightness of a scene
  
--- 254
- fixed enabling scenes
- added step-size functionality
- added step-size selector to the PI
- moved current scene-indicator to the left side
- Long-pressing a KEY for a Scene action, now toggles the light on/off / normal pressing just activates scene
- > Note: pressing keys will always sets the scene (even if switching off)

--- 255
- added selector to the PI to activate 'Adjust scene' (Rotate through the list of scenes) (<- wip ->)
- this allows you to choose, if rotating a dial in/decreases the brightness or switche to the next/previous scene

-- Summary for Slack:
---------------------
After some discussion, I changed the behaviour of the `Scene` feature as follows:
- Now supports showind scene information (icon and brightness) on an integrated SD+ layout ($B1)
- Tapping the touchpanel or pressing the dial will switch the light on or off *AND* set the scene
- -> When a light is switched ON the scene is automatically activated (in case it was not active before) (this only applies to *DIALS*)
- Long-pressing a *KEY* for a Scene action, now toggles the light on/off / normal pressing just activates scene
- > Note: pressing keys will always sets the scene (even if switching off)

- Other actions operating on a light (e.g. Lights On/Off) now show the first color of a scene, if the lightstrip runs a scene
- Renders the Key Icon smaller
- Smaller indicator for the current scene
- fixed enabling scenes
- added step-size functionality
- added step-size selector to the PI
- moved current scene-indicator to the left side

- rotating the dial now sets the overall brightness of a scene (see next item)
Test:
- added selector to the PI to activate 'Adjust scene' (Rotate through the list of scenes) (<- wip ->)
-> this allows you to choose, if rotating a dial in/decreases the brightness or cycle through your scenes

2022-12-02
-----------

### Scenes
ControlCenter plugin now supports the new 'Scenes' feature in ControlCenter 1.4 and newer. 

How it works:
---------------
#### On a Key:
Drag a 'Set Scene' action onto your Stream Deck key. Select the scene you want to switch to from the Property Inspector's dropdown menu.
- press the key to activate the scene

#### On a Dial:
Drag a 'Set Scene' action onto your Stream Deck dial. Select the scene you want to switch to from the Property Inspector's dropdown menu.
- Quick press the dial to switch the light on or off (an indicator on the touch panel will show the light's current state)
- Long press the dial to activate the scene
- Rotate the dial to step through the scenes of the lightstrip

#### On a Touch Panel:
Drag a 'Set Scene' action onto your Stream Deck dial. Select the scene you want to switch to from the Property Inspector's dropdown menu.
- Quick tap the touch panel to switch the light on or off (an indicator on the touch panel will show the light's current state)
- Tap and hold the touch panel to activate the scene

### On/Off icon
a small on/off icon at the center of the key or touch panel shows the current state of the light (on/off)


#### Indicator:
a small indicator at the top-right of the key or touch panel shows if this is the current scene of the light (if applicable)


2022-10-11 
------------
#### New behaviour of touchpanel
- If user unchecks `Show Title` in the PI, NO title will be shown in the touchpanel (no matter what is set in the title field of the PI itself)
- If user checks `Show Title` in the PI, the title will be shown in the touchpanel. If there's no title in the PI, the title will be set to the name of the device (as it was before). If the plugin doesn't know the name of the device, the title will be set to the current actions name.

#### fixes a tiny bug, where rotating the dial clockwise would loose the first tick, if the dial was set to 3% or less;


2022-10-12
------------
- re-introduced updating of dynamic images  // https://elgato.atlassian.net/browse/SD-5238
- to avoid unnecessary traffic, svg images are only updated, if they are really changed
- PI-controls now better mimic the UI of native controls

2022-10-13
------------
- Adjust update throttling to reduce more flicker on the touchpanel (while swiping)


2022-10-20
------------
- Add ColorPanel action, which allows changes settings of a light with colors (atm. LightStrip only)
- 
![Color Panel](readme.png)

What you can do:
Drag the 'Color Panel' action to a touchpanel, and set the light you want to control. 

Spectrum: (upper part of the color panel)
- press the dial (short): light turns on/off
- press the dial (long): add debug mode and show current settings of a light
- touch the color spectrum (short): light turns on/off
- touch the color spectrum (long): set the color of the light to the color under your finger (approx ;))

Values (lower part of the color panel) = (Hue, Saturation, Brightness)
- touch one of the text-boxes (long): set focus to the text-box
- if focus is set to a text-box, you can change the value by turning the dial (your light changes as you dial)


## GENERAL:

2022-12-01:
General question: 
To be in sync with the other dials:
- a short press switches the light on/off
- a long press of the dial sets the scene
Same for touches
Q: What, if the light is set to another scene when switching the light on? Should a short press toggle the light AND select the scene?

atm (2022-11-07) output differs from Mac to Window
 Plan is 
- to use the same output for both

FIRST USE OF A SCENE (default behavior):
- user drags in a new scene
- most likely no scene is set in the device
- sceneId is set to the first scene found in the device's favoriteScenes, and then saved in the settings

USER SELECTS ANOTHER DEVICE in the PI (but had a scene from the previous device in settings, which are not valid for the new device)
 (Note: we can't just copy the scene's value, because we can't create a scene from the plugin)
So what do we do?
-> we could set the sceneId to the first scene found in the device's favoriteScenes (if any) and ignore the settings
-> we could try to find a scene with the same name in the new device and set the sceneId to that scene (this would also allow a user to change the device and keep the scene)


DEFAULT HANDLING:
if no 'favoriteScenes' are found, the device is not a supported light for this action (and not shown in the PI)
if favoriteScenes is an empty array, the device is a supported light, but has no scenes (show 'no scenes found' in the PI)
if favoriteScenes is an array with scenes, show the scenes, BUT
- if the device already has a sceneId, but it is not in the favoriteScenes array, what to do?
- -> find a scene with the same name in the current array of scenes?
- -> preselect this scene (if found)?
- -> ignore? (that's what we do in other CC-actions, because the property in question might re-appear again - which is unlikely for a `sceneId`, because it looks 'unique')
