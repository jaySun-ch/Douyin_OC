//
//  CommentViewController.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/20.
//

#import "CustomCommentView.h"
#import "MainCommentTabCell.h"
#import "DefinGroup.pch"
#import <Masonry/Masonry.h>

#define Headerheight 70
#define FootHeight 15

@interface CustomCommentView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *NavigationBar;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) CommentData *comment;
@property (nonatomic,strong) UIView *buttonBar;
@property (nonatomic,strong) UITextField *commentField;
@property (nonatomic,strong) UIButton *AtButton;
@property (nonatomic,strong) UIButton *FaceButton;
@property (nonatomic,strong) UIButton *SendCommentButton;
@property (nonatomic,strong) UIView *continaler;
@property (nonatomic,strong) CommentModel *currentModel;
@property (nonatomic,assign) NSInteger currentsection;
@property (nonatomic,strong) UIPanGestureRecognizer *gesture;
@end



@implementation CustomCommentView

- (instancetype)initWithData:(CommentData *)data VideoData:(VideoPlayData *)videodata User:(NSString *)user{
    self = [super initWithFrame:CGRectMake(0,ScreenHeight / 2 - 150 ,ScreenWidth, ScreenHeight)];
    if(self){
        self.comment = data;
        self.currentsection = -1;
        self.VideoData = videodata;
        self.username = user;
        self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(DrageGesture:)];
        self.gesture.delegate = self;
        [self addGestureRecognizer:_gesture];
        _currentModel = [[CommentModel alloc]init];
        [self.comment.data.allKeys sortedArrayUsingComparator:^NSComparisonResult(CommentModel *obj1, CommentModel *obj2) {
            if(obj1.Like.count > obj2.Like.count){
                NSLog(@"compare1CreateDate %@",obj1.CreateDate);
                return NSOrderedAscending;
            }else if(obj1.Like.count < obj2.Like.count){
                NSLog(@"compare2 %@",obj1.Message);
                return NSOrderedDescending;
            }else{
                if([obj1.CreateDate laterDate:obj2.CreateDate]){
                    NSLog(@"compare3%@",obj1.Message);
                    return NSOrderedAscending;
                }else{
                    NSLog(@"compare4%@",obj1.Message);
                    return NSOrderedDescending;
                }
            }
        }];
        
        NSLog(@"%@ keys",self.comment.data.allKeys);
        [self SetUpView];
    }
    return self;
}


-(void)DrageGesture:(UIPanGestureRecognizer *)sender{
    CGPoint trans = [sender translationInView:self];
    
    if(sender.state == 2){
        if(trans.y > 0){
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, trans.y);
            } completion:nil];
        }
    }else if(sender.state == 3){
        if(trans.y > 200){
            [self dismissPresentView];
        }else{
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:nil];
        }
    }
    NSLog(@"%f drageGesture %ld",trans.y,sender.state);
}

