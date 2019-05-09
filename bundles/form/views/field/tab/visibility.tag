<field-tab-visibility>
  <div class="tab-visibility">
    <div class="form-group">
      <label>
        Visibility
      </label>
      <input class="form-control" ref="visible" value={ opts.field.visible || 'true' } onchange={ onVisible } />
    </div>
  </div>
  
  <script>
  

    /**
     * on display
     *
     * @param {Event} e
     */
    async onVisible (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.visible = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }
  </script>
</field-tab-visibility>
