<field-row>
  <field ref="field" class="field-row-inner" on-row-class={ onRowClass } on-center-vertically={ onCenterVertically } get-fields={ getFields } get-element={ getElement }>
    <yield to="body">
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        Row #{ opts.placement }
      </span>
      <eden-add type="top" onclick={ opts.onAddField } way="unshift" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      
      <div class="{ opts.field.row || 'row row-eq-height' } { this.acl.validate('admin') && !opts.preview ? 'eden-dropzone' : '' } { 'empty' : !opts.getFields(opts.field.children).length }" data-placement={ opts.placement + '.children' }>
        <div if={ !opts.getFields(opts.field.children).length } class="col py-5 text-center">Add Elements</div>
        <div if={ opts.field.centerVertically } each={ child, a in opts.getFields(opts.field.children) } no-reorder class="{ child.class || 'col' } d-flex align-items-center" data-field={ child.uuid } placement={ opts.placement + '.children.' + a }>
          <div data-is={ opts.getElement(child) } class="w-100" preview={ opts.preview } data={ opts.getField(child) } field={ child } get-field={ opts.getField } on-add-field={ opts.onAddField } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.children.' + a } />
        </div>
        <div if={ !opts.field.centerVertically } each={ child, a in opts.getFields(opts.field.children) } no-reorder class={ child.class || 'col' } data-is={ opts.getElement(child) } preview={ opts.preview } data-field={ child.uuid } data={ opts.getField(child) } field={ child } helper={ opts.helper } get-field={ opts.getField } on-add-field={ opts.onAddField } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } on-update={ opts.onUpdate } i={ a } placement={ opts.placement + '.children.' + a } />
      </div>
      
      <eden-add type="bottom" onclick={ opts.onAddField } way="push" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      <span class="eden-dropzone-label eden-dropzone-label-end" if={ this.acl.validate('admin') && !opts.preview }>
        Row #{ opts.placement } End
      </span>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Row Class
        </label>
        <input class="form-control" ref="row" value={ opts.field.row || 'row' } onchange={ opts.onRowClass } />
      </div>
      <div class="form-group">
        <label>
          Center Vertically
        </label>
        <select class="form-control" ref="center" onchange={ opts.onCenterVertically }>
          <option value="true" selected={ opts.field.centerVertically }>Yes</option>
          <option value="false" selected={ !opts.field.centerVertically }>No</option>
        </select>
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
    async onRowClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.row = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }
    
    /**
     * center vertically
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async onCenterVertically (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.centerVertically = jQuery(e.target).val() === 'true';

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }
    
  </script>
</field-row>
