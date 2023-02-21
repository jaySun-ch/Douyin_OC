//
//  SelectMajorView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/8.
//

#import "SelectMajorView.h"

@interface SelectMajorView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *MajorArray;
@end

@implementation SelectMajorView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



- (void)viewDidLoad{
    [super viewDidLoad];
  
    self.MajorArray = @[
        @"文学系",
       @"语言学系",
        @"文献学系",
        @"戏剧影视艺术系",
        @"大学语文部",
        @"哲学系（宗教学系",
       @"中国历史系",
        @"世界历史系",
        @"考古文物系",
        @"现代物理系",
        @"物理学系",
        @"光电科学系",
        @"声科学与工程系",
        @"基础物理教学中心",
        @"数学系",
        @"天文与空间科学学院",
        @"地球科学系",
        @"水科学系",
        @"地质工程与信息技术系",
        @"气象学系",
        @"大气物理学系",
        @"国土资源与旅游学系",
        @"地理信息科学系",
        @"海洋科学系",
        @"计算机科学与技术系",
        @"电子工程系",
        @"微电子与光电子学系",
        @"信息电子学系",
        @"通信工程系",
        @"电子电工实验教学中心",
        @"微制造与集成工艺中心",
        @"材料科学与工程系",
        @"量子电子学与光学工程系",
        @"生物医学工程系",
        @"能源科学与工程系",
        @"新闻与新媒体系",
        @"广播电影电视系",
        @"应用传媒系",
        @"经济学院",
        @"管理学院",
        @"英语系",
        @"俄语系",
        @"日语系",
        @"德语系",
        @"法语系",
        @"西班牙语系",
        @"国际商务系",
        @"朝鲜语系",
        @"法学院",
        @"生命科学学院",
        @"政治学系",
        @"行政管理学系",
        @"劳动人事与社会保障系",
        @"马克思主义学院",
        @"信息管理学院",
        @"社会学系",
        @"心理学系",
        @"社会工作与社会政策系",
        @"化学化工学院",
        @"环境科学系",
        @"环境工程系",
        @"环境规划与管理系",
        @"医学院",
        @"软件学院",
        @"管理科学与工程系",
        @"控制与系统工程系",
        @"光通信工程研究中心",
        @"大学外语部",
        @"体育部",
        @"艺术研究院",
        @"建筑系",
        @"城市规划与设计系",
    ];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self initTableView];
}

-(void)initNavigationBar{
    self.title = @"选择院系";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(dissmissView)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

-(void)dissmissView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTableView{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.sectionIndexColor = [UIColor lightGrayColor];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MajorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.MajorArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
