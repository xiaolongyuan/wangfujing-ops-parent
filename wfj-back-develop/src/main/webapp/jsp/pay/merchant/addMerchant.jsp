<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setAttribute("ctx", request.getContextPath());%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="${ctx}/js/jquery-1.9.1.js"></script>
<script src="${ctx}/js/jquery.form.js"></script>
<script src="${ctx}/assets/js/validation/bootstrapValidator.js"></script>
<title>签约商户基本信息</title>
<script type="text/javascript">
__ctxPath = "${pageContext.request.contextPath}";
$(function(){
	 
	$('#theForm').bootstrapValidator({
		message : 'This value is not valid',
		feedbackIcons : {
			valid : 'glyphicon glyphicon-ok',
			invalid : 'glyphicon glyphicon-remove',
			validating : 'glyphicon glyphicon-refresh'
		},
		submitHandler : function(validator, form, submitButton) {
			// Do nothing
			$.ajax({
		        type:"post",
		        contentType: "application/x-www-form-urlencoded;charset=utf-8",
		        dataType: "json",
		        ajaxStart: function() {
			       	 $("#loading-container").attr("class","loading-container");
			        },
		        ajaxStop: function() {
		          //隐藏加载提示
		          setTimeout(function() {
		       	        $("#loading-container").addClass("loading-inactive");
		       	 },300);
		        },
		        url:__ctxPath + "/wfjpay/addMerchant",
		        data: $("#theForm").serialize(),
		        success: function(response) {
		        	if(response.success == 'true'){
						$("#modal-body-success").html("<div class='alert alert-success fade in'><strong>添加成功，返回列表页!</strong></div>");
	  	  				$("#modal-success").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-success"});
		        	}else if(response.data.errorMsg != ""){
		        	    $("#warning2Body").text(response.data.errorMsg);
						$("#warning2").show();
					}
	        	}
			});
		},
		fields : {
			name : {
				validators : {
					notEmpty : {
						message : '品牌名称不能为空'
					}
				}
			},
			merCode : {
				validators : {
					regexp: {
                        regexp: /^[A-Za-z0-9\s]{1,12}$/,
                        message: '商户编码必须由数字或字母或空格12位组成'
                    },
					notEmpty : {
						message : '商户编码不能为空'
					}
				}
			},
			feeCostRate : {
				validators : {
					regexp: {
                        regexp: /^\d+(\.\d+)?$/,
                        message: '费率必须为正数'
                    },
					notEmpty : {
						message : '费率不能为空'
					}
				}
			}
			
			
		}

	}).find('button[data-toggle]').on('click',function() {
		var $target = $($(this).attr('data-toggle'));
		$target.toggle();
		if (!$target.is(':visible')) {
			$('#theForm').data('bootstrapValidator').disableSubmitButtons(false);
		}
	});
	
		$("#close").click(function(){
			t = 0;
			$("#pageBody").load(__ctxPath+"/jsp/pay/merchant/list.jsp");
		});
}); 

	/* __ctxPath = "${pageContext.request.contextPath}";
	$(function(){
  		$("#save").click(function(){
  			saveFrom();
  		});
  		$("#close").click(function(){
  			$("#pageBody").load(__ctxPath+"/jsp/pay/merchant/list.jsp");
  		});
	});
  	//保存数据
  	function saveFrom(){
  		$.ajax({
	        type:"post",
	        contentType: "application/x-www-form-urlencoded;charset=utf-8",
	        url:__ctxPath + "/wfjpay/addMerchant",
	        dataType: "json",
	        data: $("#theForm").serialize(),
	        success:function(response) {
	        	if(response.success == 'true'){
					$("#modal-body-success").html("<div class='alert alert-success fade in'>"+
						"<i class='fa-fw fa fa-times'></i><strong>添加成功，返回列表页!</strong></div>");
  	  				$("#modal-success").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-success"});
				}else{
					// $("#model-body-success").html("<div class='alert alert-warning fade in'><i class='fa-fw fa fa-times'></i><strong>添加失败!</strong></div>");
 	     	  		//$("#modal-warning").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-warning"}); 
 	     	  	    $("#warning2Body").text(response.data.errorMsg);
					$("#warning2").show();
				
				}
        	}
		});
  	}
  	 */
  	 
  	 
  	  function attrChange(value){
  		 if(value=="1"){
  			neibuMerchant();
  			$("#option_merchant").show();
  			 $("#input_merchant").hide();
  		 }
  		 else if(value=="2"){
  			$("#option_merchant").hide();
  			 $("#input_merchant").show();
  		 }

  	 }
  	 
  	 function  neibuMerchant(){
  		$.ajax({
	        type:"post",
	        contentType: "application/x-www-form-urlencoded;charset=utf-8",
	        url:__ctxPath + "/wfjpay/paySystem/findAllListNoParam",
	        dataType: "json",
	        success:function(response) {
	        	if(response.success == 'true'){
	        		  var html=" ";
	    		        var arr=response.list;
	    		        for(var i=0;i<arr.length;i++){
	  					html+="<option value='"+arr[i].id+"'>"+arr[i].id+"</option>";	
	  				}
	  				$("#bpId_input").html(html);
	    		        
				}else{
					alert("请求失败");
				
				}
        	}
		});
  	 }
  	 
  	 
  	 
  	function successBtn(){
		$("#modal-success").attr({"style":"display:none;","aria-hidden":"true","class":"modal modal-message modal-success fade"});
		$("#pageBody").load(__ctxPath+"/jsp/pay/merchant/list.jsp");
	}
	</script> 
	</head>
