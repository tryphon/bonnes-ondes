class SlugInput
	constructor: (@input) ->
		@input.change @disable
		@source_input().keyup @source_change

	source_attribute: ->
		@input.data("slug-source")

	url: ->
		@input.data("slug-url")

	source_input_id: ->
		@input.attr("id").replace('slug', @source_attribute())

	source_input: ->
		$("##{@source_input_id()}")

	source_change: (event) => 
		@change_slug(event.target.value)

	change_slug: (name) ->
		return if @disable_change
		
		$.post(@url(), { name: name }).done (data) => 
			@input.val data.slug

	disable: (event) =>
		@disable_change = true


$ ->
	new SlugInput $('form input.slug')