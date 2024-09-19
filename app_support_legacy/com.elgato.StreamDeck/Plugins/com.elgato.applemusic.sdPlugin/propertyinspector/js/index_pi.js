/* global addDynamicStyles, $SD, Utils */
/* eslint-disable no-extra-boolean-cast */
/* eslint-disable no-else-return */

/**
 * This example contains a working Property Inspector, which already communicates
 * with the corresponding plugin throug settings and/or direct messages.
 * If you want to use other control-types, we recommend copy/paste these from the
 * PISamples demo-library, which already contains quite some example DOM elements
 */


/**
 * First we declare a global variable, which change all elements behaviour
 * globally. It installs the 'onchange' or 'oninput' event on the HTML controls and fiels.
 *
 * Change this, if you want interactive elements act on any modification (oninput),
 * or while their value changes 'onchange'.
 */

var onchangeevt = 'onchange'; // 'oninput';

/**
 * cache the static SDPI-WRAPPER, which contains all your HTML elements.
 * Please make sure, you put all HTML-elemenets into this wrapper, so they
 * are drawn properly using the integrated CSS.
 */

let sdpiWrapper = document.querySelector('.sdpi-wrapper');

/**
 * Since the Property Inspector is instantiated every time you select a key
 * in Stream Deck software, we can savely cache our settings in a global variable.
 */

let settings;

/**
 * Since the Property Inspector is instantiated every time you select a key
 * in Stream Deck software, we can savely cache the action type in a global variable.
 */
let actionType;

/**
 * The currently selected ID
 */

var currentSelectedID;


 /**
  * The 'connected' event is the first event sent to Property Inspector, after it's instance
  * is registered with Stream Deck software. It carries the current websocket, settings,
  * and other information about the current environmet in a JSON object.
  * You can use it to subscribe to events you want to use in your plugin.
  */

$SD.on('connected', (jsn) => {
    /**
     * The passed 'applicationInfo' object contains various information about your
     * computer, Stream Deck version and OS-settings (e.g. colors as set in your
     * OSes display preferences.)
     * We use this to inject some dynamic CSS values (saved in 'common_pi.js'), to allow
     * drawing proper highlight-colors or progressbars.
     */

    console.log("connected");
    addDynamicStyles($SD.applicationInfo.colors, 'connectSocket');

    /**
     * Current settings are passed in the JSON node
     * {actionInfo: {
     *      payload: {
     *          settings: {
     *                  yoursetting: yourvalue,
     *                  otherthings: othervalues
     * ...
     * To conveniently read those settings, we have a little utility to read
     * arbitrary values from a JSON object, eg:
     *
     * const foundObject = Utils.getProp(JSON-OBJECT, 'path.to.target', defaultValueIfNotFound)
     */
     
	actionType = Utils.getProp(jsn, 'actionInfo.action', false);
	 
	if (actionType) {
		const label = document.querySelector( "#select_combo_label" );
		const mainCombo = document.querySelector( "#select_combo" );
		label.innerText = 'Action'.lox();
		mainCombo.style.visibility = "visible";
		
		const el = document.querySelector( '#currentSelectedID' );
		el.onchange = () => {
			currentSelectedID = el.value;
			settings["currentSelectedID"] = currentSelectedID;
			$SD.api.setSettings($SD.uuid, settings);
		};
	}
   
	settings = Utils.getProp(jsn, 'actionInfo.payload.settings', false);
    if (settings) {
    	if (settings.hasOwnProperty('currentSelectedID')) {
			currentSelectedID = settings['currentSelectedID'];
		} else {
			currentSelectedID = "";
		}
    	
        updateUI(settings);
    }
});

/**
 * The 'sendToPropertyInspector' event can be used to send messages directly from your plugin
 * to the Property Inspector without saving these messages to the settings.
 */

$SD.on('sendToPropertyInspector', jsn => {
	const el = document.querySelector( '#currentSelectedID' );
	el.onchange = () => {
		currentSelectedID = el.value;
		settings["currentSelectedID"] = currentSelectedID;
		$SD.api.setSettings($SD.uuid, settings);
	};
});

const updateUI = (pl) => {
    Object.keys(pl).map(e => {
        if (e && e != '') {
            const foundElement = document.querySelector(`#${e}`);
            console.log(`searching for: #${e}`, 'found:', foundElement);
            if (foundElement && foundElement.type !== 'file') {
                foundElement.value = pl[e];
                const maxl = foundElement.getAttribute('maxlength') || 50;
                const labels = document.querySelectorAll(`[for='${foundElement.id}']`);
                if (labels.length) {
                    for (let x of labels) {
                        x.textContent = maxl ? `${foundElement.value.length}/${maxl}` : `${foundElement.value.length}`;
                    }
                }
            }
        }
   })
}

