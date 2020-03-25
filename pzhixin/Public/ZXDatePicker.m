//
//  ZXDatePicker.m
//  pzhixin
//
//  Created by zhixin on 2019/11/6.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDatePicker.h"

@interface ZXDatePicker ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ZXDatePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaViewAction)];
    [self.view addGestureRecognizer:tapView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [_datePicker setMaximumDate:[formatter dateFromString:[UtilsMacro fetchCurrentDate]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITapGestureRecognizer

- (void)handleTaViewAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Method

- (IBAction)handleTapDatePickerBtnAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter stringFromDate:_datePicker.date];
            if (self.zxDatePickerResultBlock) {
                self.zxDatePickerResultBlock(dateStr);
            }
        }
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
