//
//  CustomBackGroundView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import "CustomBackGroundCropView.h"

#define MaskHeight ScreenWidth/2

@interface CustomBackGroundCropView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) UIButton *CancelButton;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIButton *ReFreshButton;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) CAShapeLayer *fillLayer;
@property (nonatomic,strong) UIImage *originImage;

@end


@implementation CustomBackGroundCropView

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if(self){
        self.originImage = image;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"darkgray"];
    [self initScrollView];
    [self initTopBar];
}


-(void)initTopBar{
    self.TopBar = [[UIView alloc] init];
    self.TopBar.backgroundColor = [UIColor colorNamed:@"darkgray"];
    [self.view addSubview:self.TopBar];
    
    self.CancelButton = [[UIButton alloc] init];
    [self.CancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.CancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.CancelButton addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.CancelButton];
    
    self.MakeSureButton = [[UIButton alloc] init];
    [self.MakeSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.MakeSureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(SaveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.MakeSureButton];
    
    self.ReFreshButton = [[UIButton alloc] init];
    [self.ReFreshButton setImage:[UIImage systemImageNamed:@"arrow.clockwise"] forState:UIControlStateNormal];
    [self.ReFreshButton setTintColor:[UIColor lightGrayColor]];
    [self.ReFreshButton addTarget:self action:@selector(ReSetImage) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:self.ReFreshButton];
    
    [self.TopBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(100);
        
    }];
    
    [self.CancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopBar).inset(60);
        make.left.equalTo(self.TopBar).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.ReFreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopBar).inset(60);
        make.centerX.equalTo(self.TopBar);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopBar).inset(60);
        make.right.equalTo(self.TopBar).inset(20);
        make.height.mas_equalTo(20);
    }];
}

-(void)ReSetImage{
    [self.scrollview setZoomScale:1.0];
    [self.imageView setCenterX:(self.imageView.frame.size.width + 30) / 2 + 20];
}

-(void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initScrollView{
    self.scrollview = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.scrollview setZoomScale:1.0];
    [self.scrollview setMinimumZoomScale:1.0];
    [self.scrollview setMaximumZoomScale:5.0];
    self.scrollview.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
    self.scrollview.alwaysBounceVertical = YES;
    self.scrollview.alwaysBounceHorizontal = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    [self.scrollview setScrollEnabled:YES];
    self.scrollview.delegate = self;
    [self.view addSubview:self.scrollview];
    [self SetImage];
}

