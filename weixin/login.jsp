<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="com.lineteam.util.StringUtils"%>
<%@ page import="com.lineteam.db.QueryUtil"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.lineteam.security.SecurityObjectBuilder"%>
<%@ page import="com.param.SessionParam"%>
<%@ page import="com.util.cache.CacheFactory"%>
<%@ page import="com.util.cache.Cache"%>
<%@ page import="javax.ws.rs.core.MediaType"%>
<%@ page import="com.param.RestParams"%>
<%@ page import="org.feuyeux.jaxrs2.atup.core.rest.AtupRequest"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.lineteam.util.HashEncrypt"%>
<%@ page import="com.app.ajax.weixin.repair.RepairAjax"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ page import="com.app.common.AppUser"%>
<%
	SessionParam param=new SessionParam(request);
	String ROOTPath = request.getContextPath();
	if ("/".equals(ROOTPath)){
		ROOTPath="";
	}
	String userName = request.getParameter("username");
	String passWord = request.getParameter("password");
	String appId = request.getParameter("appId");
	String message = "";
	if(!StringUtils.isBlank(userName) && !StringUtils.isBlank(passWord)){
		QueryUtil query =  QueryUtil.getInstance();
		Map userMap = query.firstRecord("select a.ID, a.NAME, a.SCHOOL_ID, a.OBJECT_NAME, ifnull(b.URL, '/Res/images/defaultHead.jpg') as ICON " 
				+ "from t_user a left join T_HEAD_PIC b on a.ID=b.user_id " 
				+ "where a.username=? and a.password=?", 
				new String[]{userName, HashEncrypt.getHash(passWord)});
		if(userMap != null && !userMap.isEmpty()){
			String userId = BeanUtils.getPropertyStr(userMap, "ID");
			String userType = BeanUtils.getPropertyStr(userMap, "OBJECT_NAME");
			/*
			private String userId;
			private String userType;
			private String schoolId;
			private String name;
			private String termId;
			private String loginType="APP";
			private String classIds;		//相关班级
			private String icon;			//用户头像
			private String status;
			
			private String dbId;			//用户所在数据库ID
			
			private String stuDbId;			//当前子女所在数据库ID
			private String studentId; 		//子女ID
			private String studentName; 	//子女姓名
			private String parentTitle;		//家长称谓
			
			private String token;			//用户相关验证token
			*/
			AppUser user = new AppUser();
			user.setUserId(userId);
			user.setOpenId("oNcu8wSoF4A7wkzoyUEXSr7b32uA");
			user.setUserType(userType);
			String schoolId = BeanUtils.getPropertyStr(userMap, "SCHOOL_ID");
			user.setSchoolId(schoolId);
			String termId = "201602";
			user.setTermId(termId);
			user.setName(BeanUtils.getPropertyStr(userMap, "NAME"));
			user.setLoginType("WEIXIN");
			user.setIcon(ROOTPath+BeanUtils.getPropertyStr(userMap, "ICON"));
			user.setStatus("1");
			String studentId = "";
			String studentName = "";
			String parentTitle = "";
			String classId = "";
			boolean flag = true;
			if("T_PARENT".equals(userType)){
				Map parentMap = query.firstRecord("select a.STUDENT_ID, b.NAME as STUDENT_NAME, a.PARENT_TITLE, b.CLASS_ID " 
						+ "from t_student_parents a inner join t_STUDENT b on a.student_id=b.id " 
						+ "where a.school_id=? and a.parent_id=?", 
						new String[]{schoolId, userId});
				if(parentMap != null && !parentMap.isEmpty()){
					studentId = BeanUtils.getPropertyStr(parentMap, "STUDENT_ID");
					studentName = BeanUtils.getPropertyStr(parentMap, "STUDENT_NAME");
					parentTitle = BeanUtils.getPropertyStr(parentMap, "PARENT_TITLE");
					classId = BeanUtils.getPropertyStr(parentMap, "CLASS_ID");
				}else {
					message = "家长找不到匹配学生信息";
					flag = false;
				}
			}else if("T_STUDENT".equals(userType)){
				Map classMap = query.firstRecord("select CLASS_ID from t_STUDENT where id=?", 
						new String[]{userId});
				if(classMap != null && !classMap.isEmpty()){
					classId = BeanUtils.getPropertyStr(classMap, "CLASS_ID");
				}
			}else if("T_TEACHER".equals(userType)){
				List classList = query.executeQuery("select a.CLASS_ID from t_class_course a inner join t_class b " 
						+ "on a.class_id=b.id where a.school_id=? and b.term_id=? " 
						+ "and (a.teacher_id=? or b.teacher_id=? or b.fteacher_id=?)"
						, new String[]{schoolId, termId, userId, userId, userId});
				for(Object obj : classList){
					String cid = BeanUtils.getPropertyStr(obj, "CLASS_ID");
					classId = ("".equals(classId) ? "" : classId + ",") + "'"+cid+"'";
				}
				String deptCodes="";
				//查询老师所属部门
				List deptList = query.executeQuery("SELECT dept.CODE FROM T_DEPT_MEMBER man INNER JOIN T_DEPARTMENTS dept " 
						+ "ON man.dept_id=dept.code WHERE dept.school_id=? AND teacher_id=?", new String[]{schoolId, userId});
				for(Object obj : deptList){
					String code = BeanUtils.getPropertyStr(obj, "CODE");
					deptCodes = ("".equals(code) ? "" : deptCodes + ",") + code;
				}
				user.setDeptCodes(deptCodes);
			}
			//检查报修管理权限
			RepairAjax repairAjax = new RepairAjax();
			user.setIsRepairManager(repairAjax.isRepairManager(user));
			//检查一卡通微信充值权限
			user.setUseYKTWXPay(1==query.executeCountQuery("select count(code) from t_extra_funcs " 
					+ "where school_id=? and object_id=? and code='YKT_WXPAY'", new String[]{user.getSchoolId(), appId}));
			//设置子女相关信息
			user.setClassIds(classId);
			user.setStudentId(studentId);
			user.setStudentName(studentName);
			user.setParentTitle(parentTitle);
			if(flag){
				LogUtil.info("--------------- login.jsp setSecurityObject --------------- "+request.hashCode());
				param.setSecurityObject(SecurityObjectBuilder.build());
				param.setLqtWeixinUser(user);
				param.setLqtWeixinAPPId(appId);
				response.sendRedirect("wechat/views/profile/profile.jsp");
				return;
			}
		}else {
			message = "用户名或密码错误";
		}
	}
%>

<html>
  	<head>
  		<meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
    	<link rel="stylesheet" href="../Res/css/bootstrap.min.css">
    	<title>登录测试</title>
  	</head>
  	<body>
  		<div class="panel-body">
	  		<form class="form" action="#" method="post">
	  			<h3 class="text-center">
                    <br>
                </h3>
                <div class="form-group">
                    <label class="control-label">微信</label>
		  			<select class="form-control" type="text" name="appId">
		  				<option value="wx7fa6586991d600f0">测试公众号</option>
		  				<option value="wx2e3a10f99ee1c75e">主云公众号</option>
		  				<option value="wx31be818db324cf0e">华二公众号</option>
		  				<option value="wx0ee5d0c883ef98c7">北大公众号</option>
		  			</select>
		  		</div>
	  			<div class="form-group">
                    <label class="control-label">帐号</label>
		  			<input class="form-control" type="text" name="username" />
		  		</div>
		  		<div class="form-group">
                    <label class="control-label">密码</label>
		  			<input class="form-control" type="password" name="password" />
		  		</div>	  			
	  			<button class="btn btn-success btn-block" type="submit">提交</button>
	  		</form>
  		<%=message %><!-- 111111111111111111 -->
  		</div>
	</body>
</html>
