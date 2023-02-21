//
//  MainVideoCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import "MainVideoCell.h"
#import "CustomFavoriteView.h"
#import "CustomStarView.h"
#import "CustomAddButton.h"
#import "PlayProgreeBar.h"
#import "MusicAlbumAnimationView.h"
#import "MusicAnimationName.h"
#import "VideoThumbnailView.h"
#import "CommentView.h"
#import "MainPlayerView.h"
#import "VideoAccountDetialView.h"


#define iconRightPadding ScreenWidth / 2 - 32
#define iconsize 35

#define iconSpace 15
//
//#define originx UIScreen.mainScreen.bounds.size.width - 65
//
//#define originHeight (UIScreen.mainScreen.bounds.size.height / 2) - 80

static const NSInteger AvatarTag   = 0x02;
static const NSInteger CommentTag = 0x03;
static const NSInteger Sharetag = 0x04;
static const NSInteger MusicAlbumTag   = 0x05;


@interface MainVideoCell()<PlayProgreeBarDelegate,MainPlayerViewDelegate>
@property (nonatomic,strong) MainPlayerView *PlayView;
@property (nonatomic,strong) UIView *container;
@property (nonatomic, strong) UITextView  *desc;
@property (nonatomic, strong) UILabel  *nickName;

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) CustomAddButton *addbutton;

@property (nonatomic,strong) MusicAlbumAnimationView *musicIcon;
@property (nonatomic,strong) UIImageView *musicLogo;
@property (nonatomic,strong) MusicAnimationName *musciName;


@property (nonatomic,strong) UIImageView *share;
@property (nonatomic,strong) UILabel *shareNum;
@property (nonatomic,strong) CustomFavoriteView *favoriate;
@property (nonatomic,strong) UILabel *favoriateNum;
@property (nonatomic,strong) UIImageView *comment;
@property (nonatomic,strong) UILabel *commentNum;
@property (nonatomic,strong) CustomStarView *star;
@property (nonatomic,strong) UILabel *starNum;

@property (nonatomic,strong) UIView *playerStatusBar;
@property (nonatomic,strong) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic,assign) NSTimeInterval lastTapTime;
@property (nonatomic,assign) CGPoint lastTapPoint;

@property (nonatomic,strong) PlayProgreeBar *playProgressBar;//只有在长视频中出现
@property (nonatomic,strong) VideoThumbnailView *videoThumb;

@property (nonatomic,assign) CGFloat totalTime;
@property (nonatomic,assign) BOOL isDraging;
@property (nonatomic,assign) BOOL isScaleMode;
@property (nonatomic,strong) VideoPlayData *videodata;

@end


@implementation MainVideoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        [self initSubViews];
    }
    return self;
}

