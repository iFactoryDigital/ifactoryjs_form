<field-boolean>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } get-fields={ getFields } get-element={ getElement } on-change={ onChange }>
    <yield to="body">
      <validate type="boolean" group-class={ opts.field.group || 'form-group' } name={ opts.field.uuid } label={ opts.field.label || 'Set Label' } data-value={ opts.data.value } required={ opts.field.required } on-change={ opts.onChange } />
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
      return jQuery('input', this.root).val() === 'true';
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
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      
    });
    
  </script>
</field-boolean>
