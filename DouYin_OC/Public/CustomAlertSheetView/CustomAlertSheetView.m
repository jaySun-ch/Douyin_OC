//
//  CustomAlertSheetView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import "CustomAlertSheetView.h"
#import "CustomAlertTabCell.h"

#define CellHeight 55
NSString *const ButtonCell = @"ButtonCell";

@implementation CustomAlertAction
-(instancetype)initWithStyle:(NSString *)Title image:(UIImage*)image style:(CustomAlertActionStyle)style SetImageRight:(BOOL)SetImageRight  handle:(buttonaction)handle{
    self = [super init];
    if(self){
        self.title = Title;
        self.image = image;
        self.style = style;
        self.SetImageRight = SetImageRight;
        self.handle = handle;
    }
    return self;
}
@end

@interface CustomAlertSheetView()<HWPanModalPresentable,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray<CustomAlertAction *> *actions;
@property (nonatomic,assign) NSInteger actioncount;
@end


@implementation CustomAlertSheetView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (instancetype)initWithActionCount:(NSInteger)count{
    self = [super init];
    if(self){
        self.actioncount = count;
        self.actions = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithTableView];
}

-(void)initWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setScrollEnabled:NO];
    [self.tableview registerClass:[CustomAlertTabCell class] forCellReuseIdentifier:ButtonCell];
    [self.view addSubview:self.tableview];
    [self.actions sortUsingComparator:^NSComparisonResult(CustomAlertAction * _Nonnull obj1, CustomAlertAction *_Nonnull obj2) {
        if(obj1.style == CustomAlertActionStyleCancel){
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    [self.tableview reloadData];
};

-(BOOL)HasCancelType{
    NSArray *fliterArray = [self.actions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CustomAlertAction *_Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject.style == CustomAlertActionStyleCancel){
            return YES;
        }
        return NO;
    }]];
    
    if(fliterArray.count == 0){
        return NO;
    }else{
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self HasCancelType]){
        return 2;
    }else{
        return 1;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if([self HasCancelType]){
       
        if(section == 0){
            return self.actions.count - 1;
        }else{
            return 1;
        }
    
    }else{
        return self.actions.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CellHeight;
    }else{
        return CellHeight + 25;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(indexPath.section == 0){
            if(self.actions[indexPath.row].handle){
                self.actions[indexPath.row].handle();
            }
        }else{
            if(self.actions.lastObject.handle){
                self.actions.lastObject.handle();
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CustomAlertTabCell *cell = [tableView dequeueReusableCellWithIdentifier:ButtonCell forIndexPath:indexPath];
        [cell SetData:self.actions[indexPath.row].title image:self.actions[indexPath.row].image SetImageRight:self.actions[indexPath.row].SetImageRight IsLast:NO];
        return cell;
    }else{
        CustomAlertTabCell *cell = [tableView dequeueReusableCellWithIdentifier:ButtonCell forIndexPath:indexPath];
        [cell SetData:self.actions.lastObject.title image:self.actions.lastObject.image SetImageRight:self.actions.lastObject.SetImageRight IsLast:YES];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 10;
    }else{
        return 0.1;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor colorNamed:@"lightgray"];
        return footerView;
    }else{
        return nil;
    }
}

-(void)addCustomActions:(CustomAlertAction *)action{
    if(action.style == CustomAlertActionStyleCancel){
        if(![self HasCancelType]){
            [self.actions addObject:action];
        }
    }else{
        [self.actions addObject:action];
    }
}

- (BOOL)ProhibitScreenDrag{
    return YES;
}

- (BOOL)ProhibitPresentViewDrag{
    return YES;
}


- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent,(self.actioncount)*CellHeight);
}

@end
