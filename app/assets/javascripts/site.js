	$(document).ready(function(){

	     $('body').click(function() {
			 $("#datafriend").css("display","none");
	     });

	     $('#datafriend').click(function(event){
	         event.stopPropagation();
	     });

	$(".getdatauser").on("click",function(e){
		e.preventDefault();
		var idfriend = $(this).data("id");

		$.ajax({
			type: 'get',
			url:'http://tranquil-crag-5078.herokuapp.com/home/getdata?id='+idfriend,
			dataType: 'html',
			success:function(recibo){
            	$('#datafriend').html(recibo);
            	$('#datafriend').fadeIn();
          	}
		});
		
	});
	
});