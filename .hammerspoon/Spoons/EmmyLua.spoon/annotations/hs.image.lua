--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- A module for capturing and manipulating image objects from other modules for use with hs.drawing.
-- 
---@class hs.image
local M = {}
hs.image = M

-- Table of arrays containing the names of additional internal system images which may also be available for use with `hs.drawing.image` and [hs.image.imageFromName](#imageFromName).
--
-- Notes:
--  * The list of these images was pulled from a collection located in the repositories at https://github.com/hetima?tab=repositories.  As these image names are (for the most part) not formally listed in Apple's documentation or published APIs, their use cannot be guaranteed across all OS X versions.  If you identify any images which may be missing or could be added, please file an issue at https://github.com/Hammerspoon/hammerspoon.
---@type table
M.additionalImageNames = {}

-- Creates a new bitmap representation of the image and returns it as a new hs.image object
--
-- Parameters:
--  * `size` - an optional table specifying the height and width the image should be scaled to in the bitmap. The size is specified as table with `h` and `w` keys set. Defaults to the size of the source image object.
--  * `gray` - an optional boolean, default false, specifying whether or not the bitmap should be converted to grayscale (true) or left as RGB color (false).
--
-- Returns:
--  * a new hs.image object
--
-- Notes:
--  * a bitmap representation of an image is rendered at the specific size specified (or inherited) when it is generated -- if you later scale it to a different size, the bitmap will be scaled as larger or smaller pixels rather than smoothly.
--
--  * this method may be useful when preparing images for other devices (e.g. `hs.streamdeck`).
function M:bitmapRepresentation(size, gray, ...) end

-- Reads the color of the pixel at the specified location.
--
-- Parameters:
--  * `point` - a `hs.geometry.point`
--
-- Returns:
--  * A `hs.drawing.color` object
function M:colorAt(point, ...) end

-- Returns a copy of the image
--
-- Parameters:
--  * None
--
-- Returns:
--  * a new hs.image object
function M:copy() end

-- Returns a copy of the portion of the image specified by the rectangle specified.
--
-- Parameters:
--  * rectangle - a table with 'x', 'y', 'h', and 'w' keys specifying the portion of the image to return in the new image.
--
-- Returns:
--  * a copy of the portion of the image specified
function M:croppedCopy(rectangle, ...) end

-- Returns a bitmap representation of the image as a base64 encoded URL string
--
-- Parameters:
--  * scale - an optional boolean, default false, which indicates that the image size (which macOS represents as points) should be scaled to pixels.  For images that have Retina scale representations, this may result in an encoded image which is scaled down from the original source.
--  * type  - optional case-insensitive string parameter specifying the bitmap image type for the encoded string (default PNG)
--    * PNG  - save in Portable Network Graphics (PNG) format
--    * TIFF - save in Tagged Image File Format (TIFF) format
--    * BMP  - save in Windows bitmap image (BMP) format
--    * GIF  - save in Graphics Image Format (GIF) format
--    * JPEG - save in Joint Photographic Experts Group (JPEG) format
--
-- Returns:
--  * the bitmap image representation as a Base64 encoded string
--
-- Notes:
--  * You can convert the string back into an image object with [hs.image.imageFromURL](#URL), e.g. `hs.image.imageFromURL(string)`
---@return string
function M:encodeAsURLString(scale, type, ...) end

-- Gets the EXIF metadata information from an image file.
--
-- Parameters:
--  * path - The path to the image file.
--
-- Returns:
--  * A table of EXIF metadata, or `nil` if no metadata can be found or the file path is invalid.
function M.getExifFromPath(path, ...) end

-- Creates an `hs.image` object for the file or files specified
--
-- Parameters:
--  * file - the path to a file or an array of files to generate an icon for.
--
-- Returns:
--  * An `hs.image` object or nil, if there was an error.  The image will be the icon for the specified file or an icon representing multiple files if an array of multiple files is specified.
function M.iconForFile(file, ...) end

-- Creates an `hs.image` object of the icon for the specified file type.
--
-- Parameters:
--  * fileType - the file type, specified as a filename extension or a universal type identifier (UTI).
--
-- Returns:
--  * An `hs.image` object or nil, if there was an error
function M.iconForFileType(fileType, ...) end

-- Creates an `hs.image` object using the icon from an App
--
-- Parameters:
--  * bundleID - A string containing the bundle identifier of an application
--
-- Returns:
--  * An `hs.image` object or nil, if no app icon was found
function M.imageFromAppBundle(bundleID, ...) end

-- Creates an image from an ASCII representation with the specified context.
--
-- Parameters:
--  * ascii - A string containing a representation of an image
--  * context - An optional table containing the context for each shape in the image.  A shape is considered a single drawing element (point, ellipse, line, or polygon) as defined at https://github.com/cparnot/ASCIImage and http://cocoamine.net/blog/2015/03/20/replacing-photoshop-with-nsstring/.
--    * The context table is an optional (possibly sparse) array in which the index represents the order in which the shapes are defined.  The last (highest) numbered index in the sparse array specifies the default settings for any unspecified index and any settings which are not explicitly set in any other given index.
--    * Each index consists of a table which can contain one or more of the following keys:
--      * fillColor - the color with which the shape will be filled (defaults to black)  Color is defined in a table containing color component values between 0.0 and 1.0 for each of the keys:
--        * red (default 0.0)
--        * green (default 0.0)
--        * blue (default 0.0)
--        * alpha (default 1.0)
--      * strokeColor - the color with which the shape will be stroked (defaults to black)
--      * lineWidth - the line width (number) for the stroke of the shape (defaults to 1 if anti-aliasing is on or (√2)/2 if it is off -- approximately 0.7)
--      * shouldClose - a boolean indicating whether or not the shape should be closed (defaults to true)
--      * antialias - a boolean indicating whether or not the shape should be antialiased (defaults to true)
--
-- Returns:
--  * An `hs.image` object, or nil if an error occurred
--
-- Notes:
--  * To use the ASCII diagram image support, see https://github.com/cparnot/ASCIImage and http://cocoamine.net/blog/2015/03/20/replacing-photoshop-with-nsstring
--  * The default for lineWidth, when antialiasing is off, is defined within the ASCIImage library. Geometrically it represents one half of the hypotenuse of the unit right-triangle and is a more accurate representation of a "real" point size when dealing with arbitrary angles and lines than 1.0 would be.
function M.imageFromASCII(ascii, context, ...) end

-- Creates an `hs.image` object from a video file or the album artwork of an audio file or directory
--
-- Parameters:
--  * file - A string containing the path to an audio or video file or an album directory
--
-- Returns:
--  * An `hs.image` object
--
-- Notes:
--  * If a thumbnail can be generated for a video file, it is returned as an `hs.image` object, otherwise the filetype icon
--  * For audio files, this function first determines the containing directory (if not already a directory)
--  * It checks if any of the following common filenames for album art are present:
--   * cover.jpg
--   * front.jpg
--   * art.jpg
--   * album.jpg
--   * folder.jpg
--  * If one of the common album art filenames is found, it is returned as an `hs.image` object
--  * This is faster than extracting image metadata and allows for obtaining artwork associated with file formats such as .flac/.ogg
--  * If no common album art filenames are found, it attempts to extract image metadata from the file. This works for .mp3/.m4a files
--  * If embedded image metadata is found, it is returned as an `hs.image` object, otherwise the filetype icon
function M.imageFromMediaFile(file, ...) end

-- Returns the hs.image object for the specified name, if it exists.
--
-- Parameters:
--  * Name - the name of the image to return.
--
-- Returns:
--  * An hs.image object or nil, if no image was found with the specified name.
--
-- Notes:
--  * Some predefined labels corresponding to OS X System default images can be found in `hs.image.systemImageNames`.
--  * Names are not required to be unique: The search order is as follows, and the first match found is returned:
--     * an image whose name was explicitly set with the `setName` method since the last full restart of Hammerspoon
--     * Hammerspoon's main application bundle
--     * the Application Kit framework (this is where most of the images listed in `hs.image.systemImageNames` are located)
--  * Image names can be assigned by the image creator or by calling the `hs.image:setName` method on an hs.image object.
function M.imageFromName(string, ...) end

-- Loads an image file
--
-- Parameters:
--  * path - A string containing the path to an image file on disk
--
-- Returns:
--  * An `hs.image` object, or nil if an error occurred
function M.imageFromPath(path, ...) end

-- Creates an `hs.image` object from the contents of the specified URL.
--
-- Parameters:
--  * url - a web url specifying the location of the image to retrieve
--  * callbackFn - an optional callback function to be called when the image fetching is complete
--
-- Returns:
--  * An `hs.image` object or nil, if the url does not specify image contents or is unreachable, or if a callback function is supplied
--
-- Notes:
--  * If a callback function is supplied, this function will return nil immediately and the image will be fetched asynchronously
function M.imageFromURL(url, callbackFn, ...) end

-- Get or set the name of the image represented by the hs.image object.
--
-- Parameters:
--  * `name` - an optional string specifying the new name for the hs.image object.
--
-- Returns:
--  * if no argument is provided, returns the current name.  If a new name is specified, returns the hs.image object or nil if the name cannot be changed.
--
-- Notes:
--  * see also [hs.image:setName](#setName) for a variant that returns a boolean instead.
function M:name(name, ...) end

-- Save the hs.image object as an image of type `filetype` to the specified filename.
--
-- Parameters:
--  * filename - the path and name of the file to save.
--  * scale    - an optional boolean, default false, which indicates that the image size (which macOS represents as points) should be scaled to pixels.  For images that have Retina scale representations, this may result in a saved image which is scaled down from the original source.
--  * filetype - optional case-insensitive string parameter specifying the file type to save (default PNG)
--    * PNG  - save in Portable Network Graphics (PNG) format
--    * TIFF - save in Tagged Image File Format (TIFF) format
--    * BMP  - save in Windows bitmap image (BMP) format
--    * GIF  - save in Graphics Image Format (GIF) format
--    * JPEG - save in Joint Photographic Experts Group (JPEG) format
--
-- Returns:
--  * Status - a boolean value indicating success (true) or failure (false)
--
-- Notes:
--  * Saves image at the size in points (or pixels, if `scale` is true) as reported by [hs.image:size()](#size) for the image object
---@return boolean
function M:saveToFile(filename, scale, filetype, ...) end

-- Assigns the name assigned to the hs.image object.
--
-- Parameters:
--  * Name - the name to assign to the hs.image object.
--
-- Returns:
--  * Status - a boolean value indicating success (true) or failure (false) when assigning the specified name.
--
-- Notes:
--  * This method is included for backwards compatibility and is considered deprecated.  It is equivalent to `hs.image:name(name) and true or false`.
---@return boolean
function M:setName(Name, ...) end

-- Returns a copy of the image resized to the height and width specified in the size table.
--
-- Parameters:
--  * size     - a table with 'h' and 'w' keys specifying the size for the new image.
--  * absolute - an optional boolean specifying whether or not the copied image should be resized to the height and width specified (true), or whether the copied image should be scaled proportionally to fit within the height and width specified (false).  Defaults to false.
--
-- Returns:
--  * a copy of the image object at the new size
--
-- Notes:
--  * This method is included for backwards compatibility and is considered deprecated.  It is equivalent to `hs.image:copy():size(size, [absolute])`.
function M:setSize(size, absolute, ...) end

-- Get or set the size of the image represented by the hs.image object.
--
-- Parameters:
--  * `size`     - an optional table with 'h' and 'w' keys specifying the size for the image.
--  * `absolute` - when specifying a new size, an optional boolean, default false, specifying whether or not the image should be resized to the height and width specified (true), or whether the copied image should be scaled proportionally to fit within the height and width specified (false).
--
-- Returns:
--  * If arguments are provided, return the hs.image object; otherwise returns the current size
--
-- Notes:
--  * See also [hs.image:setSize](#setSize) for creating a copy of the image at a new size.
function M:size(size, absolute, ...) end

-- Table containing the names of internal system images for use with hs.drawing.image
--
-- Notes:
--  * Image names pulled from NSImage.h
--  * This table has a __tostring() metamethod which allows listing it's contents in the Hammerspoon console by typing `hs.image.systemImageNames`.
---@type table
M.systemImageNames = {}

-- Get or set whether the image is considered a template image.
--
-- Parameters:
--  * `state` - an optional boolean specifying whether or not the image should be a template.
--
-- Returns:
--  * if a parameter is provided, returns the hs.image object; otherwise returns the current value
--
-- Notes:
--  * Template images consist of black and clear colors (and an alpha channel). Template images are not intended to be used as standalone images and are usually mixed with other content to create the desired final appearance.
--  * Images with this flag set to true usually appear lighter than they would with this flag set to false.
function M:template(state, ...) end

-- Converts an image to an ASCII representation of the image in the form of a string.
--
-- Parameters:
--  * width - An optional width in pixels (defaults to image width if nothing supplied).
--  * height - An optional height in pixels (defaults to image height if nothing supplied).
--
-- Returns:
--  * A string.
---@return string
function M:toASCII(width, height, ...) end

