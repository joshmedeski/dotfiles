// Copyright © 2022, Corsair Memory Inc. All rights reserved.

let config = {};

// Is the current build a production build?
//
// Defaults:
//   Production: true
//   Development: false
config.production = true;

// Enable or disable debug logging, useful for development.
//
// Defaults:
//   Production: false
//   Development: true
config.debug = (config.production ? false : true);

// Delay before a WebSocket is considered truly open.
//
// Necessary for the Chromium version used by Stream Deck's Qt, due to odd
// behavior causing the WebSocket to be in both open and closed state at the
// same time. Hopefully fixed by a Chromium update in the future.
//
// Defaults:
//   Production: 250
//   Development: 250
config.websocket_open_delay = (config.production ? 250 : 250);

// Delay between attempts to connect to OBS Studio.
//
// Defaults:
//   Production: 250
//   Development: 250
config.obs_connection_attempt_delay = (config.production ? 250 : 250);

// Delay between attempts to connect to specific OBS Studio ports
//
// Defaults:
//   Production: 250
//   Development: 250
config.obs_connection_attempt_delay_port = (config.production ? 50 : 50);

// Time before calls to Stream Deck time out.
//
// Defaults:
//   Production: 10000
//   Development: 10000
config.streamdeck_timeout = (config.production ? 10000 : 10000);

// Enable Stream Deck messaging debugging.
//
// This allows us to inspect the actual data that is sent between the Stream Deck
// and plugin.
//
// Defaults:
//   Production: false
//   Development: false
config.debug_streamdeck = (config.debug ? true : false);

// Enable OBS messaging debugging.
//
// This allows us to inspect the actual data that is sent between the Stream Deck
// and OBS plugin.
//
// Defaults:
//   Production: false
//   Development: false
config.debug_obs = (config.debug ? true : false);

// Enable Inspector messaging debugging.
//
// This allows us to inspect the actual data that is sent between the Inspector
// and Action.
//
// Defaults:
//   Production: false
//   Development: false
config.debug_inspector = (config.debug ? true : false);

// Enable additional status information.
//
// Sometimes shows an Ok/Alert state when a button is pressed.
//
// Defaults:
//   Production: false
//   Development: false
config.status = (config.debug ? true : false);

// Truncate select options to this number of chars
config.truncateOptions = 100;
