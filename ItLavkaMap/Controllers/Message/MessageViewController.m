//
//  MessageViewController.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/9/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
    @property (weak, nonatomic) IBOutlet UITextView *textView;
    
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.textView.text = self.message;
    [self.textView becomeFirstResponder];
}
    
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
- (IBAction)cacelButtonAction:(UIBarButtonItem *)sender {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)saveButtonAction:(UIBarButtonItem *)sender {
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSaveText:)]) {
        [self.delegate messageViewController:self didSaveText:self.textView.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
- (void)keyboardWillShow:(NSNotification*)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
}
    
- (void)keyboardWillHide:(NSNotification*)notification {
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
    
@end
