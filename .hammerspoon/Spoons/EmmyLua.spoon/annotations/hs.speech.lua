--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- This module provides access to the Speech Synthesizer component of OS X.
--
-- The speech synthesizer functions and methods provide access to OS X's Text-To-Speech capabilities and facilitates generating speech output both to the currently active audio device and to an AIFF file.
--
-- A discussion concerning the embedding of commands into the text to be spoken can be found at https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/SpeechSynthesisProgrammingGuide/FineTuning/FineTuning.html#//apple_ref/doc/uid/TP40004365-CH5-SW6.  It is somewhat dated and specific to the older MacinTalk style voices, but still contains some information relevant to the more modern higher quality voices as well in its discussion about embedded commands.
---@class hs.speech
local M = {}
hs.speech = M

-- Returns a table containing a variety of properties describing and defining the specified voice.
--
-- Parameters:
--  * voice - the name of the voice to look up attributes for
--
-- Returns:
--  * a table containing key-value pairs which describe the voice specified.  These attributes may include (but is not limited to) information about specific characters recognized, sample text, gender, etc.
--
-- Notes:
--  * All of the names that have been encountered thus far follow this pattern for their full name:  `com.apple.speech.synthesis.voice.*name*`.  You can provide this suffix or not as you prefer when specifying a voice name.
function M.attributesForVoice(voice, ...) end

-- Returns a list of the currently installed voices for speech synthesis.
--
-- Parameters:
--  * full - an optional boolean flag indicating whether or not the full internal names should be returned, or if the shorter versions should be returned.  Defaults to false.
--
-- Returns:
--  * an array of the available voice names.
--
-- Notes:
--  * All of the names that have been encountered thus far follow this pattern for their full name:  `com.apple.speech.synthesis.voice.*name*`.  This prefix is normally suppressed unless you pass in true.
function M.availableVoices(full, ...) end

-- Resumes a paused speech synthesizer.
--
-- Parameters:
--  * None
--
-- Returns:
--  * the synthesizer object
function M:continue() end

-- Returns the name of the currently selected default voice for the user.  This voice is the voice selected in the System Preferences for Dictation & Speech as the System Voice.
--
-- Parameters:
--  * full - an optional boolean flag indicating whether or not the full internal name should be returned, or if the shorter version should be returned.  Defaults to false.
--
-- Returns:
--  * the name of the system voice.
--
-- Notes:
--  * All of the names that have been encountered thus far follow this pattern for their full name:  `com.apple.speech.synthesis.voice.*name*`.  This prefix is normally suppressed unless you pass in true.
---@return string
function M.defaultVoice(full, ...) end

-- Returns whether or not the system is currently using a speech synthesizer in any application to generate speech.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a boolean value indicating whether or not any application is currently generating speech with a synthesizer.
--
-- Notes:
--  * See also `hs.speech:speaking`.
---@return boolean
function M.isAnyApplicationSpeaking() end

-- Returns whether or not the synthesizer is currently paused.
--
-- Parameters:
--  * None
--
-- Returns:
--  * True or false indicating whether or not the synthesizer is currently paused.  If there is an error, returns nil.
--
-- Notes:
--  * If an error occurs retrieving this value, the details will be logged in the system logs which can be viewed with the Console application.  You can also have such messages logged to the Hammerspoon console by setting the module's log level to at least Information (This can be done with the following, or similar, command: `hs.speech.log.level = 3`.  See `hs.logger` for more information)
function M:isPaused() end

-- Returns whether or not the synthesizer is currently speaking, either to an audio device or to a file.
--
-- Parameters:
--  * None
--
-- Returns:
--  * True or false indicating whether or not the synthesizer is currently producing speech.  If there is an error, returns nil.
--
-- Notes:
--  * If an error occurs retrieving this value, the details will be logged in the system logs which can be viewed with the Console application.  You can also have such messages logged to the Hammerspoon console by setting the module's log level to at least Information (This can be done with the following, or similar, command: `hs.speech.log.level = 3`.  See `hs.logger` for more information)
function M:isSpeaking() end

