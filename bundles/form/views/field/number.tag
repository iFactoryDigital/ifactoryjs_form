<field-number>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } value={ this.value } get-fields={ getFields } get-element={ getElement }>
    <yield to="body">
      <div class={ opts.field.group || 'form-group' }>
        <label for={ opts.field.uuid }>
          { opts.field.label }
          <i if={ !opts.field.label }>Set Label</i>
        </label>
        <input type="number" name={ opts.field.uuid } required={ opts.field.required } class="{ opts.field.field || 'form-control' }{ 'form-control-active' : false }" id={ opts.field.uuid } value={ opts.value } />
      </div>
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      
    });
    
  </script>
</field-number>
