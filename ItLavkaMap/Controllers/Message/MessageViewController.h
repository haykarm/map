//
//  MessageViewController.h
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/9/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MessageViewController;
@protocol MessageViewControllerDelegate <NSObject>
    
- (void)messageViewController:(MessageViewController *)controller didSaveText:(NSString *)message;
    
@end
    
@interface MessageViewController : UIViewController

@property (copy, nonatomic) NSString *message;
@property (weak, nonatomic) id <MessageViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
