<element-address>
  <span>
    <span if={ (opts.data.value || {}).formatted }>{ (opts.data.value || {}).formatted }</span>
    <i if={ !(opts.data.value || {}).formatted }>N/A</i>
  </span>
</element-address>
