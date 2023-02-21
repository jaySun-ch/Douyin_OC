//
//  AddFriendView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "AddFriendView.h"
#import "SearchBarCell.h"
#import "RecommendClientCell.h"

@interface AddFriendView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView; //结果页面
@end

@implementation AddFriendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        self.backgroundColor = [UIColor redColor];
        [self initTableView];
    }
    return self;
}

- (void)ViewDidAppear{
    
}

#pragma 设置tableView
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.size.width, self.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SearchBarCell class] forCellReuseIdentifier:@"searchBar"];
    [self.tableView registerClass:[RecommendClientCell class] forCellReuseIdentifier:@"recommend"];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 60;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        SearchBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchBar" forIndexPath:indexPath];
        return cell;
    }else{
        RecommendClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommend" forIndexPath:indexPath];
        if(cell == nil){
            cell = [[RecommendClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"recommend"];
        }
        [cell.imageView setImage:[UIImage imageNamed:@"img1"]];
        [cell.textLabel setText:@"USername"];
        [cell.subtitle setText:@"你干嘛 哎呦"];
        [cell SetCellWithType:RecommendClientCellNormal];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