- (void)SetVideoAssset:(VideoPlayData *)data{
    _videodata = data;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:data.desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3]; //行距的大小
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [attributedString setParagraphStyle:paragraphStyle];
    [attributedString setFont:[UIFont systemFontOfSize:15.0]];
    [_avatar setImageWithURL:[NSURL URLWithString:data.ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [_starNum setText:[NSString stringWithFormat:@"%ld",data.starcount]];
    [_favoriateNum setText:[NSString stringWithFormat:@"%ld",data.likecount]];
    [_commentNum setText:[NSString stringWithFormat:@"%ld",data.commentCount]];
    [_shareNum setText:[NSString stringWithFormat:@"%ld",data.sharecount]];
    [_desc setAttributedText:attributedString];
    [_desc setTextColor:[UIColor whiteColor]];
    [_nickName setText:[NSString stringWithFormat:@"@%@",data.username]];
    [_musciName setText:[NSString stringWithFormat:@"%@创作的原声",data.username]];
    NSLog(@"%@ SetVideoAssset",data.video_url);
    [self.PlayView SetPlayerUrl:data.video_url VideoRadio:data.videoRadio];
}


-(void)replay{
    [self.PlayView replay];
}

-(void)play{
    [self.PlayView play];
    [self.pauseIcon setHidden:YES];
}

-(void)pause{
    [self.PlayView pause];
}


- (void)startDownloadHighPriorityTask:(NSString *)url{
    [self.PlayView startDownLoadTask:[[NSURL alloc] initWithString:url] isBackground:NO];
}


- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status{
    if(status != AVPlayerItemStatusReadyToPlay){
        self.isPlayReady = NO;
        [self startLoadingPlayItemAnimation:YES];
    }else{
        self.isPlayReady = YES;
        [self startLoadingPlayItemAnimation:NO];
    }
}

-(NSString *)GetVideoTimeFormat:(CGFloat)time{
    int min = time / 60;
    CGFloat sec = time - min * 60;
    NSLog(@"%d %.2f GetVideoTimeFormat",min,sec);
    if(min == 0 && sec < 10){
        return [NSString stringWithFormat:@"00:0%.0f",sec];
    }else if(min == 0 && sec >= 10){
        return [NSString stringWithFormat:@"00:%.0f",sec];;
    }else if(min < 10 && sec < 10){
        return [NSString stringWithFormat:@"0%d:0%.0f",min,sec];
    }else if(min > 10 && sec < 10){
        return [NSString stringWithFormat:@"%d:%.0f",min,sec];
    }else{
        return [NSString stringWithFormat:@"0%d:%.0f",min,sec];
    }
}

- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total{
    self.totalTime = total;
    if(!self.isDraging){
        [self.playProgressBar ChangeWithProgress:current / total];
    }
    if(total > 30 || self.isScaleMode){
        [self.videoThumb.allTime setText:[self GetVideoTimeFormat:total]];
        [self.playProgressBar setHidden:NO];
    }else{
        [self.playProgressBar setHidden:YES];
    }
}

- (void)DidChangePlayBar:(CGFloat)progress{
    self.isDraging = YES;
    [self.videoThumb SetImageWithimage:[self.PlayView getVideoImageAtTime:CMTimeMake(self.totalTime * progress, 1.0f)]];
    [self.videoThumb.currentTime setText:[self GetVideoTimeFormat:progress * self.totalTime]];
}

- (void)EndDragToProgress:(CGFloat)progress{
    self.isDraging = NO;
    [self.PlayView SeekToProgress:progress];
}

-(void)SetContainerWithAlpha:(CGFloat)Alpha{
    self.container.alpha = Alpha;
    self.playProgressBar.alpha = Alpha;
}

-(void)initSubViews{
    [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(HandlePinchGesture:)]];
    
    _PlayView = [[MainPlayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenHeight - TabbarHeight)];
    _PlayView.delegate = self;
    [self addSubview:_PlayView];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetureHandeler:)];
    [self addGestureRecognizer:_singleTapGesture];
    
    _pauseIcon = [[UIImageView alloc]init];
    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = [UIColor whiteColor];
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    
    _avatar = [[UIImageView alloc]init];
    [_avatar setImage:[UIImage imageNamed:@"img_find_default"]];
    _avatar.layer.cornerRadius = 45 / 2;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.layer.borderWidth  = 1;
    _avatar.clipsToBounds = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.tag = AvatarTag;
    _avatar.userInteractionEnabled = YES;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetureHandeler:)]];
    [_avatar sizeToFit];
    [_container addSubview:_avatar];
    
    _share = [[UIImageView alloc]init];
    _share.contentMode = UIViewContentModeCenter;
    [_share setImage:[UIImage imageNamed:@"icon_home_share"]];
    _share.userInteractionEnabled = YES;
    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetureHandeler:)]];
    _share.tag = Sharetag;
    [_container addSubview:_share];
    
    _shareNum = [[UILabel alloc]init];
    [_shareNum setText:@"10"];
    [_shareNum setTextColor:[UIColor whiteColor]];
    [_shareNum setFont:SmallFont];
    [_shareNum setTextAlignment:NSTextAlignmentCenter];
    [_container addSubview:_shareNum];
    
    _comment = [[UIImageView alloc]init];
    _comment.tag = CommentTag;
    _comment.contentMode = UIViewContentModeCenter;
    _comment.userInteractionEnabled = YES;
    [_comment setImage:[UIImage imageNamed:@"icon_home_comment"]];
    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetureHandeler:)]];
    [_container addSubview:_comment];
    
    _commentNum = [[UILabel alloc]init];
    [_commentNum setText:@"100"];
    [_commentNum setTextColor:[UIColor whiteColor]];
    [_commentNum setFont:SmallFont];
    [_commentNum setTextAlignment:NSTextAlignmentCenter];
    [_container addSubview:_commentNum];
    
    _favoriate = [[CustomFavoriteView alloc]init];
    [_favoriate sizeToFit];
    [_container addSubview:_favoriate];
    
    _favoriateNum = [[UILabel alloc]init];
    [_favoriateNum setText:@"122"];
    [_favoriateNum setFont:SmallFont];
    [_favoriateNum setTextColor:[UIColor whiteColor]];
    [_favoriateNum setTextAlignment:NSTextAlignmentCenter];
    [_container addSubview:_favoriateNum];
    
    _star = [[CustomStarView alloc]init];
    [_container addSubview:_star];
    
    _starNum = [[UILabel alloc]init];
    [_starNum setText:@"122"];
    [_starNum setTextColor:[UIColor whiteColor]];
    [_starNum setFont:SmallFont];
    [_starNum setTextAlignment:NSTextAlignmentCenter];
    [_container addSubview:_starNum];
    
    _musicIcon = [MusicAlbumAnimationView new];
    _musicIcon.userInteractionEnabled = YES;
    [_musicIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetureHandeler:)]];
    [_container addSubview:_musicIcon];
    
    _desc = [[UITextView alloc] init];
    [_desc setBackgroundColor:[UIColor clearColor]];
    [_desc setScrollEnabled:NO];
    [_desc setEditable:NO];
