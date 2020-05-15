<field-textarea>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } get-fields={ getFields } get-element={ getElement } languages={ this.languages } onchange={ onChange } language={ this.language }>
    <yield to="body">
      <div if={ opts.field.i18n } each={ lng, i in opts.languages } hide={ i18n.lang() !== lng }>
        <validate type="textarea" group-class={ opts.field.group || 'form-group' } name="{ opts.field.uuid }[{ lng }]" label={ opts.field.label || 'Set Label' } data-value={ (opts.data.value || '')[lng] || opts.data.value } on-change={ opts.onChange } required={ opts.field.required } min-length={ (opts.field.validateLength || {}).min } max-length={ (opts.field.validateLength || {}).max } append="field-i18n" />
      </div>
      <validate if={ !opts.field.i18n } type="textarea" group-class={ opts.field.group || 'form-group' } name={ opts.field.uuid } label={ opts.field.label || 'Set Label' } data-value={ (opts.data.value || '')[opts.language] || opts.data.value } on-change={ opts.onChange } required={ opts.field.required } min-length={ (opts.field.validateLength || {}).min } max-length={ (opts.field.validateLength || {}).max } />
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('i18n');

    // get languages
    this.language  = this.i18n.lang();
    this.languages = this.eden.get('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());
    
    /**
     * return value
     *
     * @return {*}
     */
    val() {
      // get val
      if (opts.field.i18n) {
        // reduce value
        return this.languages.reduce((accum, language) => {
          // add to accum
          accum[language] = jQuery(`[name="${opts.field.uuid}[${language}]"]`, this.root).val();
          
          // return accum
          return accum;
        }, {});
      } else {
        // return non accumulated value
        return jQuery('textarea', this.root).val();
      }
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
      // check frontend
      if (!this.eden.frontend) return;
      
      // set language
      this.language = this.i18n.lang();
    });
    
  </script>
</field-textarea>
