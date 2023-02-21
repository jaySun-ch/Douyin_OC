//
//  MainCommentTabCell.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/20.
//

#import "MainCommentTabCell.h"
#import <Masonry/Masonry.h>
#import "DefinGroup.pch"


@interface MainCommentTabCell()
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UILabel *clientname;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) UILabel *timeAndLocation;

@end

@implementation MainCommentTabCell

- (void)initWithData:(CommentModel *)data LeverUpName:(NSString *)LeverUpName{
    _data = data;
//    [_clientname setText:_data.commentName];
//    [_message setText:_data.meesage];
//    [_timeAndLocation setText:[NSString stringWithFormat:@"%@前.%@",_data.creatDate.description,_data.location]];
//    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)_data.Like] forState:UIControlStateNormal];
    if([data.WasCommentName isEqualToString:LeverUpName]){
        [_clientname setText:data.CommentName];
    }else{
        [_clientname setText:[NSString stringWithFormat:@"%@ 回复 %@",data.CommentName,data.WasCommentName]];
    }
    [_message setText:data.Message];
    [_timeAndLocation setText:[NSString stringWithFormat:@"%@前.%@",@"1小时",data.loaction]];
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",data.Like.count] forState:UIControlStateNormal];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _clientImage = [[UIImageView alloc] init];
        _clientname = [[UILabel alloc] init];
        _message = [[UILabel alloc]init];
        _timeAndLocation = [[UILabel alloc]init];
        _likeButton = [[UIButton alloc] init];
        _dislikeButton = [[UIButton alloc]init];
        [self setupView];
    }
    return self;
}

-(void)SetMain:(BOOL)IsMain{
    if(IsMain){
        [_clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(5);
            make.width.height.mas_equalTo(34);
            make.top.equalTo(self).inset(5);
        }];
    }else{
        _clientImage.layer.cornerRadius = 10;
        [_clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(40);
            make.width.height.mas_equalTo(20);
            make.top.equalTo(self).inset(5);
        }];
    }
}

-(void)setupView{
    [_clientImage setImage:[UIImage imageNamed:@"img_find_default"]];
    _clientImage.layer.cornerRadius = 17;
    [self addSubview:_clientImage];
    
    [_clientname setFont:MoreSmallFont];
    [_clientname setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_clientname];
    
    
    [_message setFont:[UIFont systemFontOfSize:15.0]];
    [self addSubview:_message];
    
    [_timeAndLocation setFont:MoreSmallFont];
    [_timeAndLocation setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_timeAndLocation];
    
    [_likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_likeButton setTintColor:[UIColor lightGrayColor]];
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",self.data.Like.count] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(LikeComment) forControlEvents:UIControlEventTouchUpInside];
    [_likeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.contentView addSubview:_likeButton];
    
    [_dislikeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_dislikeButton setTintColor:[UIColor lightGrayColor]];
    [_dislikeButton setImage:[UIImage systemImageNamed:@"heart.slash"] forState:UIControlStateNormal];
    [_dislikeButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
//    [_dislikeButton addTarget:self action:@selector(LikeComment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_dislikeButton];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"回复";
    [label setFont:[UIFont systemFontOfSize:12.5 weight:UIFontWeightBold]];
    [label setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label];
   

    
    [_dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dislikeButton.mas_left).inset(20);
        make.bottom.equalTo(self);
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
        make.top.equalTo(_message.mas_bottom).inset(8);
        make.left.mas_equalTo(_clientImage.mas_right).inset(8);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeAndLocation.mas_right).inset(18);
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
