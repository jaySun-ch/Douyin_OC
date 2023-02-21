//
//  CommentViewController.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/20.
//

#import <UIKit/UIKit.h>
#import "CommentData.h"
#import "NetWorkHelper.h"
#import "NSNotification+Extension.h"
#import "CustomHeaderView.h"
#import "VideoPlayData.h"

@interface CustomCommentView : UIView
@property (nonatomic,copy) VideoPlayData *VideoData;
@property (nonatomic,copy) NSString *username;
- (instancetype)initWithData:(CommentData *)data VideoData:(VideoPlayData *)videodata User:(NSString *)user;
@end
