
// require dependencies
const Helper = require('helper');

// require models
const Form = model('form');

// require helpers
const fieldHelper = helper('form/field');

/**
 * build placement helper
 */
class FormHelper extends Helper {
  /**
   * construct placement helper
   */
  constructor() {
    // run super
    super();
  }

  /**
   * gets form
   *
   * @param  {String} placement
   *
   * @return {form}
   */
  async get(placement) {
    // find one
    return await Form.findOne({
      placement,
    }) || new Form({
      placement,
      fields : [],
    });
  }

  /**
   * renders form and values
   *
   * @param  {Request} req
   * @param  {Form}    form
   * @param  {Array}   values
   *
   * @return {*}
   */
  render(req, form, current) {
    // return
    return form.sanitise(req, current);
  }

  /**
   * creates grid column for form field
   *
   * @param  {Form}   form
   * @param  {Grid}   grid
   * @param  {Object} field
   * @param  {Object} opts
   *
   * @return {*}
   */
  async column(req, form, grid, field, opts) {
    // get from register
    const registered = fieldHelper.fields().find(b => b.type === field.type);

    // return not registered
    if (!registered) return;

    // create column
    grid.column(field.name, Object.assign({
      tag  : 'element-column',
      sort : true,
      meta : {
        field,
        data : await registered.render(req, field, null),
      },
      title  : field.label,
      update : (...args) => {
        console.log(...args);
      },
    }, opts));
  }

  /**
   * renders form and values
   *
   * @param  {Request} req
   * @param  {Form}    form
   * @param  {Array}   current
   *
   * @return {*}
   */
  async submit(req, form, current = []) {
    // return
    const fields = (await Promise.all((await form.get('fields')).map(async (field) => {
      // get from register
      const registered = fieldHelper.fields().find(b => b.type === field.type);

      // check registered
      if (!registered) return null;

      // get data
      const data = await registered.submit(req, field, req.body[field.uuid], (current.find((c) => {
        // return found field
        return c.uuid === field.uuid;
      }) || {}).value);

      // set uuid
      field.value = data;

      // return render
      return field;
    }))).filter(f => f);

    // return fields
    return fields;
  }
}

/**
 * export new FormHelper class
 *
 * @return {FormHelper}
 */
module.exports = new FormHelper();
