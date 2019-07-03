
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
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   *
   * @return {*}
   */
  submit(req, field, value) {
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
    field.tag = 'textarea';
    field.value = value;

    // return
    return field;
  }
}

/**
 * export built textarea helper
 *
 * @type {textarea}
 */
module.exports = TextareaField;
