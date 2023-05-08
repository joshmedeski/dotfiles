/* global Utils, ControlCenterKey */
/** Class to hold common data for Key Lights */

/**
     *  53 = Elgato Key Light
     *  54 = Eve Light Strip.
     *  57 = Elgato Light Strip (old firmware)
     *  70 = Elgato Light Strip (new firmware)
     * 200 = Elgato Key Light Air
     * 201 = Elgato Ring Light
 */

/**
 * On/Off: all (53, 54, 57, 70, 200, 201)
 * Brightness: all (53, 54, 57, 70, 200, 201)
 * Temperature: Key Light, Ring Light (53, 200, 201)
 * Set Color: Light Strip only (54, 57, 70)
*/

const ControlCenterKeyLight = function(jsn, options, clr) {

    if(!options.hasOwnProperty('allowedDeviceTypes')) {
        options.allowedDeviceTypes = [DEVICETYPES.KEYLIGHT, DEVICETYPES.LIGHTSTRIP_EVE, DEVICETYPES.LIGHTSTRIP_OLD, DEVICETYPES.LIGHTSTRIP, DEVICETYPES.KEYLIGHTAIR, DEVICETYPES.RINGLIGHT, DEVICETYPES.KEYLIGHTMINI];
    }

    ControlCenterKey.call(this, jsn, options, clr);
    this.showStatesArr = ['Device State', 'Desired State'];
    this.showValuesArr = ['Value', 'Step'];

    this.listeners.push(
        this.cc.on('deviceRemoved', device => {
            // console.log('CCKL::deviceRemoved', device.deviceID, this.settings.deviceID);
            if(device.deviceID == this.settings.deviceID) {
                this.updateKey();
            }
        })
    );

    this.listeners.push(
        this.cc.on('deviceConfigurationChanged', device => {
            // console.log('CCKL::deviceConfigurationChanged', this.settings.type, this.type, device.deviceID, this.cc.devices, device);
            if(device.deviceID == this.settings.deviceID) {
                if(device.name) this.settings.name = device.name;
                if(device.type) {
                    if(this.settings.type != device.type) {
                        this.settings.type = device.type;
                        this.setSettings();
                    }
                }
                if(this.updateTitle) this.updateTitle(null, device);
                this.updateKey(device, false);
            }
            if(this.isAllDevices(this.settings)) {
                this.updateKeyAndDevices(false);
            }
        })
    );
};

ControlCenterKeyLight.prototype = Object.create(ControlCenterKey.prototype);
ControlCenterKeyLight.prototype.constructor = ControlCenterKeyLight;

ControlCenterKeyLight.prototype.getValue = function(device) {
    return typeof this.options.value === 'function'
        ? this.options.value(this, device)
        : Number(this.utils.getProperty(this.settings, this.options.property));
};

ControlCenterKeyLight.prototype.getSceneElements = function(inDevice) {
    let device = inDevice || this.findDeviceById(this.settings['deviceID']);
    if(!device) {
        // console.warn('No device found for deviceID', this.settings['deviceID']);
        return [];
    }
    let sceneElements = [];
    if(device.lights?.hasOwnProperty('sceneId')) { // light has a color-scene set
        const favoritePropertyArray = device.favoriteScenes || [];  // try to get all favoriteScenes
        sceneElements = favoritePropertyArray?.find(s => s.id === device.lights.sceneId)?.sceneElements ?? [];
        if(sceneElements.length === 0) {
            console.info('No sceneElement found in device.favoriteScenes', device?.deviceID, device?.name, device, device.favoriteScenes)
        }
    } else {
        console.warn('No sceneId found for device', device?.deviceID, device?.name, device);
    }
    return sceneElements;
};



/**
 * Icon consists of:
 * -- Background (red if unavailable, grey = default, light if active/current)
 * -- Device (default = black background for Key Light)
 * -- Colored forground: various color, depending on type of action (e.g. bluish for cold colors, yellow(is) for warm, black for default)
 * -- Icon or Text
 */

