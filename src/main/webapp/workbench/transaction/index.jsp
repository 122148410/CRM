<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});


		pageTransactionList(1,5);





		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

    $("#transactionUpdate").click(function () {
             var $xz = $("input[name=xz]:checked");
             var id = $xz.val();
            // alert($xz);
            //alert(id);

            if ($xz.length == 0) {
                alert("请选择修改记录transaction");
            } else if ($xz.length > 1) {
                alert("只能修改一条记录transaction");
            } else {

                $.ajax({
                    url : "workbench/transaction/transactionUpdate.do",
                    data : {
                       "id":id
                    },
                    type : "post",
                    dataType : "json",
                    success : function (data) {

						window.location.href='workbench/transaction/edit.do?id='+id;

                    }

                })
            }

        })



		$("#deleteBtn").click(function () {
            var $xz = $("input[name=xz]:checked");

			if ($xz == 0) {
				alert("请选择删除的交易记录");
			} else {

				if (confirm("确定删除吗")) {

					var param= "";
					for (var i = 0; i < $xz.length; i++) {
						param +="id="+$($xz[i]).val();
						if (i < $xz.length-1) {
							param += "&";
						}
					}
					//alert(i)
					//alert(param);
					$.ajax({
						url : "workbench/transaction/delete.do",
						data :param,
						type : "post",
						dataType : "json",
						success : function (data) {

							if (data) {

								//操作后维持已经设置好的每页展现的记录数
								pageTransactionList(1,2);
								alert("删除成功");
							} else {
								alert("删除失败");
							}
						}

					})
				}

			}

		})


		$("#transactionQuery").click(function () {

			$("#hidden-name").val($.trim($("#create-name").val()));
			$("#hidden-owner").val($.trim($("#create-owner").val()));
			$("#hidden-customerId").val($.trim($("#create-customerId").val()));
		    $("#hidden-stage").val($.trim($("#create-stage").val()));
			$("#hidden-type").val($.trim($("#create-type").val()));
			$("#hidden-source").val($.trim($("#create-source").val()));
			$("#hidden-contactsId").val($.trim($("#create-contactsId").val()));

			pageTransactionList(1,$("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));

		})





	});


	function pageTransactionList(pageNo,pageSize) {

		$("#create-owner").val($.trim($("#hidden-owner").val()));
		$("#create-name").val($.trim($("#hidden-name").val()));
		$("#create-customerId").val($.trim($("#hidden-customerId").val()));
		$("#create-stage").val($.trim($("#hidden-stage").val()));
		$("#create-type").val($.trim($("#hidden-type").val()));
		$("#create-source").val($.trim($("#hidden-source").val()));
		$("#create-contactsId").val($.trim($("#hidden-contactsId").val()));

		//alert($("#create-stage").val())

	   $.ajax({
		   url : "workbench/transaction/pageTransactionList.do",
		   data : {
               "pageNo":pageNo,
			   "pageSize":pageSize,
			   "owner":$.trim($("#create-owner").val()),
			   "name":$.trim($("#create-name").val()),
			   "customerId":$.trim($("#create-customerId").val()),
			   "stage":$.trim($("#create-stage").val()),
			   "type":$.trim($("#create-type").val()),
			   "source":$.trim($("#create-source").val()),
			   "contactsId":$.trim($("#create-contactsId").val()),

		   },
		   type : "get",
		   dataType : "json",
		   success : function (data) {

		   	     var html = "";
			   $.each(data.dataList,function (i,n) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.type+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.contactsId+'</td>';
					html += '</tr>';

			   })
			   $("#transactionBody").html(html);

				//计算总页数
			   var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

			   //数据处理完毕后，结合分页查询，对前端展现分页信息
			   $("#transactionPage").bs_pagination({
				   currentPage: pageNo, // 页码
				   rowsPerPage: pageSize, // 每页显示的记录条数
				   maxRowsPerPage: 20, // 每页最多显示的记录条数
				   totalPages: totalPages, // 总页数
				   totalRows: data.total, // 总记录条数

				   visiblePageLinks: 5, // 显示几个卡片

				   showGoToPage: true,
				   showRowsPerPage: true,
				   showRowsInfo: true,
				   showRowsDefaultInfo: true,

				   //该回调函数时在，点击分页组件的时候触发的
				   onChangePage : function(event, data){
					   pageTransactionList(data.currentPage , data.rowsPerPage);
				   }
			   });
		   }

	   })

   }
	
</script>
</head>
<body>

       <input type="hidden" id="hidden-owner">
       <input type="hidden" id="hidden-name">
       <input type="hidden" id="hidden-customerId">
       <input type="hidden" id="hidden-stage">
       <input type="hidden" id="hidden-type">
       <input type="hidden" id="hidden-source">
       <input type="hidden" id="hidden-contactsId">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者1</div>
				      <input class="form-control" type="text" id="create-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称1</div>
				      <input class="form-control" type="text" id="create-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="create-customerId">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="create-stage">
					  	<option></option>
						  <c:forEach items="${stageList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						<%--<option>资质审查</option>
					  	<option>需求分析</option>
					  	<option>价值建议</option>
					  	<option>确定决策者</option>
					  	<option>提案/报价</option>
					  	<option>谈判/复审</option>
					  	<option>成交</option>
					  	<option>丢失的线索</option>
					  	<option>因竞争丢失关闭</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="create-type">
					  	<option></option>
						  <c:forEach items="${transactionTypeList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  	<%--<option>已有业务</option>
					  	<option>新业务</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="create-source">
						  <option></option>
                           <c:forEach items="${sourceList}" var="source">
							   <option value="${source.value}">${source.text}</option>
						   </c:forEach>
						  <%--<option>广告</option>
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
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="create-contactsId">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="transactionQuery">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="transactionUpdate" <%--onclick="window.location.href='workbench/transaction/edit.do';"--%>><span class="glyphicon glyphicon-pencil"></span> 修改1</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?id=43f5dc82ed3346338f308f07d6276695';">1万块</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>--%>
                       <%-- <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div id="transactionPage" style="height:60px; position: relative;top:5px;">
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>--%>
				<%--<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>--%>
			<%--	<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>