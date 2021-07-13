<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">

	$(function(){

		showContactsPageList(1,3);

		$("#create-customerName").typeahead({
			//最多显示的下拉列表内容
			items:8,
			//将浏览器默认提示关闭
			autocomplete:"off",
			source: function (query, process) {
				$.get(
						"workbench/transaction/getCustomerName.do",
						{ "name" : query },
						function (data) {
							//alert("返回数据"+data);
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});



		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});







		$("#createBtn").click(function () {

			$.ajax({
				url : "workbench/contacts/getUserList.do",
				type : "get",
				dataType : "json",
				success : function (data) {


						var html = "<option></option>";
						$.each(data,function (i,n) {
                          html +="<option value='"+n.id+"'>"+n.name+"</option>";

						})
						$("#create-owner").html(html);

						var id ="${user.id}";

						$("#create-owner").val(id);

						$("#createContactsModal").modal("show");

				}

			})

		})






		$("#saveBtn").click(function () {

			$.ajax({
				url : "workbench/contacts/saveContacts.do",
				data : {
					"owner":$.trim($("#create-owner").val()),
					"source":$.trim($("#create-source").val()),
					"customerName":$.trim($("#create-customerName").val()),
					"fullname":$.trim($("#create-fullname").val()),
					"appellation":$.trim($("#create-appellation").val()),
					"email":$.trim($("#create-email").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"job":$.trim($("#create-job").val()),
					"birth":$.trim($("#create-birth").val()),
					"description":$.trim($("#create-description").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {

					if (data) {
                      alert("保存联系人成功");
						$("#create-owner").val("");
						$("#create-source").val("");
						$("#create-customerName").val("");
						$("#create-fullname").val("");
						$("#create-appellation").val("");
						$("#create-email").val("");
						$("#create-mphone").val("");
						$("#create-job").val("");
						$("#create-birth").val("");
						$("#create-description").val("");
						$("#create-contactSummary").val("");
						$("#create-nextContactTime").val("");
						$("#create-address").val("");
                      location.reload();

						//showContactsPageList(1,3);
					} else {
						alert("保存联系人失败");
					}

				}

			})
		})





        $("#editBtn").click(function () {
            var $xz = $("input[name=xz]:checked");
            var id =$xz.val();
            //alert($xz)
            //alert(id)
            if ($xz.length == 0) {
                alert("请选择需要修改的联系人记录")
            }else if ($xz.length > 1) {
                alert("只能修改一条联系人记录");
            } else {

                $.ajax({
                    url : "workbench/contacts/getUserListAndContacts.do",
                    data : {
                      "id":id
                    },
                    type : "get",
                    dataType : "json",
                    success : function (data) {


                        var html = "<option></option>";
                        $.each(data.uList,function (i,n) {
                         html += "<option value='"+n.id+"'>"+n.name+"</option>";
                        })
                        $("#edit-owner").html(html);

                        //处理Contacts单条数据
                            $("#edit-appellation").val(data.con.appellation);
                            $("#edit-source").val(data.con.source);

                            $("#edit-id").val(data.con.id);
                            $("#edit-owner").val(data.con.owner);
                            $("#edit-job").val(data.con.job);
                            $("#edit-mphone").val(data.con.mphone);
                            $("#edit-address").val(data.con.address);
                            $("#edit-nextContactTime").val(data.con.nextContactTime);
                            $("#edit-contactSummary").val(data.con.contactSummary);
                            $("#edit-fullname").val(data.con.fullname);
                            $("#edit-email").val(data.con.email);
                            $("#edit-birth").val(data.con.birth);
                            $("#edit-description").val(data.con.description);
                            $("#edit-customerName").val(data.con.customerId);

                            $("#edit-hiddenId").val(data.cusId.customerId);

                            $("#editContactsModal").modal("show");

                    }

                });
            }

        })




        $("#updateBtn").click(function () {
            var $xz = $("input[name=xz]:checked");
            var id =$xz.val();

            if ($xz.length == 0) {
                alert("请选择需要修改的联系人记录");
            }else if ($xz.length > 1) {
                alert("只能一次修改一条联系人记录");
            }
            $.ajax({
                url : "workbench/contacts/updateContactsById.do",
                data : {
                    "id":id,
                    "owner":$.trim($("#edit-owner").val()),
                    "source":$.trim($("#edit-source").val()),
                    "customerId":$.trim($("#edit-hiddenId").val()),
                    "fullname":$.trim($("#edit-fullname").val()),
                    "appellation":$.trim($("#edit-appellation").val()),
                    "email":$.trim($("#edit-email").val()),
                    "mphone":$.trim($("#edit-mphone").val()),
                    "job":$.trim($("#edit-job").val()),
                    "birth":$.trim($("#edit-birth").val()),
                    "description":$.trim($("#edit-description").val()),
                    "contactSummary":$.trim($("#edit-contactSummary").val()),
                    "nextContactTime":$.trim($("#edit-nextContactTime").val()),
                    "address":$.trim($("#edit-address").val()),
					"customerName":$.trim($("#edit-customerName").val()),

                },
                type : "post",
                dataType : "json",
                success : function (data) {

                    if (data) {
                        alert("成功");
                        location.reload();
                    } else {
                        alert("失败");
                    }

                }

            });
        })





		$("#qx").click(function () {
         $("input[name=xz]").prop("checked",this.checked);
		})

		$("#deleteBtn").click(function () {
           var $xz = $("input[name=xz]:checked");

           var param = "";
			if (confirm("确定删除记录吗?")) {
				for (var i = 0; i < $xz.length; i++) {
					param += "id="+$($xz[i]).val();
					if (i < $xz.length - 1) {
						param += "&";
					}
				}
                 //alert(param);
				$.ajax({
					url : "workbench/contacts/deleteContactsById.do",
					data :param,
					type : "post",
					dataType : "json",
					success : function (data) {

						if (data) {
							alert("删除成功");
							location.reload();
						} else {
							alert("删除失败");
						}

					}

				})
			}


		})




		//给回车绑定一个查询事件
		


        //根据搜索框条件查询联系人
        $("#searchContacts").click(function () {

            $.ajax({
                url : "workbench/contacts/searchContactsByCondition.do",
                data : {
                    "owner":$.trim($("#search-owner").val()),
                    "source":$.trim($("#search-source").val()),
                    "customerId":$.trim($("#search-customerId").val()),
                    "fullname":$.trim($("#search-fullname").val()),
                    "birth":$.trim($("#search-birth").val()),
                },
                type : "get",
                dataType : "json",
                success : function (data) {

                    var html = "";
                    $.each(data,function (i,n) {
                       html += '<tr>';
                       html += '<td><input type="checkbox" id="'+n.id+'" name="xz"/></td>';
                       html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id=\''+n.id+';">'+n.fullname+'</a></td>';
                        html +='<td>'+n.customerId+'</td>';
                        html +='<td>'+n.owner+'</td>';
                        html +='<td>'+n.source+'</td>';
                        html +='<td>'+n.birth+'</td>';
                       html += '</tr>';
                    })

                    $("#contactsBody").html(html);

                }

            })

        })






	});



	function showContactsPageList(pageNo,pageSize) {

		$.ajax({
			url : "workbench/contacts/getContactsList.do",
			data : {
               "pageNo":pageNo,
				"pageSize":pageSize,
				"owner":$.trim($("#search-owner").val()),
				"source":$.trim($("#search-source").val()),
				"customerId":$.trim($("#search-customerId").val()),
				"fullname":$.trim($("#search-fullname").val()),
				"birth":$.trim($("#search-birth").val()),
			},
			type : "get",
			dataType : "json",
			success : function (data) {

				if (data) {
					var html = "";
					$.each(data.dataList,function (i,n) {

						html +='<tr>';
						html +='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html +='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
						html +='<td>'+n.customerId+'</td>';
						html +='<td>'+n.owner+'</td>';
						html +='<td>'+n.source+'</td>';
						html +='<td>'+n.birth+'</td>';
						html +='</tr>';

					})
					$("#contactsBody").html(html);

					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					//数据处理完毕后，结合分页查询，对前端展现分页信息
					$("#contactsPage").bs_pagination({
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
							showContactsPageList(data.currentPage , data.rowsPerPage);
						}
					});
				}

			}

		})

	}


	
</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<%--<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>--%>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								  <%--<option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customer" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">

							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" readonly placeholder="点击选择下次联系时间" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

                        <input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
                                    <c:forEach items="${sourceList}" var="s">
                                        <option value="${s.value}" ${s.id eq con.id ? "selected" : ""}>${s.text}</option>
                                    </c:forEach>
								 <%-- <option selected>广告</option>
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
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
                                    <c:forEach items="${appellationList}" var="a">
                                        <option value="${a.value}" ${a.id eq con.id ? "selected" : ""}>${a.text}</option>
                                    </c:forEach>
								  <%--<option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
                                <input type="hidden" id="edit-hiddenId">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text"readonly placeholder="点击选择下次联系时间"  class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" id="search-fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" id="search-customerId" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源1</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
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
				      <div class="input-group-addon">生日1</div>
				      <input class="form-control" id="search-birth" type="text">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchContacts">查询1</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="createBtn" class="btn btn-primary" data-toggle="modal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editBtn" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>--%>
                        <%--<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="contactsPage"></div>
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
				<%--<div style="position: relative;top: -88px; left: 285px;">
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