/** CREATE INTERACTIVE HTML-DOM
 * The 'prepareDOMElements' helper is called, to install events on all kinds of
 * elements (as seen e.g. in PISamples)
 * Elements can get clicked or act on their 'change' or 'input' event. (see at the top
 * of this file)
 * If you use common elements, you don't need to touch these helpers. Just take care
 * setting an 'id' on the element's input-control from which you want to get value(s).
 * These helpers allow you to quickly start experimenting and exchanging values with
 * your plugin.
 */

function prepareDOMElements(baseElement) {
    baseElement = baseElement || document;
    Array.from(baseElement.querySelectorAll('.sdpi-item-value')).forEach(
        (el, i) => {
            const elementsToClick = [
                'BUTTON',
                'OL',
                'UL',
                'TABLE',
                'METER',
                'PROGRESS',
                'CANVAS'
            ].includes(el.tagName);
            const evt = elementsToClick ? 'onclick' : onchangeevt || 'onchange';

            /** Look for <input><span> combinations, where we consider the span as label for the input
             * we don't use `labels` for that, because a range could have 2 labels.
             */
            const inputGroup = el.querySelectorAll('input + span');
            if (inputGroup.length === 2) {
                const offs = inputGroup[0].tagName === 'INPUT' ? 1 : 0;
                inputGroup[offs].textContent = inputGroup[1 - offs].value;
                inputGroup[1 - offs]['oninput'] = function() {
                    inputGroup[offs].textContent = inputGroup[1 - offs].value;
                };
            }
        }
    );

    /**
     * You could add a 'label' to a textares, e.g. to show the number of charactes already typed
     * or contained in the textarea. This helper updates this label for you.
     */
    baseElement.querySelectorAll('textarea').forEach((e) => {
        const maxl = e.getAttribute('maxlength');
        e.targets = baseElement.querySelectorAll(`[for='${e.id}']`);
        if (e.targets.length) {
            let fn = () => {
                for (let x of e.targets) {
                    x.textContent = maxl ? `${e.value.length}/${maxl}` : `${e.value.length}`;
                }
            };
            fn();
            e.onkeyup = fn;
        }
    });

    baseElement.querySelectorAll('[data-open-url').forEach(e => {
        const value = e.getAttribute('data-open-url');
        if (value) {
            e.onclick = () => {
                let path;
                if (value.indexOf('http') !== 0) {
                    path = document.location.href.split('/');
                    path.pop();
                    path.push(value.split('/').pop());
                    path = path.join('/');
                } else {
                    path = value;
                }
                $SD.api.openUrl($SD.uuid, path);
            };
        } else {
            console.log(`${value} is not a supported url`);
        }
    });
}

/**
 * This is a quick and simple way to localize elements and labels in the Property
 * Inspector's UI without touching their values.
 * It uses a quick 'lox()' function, which reads the strings from a global
 * variable 'localizedStrings' (in 'common.js')
 */

// eslint-disable-next-line no-unused-vars
function localizeUI() {
    const el = document.querySelector('.sdpi-wrapper') || document;
    let t;
    Array.from(el.querySelectorAll('sdpi-item-label')).forEach(e => {
        t = e.textContent.lox();
        if (e !== t) {
            e.innerHTML = e.innerHTML.replace(e.textContent, t);
        }
    });
    Array.from(el.querySelectorAll('*:not(script)')).forEach(e => {
        if (
            e.childNodes
            && e.childNodes.length > 0
            && e.childNodes[0].nodeValue
            && typeof e.childNodes[0].nodeValue === 'string'
        ) {
            t = e.childNodes[0].nodeValue.lox();
            if (e.childNodes[0].nodeValue !== t) {
                e.childNodes[0].nodeValue = t;
            }
        }
    });
}

/**
 *
 * Some more (de-) initialization helpers
 *
 */

document.addEventListener('DOMContentLoaded', function() {
    document.body.classList.add(navigator.userAgent.includes("Mac") ? 'mac' : 'win');
    prepareDOMElements();
    $SD.on('localizationLoaded', (language) => {
        localizeUI();
    });
});

/** the beforeunload event is fired, right before the PI will remove all nodes */
window.addEventListener('beforeunload', function(e) {
    e.preventDefault();
    // Don't set a returnValue to the event, otherwise Chromium with throw an error.  // e.returnValue = '';
});

function gotCallbackFromWindow(parameter) {
    console.log(parameter);
}
