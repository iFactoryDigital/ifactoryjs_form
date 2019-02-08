
/**
 * build radio helper
 */
class RadioField {
  /**
   * construct radio helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.update = this.update.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Radio';
    this.description = 'Radio Field';
  }

  /**
   * submits form field
   *
   * @param {Object} data
   *
   * @return {*}
   */
  submit({ child, value }) {
    // return value
    return value;
  }

  /**
   * updates field
   *
   * @param {field} Field
   * @param {Object} data
   * @param {Object} options
   *
   * @return {*}
   */
  async update(field, data) {
    // set data
    for (const key in data) {
      // check if id
      if (key === 'id') continue;

      // set value
      field.set(key, data[key]);
    }
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
    field.tag = 'radio';

    // return
    return field;
  }
}

/**
 * export built radio helper
 *
 * @type {radio}
 */
module.exports = RadioField;
