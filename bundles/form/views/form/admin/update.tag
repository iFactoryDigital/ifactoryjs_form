<form-admin-update-page>
  <admin-header title="{ this.form.get('id') ? 'Update' : 'Create' } Form { this.form.get('title.' + this.language) }" on-preview={ onPreview }>
    <yield to="right">

      <a href="/admin/form" class="btn btn-lg btn-primary">
        Back
      </a>

    </yield>
  </admin-header>

  <div class="container-fluid">

    <div ref="form" class="admin-form" show={ !this.preview }>
      <div class="card mb-3">
        <div class="card-header">
          Form Information
        </div>
        <div class="card-header">
          <ul class="nav nav-tabs card-header-tabs">
            <li each={ lng, i in this.languages } class="nav-item">
              <a class={ 'nav-link' : true, 'active' : this.language === lng } href="#!" data-lng={ lng } onclick={ onLanguage }>{ lng }</a>
            </li>
          </ul>
        </div>
        <div class="card-body">
          <div class="form-group">
            <label for="title">Form Title</label>
            <input type="text" id="title" name="title[{ lng }]" class="form-control" value={ (form.get('title') || {})[lng] } data-input="title.{ lng }" hide={ this.language !== lng } each={ lng, i in this.languages } onchange={ onSlug }>
          </div>
          <div class="form-group">
            <label for="slug">Form Slug</label>
            <input type="text" id="slug" name="slug" class="form-control" ref="slug" data-input="slug" value={ form.get('slug') } onchange={ onInput }>
          </div>
          <div class="form-group">
            <label for="layout">Form Layout</label>
            <input type="text" id="layout" name="layout" class="form-control" ref="layout" data-input="layout" value={ form.get('layout') } onchange={ onInput }>
          </div>
        </div>

      </div>
    </div>

    <div class="cms-placement-fields" data-placement={ (opts.item || {}).id || 'form' } data-is="eden-fields" model={ true } form={ true } for="frontend" fields={ opts.fields } on-save={ onForm } type={ (opts.item || {}).id || 'form' } />

  </div>

  <script>
    // do mixins
    this.mixin('i18n');
    this.mixin('model');

    // set update
    this.type     = opts.type;
    this.form     = this.model('form', opts.item);
    this.loading  = {};
    this.updating = {};

    // load data
    this.language  = this.i18n.lang();
    this.languages = this.eden.get('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());

    /**
     * on preview
     *
     * @param  {Event} e
     */
    onInput (e) {
      // save form
      this.saveForm(this.form);
    }

    /**
     * on language
     *
     * @param  {Event} e
     */
    onLanguage (e) {
      // set language
      this.language = e.target.getAttribute('data-lng');

      // update view
      this.update();
    }

    /**
     * set slug
     *
     * @param  {Event} e
     */
    onSlug (e) {
      // require slug
      let slug = require('slug');

      // set slug
      this.refs.slug.value = slug(e.target.value).toLowerCase();

      // save form
      this.saveForm(this.form);
    }

    /**
     * saves form
     *
     * @param  {Object}  form
     *
     * @return {Promise}
     */
    async saveForm (form) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!form.type) form.set('type', opts.type);

      // set input values
      jQuery('[data-input]', this.refs.form).each((i, elem) => {
        // set value
        form.set(jQuery(elem).attr('data-input'), jQuery(elem).val());
      });

      // log data
      let res = await fetch('/admin/form/' + (form.get('id') ? form.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(this.form.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();
      
      // check if new form
      if (!form.get('id') && data.result.id) {
        // change url
        let state = Object.assign({}, {
          'prevent' : true
        }, eden.router.history.location.state);
        
        // replace state
        eden.router.history.replace({
          'state'    : state,
          'pathname' : '/admin/form/' + data.result.id + '/update'
        });
      }

      // set logic
      for (let key in data.result) {
        // clone to form
        form.set(key, data.result[key]);
      }

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }


    /**
     * on update
     *
     * @type {update}
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set language
      this.language = this.i18n.lang();

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
      this.form = this.model('form', opts.item);
      
      // set to placements
      if (this.form.id) this.eden.set('placements.' + this.form.id, this.form.get('placement'));

    });
  </script>
</form-admin-update-page>
