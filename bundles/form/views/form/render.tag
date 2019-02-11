<form-render>
  <form ref="form" method={ opts.method || 'post' } action={ opts.action || '/form/submit' } class="form-render form-{ opts.placement.split('.').join('-') }">
    <div class="form-render-fields" data-form={ opts.placement } ref="fields" data-is="eden-fields" fields={ this.getFields() } preview={ opts.preview } form={ getForm() } on-save={ onSave } id={ opts.placement } positions={ opts.positions } />
  </form>

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
      forms[opts.placement] = form.get();

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
      return opts.form || ((this.eden.get('forms') || {})[opts.placement] ? this.eden.get('forms')[opts.placement] : {
        'placement' : opts.placement
      });
    }
    
    /**
     * submit form
     *
     * @return {*}
     */
    submit () {
      // submit form
      return jQuery(this.refs.form).submit();
    }

  </script>
</form-render>
