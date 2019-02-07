<form-submit-child-text>
  <div class="form-group">
    <div class="input-group">
      <input type="text" name={ this.name () } id={ this.name (true) + '-input' } required={ opts.child.required || false } class={ 'form-control' : true, 'form-control-active' : this.input (this.name ()) } value={ opts.child.value || '' }>
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
</form-submit-child-text>