-- Gets or sets the pitch modulation for the synthesizer's voice.
--
-- Parameters:
--  * modulation - an optional number indicating the pitch modulation for the synthesizer.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the synthesizer object.  Returns nil if an error occurs.
--
-- Notes:
--  * Pitch modulation is expressed as a floating-point value in the range of 0.000 to 127.000. These values correspond to MIDI note values, where 60.000 is equal to middle C on a piano scale. The most useful speech pitches fall in the range of 40.000 to 55.000. A pitch modulation value of 0.000 corresponds to a monotone in which all speech is generated at the frequency corresponding to the speech pitch. Given a speech pitch value of 46.000, a pitch modulation of 2.000 would mean that the widest possible range of pitches corresponding to the actual frequency of generated text would be 44.000 to 48.000.
--
--  * If an error occurs retrieving or setting this value, the details will be logged in the system logs which can be viewed with the Console application.  You can also have such messages logged to the Hammerspoon console by setting the module's log level to at least Information (This can be done with the following, or similar, command: `hs.speech.log.level = 3`.  See `hs.logger` for more information)
function M:modulation(modulation, ...) end

-- Creates a new speech synthesizer object for use by Hammerspoon.
--
-- Parameters:
--  * voice - an optional string specifying the voice the synthesizer should use for generating speech.  Defaults to the system voice.
--
-- Returns:
--  * a speech synthesizer object or nil, if the system was unable to create a new synthesizer.
--
-- Notes:
--  * All of the names that have been encountered thus far follow this pattern for their full name:  `com.apple.speech.synthesis.voice.*name*`.  You can provide this suffix or not as you prefer when specifying a voice name.
--  * You can change the voice later with the `hs.speech:voice` method.
function M.new(voice, ...) end

-- Pauses the output of the speech synthesizer.
--
-- Parameters:
--  * where - an optional string indicating when to pause the audio output (defaults to "immediate").  The string can be one of the following:
--    * "immediate" - pauses output immediately.  If in the middle of a word, when speech is resumed, the word will be repeated.
--    * "word"      - pauses at the end of the current word.
--    * "sentence"  - pauses at the end of the current sentence.
--
-- Returns:
--  * the synthesizer object
function M:pause(where, ...) end

-- Returns the phonemes which would be spoken if the text were to be synthesized.
--
-- Parameters:
--  * text - the text to tokenize into phonemes.
--
-- Returns:
--  * the text converted into the series of phonemes the synthesizer would use for the provided text if it were to be synthesized.
--
-- Notes:
--  * This method only returns a phonetic representation of the text if a Macintalk voice has been selected.  The more modern higher quality voices do not use a phonetic representation and an empty string will be returned if this method is used.
--  * You can modify the phonetic representation and feed it into `hs.speech:speak` if you find that the default interpretation is not correct.  You will need to set the input mode to Phonetic by prefixing the text with "[[inpt PHON]]".
--  * The specific phonetic symbols recognized by a given voice can be queried by examining the array returned by `hs.speech:phoneticSymbols` after setting an appropriate voice.
---@return string
function M:phonemes(text, ...) end

-- Returns an array of the phonetic symbols recognized by the synthesizer for the current voice.
--
-- Parameters:
--  * None
--
-- Returns:
--  * For MacinTalk voices, this method will return an array of the recognized symbols for the currently selected voice.  For the modern higher quality voices, or if an error occurs, returns nil.
--
-- Notes:
--  * Each entry in the array of phonemes returned will contain the following keys:
--    * Symbol      - The textual representation of this phoneme when returned by `hs.speech:phonemes` or that you should use for this sound when crafting a phonetic string yourself.
--    * Opcode      - The numeric opcode passed to the callback for the "willSpeakPhoneme" message corresponding to this phoneme.
--    * Example     - An example word which contains the sound the phoneme represents
--    * HiliteEnd   - The character position in the Example where this phoneme's sound begins
--    * HiliteStart - The character position in the Example where this phoneme's sound ends
--
--  * Only the older, MacinTalk style voices support phonetic text.  The more modern, higher quality voices are not rendered phonetically and will return nil for this method.
--
--  * If an error occurs retrieving this value, the details will be logged in the system logs which can be viewed with the Console application.  You can also have such messages logged to the Hammerspoon console by setting the module's log level to at least Information (This can be done with the following, or similar, command: `hs.speech.log.level = 3`.  See `hs.logger` for more information)
function M:phoneticSymbols() end

