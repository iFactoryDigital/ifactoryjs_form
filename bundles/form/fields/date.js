
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
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Date';
    this.description = 'Date Field';
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
   * renders form field
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
   * renders form field
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