- (void)SetUpView{
    NSLog(@"init2");
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth,ScreenHeight / 2 + 150 ) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableview.showsVerticalScrollIndicator = NO;
    _NavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    _NavigationBar.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    title.text = [NSString stringWithFormat:@"%ld条评论",self.comment.allcount];
    title.font = [UIFont systemFontOfSize:13.0];
    title.textColor  = [UIColor blackColor];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [closeButton setTintColor:[UIColor blackColor]];
    [closeButton addTarget:self action:@selector(dismissPresentView) forControlEvents:UIControlEventTouchUpInside];
    
    [_NavigationBar addSubview:title];
    [_NavigationBar addSubview:closeButton];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_NavigationBar.mas_left).inset(ScreenWidth / 2 - 25);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_NavigationBar.mas_right).inset(10);
        make.top.equalTo(_NavigationBar.mas_top).inset(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:_tableview];
    [self addSubview:_NavigationBar];
    [_tableview reloadData];
    
    NSLog(@"%ld commentdata",self.comment.allcount);
    
    if(self.comment.allcount == 0){
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 50, 80, 100, 30)];
        content.contentMode = UIViewContentModeCenter;
        content.text = @"还没有评论哦";
        content.font = [UIFont systemFontOfSize:13.0];
        content.textColor  = [UIColor blackColor];
        [self addSubview:content];
    }
    
    _buttonBar = [[UIView alloc] init];
    _buttonBar.layer.borderWidth = 1;
    _buttonBar.backgroundColor = [UIColor whiteColor];
    _buttonBar.layer.borderColor = [UIColor systemGray5Color].CGColor;
    _buttonBar.frame = CGRectMake(0,self.tableview.frame.size.height - 100, ScreenWidth, 100);
  
    _continaler = [UIView new];
    _continaler.backgroundColor = [UIColor systemGray5Color];
    _continaler.layer.cornerRadius = 10;
    _continaler.frame = CGRectMake(20,10, ScreenWidth - 40, 40);
    
    _commentField = [[UITextField alloc]init];
    _commentField.placeholder = @"善语结善缘,恶言伤人心";
    _commentField.delegate = self;
    _commentField.returnKeyType = UIReturnKeySend;
    _FaceButton = [[UIButton alloc] init];
    [_FaceButton setImage:[UIImage systemImageNamed:@"face.smiling"] forState:UIControlStateNormal];
    [_FaceButton setTintColor:[UIColor darkGrayColor]];
    
    _AtButton = [[UIButton alloc]init];
    [_AtButton setImage:[UIImage systemImageNamed:@"at"] forState:UIControlStateNormal];
    [_AtButton setTintColor:[UIColor darkGrayColor]];
    
    _SendCommentButton = [UIButton new];
    [_SendCommentButton setTitle:@"发送" forState:UIControlStateNormal];
    [_SendCommentButton setBackgroundColor:[UIColor redColor]];
    [_SendCommentButton addTarget:self action:@selector(SendMessage) forControlEvents:UIControlEventTouchUpInside];
    [_SendCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _SendCommentButton.layer.cornerRadius = 10;
    
    [_continaler addSubview:_AtButton];
    [_continaler addSubview:_commentField];
    [_continaler addSubview:_FaceButton];
    [_buttonBar addSubview:_continaler];
    [_buttonBar addSubview:_SendCommentButton];
    [self addSubview:_buttonBar];
    
    
    [_commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_continaler).inset(10);
        make.height.mas_equalTo(40);
    }];
    
    [_FaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_continaler).inset(10);
        make.centerY.equalTo(_continaler);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(40);
    }];
    
    [_AtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentField.mas_right);
        make.right.equalTo(_FaceButton.mas_left);
        make.centerY.equalTo(_continaler);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(40);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)KeyBoardWillShow:(NSNotification *)notification{
    CGFloat KeyboardHeight = [notification keyBoardHeight];
    _buttonBar.frame = CGRectMake(0,self.tableview.frame.size.height - 100 - KeyboardHeight, ScreenWidth, 100);
}

-(void)KeyBoardWillHidden:(NSNotification *)notification{
    self.commentField.placeholder = @"善语结善缘,恶言伤人心";
    _buttonBar.frame = CGRectMake(0,self.tableview.frame.size.height - 100, ScreenWidth, 100);
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    NSLog(@"textField.text %@",textField.text);
    if([textField.text isEqualToString:@""]){
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.continaler.frame = CGRectMake(20,10, ScreenWidth - 40, 40);
            self.SendCommentButton.frame = CGRectMake(ScreenWidth,10,0, 40);
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.continaler.frame = CGRectMake(20,10, ScreenWidth - 120, 40);
            self.SendCommentButton.frame = CGRectMake(ScreenWidth - 90,10, 80, 40);
        } completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self SendMessage];
    return YES;
}


