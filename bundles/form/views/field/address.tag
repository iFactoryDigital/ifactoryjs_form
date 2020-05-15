<field-address>
  <field ref="field" is-input={ true } is-multiple={ true } name={ opts.name } class="field-container-inner" values={ this.value } data-value={ this.current } label-class={ opts.labelClass } has-field={ opts.hasField } on-new={ onNew } on-remove={ onRemove } on-item={ onItem } get-fields={ getFields } get-element={ getElement } loading={ this.loading } on-search={ onSearch } on-search-button={ onSearchButton } show-map={ this.showMap } on-show-map={ onShowMap } show-manual={ this.showManual } on-show-manual={ onShowManual } get-selected={ getSelected } on-manual-value={ onManualValue } >
    <yield to="body">
      <div class={ opts.field.group || 'form-group' }>
        <label for={ opts.field.uuid + '-geo' } class={ opts.labelClass }>
          { opts.field.label }
          <i if={ !opts.field.label }>Set Label</i>
        </label>

        <p if={ opts.hasField === false && opts.data.value }>
          <b if={ opts.name }>{ opts.name }</b><br if={ opts.name } />
          { opts.data.value.address || (opts.data.value.house_number + ' ' + opts.data.value.road) },<br />
          { opts.data.value.address2 || (opts.data.value.postcode + ' ' + (opts.data.value.neighbourhood || opts.data.value.suburb)) },<br />
          { opts.data.value.city }<span if={ opts.data.value.city }>, </span>{ opts.data.value.state }
        </p>

        <input type="hidden" ref="address" id="address-{opts.field.uuid}" name={ opts.field.uuid + '[address]' } />

        <div hide={ !opts.showMap && !opts.showManual } >
          <div class="address-map" ref="map" />
        </div>

        <div style={ 'display:none': !(opts.showManual && opts.hasField !== false) } >
          <div class="row">
            <div class="col-md-3 mb-3">
              <!-- <label for="address">Address</label> -->
              <input type="text" class="form-control" id="house_number-{opts.field.uuid}" ref="manual_house_number" placeholder="123" required="" onchange={ opts.onManualValue }>
              <div class="invalid-feedback">
                Please enter your street number.
              </div>
            </div>
            <div class="col-md mb-3">
              <!-- <label for="address">Address</label> -->
              <input type="text" class="form-control" id="road-{opts.field.uuid}" ref="manual_road" placeholder="Main St" required="" onchange={ opts.onManualValue }>
              <div class="invalid-feedback">
                Please enter your shipping address.
              </div>
            </div>
          </div>
          <div class="mb-3">
            <label for="address2">Address 2 <span class="text-muted">(Optional)</span></label>
            <input type="text" class="form-control" id="address2-{opts.field.uuid}" ref="manual_address2" placeholder="Apartment or suite" onchange={ opts.onManualValue }>
          </div>
          <div class="row">
            <div class="col-md mb-3">
              <label for="country">Country</label>
              <select class="custom-select d-block w-100" id="country-{opts.field.uuid}" required="" ref="manual_country" onchange={ opts.onManualValue }>
                <option value="">Choose...</option>
                <option value="Australia">Australia</option>
              </select>
              <div class="invalid-feedback">
                Please select a valid country.
              </div>
            </div>
            <div class="col-md mb-3">
              <label for="state">State</label>
              <select class="custom-select d-block w-100" id="state{opts.field.uuid}" required="" ref="manual_state" onchange={ opts.onManualValue }>
                <option value="">Choose...</option>
                <option value="Queensland">QLD </option>
                <option value="New South Wales">NSW</option>
                <option value="South Australia">SA</option>
                <option value="Tasmania">TAS</option>
                <option value="Victoria">VIC</option>
                <option value="Western Australia"} >WA</option>
                <option value="Australian Capital Territory">ACT</option>
                <option value="Northern Territory">NT</option>
              </select>
              <div class="invalid-feedback">
                Please provide a valid state.
              </div>
            </div>
            <div class="col-md mb-3">
              <label for="zip">Zip</label>
              <input type="text" class="form-control" id="zip{opts.field.uuid}" placeholder="" required="" ref="manual_postcode" onchange={ opts.onManualValue }>
              <div class="invalid-feedback">
                Zip code required.
              </div>
            </div>
            <div class="col-md-1 mb-3">
              <label>&nbsp;</label>
              <div class="btn-group d-flex">
                <button class={ 'btn' : true, 'btn-info' : !opts.showMap, 'btn-success' : opts.showMap } onclick={ opts.onShowMap } if={ this.showManual === false }  type="button">
                  <i class="fa fa-map-marked" />
                </button>
                <button class={ 'btn' : true, 'btn-info' : !opts.showManual, 'btn-success' : opts.showManual } onclick={ opts.onShowManual } type="button">
                  <i class="fa fa-pencil" />
                </button>
              </div>
            </div>
          </div>
        </div>

        <div class="input-group" style={ 'display:none': opts.showManual && opts.hasField !== false } hide={ opts.hasField === false || opts.showManual }>
          <input type="text" name={ opts.field.uuid + '[geo]' } ref="search" required={ opts.field.required } class={ opts.field.field || 'form-control' } placeholder="Enter Address" id={ opts.field.uuid + '-geo' } autocomplete="off">
          <div class="input-group-append">
            <div class="btn-group">
              <!--
              <button class={ 'btn btn-info' : true, 'disabled' : opts.loading() } onclick={ opts.loading() ? null : opts.onSearchButton } type="button" disabled={ opts.loading() } data-toggle="tooltip" title="Search for Address">
                <i class={ 'fa' : true, 'fa-search' : !opts.loading(), 'fa-spinner fa-spin' : opts.loading() } />
              </button>
              -->
              <button class={ 'btn' : true, 'btn-info' : !opts.showMap, 'btn-success' : opts.showMap } onclick={ opts.onShowMap } type="button" data-toggle="tooltip" title={ opts.showMap ? 'Hide Map' : 'Show Map' }>
                <i class="fa fa-map-marked" />
              </button>
              <button class={ 'btn' : true, 'btn-info' : !opts.showManual, 'btn-success' : opts.showManual } onclick={ opts.onShowManual } type="button" data-toggle="tooltip" title="Alter Address Manually">
                <i class="fa fa-pencil" />
              </button>
            </div>
          </div>

          <div class="btn-group ml-2" if={ opts.field.multiple }>
            <button class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <i class="fa fa-chevron-down" />
            </button>
            <div class="dropdown-menu dropdown-menu-right">
              <button each={ val, i in opts.values } class={ 'dropdown-item' : true, 'active' : val.id === (opts.dataValue || {}).id } onclick={ opts.onItem }>{ (val.formatted || '').length ? val .formatted.split(',').slice(0, 3).join(',') : 'N/A' }</button>
              <div class="dropdown-divider"></div>
              <button class="dropdown-item" onclick={ opts.onNew }>
                New Address
              </button>
            </div>
            <button class="btn btn-danger" onclick={ opts.onRemove } if={ opts.values.length > 1 }>
              <i class="fa fa-times" />
            </button>
          </div>
        </div>
      </div>
    </yield>
  </field>

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('loading');

    // require uuid
    const uuid = require('uuid');

    // set initial value
    this.value = (Array.isArray(opts.data.value || {}) ? opts.data.value : [opts.data.value]).filter(i => i);

    // check value
    if (!this.value.length) {
      // push empty value
      this.value.push({
        id : uuid(),
      });
    }

    // add ids
    this.value.forEach((val) => {
      // add uuid
      if (!val.id) val.id = uuid();
    });

    // set current
    this.current    = this.value[0];
    this.showMap    = !!this.current.map;
    this.showManual = !!this.current.manual;

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
     * on search button
     *
     * @param  {Event} e
     */
    onNew(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set current
      this.current = {
        id : uuid(),
      };

      // push value
      this.value.push(this.current);

      // set show map
      this.showMap = this.current.map;

      // update view
      this.update();
    }

    /**
     * on search button
     *
     * @param  {Event} e
     */
    onRemove(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set current
      this.value = this.value.filter(v => v.id !== this.current.id);

      // check length
      if (!this.value.length) {
        // push value
        this.value.push({
          id : uuid(),
        });
      }

      // set current
      this.current = this.value[0];

      // set show map
      this.showMap = this.current.map;

      // update view
      this.update();
    }

    /**
     * on search button
     *
     * @param  {Event} e
     */
    onItem(e) {
      // check frontend
      if (!this.eden.frontend) return;

      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set current
      this.current = e.item.val;

      // set show map
      this.showMap = this.current.map;

      // initialize
      this.initialize();

      jQuery('.select-address-customer option[value='+this.current.id+']').prop('selected', 'selected').trigger('change');

      // update view
      //this.update();
      this.update();
    }

    /**
     * on search button
     *
     * @param  {Event} e
     */
    onShowMap(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set show map
      this.showMap = !this.showMap;
      this.current.map = this.showMap;

      // update view
      this.update();
    }

    /**
     * on search button
     *
     * @param  {Event} e
     */
    onShowManual(e) {
      // prevent default
      if (e) {
        e.preventDefault();
        e.stopPropagation();
      }

      // set show map
      this.showManual = !this.showManual;

      // check value
      jQuery(this.refs.field.refs.manual_state).val(this.current.state ? this.current.state : '');
      jQuery(this.refs.field.refs.manual_country).val(this.current.country ? this.current.country : '');
      this.refs.field.refs.manual_road.value = this.current.road;
      this.refs.field.refs.manual_address2.value = this.current.address2 || [this.current.suburb || this.current.neighbourhood, this.current.hamlet].filter(i => i).join(', ');
      this.refs.field.refs.manual_postcode.value = this.current.postcode ? this.current.postcode : '';
      this.refs.field.refs.manual_house_number.value = this.current.house_number;

      // set show manual
      this.current.manual = this.showManual;


      // update view
      this.update();
    }

    /**
     * update state for manual
     */
    onManualValue(e) {
      // loop refs
      ['state', 'house_number', 'road', 'address2', 'country', 'state', 'postcode'].forEach((ref) => {
        // set values
        this.current[ref] = jQuery(`[ref="manual_${ref}"]`, this.root).val();
      });

      // set formatted
      this.current.formatted = `${this.current.house_number} ${this.current.road}, ${this.current.address2 || ''} ${this.current.state}, ${this.current.postcode}, ${this.current.country}`;

      // set field value
      this.refs.field.refs.search.value = this.current.formatted;

      // update view
      this.update();
    }

    /**
     * on search button
     *
     * @param  {Event} e
     */
    onSearchButton(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // get search
      return this.onSearch(e);
    }

    /**
     * on search
     *
     * @param  {Event} e
     */
    async onSearch(e) {
      // require leaflet
      const L = require('leaflet');

      // set value
      const value = this.refs.field.refs.search.value;

      // set loading
      this.loading('geocode', true);

      // do search
      const res = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(value)}&countrycodes=AU&addressdetails=1&limit=10`);
      const data = await res.json();

      // set address
      const address = data.length === 1 ? data[0] : data[0];

      // reset loading
      if (!address) return this.loading('geocode', false);

      // check data
      Object.assign(this.current, {
        map    : true,
        manual : false,
        coords : {
          lat : address.lat,
          lng : address.lon,
        },
        formatted : address.display_name,

        ...(address.address),
      });

      // set view
      this.map.setView([this.current.coords.lat, this.current.coords.lng], 16);

      // remove marker
      if (this.marker) this.map.removeLayer(this.marker);

      // add marker
      this.marker = L.marker([this.current.coords.lat, this.current.coords.lng], {
        draggable : true,
      }).addTo(this.map);

      // set values
      this.marker._icon.src = '/public/assets/maps/marker-icon.png';
      this.marker._shadow.src = '/public/assets/maps/marker-shadow.png';

      // reset loading
      this.loading('geocode', false);

      // set show
      this.showMap = true;
      this.showManual = false;

      // update view
      this.update();
    }

    /**
     * renders location input
     */
    initialize () {
      // require leaflet
      const L = require('leaflet');

      // set map
      this.map = this.map || L.map(this.refs.field.refs.map).setView((this.current || {}).coords ? [this.current.coords.lat, this.current.coords.lng] : [-27.472895, 153.017990], (this.current || {}).coords ? 16 : 13);

      // remove marker
      if (this.marker) this.map.removeLayer(this.marker);

      // add marker
      if ((this.current || {}).coords) {
        // add marker
        this.marker = L.marker([this.current.coords.lat, this.current.coords.lng], {
          draggable : true,
        }).addTo(this.map);

        // initialize
        this.initializeMarker();

        // set values
        this.marker._icon.src = '/public/assets/maps/marker-icon.png';
        this.marker._shadow.src = '/public/assets/maps/marker-shadow.png';

        // set view
        this.map.setView([this.current.coords.lat, this.current.coords.lng], 16);
      } else {
        // add marker
        this.marker = L.marker([-27.472895, 153.017990], {
          draggable : true,
        }).addTo(this.map);

        // initialize
        this.initializeMarker();

        // set values
        this.marker._icon.src = '/public/assets/maps/marker-icon.png';
        this.marker._shadow.src = '/public/assets/maps/marker-shadow.png';

        // set view
        this.map.setView([-27.472895, 153.017990], 16);
      }

      // use OSM
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution : '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map);

      // setup widget
      this.widget = new AddressFinder.Widget(
        // Replace with the id of your search field
        this.refs.field.refs.search,
        // Replace with your license key
        'BDJ8AVRLT3QHM7KGNUCE',
        'AU',
        {

        }
      );

      // on result
      this.widget.on('result:select', (fullAddress, meta) => {
        // set value
        this.refs.field.refs.search.value = meta.full_address;

        // check data
        Object.assign(this.current, {
          ...meta,

          map           : true,
          road          : meta.street,
          state         : meta.state_territory,
          manual        : false,
          country       : 'AU',
          postcode      : parseInt(meta.postcode),
          formatted     : meta.full_address,
          house_number  : meta.street_number_1,
          coords : {
            lat : parseFloat(meta.latitude),
            lng : parseFloat(meta.longitude),
          },
        });

        // set view
        this.map.setView([this.current.coords.lat, this.current.coords.lng], 16);

        // remove marker
        if (this.marker) this.map.removeLayer(this.marker);

        // add marker
        this.marker = L.marker([this.current.coords.lat, this.current.coords.lng], {
          draggable : true,
        }).addTo(this.map);

        // initialize
        this.initializeMarker();

        // set values
        this.marker._icon.src = '/public/assets/maps/marker-icon.png';
        this.marker._shadow.src = '/public/assets/maps/marker-shadow.png';

        // update view
        this.update();
      });
    }

    initializeMarker() {
      // on drag
      this.marker.on('drag', (e) => {
        // set current
        this.current.coords = {
          lat : parseFloat(this.marker.getLatLng().lat),
          lng : parseFloat(this.marker.getLatLng().lng),
        };

        // update view
        this.update();
      });
    }

    updateAddressSelect() {
      if(jQuery('.select-address-customer').length > 0 && (!jQuery('.select-address-customer').val() || jQuery('.select-address-customer').val() === 'Select Address')) {
        jQuery('.select-address-customer option[value='+this.current.id+']').prop('selected', 'selected').trigger('change');
        jQuery('.delivery-grid select option[value="'+this.current.id+'"]').prop('selected', 'selected').trigger('change');
      }
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // render location
      this.initialize();

      // do tooltips
      jQuery('body > .tooltip').remove();
      jQuery('[data-toggle="tooltip"]').tooltip();

      // set values
      this.refs.field.refs.address.value = JSON.stringify(this.value);

      //if manual is set, update value from manual field
      if (this.showManual) {
        // set false
        this.showManual = false;

        // do on show manual
        this.onShowManual();
      }

      // set search field value
      if (this.refs.field.refs.search) {
        // set search value
        this.refs.field.refs.search.value = (this.current || {}).formatted || '';
      }
      let _id = this.current.id;
      if(jQuery('.select-address-customer').length > 0 && (!jQuery('.select-address-customer').val() || jQuery('.select-address-customer').val() === 'Select Address')) {
        setTimeout(function() {
          jQuery('.select-address-customer option[value='+_id+']').prop('selected', 'selected').trigger('change');
          jQuery('.delivery-grid select option[value="'+_id+'"]').prop('selected', 'selected').trigger('change');
        }, 300);
      }
    });

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('updated', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // render location
      if (this.map) this.map.invalidateSize();

      // do tooltips
      jQuery('body > .tooltip').remove();
      jQuery('[data-toggle="tooltip"]').tooltip();

      // set values
      this.refs.field.refs.address.value = JSON.stringify(this.value);

      // set search field value
      if (this.refs.field.refs.search) {
        this.refs.field.refs.search.value = (this.current || {}).formatted || '';
      }
      this.updateAddressSelect();
    });

  </script>
</field-address>
