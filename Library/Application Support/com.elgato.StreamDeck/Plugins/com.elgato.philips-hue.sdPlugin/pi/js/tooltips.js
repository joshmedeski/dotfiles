//==============================================================================
/**
@file       tooltips.js
@brief      Philips Hue Plugin
@copyright  (c) 2019, Corsair Memory, Inc.
            This source code is licensed under the MIT-style license found in the LICENSE file.
**/
//==============================================================================

function rangeToPercent(value, min, max) {
    return ((value - min) / (max - min));
}

function initToolTips() {
    const tooltip = document.querySelector('.sdpi-info-label');
    const arrElements = document.querySelectorAll('.floating-tooltip');

    arrElements.forEach((e,i) => {
        initToolTip(e, tooltip)
    })
}

function initToolTip(element, tooltip) {
    const tw = tooltip.getBoundingClientRect().width;
    const suffix = element.getAttribute('data-suffix') || '';

    const updateTooltip = () => {
        const elementRect = element.getBoundingClientRect();
        const w = elementRect.width - tw / 2;
        const percent = rangeToPercent(
            element.value,
            element.min,
            element.max,
        );

        tooltip.textContent = suffix !== '' ? `${element.value} ${suffix}` : String(element.value);
        tooltip.style.left = `${elementRect.left + Math.round(w * percent) - tw / 4}px`;
        tooltip.style.top = `${elementRect.top - 32}px`;
    };

    if (element) {
        element.addEventListener('mouseenter', () => {
            tooltip.classList.remove('hidden');
            tooltip.classList.add('shown');
            updateTooltip();
        }, false);

        element.addEventListener('mouseout', () => {
            tooltip.classList.remove('shown');
            tooltip.classList.add('hidden');
            updateTooltip();
        }, false);

		element.addEventListener('input', updateTooltip, false);
    }
}
