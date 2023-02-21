//
//  ShowClientImageView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import "ShowClientImageView.h"
#import "CustomClientImageTableCell.h"

@interface ShowClientImageView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *FirstcontinaerView;
@property (nonatomic,strong) UIImageView *dissButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *clientImageView;
@end


@implementation ShowClientImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
    }
    return self;
}


-(void)initSubViews{
    [self setUserInteractionEnabled:YES];
    self.backgroundColor = [UIColor clearColor];
    self.FirstcontinaerView = [[UIView alloc] initWithFrame:self.frame];
    self.FirstcontinaerView.backgroundColor = [UIColor blackColor];
    self.FirstcontinaerView.alpha = 0;
    [self addSubview:self.FirstcontinaerView];
    
    self.dissButton = [[UIImageView alloc] init];
    [self.dissButton setUserInteractionEnabled:YES];
    [self.dissButton setTintColor:[UIColor whiteColor]];
    [self.dissButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DissMissView)]];
    [self.dissButton setImage:[UIImage systemImageNamed:@"xmark"]];
    [self.FirstcontinaerView addSubview:self.dissButton];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 5;
    [self.tableView setScrollEnabled:NO];
    [self.tableView registerClass:[CustomClientImageTableCell class] forCellReuseIdentifier:@"cell"];
    [self.FirstcontinaerView addSubview:self.tableView];
    [self.tableView reloadData];
    
    
    
    self.clientImageView = [[UIImageView alloc] init];
    self.clientImageView.clipsToBounds = YES;
    self.clientImageView.layer.cornerRadius = 40;
    [self.clientImageView setUserInteractionEnabled:YES];
    self.clientImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.clientImageView.frame = CGRectMake(15, 140, 80, 80);
    [self.clientImageView setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.clientImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(HandlePinGesture:)]];
    [self addSubview:self.clientImageView];
    
    [self.dissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).inset(60);
        make.left.equalTo(self).inset(20);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(20);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(30);
        make.right.equalTo(self).inset(30);
        make.bottom.equalTo(self).inset(50);
        make.height.mas_equalTo(165);
    }];
    
    
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(HandleDragGesture:)]];
    
    [self.clientImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DissMissView)]];
}

-(void)StartAnimation{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"cornerRadius";
    animation.fromValue = @(40);
    animation.toValue = @(0);
    animation.duration = 0.3f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion = YES;//动画结束了禁止删除
    animation.fillMode = kCAFillModeForwards;//停在动画结束处
    [self.clientImageView.layer addAnimation:animation forKey:@"cornerRadius"];
    [UIView animateWithDuration:0.5f animations:^{
        self.FirstcontinaerView.alpha = 1;
        self.clientImageView.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor blackColor];
        self.clientImageView.frame = CGRectMake(0, self.dissButton.bottom + 200, ScreenWidth, ScreenWidth);
    } completion:nil];
}


-(void)HandlePinGesture:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2f animations:^{
            self.FirstcontinaerView.alpha = 1;
            self.clientImageView.transform = CGAffineTransformMakeScale(1,1);
        }];
    }else{
        [UIView animateWithDuration:0.1f animations:^{
            self.FirstcontinaerView.alpha = 0;
            self.clientImageView.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
        }];
    }
}

-(void)HandleDragGesture:(UIPanGestureRecognizer *)gesture{
    CGPoint trans = [gesture translationInView:self];
    if(gesture.state == UIGestureRecognizerStateEnded){
        if(self.clientImageView.transform.ty > 40){
            [UIView animateWithDuration:0.2f animations:^{
                [self setAlpha:0];
                self.clientImageView.transform = CGAffineTransformMakeTranslation(0,ScreenHeight);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.2f animations:^{
                self.clientImageView.transform  = CGAffineTransformMakeTranslation(0,0);
                self.FirstcontinaerView.alpha = 1;
                self.alpha = 1;
            }];
        }
    }else{
        [UIView animateWithDuration:0.1f animations:^{
            self.clientImageView.transform = CGAffineTransformMakeTranslation(trans.x, trans.y);
            self.FirstcontinaerView.alpha = (20-trans.y)/20;
        }];
    }
    NSLog(@"%f %f",trans.x,trans.y);
}


-(void)DissMissView{
    [UIView animateWithDuration:0.2f animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomClientImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell SetData:@"更换头像" image:[UIImage imageNamed:@"ic90Pen1"]];
    }else if(indexPath.row == 1){
        [cell SetData:@"保存头像" image:[UIImage systemImageNamed:@"arrow.down.to.line"]];
    }else{
        [cell SetData:@"查看抖音码" image:[UIImage systemImageNamed:@"qrcode"]];
    }
    UIView *background = [[UIView alloc] init];
    background.frame = cell.frame;
    background.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:background];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        CustomImagePicker *picker = [[CustomImagePicker alloc] init];
        picker.type = PickerImageClientImage;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }else if(indexPath.row == 1){
        [CustomImagePicker SaveImageToPhotos:self.clientImageView.image];
    }
}


@end

