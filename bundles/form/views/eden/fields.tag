<eden-fields>
  <div ref="form" class="eden-fields eden-blocks">

    <div class="{ 'eden-dropzone' : this.acl.validate('admin') && !opts.preview } { 'empty' : !getFields().length }" ref="form" data-placement="" if={ !this.updating }>
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        { this.form.get('title') || this.form.get('placement') }
      </span>
      
      <eden-add type="top" onclick={ onAddField } way="unshift" form="" if={ this.acl.validate('admin') && !opts.preview } />
      <div each={ el, i in getFields() } el={ el } no-reorder class={ el.class } data-is={ getElement(el) } preview={ this.preview } data-field={ el.uuid } data={ getField(el) } field={ el } helper={ this.helper } get-field={ getField } on-add-field={ onAddField } on-save={ this.onSaveField } on-remove={ onRemoveField } on-refresh={ this.onRefreshField } on-update={ onUpdate } placement={ i } i={ i } />
      <eden-add type="bottom" onclick={ onAddField } way="push" form="" if={ this.acl.validate('admin') && !opts.preview } />
    </div>
  </div>

  <field-modal fields={ opts.fields } add-field={ onSetField } />

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('model');
    this.mixin('fields');

    // require uuid
    const uuid = require('uuid');

    // set update
    this.form     = opts.form ? (opts.model ? this.parent.form : this.model('form', opts.form)) : this.model('form', {});
    this.type     = opts.type;
    this.fields   = (opts.form || {}).render || [];
    this.loading  = {};
    this.preview  = !!opts.preview;
    this.updating = false;

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
      let found = this.fields.find((b) => b.uuid === field.uuid || (field.name && b.name && field.name === b.name));

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
      return (this.form.get('positions') || []).map(this.filter.fix).filter((field) => field);
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
      this.fieldPos = target.attr('placement');

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
      this.form.set('positions', (this.form.get('positions') || []).map(this.filter.replace(fieldClone)));
      this.form.set('fields', (this.form.get('positions') || []).reduce(this.filter.flatten, []));

      // save form
      await this.saveForm(preventUpdate);

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
      let positions = (this.form.get('positions') || []).map(this.filter.fix).filter((field) => field);

      // set moving on field
      positions = dotProp.set(positions, form + '.removing', true);

      // get positions
      this.form.set('positions', positions.map(this.filter.place).filter((field) => field));
      this.form.set('fields', (this.form.get('positions') || []).reduce(this.filter.flatten, []));

      // save form
      await this.saveForm();
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
      this.form.set('fields', (this.form.get('positions') || []).reduce(this.filter.flatten, []));

      // save form
      await this.onSaveField(field, {});

      // update view
      this.update();
    }

    /**
     * adds field by type
     *
     * @param  {String} type
     *
     * @return {*}
     */
    async onUpdate () {
      // update view
      this.update();
    }

    /**
     * saves form
     *
     * @return {Promise}
     */
    async saveForm (preventRefresh) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!this.form.type) this.form.set('type', opts.type);

      // log data
      let res = await fetch('/form/' + (this.form.get('id') ? this.form.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(this.form.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // set logic
      for (let key in data.result) {
        // clone to form
        this.form.set(key, data.result[key]);

        // set in opts
        if (opts.form && data.result[key] && !opts.model) opts.form[key] = data.result[key];
      }
      
      // set fields
      const missing = (this.form.get('render') || []).filter((field) => !this.fields.find((f) => f.uuid === field.uuid));
      
      // push missing fields
      this.fields.push(...missing);
      
      // set forms
      if (!window.eden.forms) window.eden.forms = {};

      // set in eden
      window.eden.forms[this.form.get('id')] = data.result;

      // on save
      if (opts.onSave) opts.onSave(this.form);

      // set loading
      this.loading.save = false;

      // update view
      if (!preventRefresh) {
        this.helper.update();
      } else {
        this.update()
      }
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

      // return on loading fields
      if (this.loading.fields) return;

      // require query string
      const qs = require('querystring');

      // set opts
      opts = qs.stringify(opts);

      // set loading
      this.loading.fields = true;

      // update view
      this.update();

      // log data
      let res = await fetch((this.form.get('id') ? '/form/' + this.form.get('id') + '/view' : '/form/create') + (opts.length ? '?' + opts : ''), {
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
        // set forms
        if (!window.eden.forms) window.eden.forms = {};
          
        // set in eden
        window.eden.forms[this.form.get('id')] = data.result;

        // set fields
        for (let key in data.result) {
          // set key
          this.form.set(key, data.result[key]);
        }
        
        // set fields
        const missing = (this.form.get('render') || []).filter((field) => !this.fields.find((f) => f.uuid === field.uuid));
        
        // push missing fields
        this.fields.push(...missing);

        // set loading
        this.loading.fields = false;

        // update view
        this.helper.update();
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
        let placement = jQuery(el).attr('placement');

        // check target
        if (!target || !source || !el) return;

        // get fields of target
        let fields = [];

        // get positions
        let positions = (this.form.get('positions') || []).map(this.filter.fix).filter((field) => field);

        // set moving on field
        positions = dotProp.set(positions, placement + '.moving', true);

        // loop physical fields
        jQuery('> [data-field]', target).each((i, field) => {
          // set get from
          let getFrom = jQuery(field).attr('placement');
          let gotField = dotProp.get(positions, getFrom);

          // return on no field
          if (!gotField) return;

          // clone field
          if (getFrom === placement) {
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
        if (jQuery(target).attr('data-placement').length) {
          // set positions
          positions = dotProp.set(positions, jQuery(target).attr('data-placement'), fields);
        } else {
          // set positions
          positions = fields;
        }

        // get positions
        positions = (positions || []).map(this.filter.place).filter((field) => field);

        // update form
        this.form.set('positions', positions);

        // remove logic
        this.updating = false;
        this.update();

        // save
        this.saveForm();
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
      if (this.helper.hasChange()) {
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

      // set form
      this.form = opts.form ? (opts.model ? this.parent.form : this.model('form', opts.form)) : this.model('form', {});

      // init dragula
      if (!this.dragula && this.acl.validate('admin')) this.initDragula();

      // set default positions
      if (opts.positions && !(this.form.get('positions') || []).length && !this.form.get('id')) {
        // set default
        this.form.set('positions', opts.positions);
        this.form.set('fields', (this.form.get('positions') || []).reduce(this.filter.flatten, []));

        // save fields
        this.saveForm();
      }

      // set positions
      if (this.helper.hasChange()) {
        // set position
        this.type    = opts.type;
        this.preview = !!opts.preview;

        // force update
        this.helper.update();
      }

      // check fields
      if (this.helper.shouldLoad()) {
        // load fields
        this.loadFields();
      }
    });
  </script>
</eden-fields>
