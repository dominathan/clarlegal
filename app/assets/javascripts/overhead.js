$(document).on('submit', function(){
  $('.monetary').each(function(i,obj) {
    currency = $(this).val();
    $(this).val(Number(currency.replace(/[\$,]/g,"")))
  });
});


$(document).ready(function() {
  $('#lawfirmOverhead').dataTable({
    order: [[0,'desc']]
  });
});
