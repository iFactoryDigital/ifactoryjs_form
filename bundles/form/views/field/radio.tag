<form-submit-child-radio>
  <div class="form-group">
    <label for={ this.name (true) + '-input' }>
      { opts.child.name }
    </label>
    <div class="form-check" each={ box, i in opts.child.data.data }>
      <label class="form-check-label">
        <input class="form-check-input" name={ this.name () } required={ isRequired () } type="radio" value={ box.id } checked={ isChecked (box) }>
        <span>{ box.text }</span>
      </label>
    </div>
  </div>

  <script>
    this.mixin ('child');

    /**
     * returns true if checkbox should be checked
     *
     * @param {Object} box
     */
    isChecked (box) {
      // check if checked
      return ((opts.child.value || '') === box.id);
    }

    /**
     * return is required
     *
     * @return Boolean
     */
    isRequired () {
      // return is required
      return opts.child.required;
    }
  </script>
</form-submit-child-radio>
