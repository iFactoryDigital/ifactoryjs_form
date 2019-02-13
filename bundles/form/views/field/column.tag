<field-column>
  <div class="row">
    <div class="col">
      <div data-is="field-{ opts.column.meta.field.tag }" field={ getField() } data={ getData() } preview={ true } class="field-column" ref="field" />
    </div>
    <div class="col-2 pl-0">
      <button class={ 'btn btn-block btn-success' : true, 'loading' : this.loading } onclick={ onSave } disabled={ this.loading }>
        <i class="fa { this.loading ? 'fa-spinner fa-spin' : 'fa-check' }" />
      </button>
    </div>
  </div>

  <script>
  
    /**
     * on save
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onSave(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.loading = true;
      
      // update view
      this.update();
      
      // save
      if (opts.onSave) opts.onSave(opts.row, opts.column, this.refs.field.val());
    }
    
    /**
     * get data
     *
     * @return {*}
     */
    getField() {
      // return object assign
      return Object.assign({}, opts.column.meta.field, {

      });
    }
    
    /**
     * get data
     *
     * @return {*}
     */
    getData() {
      // return object assign
      return Object.assign({}, opts.column.meta.data, {
        label : null,
        value : opts.dataValue
      });
    }
  </script>
</field-column>
