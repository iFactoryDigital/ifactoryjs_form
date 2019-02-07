<eden-fields>
  <div ref="form" class="eden-fields eden-blocks">

    <div class="{ 'eden-dropzone' : this.acl.validate('admin') && !opts.preview } { 'empty' : !getFields().length }" ref="form" data-form="" if={ !this.updating }>
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        { this.form.get('title') }
      </span>
      <eden-add type="top" onclick={ onAddField } way="unshift" form="" if={ this.acl.validate('admin') && !opts.preview } />
      <div each={ el, i in getFields() } el={ el } no-reorder class={ el.class } data-is={ getElement(el) } preview={ this.preview } data-field={ el.uuid } data={ getField(el) } field={ el } get-field={ getField } on-add-field={ onAddField } on-save={ this.onSaveField } on-remove={ onRemoveField } on-refresh={ this.onRefreshField } placement={ i } i={ i } />
      <eden-add type="bottom" onclick={ onAddField } way="push" form="" if={ this.acl.validate('admin') && !opts.preview } />
    </div>
  </div>

  <field-modal fields={ opts.fields } add-field={ onSetField } />

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('model');

    // require uuid
    const uuid = require('uuid');

    // set update
    this.form     = opts.form ? this.model('form', opts.form) : this.model('form', {});
    this.type     = opts.type;
    this.fields   = (opts.form || {}).render || [];
    this.loading  = {};
    this.preview  = !!opts.preview;
    this.updating = false;

    // set flattened fields
    const fix = (field) => {
      // standard children fields
      let children = ['left', 'right', 'children'];

      // return if moving
      if (!field) return;

      // check children
      for (let child of children) {
        // check child
        if (field[child]) {
          // remove empty fields
          field[child] = Object.values(field[child]).filter((field) => field);

          // push children to flat
          field[child] = field[child].map(fix);
        }
      }

      // return accum
      return field;
    };

    // set flattened fields
    const place = (field) => {
      // standard children fields
      let children = ['left', 'right', 'children'];

      // return if moving
      if (field.moving || field.removing) return;

      // check children
      for (let child of children) {
        // check child
        if (field[child]) {
          // remove empty fields
          field[child] = Object.values(field[child]);

          // push children to flat
          field[child] = field[child].map(place).filter((field) => field);
        }
      }

      // return accum
      return field;
    };

    // set flattened fields
    const replace = (b) => {
      // return field
      return (field) => {
        // standard children fields
        let children = ['left', 'right', 'children'];

        // return if moving
        if (field.moving || field.removing) return;

        // set field info for replace
        if (field.uuid === b.uuid) {
          // remove
          for (let key in b) {
            // set key
            field[key] = b[key];
          }
        }

        // check children
        for (let child of children) {
          // check child
          if (field[child]) {
            // remove empty fields
            field[child] = Object.values(field[child]);

            // push children to flat
            field[child] = field[child].map(replace(b)).filter((field) => field);
          }
        }

        // return accum
        return field;
      };
    };

    // set flattened fields
    const flatten = (accum, field) => {
      // standard children fields
      let children = ['left', 'right', 'children'];

      // get sanitised
      let sanitised = JSON.parse(JSON.stringify(field));

      // loop for of
      for (let child of children) {
        // delete child field
        delete sanitised[child];
        delete sanitised.saving;
      }

      // check field has children
      accum.push(sanitised);

      // check children
      for (let child of children) {
        // check child
        if (field[child]) {
          // remove empty fields
          field[child] = field[child].filter((field) => field);

          // push children to flat
          accum.push(...field[child].reduce(flatten, []));
        }
      }

      // return accum
      return accum;
    };

    /**
     * get field data
     *
     * @param  {Object} field
     *
     * @return {*}
     */
    getField (field) {
      // return on no field
      if (!field) return;

      // get found
      let found = this.fields.find((b) => b.uuid === field.uuid);

      // gets data for field
      if (!found) return null;

      // return found
      return found;
    }

    /**
     * get element
     *
     * @param  {Object} child
     *
     * @return {*}
     */
    getElement (child) {
      // return get child
      return (this.getField(child) || {}).tag ? 'field-' + (this.getField(child) || {}).tag : 'eden-loading';
    }

    /**
     * get fields
     *
     * @return {Array}
     */
    getFields () {
      // return filtered fields
      return (this.form.get('positions') || []).map(fix).filter((field) => field);
    }

    /**
     * on add field
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onAddField (e) {
      // get target
      let target = !jQuery(e.target).is('eden-add') ? jQuery(e.target).closest('eden-add') : jQuery(e.target);

      // way
      this.way      = target.attr('way');
      this.fieldPos = target.attr('form');

      // open modal
      jQuery('.add-field-modal', this.root).modal('show');
    }

    /**
     * on refresh field
     *
     * @param  {Event}  e
     * @param  {Object} field
     */
    async onSaveField (field, data, form, preventUpdate) {
      // clone
      let fieldClone = Object.assign({}, field);

      // prevent update check
      if (!preventUpdate) {
        // set loading
        field.saving = true;

        // update view
        this.update();
      }

      // log data
      let res = await fetch('/form/' + this.form.get('id') + '/field/save', {
        'body' : JSON.stringify({
          'data'  : data,
          'field' : fieldClone
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // set logic
      for (let key in result.result) {
        // clone to form
        data[key] = result.result[key];
      }

      // set to fields
      if (!this.fields.find((b) => b.uuid === data.uuid)) this.fields.push(data);

      // set flat
      this.form.set('positions', (this.form.get('positions') || []).map(replace(fieldClone)));
      this.form.set('fields', (this.form.get('positions') || []).reduce(flatten, []));

      // save form
      await this.saveForm(this.form, true);

      // check prevent update
      if (!preventUpdate) {
        // set loading
        delete field.saving;

        // update view
        this.update();
      }
    }

    /**
     * on refresh field
     *
     * @param  {Event}  e
     * @param  {Object} field
     */
    async onRefreshField (field, data) {
      // set loading
      field.refreshing = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/form/' + this.form.get('id') + '/field/save', {
        'body' : JSON.stringify({
          'data'  : data,
          'field' : field
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // set logic
      for (let key in result.result) {
        // clone to form
        data[key] = result.result[key];
      }

      // set loading
      delete field.refreshing;

      // update view
      this.update();
    }

    /**
     * on refresh field
     *
     * @param  {Event}  e
     * @param  {Object} field
     */
    async onRemoveField (field, data, form) {
      // get uuid
      const dotProp = require('dot-prop-immutable');

      // set loading
      field.removing = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/form/' + this.form.get('id') + '/field/remove', {
        'body' : JSON.stringify({
          'data'  : data,
          'field' : field
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // get positions
      let positions = (this.form.get('positions') || []).map(fix).filter((field) => field);

      // set moving on field
      positions = dotProp.set(positions, form + '.removing', true);

      // get positions
      this.form.set('positions', positions.map(place).filter((field) => field));
      this.form.set('fields', (this.form.get('positions') || []).reduce(flatten, []));

      // save form
      await this.saveForm(this.form);
    }

    /**
     * adds field by type
     *
     * @param  {String} type
     *
     * @return {*}
     */
    async onSetField (type) {
      // get uuid
      const dotProp = require('dot-prop-immutable');

      // create field
      let field = {
        'uuid' : uuid(),
        'type' : type
      };

      // check positions
      if (!this.form.get('positions')) this.form.set('positions', []);

      // get from position
      let pos = (this.fieldPos || '').length ? dotProp.get(this.form.get('positions'), this.fieldPos) : this.form.get('positions');

      // force pos to exist
      if (!pos && (this.fieldPos || '').length) {
        // set pos
        pos = [];

        // set
        dotProp.set(this.form.get('positions'), this.fieldPos, pos);
      }

      // do thing
      pos[this.way](field);

      // set flat
      this.form.set('fields', (this.form.get('positions') || []).reduce(flatten, []));

      // save form
      await this.saveForm(this.form);
      await this.onSaveField(field, {});

      // update view
      this.update();
    }

    /**
     * saves form
     *
     * @param {Object}  form
     * @param {Boolean} preventRefresh
     *
     * @return {Promise}
     */
    async saveForm (form, preventRefresh) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!form.type) form.set('type', opts.type);

      // log data
      let res = await fetch('/form/' + (form.get('id') ? form.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(form.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // prevent clear
      if (!preventRefresh) {
        // reset positions
        form.set('positions', []);

        // update view
        this.update();
      }

      // set in eden
      window.eden.forms[form.get('id')] = data.result;

      // set logic
      for (let key in data.result) {
        // clone to form
        form.set(key, data.result[key]);

        // set in opts
        if (data.result[key]) opts.form[key] = data.result[key];
      }

      // set form
      this.form = form;

      // on save
      if (opts.onSave) opts.onSave(form);

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }

    /**
     * loads form fields
     *
     * @param  {Object} opts
     *
     * @return {Promise}
     */
    async loadFields (opts) {
      // set opts
      if (!opts) opts = {};

      // require query string
      const qs = require('querystring');

      // set opts
      opts = qs.stringify(opts);

      // set loading
      this.loading.fields = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/form/' + this.form.get('id') + '/view' + (opts.length ? '?' + opts : ''), {
        'method'  : 'get',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // set in eden
      if (data.result) {
        // set in eden
        window.eden.forms[this.form.get('id')] = data.result;

        // set key
        this.form.set('positions', []);

        // udpate view
        this.update();

        // set fields
        for (let key in data.result) {
          // set key
          this.form.set(key, data.result[key]);
        }

        // set loading
        this.loading.fields = false;

        // get fields
        this.fields = this.form.get('render') || [];

        // update view
        this.update();
      }
    }

    /**
     * init dragula
     */
    initDragula () {
      // require dragula
      const dragula = require('dragula');
      const dotProp = require('dot-prop-immutable');

      // do dragula
      this.dragula = dragula(jQuery('.eden-dropzone', this.refs.form).toArray(), {
        'moves' : (el, container, handle) => {
          return (jQuery(el).is('[data-field]') || jQuery(el).closest('[data-field]').length) && (jQuery(handle).is('.move') || jQuery(handle).closest('.move').length) && (jQuery(handle).is('.move') ? jQuery(handle) : jQuery(handle).closest('.move')).attr('for') === jQuery(el).attr('data-field');
        }
      }).on('drop', (el, target, source, sibling) => {
        // get current form
        let form = jQuery(el).attr('form');

        // check target
        if (!target || !source || !el) return;

        // get fields of target
        let fields = [];

        // get positions
        let positions = (this.form.get('positions') || []).map(fix).filter((field) => field);

        // set moving on field
        positions = dotProp.set(positions, form + '.moving', true);

        // loop physical fields
        jQuery('> [data-field]', target).each((i, field) => {
          // set get from
          let getFrom = jQuery(field).attr('form');
          let gotField = dotProp.get(positions, getFrom);

          // return on no field
          if (!gotField) return;

          // clone field
          if (getFrom === form) {
            // clone field
            gotField = JSON.parse(JSON.stringify(gotField));

            // delete placing
            if (gotField.moving) delete gotField.moving;
          }

          // get actual field
          fields.push(gotField);
        });

        // remove logic
        this.updating = true;
        this.update();

        // set form
        if (jQuery(target).attr('data-form').length) {
          // set positions
          positions = dotProp.set(positions, jQuery(target).attr('data-form'), fields);
        } else {
          // set positions
          positions = fields;
        }

        // get positions
        positions = (positions || []).map(place).filter((field) => field);

        // update form
        this.form.set('positions', positions);

        // remove logic
        this.updating = false;
        this.update();

        // save
        this.saveForm(this.form);
      }).on('drag', (el, source) => {
        // add is dragging
        jQuery(this.refs.form).addClass('is-dragging');
      }).on('dragend', () => {
        // remove is dragging
        jQuery(this.refs.form).removeClass('is-dragging');
      }).on('over', function (el, container) {
        // add class
        jQuery(container).addClass('eden-field-over');
      }).on('out', function (el, container) {
        // remove class
        jQuery(container).removeClass('eden-field-over');
      });

      // on update
      this.on('updated', () => {
        // set containers
        this.dragula.containers = jQuery('.eden-dropzone', this.refs.form).toArray();
      });
    }

    /**
     * on update
     *
     * @type {update}
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // check type
      if ((opts.form || {}).id !== this.form.get('id') || opts.type !== this.type || !!opts.preview !== !!this.preview) {
        // set fields
        this.form.set('positions', []);

        // set type
        this.fields = (opts.form || {}).render || [];

        // trigger mount
        this.trigger('mount');
      }
    });

    /**
     * on mount
     *
     * @type {mount}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // init dragula
      if (!this.dragula && this.acl.validate('admin')) this.initDragula();

      // set form
      this.form = opts.form ? this.model('form', opts.form) : this.model('form', {});

      // check default
      if (opts.positions && !(this.form.get('positions') || []).length && !this.form.get('id')) {
        // set default
        this.form.set('positions', opts.positions);
        this.form.set('fields', (this.form.get('positions') || []).reduce(flatten, []));

        // save fields
        this.saveForm(this.form);
      }

      // set positions
      if (opts.type !== this.type || !!this.preview !== !!opts.preview) {
        // set position
        this.type    = opts.type;
        this.preview = !!opts.preview;

        // get positions
        let positions = this.form.get('positions') || [];

        // reset positions
        this.form.set('positions', []);

        // update
        this.update();

        // set positions again
        this.form.set('positions', positions);

        // update view again
        this.update();
      }

      // check fields
      if ((this.form.get('fields') || []).length !== this.fields.length) {
        // load fields
        this.loadFields();
      } else if (!(this.form.get('fields') || []).length && !(this.eden.get('positions') || {})[this.form.get('id')]) {
        // load fields
        this.loadFields();
      }

      // loads field
      socket.on('form.' + this.form.get('id') + '.field', (field) => {
        // get found
        let found = this.fields.find((b) => b.uuid === field.uuid);

        // check found
        if (!found) {
          // push
          this.fields.push(field);

          // return update
          return this.update();
        }

        // set values
        for (let key in field) {
          // set value
          found[key] = field[key];
        }

        // update
        this.update();
      });
    });
  </script>
</eden-fields>