-(void)SendMessage{
   
    if([self.commentField.text isEqualToString: @""]){
        [UIWindow showTips:@"请发表你的意见再评论哦"];
    }else{
        PostCommentRequest *request = [PostCommentRequest new];
        request.VideoId = _VideoData._id;
        request.CommentName = _username;
        if(self.currentModel == nil){
            request.WasCommentName = _VideoData.username;
        }else{
            request.WasCommentName = self.currentModel.CommentName;
        }
        
        request.Message = self.commentField.text;
        request.loaction = @"辽宁";
        if(self.currentsection != -1){
            request.IsMainComment = NO;
        }else{
            request.IsMainComment = YES;
        }
        
        if(!request.IsMainComment && _currentModel != nil){
            request.LeverUpCommentId = _currentModel._id;
        }else{
            request.LeverUpCommentId = @"";
        }
        
        [NetWorkHelper getWithUrlPath:PostComentPath request:request success:^(id data) {
          
            if(data == nil){
                [UIWindow showTips:@"评论失败"];
            }else{
                PostCommentResponse *response = [[PostCommentResponse alloc] initWithDictionary:data error:nil];
                if(response.msg.IsMainComment){
                    // 代表是二级评论 将二级评论添加到后面的
                    self.comment.data[response.msg] = [NSMutableArray array];
                    [self.tableview reloadData];
                }else{
                    //代表是一级评论
                    self.comment.data.allKeys[self.currentsection].LeverdownCommentCount += 1;
                    [self.comment.data[self.comment.data.allKeys[self.currentsection]] addObject:response.msg];
//                    NSLog(@"addObject %@ %ld",self.comment.data.allKeys[self.currentsection]);
                    [self.tableview reloadData];
                }
            }
          
            self.currentModel = nil;
            self.currentsection = -1;
        } faliure:^(NSError *error) {
            [UIWindow showTips:@"评论失败"];
            self.currentModel = nil;
            self.currentsection = -1;
        }];
    }
    self.commentField.text = @"";
    [self.commentField resignFirstResponder];
}

