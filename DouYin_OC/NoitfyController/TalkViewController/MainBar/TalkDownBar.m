//
//  TalkDownBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "TalkDownBar.h"

@interface TalkDownBar()<YYTextViewDelegate>
@property (nonatomic,strong) UIView *Background;
@property (nonatomic,strong) UIView *cameraBackground;
@property (nonatomic,strong) UIImageView *camera;
@property (nonatomic,strong) YYTextView *textfiled;
@property (nonatomic,strong) UIImageView *Wave;
@property (nonatomic,strong) UIImageView *face;
@property (nonatomic,strong) UIImageView *plus;
@end

@implementation TalkDownBar
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor blackColor];
    self.Background = [[UIView alloc] init];
    self.Background.backgroundColor = [UIColor colorNamed:@"lightgray"];
    self.Background.layer.cornerRadius =  5;
    [self addSubview:self.Background];
    
    self.cameraBackground = [[UIView alloc] init];
    self.cameraBackground.layer.cornerRadius = 35 / 2;
    self.cameraBackground.clipsToBounds = YES;
    self.cameraBackground.backgroundColor = [UIColor linkColor];
    [self.Background addSubview:self.cameraBackground];
    
    self.camera = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"camera.fill"]];
//        self.camera.layoutMargins = UIEdgeInsetsMake(2, 2, 2, 2);
    [self.camera setTintColor:[UIColor whiteColor]];
    [self.cameraBackground addSubview:self.camera];
    
    self.textfiled = [[YYTextView alloc] init];
    self.textfiled.delegate = self;
    self.textfiled.returnKeyType = UIReturnKeySend;
    self.textfiled.font = [UIFont systemFontOfSize:17.0];
    self.textfiled.placeholderText = @"发送消息";
    [self.Background addSubview:self.textfiled];
    
    self.Wave = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"wave.3.right.circle"]];
    [self.Background addSubview:self.Wave];
    
    self.face = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"face.smiling"]];
    [self.Background addSubview:self.face];
    
    self.plus = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"plus.circle"]];
    [self.plus setUserInteractionEnabled:YES];
    [self.plus addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self SendMessage];
    }]];
    [self.Background addSubview:self.plus];
    
    [self.Background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).inset(5);
        make.left.equalTo(self).inset(10);
        make.right.equalTo(self).inset(10);
        make.bottom.equalTo(self).inset(5);
        make.width.mas_equalTo(self.size.width - 20);
    }];
    
    [self.cameraBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Background).inset(3);
        make.bottom.equalTo(self.Background).inset(5);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    [self.camera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.cameraBackground);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.Background).inset(3);
        make.bottom.equalTo(self.Background).inset(7);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.face mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plus.mas_left).inset(3);
        make.bottom.equalTo(self.Background).inset(7);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.Wave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.face.mas_left).inset(3);
        make.bottom.equalTo(self.Background).inset(7);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cameraBackground.mas_right).inset(3);
        make.top.equalTo(self.Background).inset(5);
        make.bottom.equalTo(self.Background).inset(5);
        make.right.equalTo(self.Wave.mas_left).inset(5);
    }];
}

- (void)textViewDidChange:(YYTextView *)textView{
    if(_delegate){
        [_delegate DidChangeTextViewHeight:textView.contentSize.height];
    }
    if([textView.text isEqualToString:@""]){
        [self ResetFrame];
    }else{
        [self SetNewFrame];
    }
}


-(void)SendMessage{
    if(_delegate){
        [_delegate DidSendMessage:self.textfiled.text];
    }
    [[PDSocketManager shared] SendMessageWithRoomIDWithID:self.TalkID message:self.textfiled.text MyName:[AppUserData GetCurrenUser].username];
    self.textfiled.text = @"";
}




-(void)SetNewFrame{
    if(self.plus.image != [UIImage systemImageNamed:@"arrow.up.circle.fill"]){
        [UIView animateWithDuration:0.2f animations:^{
            [self.Wave removeFromSuperview];
            [self.camera setImage:[UIImage systemImageNamed:@"magnifyingglass"]];
            [self.plus setImage:[UIImage systemImageNamed:@"arrow.up.circle.fill"]];
            [self.plus setTintColor:[UIColor systemPinkColor]];
            [self.camera mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
            [self.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.face.mas_left).inset(5);
            }];
            self.Wave = nil;
        }];
    }
}

-(void)ResetFrame{
    if(self.Wave == nil){
        [UIView animateWithDuration:0.2f animations:^{
            [self.camera setImage:[UIImage systemImageNamed:@"camera.fill"]];
            self.Wave = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"wave.3.right.circle"]];
            [self.Background addSubview:self.Wave];
            [self.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.face.mas_left).inset(3+30);
            }];
            [self.Wave mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.face.mas_left).inset(3);
                make.bottom.equalTo(self.Background).inset(7);
                make.width.height.mas_equalTo(30);
            }];
            [self.plus setImage:[UIImage systemImageNamed:@"plus.circle"]];
            [self.plus setTintColor:[UIColor blackColor]];
            [self.camera mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(20);
            }];
        }];
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
            if(![self.textfiled.text isEqualToString:@""]){
                [self SendMessage];
            }
           return NO;
       }
       return YES;
}

-(void)DisMissKeyBoard{
    [self.textfiled resignFirstResponder];
}




@end
