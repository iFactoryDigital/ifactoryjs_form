
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
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   * @param {*}      old
   *
   * @return {*}
   */
  async submit(req, field, value, old) {
    // return value
    try {
      // return user
      return await User.findById(value);
    } catch (e) {
      // return old value
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
    field.tag = 'user';
    field.value = value ? (Array.isArray(value) ? await Promise.all(value.map(item => item.sanitise())) : await value.sanitise()) : null;

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
