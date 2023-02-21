//
//  ChangeBackGroundView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import "ChangeBackGroundView.h"

@interface ChangeBackGroundView()
@property (nonatomic,strong) UIButton *changeBackgroundbutton;
@property (nonatomic,strong) UIButton *downLoadBackground;
@end

@implementation ChangeBackGroundView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(ScaleWithClientBackgroundImage:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapDismissView:)]];
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(DragBackgroundHandle:)]];
        //    [self.header OffsetBackGroundImage];
        self.backgroundImage = [[UIImageView alloc] init];
        [self.backgroundImage setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].BackGroundImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
        [self.backgroundImage setUserInteractionEnabled:YES];

        [self addSubview:self.backgroundImage];
        
        self.changeBackgroundbutton = [[UIButton alloc] init];
        self.changeBackgroundbutton.layer.cornerRadius = 3;
        [self.changeBackgroundbutton setTitle:@"更换背景" forState:UIControlStateNormal];
        [self.changeBackgroundbutton setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
        [self.changeBackgroundbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.changeBackgroundbutton addTarget:self action:@selector(ShowChangeBackGroundSelectController) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changeBackgroundbutton];
        
        
        self.downLoadBackground = [[UIButton alloc]init];
        self.downLoadBackground.layer.cornerRadius = 3;
        [self.downLoadBackground setTitle:@"下载" forState:UIControlStateNormal];
        [self.downLoadBackground setImage:[UIImage systemImageNamed:@"arrow.down.to.line.compact"] forState:UIControlStateNormal];
        [self.downLoadBackground setTintColor:[UIColor whiteColor]];
        [self.downLoadBackground addTarget:self action:@selector(SavaImage) forControlEvents:UIControlEventTouchUpInside];
        [self.downLoadBackground setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.downLoadBackground setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
        [self addSubview:self.downLoadBackground];
        
        [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(200);
        }];
        
        [self.changeBackgroundbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(15);
            make.bottom.equalTo(self).inset(50);
            make.width.mas_equalTo((ScreenWidth - 35) / 2);
            make.height.mas_equalTo(40);
        }];
        
        [self.downLoadBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(15);
            make.bottom.equalTo(self).inset(50);
            make.width.mas_equalTo((ScreenWidth - 35 )/ 2);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

-(void)SavaImage{
    [CustomImagePicker SaveImageToPhotos:self.backgroundImage.image];
}

-(void)ShowChangeBackGroundSelectController{
    if(_delegate){
        [_delegate ShowSelectBackGroundViewController];
    }
}


-(void)ScaleWithClientBackgroundImage:(UIPinchGestureRecognizer *)gesture{
    self.backgroundImage.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    if(gesture.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundImage.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }
    NSLog(@"%f scale",gesture.scale);
}

-(void)TapDismissView:(UITapGestureRecognizer *)gesture{
    if(_delegate){
        [_delegate DismissBackGroundView:NO];
    }
}

-(void)DragBackgroundHandle:(UIPanGestureRecognizer *)gesture{
    CGPoint trans = [gesture translationInView:self];
    
    if(gesture.state != UIGestureRecognizerStateEnded){
        self.backgroundImage.transform = CGAffineTransformMakeTranslation(0, trans.y);
    }else{
        if(trans.y > 310){
            if(_delegate){
                [_delegate DismissBackGroundView:YES];
            }
        }else if(trans.y < - 310){
            if(_delegate){
                [_delegate DismissBackGroundView:NO];
            }
        }else{
            [UIView animateWithDuration:0.3f animations:^{
                self.backgroundImage.transform = CGAffineTransformMakeTranslation(0,0);
            } completion:nil];
        }
        NSLog(@"%f DragBackgroundHandle",trans.y);
    }
}


@end
