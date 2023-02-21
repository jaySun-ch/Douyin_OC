//
//  TalkMessageData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TalkMessageDataType){
    TalkMessageDataText, // 当前信息为文字信息
    TalkMessageDataImage, // 当前信息为图像信息
    TalkMessageDataVideo, // 当前信息为视频信息
    TalkMessageDataReply, // 当前信息为回复消息信息
    TalkMessageDataCenter, // 当前信息为拍一拍或者时间信息
};

typedef NS_ENUM(NSInteger,MessageState){ // 只是针对最后一条消息
    MessageHasRead,// 已读
    MessageSending, // 发送中
    MessageSendSuccess, // 发送成功
    MessageSendFaliure, // 发送失败
};



@interface OneMessageData : NSObject //单条信息的主要存储内容
@property (nonatomic,assign) NSInteger message_id; // 单条信息的UID
@property (nonatomic,assign) TalkMessageDataType dataType; // 单条信息的Type
@property (nonatomic,copy) NSString *replyMessage_id; //如果是回复消息的话 找到回复消息的Id
@property (nonatomic,copy) NSString *My_id; //该信息发送者的UID;
@property (nonatomic,copy) NSDate *SendDate; // 发送消息时候的时间


#pragma 主体信息内容设置
@property (nonatomic,copy) NSString *SendMessage; //发送的主体信息
@property (nonatomic,copy) NSString *SendImageUrl; // 发送的图像信息的url
@property (nonatomic,assign) CGFloat ImageRadio;
@property (nonatomic,copy) NSString *SendVideoUrl; //发送的视频信息的url

#pragma 主体信息内容的状态设置
@property (nonatomic,assign) MessageState state;
@end
