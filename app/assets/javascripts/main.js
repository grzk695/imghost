$(document).ready(function() {
    ajaxifyPagination();
    initializePhotoModal();
    initializePhotoSelection();
     selected = [];

     
});

function initializePhotoSelection(){
    $(document).on("click",".photo input[type='checkbox']",function(){
       if ( $(this).is(':checked') ){
        selected.push($(this).val());
       } else {
        selected.splice($.inArray($(this).val(),selected),1);
       }
       $("#selectedNumber").html("Selected: "+selected.length);
    })
}

function sendDelete(){
        $.ajax({
            url: "/photos/delete/all",
            method: 'post',
            data:{
                _method: "DELETE",
                ids: selected
            },
            dataType: 'script'
        });
}

function sendShare(type){
        $.ajax({
            url: "/links",
            method: 'post',
            data:{
                _method: "post",
                ids: selected,
                type: type
            },
            dataType: 'script'
        });
}

function drawSelected(){
    $.each(selected,function(index,value){
         var input = "input[value='"+value+"'][type='checkbox']";
         $(input).prop('checked',true);
         $("#selectedNumber").html("Selected: "+selected.length);
    });
}

function initializePhotoModal(){
    $("#modal-window").modal({
        show: false
    });
    $("#modal-window").on('hidden.bs.modal',function(e){
        $(this).html("");
    });
}

function ajaxifyPagination() {
    $(".pagination a").click(function() {
        $.getScript(this.href);
    return false;
 
    });
}

function sendRefreshToken() {
	$.ajax({
    	  type: "GET",
    	  url: $("#refresh_token").html(),
    	  dataType: "script"
    	});
    	
}

