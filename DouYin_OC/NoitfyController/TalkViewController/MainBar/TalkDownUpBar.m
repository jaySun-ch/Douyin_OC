//
//  TalkDownUpBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//

#import "TalkDownUpBar.h"
#import "CustomBottomBarButton.h"

@interface TalkDownUpBar()
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) CustomBottomBarButton *helloButton;
@property (nonatomic,strong) CustomBottomBarButton *loveheartButton;
@property (nonatomic,strong) CustomBottomBarButton *PictureButton;
@property (nonatomic,strong) CustomBottomBarButton *Look_togeture;
@property (nonatomic,strong) CustomBottomBarButton *Video_talk;
@property (nonatomic,strong) CustomBottomBarButton *question;
@property (nonatomic,strong) NSArray *textarray;
@end


@implementation TalkDownUpBar


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.textarray = @[@"打招呼",@"比个心",@"以图换图",@"一起看",@"视频通话",@"在干嘛"];
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        self.scrollview.alwaysBounceHorizontal = YES;
        self.scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollview];
        
        self.helloButton = [[CustomBottomBarButton alloc] init];
        self.helloButton.tag = 1;
        self.helloButton.layer.cornerRadius =  10;
        [self.helloButton SetWithTitle:self.textarray[0] image:[UIImage imageNamed:@"say_hello"]];
        [self.scrollview addSubview:self.helloButton];
        
        self.loveheartButton = [[CustomBottomBarButton alloc] init];
        self.loveheartButton.tag = 2;
        self.loveheartButton.layer.cornerRadius = 10;
        [self.loveheartButton SetWithTitle:self.textarray[1] image:[UIImage imageNamed:@"Love_heart"]];
        [self.scrollview addSubview:self.loveheartButton];
        
        self.PictureButton = [[CustomBottomBarButton alloc] init];
        self.PictureButton.tag = 3;
        self.PictureButton.layer.cornerRadius = 10;
        [self.PictureButton SetWithTitle:self.textarray[2] image:[UIImage imageNamed:@"Picture_Pict"]];
        [self.scrollview addSubview:self.PictureButton];
        
        self.Look_togeture = [[CustomBottomBarButton alloc] init];
        self.Look_togeture.tag = 4;
        self.Look_togeture.layer.cornerRadius = 10;
        [self.Look_togeture SetWithTitle:self.textarray[3] image:[UIImage imageNamed:@"Look_together"]];
        [self.scrollview addSubview:self.Look_togeture];
        
        self.Video_talk = [[CustomBottomBarButton alloc] init];
        self.Video_talk.tag = 5;
        self.Video_talk.layer.cornerRadius =  10;
        [self.Video_talk SetWithTitle:self.textarray[4] image:[UIImage imageNamed:@"Video"]];
        [self.scrollview addSubview:self.Video_talk];
        
        
        self.question = [[CustomBottomBarButton alloc] init];
        self.question.tag = 6;
        self.question.layer.cornerRadius = 10;
        [self.question SetWithTitle:self.textarray[5] image:[UIImage imageNamed:@"question"]];
        [self.scrollview addSubview:self.question];
        
     
        
        CGFloat orginx = 10;
        for(NSInteger i = 1;i < 7 ; i++){
            NSLog(@"%ld NSInteger",i);
            CustomBottomBarButton *view = [self viewWithTag:i];
            CGSize size = [self.textarray[i-1] singleLineSizeWithText:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
            // 15 是 图像的宽度  25是左右两侧留下的距离
            view.frame = CGRectMake(orginx,(self.frame.size.height - 30)/2, size.width + 18 + 25,35);
            orginx += (size.width + 18 + 25 + 5);
        }
        
        self.scrollview.contentSize = CGSizeMake(orginx + 20,self.frame.size.height);
    }
    return self;
}
@end