-(void)SetImage{
    self.imageView = [[UIImageView alloc]init];
    [self.imageView setImage:self.originImage];
    if( ScreenWidth * self.originImage.size.height / self.originImage.size.width < ScreenHeight){
        [self.imageView setFrame:CGRectMake(0, 0,ScreenWidth, ScreenWidth * self.originImage.size.height / self.originImage.size.width )];
    }else{
        [self.imageView setFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight)];
    }
    
    // 如果设置原比例之后照片高度小于了裁剪高度 那么要将宽度设为对照
    if(self.imageView.image.size.height < MaskHeight){
        [self.imageView setFrame:CGRectMake(0, 0, MaskHeight * self.originImage.size.width / self.originImage.size.height, MaskHeight)];
    }
    
    [self.scrollview addSubview:self.imageView];
    [self.scrollview setContentSize:CGSizeMake(ScreenWidth, MaskHeight)];

    
    if(self.scrollview.contentSize.width < self.imageView.size.width){
        NSLog(@"1 %f %f",self.scrollview.contentSize.width,self.imageView.size.width);
        [self.scrollview setContentSize:CGSizeMake(self.imageView.frame.size.width, MaskHeight)];
        [self.scrollview setContentInset:UIEdgeInsetsMake(MaskHeight / 4,(self.imageView.size.width - ScreenWidth) / 2 , MaskHeight / 4, (self.imageView.frame.size.width - ScreenWidth) / 2)];
    }
    
    if(self.scrollview.contentSize.height < self.imageView.size.height){
        if(self.imageView.size.height < ScreenHeight){
            
            [self.scrollview setContentSize:CGSizeMake(ScreenWidth, self.imageView.size.height)];
            if((self.imageView.size.height - MaskHeight * 3 / 2) > 0){
                [self.scrollview setContentInset:UIEdgeInsetsMake((self.imageView.size.height - MaskHeight) / 2,0,(self.imageView.size.height - MaskHeight * 3 / 2),0)];
            }else{
                [self.scrollview setContentInset:UIEdgeInsetsMake((self.imageView.size.height - MaskHeight) / 2,0,(self.imageView.size.height - MaskHeight) / 2,0)];
            }
            
           
        }else{
            NSLog(@"3 %f %f",self.scrollview.contentSize.height,self.imageView.size.height);
            [self.scrollview setContentSize:CGSizeMake(ScreenWidth,ScreenHeight)];
            [self.scrollview setContentInset:UIEdgeInsetsMake((ScreenHeight - MaskHeight) / 2,0,(ScreenHeight - MaskHeight) / 2,0)];
        }
    }
    
    NSLog(@"end %f %f",self.scrollview.contentInset.top,self.scrollview.contentInset.bottom);
        
    self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
     
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.maskView setUserInteractionEnabled:NO];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.frame cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, ScreenHeight / 2 - MaskHeight / 2, ScreenWidth, MaskHeight) cornerRadius:0];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    self.fillLayer = [CAShapeLayer layer];
    self.fillLayer.path = path.CGPath;
    self.fillLayer.fillRule = kCAFillRuleEvenOdd;
    self.fillLayer.fillColor = [UIColor colorNamed:@"darkgray"].CGColor;
    self.fillLayer.opacity = 1;
    [self.maskView.layer addSublayer:self.fillLayer];
    [self.view addSubview:self.maskView];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.fillLayer.opacity != 1){
        [self.fillLayer removeFromSuperlayer];
        self.fillLayer.opacity = 1;
        [self.maskView.layer addSublayer:self.fillLayer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.fillLayer.opacity != 0.5){
        [self.fillLayer removeFromSuperlayer];
        self.fillLayer.opacity = 0.5;
        [self.maskView.layer addSublayer:self.fillLayer];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIImage *)getSubImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenWidth,MaskHeight), NO, 0.0);
    CGRect myImageRect = CGRectMake(0,ScreenHeight / 2 - MaskHeight / 2,ScreenWidth, MaskHeight);
    CGImageRef imageRef = self.imageView.image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(CGSizeMake(ScreenWidth,MaskHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* img = [UIImage imageWithCGImage:subImageRef];
    img = [self imageWithImage:img scaledToSize:CGSizeMake(ScreenWidth,MaskHeight)];
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//-(UIImage *)getCutImage{
//    //算出截图位置相对图片的坐标
//    CGRect rect = [self.view convertRect:_cutFrame toView:_showImageView];
//    CGFloat scale = _originalImage.size.width / _showImageView.frame.size.width *
//    _showImageView.transform.a;
//    CGRect myImageRect= CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
//    
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(_originalImage.CGImage, myImageRect);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    
//    //释放资源
//    CGImageRelease(subImageRef);
//    
//    return smallImage;
//}


-(void)SaveImage{
    [UIWindow ShowLoadNoAutoDismiss];
    [self dismissViewToRootController:YES completion:^{
        [self SaveImageToServer];
    }];
}

-(void)SaveImageToServer{
    NSData *file = UIImagePNGRepresentation(self.originImage);
    [NetWorkHelper uploadWithUrlPath:[NSString stringWithFormat:@"%@?PhoneNumber=%@&ChangeMessageName=BackGroundImageUrl",UpdateClientImagePath,[AppUserData GetCurrenUser].phoneNumber] data:file request:nil progress:^(CGFloat percent) {
        NSLog(@"%f",percent);
    } success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        if([response.status isEqualToString:@"failure"]){
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"上传失败"];
            }];
        }else{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"上传成功"];
                ClientData *data =  [AppUserData GetCurrenUser];
                data.BackGroundImageUrl = response.msg;
                [AppUserData SavCurrentUser:data];
            }];
        }
    } failure:^(NSError *error) {
        [UIWindow DissMissLoadWithBlock:^{
            [UIWindow showTips:@"服务器走神了哦"];
        }];
    }];
}

@end
