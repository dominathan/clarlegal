$(document).ready(function() {
  $('#caseFees').dataTable({

  });
});


$(document).on('submit', function(){
  $('.monetary').each(function(i,obj) {
    currency = $(this).val();
    $(this).val(Number(currency.replace(/[\$,]/g,"")))
  });

  $('.percentage').each(function(i,obj) {
    percentage = $(this).val();
    final_num = parseFloat(percentage.replace(/[\%]/g,"")) <= 1 ? parseFloat(percentage) : parseFloat(percentage.replace(/[\%]/g,""))/100;
    $(this).val(final_num);
  });
});

$(document).ready(function() {
  $("#fee_fee_type").on('change', function () {
    if(this.value == "Contingency") {
      $(".fees").addClass('hide');
      $(".contingency").toggleClass('hide');
      $("#feeNameChange label").text('Medium Estimate:');
    } else if(this.value == "Fixed Fee") {
      $('.fees').addClass('hide');
      $(".fixed").toggleClass('hide');
      $("#feeNameChange label").text('Contract Amount:');
    } else if (this.value == "Hourly") {
      $('.fees').addClass('hide');
      $("#feeNameChange label").text('Medium Estimate:');
      $('.hourly').toggleClass('hide');
    } else if (this.value == "Mixed") {
      $('.fees').addClass('hide');
      $("#feeNameChange label").text('Contract Amount:');
      $('.mixed').toggleClass('hide');
    };
  });
});
