//
//  TableViewCell.m
////  DouYin(OC)
////
////  Created by 孙志雄 on 2022/11/16.
////
//
//#import "CustomTableViewCell.h"
//#import "DefinGroup.pch"
//#import "MusicAlbumAnimationView.h"
//#import "MusicAnimationName.h"
//#import <Masonry/Masonry.h>
//
//#define iconsize 45
//
//#define iconSpace 35
//
//#define originx UIScreen.mainScreen.bounds.size.width - 65
//
//#define originHeight (UIScreen.mainScreen.bounds.size.height / 2) - 80
//
//static const NSInteger AvatarTag   = 0x01;
//static const NSInteger CommentTag = 0x02;
//static const NSInteger Sharetag = 0x04;
//static const NSInteger MusicAlbumTag   = 0x05;
//
//@interface CustomTableViewCell()<AVPlayerUpdateDelegate,UIGestureRecognizerDelegate>
//@property (nonatomic, strong) UILabel  *desc;
//@property (nonatomic, strong) UILabel  *nickName;
//@property (nonatomic,strong) UIImageView *avatar;
//
//@property (nonatomic,strong) MusicAlbumAnimationView *musicIcon;
//@property (nonatomic,strong) UIImageView *musicLogo;
//@property (nonatomic,strong) MusicAnimationName *musciName;
//@property (nonatomic,strong) CustomAddButton *addbutton;
//@property (nonatomic ,strong)CAGradientLayer   *gradientLayer;
//
//@property (nonatomic,strong) UIImageView *share;
//@property (nonatomic,strong) UILabel *shareNum;
//@property (nonatomic,strong) CustomFavoriteView *favoriate;
//@property (nonatomic,strong) UILabel *favoriateNum;
//@property (nonatomic,strong) UIImageView *comment;
//@property (nonatomic,strong) UILabel *commentNum;
//@property (nonatomic,strong) CustomStarView *star;
//@property (nonatomic,strong) UILabel *starNum;
//
//@property (nonatomic,strong) UIView *container;
//@property (nonatomic,strong) UIView *playerStatusBar;
//@property (nonatomic,strong) UIImageView *pauseIcon;
//@property (nonatomic,strong) UITapGestureRecognizer *singleTapGesture;
//@property (nonatomic,assign) NSTimeInterval lastTapTime;
//@property (nonatomic,assign) CGPoint lastTapPoint;
//
//@property (nonatomic,assign) CGFloat SafeAreaButtonHeight;
////@property (nonatomic,strong) CommentView *commentView;
//@property (nonatomic,strong) CommentData *maincommentdata;
//@end
//
//@implementation CustomTableViewCell
//
//
//- (void)initData:(VideoPlayData *)video isLastCell:(BOOL)isLastCell{
//    _videodata = [[VideoPlayData alloc] init];
//    _videodata = video;
//    [_desc setText:video.desc];
//    [_nickName setText:[NSString stringWithFormat:@"@%@",video.author]];
//    [_musciName setText:@"douyin 创作的原声"];
//    [_musicIcon startAnimation:10];
//    if(isLastCell){
//        _SafeAreaButtonHeight = 88;
//    }else{
//        _SafeAreaButtonHeight = 5;
//    }
//    [self GetCommentData];
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self){
//        NSLog(@"CellViewType %@",reuseIdentifier);
//        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_video_loading"]]];
//        [self setTintColor:[UIColor whiteColor]];
//        _lastTapTime = 0;
//        _lastTapPoint = CGPointZero;
//        _PlayerView = [[CustomAVPlayerView alloc] init:reuseIdentifier];
//        _PlayerView.delegate = self;
//        [self.contentView addSubview:_PlayerView];
//        [self initSubView];
//    }
//    return self;
//}
//
//-(void)GetCommentData{
//    CommentRequest *quest = [CommentRequest new];
//    quest.VideoId = self.videodata._id;
//    [NetWorkHelper getWithUrlPath:MainCommentListPath request:quest success:^(id data) {
//        CommentDResponse *response = [[CommentDResponse alloc]initWithDictionary:data error:nil];
//        self.maincommentdata = [[CommentData alloc] init];
//        self.maincommentdata.data = [[NSMutableDictionary alloc] init];
//        NSInteger allcount = response.data.count; // 主评论
//        for(NSInteger i = 0; i<response.data.count;i++){
//            NSLog(@"response.data %@",response.data[i].Message);
//            self.maincommentdata.data[response.data[i]] = [NSMutableArray array];
//            allcount += response.data[i].LeverdownCommentCount; // 加上二级评论个数
//        }
//        self.maincommentdata.allcount = allcount;
//        [self.commentNum setText:[NSString stringWithFormat:@"%ld",self.maincommentdata.allcount]];
//    } faliure:^(NSError *error) {
//        NSLog(@"error");
//    }];
//}
//
//
//-(void)showComment{
////    self.commentView = [[CommentView alloc] initWithData:_maincommentdata VideoData:self.videodata User:@"花海"];
////    self.commentView.alpha = 0.0;
////    self.commentView.transform = CGAffineTransformMakeTranslation(0, 400);
////    for(UIView *view in UIApplication.sharedApplication.delegate.window.subviews){
////        [view setUserInteractionEnabled:NO];
////    }
////    [UIApplication.sharedApplication.delegate.window addSubview:self.commentView];
////    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////        self.commentView.transform = CGAffineTransformMakeTranslation(0, 0);
////        self.commentView.alpha = 1.0;
////    } completion:nil];
//}
//
//
//-(void)initSubView{
//    _container = [UIView new];
//    [self.contentView addSubview:_container];
//    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetureHandeler:)];
//    [_container addGestureRecognizer:_singleTapGesture];
//    
//    
//    _gradientLayer = [CAGradientLayer layer];
//    _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.2].CGColor, (__bridge id)[UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.4].CGColor];
//    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
//    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
//    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
//    [_container.layer addSublayer:_gradientLayer];
//    
//    
//    _pauseIcon = [[UIImageView alloc]init];
//    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
//    _pauseIcon.contentMode = UIViewContentModeCenter;
//    _pauseIcon.layer.zPosition = 3;
//    _pauseIcon.hidden = YES;
//    [_container addSubview:_pauseIcon];
//    
//    _playerStatusBar = [[UIView alloc]init];
//    _playerStatusBar.backgroundColor = [UIColor whiteColor];
//    [_playerStatusBar setHidden:YES];
//    [_container addSubview:_playerStatusBar];
//    
//    _avatar = [[UIImageView alloc]init];
//    [_avatar setImage:[UIImage imageNamed:@"img_find_default"]];
//    _avatar.layer.cornerRadius = iconsize / 2;
//    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
//    _avatar.layer.borderWidth  = 1;
//    _avatar.tag = AvatarTag;
//    _avatar.userInteractionEnabled = YES;
//    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetureHandeler:)]];
//    [_avatar sizeToFit];
//    [_container addSubview:_avatar];
//    
//    _share = [[UIImageView alloc]init];
//    [_share setImage:[UIImage imageNamed:@"icon_home_share"]];
//    [_share sizeToFit];
//    _share.userInteractionEnabled = YES;
//    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetureHandeler:)]];
//    _share.tag = Sharetag;
//    [_container addSubview:_share];
//    
//    _shareNum = [[UILabel alloc]init];
//    [_shareNum setText:@"10"];
//    [_shareNum setTextColor:[UIColor whiteColor]];
//    [_shareNum setFont:SmallFont];
//    [_shareNum setTextAlignment:NSTextAlignmentCenter];
//    [_container addSubview:_shareNum];
//    
//    _comment = [[UIImageView alloc]init];
//    _comment.tag = CommentTag;
//    [_comment sizeToFit];
//    _comment.userInteractionEnabled = YES;
//    [_comment setImage:[UIImage imageNamed:@"icon_home_comment"]];
//    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetureHandeler:)]];
//    [_container addSubview:_comment];
//    
//    _commentNum = [[UILabel alloc]init];
//    [_commentNum setText:@"100"];
//    [_commentNum setTextColor:[UIColor whiteColor]];
//    [_commentNum setFont:SmallFont];
//    [_commentNum setTextAlignment:NSTextAlignmentCenter];
//    [_container addSubview:_commentNum];
//    
//    _favoriate = [[CustomFavoriteView alloc]init];
//    [_favoriate sizeToFit];
//    [_container addSubview:_favoriate];
//    
//    _favoriateNum = [[UILabel alloc]init];
//    [_favoriateNum setText:@"1.2w"];
//    [_favoriateNum setFont:SmallFont];
//    [_favoriateNum setTextColor:[UIColor whiteColor]];
//    [_favoriateNum setTextAlignment:NSTextAlignmentCenter];
//    [_container addSubview:_favoriateNum];
//    
//    _star = [[CustomStarView alloc]init];
//    [_container addSubview:_star];
//    
//    _starNum = [[UILabel alloc]init];
//    [_starNum setText:@"1.2w"];
//    [_starNum setTextColor:[UIColor whiteColor]];
//    [_starNum setFont:SmallFont];
//    [_starNum setTextAlignment:NSTextAlignmentCenter];
//    [_container addSubview:_starNum];
//    
//    _musicIcon = [MusicAlbumAnimationView new];
//    _musicIcon.userInteractionEnabled = YES;
//    [_musicIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetureHandeler:)]];
//    [_container addSubview:_musicIcon];
//    
//    _desc = [[UILabel alloc] init];
//    [_desc setText:@"最长的电影 cover by 周杰伦"];
//    [_desc setTextColor:[UIColor whiteColor]];
//    [_container addSubview:_desc];
//    
//    
//    _nickName = [[UILabel alloc] init];
//    [_nickName setText:@"@username"];
//    [_nickName setTextColor:[UIColor whiteColor]];
//    [_container addSubview:_nickName];
//    
//    _musciName = [[MusicAnimationName alloc]init];
//    _musciName.textColor = [UIColor whiteColor];
//    _musciName.font = MediumFont;
//    [_container addSubview:_musciName];
//    
//    _musicLogo = [[UIImageView alloc]init];
//    _musicLogo.contentMode = UIViewContentModeCenter;
//    _musicLogo.image = [UIImage imageNamed:@"icon_home_musicnote3"];
//    [_container addSubview:_musicLogo];
//    
//    _addbutton = [[CustomAddButton alloc] init];
//    [_container addSubview:_addbutton];
//}
//
//
//-(void)startLoadingPlayItemAnimation:(BOOL)isStart{
//    if(isStart){
//        _playerStatusBar.backgroundColor = [UIColor whiteColor];
//        [_playerStatusBar setHidden:NO];
//        [_playerStatusBar.layer removeAllAnimations];
//        
//        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
//        animationGroup.duration = 0.5;
//        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
//        animationGroup.repeatCount = MAXFLOAT;
//        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        
//        CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
//        scaleAnimation.keyPath = @"transform.scale.x";
//        scaleAnimation.fromValue = @(0.1f);
//        scaleAnimation.toValue = @(1.0f * UIScreen.mainScreen.bounds.size.width);
//        
//        CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
//        alphaAnimation.keyPath = @"opacity";
//        alphaAnimation.fromValue = @(1.0f);
//        alphaAnimation.toValue = @(0.5f);
//        [animationGroup setAnimations:@[scaleAnimation,alphaAnimation]];
//        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
//    }else{
//        [self.playerStatusBar.layer removeAllAnimations];
//        [self.playerStatusBar setHidden:YES];
//    }
//}
//
//- (void)prepareForReuse{
//    [super prepareForReuse];
//    [_PlayerView cancelLoading];
//    [_pauseIcon setHidden:YES];
//    [_favoriate resetView];
//    [_musicIcon resetView];
//}
//
//- (void)play{
//    [_PlayerView play];
//    [_pauseIcon setHidden:YES];
//}
//
//-(void)pause{
//    [_PlayerView pause];
//    [_pauseIcon setHidden:NO];
//}
//
//-(void)replay{
//    [_PlayerView replay];
//    [_pauseIcon setHidden:YES];
//}
//
//-(void)GetureHandeler:(UITapGestureRecognizer *)sender{
//    NSLog(@"%ld",(long)sender.view.tag);
//    switch (sender.view.tag){
//        case AvatarTag:{
//            self.OnAvaterFunction();
//        }
//        case CommentTag:{
//            [self showComment];
//        }
//        case Sharetag:{
//            NSLog(@"showShare");
//        }
//        case MusicAlbumTag:{
//            NSLog(@"MusicAlbumtag");
//        }
//        default:{
//            CGPoint point = [sender locationInView:_container];
//            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
//            if(time - _lastTapTime > 0.25f){
//                [self performSelector:@selector(signleTapAction) withObject:nil afterDelay:0.25f];
//            }else{
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(signleTapAction) object:nil];
//                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
//                if(!self.favoriate.isFavorite){
//                    [self.favoriate startLikeAnim:YES];
//                }
//                self.favoriate.isFavorite = YES;
//            }
//            _lastTapTime = time;
//            _lastTapPoint = point;
//            break;
//        }
//    }
//}
//
//
//- (void)startDownloadHighPriorityTask:(NSString *)url;{
//    [_PlayerView startDownLoadTask:[NSURL URLWithString:url] isBackground:NO];
//}
//
//- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
//    UIImageView *likeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
//    CGFloat k = ((oldPoint.y - newPoint.y) / (oldPoint.x - newPoint.x));
//    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f:-0.5f);
//    CGFloat angle = M_PI_4 * -k;
//    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
//    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
//    [_container addSubview:likeImageView];
//    [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
//    } completion:^(BOOL finished) {
//        // 结束之后再放大
//        [UIView animateWithDuration:0.5f
//                              delay:0.5f
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
//                             likeImageView.alpha = 0.0f;
//                         }
//                         completion:^(BOOL finished) {
//                             [likeImageView removeFromSuperview];
//                         }];
//    }];
//}
//
//
//-(void)signleTapAction{
//    [self showPauseViewAnimation:[_PlayerView rate]];
//    [_PlayerView updatePlayerState];
//}
//
//-(void)showPauseViewAnimation:(CGFloat)rate{
//    if(rate == 0){
//        [UIView animateWithDuration:0.25f animations:^{
//            self.pauseIcon.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            [self.pauseIcon setHidden:YES];
//        }];
//    }else{
//        [_pauseIcon setHidden:NO];
//        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f,1.8f);
//        _pauseIcon.alpha = 1.0f;
//        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        }completion:nil];
//    }
//}
//
//- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total{
//    
//}
//
//- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status{
//    NSLog(@"%@",_videodata.desc);
//    switch(status){
//        case AVPlayerItemStatusUnknown:
//            [self startLoadingPlayItemAnimation:YES];
//            NSLog(@"AVPlayerItemStatusUnknown");
//            break;
//        case AVPlayerItemStatusReadyToPlay:
//            [self startLoadingPlayItemAnimation:NO];
//            _isPlayerReady = YES;
//            if(_onPlayerReady){
//                _onPlayerReady();
//            }
//            NSLog(@"AVPlayerItemStatusReadyToPlay");
//            break;
//        case AVPlayerItemStatusFailed:
//            [self startLoadingPlayItemAnimation:NO];
//            [UIWindow showTips:@"加载失败"];
//            NSLog(@"AVPlayerItemStatusFailed");
//            break;
//        default:
//            NSLog(@"%ld AVPlayerItemStatus",(long)status);
//            break;
//    }
//}
//
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
//    [CATransaction commit];
//    
//    [_PlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    
//    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    
//    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.width.height.mas_equalTo(100);
//    }];
//    
//    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(self).inset(_SafeAreaButtonHeight);
//        make.width.mas_equalTo(1.0f);
//        make.height.mas_equalTo(0.8f);
//    }];
//    
// 
//    [_musicLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.bottom.equalTo(self).inset(_SafeAreaButtonHeight);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(25);
//    }];
//    
//    [_musciName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.musicLogo.mas_right);
//        make.centerY.equalTo(self.musicLogo);
//        make.width.mas_equalTo(ScreenWidth/2);
//        make.height.mas_equalTo(24);
//    }];
//    
//    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.musciName);
//        make.right.equalTo(self).inset(10);
//        make.width.height.mas_equalTo(50);
//    }];
//    
//    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.bottom.equalTo(self.musciName.mas_top).inset(8);
//        make.width.mas_lessThanOrEqualTo(ScreenWidth / 5 * 3);
//    }];
//    
//    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.bottom.equalTo(self.desc.mas_top).inset(5);
//        make.width.mas_lessThanOrEqualTo(ScreenWidth / 4 * 3 + 30);
//    }];
//    
//    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.musicIcon.mas_top).inset(40);
//        make.right.equalTo(self).inset(10);
//        make.width.mas_equalTo(iconsize);
//        make.height.mas_equalTo(iconsize-5);
//    }];
//    
//    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.share.mas_bottom);
//        make.centerX.equalTo(self.share);
//    }];
//    
//    
//    [_star mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.share.mas_top).inset(iconSpace);
//        make.right.equalTo(self).inset(10);
//        make.width.mas_equalTo(iconsize);
//        make.height.mas_equalTo(iconsize);
//    }];
//    
//    [_starNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.star.mas_bottom);
//        make.centerX.equalTo(self.star);
//    }];
//    
//    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.star.mas_top).inset(iconSpace);
//        make.right.equalTo(self).inset(10);
//        make.width.mas_equalTo(iconsize);
//        make.height.mas_equalTo(iconsize-5);
//    }];
//    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.comment.mas_bottom);
//        make.centerX.equalTo(self.comment);
//    }];
//    
//    [_favoriate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.comment.mas_top).inset(iconSpace);
//        make.right.equalTo(self).inset(10);
//        make.width.mas_equalTo(iconsize);
//        make.height.mas_equalTo(iconsize-5);
//    }];
//    
//    [_favoriateNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.favoriate.mas_bottom);
//        make.centerX.equalTo(self.favoriate);
//    }];
//
//    
//    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.favoriate.mas_top).inset(25);
//        make.right.equalTo(self).inset(10);
//        make.width.height.mas_equalTo(iconsize);
//    }];
//    
//    [_addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.avatar);
//        make.centerY.equalTo(self.avatar.mas_bottom);
//        make.width.height.mas_equalTo(24);
//    }];
//    
//    
//}
//
//
//
//-(void)startDownLoadBackgroundTask{
////    NSString *player = [NetWorkHelper isWifiStatus] ?
////    NSLog(@"videourl %@",_videodata.video_url);
//    [_PlayerView SetPlayerUrl:_videodata.video_url];
//    
//}
//- (void)startDownloadHighPriorityTask{
//    [_PlayerView startDownLoadTask:[NSURL URLWithString:_videodata.video_url] isBackground:NO];
//}
//@end
