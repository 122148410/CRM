<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.mo.crm.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	//准备字典类型为stage的字典值列表
	List<DicValue> dvList = (List<DicValue>)application.getAttribute("stageList");

	//准备阶段和可能性之间的对应关系
	Map<String,String> pMap = (Map<String,String>)application.getAttribute("pMap");

	//根据pMap准备pMap中的key集合
	Set<String> set = pMap.keySet();

	//准备：前面正常阶段和后面丢失阶段的分界点下标
	int point = 0;
	for(int i=0;i<dvList.size();i++){

		//取得每一个字典值
		DicValue dv = dvList.get(i);

		//从dv中取得value
		String stage = dv.getValue();
		//根据stage取得possibility
		String possibility = pMap.get(stage);


	}
%>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>


<script type="text/javascript">

        $(function(){

        	//alert("transaction/edit");


			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});



			$("#updateBtn").click(function () {
			var	id = $("#editTran-id").val()
				//alert(id);
				$.ajax({
					url : "workbench/transaction/updateTranById.do",
					data : {
						"id":$("#editTran-id").val(),
						"owner":$.trim($("#editTran-owner").val()),
						"money":$.trim($("#editTran-money").val()),
						"name":$.trim($("#editTran-name").val()),
						"expectedDate":$.trim($("#editTran-expectedDate").val()),
						"customerId":$.trim($("#edit-customerId").val()),
						"stage":$.trim($("#editTran-stage").val()),
						"type":$.trim($("#editTran-type").val()),
						"source":$.trim($("#editTran-source").val()),
						"activityId":$.trim($("#edit-activityId").val()),
						"contactsId":$.trim($("#edit-contactsId").val()),
						"description":$.trim($("#editTran-description").val()),
						"contactSummary":$.trim($("#editTran-contactSummary").val()),
						"nextContactTime":$.trim($("#editTran-nextContactTime").val())

					},
					type : "post",
					dataType : "json",
					success : function (data) {

						if (data) {

                           window.location.href="workbench/transaction/index.jsp";
                          // window.location.reload();
							//alert("更新交易成功")

						} else {
							alert("更新交易失败")
						}

					}

				})
			})



			//searchTranById();

        });

      /*  function searchTranById() {

			alert("searchTranById");
            $.ajax({
                url : "workbench/transaction/searchTranById.do",
                data : {
                   "id":id
                },
                type : "get",
                dataType : "json",
                success : function (data) {

                    var html = "<option></option>"

                    $.each(data.usList,function (i,n) {
                        html += "<option value='"+n.id+"'>"+n.name+"</option>";
                    })
                    $("#editTran-owner").html(html);

                    //处理Tran单条属性
					$("#editTran-id").val(data.t.id);
                    $("#editTran-owner").val(data.t.owner);
					$("#editTran-money").val(data.t.money);
					$("#editTran-name").val(data.t.name);
					$("#editTran-expectedDate").val(data.t.expectedDate);
					$("#editTran-customerId").val(data.t.customerId);
					$("#editTran-stage").val(data.t.stage);
					$("#editTran-type").val(data.t.type);
					$("#editTran-source").val(data.t.source);
					$("#editTran-possibility").val(data.t.possibility);



                }

            })
        }*/


    </script>
</head>
<body>

	<!-- 查找市场活动 -->
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动1</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>


	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="updateBtn" class="btn btn-primary">1更新</button>
			<button type="button" onclick="location.href='javascript:history.back()'" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" id="transactionForm" role="form" style="position: relative; top: -30px;">

		<input type="hidden" id="editTran-id" value="${tran.id}"/>

		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="editTran-owner">
					<c:forEach items="${uList}" var="u">
						<option value="${u.id}"  ${user.id eq u.id ? "selected" : ""}> ${u.name} </option>
					</c:forEach>
				  <%--<option selected>zhangsan</option>
                    <option>lisi</option>
				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="editTran-money" value="${tran.money}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" value="${tran.name}" id="editTran-name" >
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly placeholder="点击修改时间" value="${tran.expectedDate}" class="form-control time1" id="editTran-expectedDate" >
			</div>
		</div>

		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" value="${tran.customerId}" id="editTran-customerId" placeholder="支持自动补全，输入客户不存在则新建">
                <input type="hidden" id="edit-customerId" value="${t.customerId}">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="editTran-stage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.value}" ${s.value eq tran.stage ? "selected" : ""}>${s.text}</option>
				  </c:forEach>
			  	<%--<option>资质审查</option>
			  	<option>需求分析</option>
			  	<option>价值建议</option>
			  	<option>确定决策者</option>
			  	<option>提案/报价</option>
			  	<option selected>谈判/复审</option>
			  	<option>成交</option>
			  	<option>丢失的线索</option>
			  	<option>因竞争丢失关闭</option>--%>
			  </select>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="editTran-type">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}" ${t.value eq tran.type ? "selected" : ""} >${t.text}</option>
					</c:forEach>
				  <%--<option>已有业务</option>
				  <option selected>新业务</option>--%>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly class="form-control" value="${tran.possibility}" id="editTran-possibility">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="editTran-source">
				  <option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}" ${s.value == tran.source ? "selected" : ""}>${s.text}</option>
					</c:forEach>
					<%--<option selected>${tran.source}</option>--%>
				  <%--<option selected>广告</option>
				  <option>推销电话</option>
				  <option>员工介绍</option>
				  <option>外部介绍</option>
				  <option>在线商场</option>
				  <option>合作伙伴</option>
				  <option>公开媒介</option>
				  <option>销售邮件</option>
				  <option>合作伙伴研讨会</option>
				  <option>内部研讨会</option>
				  <option>交易会</option>
				  <option>web下载</option>
				  <option>web调研</option>
				  <option>聊天</option>--%>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" value="${tran.activityId}" id="editTran-activityId" >
                <input type="hidden" id="edit-activityId" value="${t.activityId}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" value="${tran.contactsId}" id="editTran-contactsId">
                <input type="hidden" id="edit-contactsId" value="${t.contactsId}">
			</div>
		</div>

		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="editTran-description">${tran.description}</textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="editTran-contactSummary">${tran.contactSummary}</textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly placeholder="点击修改时间" value="${tran.nextContactTime}" class="form-control time2" id="editTran-nextContactTime">
			</div>
		</div>

	</form>
</body>
</html>