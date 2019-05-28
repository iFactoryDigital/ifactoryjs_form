<field-date>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } get-fields={ getFields } get-element={ getElement } on-min-length={ onMinLength } on-max-length={ onMaxLength } on-change={ onChange } on-start-year={ onStartYear } on-end-year={ onEndYear }>
    <yield to="body">
      <validate type="date" ref="date" start-year={ opts.field.startYear } end-year={ opts.field.endYear } group-class={ opts.field.group || 'form-group' } name={ opts.field.uuid } label={ opts.field.label || 'Set Label' } data-value={ opts.data.value } required={ opts.field.required } min-length={ (opts.field.validateLength || {}).min } max-length={ (opts.field.validateLength || {}).max } on-change={ opts.onChange } />
    </yield>
    
    <yield to="validation">
    
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Start Year
        </label>
        <input class="form-control" ref="start-year" value={ opts.field.startYear || (new Date()).getFullYear() } onchange={ opts.onStartYear } />
      </div>
      <div class="form-group">
        <label>
          End Year
        </label>
        <input class="form-control" ref="end-year" value={ opts.field.endYear || ((new Date()).getFullYear() - 80) } onchange={ opts.onEndYear } />
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
      return this.refs.field.refs.date.val();
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
    async onStartYear (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.startYear = parseInt(e.target.value.length ? e.target.value : (new Date()).getFullYear());

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onEndYear (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.endYear = parseInt(e.target.value.length ? e.target.value : ((new Date()).getFullYear() - 80));

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      
    });
    
  </script>
</field-date>