<body>
	<div class="page-body">
		<div class="row">
			<div class="col-lg-12 col-sm-12 col-xs-12">
				<div class="row">
					<div class="col-lg-12 col-sm-12 col-xs-12">
						<div class="widget radius-bordered">
							<div class="widget-header">
								<span class="widget-caption">签约商户管理</span>
							</div>
							<div class="widget-body">
								<form id="theForm" method="post" class="form-horizontal" enctype="multipart/form-data">        
									<div class="form-group">
										<label class="col-lg-3 control-label">签约商户名称</label>
										<div class="col-lg-6">
											<input type="text" class="form-control" id="addMerchantName" name="name" placeholder="必填"/>
										</div>
									</div>
        
								
									<div class="form-group">
										<label class="col-lg-3 control-label">签约商户费率</label>
										<div class="col-lg-6">
											<input type="text" class="form-control" id="addMerchantFee" name="feeCostRate" placeholder="必填"/>
										</div>
									</div>
									
						<div class="form-group">
							<label class="col-lg-3 control-label">签约商户类型</label>
							<div class="radio">
								<label> <input class="basic divtype cart_flag" type="radio"
									id="merchantType_0" name="merchantType" value="1" onclick="attrChange(this.value)"> <span
									class="text">内部</span>
								</label> 
								<label> <input class="basic divtype cart_flag" type="radio"
									id="merchantType_1" name="merchantType" value="2" onclick="attrChange(this.value)"> <span
									class="text">外部</span>
								</label> 
								
								
							</div>
							<div class="form-group"  style="display:none"  id="option_merchant">
								
																
									  <label class="col-lg-3 control-label">内部请选择</label>
									  <div class="col-lg-6">
									  <ul class="topList clearfix">
									  <li class="col-md-2">
											<select id="bpId_input" style="padding: 0 0;" name="merCode">										
										</select>
									  </li>
								</ul>
								</div>
							</div>
							
															
							<div class="form-group"  style="display:none"  id="input_merchant">
							   <label class="col-lg-3 control-label">外部请填写</label>
							   <div class="col-lg-6">
								<input type="text" class="form-control" id="text_merchant" name="merCode" placeholder="必填"/>
								</div>
								
							</div>
							<div class="radio" style="display: none;">
								<label> <input class="inverted" type="radio"
									name="merchantType"> <span class="text"></span>
								</label>
							</div>
						</div>
						<div>
						
						
						</div>						
									<!-- <div class="form-group">
										<label class="col-lg-3 control-label">签约商户编码</label>
										<div class="col-lg-6">
											<input type="text" class="form-control" id="addMerchantCode" name="merCode" placeholder="必填"/>
										</div>
										<div  id="wrap">
										 <label> <input class="basic" type="radio"
															id="merchant_radio1" name="merchantType" value="1"  onclick="to_onclickVal()"> <span
															class="text">内部</span>
														</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										 <label> <input class="basic" type="radio"
															id="merchant_radio2" name="merchantType" value="2" onclick="to_onclickVal()"> <span
															class="text">外部</span>
														</label>
										</div>
									</div> -->
         							<div class="form-group">
										<div class="col-lg-offset-4 col-lg-6">
											<button class="btn btn-success" style="width: 25%;" id="save" type="submit" >保存</button>&emsp;&emsp;
											<input class="btn btn-danger" style="width: 25%;" id="close" type="button" value="取消"/>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
 <!-- /Page Body -->
	<script>
    </script>
</body>
</html>