<field-modal>
  <div class="modal fade add-field-modal" id="field-modal" tabindex="-1" role="dialog" ref="modal" aria-labelledby="field-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="field-modal-label">
            Select Field
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <ul class="list-group">
            <li each={ field, i in getFields() || [] } class={ 'list-group-item list-group-item-action flex-column align-items-start' : true, 'active' : isActive(field) } onclick={ onField }>
              <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">
                  { field.opts.title }
                </h5>
              </div>
              <p class="m-0">{ field.opts.description }</p>
            </li>
          </ul>
          
          <hr />
          
          <ul class="list-group">
            <li each={ field, i in getFields('structure') || [] } class={ 'list-group-item list-group-item-action flex-column align-items-start' : true, 'active' : isActive(field) } onclick={ onField }>
              <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">
                  { field.opts.title }
                </h5>
              </div>
              <p class="m-0">{ field.opts.description }</p>
            </li>
          </ul>
          
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="button" class={ 'btn btn-primary' : true, 'disabled' : !this.type || this.loading } disabled={ !this.type || this.loading } onclick={ onAddField }>
            { this.loading ? 'Adding field...' : (this.type ? 'Add field' : 'Select field') }
          </button>
        </div>
      </div>
    </div>
  </div>
  
  <script>
  
    /**
     * gets fields
     *
     * @return {*}
     */
    getFields (category) {
      // return sorted fields
      let rtn = (opts.fields || []).sort((a, b) => {
        // Return sort
        return ('' + a.opts.title).localeCompare(b.opts.title);
      });
      
      // check default
      if (category) {
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
      
      // return rtn
      return rtn;
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
</field-modal>
