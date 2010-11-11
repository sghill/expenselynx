// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// jQuery.ajaxSetup({ 
//   'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
// })

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

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
  
  $("#new_receipt").submitWithAjax();
})