//
//  SelectSchoolView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/8.
//

#import "SelectSchoolView.h"
#import "SchoolData.h"

@interface SelectSchoolView()<UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) SchoolData *data;
@property (nonatomic,strong) NSMutableArray *SearchResultData;
@property (nonatomic,strong) UIView *searchNone;

@end



@implementation SelectSchoolView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.SearchResultData = [NSMutableArray array];
    self.data = [[SchoolData alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self initTableView];
    [self initSearchNone];
}

-(void)initSearchNone{
    self.searchNone = [[UIView alloc] init];
    [self.view addSubview:self.searchNone];
    
    UIImageView  *searchNoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchNone"]];
    [searchNoneImage sizeToFit];
    [self.searchNone addSubview:searchNoneImage];
    
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setText:@"搜索结果为空"];
    [self.searchNone addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setText:@"没有搜索到相关的内容"];
    [label2 setFont:[UIFont systemFontOfSize:15.0]];
    [label2 setTextColor:[UIColor lightGrayColor]];
    [self.searchNone addSubview:label2];
    
    [self.searchNone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).inset(ScreenHeight / 5);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(300);
        make.width.mas_equalTo(250);
    }];
    
    [searchNoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchNone);
        make.centerX.equalTo(self.searchNone);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(250);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchNoneImage.mas_bottom);
        make.centerX.equalTo(self.searchNone);
        make.height.mas_equalTo(20);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).inset(10);
        make.centerX.equalTo(self.searchNone);
        make.height.mas_equalTo(20);
    }];
    
    [self.searchNone setAlpha:0];
}

-(void)initNavigationBar{
    self.title = @"选择学校";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(dissmissView)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    self.searchController = [[UISearchController alloc] init];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.enablesReturnKeyAutomatically = NO;
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.obscuresBackgroundDuringPresentation = YES;
    [self.searchController.searchBar setShowsCancelButton:NO];
    [self.searchController.searchBar setPlaceholder:@"搜索学校"];
    [self.navigationItem setSearchController:self.searchController];
}

-(void)initTableView{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.sectionIndexColor = [UIColor lightGrayColor];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(!self.searchController.isActive || self.SearchResultData.count == 0){
        return self.data.locationName.allKeys.count;
    }else{
        return 1;
    }
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.searchController.searchBar.text isEqualToString:@""] && self.SearchResultData.count == 0){
        return self.data.locationName[self.data.locationName.allKeys[section]].count;
    }else{
        return self.SearchResultData.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([self.searchController.searchBar.text isEqualToString:@""] && self.SearchResultData.count == 0){
        return self.data.locationName.allKeys[section];
    }else{
        return nil;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if([self.searchController.searchBar.text isEqualToString:@""] && self.SearchResultData.count == 0){
        return self.data.locationName.allKeys;
    }else{
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.searchController.searchBar.text isEqualToString:@""] && self.SearchResultData.count == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = self.data.locationName[self.data.locationName.allKeys[indexPath.section]][indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = self.SearchResultData[indexPath.row];
        return cell;
    }
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    [self.tableview reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    self.searchController.searchBar.backgroundColor = self.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor;
    [self.tableview reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.SearchResultData removeAllObjects];
    for(NSArray *schools in self.data.locationName.allValues){
        for(NSString *school in schools){
            if([school containsString:searchController.searchBar.text]){
                [self.SearchResultData addObject:school];
            }
        }
    }
    if(self.SearchResultData.count != 0){
        self.searchNone.alpha = 0;
    }else{
        if(![self.searchController.searchBar.text isEqualToString:@""]){
            self.searchNone.alpha = 1;
        }
    }
    [self.tableview reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClientData *data = [AppUserData GetCurrenUser];
    data.school = self.data.locationName[self.data.locationName.allKeys[indexPath.section]][indexPath.row];
    [AppUserData SavCurrentUser:data];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dissmissView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
