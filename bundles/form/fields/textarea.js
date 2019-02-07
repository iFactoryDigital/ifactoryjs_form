
/**
 * build textarea helper
 */
class TextareaField {
  /**
   * construct textarea helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Textarea';
    this.description = 'Textarea Field';
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
    return value || '';
  }
}

/**
 * export built textarea helper
 *
 * @type {textarea}
 */
module.exports = TextareaField;
