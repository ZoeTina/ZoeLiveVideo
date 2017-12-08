//
//  URLDefine.h
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/14.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#ifndef URLDefine_h
#define URLDefine_h

extern NSString* const DynamicUrl;

extern NSString* const indexSetting;

//更改头像
extern NSString* const updateAvatar;
//修改昵称
extern NSString* const updateNickname;
//修改性别信息
extern NSString* const updateSex;
//修改生日
extern NSString* const updateBirthday;
//获取移动端观看历史
extern NSString* const getMobileHistory;
//手机登陆
extern NSString* const login;
//第三方账号登陆
extern NSString* const thirdAccountLogin;
//绑定手机号
extern NSString* const bindAccount;
//获取用户协议，需要拼接
extern NSString* const getUserAgreement;
//获取验证码
extern NSString* const getVerifyCode;
//删除手机端所有历史
extern NSString* const deleteAllHitsory;
// 删除手机观看历史
extern NSString* const deleteHistory;
//上传文件接口
extern NSString* const uploadFile;
//token登陆
extern NSString* const tokenLogin;

// 版本信息v
extern NSString* const versionManage;

// 广告引导页
extern NSString* const startPage;

//获取消息通知
extern NSString* const infomationPush;

//获取收藏列表
extern NSString* const getFavList;
//取消收藏
extern NSString* const deleteFavorite;

//获取产品包订购记录
extern NSString* const getOrderList;

//获取熊猫钱包余额
extern NSString* const getPandaBalance;

//获取用户评论回复信息
extern NSString* const getCommentByReplyList;


#pragma mark -- 家庭圈
//获取家庭圈基本信息
extern NSString* const getFamilyBasic;

//获取家庭圈邀请列表
extern NSString* const getFamilyInvite;

//获取通讯录用户状态
extern NSString* const getContactsState;


//获取家庭圈详情列表
extern NSString* const getFamilyInfo;

//退出家庭圈
extern NSString* const exitFamily;

//修改家庭圈名
extern NSString* const modifyFamilyName;
//修改家庭圈用户昵称
extern NSString* const modifyFamilyNickName;

//同意邀请
extern NSString* const joinFamily;

//发送邀请
extern NSString* const sendInviteMsg;
//家庭圈注册
extern NSString* const registerFamily;

//TV端播放视频
extern NSString* const playVideoForTV;

//云看单
//获取用户云看单列表
extern NSString* const getCloudVideoList;
//删除云看单视频
extern NSString* const deleteCloudVideo;
//云看单排序
extern NSString* const reorderCloudVideo;
//添加云看单内容
extern NSString* const addCloudVideo;
//请求TV端授权
extern NSString* const requestTVAuthorize;
//获取TV端授权信息
extern NSString* const getTVAuthorizeByPhone;

//获取充值记录
extern NSString* const getRechargeList;
//消费记录
extern NSString* const getConsumeList;
//意见反馈
extern NSString* const commitFeedback;
//电视端历史观看记录
extern NSString* const getTVHistoryList;
extern NSString* const applePay;

//查看自己上传的视频列表
extern NSString* const getUgcFileList;
//获取UGC活动信息
extern NSString* const getUgcInfo;
extern NSString* const delUgcFiles;
//UGC上传文件接口
extern NSString* const ugcUploadFile;
extern NSString* const postUgcInfo;
//查看用户剩余上传文件数量
extern NSString* const getUploadFileNum;
//订购产品信息
extern NSString* const orderProductionList;
extern NSString* const chargeProducationList;
extern NSString* const helpJson;
extern NSString* const loginProtocol;
#endif /* URLDefine_h */
