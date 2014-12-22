$(document).ready(function() {
  $('#settlementCalculator').dataTable({
    "bPaginate": false,
    "bFilter": false,
    "bInfo": false
  });
  $('#settlementCalculatorDefendant').dataTable({
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

//For Settlement Calculator Plaintiff
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


//For Settlement Calculator - Defendant
$(document).on('change','input', function() {
  // Strip out all ($ and ,) from monetary class and strip out % for probabilities
  // Multiply the value of the probabilty by the numerical amount for high and low estimates
  if( $("#bestCaseHighDefendant").val() != "" &&
      $("#bestCaseProbDefendant").val() != "" &&
      $("#bestCaseLowDefendant").val() != "") {
        var bestCaseHighDefendant = $("#bestCaseHighDefendant").val().replace(/[\$,]/g,"");
        var bestCaseProbDefendant = parseFloat($("#bestCaseProbDefendant").val().replace(/[\%]/g,"")) <= 1 ? parseFloat($("#bestCaseProbDefendant").val().replace(/[\%]/g,"")) : parseFloat($("#bestCaseProbDefendant").val().replace(/[\%]/g,""))/100;
        var bestCaseLowDefendant = $("#bestCaseLowDefendant").val().replace(/[\$,]/g,"");
        $("#bestCaseHighEstimateDefendant").text((bestCaseHighDefendant * bestCaseProbDefendant).formatMoney(0));
        $("#bestCaseLowEstimateDefendant").text((bestCaseProbDefendant * bestCaseLowDefendant).formatMoney(0));
  };

  if( $("#mostLikelyCaseHighDefendant").val() != "" &&
    $("#mostLikelyCaseProbDefendant").val() != ""
    && $("#mostLikelyCaseLowDefendant").val() != "") {
      var mostLikelyCaseHighDefendant = $("#mostLikelyCaseHighDefendant").val().replace(/[\$,]/g,"");
      var mostLikelyCaseProbDefendant = parseFloat($("#mostLikelyCaseProbDefendant").val().replace(/[\%]/g,"")) <= 1 ? parseFloat($("#mostLikelyCaseProbDefendant").val().replace(/[\%]/g,"")) : parseFloat($("#mostLikelyCaseProbDefendant").val().replace(/[\%]/g,""))/100;
      var mostLikelyCaseLowDefendant = $("#mostLikelyCaseLowDefendant").val().replace(/[\$,]/g,"");
      $("#mostLikelyCaseHighEstimateDefendant").text((mostLikelyCaseHighDefendant * mostLikelyCaseProbDefendant).formatMoney(0));
      $("#mostLikelyCaseLowEstimateDefendant").text((mostLikelyCaseProbDefendant * mostLikelyCaseLowDefendant).formatMoney(0));
  };

  if( $("#worstCaseHighDefendant").val() != "" &&
      $("#worstCaseProbDefendant").val() != "" &&
      $("#worstCaseLowDefendant").val() != "") {
        var worstCaseHighDefendant = $("#worstCaseHighDefendant").val().replace(/[\$,]/g,"");
        var worstCaseProbDefendant = parseFloat($("#worstCaseProbDefendant").val().replace(/[\%]/g,"")) <= 1 ? parseFloat($("#worstCaseProbDefendant").val().replace(/[\%]/g,"")) : parseFloat($("#worstCaseProbDefendant").val().replace(/[\%]/g,""))/100;
        var worstCaseLowDefendant = $("#worstCaseLowDefendant").val().replace(/[\$,]/g,"");
        $("#worstCaseHighEstimateDefendant").text((worstCaseHighDefendant * worstCaseProbDefendant).formatMoney(0));
        $("#worstCaseLowEstimateDefendant").text((worstCaseProbDefendant * worstCaseLowDefendant).formatMoney(0));
  };

  if ( $("#bestCaseHighEstimateDefendant").text() != "$" &&
       $("#mostLikelyCaseHighEstimateDefendant").text() != "$" &&
       $("#worstCaseHighEstimateDefendant").text() != "$" ) {
          var bestHighDefendant = parseInt($("#bestCaseHighEstimateDefendant").text().replace(/[\$,]/g,""));
          var mostlikelyHighDefendant = parseInt($("#mostLikelyCaseHighEstimateDefendant").text().replace(/[\$,]/g,""));
          var worstHighDefendant = parseInt($("#worstCaseHighEstimateDefendant").text().replace(/[\$,]/g,""));
          var highEstimateDefendant = (bestHighDefendant + mostlikelyHighDefendant + worstHighDefendant).formatMoney(0);
          $("#totalSettlementValueHighDefendant").text(highEstimateDefendant);
  }

  if ( $("#bestCaseLowEstimateDefendant").text() != "$" &&
       $("#mostLikelyCaseLowEstimateDefendant").text() != "$" &&
       $("#worstCaseLowEstimateDefendant").text() != "$" ) {
          var bestLowDefendant = parseInt($("#bestCaseLowEstimateDefendant").text().replace(/[\$,]/g,""));
          var mostlikelyLowDefendant = parseInt($("#mostLikelyCaseLowEstimateDefendant").text().replace(/[\$,]/g,""));
          var worstLowDefendant = parseInt($("#worstCaseLowEstimateDefendant").text().replace(/[\$,]/g,""));
          var lowEstimateDefendant = (bestLowDefendant + mostlikelyLowDefendant + worstLowDefendant).formatMoney(0);
          $("#totalSettlementValueLowDefendant").text(lowEstimateDefendant);
  }

  if( $("#totalSettlementValueLowDefendant").text() != "$" &&
      $("#totalSettlementValueHighDefendant").text() != "$" &&
      $("#highLegalCostDefendant").val() != "" &&
      $("#lowLegalCostDefendant").val() != "") {
          var finalLegalHighDefendant = parseInt($("#highLegalCostDefendant").val().replace(/[\$,]/g,""));
          var finalLegalLowDefendant = parseInt($("#lowLegalCostDefendant").val().replace(/[\$,]/g,""));
          var finalHighDefendant = (parseInt($("#totalSettlementValueHighDefendant").text().replace(/[\$,]/g,"")) + finalLegalHighDefendant).formatMoney(0);
          var finalLowDefendant = (parseInt($("#totalSettlementValueLowDefendant").text().replace(/[\$,]/g,"")) + finalLegalLowDefendant).formatMoney(0);
          $("#totalValueHighDefendant").text(finalHighDefendant);
          $("#totalValueLowDefendant").text(finalLowDefendant);
  }

});
