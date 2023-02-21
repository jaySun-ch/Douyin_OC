//
//  LoactionPicker.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import "LoactionPicker.h"

@interface LoactionPicker()<HWPanModalPresentable,WHAreaPickerViewDelegate>
@property (nonatomic,strong) WHAreaPickerView *pickerView;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UISwitch *ToogleView;
@end


@implementation LoactionPicker

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initTopbar];
    _pickerView = [[WHAreaPickerView alloc]initWithFrame:self.view.frame];
    _pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MakeSureButton.mas_bottom).inset(20);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)Save{
    ClientData *data = [AppUserData GetCurrenUser];
    if(![data.location isEqualToString:[self.pickerView GetCurrentLocation]]){
        [self SaveData];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)SaveData{
    ClientData *data = [AppUserData GetCurrenUser];
    if(self.ToogleView.isOn){
        data.location = @"";
    }else{
        data.location = [self.pickerView GetCurrentLocation];
    }
    ChangeClientMessageRequest *request = [ChangeClientMessageRequest new];
    request.PhoneNumber = [AppUserData GetCurrenUser].phoneNumber;
    request.ChangeMessageName = @"location";
    request.ChangeContend = data.location;
    [UIWindow ShowLoadNoAutoDismiss];
    [ClientData SaveUserToServerWithRequest:request responsedata:^(SuccessResponse *responsedata) {
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
    [self.ToogleView addTarget:self action:@selector(ChangeData) forControlEvents:UIControlEventValueChanged];
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

-(void)ChangeData{
    ClientData *data = [AppUserData GetCurrenUser];
    data.location = @"";
    [AppUserData SavCurrentUser:data];
}

-(void)dismissView{
    [self Save];
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
    return PanModalHeightMake(PanModalHeightTypeContent, 350);
}

@end
