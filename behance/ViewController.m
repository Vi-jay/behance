//
//  ViewController.m
//  adobe
//
//  Created by 王慧 on 2017/10/17.
//  Copyright © 2017年 王慧. All rights reserved.
//

#import "ViewController.h"
#import <AdobeCreativeSDKCore/AdobeCreativeSDKCore.h>
static NSString * const kCreativeSDKClientId = @"36a431fcb479494fa908f243f9881f71";
static NSString * const kCreativeSDKClientSecret = @"6fe3a6e8-aff3-4d55-864f-993e84ee2e45";
static NSString * const kCreativeSDKRedirectURLString = @"ams+6cd6d7e13cf647f0c027d23a7eccb6a3779f3da1://adobeid/36a431fcb479494fa908f243f9881f71";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set the client ID and secret values so the CSDK can identify the calling app. The three
    // specified scopes are required at a minimum.
    [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:kCreativeSDKClientId
                                                                   clientSecret:kCreativeSDKClientSecret
                                                            additionalScopeList:@[AdobeAuthManagerUserProfileScope,
                                                                                  AdobeAuthManagerEmailScope,
                                                                                  AdobeAuthManagerAddressScope]];
    
    // Also set the redirect URL, which is required by the CSDK authentication mechanism.
    [AdobeUXAuthManager sharedManager].redirectURL = [NSURL URLWithString:kCreativeSDKRedirectURLString];
    
    if ([AdobeUXAuthManager sharedManager].isAuthenticated)
    {
        NSLog(@"The user has already been authenticated.");
        
        self.userNameLabel.text = [AdobeUXAuthManager sharedManager].userProfile.displayName;
        self.emailLabel.text = [AdobeUXAuthManager sharedManager].userProfile.email;
        
        [self.loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([AdobeUXAuthManager sharedManager].isAuthenticated)
    {
        [[AdobeUXAuthManager sharedManager] logout:^{
            
            NSLog(@"User was successfully logged out.");
            
            self.userNameLabel.text = @"<Not Logged In>";
            self.emailLabel.text = @"<Not Logged In>";
            
            [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
            
        } onError:^(NSError *error) {
            
            NSLog(@"There was a problem logging out: %@", error);
        }];
    }
    else
    {
        [[AdobeUXAuthManager sharedManager] login:self onSuccess:^(AdobeAuthUserProfile *profile) {
            
            NSLog(@"Successfully logged in. User profile: %@", profile);
            
            self.userNameLabel.text = [AdobeUXAuthManager sharedManager].userProfile.displayName;
            self.emailLabel.text = [AdobeUXAuthManager sharedManager].userProfile.email;
            
            [self.loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
            
        } onError:^(NSError *error) {
            
            NSLog(@"There was a problem logging in: %@", error);
        }];
    }
}

@end
