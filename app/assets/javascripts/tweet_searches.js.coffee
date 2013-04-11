# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#search_button').click ->
    word = $('input#search').val()
    $('input#active_word').val(word);
    $('#results').empty()
    callback = (data) -> $.each(data.statuses, (key, val) ->
    	$('#results').append(
    		"<div class='tweet'><div class='user_image'><img src='" + val["user"]["profile_image_url"] + "'> <strong> " + val["user"]["name"] + "</strong> @"+val["user"]["screen_name"]+"</div>" +
    			"<div class='tweet_text'>" + 
    			val["text"] + "</div>" +
    		"<a onclick=save_tweet('"+val['id_str']+"')>save</a></div>" 
    	)
    	)
    $.get '/search_tweet?word='+word, callback, 'json'

  $('#search_save_button').click ->
    word = $('input#search').val()
    $('#words_saved').empty()
    $.get '/search_tweet/save?word=', {word}, 'json'

