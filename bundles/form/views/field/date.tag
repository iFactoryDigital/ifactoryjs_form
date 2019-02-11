<form-submit-child-date>
  <div class="form-group">
    <input type="hidden" name={ this.name () + '[iso]' } value={ this.date.toISOString () } />
    <div class="input-group date">
      <input type="text" name={ this.name () + '[input]' } required={ opts.child.required } ref="date" class={ 'form-control' : true, 'form-control-active' : true } id={ this.name (true) + '-input' } />
      <label for={ this.name (true) + '-input' }>
        { opts.child.name }
      </label>
      <div class="input-bar"></div>
      <span class="input-group-addon">
        <i class="fa fa-date"></i>
      </span>
    </div>
  </div>

  <script>
    // do mixins
    this.mixin('child');
    this.mixin('input');

    // set date
    try {
      this.date = new Date(opts.data.value || new Date());
    } catch (e) {}

    // set date
    if (!this.date || isNaN(this.date)) this.date = new Date();

    /**
     * on change function
     *
     * @param {Event} e
     */
    onChange (e) {
      // get full String
      var date = new Date (jQuery (this.refs.date).datetimepicker ('date'));

      // set date
      this.date = date;

      // update view
      this.update ();
    }

    /**
     * on mount function
     *
     * @type {String} mount
     */
    this.on ('mount', () => {
      // check if jQuery is defined
      if (typeof jQuery !== 'undefined') {
        // mask date input
        window.dateinput = jQuery (this.refs.date).datetimepicker ({
          'icons'       : {
            'up'   : "fa fa-arrow-up",
            'time' : "fa fa-clock-o",
            'date' : "fa fa-calendar",
            'down' : "fa fa-arrow-down"
          },
          'format'      : 'DD-MM-YYYY LT',
          'defaultDate' : this.date
        }).on ('dp.change', this.onChange);
      }
    });
  </script>
</form-submit-child-date>
