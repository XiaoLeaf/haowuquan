//
//  ZXPickerManager.m
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPickerManager.h"

@interface ZXPickerManager () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) NSArray *monthList;

@property (assign, nonatomic) BOOL isLoaded;

@end

@implementation ZXPickerManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.picker setDelegate:self];
    [self.picker setDataSource:self];
    [self.view setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaViewAction)];
    [self.view addGestureRecognizer:tapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isLoaded) {
        NSInteger selectRow = [[[self.dataSource objectAtIndex:self.dataSource.count - 1] valueForKey:@"month"] count] - 1;
        [self.picker selectRow:self.dataSource.count - 1 inComponent:0 animated:NO];
        [self pickerView:self.picker didSelectRow:self.dataSource.count - 1 inComponent:0];
        [self.picker selectRow:selectRow inComponent:1 animated:NO];
        _isLoaded = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)handleTaViewAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    _monthList = [[NSArray alloc] initWithArray:[[_dataSource objectAtIndex:0] valueForKey:@"month"]];
    [self.picker reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_dataSource count];
    }
    return [_monthList count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 33.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[_dataSource objectAtIndex:row] valueForKey:@"year"];
    } else {
        return [_monthList objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _monthList = [[NSArray alloc] initWithArray:[[_dataSource objectAtIndex:row] valueForKey:@"month"]];
        [self.picker reloadComponent:1];
    }
}

#pragma mark - Button Method

- (IBAction)handleTapPickManagerBtnActions:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            NSInteger yearRow = [self.picker selectedRowInComponent:0];
            NSInteger monthRow = [self.picker selectedRowInComponent:1];
            if (self.zxPickManagerBlock) {
                self.zxPickManagerBlock([[_dataSource objectAtIndex:yearRow] valueForKey:@"year"], [_monthList objectAtIndex:monthRow]);
            }
        }
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
