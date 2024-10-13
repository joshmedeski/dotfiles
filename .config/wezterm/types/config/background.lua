---@meta

---@alias HexColor string A color in the form "#RRGGBB" or "#RRGGBBAA" where the AA component is optional and defaults to "FF" if not specified.

---@class FileSource
---@field File string Load the specified image file. PNG, JPEG, GIF, BMP, ICO, TIFF, PNM, DDS, TGA and farbfeld files can be loaded. Animated GIF and PNG files will animate while the window has focus.

---@class FileSourceWithPath
---@field File {path: string, speed: number} Load the specified image file, which is an animated gif, and adjust the animation speed to x times its normal speed.

---@class GradientSource
---@field Gradient Gradient Generate a gradient

---@class ColorSource
---@field Color {Color: AnsiColor | HexColor} Generate an image with the specified color.

---@class BackgroundLayer
---@field source FileSource | FileSourceWithPath | GradientSource | ColorSource Defines the source of the layer texture data.
---@field attachment "Fixed" | "Scroll" | {Parallax: number} Controls whether the layer is fixed to the viewport or moves as it scrolls.
---@field repeat_x "Repeat" | "Mirror" | "NoRepeat" Controls whether the image is repeated in the x-direction.
---@field repeat_y "Repeat" | "Mirror" | "NoRepeat" Controls whether the image is repeated in the y-direction.
---@field repeat_x_size number | string Normally, when repeating, the image is tiled based on its width such that each copy of the image is immediately adjacent to the preceding instance. You may set `repeat_x_size` to a different value to increase or decrease the space between the repeated instances.
---@field repeat_y_size number | string Normally, when repeating, the image is tiled based on its width such that each copy of the image is immediately adjacent to the preceding instance. You may set `repeat_y_size` to a different value to increase or decrease the space between the repeated instances.
---@field vertical_align "Top" | "Middle" | "Bottom" Controls the initial vertical position of the layer, relative to the viewport.
---@field horizontal_align "Left" | "Center" | "Right" Controls the initial horizontal position of the layer, relative to the viewport.
---@field vertical_offset number | string Specify an offset from the initial vertical position.
---@field horizontal_offset number | string Specify an offset from the initial horizontal position.
---@field opacity number A  number in the range `0` through `1.0` inclusive that is multiplied with the alpha channel of the source to adjust the opacity of the layer. The default is `1.0` to use the source alpha channel as-is. Using a smaller value makes the layer less opaque/more transparent.
---@field hsb HsbTransform A  hue, saturation, brightness transformation that can be used to adjust those attributes of the layer.
---@field height "Cover" | "Contain" | number | string Controls the height of the image.
---@field width "Cover" | "Contain" | number | string Controls the width of the image.
