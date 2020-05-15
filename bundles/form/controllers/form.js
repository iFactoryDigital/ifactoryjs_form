
// require dependencies
const socket     = require('socket');
const Controller = require('controller');

// load models
const Form = model('form');

// load helper
const formHelper  = helper('form');
const fieldHelper = helper('form/field');
const modelHelper = helper('model');

/**
 * build induction controller
 *
 * @acl   true
 * @fail  /
 * @mount /form
 */
class FormController extends Controller {
  /**
   * construct example controller class
   */
  constructor() {
    // run super
    super();

    // register simple field
    fieldHelper.field('structure.container', {
      for         : ['frontend', 'admin'],
      title       : 'Container Element',
      categories  : ['structure'],
      description : 'Creates container structure',
    }, async (req, field) => {
      // set tag
      field.tag = 'container';

      // return
      return field;
    }, async (req, field) => { }, async (req, field) => { });

    // register simple field
    fieldHelper.field('structure.row', {
      for         : ['frontend', 'admin'],
      title       : 'Row Element',
      categories  : ['structure'],
      description : 'Creates row structure',
    }, async (req, field) => {
      // set tag
      field.tag = 'row';

      // return
      return field;
    }, async (req, field) => { }, async (req, field) => { });

    // register simple field
    fieldHelper.field('structure.div', {
      for         : ['frontend', 'admin'],
      title       : 'Div Element',
      categories  : ['structure'],
      description : 'Creates div structure',
    }, async (req, field) => {
      // set tag
      field.tag = 'div';

      // return
      return field;
    }, async (req, field) => { }, async (req, field) => { });

    // register simple field
    fieldHelper.field('structure.card', {
      for         : ['frontend', 'admin'],
      title       : 'Card Element',
      categories  : ['structure'],
      description : 'Creates card structure',
    }, async (req, field) => {
      // set tag
      field.tag = 'card';

      // return
      return field;
    }, async (req, field) => { }, async (req, field) => { });

    // register default field types
    ['address', 'boolean', 'checkbox', 'encrypt', 'date', 'file', 'email', 'image', 'phone', 'number', 'radio', 'select', 'text', 'textarea', 'wysiwyg'].sort().forEach((field) => {
      // require field
      const FieldClass = require(`form/fields/${field}`);

      // initialize class
      const fieldClassBuilt = new FieldClass(fieldHelper);

      // register
      fieldHelper.field(field, {
        for         : ['frontend', 'admin'],
        title       : fieldClassBuilt.title,
        categories  : fieldClassBuilt.categories,
        description : fieldClassBuilt.description,
      }, fieldClassBuilt.render, fieldClassBuilt.save, fieldClassBuilt.submit);
    });

    // add middleware
    this.eden.router.use(this._middleware);

    // on render
    this.eden.pre('view.compile', async (render) => {
      // move menus
      if (render.state.forms && render.state.forms.length) {
        // set Block
        render.forms = {};

        // await promise
        await Promise.all(render.state.forms.map(async (placement) => {
        // get Block
          const form = await formHelper.get(placement);

          // set null or Block
          render.forms[placement] = form ? await formHelper.render(render.req, form) : null;
        }));
      }

      // check fields
      if (!render.fields && !render.isJSON) {
        // render fields
        render.fields = fieldHelper.renderFields('frontend');
      }

      // delete state fields
      delete render.state.forms;
    });
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.listen.form
   * @return {Async}
   */
  async listenAction(id, uuid, opts) {
    // / return if no id
    if (!id) return null;

    // join room
    opts.socket.join(`placement.${id}`);

    // add to room
    return await modelHelper.listen(opts.sessionID, await Form.findById(id), uuid);
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.deafen.form
   * @return {Async}
   */
  async deafenAction(id, uuid, opts) {
    // / return if no id
    if (!id) return null;

    // add to room
    return await modelHelper.deafen(opts.sessionID, await Form.findById(id), uuid);
  }

  /**
   * add/edit action
   *
   * @route    {get} /:id/view
   * @layout   admin
   * @priority 12
   */
  async viewAction(req, res) {
    // set website variable
    let form = null;

    // check for website model
    if (req.params.id && req.params.id !== 'null') {
      // add try/catch
      try {
        // load by id
        form = await Form.findById(req.params.id);
      } catch (e) {}

      // add try/catch
      try {
        // load by id
        if (!form) {
          // set form by placement
          form = await Form.findOne({
            placement : req.params.id,
          });
        }
      } catch (e) {}
    }

    // check placement
    if (!form) {
      // set new form
      form = new Form({
        creator : req.user,
      });
    }

    // return JSON
    res.json({
      state   : 'success',
      result  : await form.sanitise(req),
      message : 'Successfully got fields',
    });
  }

  /**
   * save field action
   *
   * @returns  {*}
   *
   * @route    {post} /:id/field/save
   * @layout   admin
   * @priority 12
   */
  async saveFieldAction(req, res) {
    // set website variable
    let form = new Form({
      creator : req.user,
    });

    // check for website model
    if (req.params.id && req.params.id !== 'null') {
      // load by id
      form = await Form.findById(req.params.id);
    }

    // get field
    const fields  = form.get('fields') || [];
    const current = fields.find(field => field.uuid === req.body.field.uuid);

    // check current
    if (!current) {
      // return json
      return res.json({
        state   : 'fail',
        result  : {},
        message : 'Field not found',
      });
    }

    // update
    const registered = fieldHelper.fields().find(w => w.type === current.type);

    // await save
    if (registered && registered.save) await registered.save(req, req.body.field);

    // get rendered
    const rendered = await registered.render(req, req.body.field);

    // set uuid
    rendered.uuid = req.body.field.uuid;

    // emit
    socket.room(`form.${form.get('_id').toString()}`, `form.${form.get('_id').toString()}.field`, rendered);

    // return JSON
    return res.json({
      state   : 'success',
      result  : rendered,
      message : 'Successfully saved field',
    });
  }

  /**
   * remove field action
   *
   * @route    {post} /:id/field/remove
   * @layout   admin
   * @priority 12
   */
  async removeBlockAction(req, res) {
    // return JSON
    res.json({
      state   : 'success',
      result  : null,
      message : 'Successfully removed field',
    });
  }

  /**
   * create submit action
   *
   * @route  {post} /create
   * @layout admin
   */
  createAction(...args) {
    // return update action
    return this.updateAction(...args);
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route {post} /:id/update
   */
  async updateAction(req, res) {
    // set website variable
    let form = new Form();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      form = await Form.findById(req.params.id);
      create = false;
    }

    // update placement
    form.set('name', req.body.name);
    form.set('fields', req.body.fields);
    form.set('placement', req.body.placement);
    form.set('positions', req.body.positions);

    // save placement
    await form.save(req.user);

    // send alert
    req.alert('success', `Successfully ${create ? 'Created' : 'Updated'} form!`);

    // return JSON
    res.json({
      state   : 'success',
      result  : await form.sanitise(req),
      message : 'Successfully updated form',
    });
  }

  /**
   * middleware for Block
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   */
  _middleware(req, res, next) {
    // set Block
    res.locals.forms = [];

    // create middle function
    const middleFunction = (form) => {
      // check locals
      if (!Array.isArray(res.locals.forms)) res.locals.forms = [];

      // push placement to Block
      if (res.locals.forms.includes(form)) return;

      // add to Block
      res.locals.forms.push(form);
    };

    // create Block method
    res.form = middleFunction;
    req.form = middleFunction;

    // run next
    return next();
  }
}

/**
 * export form controller
 *
 * @type {FormController}
 */
module.exports = FormController;
