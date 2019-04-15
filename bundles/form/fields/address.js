
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
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Address';
    this.description = 'Address Field';
  }

  /**
   * submits form field
   *
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   * @param {*}      old
   *
   * @return {*}
   */
  submit(req, field, value, old) {
    console.log(value);
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
    field.tag = 'address';
    field.value = value;

    // return
    return field;
  }
}

/**
 * export built address helper
 *
 * @type {AddressField}
 */
module.exports = AddressField;
