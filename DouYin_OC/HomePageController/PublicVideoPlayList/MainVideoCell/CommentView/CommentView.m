//
//  CommentView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/20.
//

#import "CommentView.h"
#import "CommentBottomBar.h"
#import "MainCommentCell.h"
#import "SecondCommentCell.h"
#import "LoadMoreCell.h"


@interface CommentView()<HWPanModalPresentable,UITableViewDelegate,UITableViewDataSource,LoadMoreCellDelegate>
@property (nonatomic,strong) UILabel *currenttitle;
@property (nonatomic,strong) UIButton *xmarkButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CommentBottomBar *bottombar;
@property (nonatomic,strong) UIView *KeyBoardBackground;
@property (nonatomic,assign) CGFloat KeyboardHeight;
@property (nonatomic,strong) NSArray *maincomment;
@property (nonatomic,strong) NSMutableArray *secondcomment;
@end

@implementation CommentView


- (void)viewDidLoad{
    [super viewDidLoad];
    self.maincomment = @[
        @"我灵魂失控，静静悄悄离开",
        @"发现B页面的测滑手势也被禁用了，即无法侧滑到A页面。这是因为侧滑手势的属性设置时全局性的，都是导航控制器的同一个设置",
        @"但是，如果有多个页面都需要禁用测滑手势，其他都是开启",
        @"爱情来的太快就像龙卷风",
        @"我只能永远读着对白读着你对我的伤害",
        @"明明爱很清晰 却只能接受分离",
        @"看不到的永远只能输",
        @"只能说我输了 也许是你怕了 我们的回忆没有皱褶 你却用离开烫下句点"
    ];
    self.secondcomment = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboadrWillshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboadrWillDissMiss:) name:UIKeyboardWillHideNotification object:nil];
    [self initTableView];
    [self initTopBarAndBotomBar];
}


- (UIScrollView *)panScrollable{
    return self.tableView;
}

- (BOOL)isAutoHandleKeyboardEnabled{
    return NO;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView == self.tableView){
//        if(scrollView.contentOffset.y>=0){
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, -20, 0);
//        }else if(scrollView.contentOffset.y <= self.tableView.contentSize.height - self.tableView.frame.size.height - 20){
//            scrollView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
//        }else if(scrollView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height - 20 && scrollView.contentOffset.y <= self.tableView.contentSize.height - self.tableView.frame.size.height){
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, -(self.tableView.contentSize.height - self.tableView.frame.size.height - 20), 0);
//        }
//    }
//}


-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,40,self.view.width,( ScreenHeight * 2 / 3) - 60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[MainCommentCell class] forCellReuseIdentifier:@"MainComment"];
    [self.tableView registerClass:[SecondCommentCell class] forCellReuseIdentifier:@"SecondComment"];
    [self.tableView registerClass:[LoadMoreCell class] forCellReuseIdentifier:@"LoadMore"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.maincomment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2){
        return self.secondcomment.count+2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == self.secondcomment.count + 1){
        return 40;
    }
    if(indexPath.row == 0){
        CGFloat height = [self.maincomment[indexPath.section] heightForFont:[UIFont systemFontOfSize:15.0] width:ScreenWidth - 80];
        return (height + 55);
    }
    
    return 75;
   

}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [UIView new];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        // 首行
        MainCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainComment" forIndexPath:indexPath];
        [cell SetContentWith:self.maincomment[indexPath.section]];
        return cell;
    }else{
        if(indexPath.row == self.secondcomment.count + 1 && indexPath.section == 2){
            LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }else{
            SecondCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondComment" forIndexPath:indexPath];
            [cell SetContentWith:@"我会发着呆"];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)LoadMoreComment{
    [self.secondcomment addObject:@"我会发着呆"];
    [self.secondcomment addObject:@"我会发着呆"];
}

-(void)KeyboadrWillshow:(NSNotification *)center{
    CGFloat KeyboardHeight = [center keyBoardHeight];
    self.KeyboardHeight = KeyboardHeight;
    self.bottombar.frame =  CGRectMake(0,ScreenHeight * 2 / 3 - 93 - KeyboardHeight, ScreenWidth,130);
    [self.bottombar KeyboardShowLayout];
}


-(void)KeyboadrWillDissMiss:(NSNotificationCenter *)center{
    if([self.bottombar.textview.text isEqualToString:@""]){
        self.bottombar.frame = CGRectMake(0,(ScreenHeight * 2 / 3) - 53, ScreenWidth,90);
        [self.bottombar KeyBoardDissmisslayout];
    }else{
        self.bottombar.frame = CGRectMake(0,ScreenHeight * 2 / 3 - 93, ScreenWidth,130);
    }
}


-(void)initTopBarAndBotomBar{
    _currenttitle = [UILabel new];
    [_currenttitle setTextAlignment:NSTextAlignmentCenter];
    [self.currenttitle setText:@"170条评论"];
    [self.currenttitle setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    [self.view addSubview:self.currenttitle];
    
     _xmarkButton = [UIButton new];
    _xmarkButton.contentMode = UIViewContentModeScaleAspectFit;
    _xmarkButton.tintColor = [UIColor blackColor];
    [_xmarkButton addTarget:self action:@selector(DismissView) forControlEvents:UIControlEventTouchUpInside];
    [_xmarkButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [self.view addSubview:_xmarkButton];
    
    [_currenttitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).inset(10);
        make.height.mas_equalTo(20);
    }];
    
    [_xmarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_currenttitle);
        make.right.equalTo(self.view).inset(20);
        make.height.width.mas_equalTo(12);
    }];
    
    self.bottombar = [CommentBottomBar new];
    self.bottombar.frame = CGRectMake(0,(ScreenHeight * 2 / 3) - 53, ScreenWidth,90);
    [self.view addSubview:self.bottombar];
}



