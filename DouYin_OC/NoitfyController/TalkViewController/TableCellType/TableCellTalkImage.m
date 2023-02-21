//
//  TableCellTalkImage.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "TableCellTalkImage.h"

@interface TableCellTalkImage()
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UIImageView *SendImage;
@end

@implementation TableCellTalkImage



-(void)initWithModel:(BOOL)isFriend imageurl:(NSString *)imageurl ImageRadio:(CGFloat)ImageRadio{
    self.clientImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
    self.clientImage.contentMode = UIViewContentModeScaleAspectFill;
    self.clientImage.layer.cornerRadius = 20;
    self.clientImage.clipsToBounds = YES;
    [self addSubview:self.clientImage];
    
    self.SendImage = [[UIImageView alloc]init];
    [self.SendImage setImageWithURL:[NSURL URLWithString:imageurl] options:YYWebImageOptionSetImageWithFadeAnimation];
    self.SendImage.contentMode = UIViewContentModeScaleAspectFill;
    self.SendImage.backgroundColor = [UIColor grayColor];
    self.SendImage.layer.cornerRadius = 5;
    self.SendImage.clipsToBounds = YES;
    [self addSubview:self.SendImage];
    
    if(isFriend){
        [self initFriendCell:ImageRadio];
    }else{
        [self initMyCell:ImageRadio];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.clientImage removeFromSuperview];
    [self.SendImage removeFromSuperview];
}

-(void)initFriendCell:(CGFloat)ImageRadio{
    [self.clientImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(10);
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self).inset(10);
    }];
    
    if(ImageRadio >= 1){
        [self.SendImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(self.frame.size.height - 20);
            make.top.equalTo(self).inset(10);
        }];
    }else{
        // 如果当前的是宽度大于长度
        [self.SendImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(5);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(self.frame.size.height - 20);
            make.top.equalTo(self).inset(10);
        }];
    }
   
}

-(void)initMyCell:(CGFloat)ImageRadio{
    [self.clientImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self).inset(10);
    }];
    
    if(ImageRadio >= 1){
        [self.SendImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.clientImage.mas_left).inset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(self.frame.size.height - 20);
            make.top.equalTo(self).inset(10);
        }];
    }else{
        // 如果当前的是宽度大于长度
        [self.SendImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.clientImage.mas_left).inset(5);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(self.frame.size.height - 20);
            make.top.equalTo(self).inset(10);
        }];
    }
}

@end
