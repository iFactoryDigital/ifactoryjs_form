
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
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   * @param {*}      old
   *
   * @return {*}
   */
  submit(req, field, value, old) {
    // try catch
    try {
      if (value && value.split('-') && value.split('-').length > 2 && value.split('-')[0].length === 2) {
        value = `${value.split('-')[2]}-${value.split('-')[1]}-${value.split('-')[0]}`;
      }

      // let date
      let date = new Date(value);

      // check isNan
      // eslint-disable-next-line no-restricted-globals
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
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   *
   * @return {*}
   */
  async render(req, field, value) {
    // set tag
    field.tag = 'date';
    field.value = value;

    // return
    return field;
  }
}

/**
 * export built date helper
 *
 * @type {date}
 */
module.exports = DateField;
