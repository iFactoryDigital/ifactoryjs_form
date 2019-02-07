<form-render>
  <div class="form-render form-{ opts.form.split('.').join('-') }">
    <div class="form-render-fields" data-form={ opts.form } ref="fields" data-is="eden-fields" fields={ this.getFields() } form={ getForm() } on-save={ onSave } id={ opts.form } />
  </div>

  <script>
    // mixin acl
    this.mixin('acl');
    this.mixin('model');

    // is update
    this.isUpdate = false;

    /**
     * on save forms
     *
     * @return {Model}
     */
    onSave (form) {
      // get forms
      let forms = this.eden.get('forms') || {};

      // set form
      forms[opts.form] = form.get();

      // set forms
      this.eden.set('forms', forms);
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onToggleUpdate (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.isUpdate = !this.isUpdate;

      // update
      this.update();
    }

    /**
     * add load fields function
     *
     * @return {*}
     */
    loadFields () {
      // return internal proxied
      return this.refs.fields.loadFields(...arguments);
    }

    /**
     * gets fields
     *
     * @return {Array}
     */
    getFields () {
      // check for fields
      return this.eden.get('fields') || [];
    }

    /**
     * returns form
     *
     * @return {Object}
     */
    getForm () {
      // return form
      return (this.eden.get('forms') || {})[opts.form] ? this.eden.get('forms')[opts.form] : {
        'id' : opts.form
      };
    }

  </script>
</form-render>
