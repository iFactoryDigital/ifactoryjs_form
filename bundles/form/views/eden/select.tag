<eden-select>
  <select class="selectpicker form-control" name={ opts.name } multiple={ opts.multiple } ref="select">
    <yield />
  </select>

  <script>
    // set initialized
    this.initialized = false;

    /**
     * check should update
     */
    shouldUpdate(data) {
      // check initialized
      return !this.initialized;
    }
    
    /**
     * return value
     *
     * @return {*}
     */
    val() {
      // return value
      return jQuery(this.refs.select).val();
    }

    /**
     * on mount function
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend || this.initialized) return;

      // require logic
      require('bootstrap-select/js/bootstrap-select.js');

      // do select 2
      jQuery(this.refs.select).selectpicker({
        liveSearch : true
      });

      // ajax
      if (opts.url) {
        // require ajax
        require('ajax-bootstrap-select/dist/js/ajax-bootstrap-select.min.js');

        // add ajax logic
        jQuery(this.refs.select).ajaxSelectPicker({
          ajax : {
            url  : opts.url,
            type : 'GET',
            data : () => {
              // create params
              const params = {
                q   : '{{{q}}}',
                data: opts.data ? opts.data : ''
              };

              // return params
              return params;
            },
            dataType : 'json',
          },
          locale : {
            emptyTitle : opts.label
          },
          emptyRequest : true,
        }).on('change', (e) => {
          // on change
          if (opts.onChange) opts.onChange(e);
        });
      }
    });
  </script>
</eden-select>
