//
//  MapSearchView.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/8/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "MapSearchView.h"

@interface MapSearchView () <UITextFieldDelegate>
    @property (strong, nonatomic) IBOutlet UIView *contentView;
    @property (weak, nonatomic) IBOutlet UITextField *searchTextField;
    
@end

@implementation MapSearchView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}

    
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}
    
- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40.0, self.searchTextField.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"icon_pin_search"];
    imageView.contentMode = UIViewContentModeCenter;
    self.searchTextField.leftView = imageView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.layer.cornerRadius = self.searchTextField.frame.size.height / 2;
    [self addTextFieldShadow];
    
    self.searchTextField.delegate = self;
}

- (void)addTextFieldShadow {
    self.searchTextField.layer.masksToBounds = NO;
    self.searchTextField.layer.shadowRadius = 1.0;
    self.searchTextField.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchTextField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.searchTextField.layer.shadowOpacity = 0.25;
}

- (void)setAddress:(NSString *)address {
    self.searchTextField.text = address;
}
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
