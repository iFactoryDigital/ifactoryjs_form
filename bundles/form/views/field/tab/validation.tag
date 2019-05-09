<field-tab-validation>
  <div class="field-settings">
    <div if={ opts.isInput }>
      <div class="form-group">
        <label>
          Required
        </label>
        <select class="form-control" onchange={ onRequired }>
          <option value="true" selected={ opts.field.required }>Yes</option>
          <option value="false" selected={ !opts.field.required }>No</option>
        </select>
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
    async onRequired (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.required = jQuery(e.target).val() === 'true';

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }
  
  </script>
</field-tab-validation>
