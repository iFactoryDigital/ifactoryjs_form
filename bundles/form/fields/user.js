
// require models
const User = model('user');

/**
 * build user helper
 */
class UserField {
  /**
   * construct user helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'User';
    this.description = 'User Field';
  }

  /**
   * renders form field
   *
   * @param {Object} data
   * @param {*}      value
   *
   * @return {*}
   */
  async submit({ child, value }) {
    // return value
    return value;
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
    field.tag = 'user';

    // return
    return field;
  }
}

/**
 * export built user helper
 *
 * @type {UserField}
 */
module.exports = UserField;