ControlCenterKeyLight.prototype.compileSVGString = function(
    bgColor,
    title,
    showIcon,
    base,
    deviceAvailable,
    sameValue,
    overrideColor = null,
    context
) {
    const icons = {
        cold: '',
        warm: '',
        dark: '',
        light: '',
        verydark: '',
        verylight: '',
        lightest: '',
        darkest: '',
        onoff: '',
        off: '',
    };
    let options = MGradients.hasOwnProperty(base) ? MGradients[base] : MGradients.red;

    const isConnected = ($CC && $CC.isConnected());
    const isLightStrip = this.isLightStrip(deviceAvailable);
    const fontSize = CONFIG.fontSize ? Utils.minmax(CONFIG.fontSize, 12, 48) : 24;
    const fontY = 81; //82.5;
    const isAllDevices = this.isAllDevices(this.settings);

    if(!isConnected || !deviceAvailable) {
        title = '~';
        options = MGradients.black;
        options.backgroundColor = '#800000';
        // options.textOrIcon = `<text fill="${isLightStrip ? '#FFFFFF' : options.fontColor}" font-family="Arial-BoldMT, Arial" font-size="${fontSize}" font-weight="bold"><tspan x="50%" y="${fontY}" text-anchor="middle">${String(
        //     title
        // )}</tspan></text>`;
        options.textOrIcon = `<path transform="translate(57,57)" fill="${options.fontColor}" d="M15.6052445,0.1025641 C18.7681606,0.1025641 21.810981,1.04290219 24.4031454,2.81975182 C26.9358564,4.55648665 28.8740343,6.9692738 30.0095926,9.7961873 C30.1546587,10.1584004 30.2878341,10.531232 30.4055516,10.9052435 L27.6492961,12.4897781 C27.5541708,12.1145867 27.4400205,11.7405752 27.3092232,11.3760025 C25.5529724,6.4642993 20.8490265,3.16426715 15.6052445,3.16426715 C8.7574121,3.16426715 3.18663693,8.6930303 3.18663693,15.4877694 C3.18663693,22.2825085 8.7574121,27.8100918 15.6052445,27.8100918 C18.2651856,27.8100918 20.803842,26.9830191 22.9453502,25.4197217 C25.0440521,23.8871004 26.5827038,21.7869727 27.396025,19.3470491 L27.4055376,19.2927761 L12.3555265,10.7483239 L12.3555265,20.0124828 L17.5434224,17.0451675 L20.2152542,18.5612709 L12.4375721,23.0081144 L9.6872619,21.453076 L9.6872619,9.3254284 L12.4328158,7.755052 L17.9203564,10.8674884 L17.9536502,10.8922652 L30.8585859,18.221475 C30.2248136,21.7197214 28.3674921,24.9171069 25.6207492,27.2284272 C22.8288217,29.5775027 19.2711356,30.8717949 15.6052445,30.8717949 C11.4637268,30.8717949 7.5707241,29.2719223 4.64205397,26.3659591 C1.71338389,23.4599958 0.1010101,19.5959968 0.1010101,15.4877694 C0.1010101,11.3783622 1.71338389,7.5143632 4.64205397,4.60839992 C7.5707241,1.70243668 11.4637268,0.1025641 15.6052445,0.1025641 Z"/>
        `;
    } else {
        let fcolor = options.fontColor;
        if(deviceAvailable) {
            options.backgroundColor = sameValue ? MDefaultColors.backgroundColor_light : MDefaultColors.backgroundColor;
        } else {
            options.backgroundColor = '#800000'; //deviceAvailable ? "#4E4E61" : "#800000"; //"#B30000"; //MDefaultColors.backgroundColor; // red
        }
        if(deviceAvailable && (deviceAvailable.type == DEVICETYPES.RINGLIGHT)) {
            fcolor = sameValue ? '#444444' : '#D8D8D8';
        }

        if(showIcon && icons.hasOwnProperty(base)) {
            if(isAllDevices) {
                options.textOrIcon = getIcon(base, options.fontColor);
            } else {
                options.textOrIcon = getIcon(base, fcolor);
            }

        } else {
            options.textOrIcon = `<text fill="${isLightStrip ? '#FFFFFF' : fcolor}" font-family="Arial-BoldMT, Arial" font-size="${fontSize}" font-weight="bold"><tspan x="50%" y="${fontY}" text-anchor="middle">${String(title)}</tspan></text>`;
        }

        // 2021-12-20 patch colors:
        if(overrideColor) {
            const oldOptions = options;
            options = {...options};  // clone options to not overwrite constants
            options.startColor = overrideColor.startColor;
            options.stopColor = overrideColor.startColor;
            options.blendColor = overrideColor.blendColor;
        }
    }

    if(this.type == 'LightsOnOff' && isAllDevices) {
        return icon_multipleDevices(options, deviceAvailable, context);
    }

    if(!this.isAllDevices(this.settings) && isLightStrip) {
        const sceneElements = this.getSceneElements(deviceAvailable);
        const colorObj = sceneElements.length ? {lights: sceneElements[0]} : deviceAvailable?.lights;
        const lights = {
            hue: Number(this.utils.getProp(colorObj, 'lights.hue', MDefaultColors.hue)),
            sat: Number(this.utils.getProp(colorObj, 'lights.saturation', 100) / 100),
            bri: Number(this.utils.getProp(colorObj, 'lights.brightness', 100) / 100)
        };
     
        if(this.type == 'ColorPicker') {
            const settings = {
                hue: parseInt(this.utils.getProp(this.settings, 'lights.hue', MDefaultColors.hue)),
                sat: this.utils.getProp(this.settings, 'lights.saturation', 100) / 100,
                bri: this.utils.getProp(this.settings, 'lights.brightness', 100) / 100
            };
            // const isTemperature = this.utils.isTemperature(settings.hue, settings.sat) ? 'temperature' : 'color';
            //check if current values are equal to settings values and adjust background-color accordingly
            if(isConnected && deviceAvailable) {
                options.backgroundColor =
                    Object.keys(lights)
                        .every(p => lights[p] == settings[p])
                        ? MDefaultColors.backgroundColor_light
                        : MDefaultColors.backgroundColor;
            }

            options.color = hsv2hex(settings.hue, settings.sat, 1);
            options.overlay = `
                <mask id="mask_overlay" fill="#fff">
                    <use xlink:href="#mask_rect" />
                </mask>
                <rect id="mask_rect" width="${parseInt(settings.bri * 80)}" height="64" x="0" y="0" />
                <path transform="translate(30,46)" filter="url(#b_2g-a)" fill="#333"    fill-rule="nonzero" d="M26,52 C11.6405965,52 0,40.3594035 0,26 C0,11.6405965 11.6405965,0 26,0 L26,0 L54,0 C68.3594035,0 80,11.6405965 80,26 C80,40.3594035 68.3594035,52 54,52 L54,52 Z"/>
                <path transform="translate(30,46)" fill="${hsv2hex(0, 0, settings.bri)}" fill-rule="nonzero" d="M26,52 C11.6405965,52 0,40.3594035 0,26 C0,11.6405965 11.6405965,0 26,0 L26,0 L54,0 C68.3594035,0 80,11.6405965 80,26 C80,40.3594035 68.3594035,52 54,52 L54,52 Z" />;
                <path mask="url(#mask_overlay)" transform="translate(30,46)" fill="${options.color}" fill-rule="nonzero" d="M26,52 C11.6405965,52 0,40.3594035 0,26 C0,11.6405965 11.6405965,0 26,0 L26,0 L54,0 C68.3594035,0 80,11.6405965 80,26 C80,40.3594035 68.3594035,52 54,52 L54,52 Z" />;
                `;
        } else {
            options.overlay = `<g transform="translate(32 46)">
            <path filter="url(#b_2g-a)" fill="#333333" fill-rule="nonzero" d="M26,52 C11.6405965,52 0,40.3594035 0,26 C0,11.6405965 11.6405965,0 26,0 L26,0 L54,0 C68.3594035,0 80,11.6405965 80,26 C80,40.3594035 68.3594035,52 54,52 L54,52 Z"/>
            <path fill="${showIcon ? options.stopColor : "#333333"}" d="M26,52 C11.6405965,52 0,40.3594035 0,26 C0,11.6405965 11.6405965,0 26,0 L26,0 L54,0 C68.3594035,0 80,11.6405965 80,26 C80,40.3594035 68.3594035,52 54,52 L54,52 Z"/>
            </g>${options.textOrIcon}`;
            options.color = hsv2hex(lights.hue, lights.sat, 1); // LEDs
        }

        return this.createLightStripSVG(options);
    }

    if(this.type === 'Battery') {
        options.showBatteryLevelLabel = this.showBatteryLevelLabel;
    };

    return this.type === 'Battery' ? this.createBatterySVG(options, deviceAvailable) : this.createKeyLightSVG(options, deviceAvailable, this);
};

