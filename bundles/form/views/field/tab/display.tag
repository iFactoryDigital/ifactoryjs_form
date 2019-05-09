<field-tab-display>
  <div class="tab-display">
  
    <div class="form-group" if={ opts.isInput }>
      <label>
        Label
      </label>
      <input class="form-control" ref="label" value={ opts.field.label } onchange={ onLabel } />
    </div>
    
    <div class="form-group" if={ opts.isMultiple }>
      <label>
        Multiple Values
      </label>
      <select class="form-control" onchange={ onAllowMultiple }>
        <option value="true" selected={ opts.field.multiple }>Yes</option>
        <option value="false" selected={ !opts.field.multiple }>No</option>
      </select>
    </div>
    
    <div class="form-group">
      <label>
        Container Class
      </label>
      <input class="form-control" ref="class" value={ opts.field.class } onchange={ onClass } />
    </div>
    
    <div if={ opts.isInput }>
      <div class="form-group">
        <label>
          Group Class
        </label>
        <input class="form-control" ref="group" value={ opts.field.group || 'form-group' } onchange={ onGroupClass } />
      </div>
      <div class="form-group">
        <label>
          Input Class
        </label>
        <input class="form-control" ref="field" value={ opts.field.field || 'form-control' } onchange={ onFieldClass } />
      </div>
      
      <div if={ opts.i18n }>
        <div class="form-group">
          <label>
            Enable i18n
          </label>
          <select class="form-control" onchange={ onLanguage }>
            <option value="true" selected={ opts.field.i18n }>Yes</option>
            <option value="false" selected={ !opts.field.i18n }>No</option>
          </select>
        </div>
      </div>
    </div>
    
  </div>
  
  <script>

    /**
     * on class

     * @param  {Event} e
     */
    async onLabel (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.label = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }

    /**
     * on class

     * @param {Event} e
     */
    async onClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.class = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onGroupClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.group = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onFieldClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.field = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }

    /**
     * on allow multiple
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async onAllowMultiple (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.multiple = jQuery(e.target).val() === 'true';

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }

    /**
     * on allow multiple
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async inI18n (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.i18n = jQuery(e.target).val() === 'true';

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }
  
  </script>
</field-tab-display>
