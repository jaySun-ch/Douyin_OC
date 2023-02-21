//
//  SeletTimeView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/8.
//


#import "SeletTimeView.h"

@interface SeletTimeView()<HWPanModalPresentable>
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIDatePicker *pickerView;
@end


@implementation SeletTimeView

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTopbar];
    [self initPickerView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)initTopbar{
    self.MakeSureButton = [[UIButton alloc] init];
    [self.MakeSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.MakeSureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).inset(15);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).inset(15);
    }];
}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)initPickerView{
    self.pickerView = [[UIDatePicker alloc] init];
    if([AppUserData GetCurrenUser].bornDate){
//        [self.pickerView setDate:[ClientData GetUser].bornDate animated:YES];
    }
    [self.pickerView setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self.pickerView setDatePickerMode:UIDatePickerModeDate];
    self.pickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.pickerView setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MakeSureButton.mas_bottom).inset(10);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.equalTo(self.view);
    }];
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
