
/**
 * build number helper
 */
class NumberField {
  /**
   * construct number helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
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
   * sanitises form field
   *
   * @param {Object} data
   * @param {*}      value
   *
   * @return {*}
   */
  async render({ child }, value) {
    // return value
    return parseInt(value) || 0;
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
    // return value
    return value ? parseInt(value) : 0;
  }
}

/**
 * export built number helper
 *
 * @type {number}
 */
module.exports = NumberField;
