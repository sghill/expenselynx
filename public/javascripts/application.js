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
  //login form styling
  $("#user_remember_me").button();
  $("#user_submit").button();
  // end login form styling
  
  $("#receipt_purchase_date").datepicker({dateFormat:"yy-mm-dd", inline:true});
  
  $("#create_receipt_link").click(function() {
    $("#receipt_form").slideToggle("slow");
  })
  
  $("#create_receipt_link").attr("href","#");
  
  $("#new_receipt").submitWithAjax();
})