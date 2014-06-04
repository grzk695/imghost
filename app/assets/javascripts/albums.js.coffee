# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "click" , "#photo-selector-pagination a" , (e) ->
	$.getScript(this.href);
	return false;
$(document).on "click" , "#albums_adding a" , () -> 
	window.album.read()

root = exports ? this

class Album
	constructor: () ->
		@data = []
		@id = "#image-selector"
		@first = true
	read: ->
		selected  = [];
		unselected = [];
		$(@id+" option").each () ->
			if $(this).is(':selected')
				selected.push $(this).val()
			else
				unselected.push $(this).val()
		@data = $(@data).not(selected).get()
		@data = @data.concat(selected)
		@data = $(@data).not(unselected).get()
	send: (id) ->
		this.read()
		$.ajax 
			url: "/album/add/#{id}"
			method: "POST"
			data:
				_method: "PATCH",
				ids: @data
			dataType: 'script'

		
		
unless root.album
  root.album = new Album




