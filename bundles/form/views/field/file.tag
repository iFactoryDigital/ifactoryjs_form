<field-file>
  <field ref="field" is-input={ true } class="field-container-inner" on-input={ onInput } is-multiple={ true } get-fields={ getFields } get-element={ getElement } on-col={ onCol }>
    <yield to="body">
      <div class="form-group">
        <label for={ opts.field.uuid }>
          { opts.field.label }
          <i if={ !opts.field.label }>Set Label</i>
        </label>
        <upload name={ opts.field.uuid } multi={ opts.field.multiple } image={ opts.data.value } col={ opts.field.col } type="file" show-type={ opts.field.input || 'input' } />
      </div>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Field Column
        </label>
        <input class="form-control" ref="col" value={ opts.field.col } onchange={ opts.onCol } />
      </div>
      <div class="form-group">
        <label>
          Input Type
        </label>
        <select class="form-control" ref="input" value={ opts.field.input } onchange={ opts.onInput }>
          <option value="box">Boxed</option>
          <option value="input">Input</option>
        </select>
      </div>
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');

    /**
     * on class

     * @param  {Event} e
     */
    async onCol(e) {
      // set class
      opts.field.col = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onInput(e) {
      // set class
      opts.field.input = jQuery(e.target).val();

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
</field-file>