-- Gets or sets the base pitch for the synthesizer's voice.
--
-- Parameters:
--  * pitch - an optional number indicating the pitch base for the synthesizer.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the synthesizer object.  Returns nil if an error occurs.
--
-- Notes:
--  * Typical voice frequencies range from around 90 hertz for a low-pitched male voice to perhaps 300 hertz for a high-pitched child’s voice. These frequencies correspond to approximate pitch values in the ranges of 30.000 to 40.000 and 55.000 to 65.000, respectively.
--
--  * If an error occurs retrieving or setting this value, the details will be logged in the system logs which can be viewed with the Console application.  You can also have such messages logged to the Hammerspoon console by setting the module's log level to at least Information (This can be done with the following, or similar, command: `hs.speech.log.level = 3`.  See `hs.logger` for more information)
function M:pitch(pitch, ...) end

-- Gets or sets the synthesizers speaking rate (words per minute).
--
-- Parameters:
--  * rate - an optional number indicating the speaking rate for the synthesizer.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the synthesizer object.
--
-- Notes:
--  * The range of supported rates is not predefined by the Speech Synthesis framework; but the synthesizer may only respond to a limited range of speech rates. Average human speech occurs at a rate of 180.0 to 220.0 words per minute.
function M:rate(rate, ...) end

-- Reset a synthesizer back to its default state.
--
-- Parameters:
--  * None
--
-- Returns:
--  * Returns the synthesizer object.  Returns nil if an error occurs.
--
-- Notes:
--  * This method will reset a synthesizer to its default state, including pitch, modulation, volume, rate, etc.
--  * The changes go into effect immediately, if queried, but will not affect a synthesis in progress.
--
--  * If an error occurs retrieving or setting this value, the details will be logged in the system logs which can be viewed with the Console application.  You can also have such messages logged to the Hammerspoon console by setting the module's log level to at least Information (This can be done with the following, or similar, command: `hs.speech.log.level = 3`.  See `hs.logger` for more information)
function M:reset() end

-- Sets or removes a callback function for the synthesizer.
--
-- Parameters:
--  * fn - a function to set as the callback for this speech synthesizer.  If the value provided is nil, any currently existing callback function is removed.
--
-- Returns:
--  * the synthesizer object
--
-- Notes:
--  * The callback function should expect between 3 and 5 arguments and should not return anything.  The first two arguments will always be the synthesizer object itself and a string indicating the activity which has caused the callback.  The value of this string also dictates the remaining arguments as follows:
--
--    * "willSpeakWord"     - Sent just before a synthesized word is spoken through the sound output device.
--      * provides 3 additional arguments: startIndex, endIndex, and the full text being spoken.
--      * startIndex and endIndex can be used as `string.sub(text, startIndex, endIndex)` to get the specific word being spoken.
--
--    * "willSpeakPhoneme"  - Sent just before a synthesized phoneme is spoken through the sound output device.
--      * provides 1 additional argument: the opcode of the phoneme about to be spoken.
--      * this callback message will only occur when using Macintalk voices; modern higher quality voices are not phonetically based and will not generate this message.
--      * the opcode can be tied to a specific phoneme by looking it up in the table returned by `hs.speech:phoneticSymbols`.
--
--    * "didEncounterError" - Sent when the speech synthesizer encounters an error in text being synthesized.
--      * provides 3 additional arguments: the index in the original text where the error occurred, the text being spoken, and an error message.
--      * *Special Note:* I have never been able to trigger this callback message, even with malformed embedded command sequences, so... looking for validation of the code or fixes.  File an issue if you have suggestions.
--
--    * "didEncounterSync"  - Sent when the speech synthesizer encounters an embedded synchronization command.
--      * provides 1 additional argument: the synchronization number provided in the text.
--      * A synchronization number can be embedded in text to be spoken by including `[[sync #]]` in the text where you wish the callback to occur.  The number is limited to 32 bits and can be presented as a base 10 or base 16 number (prefix with 0x).
--
--    * "didFinish"         - Sent when the speech synthesizer finishes speaking through the sound output device.
--      * provides 1 additional argument: a boolean flag indicating whether or not the synthesizer finished because synthesis is complete (true) or was stopped early with `hs.speech:stop` (false).
function M:setCallback(fn) end

