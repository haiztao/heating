//
//  AKPickView.m
//  AKPickView
//
//  Created by Allen Kwok on 14-11-18.
//  Copyright (c) 2014年 Xlink.cn. All rights reserved.
//
#define AKToobarHeight 40
#import "AKPickView.h"
#import "NSDate+Extension.h"

@interface AKPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *contentView;
@end

@implementation AKPickView

- (NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

- (NSArray *)componentArray{
    
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.frame = [UIScreen mainScreen].bounds;
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        [self setUpToolBar];
    }
    return self;
}

-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    self = [super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}
- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


- (NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

- (void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

- (void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+AKToobarHeight;

    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.contentView.frame = CGRectMake(toolViewX, [UIScreen mainScreen].bounds.size.height, toolViewW, toolViewH);
}

- (void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, AKToobarHeight, [UIScreen mainScreen].bounds.size.width, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self.contentView addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
//    datePicker.locale = [NSLocale currentLocale];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor whiteColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }else{
        NSDateFormatter *fmt= [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"mm"];
        _defaulDate = [fmt dateFromString:@"01"];
        
        [datePicker setDate:_defaulDate];
    }
    
    
    _datePicker=datePicker;
    
    
    datePicker.frame=CGRectMake(0, AKToobarHeight,[UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self.contentView addSubview:datePicker];
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    _toolbar.backgroundColor = [UIColor whiteColor];
    [self setToolbarWithPickViewFrame];
    [self.contentView addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    toolbar.backgroundColor = [UIColor colorWithRed:0xf0/255.f green:0xf0/255.f blue:0xf1/255.f alpha:1];
    toolbar.layer.borderWidth = 0.5f;
    toolbar.layer.borderColor = [UIColor colorWithRed:0xA7/255.f green:0xAC/255.f blue:0xAE/255.f alpha:1].CGColor;
    toolbar.layer.masksToBounds = YES;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@" 取消 " forState:0];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor colorWithRed:0x00/255.f green:0x96/255.f blue:0xff/255.f alpha:1] forState:0];
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@" 确定 " forState:0];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor colorWithRed:0x00/255.f green:0x96/255.f blue:0xff/255.f alpha:1] forState:0];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}

- (void)setTitleString:(NSString *)titleString{
    self.titleLabel.text = titleString;
}

-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, AKToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (component==0) {
            _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

-(void)remove{
    if ([self.delegate respondsToSelector:@selector(toobarWillRemove)]) {
        [self.delegate toobarWillRemove];
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        weakSelf.contentView.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self reloadHeight];
    }];
}

- (void)reloadHeight{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+AKToobarHeight;
    CGFloat toolViewY ;
    if (self.isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.contentView.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}

- (void)current{
    
}

- (void)doneClick
{
    if (_pickerView) {
        if (_resultString) {
            
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                
                if (_state==nil) {
                    _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][0][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                    
                }
                _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
            }
        }
    }else if (_datePicker) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        
        if (_datePicker.date.hour) {
           fmt.dateFormat = @"H时m分";
        }else{
            fmt.dateFormat = @"m分";
        }
        
        [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        _resultString=[fmt stringFromDate:_datePicker.date];
        
        if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultDate:)]) {
            [self.delegate toobarDonBtnHaveClick:self resultDate:_datePicker.date];
        }
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    [self remove];
}

/**
 *  设置PickView的颜色
 */
- (void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}

/**
 *  设置toobar的文字颜色
 */
- (void)setTintColor:(UIColor *)color{
    _toolbar.tintColor=[UIColor blackColor];
}

/**
 *  设置toobar的背景颜色
 */
- (void)setToolbarTintColor:(UIColor *)color{
    _toolbar.barTintColor=color;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self remove];
}

- (void)dealloc{
    //NSLog(@"销毁了");
}
@end


