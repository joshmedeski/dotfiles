// input: h,s,v in [|
let hsv2rgb = (h, s, v, f = (n, k = (n + h / 60) % 6) => v - v * s * Math.max(Math.min(k, 4 - k, 1), 0)) => [f(5), f(3), f(1)];

const createSegmentPath = (x, y, diameter, startAngle, endAngle) => {
    const degrees_to_radians = Math.PI / 180;
    const radius = diameter / 2;
    const r = radius - 5;
    const x1 = (Math.cos(degrees_to_radians * endAngle) * r) + x;
    const y1 = (-Math.sin(degrees_to_radians * endAngle) * r) + y;
    const x2 = (Math.cos(degrees_to_radians * startAngle) * r) + x;
    const y2 = (-Math.sin(degrees_to_radians * startAngle) * r) + y;
    return `M${x} ${y} ${x1} ${y1} A${r} ${r} 0 0 1 ${x2} ${y2}Z`;
};

const utoa = (data) => btoa(unescape(encodeURIComponent(data)));
const toBase64 = function(svg, containsUnicode = false) {
    // return `data:image/svg+xml;base64,${utoa(svg)}`;
    return containsUnicode ? `data:image/svg+xml;base64,${utoa(svg)}` : `data:image/svg+xml;base64,${btoa(svg)}`;
};

const getSceneElements = function(device) {
    let sceneElements = [];
    if(device?.lights?.hasOwnProperty('sceneId')) { // light has a color-scene set
        const favoritePropertyArray = device.favoriteScenes || [];  // try to get all favoriteScenes
        sceneElements = favoritePropertyArray?.find(s => s.id === device.lights.sceneId)?.sceneElements ?? [];
    }
    return sceneElements;
};



function makeSceneSVG(device, sceneElements, isCurrentScene = false) {
    let lights_on = true;
    let sceneOff = false;
    let displayBrightness = 1;
    const isEncoder = false;
    // draw the scene
    const numSceneElements = sceneElements.length;
    const w = isEncoder ? 200 : 144;
    const h = isEncoder ? 100 : 144;
    const scl = this.isEncoder ? 1 : 0.8;
    const x = isEncoder ? w / 2 : h / 2;
    const strokeWidth = isEncoder ? 2 : 1;
    const topOffset = isEncoder ? h / 2 : h / 3;
    let dimSceneColors = lights_on ? 1 : 0.5;

    const radius = h / 2;
    const start = 90;
    const end = 450;
    const step = (end - start) / numSceneElements;
    const colors = sceneElements.map((color, i) => {
        const r = hsv2rgb(color.hue, color.saturation / 100, displayBrightness).map(n => Math.round(n * 255));
        return `rgb(${r[0]}, ${r[1]}, ${r[2]})`;
    });

    const paths = [`<g transform="scale(-1,1) translate(${-w},0)">`];
    const centerColor = sceneOff ? '#330000' : 'black';
    const centerScale = 0.6;
    if(numSceneElements <= 1) {
        paths.push(`<circle cx="${x}" cy="${radius}" r="${radius - 5}" fill="${colors[0]}" />`);
    } else {
        for(let i = 0;i < numSceneElements;i++) {
            const startAngle = start + (i * step);
            paths.push(`<path d="${createSegmentPath(x, radius, h, startAngle, startAngle + step)}" fill="${colors[i]}" stroke-width="${strokeWidth}" stroke="black"/>`);
        }
    }

    let hiliteCircle = ''
    if(isCurrentScene) {
        hiliteCircle = `<circle cx="${x}" cy="${radius}" r="${radius+8}" fill="white" opacity="1" />`;
    }

    paths.push(`</g>`);
    return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}">
    <g transform="translate(${w / 2},${topOffset}) scale(${scl},${scl}) translate(${-w / 2},${-topOffset})">
    ${hiliteCircle}
        <circle cx="${x}" cy="${radius}" r="${radius - strokeWidth}" fill="black" opacity="0.4" />
        <g opacity="${dimSceneColors}">
            ${paths.join('')}
        </g>
        <circle cx="${x}" cy="${radius}" r="${radius * centerScale}" fill="${centerColor}" />
        
    </g>
    </svg>`;
}
