//
//  NetWorkHelper.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import <Foundation/Foundation.h>
#import "UIWindow+Extension.h"
#import "AFHTTPSessionManager.h"

#import "BaseRequest.h"
#import "MainVideoRequest.h"
#import "CommentRequest.h"
#import "SecondCommentRequest.h"
#import "PostCommentResponse.h"
#import "SuccessResponse.h"
#import "GetUserResponse.h"
#import "ChangeClientMessageRequest.h"
#import "ChangeClientDateRequest.h"
#import "UpLoadClientImageRequest.h"
#import "SearchClientRequest.h"
#import "AddConcernRequest.h"
#import "GetClientNameAndImageRequest.h"


#import "BaseResponse.h"
#import "MainVideoResponse.h"
#import "CommentResponse.h"
#import "PostCommentRequest.h"
#import "LikeCommentRequest.h"
#import "GetUserWithPhonenumberRequest.h"
#import "GetUserWithIdRequest.h"
#import "SignInRequest.h"
#import "SignInWithMessageRequest.h"
#import "SignUpRequest.h"
#import "SignUpMessageVerifyRequest.h"
#import "resetpasswordRequest.h"
#import "resetpasswordVerifyRequest.h"
#import "SearchClientResponse.h"
#import "MyFriendDetialResponse.h"
#import "NewFriendDetialResponse.h"

//network state notification
extern NSString *const NetworkStatesChangeNotification;

extern NSString *const NetworkDomain;

//请求地址
extern NSString *const BaseUrl;

//创建访客用户接口
extern NSString *const CreateVisitorPath;

//根据用户id获取用户信息
extern NSString *const GetUserByUsernamePath;
extern NSString *const GetUserByphoneNumberPath;
extern NSString *const GetUserByIDPath;
extern NSString *const SignInPath;
extern NSString *const SignInWithMessagePath;
extern NSString *const SignUpPath;
extern NSString *const SignUpMessageVerifyPath;
extern NSString *const ResetPasswordPath;
extern NSString *const ResetPasswordVerifyPath;

//搜索用户
extern NSString *const SearchClientPath;


extern NSString *const GetFriendListDetialPath;

extern NSString *const GetFansListDetialPath;

//根据用户的id更新用户信息
extern NSString *const UpdateClientMessagePath;
// 根据用户ID更新头像和背景图
extern NSString *const UpdateClientImagePath;

//根据用户ID和对方ID更新关注和粉丝列表
extern NSString *const AddConcernPath;
//获取用户刷视频的主体推荐内容
extern NSString *const MainVideoPath;

//获取用户发布的短视频列表数据
extern NSString *const FindAwemePostByPagePath;
//获取用户喜欢的短视频列表数据
extern NSString *const FindAwemeFavoriteByPagePath;
//获取用户收藏的短视频列表数据
extern NSString *const FindAwemeStarByPagePath;


//发送文本类型群聊消息
extern NSString *const PostGroupChatTextPath;
//发送单张图片类型群聊消息
extern NSString *const PostGroupChatImagePath;
//发送多张图片类型群聊消息
extern NSString *const PostGroupChatImagesPath;
//根据id获取指定图片
extern NSString *const FindImageByIdPath;
//获取群聊列表数据
extern NSString *const FindGroupChatByPagePath;
//根据id删除指定群聊消息
extern NSString *const DeleteGroupChatByIdPath;


//根据视频id发送评论
extern NSString *const PostComentPath;
//根据id删除评论
extern NSString *const DeleteComentByIdPath;

extern NSString *const MainCommentListPath ;
//获取二级评论列表
extern NSString *const GetSecondListPath;
//喜欢评论
extern NSString *const LikeCommentPath;
//不喜欢评论
extern NSString *const DisLikeCommentPath;
//删除评论
extern NSString *const DeleteCommentPath;



typedef enum {
    HttpResquestFailed = -1000,
    UrlResourceFailed = -2000
} NetworkError;

typedef void (^UploadProgress)(CGFloat percent);
typedef void (^HttpSuccess)(id data);
typedef void (^HttpFailure)(NSError *error);

@interface NetWorkHelper :  NSObject

// 和服务端进行交流的管理实例
+ (AFHTTPSessionManager *)shareManager;

// 从服务端获取内容 查询
+ (NSURLSessionDataTask *)getWithUrlPath:(NSString *)urlpath request:(BaseRequest *)request success:(HttpSuccess) success faliure:(HttpFailure)faliure;

// 从服务端删除内容 删除
+(NSURLSessionDataTask *)deleteWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure;

// 修改服务端内容 增加/修改
+(NSURLSessionDataTask *)postWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure;

// 发送文件
+(NSURLSessionDataTask *)uploadWithUrlPath:(NSString *)urlPath data:(NSData *)data request:(BaseRequest *)request progress:(UploadProgress)progress success:(HttpSuccess)success failure:(HttpFailure)failure;

// 发送大文件
+(NSURLSessionDataTask *)uploadWithUrlPath:(NSString *)urlPath dataArray:(NSArray<NSData *> *)dataArray request:(BaseRequest *)request progress:(UploadProgress)progress success:(HttpSuccess)success failure:(HttpFailure)failure;

// 网络环境监测
+ (AFNetworkReachabilityManager *)shareReachabilityManager;

// 开始监听服务器
+ (void)startListening;

// 当前网络状况
+ (AFNetworkReachabilityStatus)networkStatus;

// 判断是否为wifi
+ (BOOL)isWifiStatus;

// 无法连接到服务器/网络
+ (BOOL)isNotReachableStatus:(AFNetworkReachabilityStatus)status;

@end
