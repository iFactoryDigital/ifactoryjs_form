<form-submit-child-file>
  <div class="form-group form-group-file">
    <label>
      { opts.child.name }
    </label>
    <table class="table table-sm table-striped table-hover">
      <thead>
        <tr>
          <th></th>
          <th>ID</th>
          <th>Name</th>
          <th>Size</th>
        </tr>
      </thead>
      <tbody>
        <tr each={ file, i in this.value }>
          <td>
            <i class={ 'fa ' + renderIcon (file.name) } />
            <input type="hidden" if={ file.id } name={ this.name () + '[' + i + ']' } value={ file.id }>
          </td>
          <td>{ file.id || 'Uploading ' + file.uploaded + '%' }</td>
          <td>
            <a if={ file.id } href={ '//' + this.config.domain + this.media.url (file) } target="_blank">
              { file.name }
            </a>
            { file.id ? '' : file.name }
          </td>
          <td>{ renderBytes (file.size) }</td>
        </tr>
      </tbody>
    </table>
    <label class="custom-file">
      <input type="file" ref="file" onchange={ onUpload } class="custom-file-input" id={ this.name (true) + '-input' } name={ this.name (true) + '-input' } multiple={ opts.child.data.multiple }>
      <span class="custom-file-control"></span>
    </label>
  </div>

  <script>
    // add mixins
    this.mixin ('uuid');
    this.mixin ('media');
    this.mixin ('child');
    this.mixin ('input');
    this.mixin ('config');

    // set value
    this.value = (opts.child.value || []).filter ((val) => val);

    // require dependencies
    let bytes = require ('bytes');
    let types = require ('font-awesome-filetypes');

    /**
     * renders bytes
     *
     * @param  {Integer} b
     *
     * @return {String}
     */
    renderBytes (b) {
      // return render bytes
      return bytes (b);
    }

    /**
     * renders icon
     *
     * @param  {String} n
     *
     * @return {String}
     */
    renderIcon (n) {
      // return icon
      return types.getClassNameForExtension (n.split ('.').pop ());
    }

    /**
     * upload function
     *
     * @param {Event} e
     *
     * @private
     */
    onUpload (e) {
      // check files
      if (e.target.files.length === 0) {
        // alert
        return eden.alert.alert ('error', 'Please set files');
      }

      // loop files
      for (var i = 0; i < e.target.files.length; i++) {
        // set file
        let fl = e.target.files[i];

        // create new reader
        let fr = new FileReader ();

        // onload
        fr.onload = () => {
          // let value
          let value = {
            'src'      : fr.result,
            'file'     : fl,
            'name'     : fl.name,
            'size'     : fl.size,
            'temp'     : this.uuid (),
            'thumb'    : fr.result,
            'uploaded' : 0
          };

          // add to value
          this.value.push (value);

          // do upload
          this._ajaxUpload (value);

          // update view
          this.update ();
        };

        // read file
        fr.readAsDataURL (fl);
      }
    }

    /**
     * ajax upload function
     *
     * @param {Object} value
     *
     * @private
     */
    _ajaxUpload (value) {
      // let change
      this.change = this.uuid ();

      // set change
      let change = this.change;

      // create form data
    	let data = new FormData ();

      // append image
    	data.append ('file', value.file);
      data.append ('temp', value.temp);

      // submit ajax form
    	jQuery.ajax ({
        'url'         : '/upload/file',
        'xhr'         : () => {
          // get the native XmlHttpRequest object
          var xhr = jQuery.ajaxSettings.xhr ();

          // set the onprogress event handler
          xhr.upload.onprogress = (evt) => {
            // log progress
            let progress = (evt.loaded / evt.total) * 100;

            // set progress
            value.uploaded = progress;

            // update
            this._update (value);
          };

          // return the customized object
          return xhr;
        },
        'data'        : data,
        'type'        : 'post',
        'cache'       : false,
        'error'       : () => {
          // do error
          eden.alert.alert ('error', 'Error uploading image');

          // remove from array
          this._remove (value);
        },
        'success'     : (data) => {
          // empty file upload
          if (change === this.change) {
            // reset file
            if (this.refs.file) this.refs.file.value = null;
          }

          // check if error
          if (data.error) {
            // do message
            return eden.alert.alert ('error', data.message);
          }

          // check if image
          if (data.file) this._update (data.file);
        },
        'dataType'    : 'json',
        'contentType' : false,
        'processData' : false
      });
    }

    /**
     * updates value
     *
     * @param {Value} val
     */
    _update (val) {
      // let id
      let id = val.id;

      // check uuid
      if (val.temp) id = val.temp;

      // loop values
      for (var i = 0; i < this.value.length; i++) {
        // check value
        if (this.value[i].id === id || this.value[i].temp === id) {
          // set value
          this.value[i] = val;

          // return update
          return this.update ();
        }
      }
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on ('mount', () => {
      // check if frontend
      if (!this.eden.frontend) return;

    });
  </script>
</form-submit-child-file>
