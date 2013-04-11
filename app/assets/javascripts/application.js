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
						return $('#results').append("<div class='tweet'><div class='user_image'><img src='" + val["user"]["profile_image_url"] + "'> <strong> " + val["user"]["name"] + "</strong> @" + val["user"]["screen_name"] + "</div>" + "<div class='tweet_text'>" + val['text'] + "<a onclick=save_tweet('" + val['id_str'] + "');> save </a></div></div>");
					});
				};
				return $.get('/search_tweet?word='+word, callback, 'json');
			});

}


function save_tweet(tweet_id){
active_word = $('input#active_word').val();
$.get('/search_tweet/tweet?tweet_id='+tweet_id+'&active_search='+active_word,
   function(data) {
	 if (data["status"] == 1){
   		alert("El tweet ya fue guardado en esta búsqueda");
   	  }
   	 else{
     $('#tweets_saved').append("<div class='tweet' id ='"+ data['id']+"'><div class='user_image'><img src='" + data["profile_image_url"] + "'> <strong> " + data["user_name"] + "</strong> @" + data["user_screen_name"] + "</div>" + "<div class='tweet_text'>" + data['tweet_text'] + "<a onclick=delete_tweet('"+data['id']+"');> Eliminar </a></div></div>");
   	 }
   	}, "json");
}

function delete_tweet(tweet_id){
$.get('/search_tweet/tweet/delete?tweet_saved_id='+tweet_id,
   function(data) {
     $('.tweet#'+tweet_id).remove();
   }, "json");
}
