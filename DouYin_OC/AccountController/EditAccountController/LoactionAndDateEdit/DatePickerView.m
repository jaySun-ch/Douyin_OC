//
//  DatePickerView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/6.
//


#import "DatePickerView.h"

@interface DatePickerView()<HWPanModalPresentable>
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UISwitch *ToogleView;
@property (nonatomic,strong) UIDatePicker *pickerView;

@end


@implementation DatePickerView

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self initTopbar];
    [self initPickerView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)Save{
    ClientData *data = [AppUserData GetCurrenUser];
    if(data.bornDate != self.pickerView.date){
        [self SaveData];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)SaveData{
    ClientData *data = [AppUserData GetCurrenUser];
    if(self.ToogleView.isOn){
        data.bornDate = nil;
    }else{
        data.bornDate = self.pickerView.date;
    }
    ChangeClientDateRequest *request = [ChangeClientDateRequest new];
    request.PhoneNumber = [AppUserData GetCurrenUser].phoneNumber;
    request.ChangeMessageName = @"bornDate";
    request.ChangeContend = data.bornDate;
    [UIWindow ShowLoadNoAutoDismiss];
    [ClientData SaveUserDateToServerWithRequest:request responsedata:^(SuccessResponse *responsedata) {
        if(responsedata == nil){
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存失败,请重试"];
            }];
        }else{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存成功"];
                [AppUserData SavCurrentUser:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

-(void)initTopbar{
    self.MakeSureButton = [[UIButton alloc] init];
    [self.MakeSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.MakeSureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    
    self.ToogleView = [[UISwitch alloc] init];
    [self.ToogleView setOn:NO];
    [self.ToogleView setTintColor:[UIColor greenColor]];
    [self.ToogleView addTarget:self action:@selector(ValueChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.ToogleView];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"不展示"];
    [self.view addSubview:label];
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).inset(15);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).inset(15);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(5);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).inset(15);
    }];
    
    [self.ToogleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).inset(10);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).inset(10);
    }];
}

-(void)dismissView{
    [self Save];
}

-(void)initPickerView{
    self.pickerView = [[UIDatePicker alloc] init];
    if([AppUserData GetCurrenUser].bornDate){
        [self.pickerView setDate:[AppUserData GetCurrenUser].bornDate animated:YES];
    }
    [self.pickerView setMaximumDate:[NSDate date]];
    [self.pickerView setDatePickerMode:UIDatePickerModeDate];
    self.pickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.pickerView setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ToogleView.mas_bottom).inset(10);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.equalTo(self.view);
    }];
}

-(void)ValueChange{
    ClientData *data = [AppUserData GetCurrenUser];
    data.bornDate = nil;
    [AppUserData SavCurrentUser:data];
}

- (BOOL)showDragIndicator{
    return NO;
}

- (BOOL)ProhibitScreenDrag{
    return YES;
}

- (BOOL)ProhibitPresentViewDrag{
    return YES;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, 300);
}

@end
