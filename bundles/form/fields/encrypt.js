
// get config
const config = require('config');
const crypto = require('crypto');

/**
 * build encrypt helper
 */
class EncryptField {
  /**
   * construct encrypt helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Encrypt';
    this.description = 'Encrypt Field';
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
    // encrypt value
    const encrypted = crypto.createHmac('sha256', config.get('secret'))
      .update(value)
      .digest('hex');

    // return value
    return encrypted;
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
    field.tag = 'encrypt';
    field.value = null;

    // return
    return field;
  }
}

/**
 * export built encrypt helper
 *
 * @type {encrypt}
 */
module.exports = EncryptField;
