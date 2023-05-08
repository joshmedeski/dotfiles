/**
@file      discoveryView.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Load the discovery view
function loadDiscoveryView() {
    // Delay the result for 1.5 seconds
    let resultDelay = 1500;

    // Set the status bar
    setStatusBar('discovery');

    // Fill the title
    document.getElementById('title').innerHTML = localization['Discovery']['Title'];

    // Fill the content area
    document.getElementById('content').innerHTML = `
        <p>&nbsp;</p>
        <img class="image" src="images/bridge.png" alt="${localization['Discovery']['Title']}">
        <div id="loader"></div>
    `;

    // Start the discovery
    autoDiscovery();

    // Discover all bridges
    function autoDiscovery() {
        Bridge.discover((status, data) => {
            if (status) {
                // Bridge discovery request was successful
                bridges = data;

                // Delay displaying the result
                setTimeout(() => {
                    if (bridges.length === 0) {
                        // No bridges were found

                        // Fill the title
                        document.getElementById('title').innerHTML = localization['Discovery']['TitleNone'];

                        // Fill the content area
                        document.getElementById('content').innerHTML = `
                            <p>${localization['Discovery']['DescriptionNone']}</p>
                            <img class="image" src="images/bridge_not_found.png" alt="${localization['Discovery']['TitleNone']}">
                            <div class="button" id="retry">${localization['Discovery']['Retry']}</div>
                            <div class="button-transparent" id="close">${localization['Discovery']['Close']}</div>
                        `;

                        // Add event listener
                        document.getElementById('retry').addEventListener('click', retry);
                        document.addEventListener('enterPressed', retry);

                        document.getElementById('close').addEventListener('click', close);
                        document.addEventListener('escPressed', close);
                    }
                    else {
                        // At least one bridge was found
                        let content;

                        if (bridges.length === 1) {
                            // Exactly one bridge was found

                            // Fill the title
                            document.getElementById('title').innerHTML = localization['Discovery']['TitleOne'];

                            // Fill the content area
                            content = `
                                <p>${localization['Discovery']['DescriptionFound']}</p>
                                <img class="image" src="images/bridge.png" alt="${localization['Discovery']['TitleOne']}">
                            `;
                        }
                        else {
                            // At least 2 bridges were found

                            // Fill the title
                            document.getElementById('title').innerHTML = localization['Discovery']['TitleMultiple'].replace('{{ number }}', bridges.length);

                            // Fill the content area
                            content = `
                                <p>${localization['Discovery']['DescriptionFound']}</p>
                                <img class="image" src="images/bridge_multiple.png" alt="${localization['Discovery']['TitleMultiple'].replace('{{ number }}', bridges.length)}">
                            `;
                        }

                        document.getElementById('content').innerHTML = content + `
                            <div class="button" id="pair">${localization['Discovery']['Pair']}</div>
                            <div class="button-transparent" id="retry">${localization['Discovery']['Retry']}</div>
                        `;

                        // Add event listener
                        document.getElementById('pair').addEventListener('click', pair);
                        document.addEventListener('enterPressed', pair);

                        document.getElementById('retry').addEventListener('click', retry);
                        document.addEventListener('escPressed', retry);
                    }
                }, resultDelay);
            }
            else {
                // An error occurred while contacting the meethue discovery service
                document.getElementById('content').innerHTML = `<p>${data}</p>`;
            }
        });
    }

    // Open pairing view
    function pair() {
        unloadDiscoveryView();
        loadPairingView();
    }

    // Retry discovery by reloading the view
    function retry() {
        unloadDiscoveryView();
        loadDiscoveryView();
    }

    // Close the window
    function close() {
        window.close();
    }

    // Unload view
    function unloadDiscoveryView() {
        // Remove event listener
        document.removeEventListener('enterPressed', retry);
        document.removeEventListener('enterPressed', pair);
        document.removeEventListener('escPressed', close);
        document.removeEventListener('escPressed', retry);
    }
}
