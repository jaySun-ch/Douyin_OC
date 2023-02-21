//
//  SetSliderBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/17.
//

#import "SetSliderBar.h"
#import "SetViewController.h"

@interface SetSliderBar()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *IconImageData;
@property (nonatomic,strong) NSArray *IconNameData;
@end

@implementation SetSliderBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.IconImageData = @[@"cart",@"creditcard",
                               @"qrcode",@"clock",
                               @"iphone.homebutton.badge.play",@"sparkles.tv",
                               @"square.stack.3d.forward.dottedline",@"heart.text.square",
                               @"leaf",@"beats.headphones",@"gearshape"
        ];
        
        self.IconNameData = @[@"我的订单",
                              @"我的钱包",
                             @"我的二维码",
                              @"观看历史",
                              @"使用管理助手",
                             @"创作者服务中心",
                              @"小程序",
                              @"抖音公益",
                              @"青少年守护中心",
                              @"我的客服",
                              @"设置"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,20,self.size.width, self.size.height-40)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 4;
    }else if(section == 2){
        return 5;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row]];
        [cell.imageView setTintColor:[UIColor blackColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    }else if(indexPath.section == 1){
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row + 2]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row + 2]];
        [cell.imageView setTintColor:[UIColor blackColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    }else if(indexPath.section == 2){
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row + 6]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row + 6]];
        [cell.imageView setTintColor:[UIColor blackColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    }else{
        UIButton *button = [[UIButton alloc] init];
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5;
        [button setImage:[UIImage systemImageNamed:@"square.stack"] forState:UIControlStateNormal];
        [button setTitle:@"更多功能" forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTintColor:[UIColor blackColor]];
        [cell.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
            make.height.mas_equalTo(cell.height / 2 + 10);
            make.width.mas_equalTo(cell.width - 40);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3){
        return 0.1;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 3){
        return nil;
    }
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 20)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 9,self.size.width - 40, 2)];
    lineView.backgroundColor = lightgraycolor;
    [view1 addSubview:lineView];
    return view1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SetViewController *vc = [[SetViewController alloc] init];
    [UIWindow PushControllerWithDissmissSliderBar:vc];
}
@end
