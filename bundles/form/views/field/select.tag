<form-submit-child-select>
  <div class="form-group">
    <label for={ this.name (true) + '-input' }>
      { opts.child.name }
    </label>
    <input-select name={ this.name () } id={ this.name (true) + '-input' } select={ select () } />
  </div>

  <script>
    this.mixin ('child');

    /**
     * returns select data
     */
    select () {
      // set data
      let options = opts.child.data;

      // set required
      options.required = opts.child.required;

      // set data
      options.data = (options.data || []);

      // check is array
      if (!Array.isArray (opts.child.value)) opts.child.value = [opts.child.value];

      // filter value
      opts.child.value = (opts.child.value || []).filter ((obj) => obj);

      // set value
      if (opts.child.value && opts.child.value.length) {
        // loop data
        options.data = options.data.map ((obj) => {
          // check if selected
          obj.selected = (opts.child.value || []).filter ((obj) => obj).indexOf (obj.id || obj.temp) > -1;

          // return obj
          return obj;
        });
      }

      // return options
      return options;
    }
  </script>
</form-submit-child-select>
