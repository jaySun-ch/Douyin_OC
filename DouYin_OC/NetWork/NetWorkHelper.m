//
//  NetWorkHelper.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import "NetWorkHelper.h"

#define UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}


NSString *const NetworkStatesChangeNotification = @"NetworkStatesChangeNotification";

NSString *const NetworkDomain = @"com.start.douyin";

NSString *const BaseUrl = @"http://172.20.10.2:3000/";

//创建访客用户接口
NSString *const CreateVisitorPath = @"visitor/create";

//根据用户id获取用户信息
NSString *const GetUserByphoneNumberPath=@"users/SignInMessageVerify";
NSString *const GetUserByUsernamePath = @"users/GetUserWithUsername";
NSString *const GetUserByIDPath = @"users/GetUserWithId";
NSString *const SignInPath = @"users/SignIn";
NSString *const SignInWithMessagePath = @"users/SignInWithMessage";
NSString *const SignUpPath = @"users/SignUp";
NSString *const SignUpMessageVerifyPath = @"users/SignUpMessageVerify";
NSString *const ResetPasswordPath = @"users/resetpassword";
NSString *const ResetPasswordVerifyPath = @"users/resetpasswordVerify";

//搜索用户
NSString *const SearchClientPath = @"search/searchClient";


NSString *const GetFriendListDetialPath = @"users/GetFriendListDetial";

NSString *const GetFansListDetialPath = @"users/GetFansListDetial";

// 根据用户的ID进行更新用户信息
NSString *const UpdateClientMessagePath = @"users/ChangeClientMessage";

// 根据用户ID更新头像和背景图
NSString *const UpdateClientImagePath = @"file/uploadClientImage";

// 添加关注
NSString *const AddConcernPath = @"users/AddConcern";

//获取用户刷视频的主体推荐内容
NSString *const MainVideoPath = @"mainVideo";

//获取用户发布的短视频列表数据
NSString *const FindAwemePostByPagePath = @"aweme/post";
//获取用户喜欢的短视频列表数据
NSString *const FindAwemeFavoriteByPagePath = @"aweme/favorite";
//获取用户收藏的短视频列表数据
NSString *const FindAwemeStarByPagePath = @"aweme/star";


//发送文本类型群聊消息
NSString *const PostGroupChatTextPath = @"groupchat/text";
//发送单张图片类型群聊消息
NSString *const PostGroupChatImagePath = @"groupchat/image";
//发送多张图片类型群聊消息
NSString *const PostGroupChatImagesPath = @"groupchat/images";
//根据id获取指定图片
NSString *const FindImageByIdPath = @"groupchat/image";
//获取群聊列表数据
NSString *const FindGroupChatByPagePath = @"groupchat/list";
//根据id删除指定群聊消息
NSString *const DeleteGroupChatByIdPath = @"groupchat/delete";

#pragma 评论的接口
//根据视频id发送评论
NSString *const PostComentPath = @"comment/post";
//根据id删除评论
NSString *const DeleteComentByIdPath = @"comment/delete";
//获取一级评论列表
NSString *const MainCommentListPath = @"comment/MainList";
//获取二级评论列表
NSString *const GetSecondListPath = @"comment/SecondList";
//喜欢评论
NSString *const LikeCommentPath = @"comment/likecomment";
//不喜欢评论
NSString *const DisLikeCommentPath = @"comment/deletelikecomment";
//删除评论
NSString *const DeleteCommentPath = @"comment/deletecomment";



@implementation NetWorkHelper
+ (AFHTTPSessionManager *)shareManager{
    static dispatch_once_t once;
    static AFHTTPSessionManager *manager;
    dispatch_once(&once, ^{
        manager = [AFHTTPSessionManager new];
        manager.requestSerializer.timeoutInterval = 15.0f;
    });
    return manager;
}