-(void)dismissPresentView{
    self.alpha = 1.0;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 400);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        for(UIView *view in UIApplication.sharedApplication.delegate.window.subviews){
            [view setUserInteractionEnabled:YES];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.comment.data.allKeys.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section < self.comment.data.allKeys.count){
        return self.comment.data[self.comment.data.allKeys[section]].count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < self.comment.data.allKeys.count){
        return 70;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < self.comment.data.allKeys.count){
        // 这是二级评论的cell
        MainCommentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(cell == nil){
            cell = [[MainCommentTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
//      if(indexPath.row < self.comment.data.allValues.count){
        
//      }
        __weak typeof(self) weakself = self;
        __weak typeof(cell) weakcell = cell;
        
        cell.likecomment = ^{
            LikeCommentRequest *request = [LikeCommentRequest new];
            request.CommentId = self.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row]._id;
            request.likeId = weakself.username;
            [NetWorkHelper getWithUrlPath:LikeCommentPath request:request success:^(id data) {
                NSLog(@"commlikeData %@",data);
                SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
                if([response.status  isEqualToString:@"faliure"]){
                    [UIWindow showTips:response.msg];
                }else{
                    [weakself.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row].Like addObject:request.likeId];
                    [weakcell.likeButton setTitle:[NSString stringWithFormat:@"%ld",weakself.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row].Like.count] forState:UIControlStateNormal];
                }
            } faliure:nil];
        };
        
        cell.deLikeComment = ^{
            LikeCommentRequest *request = [LikeCommentRequest new];
            request.CommentId = self.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row]._id;
            request.likeId = weakself.username;
            [NetWorkHelper getWithUrlPath:DisLikeCommentPath request:request success:^(id data) {
                NSLog(@"disLikecomment %@",data);
                SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
                if([response.status  isEqualToString:@"faliure"]){
                    [UIWindow showTips:response.msg];
                }else{
                    [weakself.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row].Like removeObject:request.likeId];
                    [weakcell.likeButton setTitle:[NSString stringWithFormat:@"%ld",weakself.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row].Like.count] forState:UIControlStateNormal];
//                    NSLog(@"%@ likeCommentList",weakself.comment.data.allKeys[section].Like);
                }
            } faliure:nil];
        };
        
        if([self.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row].Like containsObject:self.username]){
            [cell.likeButton setSelected:YES];
            [cell.likeButton setTintColor:[UIColor redColor]];
        }
        [cell initWithData:self.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row] LeverUpName:self.comment.data.allKeys[indexPath.section].CommentName];
        [cell SetMain:NO];
        return cell;
    }else{
        return [[UITableViewCell alloc] init];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.commentField becomeFirstResponder];
    self.currentsection = indexPath.section;
    NSLog(@"%ld currentsection",self.currentsection);
    self.currentModel = self.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row];
    self.commentField.placeholder = [NSString stringWithFormat:@"回复:%@",self.comment.data[self.comment.data.allKeys[indexPath.section]][indexPath.row].CommentName];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Headerheight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableview){
        if(scrollView.contentOffset.y <= Headerheight && scrollView.contentOffset.y>=0){
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, -FootHeight, 0);
        }else if(scrollView.contentOffset.y >= Headerheight &&  scrollView.contentOffset.y <= self.tableview.contentSize.height - self.tableview.frame.size.height - FootHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-Headerheight, 0, -FootHeight, 0);
        }else if(scrollView.contentOffset.y >= self.tableview.contentSize.height - self.tableview.frame.size.height - FootHeight && scrollView.contentOffset.y <= self.tableview.contentSize.height - self.tableview.frame.size.height){
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, -(self.tableview.contentSize.height - self.tableview.frame.size.height - FootHeight), 0);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section < self.comment.data.allKeys.count){
        CustomHeaderView *headerView = [[CustomHeaderView alloc] initWithData:self.comment.data.allKeys[section]];
        __weak typeof(self) weakself = self;
        __weak typeof(headerView) weakheaderView = headerView;
        
        headerView.likecomment = ^{
            LikeCommentRequest *request = [LikeCommentRequest new];
            request.CommentId = self.comment.data.allKeys[section]._id;
            request.likeId = weakself.username;
            [NetWorkHelper getWithUrlPath:LikeCommentPath request:request success:^(id data) {
                NSLog(@"commlikeData %@",data);
                SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
                if([response.status  isEqualToString:@"faliure"]){
                    [UIWindow showTips:response.msg];
                }else{
                    [weakself.comment.data.allKeys[section].Like addObject:request.likeId];
                    [weakheaderView.likeButton setTitle:[NSString stringWithFormat:@"%ld",weakself.comment.data.allKeys[section].Like.count] forState:UIControlStateNormal];
                    NSLog(@"%@ likeCommentList",weakself.comment.data.allKeys[section].Like);
                }
            } faliure:nil];
        };
        
        headerView.deLikeComment = ^{
            LikeCommentRequest *request = [LikeCommentRequest new];
            request.CommentId = self.comment.data.allKeys[section]._id;
            request.likeId = weakself.username;
            [NetWorkHelper getWithUrlPath:DisLikeCommentPath request:request success:^(id data) {
                NSLog(@"disLikecomment %@",data);
                SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
                if([response.status  isEqualToString:@"faliure"]){
                    [UIWindow showTips:response.msg];
                }else{
                    [weakself.comment.data.allKeys[section].Like removeObject:request.likeId];
                    [weakheaderView.likeButton setTitle:[NSString stringWithFormat:@"%ld",weakself.comment.data.allKeys[section].Like.count] forState:UIControlStateNormal];
                    NSLog(@"%@ likeCommentList",weakself.comment.data.allKeys[section].Like);
                }
            } faliure:nil];
        };
        
        if([self.comment.data.allKeys[section].Like containsObject:self.username]){
            [headerView.likeButton setSelected:YES];
            [headerView.likeButton setTintColor:[UIColor redColor]];
        }
        headerView.tag = section;
        [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showKeyboard:)]];
        return headerView;
    }else{
        return  nil;
    }
}


