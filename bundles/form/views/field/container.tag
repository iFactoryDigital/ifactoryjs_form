<field-container>
  <field ref="field" class="field-container-inner" is-container={ true } on-container-class={ onContainerClass } get-fields={ getFields } get-element={ getElement }>
    <yield to="body">
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        Container #{ opts.placement }
      </span>
      <eden-add type="top" onclick={ opts.onAddField } way="unshift" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      
      <div class="{ opts.field.container || 'container' } { this.acl.validate('admin') && !opts.preview ? 'eden-dropzone' : '' } { 'empty' : !opts.getFields(opts.field.children).length }" data-placement={ opts.placement + '.children' }>
        <div if={ !opts.getFields(opts.field.children).length } class="py-5 text-center">Add Elements</div>
        <div each={ child, a in opts.getFields(opts.field.children) } no-reorder class={ child.class } data-is={ opts.getElement(child) } preview={ opts.preview } data-field={ child.uuid } data={ opts.getField(child) } field={ child } helper={ opts.helper } get-field={ opts.getField } on-add-field={ opts.onAddField } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.children.' + a } />
      </div>
      
      <eden-add type="bottom" onclick={ opts.onAddField } way="push" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      <span class="eden-dropzone-label eden-dropzone-label-end" if={ this.acl.validate('admin') && !opts.preview }>
        Container #{ opts.placement } End
      </span>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Container Class
        </label>
        <input class="form-control" ref="container" value={ opts.field.container || 'container' } onchange={ opts.onContainerClass } />
      </div>
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');
    
    // set value
    if (!opts.field.children) opts.field.children = [];
    
    /**
     * get fields
     *
     * @param  {Array} fields
     *
     * @return {Array}
     */
    getFields (fields) {
      // return filtered fields
      return (fields || []).filter((child) => child);
    }
    
    /**
     * get element
     *
     * @param  {Object} child
     *
     * @return {*}
     */
    getElement (child) {
      // return get child
      return (opts.getField(child) || {}).tag ? 'field-' + (opts.getField(child) || {}).tag : 'eden-loading';
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onContainerClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.container = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }
    
  </script>
</field-container>
