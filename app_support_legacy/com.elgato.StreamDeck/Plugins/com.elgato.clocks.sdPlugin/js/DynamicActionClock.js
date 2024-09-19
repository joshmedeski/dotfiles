class DynamicActionClock extends DynamicAction {

    constructor (options = {}, debug = false) {
        super(options, debug);
    }

    getLocations() {
        if(this.data.locations) {
            return Object.values(this.data.locations); //<- works with Proxy ... Alternative: Array.from(this.data.locations);
        }
        return [];
    }

    getTimeZone() {
        const locArray = this.getLocations();
        const m = Utils.minmax(this.data.mode, 0, locArray.length - 1);
        if(locArray.length > 0 && m < locArray.length) {
            return locArray[m];
        }
        return '';
    }

    $getMode() {
        const loc = this.getLocations();
        if(!Array.isArray(loc)) return;
        const idx = loc.indexOf(this.data.$timezone);
        return idx;
        if(idx >= 0) return idx;
        return this.data.mode + 0;
    }
    updateCity(oCustomNames) {
        const customNamesSrc = oCustomNames || this.data.customNames;
        const customNames = Object.fromEntries(Object.entries(customNamesSrc || {}).filter(([_, v]) => v != ''));
        if(!this.data.$timezone) {
            this.data.$city = '';
        } else {
            if(customNames?.hasOwnProperty(this.data.$timezone)) {
                this.data.$city = customNames[this.data.$timezone];
            } else {
                if(customNames && typeof customNames === 'object' && this.data.customNames !== customNames) this.data.customNames = customNames;
                this.data.$city = this.data.$timezone.length ? this.data.$timezone.split("/").pop().replace("_", " ") : '';
            }
        }
        return this.data.$city;
    }

    $hasDaylightSaving() {
        // const hasDaylightSaving = this.locations[this.mode]?.indexOf('DST') > -1;
        // const isDaylightSaving = (d) => {
        //     const firstDayOfYear = new Date(d.getFullYear(), 0, 1).getTimezoneOffset();
        //     const dayOutSideDST = new Date(d.getFullYear(), 6, 1).getTimezoneOffset();
        //     return Math.max(firstDayOfYear, dayOutSideDST) !== d.getTimezoneOffset();
        // };

        // const date = new Date();
    }

}
