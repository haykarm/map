//
//  MapView.m
//  ItLavkaMap
//
//  Created by Hayk Harutyunyan on 6/8/19.
//  Copyright © 2019 Hayk Harutyunyan. All rights reserved.
//

#import "MapView.h"
#import "MapHelper.h"
@import GoogleMaps;

@interface MapView () <CLLocationManagerDelegate, GMSMapViewDelegate>
    
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *token;
    
@end

@implementation MapView
    
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:[MapHelper defaultCoordinates] zoom:[MapHelper defaultZoom]];
    [self authMapIfNeeded];
    [self.locationManager startUpdatingLocation];
}
    
- (void)authMapIfNeeded {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        [self.locationManager requestWhenInUseAuthorization];
        break;
        
        default:
        break;
    }
}
    
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.locationManager startUpdatingLocation];
}
    
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:location.coordinate zoom:[MapHelper defaultZoom]];
    [self.locationManager stopUpdatingLocation];
}
 
#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(nonnull GMSCameraPosition *)position {
    NSString *token = [[NSUUID UUID] UUIDString];
    self.token = token;
    __weak typeof(self)weakSelf = self;
    [MapHelper addressWithCoordinates:position.target complation:^(NSString * _Nonnull address) {
        if ([weakSelf.token isEqualToString:token]) {
            if ([weakSelf.delegate respondsToSelector:@selector(mapView:didChangeAddress:)]) {
                [weakSelf.delegate mapView:weakSelf didChangeAddress:address];
            }
        }
    }];
}

@end
