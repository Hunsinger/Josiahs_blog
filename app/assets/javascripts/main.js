$(function(){
	var start_time;
	var clicks = 0;
	var Timer;
	var value;
	var random_numbers = [];
	var correct_numbers = [1,2,3,4,5,6,7,8];
	var my_scores = [1504,1042,1042];

	document.cookie = "test1=Hello";
	document.cookie = "test2=World";

	

	

	while (random_numbers.length < 8) {
		number = Math.floor(Math.random() * 8) + 1;
		if (random_numbers.length == 7){
			if ($.inArray(number, random_numbers) === -1){
				random_numbers.push(number);
			}
		}
		else if ($.inArray(number, random_numbers) === -1){
			if (number != correct_numbers[random_numbers.length]) {
				random_numbers.push(number);
			}
		}
	}

	$(".box").each(function(){
		$(this).html(random_numbers[0])
		random_numbers.splice(0,1);
	})

	function Update_timer(){
		var end_time = new Date();
		var score = Math.round(((end_time - start_time)/1000)*10)*(clicks+1);
		$("#score").html(score);
	};

	$(document).on("click", ".box", function(){
		clicks += 1;
		$("#clicks").html(clicks);

		$(".none_box")
			.html($(this).html())
			.addClass("box")
			.removeClass("none_box");
		$(this)
			.html("&nbsp;")
			.addClass("none_box")
			.removeClass("box");
		if (isInOrder() === true) {
			$(".finish").show();
			clearInterval(Timer);
			$(".button").show();
		};
	});

	$(document).on("click", ".cover", function(){
		$(this).hide();
		$(".box , .none_box").show();
		start_time = new Date();
		Timer = setInterval(Update_timer, 10);
	});

	function isInOrder(){
		var previous = 0;
		var isInOrder = true;
		$(".box").each(function(){
			
			if (parseInt($(this).html()) < previous) {
				isInOrder = false;
				return false;
			}

			previous = parseInt($(this).html())
		});

		return isInOrder
	};
});