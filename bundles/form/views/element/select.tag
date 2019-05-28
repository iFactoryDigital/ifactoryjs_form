<element-select>
  <span>
    { getValue() }
  </span>

  <script>

    /**
     * gets value
     *
     * @return {*}
     */
    getValue() {
      // get value
      const values = (Array.isArray(opts.data.value) ? opts.data.value : [opts.data.value]).filter(i => i);

      // return labels
      return values.map(v => (opts.field.options.find(val => val.value === v) || {}).label).join(', ');
    }
  </script>
</element-select>