//    @小新吉他教学
//
//    ～＃我落泪情绪零碎＃周杰伦 ＃吉他弹唱 #零基
//    础学吉他
    
    [_desc setTextColor:[UIColor whiteColor]];
    [_container addSubview:_desc];
    
    
    _nickName = [[UILabel alloc] init];
    [_nickName setFont:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]];

    [_nickName setTextColor:[UIColor whiteColor]];
    [_container addSubview:_nickName];
    
    _musciName = [[MusicAnimationName alloc]init];
    _musciName.textColor = [UIColor whiteColor];
    _musciName.font = MediumFont;

    [_container addSubview:_musciName];
    
    
    _musicLogo = [[UIImageView alloc]init];
    _musicLogo.contentMode = UIViewContentModeCenter;
    _musicLogo.image = [UIImage imageNamed:@"icon_home_musicnote3"];
    [_container addSubview:_musicLogo];
    

    _addbutton = [[CustomAddButton alloc] init];
    [_container addSubview:_addbutton];
    
    self.playProgressBar = [[PlayProgreeBar alloc] init];
    [self addSubview:self.playProgressBar];
    
    self.videoThumb = [[VideoThumbnailView alloc] init];
    self.videoThumb.alpha = 0;
    [self addSubview:self.videoThumb];
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(70);
    }];
    
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
    }];
    
    [self.videoThumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(200);
        make.bottom.equalTo(self).inset(30);
    }];
    
    
    [self.playProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).inset(1);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(3);
    }];
    
    self.playProgressBar.delegate = self;
    [self.playProgressBar setHidden:YES];
    [self SetRightIcon];
    [self SetLeftIcon];
    [self startLoadingPlayItemAnimation:YES];
}


-(void)ReSetVideo{
    if(self.PlayView.rate == 0){
        [self.pauseIcon setHidden:NO];
    }else{
        [self.pauseIcon setHidden:YES];
    }
    [self.container setHidden:NO];
    self.isScaleMode = NO;
    if(self.totalTime < 30){
        [self.playProgressBar setHidden:YES];
        [self.playProgressBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).inset(5);
        }];
    }
}

-(void)HandlePinchGesture:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateEnded){
        if(gesture.scale < 1){
            [self ReSetVideo];
        }else{
            [self.playProgressBar setHidden:NO];
            self.isScaleMode = YES;
        }
    }else{
        [self.container setHidden:YES];
    }
    if(self.delegate){
        [self.delegate ScaleWithVideo:gesture isplay:self.PlayView.rate == 0 ? NO:YES];
    }
    [UIView animateWithDuration:0.15f animations:^{
        if(gesture.state != UIGestureRecognizerStateEnded){
            self.PlayView.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
        }else{
            self.PlayView.transform = CGAffineTransformMakeScale(1,1);
        }
    }];
    NSLog(@"%f HandlePinchGesture",gesture.scale);
}

