// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

// $(document).foundation();

function get_results_by(word){
	$(function() {
		$('#results').empty();
		$('input#active_word').val(word);
		
		callback = function(data) {
			return $.each(data.statuses, function(key, val) {
				return $('#results').append("<div class='tweet'><div class='user_image large-2 columns small-3'><img src='" + val["user"]["profile_image_url"] + "'></div> <div class='large-10 columns'> <strong> " + val["user"]["name"] + "</strong> <small>@" + val["user"]["screen_name"] + "</small>" + "<div class='tweet_text'>" + val['text'] + "<ul class='inline-list'><li><a onclick=reply_tweet_show('"+ val['id_str'] +"');> Reply </a></li> <li><a onclick=save_tweet('" + val['id_str'] + "');> Save </a></li></ul></div><div class='reply_tweet_input' id="+val['id_str']+"><textarea class='reply_textarea' id="+val['id_str'] +">@"+ val["user"]["screen_name"] +"</textarea><button class='reply_button' type='submit' onclick=send_reply('"+val['id_str'] +"');>Responder</button></div></div>");
			});
		};
		$.get('/search_tweet', {word: word}, callback, 'json'); 
	});

	get_saved_tweets_for(word);
}

function save_tweet(tweet_id){
	active_word = $('input#active_word').val();
	$.get('/search_tweet/tweet?tweet_id='+tweet_id+'&active_search='+active_word,
		function(data) {
			if (data["status"] == 1){
				alert("El tweet ya fue guardado en esta búsqueda");
			}
			else{
				$('#tweets_saved').append("<div class='tweet' id ='"+ data['id']+"'><div class='user_image'><img src='" + data["profile_image_url"] + "'></div> <div class='large-10 columns'><strong> " + data["user_name"] + "</strong> @" + data["user_screen_name"] + "" + "<div class='tweet_text'>" + data['tweet_text'] + "<ul class='inline-list'><li><a onclick=reply_tweet_show('"+ data['id'] +"');> Reply </a></li> <li><a onclick=delete_tweet('"+data['id']+"');> Eliminar </a></li></ul></div><div class='reply_tweet_input' id="+ data['id'] +"><textarea class='reply_textarea' id="+ data['id'] +">@"+ data["user_screen_name"] +"</textarea><button class='reply_button' type='submit' onclick=send_reply_from_saved_tweet('"+ data['id'] +"','"+tweet_id+"');>Responder</button></div></div>");
				get_searches_saved();
			}
		}, "json");
}

function delete_tweet(tweet_id){
	$.get('/search_tweet/tweet/delete?tweet_saved_id='+tweet_id,
		function(data) {
			$('.tweet #'+tweet_id).remove();
		}, "json");
}

function get_saved_tweets_for(word){
	$('#tweets_saved').empty();
	
	$.get('/search_tweet/saved_tweets?active_search='+word, 
		function(data) {
			$.each(data, function(key, val) {
				if (typeof val['id'] === "undefined" ) {
				}
				else{	
					$('#tweets_saved').append("<div class='tweet' id ='"+ val['id']+"'><div class='user_image'><img src='" + val["profile_image_url"] + "'> <strong> " + val["user_name"] + "</strong> @" + val["user_screen_name"] + "</div><div class='tweet_text'>" + val['tweet_text'] + "<a onclick=reply_tweet_show('"+ val['id'] +"');> Reply </a> | <a onclick=delete_tweet('"+val['id']+"');> Eliminar </a></div><div class='reply_tweet_input' id="+ val['id'] +"><textarea class='reply_textarea' id="+val['id'] +">@"+ val["user_screen_name"] +"</textarea><button class='reply_button' type='submit' onclick=send_reply_from_saved_tweet('"+ val['id'] +"','"+val['tweet_id']+"'); >Responder</button></div></div>");
				}
			});
		}, 'json');
}

function reply_tweet_show(tweet_id){
	$('#'+tweet_id + '.reply_tweet_input').slideToggle('fast');
}

function send_reply(tweet_id){
	active_word = $('input#active_word').val();
	msg = $('#'+tweet_id+ ' textarea').val();
	$.get('/search_tweet/tweet/reply?tweet_id='+tweet_id+'&msg='+msg,
		function(data) {
			$('#'+tweet_id +' textarea').val("");
			alert("El mensaje se ha enviado");
		}, "json");
	
}

function send_reply_from_saved_tweet(dom_id,tweet_id){
	active_word = $('input#active_word').val();
	msg = $('#'+dom_id+ ' textarea').val();
	$.get('/search_tweet/tweet/reply?tweet_id='+tweet_id+'&msg='+msg,
		function(data) {
			$('#'+dom_id +' textarea').val("");
			alert("El mensaje se ha enviado");
		}, "json");
	
}

function get_searches_saved(){
	$.getJSON('/search_tweet/searches_saved.json', function(data) {
		var items = [];
		$('#words_saved').empty();
		$.each(data, function(key, val) {
			items.unshift('<li id="' + key + '"> <a onclick=get_results_by("'+ val["word"] +'");>'+ val["word"] +'</a></li>');
		});
		$('<ul/>', {
			'class': 'tweets_list',
			html: items.join('')
		}).appendTo('#words_saved');
	});
}
