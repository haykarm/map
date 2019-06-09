//
//  MapView.h
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/8/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MapView;
@protocol MapViewDelegate <NSObject>
    
- (void)mapView:(MapView *)view didChangeAddress:(NSString *)address;
    
@end

@interface MapView : UIView

@property (weak, nonatomic) id <MapViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
