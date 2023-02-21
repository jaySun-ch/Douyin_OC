//
//  TableCellOfText.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "TableCellTalkText.h"

@interface TableCellTalkText()
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UITextView *SendMessage;

@end

@implementation TableCellTalkText



-(void)SetStatLable{
    
}

-(void)initWithModel:(BOOL)isFriend Message:(NSString *)Message{
    self.StatLable = [[UILabel alloc] init];
    [self.StatLable setFont:[UIFont systemFontOfSize:10.0]];
    [self.StatLable setTintColor:[UIColor lightGrayColor]];
    [self addSubview:self.StatLable];
    self.clientImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
    self.clientImage.contentMode = UIViewContentModeScaleAspectFill;
    self.clientImage.layer.cornerRadius = 20;
    self.clientImage.clipsToBounds = YES;
    [self addSubview:self.clientImage];
    
    self.SendMessage = [[UITextView alloc] init];
    [self.SendMessage setScrollEnabled:NO];
    [self.SendMessage setEditable:NO];
    self.SendMessage.layer.cornerRadius = 10;
    self.SendMessage.clipsToBounds = YES;
    self.SendMessage.textAlignment = UITextAlignmentCenter;
    [self.SendMessage setText:Message];
    [self.SendMessage setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:self.SendMessage];
    
    if(isFriend){
        [self initFriendCell];
    }else{
        [self initMyCell];
    }

}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.StatLable removeFromSuperview];
    [self.clientImage removeFromSuperview];
    [self.SendMessage removeFromSuperview];
}

-(void)initFriendCell{
    self.SendMessage.textColor = [UIColor blackColor];
    self.SendMessage.backgroundColor = [UIColor colorNamed:@"lightgray"];
    CGSize size = [self.SendMessage.text singleLineSizeWithText:[UIFont systemFontOfSize:16.0]];
    CGFloat height = [self.SendMessage.text heightForFont:[UIFont systemFontOfSize:16.0] width:ScreenWidth - 100];
    if(size.width > ScreenWidth - 100){
        [self.clientImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(10);
            make.width.height.mas_equalTo(40);
            make.top.equalTo(self).inset(5);
        }];
        
        [self.SendMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(5);
            make.right.equalTo(self).inset(100);
            make.top.equalTo(self.clientImage);
            make.width.mas_equalTo(size.width + 15);
        }];
    }else{
        [self.SendMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(5);
            make.centerY.equalTo(self.clientImage);
            make.width.mas_equalTo(size.width + 15);
        }];
        
        [self.clientImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(10);
            make.width.height.mas_equalTo(40);
            make.centerY.equalTo(self);
        }];
    }
  
    [self.StatLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SendMessage.mas_bottom).inset(5);
        make.height.mas_equalTo(15);
        make.left.equalTo(self.SendMessage);
    }];
}

-(void)initMyCell{
    self.SendMessage.textColor = [UIColor whiteColor];
    self.SendMessage.backgroundColor = [UIColor systemBlueColor];
    
    CGSize size = [self.SendMessage.text singleLineSizeWithText:[UIFont systemFontOfSize:16.0]];
    CGFloat height = [self.SendMessage.text heightForFont:[UIFont systemFontOfSize:16.0] width:ScreenWidth - 100];
    if(size.width > ScreenWidth - 100){
        [self.clientImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(10);
            make.width.height.mas_equalTo(40);
            make.top.equalTo(self).inset(5);
        }];
        
        [self.SendMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.clientImage.mas_left).inset(5);
            make.left.equalTo(self).inset(100);
            make.top.equalTo(self.clientImage);
            make.width.mas_equalTo(size.width + 20);
        }];
    }else{
        [self.clientImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(10);
            make.width.height.mas_equalTo(40);
            make.centerY.equalTo(self);
        }];
        
        [self.SendMessage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.clientImage.mas_left).inset(5);
            make.centerY.equalTo(self.clientImage);
            make.width.mas_equalTo(size.width + 20);
        }];
       
    }
    
    [self.StatLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SendMessage.mas_bottom).inset(5);
        make.height.mas_equalTo(15);
        make.right.equalTo(self.SendMessage);
    }];
}

-(void)AddLoadView{
}

@end