-(void)DismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (HWBackgroundConfig *)backgroundConfig{
    HWBackgroundConfig *config = [[HWBackgroundConfig alloc] init];
    config.backgroundAlpha = 0;
    return config;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, ScreenHeight * 2 / 3);
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if(section == 2){
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 50)];
//        UIView *lineview = [UIView new];
//        lineview.backgroundColor = lightgraycolor;
//        [view addSubview:lineview];
//        UIButton *label = [UIButton new];
//        label.tag = 8;
//        [label.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
//        [label setTitle:@"展开更多回复" forState:UIControlStateNormal];
//        [label setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [label addTarget:self action:@selector(LoadMoreSecondComment:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:label];
//        UIImageView *go = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron-downxiala"]];
//        go.tag = 9;
//        go.contentMode = UIViewContentModeScaleAspectFit;
//        [view addSubview:go];
//
//        CustomLoadView *load = [CustomLoadView new];
//        load.tag = 10;
//        load.center = view.center;
//        [load setHidden:YES];
//        [view addSubview:load];
//
//        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view);
//            make.left.equalTo(view).inset(65);
//            make.width.mas_equalTo(20);
//            make.height.mas_equalTo(1);
//        }];
//
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view);
//            make.left.equalTo(lineview.mas_right).inset(8);
//            make.height.mas_equalTo(20);
//        }];
//
//        [go mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view);
//            make.left.equalTo(label.mas_right);
//            make.width.height.mas_equalTo(18);
//        }];
//
//        return view;
//    }
//    return nil;
//}

//-(void)LoadMoreSecondComment:(UIButton *)sender{
//    UIView *superview = sender.superview;
//    CustomLoadView *load = (CustomLoadView*)[superview viewWithTag:10];
//    [load setHidden:NO];
//    UIButton *label = [superview viewWithTag:8];
//    [label setHidden:YES];
//    UIImageView *image = [superview viewWithTag:9];
//    [image setHidden:YES];
//    [self.secondcomment addObject:@"我灵魂失控，静静悄悄离开"];
//    [self.secondcomment addObject:@"我灵魂失控，静静悄悄离开"];
//    [self.secondcomment addObject:@"我灵魂失控，静静悄悄离开"];
//    [self.secondcomment addObject:@"我灵魂失控，静静悄悄离开"];
//    [self.secondcomment addObject:@"我灵魂失控，静静悄悄离开"];
//    [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
//}

//-(void)ReSetFooter{
//    UIView *superview = [self.tableView footerViewForSection:2];
//    CustomLoadView *load = (CustomLoadView*)[superview viewWithTag:10];
//    [load setHidden:YES];
//    UIButton *label = [superview viewWithTag:8];
//    [label setHidden:NO];
//    UIImageView *image = [superview viewWithTag:9];
//    [image setHidden:NO];
//}

@end


