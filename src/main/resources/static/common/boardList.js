
$(document).ready(function(){


});


function egovAjaxPaging(pageNo){
	
	$("#pageIndex").val(pageNo);
	console.log("egovAjaxPaging 시작!!"+$("#boardVO").serialize());	
	$.ajax({
		url:"/boardPaging.do",
		type:"POST",
		data: $("#boardVO").serialize(),
		success: function (data){
			
			var listHtml = "";
			var pageHtml = "";
			
			var json= JSON.parse(data);

			
			$('#boardListId').empty();
			
			$('#paging').empty();
			
			for(var i=0; i<json.list.length; i++){
				
				listHtml += '<tr style="cursor: pointer;">';
				
				$.each(json.list[i], function(key, value){
					listHtml += '<td>'+value+'</td>';
				});
				
				listHtml += '</tr>';
				
			}
			if(Number(json.paginationInfo.lastPageNo)>10){
				pageHtml = pageHtml + "<a href='#' onclick='egovAjaxPaging("+json.paginationInfo.firstPageNo+"); return false;'>" + "<image src='/images/egovframework/cmmn/btn_page_pre10.gif' border=0/></a>&#160;";
				pageHtml = pageHtml + "<a href='#' onclick='egovAjaxPaging("+json.firstNextBtnNum+"); return false;'>" + "<image src='/images/egovframework/cmmn/btn_page_pre1.gif' border=0/></a>&#160;";
			}			
			for(var i= Number(json.paginationInfo.firstPageNoOnPageList); i <= Number(json.paginationInfo.lastPageNoOnPageList); i++) {
				if( i == pageNo){
					pageHtml = pageHtml + "<strong>"+i+"</strong>&#160;"
				}
				else{
					pageHtml = pageHtml + "<a href='#' onclick='egovAjaxPaging("+i+"); return false;'>"+i+"</a>&#160;";
				}			
			}
			if(Number(json.paginationInfo.lastPageNo)>10){
				pageHtml = pageHtml + "<a href='#' onclick='egovAjaxPaging("+json.endNextBtnNum+"); return false;'>" + "<image src='/images/egovframework/cmmn/btn_page_next1.gif' border=0/></a>&#160;";
				pageHtml = pageHtml + "<a href='#' onclick='egovAjaxPaging("+json.paginationInfo.lastPageNo+"); return false;'>" + "<image src='/images/egovframework/cmmn/btn_page_next10.gif' border=0/></a>&#160;";
			}
			$('#boardListId').append(listHtml);

				
			$('#paging').append(pageHtml);


		}			
	})
	
	
}

function pagingSetting(url, listBodyId, pageBodyId , jsonParam ){
	
	$.each(jsonParam.data, function(key, value){
		if(key != 'page'){
			url += '&'+key+'='+value;	
		}
	});

	$.ajax({
		url:url,
		type:"GET",
		processData: false,
		contentType : "application/json; charset:UTF-8",
		success: function (data){
			
			var listHtml = "";
			var pageHtml = "";
			
			var json= JSON.parse(data);

			var urlSplit = url.split("?");
			
			$('#'+ listBodyId).empty();
			
			$('#'+ pageBodyId).empty();
			
			for(var i=0; i<json.list.length; i++){
				
				listHtml += '<tr style="cursor: pointer;">';
				
				$.each(json.list[i], function(key, value){
					listHtml += '<td>'+value+'</td>';
				});
				
				listHtml += '</tr>';
				
			}
			
			$('#'+ listBodyId).append(listHtml);
			
			var dic = {}; 
			
			dic['data']= json.pageVO;
			
			$("#page").val(json.pageVO.page);
			
			if(json.pageVO.prev){
				pageHtml += "<a href='javascript:void(0);' onclick='pagingSetting(\""+urlSplit[0]+"?page="+(json.pageVO.startPage-1)+"\",\""+listBodyId+"\",\""+pageBodyId+"\" ,"+JSON.stringify(dic)+");' ><-</a>&nbsp;"
			}
			
			for(var i = json.pageVO.startPage; i <= json.pageVO.endPage; i++){
				pageHtml += "<button type='button' onclick='pagingSetting(\""+urlSplit[0]+"?page="+i+"\",\""+listBodyId+"\",\""+pageBodyId+"\" ,"+JSON.stringify(dic)+");' >"+i+"</button>&nbsp;"
			}

			if(json.pageVO.next){
				pageHtml += "<a href='javascript:void(0);' onclick='pagingSetting(\""+urlSplit[0]+"?page="+(json.pageVO.endPage+1)+"\",\""+listBodyId+"\",\""+pageBodyId+"\" ,"+JSON.stringify(dic)+");' >-></a>"
			}
			
			$('#'+ pageBodyId).append(pageHtml);
			

		}			
	})	

}


function move_page_method(url, formData){
		
		var form = $('<form></form>');
		
		form.attr('action', url);
		form.attr('method', "GET");
		
		if(formData instanceof FormData){	
					
			for (var item of formData.entries()) {
			    
		        var name = item[0];
		        var value = item[1];
				var field = $('<input></input>');
				field.attr("type", "hidden");
				field.attr("name", name);
				field.attr("value", value);
				form.append( field );
			}
		}	
		
		form.appendTo('body');
		form.submit();
			
}

function ajax_save_method(url, formId, succ_func){
	

	$.ajax({
	
			type: "POST",
			url: url,
			data: $("#"+formId).serialize(), 
			success: function(data){
				var returnJson = JSON.parse(data);
				var returnData = returnJson.data
				succ_func(returnData);
			}
	});	
	
}