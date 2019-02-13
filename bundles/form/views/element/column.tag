<element-column>
  <div data-is="element-{ opts.column.meta.data.tag }" field={ opts.column.meta.field } data={ getData() } />
  
  <script>
    
    /**
     * get data
     *
     * @return {*}
     */
    getData() {
      // return object assign
      return Object.assign({}, opts.column.meta, {
        value : opts.dataValue
      });
    }
  </script>
</element-column>
