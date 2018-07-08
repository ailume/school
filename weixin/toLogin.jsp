<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.app.ajax.weixin.repair.RepairAjax"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="com.lineteam.util.StringUtils"%>
<%@ page import="com.lineteam.db.QueryUtil"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="com.lineteam.common.LogUtil"%>
<%@ page import="com.param.SessionParam"%>
<%@ page import="com.lineteam.security.SecurityObjectBuilder"%>
<%@ page import="com.alibaba.fastjson.JSONObject"%>
<%@ page import="com.util.cache.CacheFactory"%>
<%@ page import="com.util.cache.Cache"%>
<%@ page import="javax.ws.rs.core.MediaType"%>
<%@ page import="com.param.RestParams"%>
<%@ page import="org.feuyeux.jaxrs2.atup.core.rest.AtupRequest"%>
<%@ page import="com.lineteam.util.BeanUtils"%>
<%@ page import="com.lineteam.util.HashEncrypt"%>
<%@ page import="com.app.common.AppUser"%>
<%@ include file="/inc/begin.inc"%>
<%
	SessionParam param=new SessionParam(request); 
	String ROOTPath = request.getContextPath();
	if ("/".equals(ROOTPath)){
		ROOTPath="";
	}
	String token=StringUtils.toString(request.getParameter("token")); 		//token
  	String userId=StringUtils.toString(request.getParameter("userId"));		//userid
  	Cache cache = CacheFactory.getInstance();
  	Map userObj=(Map)cache.getObject(token);
  	String appId=BeanUtils.getPropertyStr(userObj, "APP_ID");		//appId
  	LogUtil.error(JSONObject.toJSONString(userObj));
  	String _userId=BeanUtils.getPropertyStr(userObj, "ID");
	if(userObj != null && userId.equals(_userId)){
		String userType = BeanUtils.getPropertyStr(userObj, "OBJECT_NAME");
		/*userId userType; schoolId; name; termId; loginType="APP"; classIds; icon;	status;
		dbId; stuDbId; studentId; studentName; parentTitle;	token;			//用户相关验证token
		*/
		AppUser user = new AppUser();
		user.setOpenId(BeanUtils.getPropertyStr(userObj, "OPEN_ID"));
		user.setToken(token);
		user.setUserId(userId);
		user.setUserType(userType);
		String schoolId = BeanUtils.getPropertyStr(userObj, "SCHOOL_ID");
		user.setSchoolId(schoolId);
		user.setTermId(BeanUtils.getPropertyStr(userObj, "TERM_CODE"));
		user.setName(BeanUtils.getPropertyStr(userObj, "NAME"));
		user.setLoginType("WEIXIN");
		user.setIcon(BeanUtils.getPropertyStr(userObj, "ICON"));
		user.setStatus("1");
		String studentId = "";
		String studentName = "";
		String parentTitle = "";
		String classId = "";	//查询用户班级信息
		QueryUtil query =  QueryUtil.getInstance();
		if("T_PARENT".equals(userType)){
			//设置家长学生信息
			Map parentMap=(Map)userObj.get("student");
			studentId = BeanUtils.getPropertyStr(parentMap, "studentid");
			studentName = BeanUtils.getPropertyStr(parentMap, "studentname");
			parentTitle = BeanUtils.getPropertyStr(parentMap, "parenttitle");
			//查询学生班级id
			Map classMap = query.firstRecord("select CLASS_ID from t_STUDENT where id=?", 
					new String[]{studentId});
			if(classMap != null && !classMap.isEmpty()){
				classId = BeanUtils.getPropertyStr(classMap, "CLASS_ID");
			}
		}else if("T_STUDENT".equals(userType)){
			//查询学生班级id
			Map classMap = query.firstRecord("select CLASS_ID from t_STUDENT where id=?", new String[]{userId});
			if(classMap != null && !classMap.isEmpty()){
				classId = BeanUtils.getPropertyStr(classMap, "CLASS_ID");
			}
		}else if("T_TEACHER".equals(userType)){
			//查询老师任教, 班主任管理班级
			List classList = query.executeQuery("select a.CLASS_ID from t_class_course a inner join t_class b " 
					+ "on a.class_id=b.id where a.school_id=? and b.term_id=? "  
					+ "and (a.teacher_id=? or b.teacher_id=? or b.fteacher_id=?) group by a.class_id"
					, new String[]{schoolId, user.getTermId(), userId, userId, userId});
			for(Object obj : classList){
				String cid = BeanUtils.getPropertyStr(obj, "CLASS_ID");
				classId = ("".equals(classId) ? "" : classId + ",") + cid;
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
		user.setStudentId(studentId);
		user.setStudentName(studentName);
		user.setParentTitle(parentTitle);
		user.setClassIds(classId);
		param.setSecurityObject(SecurityObjectBuilder.build());
		param.setLqtWeixinUser(user);
		param.setLqtWeixinAPPId(appId);
		LogUtil.info("--------------- LoginUser toString="+user.toString());
		response.sendRedirect("wechat/views/profile/profile.jsp");
	}else {
		response.sendRedirect("error/login_error.html");
	}
%>
<%@ include file="/inc/end.inc"%>
