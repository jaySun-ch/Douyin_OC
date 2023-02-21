//
//  FriendController.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import "FriendController.h"
#import "DefinGroup.pch"
#import "NetWorkHelper.h"
#import "CommentRequest.h"
#import "CommentResponse.h"
#import <Masonry/Masonry.h>

#define NavigationBarHeight 80
@interface FriendController()
@property (nonatomic,strong) UIView *NavigationBar;
@property (nonatomic,strong) UIImageView *plusButton;
@property (nonatomic,strong) UIImageView *searchButton;
@property (nonatomic,strong) UIImageView *promotButton;
@end

@implementation FriendController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *showit  = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 40)];
    [showit setTitle:@"show" forState:UIControlStateNormal];
    [showit addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showit];
    [self initNaivationBar];
}


-(void)initNaivationBar{
    self.NavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
    self.NavigationBar.backgroundColor = [UIColor clearColor];
    self.plusButton = [[UIImageView alloc] init];
    self.searchButton = [[UIImageView alloc] init];
    self.promotButton = [[UIImageView alloc] init];
    [self.plusButton setTintColor:[UIColor whiteColor]];
    [self.searchButton setTintColor:[UIColor whiteColor]];
    [self.promotButton setTintColor:[UIColor whiteColor]];
    [self.plusButton setImage:[UIImage systemImageNamed:@"plus.circle"] ];
    [self.searchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"]];
    [self.promotButton setImage:[UIImage systemImageNamed:@"bolt.circle"]];
    
    [self.NavigationBar addSubview:self.plusButton];
    [self.NavigationBar addSubview:self.searchButton];
    [self.NavigationBar  addSubview:self.promotButton];
    [self.view addSubview:self.NavigationBar];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.NavigationBar).inset(15);
        make.top.equalTo(self.NavigationBar).inset(NavigationBarHeight / 2 + 5);
        make.height.width.mas_equalTo(25);
    }];
    
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NavigationBar).inset(15);
        make.top.equalTo(self.NavigationBar).inset(NavigationBarHeight / 2 + 5);
        make.height.width.mas_equalTo(25);
    }];
    
    [self.promotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.NavigationBar);
        make.top.equalTo(self.NavigationBar).inset(NavigationBarHeight / 2 + 5);
        make.height.width.mas_equalTo(25);
    }];
    
}


-(void)show{
    UINavigationController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
    UIViewController *newController = [UIViewController new];
    newController.view.backgroundColor = [UIColor redColor];
    [rootController pushViewController:newController animated:YES];
//    CommentRequest *quest = [CommentRequest new];
//    quest.VideoId = @"6376e8521d4953e93dfc681c";
//    [NetWorkHelper getWithUrlPath:MainCommentListPath request:quest success:^(id data) {
//        CommentDResponse *response = [[CommentDResponse alloc]initWithDictionary:data error:nil];
//        CommentData *maindata = [[CommentData alloc] init];
//        maindata.data = [[NSMutableDictionary alloc] init];
//        NSInteger allcount = response.data.count; // 主评论
//        for(NSInteger i = 0; i<response.data.count;i++){
//            NSLog(@"response.data %@",response.data[i].Message);
//            maindata.data[response.data[i]] = [NSMutableArray array];
//            allcount += response.data[i].LeverdownCommentCount; // 加上二级评论个数
//        }
//        maindata.allcount = allcount;
//        self.commentView = [[CommentViewController alloc] initWithData:maindata];
//        self.commentView.modalPresentationStyle = UIModalPresentationFormSheet;
//        self.commentView.view.frame = 
//        self.commentView.view.alpha = 0.0;
//        self.commentView.view.transform = CGAffineTransformMakeTranslation(0, 400);
//        [UIApplication.sharedApplication.delegate.window addSubview:self.commentView.view];
//        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.commentView.view.transform = CGAffineTransformMakeTranslation(0, 0);
//            self.commentView.view.alpha = 1.0;
//        } completion:nil];
//    } faliure:^(NSError *error) {
//        NSLog(@"error");
//    }];
}
@end
