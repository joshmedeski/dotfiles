/**
@file      main.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/

// Global variable containing the localizations
var localization = null;

// Global variable containing the discovered bridges
var bridges = [];

// Global variable containing the paired bridge
var bridge = null;

// Global function to set the status bar to the correct view
function setStatusBar(view) {
    // Remove active status from all status cells
    let statusCells = document.getElementsByClassName('status-cell');
    Array.from(statusCells).forEach((cell) => {
        cell.classList.remove('active');
    });

    // Set it only to the current one
    document.getElementById('status-' + view).classList.add('active');
}

// Main function run after the page is fully loaded
window.onload = () => {
    // Bind enter and ESC keys
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            let event = new CustomEvent('enterPressed');
            document.dispatchEvent(event);
        }
        else if (e.key === 'Esc' || e.key === 'Escape') {
            let event = new CustomEvent('escPressed');
            document.dispatchEvent(event);
        }
    });

    // Get the url parameter
    let url = new URL(window.location.href);
    let language = url.searchParams.get('language');

    // Load the localizations
    getLocalization(language, (inStatus, inLocalization) => {
        if (inStatus) {
            // Save the localizations globally
            localization = inLocalization['Setup'];

            // Show the intro view
            loadIntroView();
        }
        else {
            document.getElementById('content').innerHTML = `<p>${inLocalization}</p>`;
        }
    });
};
