//
//  MapViewController.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/8/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "MapViewController.h"
#import "MessageViewController.h"
#import "MapView.h"
#import "MapSearchView.h"

@interface MapViewController () <UITextFieldDelegate, MessageViewControllerDelegate, MapViewDelegate>
    
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet MapView *mapView;
@property (weak, nonatomic) IBOutlet MapSearchView *mapSearchView;
    
@end

@implementation MapViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMessageTextField];
    self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height / 2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.mapView.delegate = self;
}
    
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupMessageTextField {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40.0, self.messageTextField.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"icon_message"];
    imageView.contentMode = UIViewContentModeCenter;
    
    self.messageTextField.leftView = imageView;
    self.messageTextField.leftViewMode = UITextFieldViewModeAlways;
    self.messageTextField.layer.cornerRadius = self.messageTextField.frame.size.height / 2;
    self.messageTextField.layer.masksToBounds = NO;
    self.messageTextField.layer.shadowRadius = 1.0;
    self.messageTextField.layer.shadowColor = [UIColor blackColor].CGColor;
    self.messageTextField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.messageTextField.layer.shadowOpacity = 0.25;
    
    self.messageTextField.delegate = self;
}

- (void)openMessageController {
    MessageViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageViewController"];
    VC.delegate = self;
    VC.message = self.messageTextField.text;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:navVC animated:YES completion:nil];
}
    
#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification*)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
    
- (void)keyboardWillHide:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self openMessageController];
    return NO;
}

#pragma mark - MessageViewControllerDelegate
- (void)messageViewController:(MessageViewController *)controller didSaveText:(NSString *)message {
    self.messageTextField.text = message;
}

#pragma mark - MapViewDelegate

- (void)mapView:(MapView *)view didChangeAddress:(NSString *)address {
    [self.mapSearchView setAddress:address];
}
@end
