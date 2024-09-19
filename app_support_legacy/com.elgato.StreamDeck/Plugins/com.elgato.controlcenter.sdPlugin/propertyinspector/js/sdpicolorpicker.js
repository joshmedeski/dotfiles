const MDefaultColors = {
    backgroundColor: '#4E4E61',
    backgroundColor_light: '#C3C3EE', //Utils.fadeColor('#4E4E61', 60),
    warmColor: '#FFB165',
    mediumColor: '#FFF2EC',
    coolColor: '#94D0EC',
    warm: '#FFD580',
    cool: '#80D5FF',
    coolColorHue: 200,
    warmColorHue: 40,
    black: '#000000',
    white: '#EFEFEF',
    warn: '#E62727',
    hue: 213,
};

let MMouseDown = false;

function initColorPicker(selector, sDefaultSettings, _cb) {
    /**
     * color-picker-script expects:
     * --------
     * sdpi-item of type 'color-picker'
     *
     * <div class="sdpi-item" id="color-picker-item">
            <div class="sdpi-item-label">Color</div>
            <div class="sdpi-item-value" type="color-picker" id="any-id-youlike">
                <div class="color-picker spectrum">
                    <div class="color-spot"></div>
                </div>
               <input type="color" class="color-chip">
            </div>
        </div>

     * if a brightness-slider should get 'linked' to the color-picker
     * just add an additional slider:
     *
     * <div type="range" class="sdpi-item" id="colorbrightness" for="mycolorpicker">
            <div class="sdpi-item-label">Brightness</div>
            <div class="sdpi-item-value">
                <input class="floating-tooltip colorbrightness" data-suffix="%" type="range" min="0" max="100" value=100>
            </div>
        </div>

     *
     * color-picker-script needs:
     * -------
     * rgb2hex
     * hex2rgb
     * rgb2hsv
     * hsv2rgb
     * hsv2hex (Macro)
     * hex2hsv (Macro)
     * injectStyle
     *
     *  */

    Object.prototype.has = hasOwnProperty;

    // input: r,g,b in [0,1], out: h in [0,360) and s,v in [0,1]
    let rgb2hsv = (r, g, b) => {
        let v = Math.max(r, g, b),
            n = v - Math.min(r, g, b),
            h = n && (v == r ? (g - b) / n : v == g ? 2 + (b - r) / n : 4 + (r - g) / n);
        return [60 * (h < 0 ? h + 6 : h), v && n / v, v];
    };
    // r,g,b are in [0-255]
    let rgb2hsv2 = (r, g, b) => rgb2hsv(r / 255, g / 255, b / 255);

    // r,g,b are in JSON [0-255]
    let rgbjson2hsv = j => rgb2hsv(j.red / 255, j.green / 255, j.blue / 255);

    // input: h,s,v in: h in [0,360) and s,v in [0,1]
    let hsv2rgb = (h, s, v, f = (n, k = (n + h / 60) % 6) => v - v * s * Math.max(Math.min(k, 4 - k, 1), 0)) => [
        f(5),
        f(3),
        f(1),
    ];

    //let hsv2rgbjson = (h,s,v, f= (n,k=(n+h/60)%6) => v - v*s*Math.max( Math.min(k,4-k,1), 0)) => {return {red:Math.round(f(5)*255),green:Math.round(f(3)*255),blue:Math.round(f(1)*255)}};

    // r,g,b are in [0-1]
    let rgb2hex = (r, g, b) =>
        '#' +
        [r, g, b]
            .map(x =>
                Math.round(x * 255)
                    .toString(16)
                    .padStart(2, 0)
            )
            .join('');

    // r,g,b are in [0-255]
    let rgb2hex2 = (r, g, b) =>
        '#' +
        [r, g, b]
            .map(x =>
                Math.round(x)
                    .toString(16)
                    .padStart(2, 0)
            )
            .join('');

    // input hex with or without leading '#', out: rgb in [0,255]
    let hex2rgb = hex => {
        const a = parseInt(hex.replace('#', ''), 16),
            r = (a >> 16) & 255,
            g = (a >> 8) & 255,
            b = a & 255;
        return [r, g, b];
    };

    let hsv2hex = (h, s, v) => rgb2hex(...hsv2rgb(h, s, v));
    let hex2hsv = hex => rgb2hsv(...hex2rgb(hex));

    let rgb2json = (r, g, b) => {
        return {
            red: Math.round(r * 255),
            green: Math.round(g * 255),
            blue: Math.round(b * 255),
        };
    };
    let hsv2rgbjson = (h, s, v) => rgb2json(...hsv2rgb(h, s, v));

    /**
     *   To return fractional values set `returnFractionalValues`
     * to TRUE:
     *   hue: 1 -360
     *   saturation:  0.00 - 1.00
     *   brightness:  0.00 - 1.00
     *
     * to FALSE:
     *   hue: 1 -360
     *   saturation:  0 - 100
     *   brightness:  0 - 100
     */
    const returnFractionalValues = false;

    let defaultSettings = sDefaultSettings || '#061261';

    // find our color-picker
    selector = selector || '[type=color-picker]';
    const colorPickers = document.querySelectorAll(selector);

    Object.values(colorPickers).map(colorPicker => {
        // -> Must be inside the sdpi-item type='color-picker' to adjust properly
        const spectrum = colorPicker.querySelector('.spectrum');
        // spot on the spectrum
        const colorSpot = colorPicker.querySelector('.color-spot');
        const chip = colorPicker.querySelector('.color-chip');

        // see if there is a brightness-slider for our color-picker
        // and if, create a style for it's thumb, as this is not accessible from
        // javascript but from css
        let stylId;
        let thumbStyle;
        let curColor;
        let displayColorMode = 'color';
        let outputColorMode = displayColorMode;
        let saturatedAtTop = true;
        let coldLeft = true;

        const colorbrightness = document.querySelector(`[type="range"][for="${colorPicker.id}"] .colorbrightness`);
        if(colorbrightness) {
            stylId = `stylefor_${colorPicker.id}`;
            thumbStyle = document.querySelector(`#${stylId}`);
            if(!thumbStyle) {
                thumbStyle = Utils.injectStyle('', stylId);
                colorbrightness.dataset.styleid = stylId;
            }
        }

        const colorModeSwitchColor = colorPicker.querySelector('.color-mode-switch .spektrum');
        if(colorModeSwitchColor) {
            colorModeSwitchColor.onclick = function() {
                colorPicker.setColorMode('color');
            };
        }
        const colorModeSwitchWhite = colorPicker.querySelector('.color-mode-switch .white');
        if(colorModeSwitchWhite) {
            colorModeSwitchWhite.onclick = function() {
                colorPicker.setColorMode('temperature');
            };
        }

        colorPicker.setCssStyles = function(which) {
            const arr = [['block', 'crosshair', 'none'], ['none', 'move', 'none'], ['block', 'crosshair', 'block']][
                which
            ];
            spectrum.style.cursor = arr[1];
        };

        colorPicker.setColorMode = function(mode) {
            displayColorMode = mode;
            if(mode == 'temperature') {
                if(spectrum.classList.contains('color')) {
                    spectrum.classList.remove('color');
                }
                spectrum.classList.add('white');
            } else {
                if(spectrum.classList.contains('white')) {
                    spectrum.classList.remove('white');
                }
                spectrum.classList.add('color');
            }
        };

        colorPicker.setColorModeForElement = function(mode, el, newClass) {
            displayColorMode = mode;
            const newColor = mode == 'temperature' ? 'white' : 'color';
            if(el.classList.contains('temperature')) el.classList.remove('temperature');
            if(el.classList.contains('color')) el.classList.remove('color');
            if(el.classList.contains('white')) el.classList.remove('white');
            outputColorMode = newClass || newColor;
            el.classList.add(outputColorMode);
        };

        colorPicker.setColor = (hue, saturation, brightness, mode) => {
            // console.log("setColor:h, s, b, k, m:", hue, saturation, brightness, mode);
            // console.trace("__SETCOLOR:", MMouseDown);
            outputColorMode = mode;
            if(colorbrightness) colorbrightness.value = brightness * 100;
            curColor = {hue, saturation, brightness};
            colorPicker.setColorMode(mode);
            colorPicker.adjustColorSpot(MMouseDown);
        };

        colorPicker.adjustColor = hexClr => {
            // console.log('adjustColor:', hexClr, curColor);
            if(hexClr) {
                // convert hex to rgb to hsv (because we need this to apply the correct brightness)
                const hsv = rgb2hsv(...hex2rgb(hexClr));
                curColor.hue = hsv[0];
                curColor.saturation = hsv[1];
                curColor.brightness = colorbrightness ? parseInt(colorbrightness.value) / 100 : 1;
            }
            if(!hexClr) {
                hexClr = hsv2hex(curColor.hue, curColor.saturation, curColor.brightness);
            }
            if(hexClr && chip) chip.value = hexClr;

            colorPicker.adjustColorElements();
        };

        colorPicker.adjustColorElements = callCallback => {
            const bri = colorbrightness ? colorbrightness.value / 100 : curColor.brightness;
            let hex = hsv2hex(curColor.hue, curColor.saturation, bri);
            const immediateUpdate = callCallback || MMouseDown;

            if(immediateUpdate && _cb) {
                let lights = {
                    hue: returnFractionalValues ? curColor.hue : Math.round(curColor.hue),
                    saturation: returnFractionalValues ? curColor.saturation : Math.round(curColor.saturation * 100),
                    brightness: returnFractionalValues ? curColor.brightness : Math.round(curColor.brightness * 100),
                };

                _cb({
                    id: colorPicker.id,
                    mode: outputColorMode,
                    lights,
                });
            }

            // we calculated the color INCLUDING brightness, so re-calculate the base-color from hue/saturation
            let baseColor_hx = hsv2hex(curColor.hue, curColor.saturation, 1);

            if(chip) chip.value = baseColor_hx;
            if(thumbStyle) {
                thumbStyle.innerHTML = `
                    input[type="range"][data-styleId="${stylId}"]::-webkit-slider-thumb {background-color: ${hex};}
                    input[type="range"][data-styleId="${stylId}"]::-webkit-slider-runnable-track {background-color: ${baseColor_hx};}
                `;
            }
        };

        colorPicker.adjustColorSpot = function(callCallback) {
            const bounds = spectrum.getBoundingClientRect();
            if(displayColorMode == 'temperature') {
                let posX;

                if(curColor.hue >= 38 && curColor.hue <= 42) {
                    posX = bounds.width / 2 + (bounds.width / 2) * (curColor.saturation * 2);
                } else if(curColor.hue >= 198 && curColor.hue <= 202) {
                    posX = (bounds.width / 2) * (1 - curColor.saturation * 2);
                }
                colorSpot.style.left = `${posX}px`;
                colorSpot.style.top = `0`;
            } else {
                const x = Math.round((curColor.hue * bounds.width) / 360);
                const y = Math.round(bounds.height * curColor.saturation);
                colorSpot.style.left = `${Math.min(100, (x / bounds.width) * 100)}%`;
                if(saturatedAtTop) {
                    colorSpot.style.top = `${Math.min(100, (1 - y / bounds.height) * 100)}%`;
                } else {
                    colorSpot.style.top = `${Math.min(100, (y / bounds.height) * 100)}%`;
                }
            }
            colorPicker.adjustColorElements(callCallback);
        };

        colorPicker.colorChanged = function(clr) {
            return curColor.hue != clr.hue || Math.round(curColor.saturation * 100) != Math.round(clr.saturation * 100);
        };

        colorPicker.throttledUpdate = Utils.throttle(function() {
            // console.log("cp:throttledUpdate");
            colorPicker.adjustColorSpot(true);
        }, 10);

        colorPicker.mouseMoved = function(event) {
            const newColor = colorPicker.getColorAtMousePosition(event);
            if(colorPicker.colorChanged(newColor)) {
                curColor = newColor;
                colorPicker.throttledUpdate();
            }
        };

        colorPicker.getColorAtMousePosition = function(event) {
            /** GENERAL */
            const bounds = spectrum.getBoundingClientRect();
            const x = Math.min(bounds.width, Math.max(0, event.clientX - bounds.left));
            const y = Math.min(bounds.height, Math.max(0, event.clientY - bounds.top));

            /** COMMON */
            let hue, saturation, brightness;

            if(displayColorMode == 'temperature') {
                let prcnt = x / (bounds.width / 2);

                if(prcnt < 1) {
                    hue = MDefaultColors.coolColorHue;
                    saturation = 0.5 - 0.5 * prcnt;
                } else {
                    hue = MDefaultColors.warmColorHue;
                    saturation = 0.5 * Math.abs(1 - prcnt);
                }

            } else {
                hue = Math.max(1, Math.round((x / bounds.width) * 360));
                if(saturatedAtTop) {
                    saturation = 1 - y / bounds.height;
                } else {
                    saturation = y / bounds.height;
                }
            }

            brightness = curColor.has('brightness') ? Number(curColor.brightness) : 1;

            const retVal = {
                hue,
                saturation,
                brightness,
            };
            return retVal;
        };

        // make available elements interactive
        if(colorbrightness) {
            colorbrightness.oninput = function() {
                curColor.brightness = this.value / 100;
                colorPicker.adjustColorElements(true);
            };
        }

        if(chip) {
            chip.onchange = function() {
                // console.log("chip:onchange");
                const hsv = rgb2hsv(...hex2rgb(this.value));
                curColor.hue = Math.max(1, hsv[0]);
                curColor.saturation = hsv[1];
                colorPicker.setColorMode('color');
                colorPicker.setColorModeForElement(displayColorMode, colorPicker, displayColorMode);
                colorPicker.adjustColor(this.value);
                colorPicker.adjustColorSpot(true);
            };
        }

        spectrum.onmousedown = function(event) {
            // console.log("spectrum:onmousedown");
            event.preventDefault();
            // colorPicker.setCssStyles(1);
            MMouseDown = true;
            curColor = colorPicker.getColorAtMousePosition(event);
            colorPicker.setColorModeForElement(displayColorMode, colorPicker, displayColorMode);
            colorPicker.adjustColorSpot(true);
            document.addEventListener('mousemove', colorPicker.mouseMoved);
        };

        // spectrum.onmouseenter = function(event) {
        //     event.preventDefault();
        //     const clr = colorPicker.getColorAtMousePosition(event);
        //     if (loupe) {
        //         loupe.style.backgroundColor = hsv2hex(clr.hue,clr.saturation,clr.brightness);
        //         loupe.style.display = 'block';
        //     }
        // }

        spectrum.onmouseout = function(event) {
            event.preventDefault();
            // colorPicker.setCssStyles(0);
        };

        spectrum.onmouseup = function(event) {
            // console.log('mouse  UP => SPEKTRUM');
            MMouseDown = false;
            // colorPicker.setCssStyles(2);
            // curColor = colorPicker.getColorAtMousePosition(event);
            // colorPicker.throttledUpdate();
        };

        document.addEventListener('mouseup', function(event) {
            // console.log('mouse  UP => OUTSIDE');
            document.removeEventListener('mousemove', colorPicker.mouseMoved);
            MMouseDown = false;
        });

        /* Initialize */

        if(typeof defaultSettings === 'object') {
            let clrMode = Utils.isTemperature(defaultSettings.hue, defaultSettings.saturation) ? 'temperature' : 'color';
            colorPicker.setColorModeForElement(clrMode, colorPicker, clrMode);
            colorPicker.setColor(
                defaultSettings.has('hue') ? defaultSettings.hue : 120,
                defaultSettings.has('saturation') ? defaultSettings.saturation : 0.5,
                defaultSettings.has('brightness') ? defaultSettings.brightness : 1,
                clrMode
            );
        } else {
            colorPicker.adjustColor(defaultSettings);
        }
    });
}