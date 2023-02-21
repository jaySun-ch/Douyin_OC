//
//  CustomeIntroduceView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//

#import "CustomeIntroduceView.h"
#import "CustomBackgroundButton.h"
#import <Masonry/Masonry.h>

#define TopMargin 8

@interface CustomeIntroduceView()
@property (nonatomic,strong) UILabel *introduce;
@property (nonatomic,strong) UIImageView *introduceRightButton;
@property (nonatomic,strong) CustomBackgroundButton *addbutton; // 性别 年龄 所在地 学校
@property (nonatomic,strong) CustomBackgroundButton *ageButton;
@property (nonatomic,strong) CustomBackgroundButton *locationButton;
@property (nonatomic,strong) CustomBackgroundButton *schoolButton;

@end

@implementation CustomeIntroduceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubView];
    }
    return self;
}

-(void)initData:(ClientData *)data{
    [self.introduceRightButton setHidden:YES];
    [self.ageButton removeFromSuperview];
    [self.locationButton removeFromSuperview];
    [self.schoolButton removeFromSuperview];
    
    self.ageButton = nil;
    self.locationButton = nil;
    self.schoolButton = nil;
    
    if([data.introduce isEqualToString:@""]){
        [self.introduce setText:@"谢谢你的关注"];
        self.introduceRightButton.alpha = 1;
        [self.introduce setTextColor:[UIColor blackColor]];
    }else{
        self.introduceRightButton.alpha = 0;
        [self.introduce setText:data.introduce];
        [self.introduce setTextColor:[UIColor blackColor]];
    }
    
    if(data.bornDate != nil){
        // 如果性别 或者 生日不为空
        if([data.sex isEqualToString:@"男"]){
            self.ageButton = [[CustomBackgroundButton alloc] init];
            [self.ageButton initWithdata:[data.bornDate GetYear] image:[UIImage imageNamed:@"man"]];
        }else if(([data.sex isEqualToString:@"女"])){
            self.ageButton = [[CustomBackgroundButton alloc] init];
            [self.ageButton initWithdata:[data.bornDate GetYear] image:[UIImage imageNamed:@"woman"]];
        }else{
            self.ageButton = [[CustomBackgroundButton alloc] init];
            [self.ageButton initWithdata:[data.bornDate GetYear] image:nil];
        }
        [self addSubview:self.ageButton];
    }
    
    
    
    if(![data.location isEqualToString:@""]){
        self.locationButton = [[CustomBackgroundButton alloc] init];
        [self.locationButton initWithdata:data.location image:nil];
        [self addSubview:self.locationButton];
    }
    
    if(![data.school isEqualToString:@""]){
        self.schoolButton = [[CustomBackgroundButton alloc] init];
        [self.schoolButton initWithdata:data.school image:nil];
        [self addSubview:self.schoolButton];
    }
    
    CGSize sexsize = [data.sex singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    CGSize locationsize = [data.location singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    CGSize schoolsize = [data.school singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    CGSize addsize = [@"点击添加标签" singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    
    if(self.ageButton != nil && self.locationButton != nil && self.schoolButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(18);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationButton.mas_right).inset(8);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
    }else if(self.ageButton != nil && self.locationButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(18);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
    }else if(self.ageButton != nil && self.schoolButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(15);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
        
    }else if(self.locationButton != nil && self.schoolButton != nil){
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
        
    }else if(self.ageButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        
    }else if(self.locationButton != nil){
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
    }else if(self.schoolButton != nil){
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
        
    }
}

-(void)initData{
    [self.addbutton removeFromSuperview];
    [self.ageButton removeFromSuperview];
    [self.locationButton removeFromSuperview];
    [self.schoolButton removeFromSuperview];
    
    self.addbutton = nil;
    self.ageButton = nil;
    self.locationButton = nil;
    self.schoolButton = nil;
    
    if([[AppUserData GetCurrenUser].introduce isEqualToString:@""]){
        [self.introduce setText:@"点击添加介绍,让大家认识你"];
        self.introduceRightButton.alpha = 1;
    }else{
        self.introduceRightButton.alpha = 0;
        [self.introduce setText:[AppUserData GetCurrenUser].introduce];
        [self.introduce setTextColor:[UIColor blackColor]];

    }
    
    if([AppUserData GetCurrenUser].bornDate != nil){
        // 如果性别 或者 生日不为空
        if([[AppUserData GetCurrenUser].sex isEqualToString:@"男"]){
            self.ageButton = [[CustomBackgroundButton alloc] init];
            [self.ageButton initWithdata:[[AppUserData GetCurrenUser].bornDate GetYear] image:[UIImage imageNamed:@"man"]];
        }else if(([[AppUserData GetCurrenUser].sex isEqualToString:@"女"])){
            self.ageButton = [[CustomBackgroundButton alloc] init];
            [self.ageButton initWithdata:[[AppUserData GetCurrenUser].bornDate GetYear] image:[UIImage imageNamed:@"woman"]];
        }else{
            self.ageButton = [[CustomBackgroundButton alloc] init];
            [self.ageButton initWithdata:[[AppUserData GetCurrenUser].bornDate GetYear] image:nil];
        }
        [self addSubview:self.ageButton];
    }
    
    
    
    if(![[AppUserData GetCurrenUser].location isEqualToString:@""]){
        self.locationButton = [[CustomBackgroundButton alloc] init];
        [self.locationButton initWithdata:[AppUserData GetCurrenUser].location image:nil];
        [self addSubview:self.locationButton];
    }
    
    if(![[AppUserData GetCurrenUser].school isEqualToString:@""]){
        self.schoolButton = [[CustomBackgroundButton alloc] init];
        [self.schoolButton initWithdata:[AppUserData GetCurrenUser].school image:nil];
        [self addSubview:self.schoolButton];
    }
    
    if(self.schoolButton == nil || self.ageButton == nil || self.locationButton == nil){
        self.addbutton = [[CustomBackgroundButton alloc] init];
        [self.addbutton initWithdata:@"点击添加标签" image:[UIImage systemImageNamed:@"plus"]];
        [self addSubview:self.addbutton];
    }
    
    CGSize sexsize = [[AppUserData GetCurrenUser].sex singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    CGSize locationsize = [[AppUserData GetCurrenUser].location singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    CGSize schoolsize = [[AppUserData GetCurrenUser].school singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    CGSize addsize = [@"点击添加标签" singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    
    if(self.ageButton != nil && self.locationButton != nil && self.schoolButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(18);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationButton.mas_right).inset(8);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
    }else if(self.ageButton != nil && self.locationButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(18);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }else if(self.ageButton != nil && self.schoolButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(15);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }else if(self.locationButton != nil && self.schoolButton != nil){
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }else if(self.ageButton != nil){
        [self.ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+sexsize.width);
        }];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ageButton.mas_right).inset(20);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }else if(self.locationButton != nil){
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+locationsize.width);
        }];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.locationButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }else if(self.schoolButton != nil){
        [self.schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(12+schoolsize.width);
        }];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.schoolButton.mas_right).inset(5);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }else{
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.introduce.mas_bottom).inset(TopMargin);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30+addsize.width);
        }];
    }
}

-(void)initSubView{
    self.introduce = [[UILabel alloc] init];
    [self.introduce setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:self.introduce];
    
    self.introduceRightButton = [[UIImageView alloc] init];
    [self.introduceRightButton setImage:[UIImage systemImageNamed:@"rectangle.and.pencil.and.ellipsis"]];
    [self.introduce setTextColor:[UIColor grayColor]];
    [self.introduceRightButton setTintColor:[UIColor grayColor]];
    [self addSubview:self.introduceRightButton];
    
    
    [self.introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [self.introduceRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.introduce.mas_right);
        make.bottom.equalTo(self.introduce);
    }];
}


@end
