//
//  SecondCommentCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/21.
//

#import "SecondCommentCell.h"
@interface SecondCommentCell()
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UILabel *clientName;
@property (nonatomic,strong) UILabel *commentContend;
@property (nonatomic,strong) UILabel *downLabel;
@property (nonatomic,strong) UIButton *likebutton;
@property (nonatomic,strong) UIButton *dislikebutton;
@property (nonatomic,strong) UILabel *OnTopTip;
@property (nonatomic,strong) UILabel *AuthorTip;
@end


@implementation SecondCommentCell

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 40;
    frame.size.width -= 40;
    [super setFrame:frame];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.clientImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
        self.clientImage.contentMode = UIViewContentModeScaleAspectFill;
        self.clientImage.clipsToBounds = YES;
        self.clientImage.layer.cornerRadius = 12.5;
        [self addSubview:self.clientImage];
        
        self.clientName = [UILabel new];
        [self.clientName setText:@"周杰伦"];
        [self.clientName setFont:[UIFont systemFontOfSize:13.0]];
        [self.clientName setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.clientName];
        
        self.commentContend = [UILabel new];
        [self.commentContend setFont:[UIFont systemFontOfSize:15.0]];
        [self.commentContend setNumberOfLines:MAXFLOAT];
        [self addSubview:self.commentContend];
        
        self.downLabel = [UILabel new];
        [self.downLabel setText:@"10-29.广东"];
        [self.downLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.downLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.downLabel];
        
        UILabel *label = [UILabel new];
        [label setText:@"回复"];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setTextColor:[UIColor darkGrayColor]];
        [self addSubview:label];
        
        self.likebutton = [UIButton new];
        [self.likebutton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.likebutton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        [self.likebutton setTintColor:[UIColor lightGrayColor]];
        [self.likebutton setTitle:@"3437" forState:UIControlStateNormal];
        [self.likebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.likebutton];
        
        self.dislikebutton = [UIButton new];
        [self.dislikebutton setImage:[UIImage imageNamed:@"heart_break1"] forState:UIControlStateNormal];
        [self.dislikebutton setTintColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.dislikebutton];
        
        [self.clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(15);
            make.top.equalTo(self).inset(10);
            make.width.height.mas_equalTo(25);
        }];
        
        [self.clientName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(8);
            make.top.equalTo(self.clientImage);
            make.height.mas_equalTo(15);
        }];
        
     
        [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(8);
            make.top.equalTo(self.commentContend.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.downLabel);
            make.left.equalTo(self.downLabel.mas_right).inset(15);
            make.height.mas_equalTo(15);
        }];
        
        [self.dislikebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.downLabel);
            make.right.equalTo(self).inset(15);
            make.width.height.mas_equalTo(15);
        }];
        
        [self.likebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.downLabel);
            make.right.equalTo(self.dislikebutton.mas_left).inset(15);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}


-(void)SetContentWith:(NSString *)text{
    CGFloat height = [text heightForFont:[UIFont systemFontOfSize:15.0] width:ScreenWidth - 80];
    NSMutableAttributedString *artText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 2;
    [artText setParagraphStyle:style];
    [self.commentContend setAttributedText:artText];
    [self.commentContend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clientImage.mas_right).inset(8);
        make.top.equalTo(self.clientName.mas_bottom);
        make.width.mas_equalTo(ScreenWidth - 80);
        make.height.mas_equalTo(height+10);
    }];
}

@end




