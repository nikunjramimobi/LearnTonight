//
//  AppDelegate.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 27/07/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import "AppDelegate.h"
#import "AppUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import <linkedin-sdk/LISDK.h>

@interface AppDelegate () 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.webServiceActor = [[WebServiceActor alloc]init];
    [self.webServiceActor start];

    
    [self switchToMainScreen];
    
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    
    GIDSignIn *SignIn = [GIDSignIn sharedInstance];
    
    if (IsStudent()) {
        [GIDSignIn sharedInstance].clientID = @"889471278126-1b6n209itp0eo98nscq9e9tlg7ps1ekt.apps.googleusercontent.com";
        [[Twitter sharedInstance] startWithConsumerKey:@"A0OSI7a2NRNIqSMHXyaIuwZ5M" consumerSecret:@"VBv4nN4babcX4XakrqCiwYn4GdUzhX2YyKWp2zffDoBI75bN82"];
    }
    else {
        [GIDSignIn sharedInstance].clientID = @"1098576332271-0657nulos2q8915a2snnse5nl5v6kdrn.apps.googleusercontent.com";
        
        [[Twitter sharedInstance] startWithConsumerKey:@"8E54vg0tvHl90eMogt8JsrzCe" consumerSecret:@"3thgpANwt3PKkNWed9zg9mEy69ko83B3cjyvG7O7yjbOGJGh1r"];
    }
    
    
    
    SignIn.scopes = @[@"https://www.googleapis.com/auth/plus.login",@"https://www.googleapis.com/auth/plus.me"];
    
    
    
    [Fabric with:@[[Twitter class]]];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    
    if([[url scheme]isEqualToString:@"fb1026267354155004"] || [[url scheme]isEqualToString:@"fb429622617224014"]) {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation
                        ];
        // Add any custom logic here.
        return handled;
    }else if([[url scheme]isEqualToString:@"li4757275"] || [[url scheme]isEqualToString:@"li4760635"]) {
        if ([LISDKCallbackHandler shouldHandleUrl:url]) {
            return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }
        return YES;
    }
    else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
    
    
}

#pragma mark - Custom Method


- (void)switchToMainScreen
{
    
    UIStoryboard *mainStoryboard;
    if (IsStudent()) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                    bundle: nil];
    }
    else {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main_Tutor"
                                                    bundle: nil];
    }
    
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    //RightMenuViewController *rightMenu = (RightMenuViewController*)[mainStoryboard
    //instantiateViewControllerWithIdentifier: @"RightMenuViewController"];
    
    //[SlideNavigationController sharedInstance].rightMenu = rightMenu;
    UINavigationController *navControllerMain = [mainStoryboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    self.window.rootViewController = navControllerMain;
    
    // Creating a custom bar button for right menu
    /*UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [button setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
     [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
     [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];*/

    
}

- (void)switchToLoginScreen
{
    UIStoryboard *loginStoryboard;
    if (IsStudent()) {
        loginStoryboard = [UIStoryboard storyboardWithName:@"Login"
                                                    bundle: nil];
    }
    else {
        loginStoryboard = [UIStoryboard storyboardWithName:@"Login_Tutor"
                                                    bundle: nil];
    }
    
    UINavigationController *navControllerLogin = [loginStoryboard instantiateViewControllerWithIdentifier:@"navLogin"];
    self.window.rootViewController = navControllerLogin;
}

-(void)showProgressloader:(UIView *)view{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"LT_loader" withExtension:@"gif"];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]];
    [imageview setBounds:CGRectMake(0, 0, 20, 20)];
    [imageview setBackgroundColor:[UIColor clearColor]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageview;
    [hud.customView setBackgroundColor:[UIColor clearColor]];
    hud.minSize = CGSizeMake(20.f, 20.f);
    
}
-(void)RemoveProgressloader:(UIView *)view{
    
    [MBProgressHUD hideHUDForView:view animated:NO];

}


@end
