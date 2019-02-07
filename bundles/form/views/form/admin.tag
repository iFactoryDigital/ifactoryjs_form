<form-admin-page>
  <div class="form form-admin">
  
    <admin-header title="Manage Forms">
      <yield to="right">
        <a href="/admin/form/create" class="btn btn-lg btn-success">
          Create
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">

      <!-- claim grid form -->
      <grid ref="grid" grid={ opts.grid } table-class="table table-bordered table-striped" title="Form Grid" />
      <!-- / claim grid form -->
    
    </div>
  </div>
</form-admin-page>
