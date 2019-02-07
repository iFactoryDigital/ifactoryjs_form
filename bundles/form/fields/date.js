
/**
 * build date helper
 */
class DateField {
  /**
   * construct date helper
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
    // try catch
    try {
      // let date
      let date = new Date(value.iso);

      // check isNan
      if (isNaN(date.getTime())) date = null;

      // return date
      return date;
    } catch (e) {
      // return null
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
    // return value
    return value && value.toLocaleTimeString ? value.toLocaleTimeString('en-GB', {
      day   : 'numeric',
      year  : 'numeric',
      month : 'short',
    }) : false;
  }
}

/**
 * export built date helper
 *
 * @type {date}
 */
module.exports = DateField;
