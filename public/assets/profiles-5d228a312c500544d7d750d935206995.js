(function() {
  $.rails.allowAction = function(link) {
    if (!link.attr('data-confirm')) {
      return true;
    }
    $.rails.showConfirmDialog(link);
    return false;
  };

  $.rails.confirmed = function(link) {
    link.removeAttr('data-confirm');
    return link.trigger('click.rails');
  };

  $.rails.showConfirmDialog = function(link) {
    var html, message;
    message = link.attr('data-confirm');
    html = "    		<div class=\"modal fade\" role=\"dialog\">\n    			<div class=\"modal-dialog\" style=\"max-height:80%;margin-top:0\" 					id=\"confirmationDialog\">\n    				<div class=\"modal-content\" style=\"max-height:80%\">\n     		 			<div class=\"modal-header\">\n        					<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>\n        					<h3>" + message + "</h3>\n      					</div>\n     					<div class=\"modal-footer\">\n             				<a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n             				<a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n           				</div>\n   					 </div>\n</div>\n    		</div>";
    $(html).modal();
    return $('#confirmationDialog .confirm').on('click', function() {
      return $.rails.confirmed(link);
    });
  };

}).call(this);
