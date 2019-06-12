<field-sidebar>
  <div class="eden-blocks-backdrop" if={ this.showing } onclick={ hide } />
  <div class={ 'eden-blocks-sidebar' : true, 'eden-blocks-sidebar-show' : this.showing }>
    <div class="card">
      <div class="card-header">
        <h5>
          Select Field
        </h5>
        
        <ul class="nav nav-tabs card-header-tabs">
          <li class="nav-item" each={ tab, i in getTabs() }>
            <button class={ 'nav-link' : true, 'active' : isTab(tab) } onclick={ onTab }>
              { this.t('cms.category.' + tab) }
            </button>
          </li>
        </ul>
      </div>

      <div class="card-body">
        <div class="form-group">
          <input class="form-control" placeholder="search" type="Search" onkeyup={ onSearch } onchange={ onSearch } ref="search" />
        </div>
        
        <ul class="list-group">
          <li each={ field, i in getFields(this.tab) || [] } class={ 'list-group-item list-group-item-action flex-column align-items-start' : true, 'active' : isActive(field) } onclick={ onField }>
            <div class="d-flex w-100 justify-content-between">
              <h5 class="mb-1">
                { field.opts.title }
              </h5>
            </div>
            <p class="m-0">{ field.opts.description }</p>
          </li>
        </ul>
        
      </div>
      <div class="card-footer">
        <button type="button" class="btn btn-secondary float-right" onclick={ hide }>Close</button>
        <button type="button" class={ 'btn btn-primary' : true, 'disabled' : !this.type || this.loading } disabled={ !this.type || this.loading } onclick={ onAddField }>
          { this.loading ? 'Adding field...' : (this.type ? 'Add field' : 'Select field') }
        </button>
      </div>
    </div>
  </div>
  
  <script>
    // do i189n
    this.mixin('i18n');

    // set showing
    this.tab = 'default';
    this.showing = false;

    /**
     * Shows sidebar
     */
    show() {
      // set showing
      this.showing = true;

      // update
      this.update();
    }

    /**
     * Shows sidebar
     */
    hide() {
      // set showing
      this.showing = false;

      // update
      this.update();
    }
    
    /**
     * on block
     *
     * @param  {Event} e
     */
    onTab (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // activate block
      this.tab = e.item.tab;
      
      // update view
      this.update();
    }

    /**
     * on block
     *
     * on search
     */
    onSearch(e) {
      // check search
      this.search = this.refs.search.value;
      
      // update view
      this.update();
    }
    
    /**
     * on field
     *
     * @param  {Event} e
     */
    onField (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // activate field
      this.type = e.item.field.type || e.item.field.tag;
      
      // update view
      this.update();
    }

    /**
     * on field
     *
     * @param  {Event} e
     */
    async onAddField (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.loading = true;
      
      // update view
      this.update();
      
      // add field by type
      await opts.addField(this.type);
      
      // set loading
      this.type    = null;
      this.loading = false;
      
      // update view
      this.update();
      
      // close modal
      jQuery(this.refs.modal).modal('hide');
    }
  
    /**
     * gets fields
     *
     * @return {*}
     */
    getFields (category = 'default') {
      // return sorted fields
      let rtn = (opts.fields || []).sort((a, b) => {
        // Return sort
        return ('' + a.opts.title).localeCompare(b.opts.title);
      });
      
      // check default
      if (category !== 'default') {
        rtn = rtn.filter((field) => {
          // set category
          return (field.opts.categories || []).includes(category);
        });
      } else {
        rtn = rtn.filter((field) => {
          // check categories
          return !(field.opts.categories);
        });
      }

      // do block search
      if (this.search && this.search.length) rtn = rtn.filter((field) => {
        // check search
        return ('' + field.opts.title).toLowerCase().includes(this.search.toLowerCase());
      });
      
      // return rtn
      return rtn;
    }

    /**
     * gets tabs
     */
    getTabs() {
      // return categories
      return (opts.fields || []).reduce((accum, field) => {
        // loop categories
        (field.opts.categories || []).forEach((category) => {
          // add category
          if (!accum.includes(category)) accum.push(category);
        });

        // return accumulator
        return accum;
      }, ['default']);
    }
    
    /**
     * on is active
     *
     * @param  {Object}  block
     *
     * @return {Boolean}
     */
    isTab (tab) {
      // return type
      return this.tab === tab;
    }
    
    /**
     * on is active
     *
     * @param  {Object}  field
     *
     * @return {Boolean}
     */
    isActive (field) {
      // return type
      return this.type === field.type;
    }
    
  </script>
</field-sidebar>
