$(document).ready(function() {

  $.fn.render_form_errors = function(model_name, errors) {
    var form;
    form = this;
    this.clear_form_errors();
    return $.each(errors, function(field, messages) {
      var input;
      input = form.find('input, select, textarea').filter(function() {
        var name;
        name = $(this).attr('name');
        if (name) {
          return name.match(new RegExp(model_name + '\\[' + field + '\\(?'));
        }
      });
      input.closest('.form-group').addClass('has-error');
      return input.parent().append('<span class="help-block">' + $.map(messages, function(m) {
        return m.charAt(0).toUpperCase() + m.slice(1);
      }).join('<br />') + '</span>');
    });

    return this;
  };

  $.fn.clear_form_errors = function() {
    this.find('.form-group').removeClass('has-error');
    return this.find('span.help-block').remove();
  };
  $.fn.clear_form_fields = function() {
    return this.find(':input', '#myform').not(':button, :submit, :reset, :hidden').val('').removeAttr('checked').removeAttr('selected');
  };



  $('#newClientModal').on('hidden.bs.modal', function () {
    $('#new_client').clear_form_errors();
  })

  $('#new_client').on('ajax:success', function (e, data, status, xhr) {
    console.log('success');
    $('#newClientModal').modal('hide');
    $('#new_client').clear_form_fields().clear_form_errors();
    $('#new_client_status').show().html('<div class="alert alert-success">Client added successfully</div>').fadeOut(5000);
  }).on('ajax:error', function (e, data, status, xhr) {
    $('#new_client').render_form_errors('client', data.responseJSON)
  });

  $.ajaxSetup({
    dataType: 'json'
  });

  $("#newClientModal #client_different_billing").click(function(){
     $("#newClientModal #billing-information").toggleClass('hide')
   });

  $('#userClients').dataTable({
    order: [[0,'desc']]
  });
});
