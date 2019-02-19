<field-i18n>
  <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    { this.language }
  </button>
  <div class="dropdown-menu dropdown-menu-right">
    <button class="dropdown-item" each={ language, i in this.languages } onclick={ onLanguage }>
      { language }
    </button>
  </div>
  
  <script>
    // do i18n
    this.mixin('i18n');
    
    // get languages
    this.language  = this.i18n.lang();
    this.languages = this.eden.get('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());
    
    /**
     * on language
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onLanguage(e) {
      // stop propagation
      e.preventDefault();
      e.stopPropagation();
      
      // set language
      this.i18n.lang(e.item.language);
    }

    /**
     * on mount function
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set product
      this.language = this.i18n.lang();

    });
    
  </script>
</field-i18n>