-- Starts speaking the provided text through the system's current audio device.
--
-- Parameters:
--  * textToSpeak - the text to speak with the synthesizer.
--
-- Returns:
--  * the synthesizer object
function M:speak(textToSpeak, ...) end

-- Returns whether or not this synthesizer is currently generating speech.
--
-- Parameters:
--  * None
--
-- Returns:
--  * A boolean value indicating whether or not this synthesizer is currently generating speech.
--
-- Notes:
--  * See also `hs.speech.isAnyApplicationSpeaking`.
---@return boolean
function M:speaking() end

-- Starts speaking the provided text and saves the audio as an AIFF file.
--
-- Parameters:
--  * textToSpeak - the text to speak with the synthesizer.
--  * destination - the path to the file to create and store the audio data in.
--
-- Returns:
--  * the synthesizer object
function M:speakToFile(textToSpeak, destination, ...) end

-- Stops the output of the speech synthesizer.
--
-- Parameters:
--  * where - an optional string indicating when to stop the audio output (defaults to "immediate").  The string can be one of the following:
--    * "immediate" - stops output immediately.
--    * "word"      - stops at the end of the current word.
--    * "sentence"  - stops at the end of the current sentence.
--
-- Returns:
--  * the synthesizer object
function M:stop(where, ...) end

-- Gets or sets whether or not the synthesizer uses the speech feedback window.
--
-- Parameters:
--  * flag - an optional boolean indicating whether or not the synthesizer should user the speech feedback window or not.  Defaults to false.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the synthesizer object.
--
-- Notes:
--  * *Special Note:* I am not sure where the visual feedback actually occurs -- I have not been able to locate a feedback window for synthesis in 10.11; however the method is defined and not marked deprecated, so I include it in the module.  If anyone has more information, please file an issue and the documentation will be updated.
function M:usesFeedbackWindow(flag, ...) end

-- Gets or sets the active voice for a synthesizer.
--
-- Parameters:
--  * full  - an optional boolean indicating whether or not you wish the full internal voice name to be returned, or if you want the shorter version.  Defaults to false.
--  * voice - an optional string indicating the name of the voice to change the synthesizer to.
--
-- Returns:
--  * If no parameter is provided (or the parameter is a boolean value), returns the current value; otherwise returns the synthesizer object or nil if the voice could not be changed for some reason.
--
-- Notes:
--  * All of the names that have been encountered thus far follow this pattern for their full name:  `com.apple.speech.synthesis.voice.*name*`.  You can provide this suffix or not as you prefer when specifying a voice name.
--  * The voice cannot be changed while the synthesizer is currently producing output.
--  * If you change the voice while a synthesizer is paused, the current synthesis will be terminated and the voice will be changed.
function M:voice(full_or_voice, ...) end

-- Gets or sets the synthesizers speaking volume.
--
-- Parameters:
--  * volume - an optional number between 0.0 and 1.0 indicating the speaking volume for the synthesizer.
--
-- Returns:
--  * If no parameter is provided, returns the current value; otherwise returns the synthesizer object.
--
-- Notes:
--  * Volume units lie on a scale that is linear with amplitude or voltage. A doubling of perceived loudness corresponds to a doubling of the volume.
function M:volume(volume, ...) end

