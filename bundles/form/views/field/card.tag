<field-card>
  <field ref="field" class="field-card-inner h-100" is-container={ true } on-card-class={ onCardClass } on-card-body-class={ onCardBodyClass } on-card-title={ onCardTitle } on-card-desc={ onCardDesc } get-fields={ getFields } get-element={ getElement }>
    <yield to="body">
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        Card #{ opts.placement }
      </span>
      <eden-add type="top" onclick={ opts.onAddField } way="unshift" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />

      <div class="{ opts.field.card || 'card' } { 'empty' : !opts.getFields(opts.field.children).length }">
        <div class="card-header" if={ (opts.field.title || '').length }>{ opts.field.title }</div>
        <div class="card-desc" if={ (opts.field.desc || '').length }>{ opts.field.desc }</div>
        <div class="{ opts.field.body || 'card-body' } { this.acl.validate('admin') && !opts.preview ? 'eden-dropzone' : '' }" data-placement={ opts.placement + '.children' }>
          <div if={ !opts.getFields(opts.field.children).length } class="py-5 text-center">Add Elements</div>
          <div each={ child, a in opts.getFields(opts.field.children) } no-reorder class={ child.class } data-is={ opts.getElement(child) } preview={ opts.preview } data-field={ child.uuid } data={ opts.getField(child) } field={ child } helper={ opts.helper } get-field={ opts.getField } on-add-field={ opts.onAddField } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } on-update={ opts.onUpdate } i={ a } placement={ opts.placement + '.children.' + a } />
        </div>
      </div>
      
      <eden-add type="bottom" onclick={ opts.onAddField } way="push" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      <span class="eden-dropzone-label eden-dropzone-label-end" if={ this.acl.validate('admin') && !opts.preview }>
        Card #{ opts.placement } End
      </span>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Card Title
        </label>
        <input class="form-control" ref="title" value={ opts.field.title } onchange={ opts.onCardTitle } />
      </div>
      <div class="form-group">
        <label>
          Card Desc
        </label>
        <input class="form-control" ref="desc" value={ opts.field.desc } onchange={ opts.onCardDesc } />
      </div>
      <div class="form-group">
        <label>
          Card Class
        </label>
        <input class="form-control" ref="card" value={ opts.field.card || 'card' } onchange={ opts.onCardClass } />
      </div>
      <div class="form-group">
        <label>
          Card Body Class
        </label>
        <input class="form-control" ref="body" value={ opts.field.body || 'card-body' } onchange={ opts.onCardBodyClass } />
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
    async onCardTitle(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.title = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onCardDesc(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.desc = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onCardClass(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.card = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onCardBodyClass(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.body = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement);
    }
    
  </script>
</field-card>
