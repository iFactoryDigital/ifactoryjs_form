
// require local dependencies
const Image = model('image');

/**
 * build image helper
 */
class ImageField {
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
    this.title = 'Image';
    this.description = 'Image Field';
  }

  /**
   * submits form field
   *
   * @param {Object} data
   *
   * @return {*}
   */
  async submit({ child, value, old }) {
    // check value
    if (!Array.isArray(value)) value = [value];

    // return value map
    return await Promise.all((value || []).filter(val => val).map(async (val, i) => {
      // run try catch
      try {
        // buffer image
        const image = await Image.findById(val);

        // check image
        if (image) return image.get('_id').toString();

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
   * @param {req}    Request
   * @param {Object} field
   * @param {*}      value
   *
   * @return {*}
   */
  async render(req, field, value) {
    // set tag
    field.tag = 'image';

    // return
    return field;
  }
}

/**
 * export ImageField helper
 *
 * @type {ImageField}
 */
module.exports = ImageField;
