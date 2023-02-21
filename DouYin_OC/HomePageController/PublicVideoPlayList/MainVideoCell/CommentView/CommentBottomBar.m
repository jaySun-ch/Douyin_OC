//
//  CommentBottomBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/21.
//

#import "CommentBottomBar.h"

@interface CommentBottomBar()<YYTextViewDelegate>
@property (nonatomic,strong) UIView *Background;
@property (nonatomic,strong) UIButton *At;
@property (nonatomic,strong) UIButton *face;
@property (nonatomic,strong) UIButton *plus;
@property (nonatomic,strong) UIButton *makesurebutton;
@end


@implementation CommentBottomBar

- (instancetype)init{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineview = [UIView new];
        lineview.backgroundColor = lightgraycolor;
        [self addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(1);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(1);
        }];
        self.Background = [UIView new];
        self.Background.backgroundColor = lightgraycolor;
        self.Background.layer.cornerRadius = 20;
        [self addSubview:self.Background];
        
        self.textview = [[YYTextView alloc] init];
        self.textview.delegate = self;
        self.textview.returnKeyType = UIReturnKeySend;
        [self.textview setFont:[UIFont systemFontOfSize:16.0]];
        [self.textview setPlaceholderFont:[UIFont systemFontOfSize:16.0 ]];
        [self.textview setPlaceholderTextColor:[UIColor darkGrayColor]];
        [self.textview setPlaceholderText:@"善语结善缘，恶言伤人心"];
        [self addSubview:self.textview];
        [self.Background addSubview:self.textview];
        
        self.At = [UIButton new];
        self.At.tintColor = [UIColor blackColor];
        [self.At setImage:[UIImage systemImageNamed:@"at"] forState:UIControlStateNormal];
        [self.Background addSubview:self.At];
        
        self.face = [UIButton new];
        self.face.tintColor = [UIColor blackColor];
        [self.face setImage:[UIImage systemImageNamed:@"face.smiling"] forState:UIControlStateNormal];
        [self.Background addSubview:self.face];
        
        self.plus = [UIButton new];
        self.plus.tintColor = [UIColor blackColor];
        [self.plus setImage:[UIImage systemImageNamed:@"plus.circle"] forState:UIControlStateNormal];
        [self.Background addSubview:self.plus];
        
        self.makesurebutton = [UIButton new];
        [self.makesurebutton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.makesurebutton setTitle:@"发送" forState:UIControlStateNormal];
        [self.makesurebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.makesurebutton setBackgroundColor:[UIColor systemPinkColor]];
        self.makesurebutton.layer.cornerRadius = 10;
        [self addSubview:self.makesurebutton];
        
        self.Background.top = self.top + 12;
        self.Background.left = self.left + 10;
        self.Background.width = ScreenWidth - 20;
        self.Background.height = 40;
//        [self.Background mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).inset(12);
//            make.left.equalTo(self).inset(10);
//            make.width.mas_equalTo(ScreenWidth - 20);
//            make.height.mas_equalTo(40);
//        }];
        
        [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.Background).inset(5);
            make.height.mas_lessThanOrEqualTo(40);
            make.left.equalTo(self.Background).inset(5);
            make.width.mas_equalTo((ScreenWidth - 40) * 2 / 3);
        }];
        
        [self.plus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.Background);
            make.centerY.equalTo(self.Background);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.face mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.plus.mas_left);
            make.centerY.equalTo(self.Background);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.At mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.face.mas_left);
            make.centerY.equalTo(self.Background);
            make.width.height.mas_equalTo(35);
        }];
        
        [self.makesurebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(5);
            make.bottom.equalTo(self.Background);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(55);
        }];
        
        self.makesurebutton.transform = CGAffineTransformMakeTranslation(100, 0);
    }
    return self;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.textview resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(YYTextView *)textView{
    if(![textView.text isEqualToString:@""]){
        [UIView animateWithDuration:0.2f animations:^{
            self.Background.width = ScreenWidth - 80;
            self.makesurebutton.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }else{
        [UIView animateWithDuration:0.2f animations:^{
            self.Background.width = ScreenWidth - 20;
            self.makesurebutton.transform = CGAffineTransformMakeTranslation(100, 0);
        }];
    }
}


-(void)KeyboardShowLayout{
//    self.Background.top = self.top + 12;
//    self.Background.left = self.left + 10;
//    self.Background.width = ScreenWidth - 20;
    self.Background.height = 80;
//    [self.Background mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).inset(12);
//        make.left.equalTo(self).inset(10);
//        make.height.mas_equalTo(80);
//    }];
    
    [self.textview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Background).inset(5);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.Background).inset(5);
        make.width.mas_equalTo(ScreenWidth - 40);
    }];
    
    [self.plus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.Background);
        make.top.equalTo(self.textview.mas_bottom);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.face mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plus.mas_left);
        make.centerY.equalTo(self.plus);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.At mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.face.mas_left);
        make.centerY.equalTo(self.plus);
        make.width.height.mas_equalTo(35);
    }];
}

-(void)KeyBoardDissmisslayout{
//    self.Background.top = self.top + 12;
//    self.Background.left = self.left + 10;
//    self.Background.width = ScreenWidth - 20;
    self.Background.height = 40;
//    [self.Background mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).inset(12);
//        make.left.equalTo(self).inset(10);
//        make.height.mas_equalTo(40);
//    }];
    
    [self.textview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Background).inset(5);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.Background).inset(5);
        make.width.mas_equalTo((ScreenWidth - 40) * 2 / 3);
    }];
    
    [self.plus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.Background);
        make.centerY.equalTo(self.Background);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.face mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plus.mas_left);
        make.centerY.equalTo(self.Background);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.At mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.face.mas_left);
        make.centerY.equalTo(self.Background);
        make.width.height.mas_equalTo(35);
    }];
}

@end
