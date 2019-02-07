
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
    this.sanitise = this.sanitise.bind(this);
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
   * sanitises form field
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
   * sanitises form field
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
 * export built radio helper
 *
 * @type {radio}
 */
module.exports = RadioField;
