// Copyright © 2022, Corsair Memory Inc. All rights reserved.

// This isn't a true UUID, it's just random data.

let uuid_buffer = new Uint8Array(16);

function uuid() {
	// Fill buffer with noise.
	if (window.crypto && window.crypto.getRandomValues) {
		window.crypto.getRandomValues(uuid_buffer);
	} else {
		for (let idx = 0; idx < this.uuid_buffer.length; idx++) {
			uuid_buffer[idx] = Math.floor(Math.random() * Math.floor(2147483647));
		}
	}

	return uuid_buffer.toHex();
}
