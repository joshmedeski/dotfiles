--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Retrieve information about the user's Language and Region settings.
--
-- Locales encapsulate information about linguistic, cultural, and technological conventions and standards. Examples of information encapsulated by a locale include the symbol used for the decimal separator in numbers and the way dates are formatted. Locales are typically used to provide, format, and interpret information about and according to the user’s customs and preferences.
---@class hs.host.locale
local M = {}
hs.host.locale = M

-- Returns an array table containing the identifiers for the locales available on the system.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an array table of strings specifying the locale identifiers recognized by this system.
--
-- Notes:
--  * these values can be used with [hs.host.locale.details](#details) to get details for a specific locale.
function M.availableLocales() end

-- Returns an string specifying the user's currently selected locale identifier.
--
-- Parameters:
--  * None
--
-- Returns:
--  * a string specifying the identifier of the user's currently selected locale.
--
-- Notes:
--  * this value can be used with [hs.host.locale.details](#details) to get details for the returned locale.
---@return string
function M.current() end

-- Returns a table containing information about the current or specified locale.
--
-- Parameters:
--  * `identifier` - an optional string, specifying the locale to display information about.  If you do not specify an identifier, information about the user's currently selected locale is returned.
--
-- Returns:
--  * a table containing one or more of the following key-value pairs:
--    * `alternateQuotationBeginDelimiterKey` - A string containing the alternating begin quotation symbol associated with the locale. In some locales, when quotations are nested, the quotation characters alternate.
--    * `alternateQuotationEndDelimiterKey`   - A string containing the alternate end quotation symbol associated with the locale. In some locales, when quotations are nested, the quotation characters alternate.
--    * `calendar`                            - A table containing key-value pairs describing for calendar associated with the locale. The table will contain one or more of the following pairs:
--      * `AMSymbol`                          - The AM symbol for time in the locale's calendar.
--      * `calendarIdentifier`                - A string representing the calendar identity.
--      * `eraSymbols`                        - An array table of strings specifying the names of the eras as recognized in the locale's calendar.
--      * `firstWeekday`                      - The index in `weekdaySymbols` of the first weekday in the locale's calendar.
--      * `longEraSymbols`                    - An array table of strings specifying long names of the eras as recognized in the locale's calendar.
--      * `minimumDaysInFirstWeek`            - The minimum number of days, an integer value, in the first week in the locale's calendar.
--      * `monthSymbols`                      - An array table of strings for the months of the year in the locale's calendar.
--      * `PMSymbol`                          - The PM symbol for time in the locale's calendar.
--      * `quarterSymbols`                    - An array table of strings for the quarters of the year in the locale's calendar.
--      * `shortMonthSymbols`                 - An array table of short strings for the months of the year in the locale's calendar.
--      * `shortQuarterSymbols`               - An array table of short strings for the quarters of the year in the locale's calendar.
--      * `shortStandaloneMonthSymbols`       - An array table of short standalone strings for the months of the year in the locale's calendar.
--      * `shortStandaloneQuarterSymbols`     - An array table of short standalone strings for the quarters of the year in the locale's calendar.
--      * `shortStandaloneWeekdaySymbols`     - An array table of short standalone strings for the days of the week in the locale's calendar.
--      * `shortWeekdaySymbols`               - An array table of short strings for the days of the week in the locale's calendar.
--      * `standaloneMonthSymbols`            - An array table of standalone strings for the months of the year in the locale's calendar.
--      * `standaloneQuarterSymbols`          - An array table of standalone strings for the quarters of the year in the locale's calendar.
--      * `standaloneWeekdaySymbols`          - An array table of standalone strings for the days of the week in the locale's calendar.
--      * `veryShortMonthSymbols`             - An array table of very short strings for the months of the year in the locale's calendar.
--      * `veryShortStandaloneMonthSymbols`   - An array table of very short standalone strings for the months of the year in the locale's calendar.
--      * `veryShortStandaloneWeekdaySymbols` - An array table of very short standalone strings for the days of the week in the locale's calendar.
--      * `veryShortWeekdaySymbols`           - An array table of very short strings for the days of the week in the locale's calendar.
--      * `weekdaySymbols`                    - An array table of strings for the days of the week in the locale's calendar.
--    * `collationIdentifier`                 - A string containing the collation associated with the locale.
--    * `collatorIdentifier`                  - A string containing the collation identifier for the locale.
--    * `countryCode`                         - A string containing the locale country code.
--    * `currencyCode`                        - A string containing the currency code associated with the locale.
--    * `currencySymbol`                      - A string containing the currency symbol associated with the locale.
--    * `decimalSeparator`                    - A string containing the decimal separator associated with the locale.
--    * `exemplarCharacterSet`                - An array table of strings which make up the exemplar character set for the locale.
--    * `groupingSeparator`                   - A string containing the numeric grouping separator associated with the locale.
--    * `identifier`                          - A string containing the locale identifier.
--    * `languageCode`                        - A string containing the locale language code.
--    * `measurementSystem`                   - A string containing the measurement system associated with the locale.
--    * `quotationBeginDelimiterKey`          - A string containing the begin quotation symbol associated with the locale.
--    * `quotationEndDelimiterKey`            - A string containing the end quotation symbol associated with the locale.
--    * `scriptCode`                          - A string containing the locale script code.
--    * `temperatureUnit`                     - A string containing the preferred measurement system for temperature.
--    * `timeFormatIs24Hour`                  - A boolean specifying whether time is expressed in a 24 hour format (true) or 12 hour format (false).
--    * `usesMetricSystem`                    - A boolean specifying whether or not the locale uses the metric system.
--    * `variantCode`                         - A string containing the locale variant code.
--
-- Notes:
--  * If you specify a locale identifier as an argument, it should be based on one of the strings returned by [hs.host.locale.availableLocales](#availableLocales). Use of an arbitrary string may produce unreliable or inconsistent results.
--
--  * Apple does not provide a documented method for retrieving the users preferences with respect to `temperatureUnit` or `timeFormatIs24Hour`. The methods used to determine these values are based on code from the following sources:
--    * `temperatureUnit`    - http://stackoverflow.com/a/41263725
--    * `timeFormatIs24Hour` - http://stackoverflow.com/a/1972487
--  * If you are able to identify additional locale or regional settings that are not provided by this function and have a source which describes a reliable method to retrieve this information, please submit an issue at https://github.com/Hammerspoon/hammerspoon with the details.
function M.details(identifier, ...) end

-- Returns the localized string for a specific language code.
--
-- Parameters:
--  * `localeCode` - The locale code for the locale you want to return the localized string of.
--  * `baseLocaleCode` - An optional string, specifying the locale to use for the string. If you do not specify a `baseLocaleCode`, the user's currently selected locale is used.
--
-- Returns:
--  * A string containing the localized string or `nil ` if either the `localeCode` or `baseLocaleCode` is invalid. For example, if the `localeCode` is "de_CH", this will return "German".
--  * A string containing the localized string including the dialect or `nil ` if either the `localeCode` or `baseLocaleCode` is invalid. For example, if the `localeCode` is "de_CH", this will return "German (Switzerland)".
--
-- Notes:
--  * The `localeCode` and optional `baseLocaleCode` must be one of the strings returned by [hs.host.locale.availableLocales](#availableLocales).
function M.localizedString(localeCode, baseLocaleCode, ...) end

-- Returns the user's language preference order as an array of strings.
--
-- Parameters:
--  * None
--
-- Returns:
--  * an array table of strings specifying the user's preferred languages as string identifiers.
function M.preferredLanguages() end

-- Registers a function to be invoked when anything in the user's locale settings change
--
-- Parameters:
--  * `fn` - the function to be invoked when a setting changes
--
-- Returns:
--  * a uuid string which can be used to unregister a callback function when you no longer require notification of changes
--
-- Notes:
--  * The callback function will not receive any arguments and should return none.  You can retrieve the new locale settings with [hs.host.locale.localeInformation](#localeInformation) and check its keys to determine if the change is of interest.
--
--  * Any change made within the Language and Region settings panel will trigger this callback, even changes which are not reflected in the locale information provided by [hs.host.locale.localeInformation](#localeInformation).
function M.registerCallback(fn, ...) end

-- Unregister a callback function when you no longer care about changes to the user's locale
--
-- Parameters:
--  * `uuidString` - the uuidString returned by [hs.host.locale.registerCallback](#registerCallback) when you registered the callback function
--
-- Returns:
--  * true if the callback was successfully unregistered or false if it was not, usually because the uuidString does not correspond to a current callback function.
---@return boolean
function M.unregisterCallback(uuidString, ...) end

