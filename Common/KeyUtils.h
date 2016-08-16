//
//  KeyUtils.h
//  BLE Scanner
//
//  Created by Ashok Domadiya on 17/02/16.
//  Copyright © 2016 Bluepixel Technologies LLP. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FontSize @[@10,@12,@14,@16,@18]

#define TBL_PORTFOLIO          @"protfolio"
#define TBL_SCRIPT             @"script"
#define TBL_TOTALSCRIPT        @"totalscript"

// login & registration
#define user_email @"email"
#define user_pass @"password"
#define user_login_type @"login_type"
#define user_socialId @"id"
#define user_firstname @"firstname"
#define user_lastname @"lastname"
#define user_profile_image @"profile_image"

// Dashboard
#define user_unique_id @"unique_id"
#define user_speak_language @"speak_language"
#define user_learn_category @"learn_category"
#define user_teach_category @"teach_category"
#define user_country @"country"
#define user_timezone @"timezone"
#define user_mobile_code @"mobile_code"
#define user_mobile_number @"mobile_number"
#define user_selling_mode @"selling_mode"
#define user_buyers_mode @"buyers_mode"


//Other
#define user_password @"user_password"
#define user_confirm_pass @"user_confirm_pass"
#define device_id @"device_id"
#define kAdvertisementData @"advertisement"
#define kRSSI @"rssi"
#define kFilter @"kFilter"
#define kFilterRSSION @"kFilterRSSION"
#define kIsFilterForRSSI @"kIsFilterForRSSI"

#define kIsFilterNameON @"kIsFilterNameON"
#define kFilterValueForName @"kFilterValueForName"

#define kSettingsDetails @"settingsDetails"
#define kContinusScann @"isContinuousScan"
#define kScanTime @"scanTime"

#define kIsLogin        @"isLogin"

#define kPassword   @"password"
#define kUserName   @"username"

#define kLastSelectedFont @"LastSelectedFont"
#define kSelectedHeader @"SelectedHeader"
#define kAvailExchange @"AvailabelExchange"

@interface KeyUtils : NSObject

@end



@interface UITextField (SpaceTextField)

@end

@interface UIButton (ButtonRounded)

@end




