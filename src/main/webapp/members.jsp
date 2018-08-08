<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
	
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
  
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <!-- Firefox doesnt support link imports yet
  <link rel="import" href="datatables-dependencies.jsp">
  -->
  <%@include file="datatables-dependencies.jsp"%>

  <!-- #### DATATABLES ### -->
  
	<body class="is-preload">
  	<%@include file="nav.jsp"%>
  	
		<%@include file="breadcrumbs.jsp"%>
  	
  	
  	<!-- #### DATATABLES ### -->
		<script>
			function deleteItem(custId, memberId){
			  httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+custId+"/members/"+memberId);
			}
			function onDatatableRefresh(json){
				buttonEnablement();
			}
			$(document).ready(function() {
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						if (undefined!=setBreadcrumbs) setBreadcrumbs("members", customer);
					});
					
					// ### populate the customer members in the datatable
			    $('#example').DataTable( {
			        "ajax": {
			            //"url": '${pageContext.request.contextPath}/api/pathfinder/customers/"+request.getParameter("customerId")+"/members/',
			            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+'/members/',
			            "data":{"_t":jwtToken},
			            "dataSrc": "",
			            "dataType": "json"
			        },
			        "scrollCollapse": true,
			        "paging":         false,
			        
			        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
			        "pageLength" : 10, // default page entries
			        "bInfo" : false, // removes "Showing N entries" in the table footer
			        "order" : [[1,"asc"]],
			        "columns": [
			            { "data": "Id" },
			            { "data": "Username" },
			            { "data": "DisplayName" },
			            { "data": "Email" },
			        ]
			        ,"columnDefs": [
			        	{ "targets": 0, "orderable": false, "render": function (data,type,row){
									return "<input type='checkbox' name='id' value='"+row['Id']+"'></input>";
								}},
				      	{ "targets": 1, "orderable": true, "render": function (data,type,row){
								  return row['Username']+"&nbsp;<span class='editLink'>(<a href='#' onclick='loadEntity(\""+row["Username"]+"\");' data-toggle='modal' data-target='#exampleModal'>edit</a>)</span>";
								  
								  //return "<a href='#' onclick='loadEntity(\""+row["Id"]+"\"); return false;' data-toggle='modal' data-target='#exampleModal'>"+row['Username']+"</a>";
								}},
			        ]
			    } );
			} );
			
			// ### enable/disable handlers for buttons on datatable buttonbar
			$(document).on('click', "input[type=checkbox]", function() {
				buttonEnablement();
			});
			buttonEnablement();
			function buttonEnablement(){
			  $('button[name="btnDelete"]').attr('disabled', $('#example input[name="id"]:checked').length<1);
			}
			// ### End: enable/disable handlers for buttons on buttonbar
			
			function btnDelete_onclick(caller){
				if (!confirm("Are you sure?")){
						return false;
				}else{
				  var idsToDelete=[];
					$('#example input[name="id"]').each(function() {
						if ($(this).is(":checked")) {
						  idsToDelete[idsToDelete.length]=$(this).val();
						}
					});
					caller.disabled=true;
					httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+Utils.getParameterByName("customerId")+"/members/", idsToDelete);
				}
			}

		</script>

		<div id="wrapper" class="container-fluid">
			<div id="buttonbar">
				<div class="row page-title">
					<div class="col-xs-4">
						<h2>Members</h2>
					</div>
					<div class="col-xs-1 pull-right">
						<div class="form-group">
							<button class="form-control btn btn-primary" name="New" onclick="editFormReset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
						</div>
					</div>
					<div class="col-xs-1 pull-right">
						<div class="form-group">
							<button class="form-control btn btn-danger" name="btnDelete" disabled onclick="btnDelete_onclick(this);" type="button">Remove</button>
						</div>
					</div>
				</div>
			</div>
			<div id="tableDiv">
				<table id="example" class="display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th align="left"></th>
							<th align="left">Username</th>
							<th align="left">DisplayName</th>
							<th align="left">Email</th>
						</tr>
					</thead>
				</table>
			</div>
    </div>
    

		<%@include file="newMemberForm.jsp"%>

	</body>
</html>