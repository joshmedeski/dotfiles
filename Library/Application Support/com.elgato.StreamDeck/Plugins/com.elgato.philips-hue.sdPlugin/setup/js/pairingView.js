/**
@file      pairingView.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Load the pairing view
function loadPairingView() {
    // Time used to automatically pair bridges
    let autoPairingTimeout = 30;

    // Define local timer
    let timer = null;

    // Set the status bar
    setStatusBar('pairing');

    // Fill the title
    document.getElementById('title').innerHTML = localization['Pairing']['Title'];

    // Fill the content area
    document.getElementById('content').innerHTML = `
        <p>${localization['Pairing']['Description']}</p>
        <img class="image" src="images/bridge_pressed.png" alt="${localization['Pairing']['Title']}">
        <div id="loader"></div>
        <div id="controls"></div>
    `;

    // Start the pairing
    autoPairing();

    // For n seconds try to connect to the bridge automatically
    function autoPairing() {
        // Define local timer counter
        let timerCounter = 0;

        // Start a new timer to auto connect to the bridges
        timer = setInterval(() => {
            if (timerCounter < autoPairingTimeout) {
                // Try to connect for n seconds
                pair();
                timerCounter++;
            }
            else {
                // If auto connect was not successful for n times,
                // stop auto connecting and show controls

                // Stop the timer
                clearInterval(timer);
                timer = null;

                // Hide the loader animation
                document.getElementById('loader').classList.add('hide');

                // Show manual user controls instead
                document.getElementById('controls').innerHTML = `
                    <div class="button" id="retry">${localization['Pairing']['Retry']}</div>
                    <div class="button-transparent" id="close">${localization['Pairing']['Close']}</div>
                `;

                // Add event listener
                document.getElementById('retry').addEventListener('click', retry);
                document.addEventListener('enterPressed', retry);

                document.getElementById('close').addEventListener('click', close);
                document.addEventListener('escPressed', close);
            }
        }, 1000)
    }

    // Try to pair with all discovered bridges
    function pair() {
        bridges.forEach(item => {
            item.pair((status, data) => {
                if (status) {
                    // Pairing was successful
                    bridge = item;

                    // Show the save view
                    unloadPairingView();
                    loadSaveView();
                }
            });
        });
    }

    // Retry pairing by reloading the view
    function retry() {
        unloadPairingView();
        loadPairingView();
    }

    // Close the window
    function close() {
        window.close();
    }

    // Unload view
    function unloadPairingView() {
        // Stop the timer
        clearInterval(timer);
        timer = null;

        // Remove event listener
        document.removeEventListener('escPressed', retry);
        document.removeEventListener('enterPressed', close);
    }
}
