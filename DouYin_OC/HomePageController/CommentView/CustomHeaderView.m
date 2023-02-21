//
//  CustomHeaderView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//

#import "CustomHeaderView.h"
#import "DefinGroup.pch"
#import <Masonry/Masonry.h>

@implementation CustomHeaderView

- (instancetype)initWithData:(CommentModel *)data{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    if(self){
        _commentdata = data;
        _clientImage = [[UIImageView alloc] init];
        _clientname = [[UILabel alloc] init];
        _message = [[UILabel alloc]init];
        _timeAndLocation = [[UILabel alloc]init];
        _likeButton = [[UIButton alloc] init];
        _dislikeButton = [[UIButton alloc]init];
        [self SetUpView];
    }
    return self;
}

- (void)SetUpView{
    [_clientImage setImage:[UIImage imageNamed:@"img_find_default"]];
    [_clientname setText:self.commentdata.CommentName];
    _clientImage.layer.cornerRadius = 15;
    [self addSubview:_clientImage];

    [_clientname setFont:MoreSmallFont];
    [_clientname setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_clientname];


    [_message setFont:[UIFont systemFontOfSize:15.0]];
    [_message setText:self.commentdata.Message];
    [self addSubview:_message];

    [_timeAndLocation setFont:MoreSmallFont];
    [_timeAndLocation setText:[NSString stringWithFormat:@"%@前  %@",@"1小时",self.commentdata.loaction]];
    [_timeAndLocation setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_timeAndLocation];

    [_likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_likeButton setTintColor:[UIColor lightGrayColor]];
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",self.commentdata.Like.count] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(LikeComment) forControlEvents:UIControlEventTouchUpInside];
    [_likeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_likeButton];

    [_dislikeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_dislikeButton setTintColor:[UIColor lightGrayColor]];
    [_dislikeButton setImage:[UIImage systemImageNamed:@"heart.slash"] forState:UIControlStateNormal];
    [_dislikeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_dislikeButton];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"回复";
    [label setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightBold]];
    [label setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label];

    [_clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(8);
        make.width.height.mas_equalTo(30);
        make.top.equalTo(self).inset(5);
    }];

    [_dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self).inset(5);;
    }];

    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dislikeButton.mas_left).inset(20);
        make.bottom.equalTo(self).inset(5);
    }];

    [_clientname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).inset(5);
        make.left.mas_equalTo(_clientImage.mas_right).inset(8);
    }];

    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_clientname.mas_bottom).inset(4);
        make.left.mas_equalTo(_clientImage.mas_right).inset(8);
    }];

    [_timeAndLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_message.mas_bottom).inset(7);
        make.left.mas_equalTo(_clientImage.mas_right).inset(8);
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeAndLocation.mas_right).inset(20);
        make.centerY.mas_equalTo(_timeAndLocation.mas_centerY);
    }];
}

-(void)LikeComment{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if(self.likeButton.isSelected){
            [self.likeButton setSelected:NO];
            [self.likeButton setTintColor:[UIColor lightGrayColor]];
            if(self.deLikeComment){
                self.deLikeComment();
            }
        }else{
            [self.likeButton setSelected:YES];
            [self.likeButton setTintColor:[UIColor redColor]];
            if(self.likecomment){
                self.likecomment();
            }
        }
    } completion:nil];
}

@end
