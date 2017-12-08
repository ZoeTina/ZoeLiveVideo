//
//  URLDefine.m
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/15.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDefine.h"

//支付是8081，其他是8082
//NSString* const DynamicUrl = @"http://172.16.17.34:8081";

//http://192.168.61.115:8082
//192.168.61.115
//192.168.32.124:2021
//正式环境的动态接口
//pandaapi.sctv.com:43086
//正式环境的静态json地址
//pandafile.sctv.com:41086
NSString* const DynamicUrl = @"http://pandaapi.sctv.com:43086";

NSString* const indexSetting = @"";

NSString* const updateAvatar = @"/updateAvatar";

NSString* const updateNickname = @"/updateNickname";

NSString* const updateSex = @"/updateSex";

NSString* const updateBirthday = @"/updateBirthday";

NSString* const getMobileHistory = @"/getMobileHistory";

NSString* const login = @"/login";

NSString* const thirdAccountLogin = @"/thirdAccountLogin";

NSString* const bindAccount = @"/bindAccount";

NSString* const getUserAgreement = @"/getUserAgreement";

NSString* const getVerifyCode = @"/getVerifyCode";

NSString* const deleteAllHitsory = @"/deleteAllHitsory";

NSString* const deleteHistory = @"/deleteHistory";

NSString* const tokenLogin = @"/tokenLogin";
//上传文件接口
NSString* const uploadFile = @"/uploadFile";

//版本信息
NSString* const versionManage = @"http://pandafile.sctv.com:42086/System/VersionManage/VersionManage.json";
//引导页
NSString* const startPage = @"http://pandafile.sctv.com:42086/System/StartPage/StartPage.json";
//获取消息通知
NSString* const infomationPush = @"http://pandafile.sctv.com:42086/System/announce/sysAnnounce.json";

NSString* const getFavList = @"/getFavList";

NSString* const deleteFavorite = @"/deleteFavorite";

NSString* const getOrderList = @"/getOrderList";

//获取熊猫钱包余额
NSString* const getPandaBalance = @"/getPandaBalance";
//获取用户评论回复信息
NSString* const getCommentByReplyList = @"/getCommentByReplyList";


//获取家庭圈基本信息
NSString* const getFamilyBasic = @"/getFamilyBasic";
//获取家庭圈邀请列表
NSString* const getFamilyInvite = @"/getFamilyInvite";
//获取通讯录状态
NSString* const getContactsState = @"getContactsState";
//获取家庭圈详情列表
NSString* const getFamilyInfo = @"/getFamilyInfo";
//退出家庭圈
NSString* const exitFamily = @"/exitFamily";
//修改家庭圈名
NSString* const modifyFamilyName = @"/modifyFamilyName";
//修改家庭圈用户昵称
NSString* const modifyFamilyNickName = @"/modifyFamilyNickName";

//同意邀请
NSString* const joinFamily = @"/joinFamily";
//发送邀请
NSString* const sendInviteMsg = @"/sendInviteMsg";
//家庭圈注册
NSString* const registerFamily = @"/registerFamily";


//TV端播放视频
NSString* const playVideoForTV = @"/playVideoForTV";

//云看单
//获取用户云看单列表
NSString* const getCloudVideoList = @"/getCloudVideoList";
//删除云看单视频
NSString* const deleteCloudVideo = @"/deleteCloudVideo";
//云看单排序
NSString* const reorderCloudVideo = @"/reorderCloudVideo";
//添加云看单内容
NSString* const addCloudVideo = @"/addCloudVideo";
//请求TV端授权
NSString* const requestTVAuthorize = @"/requestTVAuthorize";
//获取TV端授权信息
NSString* const getTVAuthorizeByPhone = @"/getTVAuthorizeByPhone";

//充值记录
NSString* const getRechargeList = @"/getRechargeList";
//消费记录
NSString* const getConsumeList = @"/getConsumeList";

NSString* const commitFeedback = @"/commitFeedback";

NSString* const applePay = @"/applePay";
//获取电视端观看历史记录
NSString* const getTVHistoryList = @"/getTVHistoryList";

//------------UGC接口--------------
//查看自己上传的视频列表
NSString* const getUgcFileList = @"/getUgcFileList";
//获取UGC活动信息
NSString* const getUgcInfo = @"http://pandafile.sctv.com:42086/content/ugc/2017/11/1.json";
//删除自己上传的视频列表
NSString* const delUgcFiles = @"/delUgcFiles";
//UGC上传文件接口
NSString* const ugcUploadFile = @"/ugcUploadFile";

NSString* const postUgcInfo = @"/postUgcInfo";

NSString* const getUploadFileNum = @"/getUploadFileNum";
//订购产品信息
NSString* const orderProductionList = @"http://pandafile.sctv.com:42086/Pay/product.json";
NSString* const chargeProducationList = @"http://pandafile.sctv.com:42086/Pay/virtual.json";
//帮助
NSString* const helpJson = @"http://pandafile.sctv.com:42086/System/FAQ/FAQ.json";
//登录协议
NSString* const loginProtocol = @"http://app.sctv.com/tv/info/201711/t20171128_3683480.shtml";
