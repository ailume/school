/**
 * Created by lume on 2017/10/18.
 *
 * 定义常量  - 网络接口请求
 *
 */

const apiRouter = {
  NOTICE_TYPE: roterPath + "/app/notice/type",
  SCOPE_DEPT: roterPath + "/app/notice/scope",
  SCOPE_SPACE: roterPath + "/app/notice/scope",
  SCOPE_OPTIONAL: roterPath + "/app/notice/scope",
  SCOPE_CURRICULUM: roterPath + "/app/notice/scope",
  SCOPE_GRADE: roterPath + "/app/notice/scope",

  // 查看通知
  LOOK_INFO: roterPath + "/app/notice/publist",
  DEL_INFO: roterPath + "/app/notice/del",
  EDLIT_INFO: roterPath + "/app/notice/info",

  // 首页
  GET_LIST: roterPath + "/app/profile/info",

  // 发布通知接口
  POST_SEND: roterPath + "/app/notice/publish",

  // 获取微信签名
  GET_CONFIG: roterPath + "/app/config/wechat?url=",


  // 评价接口

  GET_EVALUATE: roterPath + "/app/zh/teacher/scope",

  GET_CLASSBYCODE: roterPath + "/app/zh/teacher/classbycode?",

  GET_STUDENT: roterPath + "/app/zh/teacher/student?",
  GET_STUDENTINFO: roterPath + "/app/zh/teacher/studentinfo?",
  POST_EVALUATE: roterPath + "/app/zh/teacher/savescore",


  // 发布作业
  GET_HOMEWORKLIST: roterPath + "/app/homework/homeworkList",
  DEL_HOMEWORK: roterPath + "/app/homework/del",
  GET_HOMEWORKSCOPE: roterPath + "/app/homework/scope",
  POST_HOMEWORKPUBLISH: roterPath + "/app/homework/publish",

  // 图片视频上传
  POST_IMG: roterPath + "/app/upload/img",
  GET_VIDEO: roterPath + "/app/upload/video",

  SEND_SPACE: roterPath + "/app/space/publish",  // 发布帖子
  




  // 工资单
  GET_WAGELIST: roterPath + "/app/wage/myWageList",
  GET_WAGEINFO: roterPath + "/app/wage/myWageData"

}
export default apiRouter;






