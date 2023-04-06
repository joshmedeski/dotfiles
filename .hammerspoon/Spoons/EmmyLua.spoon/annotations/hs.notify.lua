--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module allows you to create on screen notifications in the User Notification Center located at the right of the users screen.
--
-- Notifications can be sent immediately or scheduled for delivery at a later time, even if that scheduled time occurs when Hammerspoon is not currently running. Currently, if you take action on a notification while Hammerspoon is not running, the callback function is not honored for the first notification clicked upon -- This is expected to be fixed in a future release.
--
-- When setting up a callback function, you have the option of specifying it with the creation of the notification (hs.notify.new) or by pre-registering it with hs.notify.register and then referring it to by the tag name specified with hs.notify.register. If you use this registration method for defining your callback functions, and make sure to register all expected callback functions within your init.lua file or files it includes, then callback functions will remain available for existing notifications in the User Notification Center even if Hammerspoon's configuration is reloaded or if Hammerspoon is restarted. If the callback tag is not present when the user acts on the notification, the Hammerspoon console will be raised as a default action.
--
-- A shorthand, based upon the original inspiration for this module from Hydra and Mjolnir, hs.notify.show, is provided if you just require a quick and simple informative notification without the bells and whistles.
--
-- This module is based in part on code from the previous incarnation of Mjolnir by [Steven Degutis](https://github.com/sdegutis/).
---@class hs.notify
local M = {}
hs.notify = M

-- Get or set the label of a notification's action button
--
-- Parameters:
--  * buttonTitle - An optional string containing the title for the notification's action button.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if buttonTitle is present; otherwise the current setting.
--
-- Notes:
--  * The affects of this method only apply if the user has set Hammerspoon notifications to `Alert` in the Notification Center pane of System Preferences
--  * This value is ignored if [hs.notify:hasReplyButton](#hasReplyButton) is true.
function M:actionButtonTitle(buttonTitle, ...) end

-- Returns how the notification was activated by the user.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the integer value corresponding to how the notification was activated by the user.  See the table `hs.notify.activationTypes[]` for more information.
---@return number
function M:activationType() end

-- Convenience array of the possible activation types for a notification, and their reverse for reference.
-- * None                    - The user has not interacted with the notification.
-- * ContentsClicked         - User clicked on notification
-- * ActionButtonClicked     - User clicked on Action button
-- * Replied                 - User used Reply button
-- * AdditionalActionClicked - Additional Action selected
--
-- Notes:
--  * Count starts at zero. (implemented in Objective-C)
---@type table
M.activationTypes = {}

-- Returns the date and time when a notification was delivered
--
-- Parameters:
--  * None
--
-- Returns:
--  * A number containing the delivery date/time of the notification, in seconds since the epoch (i.e. 1970-01-01 00:00:00 +0000)
--
-- Notes:
--  * You can turn epoch times into a human readable string or a table of date elements with the `os.date()` function.
---@return number
function M:actualDeliveryDate() end

-- Get or set additional actions which will be displayed for an alert type notification when the user clicks and holds down the action button of the alert.
--
-- Parameters:
--  * an optional table containing an array of strings specifying the additional options to list for the user to select from the notification.
--
-- Returns:
--  * The notification object, if an argument is present; otherwise the current value
--
-- Notes:
--  * The additional items will be listed in a pop-up menu when the user clicks and holds down the mouse button in the action button of the alert.
--  * If the user selects one of the additional actions, [hs.notify:activationType](#activationType) will equal `hs.notify.activationTypes.additionalActionClicked`
--  * See also [hs.notify:additionalActivationAction](#additionalActivationAction)
function M:additionalActions(actionsTable, ...) end

-- Return the additional action that the user selected from an alert type notification that has additional actions available.
--
-- Parameters:
--  * None
--
-- Returns:
--  * If the notification has additional actions assigned with [hs.notify:additionalActions](#additionalActions) and the user selects one, returns a string containing the selected action; otherwise returns nil.
--
-- Notes:
--  * If the user selects one of the additional actions, [hs.notify:activationType](#activationType) will equal `hs.notify.activationTypes.additionalActionClicked`
--  * See also [hs.notify:additionalActions](#additionalActions)
function M:additionalActivationAction() end

-- Get or set whether a notification should be presented even if this overrides Notification Center's decision process.
--
-- Parameters:
--  * alwaysPresent - An optional boolean parameter indicating whether the notification should override Notification Center's decision about whether to present the notification or not. Defaults to true.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if alwaysPresent is provided; otherwise the current setting.
--
-- Notes:
--  * This does not affect the return value of `hs.notify:presented()` -- that will still reflect the decision of the Notification Center
--  * Examples of why the users Notification Center would choose not to display a notification would be if Hammerspoon is the currently focussed application, being attached to a projector, or the user having set Do Not Disturb.
--
--  * if the notification was not created by this module, this method will return nil
function M:alwaysPresent(alwaysPresent, ...) end

-- Get or set whether an alert notification should always show an alternate action menu.
--
-- Parameters:
--  * state - An optional boolean, default false, indicating whether the notification should always show an alternate action menu.
--
-- Returns:
--  * The notification object, if an argument is present; otherwise the current value.
--
-- Notes:
--  * This method has no effect unless the user has set Hammerspoon notifications to `Alert` in the Notification Center pane of System Preferences.
--  * [hs.notify:additionalActions](#additionalActions) must also be used for this method to have any effect.
--  * **WARNING:** This method uses a private API. It could break at any time. Please file an issue if it does.
function M:alwaysShowAdditionalActions(state, ...) end

-- Get or set whether a notification should automatically withdraw once activated
--
-- Parameters:
--  * shouldWithdraw - An optional boolean indicating whether the notification should automatically withdraw. Defaults to true.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if shouldWithdraw is present; otherwise the current setting.
--
-- Notes:
--  * This method has no effect if the user has set Hammerspoon notifications to `Alert` in the Notification Center pane of System Preferences: clicking on either the action or other button will clear the notification automatically.
--  * If a notification which was created before your last reload (or restart) of Hammerspoon and is clicked upon before hs.notify has been loaded into memory, this setting will not be honored because the initial application delegate is not aware of this option and is set to automatically withdraw all notifications which are acted upon.
--
--  * if the notification was not created by this module, this method will return nil
function M:autoWithdraw(shouldWithdraw, ...) end

-- Get or set a notification's content image.
--
-- Parameters:
--  * image - An optional hs.image parameter containing the image to display. Defaults to nil. If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if image is provided; otherwise the current setting.
--
-- Notes:
--  * See hs.image for details on how to specify or define an image
--  * This method is only supported in OS X 10.9 or greater. A warning will be displayed in the console and the method will be treated as a no-op if used on an unsupported system.
function M:contentImage(image, ...) end

-- The string representation of the default notification sound. Use `hs.notify:soundName()` or set the `soundName` attribute in `hs:notify.new()`, to this constant, if you want to use the default sound
M.defaultNotificationSound = nil

-- Returns whether the notification has been delivered to the Notification Center
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating whether the notification has been delivered to the users Notification Center
---@return boolean
function M:delivered() end

-- Returns a table containing notifications which have been delivered.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the notification userdata objects for all Hammerspoon notifications currently in the notification center
--
-- Notes:
--  * Only notifications which have been presented but not cleared, either by the user clicking on the [hs.notify:otherButtonTitle](#otherButtonTitle) or through auto-withdrawal (see [hs.notify:autoWithdraw](#autoWithdraw) for more details), will be in the array returned.
--
--  * You can use this function along with [hs.notify:getFunctionTag](#getFunctionTag) to re=register necessary callback functions with [hs.notify.register](#register) when Hammerspoon is restarted.
--
--  * Since notifications which the user has closed (or cancelled) do not trigger a callback, you can check this table with a timer to see if the user has cleared a notification, e.g.
-- ~~~lua
-- myNotification = hs.notify.new():send()
-- clearCheck = hs.timer.doEvery(10, function()
--     if not hs.fnutils.contains(hs.notify.deliveredNotifications(), myNotification) then
--         if myNotification:activationType() == hs.notify.activationTypes.none then
--             print("You dismissed me!")
--         else
--             print("A regular action occurred, so callback (if any) was invoked")
--         end
--         clearCheck:stop() -- either way, no need to keep polling
--         clearCheck = nil
--     end
-- end)
-- ~~~
function M.deliveredNotifications() end

-- Return the name of the function tag the notification will call when activated.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The function tag for this notification as a string.
--
-- Notes:
--  * This tag should correspond to a function in [hs.notify.registry](#registry) and can be used to either add a replacement with `hs.notify.register(...)` or remove it with `hs.notify.unregister(...)`
--
--  * if the notification was not created by this module, this method will return nil
function M:getFunctionTag() end

-- Get or set the presence of an action button in a notification
--
-- Parameters:
--  * hasButton - An optional boolean indicating whether an action button should be present.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if hasButton is present; otherwise the current setting.
--
-- Notes:
--  * The affects of this method only apply if the user has set Hammerspoon notifications to `Alert` in the Notification Center pane of System Preferences
function M:hasActionButton(hasButton, ...) end

-- Get or set whether an alert notification has a "Reply" button for additional user input.
--
-- Parameters:
--  * state - An optional boolean, default false, indicating whether the notification should include a reply button for additional user input.
--
-- Returns:
--  * The notification object, if an argument is present; otherwise the current value
--
-- Notes:
--  * This method has no effect unless the user has set Hammerspoon notifications to `Alert` in the Notification Center pane of System Preferences.
--  * [hs.notify:hasActionButton](#hasActionButton) must also be true or the "Reply" button will not be displayed.
--  * If this is set to true, the action button will be "Reply" even if you have set another one with [hs.notify:actionButtonTitle](#actionButtonTitle).
function M:hasReplyButton(state, ...) end

-- Get or set the informative text of a notification
--
-- Parameters:
--  * informativeText - An optional string containing the informative text to be set on the notification object. This can be an empty string. If `nil` is passed, any existing informative text will be removed.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if informativeText is present; otherwise the current setting.
function M:informativeText(informativeText, ...) end

-- Creates a new notification object
--
-- Parameters:
--  * fn - An optional function or function-tag, which will be called when the user interacts with notifications. The notification object will be passed as an argument to the function. If you leave this parameter out or specify nil, then no callback will be attached to the notification.
--  * attributes - An optional table for applying attributes to the notification.
--   * Possible keys are:
--    * alwaysPresent   - see [hs.notify:alwaysPresent](#alwaysPresent)
--    * autoWithdraw    - see [hs.notify:autoWithdraw](#autoWithdraw)
--    * contentImage    - see [hs.notify:contentImage](#contentImage)
--    * informativeText - see [hs.notify:informativeText](#informativeText)
--    * soundName       - see [hs.notify:soundName](#soundName)
--    * subTitle        - see [hs.notify:subTitle](#subTitle)
--    * title           - see [hs.notify:title](#title)
--    * setIdImage      - see [hs.notify:setIdImage](#setIdImage) -- note the border will automatically be set to false if assigned as an attribute in this table.
--   * The following can also be set, but will only have an apparent effect on the notification when the user has set Hammerspoon's notification style to "Alert" in the Notification Center panel of System Preferences:
--    * actionButtonTitle           - see [hs.notify:actionButtonTitle](#actionButtonTitle)
--    * hasActionButton             - see [hs.notify:hasActionButton](#hasActionButton)
--    * otherButtonTitle            - see [hs.notify:otherButtonTitle](#otherButtonTitle)
--    * additionalActions           - see [hs.notify:additionalActions](#additionalActions)
--    * hasReplyButton              - see [hs.notify:hasReplyButton](#hasReplyButton)
--    * responsePlaceholder         - see [hs.notify:responsePlaceholder](#responsePlaceholder)
--    * alwaysShowAdditionalActions - see [hs.notify:alwaysShowAdditionalActions](#alwaysShowAdditionalActions)
--    * withdrawAfter               - see [hs.notify:withdrawAfter](#withdrawAfter)
--
-- Returns:
--  * A notification object
--
-- Notes:
--  * A function-tag is a string key which corresponds to a function stored in the [hs.notify.registry](#registry) table with the `hs.notify.register()` function.
--  * If a notification does not have a `title` attribute set, OS X will not display it, so by default it will be set to "Notification". You can use the `title` key in the attributes table, or call `hs.notify:title()` before displaying the notification to change this.
function M.new(fn, attributes, ...) end

-- Get or set the label of a notification's other button
--
-- Parameters:
--  * buttonTitle - An optional string containing the title for the notification's other button.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if buttonTitle is present; otherwise the current setting.
--
-- Notes:
--  * The affects of this method only apply if the user has set Hammerspoon notifications to `Alert` in the Notification Center pane of System Preferences
--  * Due to OSX limitations, it is NOT possible to get a callback for this button.
function M:otherButtonTitle(buttonTitle, ...) end

-- Returns whether the users Notification Center decided to display the notification
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean indicating whether the users Notification Center decided to display the notification
--
-- Notes:
--  * Examples of why the users Notification Center would choose not to display a notification would be if Hammerspoon is the currently focussed application, being attached to a projector, or the user having set Do Not Disturb.
---@return boolean
function M:presented() end

-- Registers a function callback with the specified tag for a notification. The callback function will be invoked when the user clicks on or interacts with a notification.
--
-- Parameters:
--  * tag - a string tag to identify the registered callback function. Use this as the function tag in [hs.notify.new](#new) and [hs.notify.show](#show)
--  * fn  - the function which should be invoked when a notification with this tag is interacted with.
--
-- Returns:
--  * a numerical id representing the entry in [hs.notify.registry](#registry) for this function. This number can be used with [hs.notify.unregister](#unregister) to unregister a function later if you wish.
--
-- Notes:
--  * If a function is already registered with the specified tag, it is replaced by with the new one.
function M.register(tag, fn, ...) end

-- A table containing the registered callback functions and their tags.
--
-- Notes:
--  * This table should not be modified directly. Use the `hs.notify.register(tag, fn)` and `hs.notify.unregister(id)` functions.
--  * This table has a __tostring metamethod so you can see the list of registered function tags in the console by typing `hs.notify.registry`
--  * See [hs.notify.warnAboutMissingFunctionTag](#warnAboutMissingFunctionTag) for determining the behavior when a notification attempts to perform a callback to a function tag which is not present in this table. This occurrence is most common with notifications which are acted upon by the user after Hammerspoon has been reloaded.
---@type table
M.registry = {}

-- Get the users input from an alert type notification with a reply button.
--
-- Parameters:
--  * None
--
-- Returns:
--  * If the notification has a reply button and the user clicks on it, returns a string containing the user input (may be an empty string); otherwise returns nil.
--
-- Notes:
--  * [hs.notify:activationType](#activationType) will equal `hs.notify.activationTypes.replied` if the user clicked on the Reply button and then clicks on Send.
--  * See also [hs.notify:hasReplyButton](#hasReplyButton)
function M:response() end

-- Set a placeholder string for alert type notifications with a reply button.
--
-- Parameters:
--  * `string` - an optional string specifying placeholder text to display in the reply box before the user has types anything in an alert type notification with a reply button.
--
-- Returns:
--  * The notification object, if an argument is present; otherwise the current value
--
-- Notes:
--  * In macOS 10.13, this text appears so light that it is almost unreadable; so far no workaround has been found.
--  * See also [hs.notify:hasReplyButton](#hasReplyButton)
function M:responsePlaceholder(string, ...) end

-- Schedules a notification for delivery in the future.
--
-- Parameters:
--  * date - the date the notification should be delivered to the users Notification Center specified as the number of seconds since 1970-01-01 00:00:00Z or as a string in rfc3339 format: "YYYY-MM-DD[T]HH:MM:SS[Z]".
--
-- Returns:
--  * The notification object
--
-- Notes:
--  * See also hs.notify:send()
--  * hs.settings.dateFormat specifies a lua format string which can be used with `os.date()` to properly present the date and time as a string for use with this method.
---@return hs.notify
function M:schedule(date, ...) end

-- Returns a table containing notifications which are scheduled but have not yet been delivered.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a table containing the notification userdata objects for all Hammerspoon notifications currently scheduled to be delivered.
--
-- Notes:
--  * Once a notification has been delivered, it is moved to [hs.notify.deliveredNotifications](#deliveredNotifications) or removed, depending upon the users action.
--
--  * You can use this function along with [hs.notify:getFunctionTag](#getFunctionTag) to re=register necessary callback functions with [hs.notify.register](#register) when Hammerspoon is restarted.
function M.scheduledNotifications() end

-- Delivers the notification immediately to the users Notification Center.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The notification object
--
-- Notes:
--  * See also hs.notify:schedule()
--  * If a notification has been modified, then this will resend it.
--  * You can invoke this multiple times if you wish to repeat the same notification.
---@return hs.notify
function M:send() end

-- Set a notification's identification image (replace the Hammerspoon icon with a custom image)
--
-- Parameters:
--  * image - An `hs.image` object, a string containing an image path, or a string defining an ASCIImage
--  * withBorder - An optional boolean to give the notification image a border. Defaults to `false`
--
-- Returns:
--  * The notification object
--
-- Notes:
--  * See hs.image for details on how to specify or define an image
--  * **WARNING**: This method uses a private API. It could break at any time. Please file an issue if it does
---@return hs.notify
function M:setIdImage(image, withBorder, ...) end

-- Shorthand constructor to create and show simple notifications
--
-- Parameters:
--  * title       - the title for the notification
--  * subTitle    - the subtitle, or second line, of the notification
--  * information - the main textual body of the notification
--  * tag         - a function tag corresponding to a function registered with [hs.notify.register](#register)
--
-- Returns:
--  * a notification object
--
-- Notes:
--  * All three textual parameters are required, though they can be empty strings
--  * This function is really a shorthand for `hs.notify.new(...):send()`
--  * Notifications created using this function will inherit the default `withdrawAfter` value, which is 5 seconds. To produce persistent notifications you should use `hs.notify.new()` with a `withdrawAfter` attribute of 0.
function M.show(title, subTitle, information, tag, ...) end

-- Get or set the sound for a notification
--
-- Parameters:
--  * soundName - An optional string containing the name of a sound to play with the notification. If `nil`, no sound will be played. Defaults to `nil`.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if soundName is present; otherwise the current setting.
--
-- Notes:
--  * Sounds will first be matched against the names of system sounds. If no matches can be found, they will then be searched for in the following paths, in order:
--   * `~/Library/Sounds`
--   * `/Library/Sounds`
--   * `/Network/Sounds`
--   * `/System/Library/Sounds`
function M:soundName(soundName, ...) end

-- Get or set the subtitle of a notification
--
-- Parameters:
--  * subtitleText - An optional string containing the subtitle to be set on the notification object. This can be an empty string. If `nil` is passed, any existing subtitle will be removed.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if subtitleText is present; otherwise the current setting.
function M:subTitle(subtitleText, ...) end

-- Get or set the title of a notification
--
-- Parameters:
--  * titleText - An optional string containing the title to be set on the notification object.  The default value is "Notification".  If `nil` is passed, then the title is set to the empty string.  If no parameter is provided, then the current setting is returned.
--
-- Returns:
--  * The notification object, if titleText is present; otherwise the current setting.
function M:title(titleText, ...) end

-- Unregisters a function callback so that it is no longer available as a callback when notifications corresponding to the specified entry are interacted with.
--
-- Parameters:
--  * id - the numerical id provided by [hs.notify.register](#register)
--  * tag - a string tag representing the callback function to be removed
--
-- Returns:
--  * None
function M.unregister(id_or_tag, ...) end

-- Unregisters all functions registered as callbacks.
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This does not remove the notifications from the User Notification Center, it just removes their callback function for when the user interacts with them. To remove all notifications, see [hs.notify.withdrawAll](#withdrawAll) and [hs.notify.withdrawAllScheduled](#withdrawAllScheduled)
function M.unregisterall() end

-- A value indicating whether or not a missing notification function tag should cause a warning.  Defaults to `true`.
--
-- If this variable is set to a function, the function will be called with two parameters `tag`, which will match the tag specified if you used [hs.notify.show](#show) or a UUID if you used [hs.notify.new](#new) to define the notification, and `notification` which will be the notificationObject representing the notification.  No return value is expected.
--
-- If this variable is not set to a function, it will be evaluated as a lua boolean (i.e. any value except `false` and `nil` is considered true).  If it evaluates to true, a warning will be displayed to the console indicating that the callback function is missing; if it is false, the notification will be silently discarded.
M.warnAboutMissingFunctionTag = nil

-- Withdraws a delivered notification from the Notification Center.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The notification object
--  * This method allows you to unlock a dispatched notification so that it can be modified and resent.
--  * if the notification was not created by this module, it will still be withdrawn if possible
---@return hs.notify
function M:withdraw() end

-- Get or set the number of seconds after which to automatically withdraw a notification
--
-- Parameters:
--  * seconds - An optional number, default 5, of seconds after which to withdraw a notification. A value of 0 will not withdraw a notification automatically
--
-- Returns:
--  * The notification object, if an argument is present; otherwise the current value.
--
-- Notes:
--  * While this setting applies to both Banner and Alert styles of notifications, it is functionally meaningless for Banner styles
--  * A value of 0 will disable auto-withdrawal
--
--  * if the notification was not created by this module, this method will return nil
function M:withdrawAfter(seconds, ...) end

-- Withdraw all delivered notifications from Hammerspoon
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
--
-- Notes:
--  * This will withdraw all notifications for Hammerspoon, including those not sent by this module or that linger from a previous load of Hammerspoon.
function M.withdrawAll() end

-- Withdraw all scheduled notifications from Hammerspoon
--
-- Parameters:
--  * None
--
-- Returns:
--  * None
function M.withdrawAllScheduled() end