-(void)showKeyboard:(UITapGestureRecognizer *)sender{
    self.commentField.text = @"";
    self.currentsection = sender.view.tag;
    NSLog(@"%ld currentsection",self.currentsection);
    self.currentModel = self.comment.data.allKeys[sender.view.tag];
    self.commentField.placeholder = [NSString stringWithFormat:@"回复:%@",self.comment.data.allKeys[sender.view.tag].CommentName];
    [self.commentField becomeFirstResponder];
    NSLog(@"showKeyboard %ld",sender.view.tag);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section < self.comment.data.allKeys.count){
        if(self.comment.data.allKeys[section].LeverdownCommentCount != 0){
            NSLog(@"%ld section1",section);
            return FootHeight;
        }else{
            NSLog(@"%ld section2",section);
            return 0.01;
        }
    }else{
        return FootHeight;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section < self.comment.data.allKeys.count && self.comment.data.allKeys[section].LeverdownCommentCount != 0){ // 二级评论个数不为0
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        UIButton *label = [[UIButton alloc] init];
        UIView *lineview = [[UIView alloc]init];
        UIImageView *down = [[UIImageView alloc] init];
        
        lineview.backgroundColor = [UIColor lightGrayColor];
        
        
        if(self.comment.data[self.comment.data.allKeys[section]].count == 0){
            [label setTitle:[NSString stringWithFormat:@"展开%ld条评论",self.comment.data.allKeys[section].LeverdownCommentCount] forState:UIControlStateNormal];
        }else{
            [label setTitle:@"展开更多回复" forState:UIControlStateNormal];
        }
        
        label.tag = section;
        [label.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightBold]];
        [label setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [label addTarget:self action:@selector(showSecondComment:) forControlEvents:UIControlEventTouchUpInside];
        
        [down setImage:[UIImage systemImageNamed:@"chevron.down"]];
        [down setTintColor:[UIColor darkGrayColor]];
        
        if(self.comment.data[self.comment.data.allKeys[section]].count != self.comment.data.allKeys[section].LeverdownCommentCount){
            [footView addSubview:down];
            [footView addSubview:label];
        }
       
        [footView addSubview:lineview];
        
        
        
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footView.mas_top).inset(8);
            make.left.equalTo(footView.mas_left).inset(48);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(1);
        }];
        
        if(self.comment.data[self.comment.data.allKeys[section]].count != self.comment.data.allKeys[section].LeverdownCommentCount){
            [footView addSubview:down];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lineview.mas_right).inset(5);
                make.height.mas_equalTo(20);
            }];
            
            [down mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right);
                make.top.equalTo(footView.mas_top);
                make.height.mas_equalTo(18);
                make.width.mas_equalTo(12);
            }];
        }
        
        if(self.comment.data[self.comment.data.allKeys[section]].count != 0){
            UIButton *upbutton = [[UIButton alloc]init];
            upbutton.tag = section;
            [upbutton.titleLabel setFont:[UIFont systemFontOfSize:12.5 weight:UIFontWeightBold]];
            [upbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [upbutton setTitle:@"收起" forState:UIControlStateNormal];
            [upbutton addTarget:self action:@selector(HiddenSencondComment:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:upbutton];
            UIImageView *up = [[UIImageView alloc] init];
            [up setImage:[UIImage systemImageNamed:@"chevron.up"]];
            [up setTintColor:[UIColor darkGrayColor]];
            [footView addSubview:up];
            [footView addSubview:down];
            if(self.comment.data[self.comment.data.allKeys[section]].count != self.comment.data.allKeys[section].LeverdownCommentCount){
                [upbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(down.mas_right).inset(10);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(20);
                }];
                [up mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(upbutton.mas_right).inset(-5);
                    make.top.equalTo(footView.mas_top);
                    make.height.mas_equalTo(18);
                    make.width.mas_equalTo(12);
                }];
            }else{
                [upbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lineview.mas_right).inset(2);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(20);
                }];
                [up mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(upbutton.mas_right).inset(-5);
                    make.top.equalTo(footView.mas_top);
                    make.height.mas_equalTo(18);
                    make.width.mas_equalTo(12);
                }];
            }
        }
        
        return footView;
    }else{
        return  nil;
    }
}

