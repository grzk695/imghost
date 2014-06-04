$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously
 
$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

  
$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  html = """
    		<div class="modal fade" role="dialog">
    			<div class="modal-dialog" style="max-height:80%;margin-top:0" 					id="confirmationDialog">
    				<div class="modal-content" style="max-height:80%">
     		 			<div class="modal-header">
        					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        					<h3>#{message}</h3>
      					</div>
     					<div class="modal-footer">
             				<a data-dismiss="modal" class="btn">Cancel</a>
             				<a data-dismiss="modal" class="btn btn-primary confirm">OK</a>
           				</div>
   					 </div>
				</div>
    		</div>
         """
  $(html).modal()
  $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)