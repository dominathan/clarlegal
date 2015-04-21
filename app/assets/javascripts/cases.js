$(document).ready(function() {
  $('#userCases').dataTable({
    // "columnDefs": [
    //   {
    //     "targets": [4],
    //     "visible": false
    //   },
    //   {
    //     "targets": [5],
    //     "visible": false
    //   },
    //   {
    //     "targets": [6],
    //     "visible": false
    //   },
    //   {
    //     "targets": [7],
    //     "visible": false
    //   }
    // ]
  });

    $('#clientCases').dataTable({
    // "columnDefs": [
    //   {
    //     "targets": [4],
    //     "visible": false
    //   },
    //   {
    //     "targets": [5],
    //     "visible": false
    //   },
    //   {
    //     "targets": [6],
    //     "visible": false
    //   },
    //   {
    //     "targets": [7],
    //     "visible": false
    //   }
    // ]
  });

  $("#clientSubmit").on('click',function() {
    var formData, inputGroup
    inputGroup = $("#newClientModal").find('input','select').each(function () {})
    $.ajax({
      url: "/clients",
      type: "POST",
      data: formData,
      success: function(response, status, jqXHR) {
        console.log("------------------------SUCCESSSSSSSSSSS--------------------------------");
        console.log(response);
        console.log("*************************************");
        console.log(status);
        console.log("*************************************");
        console.log(jqXHR)
      },
      error: function(jqXHR, status, errorThrown) {
        console.log("-----------------ERRRRRRRRROOOOOOORRRRR---------------------------------");
        console.log("*************************************");
        console.log(status);
        console.log("*************************************");
        console.log(jqXHR);
        console.log("*************************************");
        console.log(errorThrown)
      }
    });
  });//end client submit
});//end document.ready



