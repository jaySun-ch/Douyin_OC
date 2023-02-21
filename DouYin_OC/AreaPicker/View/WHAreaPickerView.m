//
//  WHAreaPickerView.m
//
//  Created by 王辉 on 2019/3/2.
//  Copyright © 2019 WangHui. All rights reserved.
//

#import "WHAreaPickerView.h"

#import "WHAreaList.h"

@interface WHAreaPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 地址选择器视图 */
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray<WHAreaList *> *dataSource;
/** 选中的省份 下标 默认为0 */
@property (assign, nonatomic) NSInteger selectProv;
/** 选中的城市 下标 默认为0 */
@property (assign, nonatomic) NSInteger selectCity;
/** 选中的地区 下标 默认为0 */
@property (assign, nonatomic) NSInteger selectArea;

@end

@implementation WHAreaPickerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.lastAreas.count > 2)
    {
        self.selectProv = self.lastAreas.firstObject.intValue;
        self.selectCity = self.lastAreas[1].intValue;
        self.selectArea = self.lastAreas.lastObject.intValue;
        
        [self pickerReloadComponent:0 selectRow:self.selectProv];
        [self pickerReloadComponent:1 selectRow:self.selectCity];
        [self pickerReloadComponent:2 selectRow:self.selectArea];
    }
}

#pragma mark - 自定义方法
/**
 初始化视图
 */
- (void)initUI
{
//    self.backgroundColor = [UIColor redColor];
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"area" ofType:@"plist"];
    NSArray *areaArr = [NSArray arrayWithContentsOfFile:filePath];
    self.dataSource = [WHAreaList wh_objectArrayWithKeyValuesArray:areaArr];
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.width = self.width;
    self.pickerView.height = 300;
    self.pickerView.centerX = self.centerX;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
//    self.pickerView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.pickerView];
}

/**
 选择器刷新
 
 @param component 列
 @param row 行
 */
- (void)pickerReloadComponent:(NSInteger)component selectRow:(NSInteger)row
{
    [self.pickerView reloadComponent:component];
    [self.pickerView selectRow:row inComponent:component animated:YES];
}

/**
 确认
 */
- (NSString *)GetCurrentLocation
{
    // 省份
    WHAreaList *prov = self.dataSource[self.selectProv];
    // 城市
    WHAreaList *city = prov.child[self.selectCity];
    // 县区
    WHAreaList *area = city.child[self.selectArea];
    // 区域下标
    _lastAreas = @[@(self.selectProv), @(self.selectCity), @(self.selectArea)];
    // 区域名称
    _areaName = @[prov.area_name, city.area_name, area.area_name];
    
    return [NSString stringWithFormat:@"%@ %@ %@",prov.area_name,city.area_name,area.area_name];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.dataSource.count;
    }
    else if (component == 1)
    {
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        if (provinceRow >= self.dataSource.count)
        {
            return 0;
        }
        return self.dataSource[provinceRow].child.count;
    }
    else
    {
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        NSInteger cityRow = [pickerView selectedRowInComponent:1];
        if (provinceRow >= self.dataSource.count ||
            cityRow >= self.dataSource[provinceRow].child.count)
        {
            return 0;
        }
        return self.dataSource[provinceRow].child[cityRow].child.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        if (row >= self.dataSource.count)
        {
            return nil;
        }
        return self.dataSource[row].area_name;
    }
    else if (component == 1)
    {
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        if (provinceRow >= self.dataSource.count || row >= self.dataSource[provinceRow].child.count)
        {
            return nil;
        }
        return self.dataSource[provinceRow].child[row].area_name;
    }
    else
    {
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        NSInteger cityRow = [pickerView selectedRowInComponent:1];
        if (provinceRow >= self.dataSource.count ||
            cityRow >= self.dataSource[provinceRow].child.count ||
            row >= self.dataSource[provinceRow].child[cityRow].child.count)
        {
            return nil;
        }
        return self.dataSource[provinceRow].child[cityRow].child[row].area_name;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return ScreenWidth / 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel =[[UILabel alloc] init];
    pickerLabel.textColor = [UIColor darkGrayColor];
    pickerLabel.adjustsFontSizeToFitWidth = YES;
    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.selectProv = row;
        self.selectCity = 0;
        self.selectArea = 0;
        [self pickerReloadComponent:1 selectRow:0];
        [self pickerReloadComponent:2 selectRow:0];
    }
    else if (component == 1)
    {
        self.selectCity = row;
        self.selectArea = 0;
        [self pickerReloadComponent:2 selectRow:0];
    }
    else
    {
        self.selectArea = row;
    }
}


@end
