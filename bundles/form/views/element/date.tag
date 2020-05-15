<element-date>
  <span>
    <span if={ opts.data.value }>{ getDate(opts.data.value) }</span>
    <i if={ !opts.data.value }>N/A</i>
  </span>
  <script>
    // require moment
    const moment = require('moment');
    
    /**
     * get date
     *
     * @param  {Date} date
     *
     * @return {*}
     */
    getDate(date) {
      // return date
      if (opts.field.fromNow) {
        // set from
        return moment(date).fromNow();
      }
      
      // return moment format
      return moment(date).format(opts.field.format || 'LLL');
    }
  </script>
</element-date>
