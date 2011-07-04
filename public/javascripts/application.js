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
  
  $("#alert").delay(2500).slideUp('slow');
  $("#notice").delay(2500).slideUp('slow');
  
  //unexpensed receipts table
  $('#select_all').click(function() { $(':checkbox').attr('checked', $('#select_all').attr('checked'))});
})
