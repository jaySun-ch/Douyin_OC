//
//  CustomScrollCell.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/30.
//

#import "CustomScrollCell.h"
#import "CustomImageView.h"
#import "NSString+Extension.h"
#import "TalkViewController.h"

@interface CustomScrollCell()
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) MyFriendDetialResponse *alldata;
@end

@implementation CustomScrollCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.alwaysBounceHorizontal = YES;
        _scrollview.backgroundColor = [UIColor clearColor];
        _scrollview.contentSize = CGSizeMake(100 * [AppUserData GetCurrenUser].FriendList.count, self.frame.size.height);
        [self.contentView addSubview:_scrollview];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self).inset(0);
            make.top.bottom.equalTo(self).inset(5);
        }];
    }
    return self;
}



-(void)initWithData:(MyFriendDetialResponse *)alldata{
    self.alldata = alldata;
    [self.scrollview removeAllSubviews];
    for(NSInteger i = 0; i<self.alldata.msg.count;i++){
        CustomImageView *image = [[CustomImageView alloc] initWithFrame:CGRectMake(80 * i,10,80,80) imageurl:self.alldata.msg[i].ClientImageUrl label:self.alldata.msg[i].username];
        [image setUserInteractionEnabled:YES];
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            TalkViewController *vc = [[TalkViewController alloc] init];
            vc.ClientImagurl = self.alldata.msg[i].ClientImageUrl;
            vc.ClientName = self.alldata.msg[i].username;
            vc.ClientId = self.alldata.msg[i].Id;
            [UIWindow PushController:vc];
        }]];
        image.frame = CGRectMake((80 * i) + 15,10, 80,80);
        [self.scrollview addSubview:image];
    }
}






@end
