
/**
 * build select helper
 */
class SelectField {
  /**
   * construct select helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Select';
    this.description = 'Select Field';
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
   * renders form field
   *
   * @param {Object} data
   * @param {*}      value
   *
   * @return {*}
   */
  async render({ child }, value) {
    // unset multiple
    child.multiple = false;

    // return value
    return value;
  }

  /**
   * renders form field
   *
   * @param {Object} data
   * @param {*} value
   *
   * @return {*}
   */
  async column(data, value) {
    // check value
    value = Array.isArray(value) ? value : [value];

    // get data
    let options = ((data.data || {}).data || []);
    options = Array.isArray(options) ? options : [];

    // find in data
    let values = value.map((val) => {
      // find in data
      const found = options.find((item) => {
        // return found
        return item.id === val;
      });

      // check found
      return found;
    });

    // check values
    if (values && values.length) {
      values = values.reduce((val) => {
      // return user
        return val;
      });
    }

    // check values
    if (values && !Array.isArray(values)) values = [values];

    // return value
    return values ? (values || []).map((val) => {
      // return text
      return val.text;
    }).join(', ') : false;
  }
}

/**
 * export built select helper
 *
 * @type {select}
 */
module.exports = SelectField;