-(void)HiddenSencondComment:(UIButton *)sender{
    NSLog(@"hiddensection %ld",(long)sender.tag);
    NSInteger allcount = self.comment.data[self.comment.data.allKeys[sender.tag]].count;
    NSMutableArray<NSIndexPath *> *reloadPath = [NSMutableArray array];
    for(NSInteger i = 0;i<allcount;i++){
        [reloadPath addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
        NSLog(@"NSMutableArray %ld %ld",i,sender.tag);
    };
    [self.comment.data[self.comment.data.allKeys[sender.tag]] removeAllObjects];
    [self.tableview beginUpdates];
    [self.tableview deleteRowsAtIndexPaths:reloadPath withRowAnimation:UITableViewRowAnimationFade];
    [self.tableview reloadData];
    [self.tableview endUpdates];
}



-(void)showSecondComment:(UIButton *)sender{
    NSLog(@"section %@",self.comment.data.allKeys[sender.tag]._id);
    if(self.comment.data[self.comment.data.allKeys[sender.tag]].count == 0){
        // 代表此时还没有展开二级评论 ,第一次展开二级评论
        [self GetSecondLeverComment:self.comment.data.allKeys[sender.tag]._id limit:3 StartLoaction:0 section:sender.tag];
    }else{
        // 第n此展开二级评论 从当前已经获取了的评论个数之后开始获取
        [self GetSecondLeverComment:self.comment.data.allKeys[sender.tag]._id limit:10 StartLoaction:self.comment.data[self.comment.data.allKeys[sender.tag]].count section:sender.tag];
    }
    
//    NSArray *newarry = @[@"1",@"2",@"3",@"4"];

}

-(void)GetSecondLeverComment:(NSString *)MainCommentId limit:(NSInteger)limit StartLoaction:(NSInteger)StartLoaction section:(NSInteger)section{
    // 先获取三个 //而后获取十个
    SecondCommentRequest *quest = [SecondCommentRequest new];
    quest.MainCommentId = MainCommentId;
    quest.limit = limit;
    quest.startLocation = StartLoaction;
    [NetWorkHelper getWithUrlPath:GetSecondListPath request:quest success:^(id data) {
        // 这个时候获取回来的是一个list
        CommentDResponse *response = [[CommentDResponse alloc] initWithDictionary:data error:nil];
        NSInteger oldcount = self.comment.data[self.comment.data.allKeys[section]].count;
        [self.comment.data[self.comment.data.allKeys[section]] addObjectsFromArray:response.data];
        NSLog(@"%@ sectionData",self.comment.data[self.comment.data.allKeys[section]]);
        NSInteger allcount = self.comment.data[self.comment.data.allKeys[section]].count;
        NSMutableArray<NSIndexPath *> *reloadPath = [NSMutableArray array];
        for(NSInteger i = oldcount;i<allcount;i++){
            [reloadPath addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        };
        [self.tableview beginUpdates];
        [self.tableview insertRowsAtIndexPaths:reloadPath withRowAnimation:UITableViewRowAnimationFade];
        [self.tableview reloadData];
        [self.tableview endUpdates];
    } faliure:^(NSError *error) {
        NSLog(@"error");
    }];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"willBeginEditingRowAtIndexPath %@",indexPath);
}
@end
