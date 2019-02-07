<form-submit-child-textarea>
  <div class="form-group">
    <div class="input-group">
      <textarea name={ this.name () } id={ this.name (true) + '-input' } value={ (opts.child || {}).value || '' } required={ opts.child.required || false } class={ 'form-control' : true, 'form-control-active' : this.input (this.name ()) } rows="5"></textarea>
      <label for={ this.name (true) + '-input' }>
        { opts.child.name }
      </label>
      <div class="input-bar"></div>
    </div>
  </div>

  <script>
    // add mixins
    this.mixin ('child');
    this.mixin ('input');

  </script>
</form-submit-child-textarea>
