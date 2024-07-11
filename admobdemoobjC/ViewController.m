//
//  ViewController.m
//  admobdemoobjC
//
//  Created by Naveen Singh on 29/02/24.
//

#import "ViewController.h"
@import GoogleMobileAds;
@import UserMessagingPlatform;

@interface ViewController ()
@property (nonatomic, assign) BOOL isMobileAdsStartCalled;
@end

@implementation ViewController
- (BOOL)isPrivacyOptionsRequired {
  return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus ==
         UMPPrivacyOptionsRequirementStatusRequired;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    

}

- (IBAction)ConsentBtn:(id)sender {
    UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
    [[UMPConsentInformation sharedInstance] requestConsentInfoUpdateWithParameters:parameters completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        [UMPConsentForm loadAndPresentIfRequiredFromViewController:self completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            
            // Handle successful loading and presentation of the consent form
            [self isPrivacyOptionsRequired];
        }];
    }];
    
    [[UMPConsentInformation sharedInstance] requestConsentInfoUpdateWithParameters:parameters completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error requesting consent info update: %@", error.localizedDescription);
            return;
        }
        
        [UMPConsentForm loadWithCompletionHandler:^(UMPConsentForm * _Nullable consentForm, NSError * _Nullable error)  {
            if (error) {
                NSLog(@"Error loading consent form: %@", error.localizedDescription);
                return;
            }
            
            if ([[UMPConsentInformation sharedInstance] canRequestAds]) {
                [self startGoogleMobileAdsSDK];
            }
        }];
        
        if ([[UMPConsentInformation sharedInstance] canRequestAds]) {
            [self startGoogleMobileAdsSDK];
        }
    }];
    
    UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
    debugSettings.testDeviceIdentifiers = @[@"TEST-DEVICE-HASHED-ID"];
    debugSettings.geography = UMPDebugGeographyEEA;
    parameters.debugSettings = debugSettings;
    
    [[UMPConsentInformation sharedInstance] reset];
}


- (void)startGoogleMobileAdsSDK {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_isMobileAdsStartCalled) {
            return;
        }
        self->_isMobileAdsStartCalled = YES;
        NSLog(@"Consent set");
        // Initialize the Google Mobile Ads SDK.
        
        // Instantiate the next view controller from storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil]; // Replace "Main" with your storyboard name
        UIViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        // Present the next view controller
        [self.navigationController pushViewController:nextViewController animated:YES];
    });
}

@end
