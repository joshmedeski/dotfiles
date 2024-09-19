/// <reference path="constants.js" />
/// <reference path="api.js" />

class ELGSDPropertyInspector extends ELGSDApi {
	constructor() {
		super();
		if (ELGSDPropertyInspector.__instance) {
			return ELGSDPropertyInspector.__instance;
		}

		ELGSDPropertyInspector.__instance = this;
	}

	/**
	 * Registers a callback function for when Stream Deck sends data to the property inspector
	 * @param {string} actionUUID
	 * @param {function} fn
	 * @returns ELGSDStreamDeck
	 */
	onSendToPropertyInspector(actionUUID, fn) {
		if (typeof actionUUID != 'string') {
			console.error('An action UUID string is required for onSendToPropertyInspector.');
		}

		if (!fn) {
			console.error(
				'A callback function for the sendToPropertyInspector event is required for onSendToPropertyInspector.'
			);
		}

		this.on(`${actionUUID}.${Events.sendToPropertyInspector}`, (jsn) => fn(jsn));
		return this;
	}

	/**
	 * Send payload from the property inspector to the plugin
	 * @param {object} payload
	 */
	sendToPlugin(payload) {
		this.send(this.uuid, Events.sendToPlugin, {
			action: this?.actionInfo?.action,
			payload: payload || null,
		});
	}

	/**
	 * Save the actions's persistent data.
	 * @param {object} payload
	 */
	setSettings(payload) {
		this.send(this.uuid, Events.setSettings, {
			action: this?.actionInfo?.action,
			payload: payload || null,
		});
	}

	/**
	 * Request the actions's persistent data. StreamDeck does not return the data, but trigger the actions's didReceiveSettings event
	 */
	getSettings() {
		this.send(this.uuid, Events.getSettings);
	}
}

const $PI = new ELGSDPropertyInspector();

/**
 * connectElgatoStreamDeckSocket
 * This is the first function StreamDeck Software calls, when
 * establishing the connection to the plugin or the Property Inspector
 * @param {string} port - The socket's port to communicate with StreamDeck software.
 * @param {string} uuid - A unique identifier, which StreamDeck uses to communicate with the plugin
 * @param {string} messageType - Identifies, if the event is meant for the property inspector or the plugin.
 * @param {string} appInfoString - Information about the host (StreamDeck) application
 * @param {string} actionInfo - Context is an internal identifier used to communicate to the host application.
 */
function connectElgatoStreamDeckSocket(port, uuid, messageType, appInfoString, actionInfo) {
	const delay = window?.initialConnectionDelay || 0;
	setTimeout(() => {
		$PI.connect(port, uuid, messageType, appInfoString, actionInfo);
	}, delay);
}
