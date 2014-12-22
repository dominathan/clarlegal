$(document).ready(function() {
  $('#settlementCalculator').dataTable({
    "bPaginate": false,
    "bFilter": false,
    "bInfo": false
  });
});
// Extend the default Number object with a formatMoney() method:
// usage: someVar.formatMoney(decimalPlaces, symbol, thousandsSeparator, decimalSeparator)
// defaults: (2, "$", ",", ".")
Number.prototype.formatMoney = function(places, symbol, thousand, decimal) {
  places = !isNaN(places = Math.abs(places)) ? places : 2;
  symbol = symbol !== undefined ? symbol : "$";
  thousand = thousand || ",";
  decimal = decimal || ".";
  var number = this,
      negative = number < 0 ? "-" : "",
      i = parseInt(number = Math.abs(+number || 0).toFixed(places), 10) + "",
      j = (j = i.length) > 3 ? j % 3 : 0;
  return symbol + negative + (j ? i.substr(0, j) + thousand : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousand) + (places ? decimal + Math.abs(number - i).toFixed(places).slice(2) : "");
};

$(document).on('change','input', function() {
  // Strip out all ($ and ,) from monetary class and strip out % for probabilities
  // Multiply the value of the probabilty by the numerical amount for high and low estimates
  if( $("#bestCaseHigh").val() != "" &&
      $("#bestCaseProb").val() != "" &&
      $("#bestCaseLow").val() != "") {
        var bestCaseHigh = $("#bestCaseHigh").val().replace(/[\$,]/g,"");
        var bestCaseProb = parseFloat($("#bestCaseProb").val().replace(/[\%]/g,"")) <= 1 ? parseFloat($("#bestCaseProb").val().replace(/[\%]/g,"")) : parseFloat($("#bestCaseProb").val().replace(/[\%]/g,""))/100;
        var bestCaseLow = $("#bestCaseLow").val().replace(/[\$,]/g,"");
        $("#bestCaseHighEstimate").text((bestCaseHigh * bestCaseProb).formatMoney(0));
        $("#bestCaseLowEstimate").text((bestCaseProb * bestCaseLow).formatMoney(0));
  };

  if( $("#mostLikelyCaseHigh").val() != "" &&
    $("#mostLikelyCaseProb").val() != ""
    && $("#mostLikelyCaseLow").val() != "") {
      var mostLikelyCaseHigh = $("#mostLikelyCaseHigh").val().replace(/[\$,]/g,"");
      var mostLikelyCaseProb = parseFloat($("#mostLikelyCaseProb").val().replace(/[\%]/g,"")) <= 1 ? parseFloat($("#mostLikelyCaseProb").val().replace(/[\%]/g,"")) : parseFloat($("#mostLikelyCaseProb").val().replace(/[\%]/g,""))/100;
      var mostLikelyCaseLow = $("#mostLikelyCaseLow").val().replace(/[\$,]/g,"");
      $("#mostLikelyCaseHighEstimate").text((mostLikelyCaseHigh * mostLikelyCaseProb).formatMoney(0));
      $("#mostLikelyCaseLowEstimate").text((mostLikelyCaseProb * mostLikelyCaseLow).formatMoney(0));
  };

  if( $("#worstCaseHigh").val() != "" &&
      $("#worstCaseProb").val() != "" &&
      $("#worstCaseLow").val() != "") {
        var worstCaseHigh = $("#worstCaseHigh").val().replace(/[\$,]/g,"");
        var worstCaseProb = parseFloat($("#worstCaseProb").val().replace(/[\%]/g,"")) <= 1 ? parseFloat($("#worstCaseProb").val().replace(/[\%]/g,"")) : parseFloat($("#worstCaseProb").val().replace(/[\%]/g,""))/100;
        var worstCaseLow = $("#worstCaseLow").val().replace(/[\$,]/g,"");
        $("#worstCaseHighEstimate").text((worstCaseHigh * worstCaseProb).formatMoney(0));
        $("#worstCaseLowEstimate").text((worstCaseProb * worstCaseLow).formatMoney(0));
  };

  if ( $("#bestCaseHighEstimate").text() != "$" &&
       $("#mostLikelyCaseHighEstimate").text() != "$" &&
       $("#worstCaseHighEstimate").text() != "$" ) {
          var bestHigh = parseInt($("#bestCaseHighEstimate").text().replace(/[\$,]/g,""));
          var mostlikelyHigh = parseInt($("#mostLikelyCaseHighEstimate").text().replace(/[\$,]/g,""));
          var worstHigh = parseInt($("#worstCaseHighEstimate").text().replace(/[\$,]/g,""));
          var highEstimate = (bestHigh + mostlikelyHigh + worstHigh).formatMoney(0);
          $("#totalSettlementValueHigh").text(highEstimate);
  }


  if ( $("#bestCaseLowEstimate").text() != "$" &&
       $("#mostLikelyCaseLowEstimate").text() != "$" &&
       $("#worstCaseLowEstimate").text() != "$" ) {
          var bestLow = parseInt($("#bestCaseLowEstimate").text().replace(/[\$,]/g,""));
          var mostlikelyLow = parseInt($("#mostLikelyCaseLowEstimate").text().replace(/[\$,]/g,""));
          var worstLow = parseInt($("#worstCaseLowEstimate").text().replace(/[\$,]/g,""));
          var lowEstimate = (bestLow + mostlikelyLow + worstLow).formatMoney(0);
          $("#totalSettlementValueLow").text(lowEstimate);
  }

  if( $("#totalSettlementValueLow").text() != "$" &&
      $("#totalSettlementValueHigh").text() != "$" &&
      $("#highLegalCost").val() != "" &&
      $("#lowLegalCost").val() != "") {
          var finalLegalHigh = parseInt($("#highLegalCost").val().replace(/[\$,]/g,""));
          var finalLegalLow = parseInt($("#lowLegalCost").val().replace(/[\$,]/g,""));
          var finalHigh = (parseInt($("#totalSettlementValueHigh").text().replace(/[\$,]/g,"")) - finalLegalHigh).formatMoney(0);
          var finalLow = (parseInt($("#totalSettlementValueLow").text().replace(/[\$,]/g,"")) - finalLegalLow).formatMoney(0);
          $("#totalValueHigh").text(finalHigh);
          $("#totalValueLow").text(finalLow);
  }

});

