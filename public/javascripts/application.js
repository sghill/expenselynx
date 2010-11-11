// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
$("#receipt_store_name").autocomplete({
  minLength: 0,
  source: function(request, response) {
    $.ajax({
      url: "/stores/search",
      dataType: "json",
      data: {term: request.term},
      success: function( data ) {
        response( data );
      }
    });
  }
})

$("#receipt_purchase_date").datepicker({autoSize:true, dateFormat:"yy-mm-dd", inline:true});

$("#create_receipt_link").click(function() {
  $("#receipt_form").slideToggle("slow");
})

$("#create_receipt_link")[0].href = "#";

$("#new_receipt").submit(function() {
  $.post(
    $(this).attr('action'),
    $("#new_receipt").serialize(),
    function(data, textStatus) {
      var html = "<tr><td>" + data.receipt.purchase_date +
        "</td><td>" + data.receipt.store_name + "</td><td><a href='/receipts/" +
        data.receipt.id + "'>" + data.receipt.total + "</a></td><td>" + 
        data.receipt.expensable + "</td></tr>";
      
      $(html).appendTo($("table")).effect("highlight", {}, 3000);
    }, "json");
    return false;
});

var input = $('#receipt_total')
input.change(function() {
  var text = input.val()
  input.val(text.substring(0, text.length-2) + '.' + text.substring(text.length-2));
});
});