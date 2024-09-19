class DialStack {
    constructor (data, context) {
        this.actions = data?.actions || [];
        this.currentActionIndex = 0;
    }

    get currentAction() {
        return this.actions[this.currentActionIndex];
    }

    set currentAction(action) {
        // use this action
        console.log("Active action: idx/action", this.currentActionIndex);
        action.update(true);
        return action;
    }

    addActions(actions) {
        if(!Array.isArray(actions)) return [];
        return actions.map(action => this.addAction(action));
    }
    addAction(action) {
        return this.actions.push(action);
    }

    removeAction(action) {
        return this.actions.splice(this.actions.indexOf(action), 1);
    }

    next() {
        this.currentActionIndex = this.cycle(this.currentActionIndex + 1, this.actions.length - 1);
        return this.currentAction = this.actions[this.currentActionIndex];
    }

    prev() {
        this.currentActionIndex = this.cycle(this.currentActionIndex - 1, this.actions.length - 1);
        return this.currentAction = this.actions[this.currentActionIndex];
    }

    cycle(idx, max) {
        return (idx > max ? 0 : idx < 0 ? max : idx);
    }
}