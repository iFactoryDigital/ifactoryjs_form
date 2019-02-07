
// import dependencies
const Model = require('model');

// import helpers
const fieldHelper = helper('form/field');

/**
 * create user class
 */
class Form extends Model {
  /**
   * construct placement model
   */
  constructor() {
    // run super
    super(...arguments);
  }

  /**
   * sanitises placement
   *
   * @return {Promise}
   */
  async sanitise(req) {
    // return placement
    return {
      id     : this.get('_id') ? this.get('_id').toString() : null,
      type   : this.get('type'),
      name   : this.get('name'),
      render : req ? (await Promise.all((this.get('fields') || []).map(async (field) => {
        // get from register
        const registered = fieldHelper.blocks().find(b => b.type === field.type);

        // check registered
        if (!registered) return null;

        // get data
        const data = await registered.render(req, field);

        // set uuid
        data.uuid = field.uuid;

        // return render
        return data;
      }))).filter(b => b) : null,
      fields    : this.get('fields') || [],
      positions : this.get('positions') || [],
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Form;
