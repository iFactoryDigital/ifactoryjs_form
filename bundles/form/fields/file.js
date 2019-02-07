
// require local dependencies
const File = model('file');

/**
 * build file helper
 */
class FileField {
  /**
   * construct file helper
   */
  constructor(helper) {
    // set helper
    this._helper = helper;

    // bind methods
    this.submit = this.submit.bind(this);
    this.render = this.render.bind(this);

    // set meta
    this.title = 'File';
    this.description = 'File Field';
  }

  /**
   * submits form field
   *
   * @param {Object} data
   *
   * @return {*}
   */
  async submit({ child, value, old }) {
    // check array
    if (!value) value = [];
    if (!Array.isArray(value)) value = [value];

    // return value map
    return await Promise.all(value.filter(val => val).map(async (val, i) => {
      // run try catch
      try {
        // buffer image
        const upload = await File.findById(val);

        // check image
        if (upload) return upload.get('_id').toString();

        // return null
        return null;
      } catch (e) {
        // return old
        return old[i];
      }
    }));
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
    // set multiple
    child.multiple = false;

    // check array
    if (!value) value = [];
    if (!Array.isArray(value)) value = [value];

    // return mapped value
    return (await Promise.all((value || []).filter(val => val).map(async (val) => {
      // find image
      const upload = await File.findById(val);

      // check image
      if (!upload) return;

      // render
      return await upload.render();
    }))).filter(val => val);
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
 * export built file helper
 *
 * @type {text}
 */
module.exports = FileField;
