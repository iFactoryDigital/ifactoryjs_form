<field-select>
  <field ref="field" is-input={ true } class="field-select-inner" on-option={ onOption } on-remove-option={ onRemoveOption } on-option-name={ onOptionName } on-option-save={ onOptionSave } language={ this.language } languages={ languages } on-change={ onChange }>
    <yield to="body">
      <validate type="select" options={ opts.field.options } group-class={ opts.field.group || 'form-group' } name={ opts.field.uuid } label={ opts.field.label || 'Set Label' } data-value={ (opts.data.value || '')[opts.language] || opts.data.value } required={ opts.field.required } on-change={ opts.onChange } />
    </yield>

    <yield to="modal">
      <div each={ option, i in opts.field.options } class="form-group">
        <label>
          Option #{ i + 1 }
        </label>
        <div class="input-group">
          <input type="text" name="option[{ i }]" value={ option.value } class="form-control" onchange={ opts.onOptionName } />
          <div class="input-group-append" onclick={ opts.onRemoveOption }>
            <button class="btn btn-danger">
              <i class="fa fa-times" />
            </button>
          </div>
        </div>
      </div>
      <button class="btn btn-success mr-3" onclick={ opts.onOption }>
        Add Option
      </button>
      <button class="btn btn-success" onclick={ opts.onOptionSave }>
        Save Options
      </button>
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
      // return non accumulated value
      return jQuery('input', this.root).val();
    }

    /**
     * on change
     *
     * @param {Event} e
     */
    onChange(e) {
      
    }

    /**
     * on option
     *
     * @param {Event} e
     */
    onOption(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // add option
      if (!opts.field.options) opts.field.options = [];

      // add option
      opts.field.options.push({
        label : '',
        value : '',
      });

      // update view
      this.update();
    }

    /**
     * on option name
     *
     * @param {Event} e
     */
    onOptionName(e) {
      // set value
      e.item.option.label = e.target.value;
      e.item.option.value = e.target.value;
    }

    /**
     * on option save
     *
     * @param  {Event}  e
     * @return {Promise}
     */
    async onOptionSave(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on option
     *
     * @param {Event} e
     */
    onRemoveOption(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // remove option
      opts.field.options.splice(e.item.i, 1);

      // update view
      this.update();
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
</field-select>
