<field-tab-events>
  <div class="field-settings">
    <div if={ opts.isInput }>
      <div class="form-group">
        <label>
          On Change
        </label>
        <input class="form-control" ref="change" value={ opts.field.change || '' } onchange={ onChange } />
      </div>
    
      <yield from="validate" />
    </div>
  </div>
  
  <script>

    /**
     * on allow multiple
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async onChange (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.change = e.target.value;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }
  
  </script>
</field-tab-events>
