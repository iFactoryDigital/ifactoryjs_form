<element-image>
  <media-img class="element-image" if={ this.value } image={ this.value } label="1x-sq" />
  
  <script>
    // set value
    this.value = Array.isArray(opts.data.value) ? opts.data.value[0] : opts.data.value;
    
  </script>
</element-image>
