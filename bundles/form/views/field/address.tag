<form-submit-child-address>
  <div class="form-group">
    <div class="input-group">
      <input type="hidden" name={ this.name () + '[address]' } value={ JSON.stringify (this.value) } />
      <input type="text" name={ this.name () + '[geo]' } required={ opts.child.required } class={ 'form-control' : true, 'form-control-active' : this.input (this.name () + '[geo]') } id={ this.name (true) + '[geo]' } value={ (opts.child.value || {}).formatted || '' }>
      <label for={ this.name (true) + '-geo' }>
        { this.label }
      </label>
      <div class="input-bar"></div>
    </div>
  </div>

  <script>
    // use mixins
    this.mixin ('child');
    this.mixin ('input');

    // set address
    this.label = opts.child.name;
    this.value = opts.child.value || {};

    /**
     * renders location input
     */
    _location () {
      // let input
      let input = jQuery ('input[type="text"]', this.root);
      let index = input.attr ('data-index');

      // build geocomplete
      input.geocomplete ().on ('geocode:result', (e, result) => {
        // set values
        this.value = {
          'id'         : result.id,
          'geo'        : {
            'lat' : result.geometry.location.lat (),
            'lng' : result.geometry.location.lng ()
          },
          'formatted'  : result.formatted_address,
          'components' : result.address_components
        };

        // update view
        this.update ();
      });
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on ('mount', () => {
      // check jQuery
      if (typeof jQuery !== 'undefined') {
        // render location
        this._location ();
      }
    });
  </script>
</form-submit-child-address>
