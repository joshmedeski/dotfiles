## Changes:
2023-09-08
- added the ability to pre-install arbitrary icon packs
- pre-installed icon packs can now be hidden (but not uninstalled)
- - added 3 more Elgato icon packs 
- added support for the `new` tag on fresh installed icon packs (they now show a `new` tag, even if IL was not running while they were installed - needs SD 6.4.0 - 19580)
- fixed broken 'zoom' buttons
- Repo moved to GitLab


2021-04-14
- change default-settings to show bottom-bar by default

2021-04-13
- merge old and new code and upload to a common repository
- new build-process and scripts (more details in * [Dev Documentation](../README_DEV.md)

2021-04-12
- streamlined drawing of vectors
- improve styling of the bottom bar
- change icon-area height to not overlap bottom bar

2021-04-01
- add bottombar styling

2021-03-29
- add settings to global storage
- add zoom in/out icons

2021-03-26
- Allow scaling of icons in the grid-view
- Add preliminary bottom-bar 

2021-03-25
- Gifs now show a tiny 'GIF' symbol to let them easier identify
- Gifs now play on hover
- reworked StreamDeck-integration (naming, icon-pack-structure, etc...)
- Now sort-order is stored and re-created (if icon-packs were sorted before)
- expanded state is stored/re-applied
- visibility of icon-packs is stored/re-applied
- newly added icon-packs are now shown at the TOP of the list (Q. keep it like this?)
- alt-click the disclosure triangle in the list will expand/collapse all icon-packs
- alt-click the checkbox in the filter-list will show/hide all icon-packs (except the default one)


2021-03-23
- removed editor canvas and layers per default (hidden)
- removed (i) icon to show the about window (gone for now)
- re-arranged (top-) toolbar layout to fit with the changed window size
- re-worked GIF loading
- identify icon-packs by UUID (instead of name)

2021-03-17
- loading a gif doesn't need an additional png (it helps performance, though)
- improved loading of external files (svg, png, gif, bmp) through file-selector
- improved handling of drag and drop files
- improved spacing around inspector pane
- fixed version-info in about window

2021-03-16
- removed 'Custom Fonts' section from font-list
- improved (delayed) font-loading
- deferred loading of icons a tiny bit... so UI feels more snappy (comments welcome!)
- fixed missing localization in fonts
- fixed display of broken covers after an icon-pack search 
- fixed showing font-preloader spinner showing in main window (instead of canvas) (<-when loading webfonts)
- optimized GIF support

2021-03-15
- fixed (non-) scrolling of layers list
- fixed alignment of sliders
- added some missing localization strings
- removed unnecessary cascading of HTML-nodes
- improved display of GIFs on top of the layers-list
- improved font-loading of WebFonts
- optimized CSS usage
[Known issues:]
- font-list contains 2 hardcoded strings (Find Font, Cancel). 
- when clicking 'done' after an icon-pack search, a bogus item and a missing picture is shown for a split-second

2021-03-11
- improved font-loading
- improved styling on Windows
- improved colors on Windows
- immproved range-slider support on Windows

2021-03-09
- fixed missing control-highlights (SD-3572)
- fixed some missing strings
- renamed 'Search' strings (SD-4438)
- added support for styled range-controls for windows
- changed loading webfonts (now load dynamically on runtime - before they were compiled in)
- minor UI-adjustments

2021-03-08
- fixed enabled inspector-controls when there is nothing selected
- fixed file-selector to only show valid files
- improved font-loading (wip)
- restricted loading of fonts longer than 32 characters (because of a bug in Qt or Windows)
- added a small loading-indicator, if a webfont is loaded

2021-03-05
- changed localization to load dynamically
- removed calling `navigator` too early
- removed synchronous HTTP request
- removed description from info-dialogue
- fixed font-stylings
- added missing localization
- changed loading behaviour of external strings
- improved build-scripts

2021-03-04
- added support to read fonts provided by StreamDeck
- added support to use colors provided by StreamDeck
- changed build-script to provide a proper plugin-structure
- added better gif-support
- improved loading speed

2021-03-02
- improved loading of (individual) iconPacks
- fixed broken font-support
- refactored iconLibrary

2021-03-01
- refactored loading and internal structure

2021-02-26
- added ability to load icons from an icon-pack from inside a subfolder. Just ad the proper subfolder to the icon's `path` (e.g. `"path": "mysubfolder/icon.svg")`

2021-02-24
- refactored KC to work now inside SD as 'iconEditor' (signalling and application flow changed)

2021-02-23
- loading images/svgs from an arbitrary location on the user's disc now works again

2021-02-22
- prepared/adjusted some icon-packs to adapt changes made to names, etc...



2019-12-15
- added GIF - support. Right now base64-encoded (animated-) gifs are sent to the StreamDeck application.
- DontAutoSwitchWhenInstalled set to 'true', so after installation StreamDeck doesn't load an empty profile (which is the default)
- 
