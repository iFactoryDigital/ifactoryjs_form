<form-submit-child-checkbox>
  <div class="form-group">
    <label for={ this.name(true) + '-input' }>
      { opts.child.name }
    </label>
    <div class="form-check" each={ box, i in opts.child.data.data }>
      <label class="form-check-label">
        <input class="form-check-input" type="checkbox" name={ this.name() } value={ box.id } checked={ isChecked(box) }>
        <span>{ box.text }</span>
      </label>
    </div>
  </div>

  <script>
    // do field mixin
    this.mixin('child');

    /**
     * returns true if checkbox should be checked
     *
     * @param {Object} box
     */
    isChecked (box) {
      // check if checked
      return (opts.child.value || '').includes(box.id);
    }
  </script>
</form-submit-child-checkbox>
