<field>
  <div class={ 'eden-field eden-block' : true, 'eden-field-admin eden-block-admin' : this.acl.validate('admin') && !opts.preview } data-field={ opts.field.uuid } id="field-{ opts.field.uuid }">

    <div class="eden-field-hover eden-block-hover{ opts.isContainer ? ' eden-block-hover-dropzone' : '' }" if={ this.acl.validate('admin') && !opts.preview }>
      <div class="row row-eq-height">
        <div class="col-8 d-flex align-items-center">
          <div class="w-100">
            <yield from="header" />
          </div>
        </div>
        <div class="col-4 d-flex align-items-center">
          <div class="w-100">
            <div class="btn-group float-right">
              <yield from="buttons" />
              <button class="btn btn-sm btn-secondary" onclick={ onUpdateModal }>
                <i class="fa fa-pencil" />
              </button>
              <button class="btn btn-sm btn-secondary" onclick={ onRemoveModal } if={ !opts.field.force }>
                <i class={ 'fa fa-times' : true, 'fa-spin' : this.removing || opts.field.removing } />
              </button>
              <span class="btn btn-sm btn-secondary move" for={ opts.field.uuid }>
                <i class="fa fa-arrows" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div show={ shouldShow() }>
      <yield from="body" />
    </div>
  </div>

  <div class="modal fade" ref="update" id="field-{ opts.field.uuid }-update" tabindex="-1" role="dialog" aria-labelledby="field-{ opts.field.uuid }-label" aria-hidden="true" if={ this.modal.update && this.acl.validate('admin') && !opts.preview }>
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">
            Update Field
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
        
          <div class="form-group">
            <label>
              Name
            </label>
            <input class="form-control" ref="name" value={ opts.field.name } onchange={ onName } />
          </div>

          <yield from="modal" />
        
        </div>
        
        <div class="modal-footer d-block">
          
          <nav class="nav nav-tabs mb-4">
            <a each={ tab, i in this.tabs } class={ 'nav-item nav-link' : true, 'active' : isTab(tab) } href="#" onclick={ onTab }>{ tab }</a>
          </nav>
          
          <div data-is="field-tab-{ tab.toLowerCase() }" field={ opts.field } data={ opts.data } is-input={ opts.isInput } is-multiple={ opts.isMultiple } on-save={ opts.onSave } i18n={ opts.i18n || opts.language } />
          
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" ref="remove" id="field-{ opts.field.uuid }-remove" tabindex="-1" role="dialog" aria-labelledby="field-{ opts.field.uuid }-label" aria-hidden="true" if={ this.modal.remove && this.acl.validate('admin') && !opts.preview }>
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">
            Remove Field
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          Are you sure you want to remove this field?
        </div>
        <div class="modal-footer">
          <button class={ 'btn btn-danger float-right' : true, 'disabled' : this.removing } onclick={ onRemove } disabled={ this.removing }>
            { this.removing ? 'Removing...' : 'Remove' }
          </button>
        </div>
      </div>
    </div>
  </div>

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('i18n');
    this.mixin('field');

    // set variables
    this.tabs = opts.tabs || ['Display', 'Validation', 'Visibility', 'Events'];
    this.modal = {};
    this.loading = {};
    this.updating = {};
      
    // set tab
    this.tab = this.tabs[0];
    
  
    /**
     * on display
     *
     * @param {Event} e
     */
    async onName (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.field.name = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.field, opts.data, opts.placement, true);
    }

    /**
     * on update modal

     * @param  {Event} e
     */
    onUpdateModal (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      this.modal.update = true;

      // update view
      this.update();

      // run opts
      jQuery(this.refs.update).modal('show');
    }

    /**
     * on remove modal

     * @param  {Event} e
     */
    onRemoveModal (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      this.modal.remove = true;

      // update view
      this.update();

      // run opts
      jQuery(this.refs.remove).modal('show');
    }

    /**
     * on refresh
     *
     * @param  {Event} e
     */
    async onRemove (e) {
      // set refreshing
      this.removing = true;

      // update view
      this.update();

      // run opts
      if (opts.onRemove) await opts.onRemove(opts.field, opts.data, opts.placement);

      // set refreshing
      this.removing = false;

      // update view
      this.update();
    }

    /**
     * should show
     *
     * @return {*}
     */
    shouldShow() {
      // should show
      if (opts.shouldShow) return opts.shouldShow();

      // return true
      if (!opts.field.visible || !opts.field.visible.length) return true;

      // check preview
      if (!opts.preview) return true;

      // bind to this
      const fn = new Function(`return ${opts.field.visible}`);

      // bind function
      fn.bind(this);

      // set should
      return fn.call(this);
    }
    
    /**
     * is tab
     *
     * @param  {String} tab
     *
     * @return {Boolean}
     */
    isTab(tab) {
      // return is tab
      return this.tab === tab;
    }

    /**
     * on tab
     *
     * @param  {Event} e
     * @return {*}
     */
    onTab(e) {
      // set tab
      this.tab = e.item.tab;
      
      // update view
      this.update();
    }
    
    /**
     * on field
     *
     * @param  {Event} e
     * @return {*}
     */
    field() {
      // return field
      return opts.field;
    }
    
    /**
     * on data
     *
     * @param  {Event} e
     * @return {*}
     */
    data() {
      // return field
      return opts.data;
    }


    // on mount add helper update listener
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // on update
      if (opts.field.display) opts.helper.on('update', this.update);
    });

    // on unmount function
    this.on('unmount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // remove modal backdrops
      jQuery('.modal-backdrop').remove();

      // on update
      if (opts.field.display) opts.helper.removeListener('update', this.update);
    });
  </script>
</field>
