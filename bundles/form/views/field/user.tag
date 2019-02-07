<form-submit-child-user>
  <div class="form-group">
    <label for={ this.name (true) + '-input' }>
      { opts.child.name }
    </label>
    <input-select name={ this.name () } id={ this.name (true) + '-input' } select={ select () } />
  </div>

  <script>
    this.mixin ('child');

    /**
     * returns options array
     */
    select () {
      // set initial options
      let options = opts.child.data || {};

      // set data
      options.data = (opts.child.value || []).filter ((obj) => obj);

      // check array
      if (!Array.isArray (options.data)) options.data = [options.data];

      // filter dat
      options.data = options.data.filter ((obj) => obj);

      // set required
      options.required = opts.child.required;

      // set val
      options.val = (options.data && options.data.filter ? options.data : []).filter ((item) => item).map ((item) => {
        // return id
        return item.id;
      });

      // set ajax
      options.ajax = {
        'url'            : '/form/user/list',
        'data'           : (params) => {
          // return data
          return {
            'q'    : params.term, // search term
            'page' : params.page
          };
        },
        'cache'          : true,
        'dataType'       : 'json',
        'processResults' : (data, params) => {
          // parse the results into the format expected by Select2
          // since we are using custom formatting functions we do not need to
          // alter the remote JSON data, except to indicate that infinite
          // scrolling can be used
          params.page = params.page || 1;

          // return processed results
          return {
            'results'    : data.items,
            'pagination' : {
              'more' : (params.page * 30) < data.total_count
            }
          };
        }
      };

      // return options
      return options
    }
  </script>
</form-submit-child-user>
