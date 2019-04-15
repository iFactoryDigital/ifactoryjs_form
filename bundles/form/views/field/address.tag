<field-address>
  <field ref="field" is-input={ true } class="field-container-inner" value={ this.value } get-fields={ getFields } get-element={ getElement }>
    <yield to="body">
      <div class={ opts.field.group || 'form-group' }>
        <label for={ opts.field.uuid + '-geo' }>
          { opts.field.label }
          <i if={ !opts.field.label }>Set Label</i>
        </label>
        <input type="hidden" name={ opts.field.uuid + '[address]' } value={ JSON.stringify(opts.value) } />
        <input type="text" name={ opts.field.uuid + '[geo]' } required={ opts.field.required } class="{ opts.field.field || 'form-control' }{ 'form-control-active' : false }" id={ opts.field.uuid + '-geo' } value={ (opts.value || {}).formatted || '' }>
      </div>
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');
    
    // set initial value
    this.value = opts.data.value;
    
    /**
     * return value
     *
     * @return {*}
     */
    val() {
      // get val
      return this.value;
    }

    /**
     * renders location input
     */
    initialize () {
      // let input
      let input = jQuery('input[type="text"]', this.root);
      let index = input.attr('data-index');

      // build geocomplete
      input.geocomplete().on('geocode:result', (e, result) => {
        // set values
        this.value = {
          'id'  : result.id,
          'geo' : {
            'lat' : result.geometry.location.lat(),
            'lng' : result.geometry.location.lng()
          },
          'formatted'  : result.formatted_address,
          'components' : result.address_components
        };

        // update view
        this.update();
      });
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      // check jQuery
      if (typeof jQuery !== 'undefined') {
        // render location
        this.initialize();
      }
    });
    
  </script>
</field-address>
