//
//  RecommendClientCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "RecommendClientCell.h"


@interface RecommendClientCell()

@end

@implementation RecommendClientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.clientImage = [[UIImageView alloc] init];
        self.clientImage.layer.cornerRadius = 30;
        self.clientImage.clipsToBounds = YES;
        self.clientImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.clientImage];
        
        self.clientName = [[UILabel alloc] init];
        [self.clientName setFont:titleFont];
        [self addSubview:self.clientName];
        
        self.subtitle = [[UILabel alloc] init];
        [self.subtitle setFont:subtitleFont];
        [self.subtitle setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.subtitle];
        

        [self.clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(60);
        }];
        
        [self.clientName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(self.centerY - 2);
            make.left.equalTo(self.clientImage.mas_right).inset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.clientName.mas_bottom).inset(2);
            make.left.equalTo(self.clientImage.mas_right).inset(10);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}


- (void)SetCellWithType:(RecommendClientCellType)type{
    if(type == RecommendClientCellNormal){
        self.deleteButton = [[UIButton alloc] init];
        self.deleteButton.layer.cornerRadius = 5;
        [self.deleteButton setTitle:@"移除" forState:UIControlStateNormal];
        [self.deleteButton.titleLabel setFont:subtitleFontMedium];
        [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.deleteButton setBackgroundColor:lightgraycolor];
        [self.deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [self.contentView addSubview:self.deleteButton];
        
        self.concernButton = [[UIButton alloc] init];
        self.concernButton.layer.cornerRadius = 5;
        [self.concernButton.titleLabel setFont:subtitleFontMedium];
        [self.concernButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.concernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.concernButton setBackgroundColor:[UIColor systemPinkColor]];
        [self.concernButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [self.contentView addSubview:self.concernButton];
        
        [self.concernButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(80);
        }];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.concernButton.mas_left).inset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
    }else if(type == RecommendClientCellPoke){
        self.PokeButton = [[UIButton alloc] init];
        self.PokeButton.layer.cornerRadius = 5;
        [self.PokeButton setTitle:@"戳一戳" forState:UIControlStateNormal];
        [self.PokeButton.titleLabel setFont:subtitleFontMedium];
        [self.PokeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.PokeButton setBackgroundColor:lightgraycolor];
        [self.PokeButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [self.contentView addSubview:self.PokeButton];
        
        [self.PokeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
    }else if(type == RecommendClientCellHasConcern){
        self.HasConcernButton = [[UIButton alloc] init];
        self.HasConcernButton.layer.cornerRadius = 5;
        [self.HasConcernButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.HasConcernButton.titleLabel setFont:subtitleFontMedium];
        [self.HasConcernButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.HasConcernButton setBackgroundColor:lightgraycolor];
        [self.HasConcernButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [self.contentView addSubview:self.HasConcernButton];
        
        [self.HasConcernButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
    }else if(type == RecommendClientCellChat){
        self.chatButton = [[UIButton alloc] init];
        self.chatButton.layer.cornerRadius = 5;
        [self.chatButton setTitle:@"发私信" forState:UIControlStateNormal];
        [self.chatButton.titleLabel setFont:subtitleFontMedium];
        [self.chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.chatButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        self.chatButton.layer.borderWidth = 1;
        self.chatButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:self.chatButton];
        
        self.SetButton = [[UIButton alloc] init];
        [self.SetButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
        [self.SetButton setTintColor:[UIColor blackColor]];
        [self.contentView addSubview:self.SetButton];
        [self.SetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30);
        }];
        
        
        [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.SetButton.mas_left).inset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
    }else if(type == RecommendClientCellConcern){
        
        [self.subtitle setFont:[UIFont systemFontOfSize:12.0]];

        self.concernButton = [[UIButton alloc] init];
        self.concernButton.layer.cornerRadius = 5;
        [self.concernButton.titleLabel setFont:subtitleFontMedium];
        [self.concernButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.concernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.concernButton setBackgroundColor:[UIColor systemPinkColor]];
        [self.concernButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [self.contentView addSubview:self.concernButton];
        
        [self.concernButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
    }else if(type == RecommendClientCellSearchConcern){
        [self.subtitle setFont:[UIFont systemFontOfSize:12.0]];
        
        self.downLabel = [[UILabel alloc] init];
        [self.downLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.downLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.downLabel];
        
        self.concernButton = [[UIButton alloc] init];
        self.concernButton.layer.cornerRadius = 5;
        [self.concernButton.titleLabel setFont:subtitleFontMedium];
        [self.concernButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.concernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.concernButton setBackgroundColor:[UIColor systemPinkColor]];
        [self.concernButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [self.contentView addSubview:self.concernButton];
        
        [self.concernButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
        
        [self.clientName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(10);
            make.left.equalTo(self.clientImage.mas_right).inset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subtitle.mas_bottom).inset(2);
            make.left.equalTo(self.clientImage.mas_right).inset(10);
            make.height.mas_equalTo(20);
        }];
    }
    
    if(self.subtitle.text == nil || [self.subtitle.text isEqualToString:@""]){
        [self.clientName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.clientImage.mas_right).inset(10);
            make.height.mas_equalTo(20);
        }];
    }
    
    [self SetTap];
}


-(void)SetTap{
    self.concernButton.tag = RecommendButtonConcern;
    [self.concernButton addTarget:self action:@selector(TapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    self.chatButton.tag = RecommendButtonChat;
    [self.chatButton addTarget:self action:@selector(TapOnButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)TapOnButton:(UIButton *)sender{
    if(_delegate){
        [_delegate DidTapWithTag:sender.tag index:self.MyIndex];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.PokeButton removeFromSuperview];
    [self.concernButton removeFromSuperview];
    [self.HasConcernButton removeFromSuperview];
    [self.deleteButton removeFromSuperview];
    [self.downLabel removeFromSuperview];
}




@end
