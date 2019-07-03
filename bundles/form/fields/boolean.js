
/**
 * build boolean helper
 */
class BooleanField {
  /**
   * construct boolean helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Boolean';
    this.description = 'Boolean Field';
  }

  /**
   * submits form field
   *
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   *
   * @return {*}
   */
  submit(req, field, value) {
    // return value
    return value === 'true';
  }

  /**
   * renders form field
   *
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   *
   * @return {*}
   */
  async render(req, field, value) {
    // set tag
    field.tag = 'boolean';
    field.value = !!value;

    // return
    return field;
  }
}

/**
 * export built boolean helper
 *
 * @type {boolean}
 */
module.exports = BooleanField;
