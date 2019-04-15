
// set events
const Events = require('events');

/**
 * construct fields mixin
 */
class FieldsMixin extends Events {
  /**
   * construct fields mixin
   *
   * @param {RiotElement} t
   */
  constructor(t) {
    // run super
    super();

    // set variables
    this.eden = t.eden;
    this.element = t;

    // bind methods
    this.update = this.update.bind(this);
    this.hasChange = this.hasChange.bind(this);
    this.shouldLoad = this.shouldLoad.bind(this);

    // set filter fields
    this.filter = {
      fix     : this.filterFix.bind(this),
      place   : this.filterPlace.bind(this),
      flatten : this.filterFlatten.bind(this),
      replace : this.filterReplace.bind(this),
    };
    this.element.filter = this.filter;
    this.element.helper = this;
  }

  /**
   * returns true if form changed
   *
   * @return {Boolean}
   */
  hasChange() {
    // check matched type
    if (this.element.opts.type !== this.element.type) {
      // type does not match
      return true;
    }

    // check matched preview
    if (!!this.element.preview !== !!this.element.opts.preview) {
      // preview does not match
      return true;
    }

    // check matched model
    if ((!this.element.opts.model && (this.element.opts.form || {}).id !== this.element.form.get('id'))) {
      // form id does not match
      return true;
    }
  }

  /**
   * returns true if should load
   *
   * @return {Boolean}
   */
  shouldLoad() {
    // check matched fields length
    if ((this.element.form.get('fields') || []).length !== this.element.fields.length) {
      // field lengths do not match
      return true;
    }

    // check if empty form
    if (!(this.element.form.get('fields') || []).length && !(this.eden.get('forms') || {})[this.element.form.get('id')]) {
      // field lengths do not match
      return true;
    }
  }

  /**
   * do full update
   *
   * @return {*}
   */
  update() {
    // get positions
    const positions = this.element.form.get('positions') || [];

    // reset positions
    this.element.form.set('positions', []);

    // update
    this.element.update();

    // set positions again
    this.element.form.set('positions', positions);

    // update view again
    this.element.update();
  }

  // ////////////////////////////////////////////////////////////////////////////
  //
  // Filter Methods
  //
  // ////////////////////////////////////////////////////////////////////////////

  /**
   * filter fix
   *
   * @param  {Object} field
   *
   * @return {Object}
   */
  filterFix(field) {
    // standard children fields
    const children = ['left', 'right', 'children'];

    // return if moving
    if (!field) return;

    // check children
    for (const child of children) {
      // check child
      if (field[child]) {
        // remove empty fields
        field[child] = Object.values(field[child]).filter(field => field);

        // push children to flat
        field[child] = field[child].map(this.filter.fix);
      }
    }

    // return accum
    return field;
  }

  /**
   * filter field
   *
   * @param  {Object} field
   *
   * @returns {Object}
   */
  filterPlace(field) {
    // standard children fields
    const children = ['left', 'right', 'children'];

    // return if moving
    if (field.moving || field.removing) return;

    // check children
    for (const child of children) {
      // check child
      if (field[child]) {
        // remove empty fields
        field[child] = Object.values(field[child]);

        // push children to flat
        field[child] = field[child].map(this.filter.place).filter(field => field);
      }
    }

    // return accum
    return field;
  }

  /**
   * filter flatten
   *
   * @param  {Array}  accum
   * @param  {Object} field
   *
   * @returns {Array}
   */
  filterFlatten(accum, field) {
    // standard children fields
    const children = ['left', 'right', 'children'];

    // get sanitised
    const sanitised = JSON.parse(JSON.stringify(field));

    // loop for of
    for (const child of children) {
      // delete child field
      delete sanitised[child];
      delete sanitised.saving;
    }

    // check field has children
    accum.push(sanitised);

    // check children
    for (const child of children) {
      // check child
      if (field[child]) {
        // remove empty fields
        field[child] = field[child].filter(field => field);

        // push children to flat
        accum.push(...field[child].reduce(this.filter.flatten, []));
      }
    }

    // return accum
    return accum;
  }

  /**
   * filter replace
   *
   * @param  {Field} b
   *
   * @returns {*}
   */
  filterReplace(b) {
    // return field
    return (field) => {
      // standard children fields
      const children = ['left', 'right', 'children'];

      // return if moving
      if (field.moving || field.removing) return;

      // set field info for replace
      if (field.uuid === b.uuid) {
        // remove
        for (const key in b) {
          // set key
          field[key] = b[key];
        }
      }

      // check children
      for (const child of children) {
        // check child
        if (field[child]) {
          // remove empty fields
          field[child] = Object.values(field[child]);

          // push children to flat
          field[child] = field[child].map(this.filter.replace(b)).filter(field => field);
        }
      }

      // return accum
      return field;
    };
  }
}

// export riot mixin
riot.mixin('fields', {
  /**
   * on init function
   */
  init() {
    // create fields mixin
    this.fields = new FieldsMixin(this);
  },
});
