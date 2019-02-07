
/**
 * build text helper
 */
class TextField {
  /**
   * construct text helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'Text';
    this.description = 'Text Field';
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
 * export built text helper
 *
 * @type {text}
 */
module.exports = TextField;
