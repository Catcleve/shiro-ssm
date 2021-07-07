<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">

  <link href="/shiro/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
  <link href="/shiro/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
        type="text/css" rel="stylesheet"/>

  <script type="text/javascript" src="/shiro/jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="/shiro/jquery/vue.js"></script>
  <script type="text/javascript" src="/shiro/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
  <script type="text/javascript"
          src="/shiro/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
  <script type="text/javascript"
          src="/shiro/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"
          charset="UTF-8"></script>


  <link href="/shiro/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
  <script type="text/javascript" src="/shiro/jquery/bs_pagination/en.js" charset=”gb2312″></script>
  <script type="text/javascript" src="/shiro/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>


  <script type="text/javascript" src="/shiro/jquery/layer/layer/layer.js"></script>
  <script type="text/javascript" src="/shiro/jquery/ajaxfileupload.js"></script>

</head>
<body style="overflow-x:hidden;overflow-y:auto">

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 85%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
      </div>
      <div class="modal-body">

        <form class="form-horizontal" role="form" id="addForm">

          <div class="form-group" id="app">
            <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者
              <span style="font-size: 15px; color: red;">*</span>
            </label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="create-marketActivityOwner" name="owner">
                <option value="">请选择</option>
                <option v-for="(key,value) in users" :value="value">{{key}}</option>
              </select>
            </div>
            <label for="create-marketActivityName" class="col-sm-2 control-label">名称
              <span style="font-size: 15px; color: red;">*</span>
            </label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-marketActivityName" name="name">
            </div>
          </div>

          <div class="form-group">
            <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-startTime" name="startDate">
            </div>
            <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-endTime" name="endDate">
            </div>
          </div>
          <div class="form-group">

            <label for="create-cost" class="col-sm-2 control-label">成本</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-cost" name="cost">
            </div>
          </div>
          <div class="form-group">
            <label for="create-describe" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 81%;">
              <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" onclick="saveActivity()">保存</button>
      </div>
    </div>
  </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 85%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
      </div>
      <div class="modal-body">

        <form class="form-horizontal" role="form" id="editForm">

          <div class="form-group">
            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者
              <span style="font-size: 15px; color: red;">*</span>
            </label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-marketActivityOwner" name="owner">

              </select>
            </div>
            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称
              <span style="font-size: 15px; color: red;">*</span>
            </label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-marketActivityName" name="name">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-startTime" name="startDate">
            </div>
            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-endTime" name="endDate">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-cost" name="cost">
            </div>
          </div>

          <div class="form-group">
            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 81%;">
                                            <textarea class="form-control" rows="3" id="edit-describe"
                                                      name="description">

                                            </textarea>
            </div>
          </div>

          <input type="hidden" name="id" id="edit-id">

        </form>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="updateBtn()">更新</button>
      </div>
    </div>
  </div>
</div>

<%--标题--%>
<div>
  <div style="position: relative; left: 10px; top: -10px;">
    <div class="page-header">
      <h3>市场活动列表</h3>
    </div>
  </div>
</div>

<%--主列表--%>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
  <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

    <div class="btn-toolbar" role="toolbar" style="height: 80px;">
      <form class="form-inline" role="form" id="queryForm" style="position: relative;top: 8%; left: 5px;">

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">名称</div>
            <input class="form-control" name="name" id="name" type="text">
          </div>
        </div>

        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">所有者</div>
            <input class="form-control" id="owner" type="text">
          </div>
        </div>


        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">开始日期</div>
            <input class="form-control" type="text" name="startDate" id="startTime"/>
          </div>
        </div>
        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">结束日期</div>
            <input class="form-control" type="text" name="endDate" id="endTime">
          </div>
        </div>

        <button type="button" onclick="goPage(1,5)" class="btn btn-default">查询</button>

      </form>
    </div>
    <div class="btn-toolbar" role="toolbar"
         style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
      <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" id="createBtn" onclick="createActivity()" data-toggle="modal">
          <span class="glyphicon glyphicon-plus"></span>
          创建
        </button>
        <button type="button" class="btn btn-default" onclick="editActivity()">
          <span class="glyphicon glyphicon-pencil"></span>
          修改
        </button>
        <button type="button" class="btn btn-danger" onclick="deleteActivity()">
          <span class="glyphicon glyphicon-minus"></span>
          删除
        </button>
      </div>
      <button type="button" class="btn btn-default" style="position: relative;left: 50px;top: 9px"
              onclick="outputExcel()">
        导出为excel
      </button>
    </div>
    <div style="position: relative;top: 10px;">
      <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
          <td>
            <input type="checkbox" id="checkAll"/>
          </td>
          <td>名称</td>
          <td>所有者</td>
          <td>开始日期</td>
          <td>结束日期</td>
        </tr>
        </thead>
        <tbody id="activeList">

        </tbody>
      </table>
    </div>

    <div id="activityPage">

    </div>
  </div>
</div>


<script type="text/javascript">

  function createActivity() {
    $.ajax({
      url: '/shiro/workbench/activity/add',
      type: 'post',
      dataType: 'json',
      success: function () {
        $("#createActivityModal").modal('show')
        layer.msg("有权限");
      },
      error: function () {
        layer.msg("无权限")
        $("#createBtn").attr("disabled", "disabled")
      }
    })

      /* $.post('/shiro/workbench/activity/add', function (data) {
           if (data) {
               layer.msg("有权限");
           } else {
               layer.msg("无权限")
           }
       }, 'json');
*/
  }


</script>

</body>
</html>