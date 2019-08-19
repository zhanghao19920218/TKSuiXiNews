//
//  API.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

let K_URL_login = "api/user/login"; //会员登录
let K_URL_contentList = "api/article/index" //内容模块
let K_URL_mineInfo = "api/user/index"; //个人中心
let K_URL_articleDetail = "api/article/detail"; //详情
let K_URL_uploadVideo = "api/common/upload" //上传文件
let K_URL_sendVideoDesc = "api/article/addv" //发布V视频
let K_URL_multiImages = "api/common/uploads" //上船多图文件
let K_URL_causualShow = "api/article/adds" //发布随手拍
let K_URL_scoreItemList = "api/goods/index" //商品列表
let K_URL_productDetail = "api/goods/detail" //商品详情
let K_URL_awardProducts = "api/award/index" //积分抽奖奖品列表
let K_URL_awardDraw = "api/award/draw" //抽奖
let K_URL_exchangeProduct = "api/goods/exchange" //兑换操作
let K_URL_changeMemberInfo = "/api/user/profile" //修改用户信息
let K_URL_IntegralDetail = "/api/score/index" //积分明细
let K_URL_commentAdd = "api/comment/add" //发表评论
let K_URL_sendMassage = "api/sms/send" //发送验证码
let K_URL_signIn = "api/user/register" //会员注册
let K_URL_addLike = "api/like/add"  //点赞
let K_URL_disLike = "api/like/cancel" //取消点赞
let K_URL_logOut = "api/user/logout" //注销登录
let K_URL_banner = "api/banner/index" //顶部Banner
let K_URL_messageList = "api/msg/index" //消息中心
let K_URL_recentlyReview = "api/userlog/index" //最近浏览
let K_URL_addFavorite = "api/collect/add" //添加收藏
let K_URL_favoriteList = "api/collect/index" //收藏列表
let K_URL_exchangeRecord = "api/goods/record" //兑换产品列表
let K_URL_thirdLibLogin = "api/third/login" //第三方登录
let K_URL_resetPassword = "api/user/resetpwd" //重置密码
let K_URL_sevenBeffToken = "/api/index/qiniutoken" //获取七牛云token
let K_URL_bindingMobile = "api/third/bindmobile" //绑定手机号
let K_URL_articleAdmin = "api/article/admin" //获取矩阵号数据
let K_URL_deleteArticle = "api/article/dels" //删除随手拍
let K_URL_askGoverment = "api/article/addw" //发布问政
let K_URL_deleteFavorite = "api/collect/cancel" //取消收藏
let K_URL_voteSend = "api/vote/vote" //发起投票
let K_URL_voteContentId = "api/vote/index" //投票内容
let K_URL_receiveGoods = "api/goods/receive" //现场领取
let K_URL_changeMobile = "api/user/changemobile" //修改手机号
let K_URL_mineArticle = "api/article/my" //我的帖子
let K_URL_shareScore = "api/score/share" //分享转发获取积分
let K_URL_readGetScore = "api/score/read" //阅读获得积分
let K_URL_systemConfig = "api/index/sysconfig" //系统参数
let K_URL_homeChannel = "api/module/index" //首页频道接口
let K_URL_deleteVVideo = "api/article/del" //删除V视频
let K_URL_commentIndex = "api/comment/index" //评论列表
let K_URL_scoreRule = "api/score/rule" //积分规则
let K_URL_loginMobileCode = "api/user/mobilelogin" //手机验证码登录
let K_URL_clearMessage = "api/msg/deleteall" //清空消息
