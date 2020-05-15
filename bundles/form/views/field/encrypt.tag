<field-encrypt>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } get-fields={ getFields } get-element={ getElement } on-min-length={ onMinLength } on-max-length={ onMaxLength } on-change={ onChange }>
    <yield to="body">
      <validate type="password" group-class={ opts.field.group || 'form-group' } name={ opts.field.uuid } label={ opts.field.label || 'Set Label' } data-value={ opts.data.value } required={ opts.field.required } min-length={ (opts.field.validateLength || {}).min } max-length={ (opts.field.validateLength || {}).max } on-change={ opts.onChange } />
    </yield>
    
    <yield to="validation">
      <div class="form-group">
        <label>
          Min Length
        </label>
        <input class="form-control" type="number" ref="min-length" value={ (opts.field.validateLength || {}).min } onchange={ opts.onMinLength } />
      </div>
      <div class="form-group">
        <label>
          Max Length
        </label>
        <input class="form-control" type="number" ref="min-length" value={ (opts.field.validateLength || {}).max } onchange={ opts.onMaxLength } />
      </div>
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');
    
    /**
     * return value
     *
     * @return {*}
     */
    val() {
      // get val
      return jQuery('input', this.root).val();
    }

    /**
     * on change
     *
     * @param {Event} e
     */
    onChange(e) {
      // set value
      opts.data.value = this.val();

      // emit update
      opts.helper.emit('update');
    }
    
    /**
     * on class

     * @param  {Event} e
     */
    async onMinLength (e) {
      // check validate length
      if (!opts.field.validateLength) opts.field.validateLength = {};

      // set class
      opts.field.validateLength.min = e.target.value.length ? parseInt(e.target.value) : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }
    
    /**
     * on class

     * @param  {Event} e
     */
    async onMaxLength (e) {
      // check validate length
      if (!opts.field.validateLength) opts.field.validateLength = {};

      // set class
      opts.field.validateLength.max = e.target.value.length ? parseInt(e.target.value) : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }
    

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      
    });
    
  </script>
</field-encrypt>
