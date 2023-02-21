//
//  MainTableCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "MainTableCell.h"

@interface MainTableCell()
@property (nonatomic,strong) UIImageView *ClientImage;
@property (nonatomic,strong) UILabel *clientname;
@property (nonatomic,strong) UILabel *subTitle;

@end

@implementation MainTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.ClientImage = [[UIImageView alloc] init];
        self.ClientImage.layer.cornerRadius = 25;
        self.ClientImage.clipsToBounds = YES;
        self.ClientImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.ClientImage];
        
        self.clientname = [[UILabel alloc] init];
        [self.clientname setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [self addSubview:self.clientname];
        
        self.subTitle = [[UILabel alloc] init];
        [self.subTitle setTextColor:[UIColor lightGrayColor]];
        [self.subTitle setFont:[UIFont systemFontOfSize:13.0]];
        [self addSubview:self.subTitle];
        
        self.CheckButton = [[UIImageView alloc] init];
        [self.CheckButton setTintColor:[UIColor lightGrayColor]];
        [self.CheckButton setImage:[UIImage systemImageNamed:@"circle"] ];
        [self addSubview:self.CheckButton];
        
        self.RemoveButton = [[UIImageView alloc] init];
        [self.RemoveButton setTintColor:[UIColor lightGrayColor]];
        [self.RemoveButton setImage:[UIImage systemImageNamed:@"iphone.and.arrow.forward"] ];
        self.RemoveButton.hidden = YES;
        [self.RemoveButton setUserInteractionEnabled:YES];
        [self.RemoveButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidTapOnRemoveButton:)]];
        [self.contentView addSubview:self.RemoveButton];
        
        [self.ClientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.clientname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ClientImage).inset(8);
            make.left.equalTo(self.ClientImage.mas_right).inset(10);
            make.height.mas_equalTo(15);
        }];
        
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.clientname.mas_bottom).inset(8);
            make.left.equalTo(self.ClientImage.mas_right).inset(10);
            make.height.mas_equalTo(15);
        }];
        
        [self.CheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.RemoveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(20);
        }];
    }
    return self;
}

-(void)SetData:(NSString *)imageurl name:(NSString *)name subtitle:(NSString *)subtitle iscurrent:(BOOL)iscurrent{
    [self.ClientImage setImageWithURL:[NSURL URLWithString:imageurl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.clientname setText:name];
    [self.subTitle setText:subtitle];
    if(iscurrent){
        [self.CheckButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        [self.CheckButton setTintColor:[UIColor systemPinkColor]];
    }else{
        [self.CheckButton setImage:[UIImage systemImageNamed:@"circle"]];
        [self.CheckButton setTintColor:[UIColor lightGrayColor]];
    }
}


-(void)DidTapOnRemoveButton:(UITapGestureRecognizer *)sender{
    if(_delegate){
        [_delegate DidTapOnRemoveButton:self.index];
    }
}


@end
