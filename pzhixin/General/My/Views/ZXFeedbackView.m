//
//  ZXFeedbackView.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFeedbackView.h"
#import <Masonry/Masonry.h>
#import "ZXFeedbackPickCell.h"
#import "ZXFeedbackImgCell.h"

@interface ZXFeedbackView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate> {
    UILongPressGestureRecognizer *longPress;
}

@end

@implementation ZXFeedbackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

#pragma mark - Setter

- (void)setImgList:(NSMutableArray *)imgList {
    _imgList = [[NSMutableArray alloc] initWithArray:imgList];
    [_imgCollectionView reloadData];
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15.0);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(180.0).priorityLow();
        }];
    }
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_mainView addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_mainView).offset(10.0);
            make.left.mas_equalTo(self->_mainView).offset(20.0);
            make.right.mas_equalTo(self->_mainView).offset(-20.0);
            make.bottom.mas_equalTo(self->_mainView.mas_bottom).offset(-100.0);
            make.height.mas_equalTo(70.0).priorityLow();
        }];
    }
    
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        [_contentTextView setTextColor:HOME_TITLE_COLOR];
        [_contentTextView setFont:[UIFont systemFontOfSize:15.0]];
        [_contentTextView setScrollEnabled:NO];
        [_contentTextView setDelegate:self];
        [_contentView addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_contentView);
            make.left.mas_equalTo(self->_contentView);
            make.bottom.mas_equalTo(self->_contentView);
            make.right.mas_equalTo(self->_contentView);
        }];
    }
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_contentView addSubview:_tipLabel];
        [_tipLabel setTextColor:COLOR_999999];
        [_tipLabel setNumberOfLines:0];
        [_tipLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_tipLabel setText:@"请详细描述您得问题或建议，我们将及时跟进解决。(建议添加相关问题的截图）"];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_contentView).offset(5.0);
            make.left.mas_equalTo(self->_contentView);
            make.height.mas_equalTo(20.0).priorityLow();
            make.right.mas_equalTo(self->_contentView);
        }];
    }
    
    if (!_imgCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_imgCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_imgCollectionView setScrollEnabled:NO];
        [_imgCollectionView setShowsVerticalScrollIndicator:NO];
        [_imgCollectionView setShowsHorizontalScrollIndicator:NO];
        [_imgCollectionView setDelegate:self];
        [_imgCollectionView setDataSource:self];
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImgCollectionView:)];
        [_imgCollectionView addGestureRecognizer:longPress];
        [_imgCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXFeedbackPickCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXFeedbackPickCell"];
        [_imgCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXFeedbackImgCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXFeedbackImgCell"];
        [_mainView addSubview:_imgCollectionView];
        [_imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_contentView.mas_bottom).offset(20.0);
            make.left.mas_equalTo(self->_mainView).offset(20.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-20.0);
            make.bottom.mas_equalTo(self->_mainView.mas_bottom).offset(-20.0);
            make.height.mas_equalTo(60.0);
        }];
    }
    
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setBackgroundColor:THEME_COLOR];
        [_submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_submitBtn.layer setCornerRadius:2.0];
        [_submitBtn addTarget:self action:@selector(handleTaoFeedbackSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_mainView.mas_bottom).offset(40.0);
            make.left.mas_equalTo(self.mas_left).offset(20.0);
            make.right.mas_equalTo(self.mas_right).offset(-20.0);
            make.height.mas_equalTo(40.0);
        }];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 0) {
        [_tipLabel setHidden:YES];
    } else {
        [_tipLabel setHidden:NO];
    }
}

#pragma mark - UILongPressGestureRecognizer

- (void)longPressImgCollectionView:(UILongPressGestureRecognizer *)recognizer {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan :
        {
            NSIndexPath *indexPath = [_imgCollectionView indexPathForItemAtPoint:[longPress locationInView:longPress.view]];
//            ZXFeedbackImgCell *cell = (ZXFeedbackImgCell *)[_imgCollectionView cellForItemAtIndexPath:indexPath];
            [_imgCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged :
        {
            [_imgCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
        }
            break;
        case UIGestureRecognizerStateEnded :
        {
            [_imgCollectionView cancelInteractiveMovement];
        }
            break;
            
        default:
            [_imgCollectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_imgList count] == 0) {
        return 1;
    } else if ([_imgList count] < 5) {
        return [_imgList count] + 1;
    } else {
        return [_imgList count];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60.0, 60.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (SCREENWIDTH - 40.0 - 60.0 * 5)/4.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_imgList count] == 0) {
        ZXFeedbackPickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXFeedbackPickCell" forIndexPath:indexPath];
        return cell;
    } else if ([_imgList count] < 5) {
        if (indexPath.row == [_imgList count]) {
            ZXFeedbackPickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXFeedbackPickCell" forIndexPath:indexPath];
            return cell;
        } else {
            ZXFeedbackImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXFeedbackImgCell" forIndexPath:indexPath];
            [cell.imgView setImage:[_imgList objectAtIndex:indexPath.row]];
            return cell;
        }
    } else {
        ZXFeedbackImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXFeedbackImgCell" forIndexPath:indexPath];
        [cell.imgView setImage:[_imgList objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:[longPress locationInView:collectionView]];
    id objc = [_imgList objectAtIndex:sourceIndexPath.row];
    [_imgList removeObject:objc];
    [_imgList insertObject:objc atIndex:destinationIndexPath.row];
    [_imgCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedbackCollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate feedbackCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Button Method

- (void)handleTaoFeedbackSubmitBtnAction {
//    NSLog(@"提交反馈");
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedbackSubmitButtonAction)]) {
        [self.delegate feedbackSubmitButtonAction];
    }
}

@end
