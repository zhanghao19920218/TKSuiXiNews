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
let K_URL_thirdLibLogin = "api/user/third" //第三方登录
let K_URL_resetPassword = "api/user/resetpwd" //重置密码
let K_URL_sevenBeffToken = "/api/index/qiniutoken" //获取七牛云token
