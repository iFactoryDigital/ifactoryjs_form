<form-admin-remove-page>
  <div class="form form-admin">
  
    <admin-header title="Remove Form">
      <yield to="right">
        <a href="/admin/form" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <form method="post" action="/admin/form/{ opts.item.id }/remove">
        <div class="card">
          <div class="card-body">
            <p class="m-0">
              Are you sure you want remove this form?
            </p>
          </div>
          <div class="card-footer text-right">
            <button type="submit" class="btn btn-danger btn-card">Remove Form</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</form-admin-remove-page>