+ (void)processResponseData:(id)responseObject success:(HttpSuccess)success failure:(HttpFailure)failure {
    NSInteger code = -1;
    NSString *message = @"response data error";
    if([responseObject isKindOfClass:NSDictionary.class]){
        NSDictionary *dit = (NSDictionary *)responseObject;
        code = [(NSNumber *)[dit objectForKey:@"code"] integerValue];
        message = (NSString *)[dit objectForKey:@"message"];
    }
    
    if(code == 0){
        success(responseObject);
    }else{
        NSDictionary *userinfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:NetworkDomain code:HttpResquestFailed userInfo:userinfo];
        failure(error);
    }
}

+ (NSURLSessionDataTask *)getWithUrlPath:(NSString *)urlpath request:(BaseRequest *)request success:(HttpSuccess)success faliure:(HttpFailure)faliure{
    NSDictionary *parameters = [request toDictionary];
    return [[NetWorkHelper shareManager] GET:[BaseUrl stringByAppendingString:urlpath] parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetWorkHelper processResponseData:responseObject success:success failure:faliure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        if(status == AFNetworkReachabilityStatusNotReachable){
            [UIWindow showTips:@"当前无网络"];
            faliure(error);
            return;
        }
        // 本地json数据
        
    }];
}

+ (NSURLSessionDataTask *)deleteWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDictionary *parameters = [request toDictionary];
    return [[NetWorkHelper shareManager]DELETE:[BaseUrl stringByAppendingString:urlPath] parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetWorkHelper processResponseData:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)postWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDictionary *parameters = [request toDictionary];
    return [[NetWorkHelper shareManager]POST:[BaseUrl stringByAppendingString:urlPath] parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetWorkHelper processResponseData:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)uploadWithUrlPath:(NSString *)urlPath data:(NSData *)data request:(BaseRequest *)request progress:(UploadProgress)progress success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDictionary *parameters = [request toDictionary];
    return [[NetWorkHelper shareManager] POST:[BaseUrl stringByAppendingString:urlPath] parameters:parameters headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"multipart/form-data"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_main_sync_safe(^{
            progress(uploadProgress.fractionCompleted);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetWorkHelper processResponseData:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)uploadWithUrlPath:(NSString *)urlPath dataArray:(NSArray<NSData *> *)dataArray request:(BaseRequest *)request progress:(UploadProgress)progress success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDictionary *parameters = [request toDictionary];
    return [[NetWorkHelper shareManager] POST:[BaseUrl stringByAppendingString:urlPath] parameters:parameters headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(NSData *data in dataArray){
            [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"multipart/form-data"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetWorkHelper processResponseData:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (AFNetworkReachabilityManager *)shareReachabilityManager{
    static dispatch_once_t once;
    static AFNetworkReachabilityManager *manager;
    dispatch_once(&once, ^{
        manager = [AFNetworkReachabilityManager manager];
    });
    return manager;
}

+ (void)startListening{
    [[NetWorkHelper shareReachabilityManager] startMonitoring];
    [[NetWorkHelper shareReachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStatesChangeNotification object:nil];
        if(![NetWorkHelper isNotReachableStatus:status]){
            [NetWorkHelper registerUserInfo];
        }
    }];
}


+ (BOOL)isNotReachableStatus:(AFNetworkReachabilityStatus)status{
    return  status == AFNetworkReachabilityStatusNotReachable;
}

+ (AFNetworkReachabilityStatus)networkStatus {
    return [NetWorkHelper shareReachabilityManager].networkReachabilityStatus;
}

+ (BOOL)isWifiStatus{
    return [NetWorkHelper shareReachabilityManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

+ (void)registerUserInfo {
//    VisitorRequest *request = [VisitorRequest new];
//    request.udid = UDID;
//    [NetWorkHelper postWithUrlPath:CreateVisitorPath request:request success:^(id data) {
//        VisitorResponse *response = [[VisitorResponse alloc] initWithDictionary:data error:nil];
//        writeVisitor(response.data);
//    } failure:^(NSError *error) {
//        NSLog(@"Register visitor failed.");
//    }];
}

@end

