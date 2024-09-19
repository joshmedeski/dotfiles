/**
 * Errors received from WebSocket
 */
const SocketErrors = {
	0: 'The connection has not yet been established',
	1: 'The connection is established and communication is possible',
	2: 'The connection is going through the closing handshake',
	3: 'The connection has been closed or could not be opened',
	1000: 'Normal Closure. The purpose for which the connection was established has been fulfilled.',
	1001: 'Going Away. An endpoint is "going away", such as a server going down or a browser having navigated away from a page.',
	1002: 'Protocol error. An endpoint is terminating the connection due to a protocol error',
	1003: "Unsupported Data. An endpoint received a type of data it doesn't support.",
	1004: '--Reserved--. The specific meaning might be defined in the future.',
	1005: 'No Status. No status code was actually present.',
	1006: 'Abnormal Closure. The connection was closed abnormally, e.g., without sending or receiving a Close control frame',
	1007: 'Invalid frame payload data. The connection was closed, because the received data was not consistent with the type of the message (e.g., non-UTF-8 [http://tools.ietf.org/html/rfc3629]).',
	1008: 'Policy Violation. The connection was closed, because current message data "violates its policy". This reason is given either if there is no other suitable reason, or if there is a need to hide specific details about the policy.',
	1009: 'Message Too Big. Connection closed because the message is too big for it to process.',
	1010: "Mandatory Extension. Connection is terminated the connection because the server didn't negotiate one or more extensions in the WebSocket handshake.",
	1011: 'Internl Server Error. Connection closed because it encountered an unexpected condition that prevented it from fulfilling the request.',
	1015: "TLS Handshake. The connection was closed due to a failure to perform a TLS handshake (e.g., the server certificate can't be verified).",
};

/**
 * Events used for communicating with Stream Deck
 */
const Events = {
	didReceiveSettings: 'didReceiveSettings',
	didReceiveGlobalSettings: 'didReceiveGlobalSettings',
	keyDown: 'keyDown',
	keyUp: 'keyUp',
	willAppear: 'willAppear',
	willDisappear: 'willDisappear',
	titleParametersDidChange: 'titleParametersDidChange',
	deviceDidConnect: 'deviceDidConnect',
	deviceDidDisconnect: 'deviceDidDisconnect',
	applicationDidLaunch: 'applicationDidLaunch',
	applicationDidTerminate: 'applicationDidTerminate',
	systemDidWakeUp: 'systemDidWakeUp',
	propertyInspectorDidAppear: 'propertyInspectorDidAppear',
	propertyInspectorDidDisappear: 'propertyInspectorDidDisappear',
	sendToPlugin: 'sendToPlugin',
	sendToPropertyInspector: 'sendToPropertyInspector',
	connected: 'connected',
	setImage: 'setImage',
	setXYWHImage: 'setXYWHImage',
	setTitle: 'setTitle',
	setState: 'setState',
	showOk: 'showOk',
	showAlert: 'showAlert',
	openUrl: 'openUrl',
	setGlobalSettings: 'setGlobalSettings',
	getGlobalSettings: 'getGlobalSettings',
	setSettings: 'setSettings',
	getSettings: 'getSettings',
	registerPropertyInspector: 'registerPropertyInspector',
	registerPlugin: 'registerPlugin',
	logMessage: 'logMessage',
	switchToProfile: 'switchToProfile',
	dialRotate: 'dialRotate',
	dialPress: 'dialPress',
	touchTap: 'touchTap',
	setFeedback: 'setFeedback',
	setFeedbackLayout: 'setFeedbackLayout',
};

/**
 * Constants used for Stream Deck
 */
const Constants = {
	dataLocalize: '[data-localize]',
	hardwareAndSoftware: 0,
	hardwareOnly: 1,
	softwareOnly: 2,
};

const DestinationEnum = {
	HARDWARE_AND_SOFTWARE: 0,
	HARDWARE_ONLY: 1,
	SOFTWARE_ONLY: 2,
};
