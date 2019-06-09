//
//  MapHelper.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/8/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "MapHelper.h"

@implementation MapHelper

+ (CLLocationCoordinate2D)defaultCoordinates {
    return CLLocationCoordinate2DMake(55.751244, 37.618423);
}

+ (float)defaultZoom {
    return 13.0;
}
    
+ (void)addressWithCoordinates:(CLLocationCoordinate2D)coordinates complation:(void (^ __nullable)(NSString *address))complation {
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:");
        if (![response results].count || error) {
            return;
        }
        
        GMSAddress *address = [response results].firstObject;
        
        NSMutableArray *addressComponents = [[NSMutableArray alloc] init];
        if (address.thoroughfare) {
            [addressComponents addObject:address.thoroughfare];
        }
        
        if (address.locality) {
            [addressComponents addObject:address.locality];
        }
        
        if (address.subLocality) {
            [addressComponents addObject:address.subLocality];
        }
        
        if (address.administrativeArea) {
            [addressComponents addObject:address.administrativeArea];
        }
        
        if (address.country) {
            [addressComponents addObject:address.country];
        }
        
        NSString *fullAddress = [addressComponents componentsJoinedByString:@" "];
        complation(fullAddress);
    }];
}
    
@end