-(void)showComment{
//    CommentRequest *quest = [CommentRequest new];
//  quest.VideoId = @"6376e8521d4953e93dfc681c";
//  [NetWorkHelper getWithUrlPath:MainCommentListPath request:quest success:^(id data) {
//      CommentDResponse *response = [[CommentDResponse alloc]initWithDictionary:data error:nil];
//      CommentData *maindata = [[CommentData alloc] init];
//      maindata.data = [[NSMutableDictionary alloc] init];
//      NSInteger allcount = response.data.count; // 主评论
//      for(NSInteger i = 0; i<response.data.count;i++){
//          NSLog(@"response.data %@",response.data[i].Message);
//          maindata.data[response.data[i]] = [NSMutableArray array];
//          allcount += response.data[i].LeverdownCommentCount; // 加上二级评论个数
//      }
//      maindata.allcount = allcount;
//      CommentView *commentView = [[CommentView alloc] initWithData:maindata VideoData:nil User:@"花海"];
//      commentView.alpha = 0.0;
//      commentView.transform = CGAffineTransformMakeTranslation(0, 400);
//      for(UIView *view in UIApplication.sharedApplication.delegate.window.subviews){
//          [view setUserInteractionEnabled:NO];
//      }
//      [UIApplication.sharedApplication.delegate.window addSubview:commentView];
//      [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//          commentView.transform = CGAffineTransformMakeTranslation(0, 0);
//          commentView.alpha = 1.0;
//      } completion:nil];
//  } faliure:^(NSError *error) {
//      NSLog(@"error");
//  }];
    CommentView *view = [CommentView new];
    [self.viewController presentPanModal:view];
}

-(void)SetRightIcon{
    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconRightPadding);
        make.width.height.mas_equalTo(45);
        make.bottom.equalTo(self).inset(10);
    }];
    
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_musicIcon.mas_top).inset(iconSpace);
        make.centerX.mas_equalTo(iconRightPadding);
        make.height.mas_equalTo(15);
    }];
    
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_shareNum.mas_top).inset(2);
        make.centerX.mas_equalTo(iconRightPadding);
        make.width.height.mas_equalTo(iconsize);
    }];
    
    
    [_starNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_share.mas_top).inset(iconSpace);
        make.centerX.mas_equalTo(iconRightPadding);
        make.height.mas_equalTo(15);
    }];
    
    [_star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_starNum.mas_top).inset(2);
        make.centerX.mas_equalTo(iconRightPadding);
        make.width.height.mas_equalTo(iconsize);
    }];
    
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_star.mas_top).inset(iconSpace);
        make.centerX.mas_equalTo(iconRightPadding);
        make.height.mas_equalTo(15);
    }];
    
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentNum.mas_top).inset(2);
        make.centerX.mas_equalTo(iconRightPadding);
        make.width.height.mas_equalTo(iconsize);
    }];
    
    [_favoriateNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_comment.mas_top).inset(iconSpace);
        make.centerX.mas_equalTo(iconRightPadding);
        make.height.mas_equalTo(15);
    }];
    
    [_favoriate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_favoriateNum.mas_top).inset(2);
        make.centerX.mas_equalTo(iconRightPadding);
        make.width.height.mas_equalTo(iconsize);
    }];
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconRightPadding);
        make.bottom.equalTo(_favoriate.mas_top).inset(iconSpace+10);
        make.width.height.mas_equalTo(45);
    }];
    
    [_addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_avatar);
        make.bottom.equalTo(_favoriate.mas_top).inset(iconSpace);
        make.width.height.mas_equalTo(20);
    }];
    
    [_musicIcon startAnimation:20.0];
}

-(void)SetLeftIcon{
    [_musicLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).inset(8);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    [_musciName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicLogo.mas_right);
        make.centerY.equalTo(self.musicLogo);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(24);
    }];
    
    CGFloat height = [_desc.text heightForFont:[UIFont systemFontOfSize:18.0] width:ScreenWidth * 2 / 3];
    if(height < 25){
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(5);
            make.bottom.equalTo(self.musciName.mas_top).inset(5);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(ScreenWidth * 2 / 3);
        }];
    }else{
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(5);
            make.bottom.equalTo(self.musciName.mas_top);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(ScreenWidth * 2 / 3);
        }];
    }
   
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(10);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(_desc.mas_top).inset(5);
    }];
}



