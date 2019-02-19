<field-text>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } get-fields={ getFields } get-element={ getElement } on-min-length={ onMinLength } on-max-length={ onMaxLength } language={ this.language } languages={ languages }>
    <yield to="body">
      <div if={ opts.field.i18n } each={ lng, i in opts.languages } hide={ i18n.lang() !== lng }>
        <validate type="text" group-class={ opts.field.group || 'form-group' } name="{ opts.field.uuid }[{ lng }]" label={ opts.field.label || 'Set Label' } data-value={ (opts.data.value || '')[lng] || opts.data.value } required={ opts.field.required } min-length={ (opts.field.validateLength || {}).min } max-length={ (opts.field.validateLength || {}).max } append="field-i18n" />
      </div>
      <validate if={ !opts.field.i18n } type="text" group-class={ opts.field.group || 'form-group' } name={ opts.field.uuid } label={ opts.field.label || 'Set Label' } data-value={ (opts.data.value || '')[opts.language] || opts.data.value } required={ opts.field.required } min-length={ (opts.field.validateLength || {}).min } max-length={ (opts.field.validateLength || {}).max } />
    </yield>

    <yield to="validate">
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
        return jQuery('input', this.root).val();
      }
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
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set product
      this.language = this.i18n.lang();
    });

  </script>
</field-text>
