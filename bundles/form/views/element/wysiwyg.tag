<element-wysiwyg>
  <span>
    <span if={ opts.data.value }>
      <raw data={ { html : getValue() } } />
    </span>
    <i if={ !opts.data.value }>N/A</i>
  </span>
  
  <script>
    // i18n
    this.mixin('i18n');
    
    /**
     * return value
     *
     * @return {*}
     */
    getValue() {
      // return value
      return typeof (opts.data.value || '')[this.i18n.lang()] !== 'undefined' ? (opts.data.value || '')[this.i18n.lang()] : opts.data.value;
    }
    
  </script>
</element-wysiwyg>
