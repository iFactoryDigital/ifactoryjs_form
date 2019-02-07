
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
    this.sanitise = this.sanitise.bind(this);
  }

  /**
   * sanitises form field
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

    // check if array
    if (!Array.isArray(value)) value = [value];

    // loop
    const values = await Promise.all(value.map(async (val) => {
      // if no value
      if (!val || val.length !== 24) return null;

      // find by id
      const user = val ? await User.findById(val) : null;

      // check user
      if (!user) return null;

      // add to result
      return {
        id       : user.get('_id').toString(),
        text     : (user.name() ? `${user.name()} - ` : '') + (user.get('email') || user.get('username')),
        selected : true,
      };
    }));

    // return values
    return values;
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
    // get value
    if (value && !Array.isArray(value)) value = [value];

    // map for values
    let values = (await Promise.all((value || []).map((val) => {
      // check value
      if (!val || val.length !== 24) return false;

      // find user
      return val ? User.findById(val) : false;
    })));

    // check values
    if (values && values.length) {
      values = values.reduce((user) => {
      // return user
        return user;
      });
    }

    // check value
    if (values && !Array.isArray(values)) values = [values];

    // return String
    return values && values.length ? values.map((user) => {
      // return name
      return user.name() || user.get('username');
    }).join(', ') : false;
  }
}

/**
 * export built user helper
 *
 * @type {UserField}
 */
module.exports = UserField;
