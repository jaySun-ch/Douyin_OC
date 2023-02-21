//
//  CustomEditButton.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/4.
//

#import "EditButtonCell.h"
#import "CustomAddLabel.h"

@interface EditButtonCell()
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) CustomAddLabel *customAddlabel;
@end

@implementation EditButtonCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = [@"完善信息 +10%" singleLineSizeWithText:[UIFont systemFontOfSize:9.0]];
        self.title = [[UILabel alloc] init];
        [self.title setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.title];
        self.message = [[UILabel alloc] init];
        [self.message setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.message];
        
        self.customAddlabel = [[CustomAddLabel alloc] init];
        self.customAddlabel.alpha = 0;
        [self addSubview:self.customAddlabel];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        
        [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).inset(30);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
        }];
        
        [self.customAddlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.message.mas_right).inset(3);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(size.height + 4);
            make.width.mas_equalTo(size.width + 4);
        }];
        
    }
    return self;
}


-(void)initWithTitleAndMessage:(NSString *)title message:(NSString *)message{
        [self.title setText:title];
        if([title isEqualToString:@"名字"]){
            [self.message setTextColor:[UIColor blackColor]];
            [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
            [self.message setText:[AppUserData GetCurrenUser].username];
        }else if([title isEqualToString:@"简介"]){
            if([[AppUserData GetCurrenUser].introduce isEqualToString:@""]){
                [self.message setFont:[UIFont systemFontOfSize:17.0]];
                [self.message setTextColor:[UIColor lightGrayColor]];
                [self.message setText:@"介绍一下自己"];
                [self.customAddlabel setlabel:1];
                self.customAddlabel.alpha = 1;
            }else{
                [self.message setTextColor:[UIColor blackColor]];
                [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
                [self.message setText:[AppUserData GetCurrenUser].introduce];
                [self.customAddlabel setlabel:1];
                self.customAddlabel.alpha = 0;
            }
        }else if([title isEqualToString:@"性别"]){
            if([[AppUserData GetCurrenUser].sex isEqualToString:@""]){
                [self.message setFont:[UIFont systemFontOfSize:17.0]];
                [self.message setTextColor:[UIColor lightGrayColor]];
                [self.message setText:@"设置性别"];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 1;
            }else{
                [self.message setTextColor:[UIColor blackColor]];
                [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
                [self.message setText:[AppUserData GetCurrenUser].sex];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 0;
            }
        }else if([title isEqualToString:@"生日"]){
            if([AppUserData GetCurrenUser].bornDate == nil){
                [self.message setFont:[UIFont systemFontOfSize:17.0]];
                [self.message setTextColor:[UIColor lightGrayColor]];
                [self.message setText:@"设置你的生日"];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 1;
            }else{
                [self.message setTextColor:[UIColor blackColor]];
                [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
                [self.message setText:[[AppUserData GetCurrenUser].bornDate GetDate]];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 0;
            }
        }else if([title isEqualToString:@"所在地"]){
            if([[AppUserData GetCurrenUser].location isEqualToString:@""]){
                [self.message setFont:[UIFont systemFontOfSize:17.0]];
                [self.message setTextColor:[UIColor lightGrayColor]];
                [self.message setText:@"设置你的所在地"];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 1;
            }else{
                [self.message setTextColor:[UIColor blackColor]];
                [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
                [self.message setText:[AppUserData GetCurrenUser].location];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 0;
            }
        }else if([title isEqualToString:@"学校"]){
            if([[AppUserData GetCurrenUser].school isEqualToString:@""]){
                [self.message setFont:[UIFont systemFontOfSize:17.0]];
                [self.message setTextColor:[UIColor lightGrayColor]];
                [self.message setText:@"选择学校"];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 1;
            }else{
                [self.message setTextColor:[UIColor blackColor]];
                [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
                [self.message setText:[AppUserData GetCurrenUser].school];
                [self.customAddlabel setlabel:0];
                self.customAddlabel.alpha = 0;
            }
        }else if([title isEqualToString:@"抖音号"]){
            [self.message setTextColor:[UIColor blackColor]];
            [self.message setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
            [self.message setText:[AppUserData GetCurrenUser].uid];
            [self.customAddlabel setlabel:0];
            self.customAddlabel.alpha = 0;
        }else if([title isEqualToString:@"主页背景"]){
            [self.message setFont:[UIFont systemFontOfSize:17.0]];
            [self.message setTextColor:[UIColor lightGrayColor]];
            [self.message setText:@"更换主页背景"];
            [self.customAddlabel setlabel:0];
            self.customAddlabel.alpha = 0;
        }else if([title isEqualToString:@"二维码"]){
            [self.message setFont:[UIFont systemFontOfSize:17.0]];
            [self.message setTextColor:[UIColor lightGrayColor]];
            [self.message setText:@"查看你的二维码"];
            [self.customAddlabel setlabel:0];
            self.customAddlabel.alpha = 0;
        }else if([title isEqualToString:@"编辑服务"]){
            [self.message setFont:[UIFont systemFontOfSize:17.0]];
            [self.message setTextColor:[UIColor lightGrayColor]];
            [self.message setText:@"选择你的抖音服务"];
            [self.customAddlabel setlabel:0];
            self.customAddlabel.alpha = 0;
        }
}

@end