function getIcon(key, clr) {
    const iconColor = clr || '#FFF';

    switch(key) {
        case 'onoff':
            return `<g id="icon_onoff" transform="translate(10 27)" fill="${iconColor}" fill-rule="nonzero">
            <path d="M51.0699051,30.6973221 L53.930648,33.558065 C50.3428114,36.0929929 48,40.2729 48,45 C48,52.7319865 54.2680135,59 62,59 C69.7319865,59 76,52.7319865 76,45 C76,40.594581 73.9651978,36.6644155 70.7841705,34.0980805 L73.6251955,31.2570554 C77.5245575,34.558851 80,39.4903402 80,45 C80,54.9411255 71.9411255,63 62,63 C52.0588745,63 44,54.9411255 44,45 C44,39.1696735 46.7719732,33.9867761 51.0699051,30.6973221 L51.0699051,30.6973221 Z M60,27 L64,27 L64,45 L60,45 L60,27 Z" id="Shape"></path>
            </g>`;
            break;
        case 'off':
            return `<g id="icon_onoff" transform="translate(10 27)" fill="${iconColor}" fill-rule="nonzero">
            <path d="M51.0699051,30.6973221 L53.930648,33.558065 C50.3428114,36.0929929 48,40.2729 48,45 C48,52.7319865 54.2680135,59 62,59 C69.7319865,59 76,52.7319865 76,45 C76,40.594581 73.9651978,36.6644155 70.7841705,34.0980805 L73.6251955,31.2570554 C77.5245575,34.558851 80,39.4903402 80,45 C80,54.9411255 71.9411255,63 62,63 C52.0588745,63 44,54.9411255 44,45 C44,39.1696735 46.7719732,33.9867761 51.0699051,30.6973221 L51.0699051,30.6973221 Z M60,27 L64,27 L64,45 L60,45 L60,27 Z" id="Shape"></path>
            </g>`;
            break;
        case 'cold':
            return `<g id="icon_ct_cooler" fill="${iconColor}" transform="translate(42 42)">
            <path d="M37.2013708 34.8718552C36.1664204 32.9591548 34.7279162 31.2967897 33 29.9989014L33 29.2351401 34.6041402 29.2351401 38.4466142 25.392666C38.3300822 25.1812991 38.2259248 24.9621528 38.1351186 24.7362036L33 24.7362036 33 20.881736 37.9253107 20.881736C38.0033089 20.6026013 38.1009866 20.3316805 38.2167538 20.0705635L34.3475612 16.2013708 33 16.2013708 33 13.0359666 33.9844838 13.0359666 34.0359666 8.75736075 37.2013708 8.75736075 37.2013708 13.6041402 40.8295797 17.232349C41.1624176 17.0503079 41.5143996 16.8988935 41.881736 16.7818958L41.881736 11.6654694 38.4545455 8.23827882 40.6928243 6 43.7182555 9.02543118 46.7436866 6 48.9819655 8.23827882 45.7362036 11.4840407 45.7362036 16.8527016C46.0349079 16.960179 46.3226242 17.0906817 46.5972115 17.2420688L50.2351401 13.6041402 50.2351401 8.75736075 53.4005444 8.75736075 53.4005444 13.0359666 57.6791502 13.0359666 57.6791502 16.2013708 53.0889497 16.2013708 49.2007322 20.0895884C49.3128329 20.3448328 49.4076746 20.6093744 49.4837802 20.881736L54.7710415 20.881736 58.1982321 17.4545455 60.4365109 19.6928243 57.4110797 22.7182555 60.4365109 25.7436866 58.1982321 27.9819655 54.9524702 24.7362036 49.2739723 24.7362036C49.1856983 24.9558521 49.0848073 25.1690719 48.9721964 25.3749658L52.8323708 29.2351401 57.6791502 29.2351401 57.6791502 32.4005444 53.4005444 32.4005444 53.4005444 36.6791502 50.2351401 36.6791502 50.2351401 32.0889497 46.133982 27.9877916C46.0037617 28.0455252 45.8711032 28.0987599 45.7362036 28.1472984L45.7362036 33.9524702 48.9819655 37.1982321 46.7436866 39.4365109 43.7546593 36.4474835 40.6928243 39.4365109 38.4545455 37.1982321 41.881736 33.7710415 41.881736 28.2181042C41.6810813 28.1541951 41.485008 28.0800167 41.2941338 27.9961867L37.2013708 32.0889497 37.2013708 34.8718552zM44.25 25.5C45.9068542 25.5 47.25 24.1568542 47.25 22.5 47.25 20.8431458 45.9068542 19.5 44.25 19.5 42.5931458 19.5 41.25 20.8431458 41.25 22.5 41.25 24.1568542 42.5931458 25.5 44.25 25.5zM34.5 42C31.5 49 28 52.5 24 52.5 20 52.5 16.5 49 13.5 42L34.5 42z"/>
            <path d="M36,42 C36,48.627417 30.627417,54 24,54 C17.372583,54 12,48.627417 12,42 C12,37.5583059 14.4131918,33.6802429 18,31.6053863 L18,12 C18,8.6862915 20.6862915,6 24,6 C27.3137085,6 30,8.6862915 30,12 L30,31.6053863 C33.5868082,33.6802429 36,37.5583059 36,42 Z M33,42 C33,38.0813435 30.4955771,34.7476263 27,33.5121171 L27,12 C27,10.3431458 25.6568542,9 24,9 C22.3431458,9 21,10.3431458 21,12 L21,33.5121171 C17.5044229,34.7476263 15,38.0813435 15,42 C15,46.9705627 19.0294373,51 24,51 C28.9705627,51 33,46.9705627 33,42 Z"/>
          </g>`;
            break;

        case 'warm':
            return `<g id="icon_ct_warmer" fill="${iconColor}" transform="translate(42 42)">
            <path d="M36.9741824 34.4671046C36.1218647 33.0022911 35.0285861 31.6949774 33.7486425 30.5994594 33.2671182 29.4971697 33 28.2797793 33 27 33 22.0294373 37.0294373 18 42 18 46.9705627 18 51 22.0294373 51 27 51 31.9705627 46.9705627 36 42 36 40.1387061 36 38.4093796 35.4349809 36.9741824 34.4671046L36.9741824 34.4671046zM52.8697177 35.0076853C53.4617696 34.2053676 53.967115 33.3351557 54.3719219 32.4108816L60.9365335 36.2009619 59.4365335 38.7990381 52.8697177 35.0076853 52.8697177 35.0076853zM54.3719219 21.5891184C53.967115 20.6648443 53.4617696 19.7946324 52.8697177 18.9923147L59.4365335 15.2009619 60.9365335 17.7990381 54.3719219 21.5891184 54.3719219 21.5891184zM43.5 13.5823932C43.0074992 13.52795 42.5070136 13.5 42 13.5 41.4929864 13.5 40.9925008 13.52795 40.5 13.5823932L40.5 6 43.5 6 43.5 13.5823932 43.5 13.5823932zM40.5 40.4176068C40.9925008 40.47205 41.4929864 40.5 42 40.5 42.5070136 40.5 43.0074992 40.47205 43.5 40.4176068L43.5 48 40.5 48 40.5 40.4176068 40.5 40.4176068zM42 33C45.3137085 33 48 30.3137085 48 27 48 23.6862915 45.3137085 21 42 21 38.6862915 21 36 23.6862915 36 27 36 30.3137085 38.6862915 33 42 33zM28.5 33C31.9955771 34.2355092 34.5 37.5 34.5 42 34.5 48 30 52.5 24 52.5 18 52.5 13.5 48 13.5 42 13.5 38.0813435 15 34.5 19.5 33L19.5 21 28.5 21 28.5 33z"/>
            <path d="M36,42 C36,48.627417 30.627417,54 24,54 C17.372583,54 12,48.627417 12,42 C12,37.5583059 14.4131918,33.6802429 18,31.6053863 L18,12 C18,8.6862915 20.6862915,6 24,6 C27.3137085,6 30,8.6862915 30,12 L30,31.6053863 C33.5868082,33.6802429 36,37.5583059 36,42 Z M33,42 C33,38.0813435 30.4955771,34.7476263 27,33.5121171 L27,12 C27,10.3431458 25.6568542,9 24,9 C22.3431458,9 21,10.3431458 21,12 L21,33.5121171 C17.5044229,34.7476263 15,38.0813435 15,42 C15,46.9705627 19.0294373,51 24,51 C28.9705627,51 33,46.9705627 33,42 Z"/>
          </g>`;
            break;

        case 'darkest':
        case 'verydark':
        case 'dark':
            return `<path fill="${iconColor}" d="M30 42C23.372583 42 18 36.627417 18 30 18 23.372583 23.372583 18 30 18 36.627417 18 42 23.372583 42 30 42 36.627417 36.627417 42 30 42zM30 39C34.9705627 39 39 34.9705627 39 30 39 25.0294373 34.9705627 21 30 21 25.0294373 21 21 25.0294373 21 30 21 34.9705627 25.0294373 39 30 39zM44.5598582 23.3259128C44.1519766 22.4047845 43.6622529 21.5279766 43.0999103 20.7047125L50.0346097 16.7009619 51.5346097 19.2990381 44.5598582 23.3259128zM31.5 13.6242021C30.8332875 13.542216 30.1542689 13.5 29.4653903 13.5 29.1413267 13.5 28.819445 13.5093423 28.5 13.5277722L28.5 6 31.5 6 31.5 13.6242021zM16.1408427 20.266361C15.5516809 21.0715037 15.0337305 21.9320405 14.5962634 22.8386993L8.46539031 19.2990381 9.96539031 16.7009619 16.1408427 20.266361zM14.5962634 37.1613007C15.0337305 38.0679595 15.5516809 38.9284963 16.1408427 39.733639L9.96539031 43.2990381 8.46539031 40.7009619 14.5962634 37.1613007zM28.5 46.4722278C28.819445 46.4906577 29.1413267 46.5 29.4653903 46.5 30.1542689 46.5 30.8332875 46.457784 31.5 46.3757979L31.5 54 28.5 54 28.5 46.4722278zM43.0999103 39.2952875C43.6622529 38.4720234 44.1519766 37.5952155 44.5598582 36.6740872L51.5346097 40.7009619 50.0346097 43.2990381 43.0999103 39.2952875z" transform="translate(42 42)"/>`;
            break;

        case 'lightest':
        case 'verylight':
        case 'light':
            return `<g fill="${iconColor}" transform="translate(42 42)"><circle cx="30" cy="30" r="12"/>
            <path d="M44.5598582,23.3259128 C44.1519766,22.4047845 43.6622529,21.5279766 43.0999103,20.7047125 L50.0346097,16.7009619 L51.5346097,19.2990381 L44.5598582,23.3259128 Z M31.5,13.6242021 C30.8332875,13.542216 30.1542689,13.5 29.4653903,13.5 C29.1413267,13.5 28.819445,13.5093423 28.5,13.5277722 L28.5,6 L31.5,6 L31.5,13.6242021 Z M16.1408427,20.266361 C15.5516809,21.0715037 15.0337305,21.9320405 14.5962634,22.8386993 L8.46539031,19.2990381 L9.96539031,16.7009619 L16.1408427,20.266361 Z M14.5962634,37.1613007 C15.0337305,38.0679595 15.5516809,38.9284963 16.1408427,39.733639 L9.96539031,43.2990381 L8.46539031,40.7009619 L14.5962634,37.1613007 Z M28.5,46.4722278 C28.819445,46.4906577 29.1413267,46.5 29.4653903,46.5 C30.1542689,46.5 30.8332875,46.457784 31.5,46.3757979 L31.5,54 L28.5,54 L28.5,46.4722278 Z M43.0999103,39.2952875 C43.6622529,38.4720234 44.1519766,37.5952155 44.5598582,36.6740872 L51.5346097,40.7009619 L50.0346097,43.2990381 L43.0999103,39.2952875 Z"/>
            </g>`;
            break;

        default:
            return '';
            break;
    }
}
