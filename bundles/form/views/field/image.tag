<form-submit-child-image>
  <div class="form-group form-group-image">
    <div class="row row-eq-height mx-0">
      <div each={ file, i in this.value } class="col col-lg-3 form-group-image px-1 mb-2">
        <a class="card" href={ src (file) } style="background-image : url({ thumb (file) });" data-title={ file.name } data-gallery={ this.name (true) } onclick={ onGallery }>
          <input type="hidden" if={ file.id } name={ this.name () + '[' + i + ']' } value={ file.id } class="file-input">
          <div class="progress" if={ typeof file.uploaded !== 'undefined' }>
            <div class="progress-bar bg-success" role="progressbar" style="width : { file.uploaded }%;" aria-valuenow={ file.uploaded } aria-valuemin="0" aria-valuemax="100"></div>
          </div>
        </a>
      </div>
      <div class="col col-lg-3 form-group-upload px-1 mb-2" if={ opts.child.data.multiple || !this.value.length }>
        <label class="card card-upload" for={ this.name (true) + '-input' }>
          <input type="file" ref="file" id={ this.name (true) + '-input' } name={ this.name (true) + '-input' } class="file-input" multiple={ opts.child.data.multiple }>
          <div class="d-flex align-items-center">
            <div>
              <fa i={ 'plus' } />
              <div class="upload-label" class="mt-2">
                Upload Image
              </div>
            </div>
          </div>
        </label>
      </div>
    </div>
  </div>

  <script>
    // add mixins
    this.mixin ('uuid');
    this.mixin ('child');
    this.mixin ('input');
    this.mixin ('media');

    // set value
    this.value  = opts.child.value || [];
    this.change = false;

    /**
     * src of file
     *
     * @param {Object} file
     */
    src (file) {
      // return thumb if exists
      if (!file.id) return file.src;

      // return file
      return this.media.url (file);
    }

    /**
     * thumb of file
     *
     * @param {Object} file
     */
    thumb (file) {
      // return thumb if exists
      if (file.thumb) return file.thumb;

      // return file
      return this.media.url (file, 'sm');
    }

    /**
     * on gallery function
     *
     * @param {Event} e
     */
    onGallery (e) {
      // prevent default
      e.preventDefault ();
      e.stopPropagation ();

      // get target
      let target = jQuery (e.target);

      // check target
      target = target.is ('a') ? target : target.closest ('a');

      // do gallery
      target.ekkoLightbox ();
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
     * remove value from upload
     *
     * @param {Object} val
     *
     * @private
     */
    _remove (val) {
      // let id
      let id = val.id;

      // check uuid
      if (val.temp) id = val.temp;

      // loop values
      for (var i = 0; i < this.value.length; i++) {
        // check value
        if (this.value[i].id === id || this.value[i].temp === id) {
          // set value
          this.value.splice (i, 1);

          // return update
          return this.update ();
        }
      }
    }

    /**
     * upload function
     *
     * @param {Event} e
     *
     * @private
     */
    _upload (e) {
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
      data.append ('temp',  value.temp);
    	data.append ('image', value.file);

      // submit ajax form
    	jQuery.ajax ({
        'url'         : '/upload/image',
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
          if (data.image) this._update (data.image);
        },
        'dataType'    : 'json',
        'contentType' : false,
        'processData' : false
      });
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on ('mount', () => {
      // check if frontend
      if (!this.eden.frontend) return;

      // on change
      jQuery (this.refs.file).change (this._upload);
    });
  </script>
</form-submit-child-image>
