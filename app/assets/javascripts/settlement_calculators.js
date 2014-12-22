$(document).ready(function() {
  $('#settlementCalculator').dataTable({
  });

});

$(document).on('change','input', function() {
  console.log('fuck')
  $("#bestCaseHighEstimate").text($("#bestCaseProb").val())
});
