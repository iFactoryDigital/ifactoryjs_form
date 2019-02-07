
/**
 * build address helper
 */
class AddressField {
  /**
   * construct address helper
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
  submit({ child, value, old }) {
    // run try/catch
    try {
      // return value
      return JSON.parse(value.address);
    } catch (e) {
      // return old
      return old;
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
    // run try/catch
    try {
      // return value
      return typeof value === 'string' ? JSON.parse(value) : value;
    } catch (e) {
      // return old
      return old;
    }
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
    return value && value.formatted ? value.formatted : '';
  }
}

/**
 * export built address helper
 *
 * @type {AddressField}
 */
module.exports = AddressField;