-(void)GetureHandeler:(UITapGestureRecognizer *)sender{
    NSLog(@"GetureHandeler %ld",(long)sender.view.tag);
    switch (sender.view.tag){
        case AvatarTag:{
            VideoAccountDetialView *cellDetial = [VideoAccountDetialView new];
            [cellDetial setUser_id:self.videodata.author_id];
            [UIWindow PushController:cellDetial];
            break;
        }
        case CommentTag:{
            [self showComment];
            break;
        }
        case Sharetag:{
            NSLog(@"showShare");
            break;
        }
        case MusicAlbumTag:{
            NSLog(@"MusicAlbumtag");
            break;
        }
        default:{
            CGPoint point = [sender locationInView:_container];
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            if(time - _lastTapTime > 0.25f){
                [self performSelector:@selector(signleTapAction) withObject:nil afterDelay:0.25f];
            }else{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(signleTapAction) object:nil];
                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
                if(!self.favoriate.isFavorite){
                    [self.favoriate startLikeAnim:YES];
                }
                self.favoriate.isFavorite = YES;
            }
            _lastTapTime = time;
            _lastTapPoint = point;
            break;
        }
    }
}

-(void)signleTapAction{
    [self showPauseViewAnimation:self.PlayView.rate];
}

- (void)DidDragOnPlayBar:(UIGestureRecognizerState)state{
    if(state != UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2f animations:^{
            self.container.alpha = 0;
            self.videoThumb.alpha = 1;
            [self.playProgressBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(5);
                make.bottom.equalTo(self).inset(2);
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2f animations:^{
            self.container.alpha = 1;
            self.videoThumb.alpha = 0;
            [self.playProgressBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(3);
                make.bottom.equalTo(self).inset(1);
            }];
        }];
    }
}



-(void)startLoadingPlayItemAnimation:(BOOL)isStart{
    if(isStart){
        NSLog(@"startLoadingPlayItemAnimation");
        self.playerStatusBar.backgroundColor = [UIColor whiteColor];
        [self.playerStatusBar setHidden:NO];
        [self.playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.45;
        animationGroup.beginTime = CACurrentMediaTime();
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CABasicAnimation *scaleAnimationx = [CABasicAnimation animation];
        scaleAnimationx.keyPath = @"transform.scale.x";
        scaleAnimationx.fromValue = @(0.1f);
        scaleAnimationx.toValue = @(0.9f);
        
        CABasicAnimation *scaleAnimationy = [CABasicAnimation animation];
        scaleAnimationy.keyPath = @"transform.scale.y";
        scaleAnimationy.fromValue = @(1.0f);
        scaleAnimationy.toValue = @(0.2f);
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.2f);
        [animationGroup setAnimations:@[scaleAnimationx,scaleAnimationy,alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    }else{
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
        [self.playProgressBar setHidden:NO];
    }
}


-(void)showPauseViewAnimation:(CGFloat)rate{
    if(rate == 0){
        [self.playProgressBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.bottom.equalTo(self).inset(1);
        }];
        [_PlayView play];
        if(_delegate){
            [_delegate UpdateCurrentPlayerPlayState:YES];
        }
        [UIView animateWithDuration:0.25f animations:^{
            self.pauseIcon.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.pauseIcon setHidden:YES];
        }];
    }else{
        [self.playProgressBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(5);
            make.bottom.equalTo(self).inset(2);
        }];
        if(_delegate){
            [_delegate UpdateCurrentPlayerPlayState:NO];
        }
        [_pauseIcon setHidden:NO];
        [_PlayView pause];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f,1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }completion:nil];
    }
    [self.playProgressBar FocusOnPlaybar];
}

- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
    CGFloat k = ((oldPoint.y - newPoint.y) / (oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f:-0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [_container addSubview:likeImageView];
    [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
    } completion:^(BOOL finished) {
        // 结束之后再放大
        [UIView animateWithDuration:0.5f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                             likeImageView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [likeImageView removeFromSuperview];
                         }];
    }];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.star resetView];
    [self.favoriate resetView];
    [self.addbutton resetView];
    [self SetVideoAssset:self.videodata];
    [self.playProgressBar resetView];
}


@end
