//
//  SearchController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "SearchController.h"
#import "PublicSearchResultView.h"
#import "SearchResultMoreCell.h"


#pragma 搜索聊天记录以及综合性搜索的地方
@interface SearchController()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation SearchController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self initSearchBar];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in self.searchBar.subviews){
        for(UIView *subview2 in subView.subviews){
            // 这一层View
            for(UIView *subview3 in subview2.subviews){
                // 这一层分为Backgrounround 和 continaer
                if([subview3 isKindOfClass:UIButton.class]){
                    UIButton *button = (UIButton *)subview3;
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(CancleSearch) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
    [self.searchBar.searchTextField becomeFirstResponder];
}

#pragma 设置SearchBar
-(void)initSearchBar{
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate  = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.searchTextField.delegate = self;
    self.searchBar.searchTextField.backgroundColor = [UIColor colorNamed:@"lightgray"];
    self.searchBar.placeholder = @"搜索";
//    self.searchBar.backgroundColor = [UIColor colorNamed:@"lightgray"];
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(15);
        make.top.equalTo(self.view).inset(40);
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in self.searchBar.subviews){
        for(UIView *subview2 in subView.subviews){
            // 这一层View
            for(UIView *subview3 in subview2.subviews){
                // 这一层分为Backgrounround 和 continaer
                if([subview3 isKindOfClass:UIButton.class]){
                    UIButton *button = (UIButton *)subview3;
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(CancleSearch) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self.tableview reloadData];
    return YES;
}

-(void)CancleSearch{
    [self.searchBar.searchTextField resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchBar.searchTextField resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self Search];
    return YES;
}

-(void)Search{
    if(![self.searchBar.searchTextField.text isEqualToString:@""]){
        PublicSearchResultView *vc = [PublicSearchResultView new];
        vc.SearchText = self.searchBar.searchTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma 设置tableView

-(void)initTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,100, ScreenWidth, ScreenHeight-100)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[SearchResultMoreCell class] forCellReuseIdentifier:@"SearchMore"];
    [self.view addSubview:self.tableview];
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchMore" forIndexPath:indexPath];
    cell.searchLabel.text = self.searchBar.searchTextField.text;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self Search];
}


@end
