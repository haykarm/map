//
//  MapHelper.h
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/8/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

NS_ASSUME_NONNULL_BEGIN

@interface MapHelper : NSObject
+ (CLLocationCoordinate2D)defaultCoordinates;
+ (float)defaultZoom;
+ (void)addressWithCoordinates:(CLLocationCoordinate2D)coordinates complation:(void (^ __nullable)(NSString *address))complation;
@end

NS_ASSUME_NONNULL_END
