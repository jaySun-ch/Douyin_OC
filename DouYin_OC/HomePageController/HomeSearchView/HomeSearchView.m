//
//  HomeSearchView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "HomeSearchView.h"
#import "SearchHistoryCell.h"
#import "PublicSearchResultView.h"


@interface HomeSearchView()<UISearchBarDelegate,BRSliderBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UISearchBar *searhBar;
@property (nonatomic,strong) BRSliderBar *SliderBar;
@property (nonatomic,strong) UITableView *tablewView;

@end


@implementation HomeSearchView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self SetNavigationBar];
    [self initTableView];
    [self.searhBar.searchTextField becomeFirstResponder];

}

#pragma 设置顶部导航栏
-(void)SetNavigationBar{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(DismissView)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(Search)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    self.searhBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 150, 40)];
    self.searhBar.placeholder = @"搜索点什么吧";
    self.searhBar.delegate = self;
    self.searhBar.searchTextField.delegate = self;
    [self.navigationItem setTitleView:self.searhBar];
}

-(void)Search{
    if(![self.searhBar.searchTextField.text isEqualToString:@""]){
        PublicSearchResultView *vc = [[PublicSearchResultView alloc] init];
        vc.SearchText = self.searhBar.searchTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)DismissView{
    [self.searhBar.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self Search];
    [textField resignFirstResponder];
    return YES;
}

#pragma 设置TableView
-(void)initTableView{
    self.tablewView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight - 100)];
    self.tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablewView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tablewView.dataSource = self;
    self.tablewView.delegate = self;
    self.tablewView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tablewView registerClass:[SearchHistoryCell class] forCellReuseIdentifier:@"SearchHistoryCell"];
    [self.view addSubview:self.tablewView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell" forIndexPath:indexPath];
    [cell.textLabel setText:@"苹果春气发布会"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self Search];
}


@end
