//
//  AppUtils.h
//
//
//  Created by Ashok on 20/08/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface AppUtils : NSObject

@end


#define kBEACON_UUID @"48F8C9EF-AEF9-482D-987F-3752F1C51DA1" // 81469E83-EF6F-42AF-B1C6-F339DBDCE2EA
#define kiBEACON_Identifier @"iBeaconIdentifier"

#define AppDelegate_ ((AppDelegate *)[UIApplication sharedApplication].delegate)

typedef void (^Success_Block)(id);
typedef void (^Error_Block)(id);


@interface NSString (DataFromHexString)
- (NSData *)dataUsingStringAsHex;
- (NSString *)stringWithDigitsOnly;
- (NSString *)uppercasedFirstString;

@end

@interface NSData (NSString)
- (NSString *)hexString;
- (Byte)byteAtIndex:(NSUInteger)i;
- (NSString *)string;

@end


@interface NSArray (CollectionsExt)

- (void)forEachObjectPerformBlock:(void(^)(id obj))block;
- (NSArray *)arrayByMappingObjectsUsingFullBlock:(id(^)(id obj, NSUInteger idx, BOOL *stop))block;
- (NSArray *)arrayByMappingObjectsUsingBlock:(id(^)(id obj))block;
- (NSArray *)arrayByFilteringObjectsUsingBlock:(BOOL(^)(id obj))block;
- (NSArray *)arrayByFilteringObjectsUsingFullBlock:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))block;
- (id)objectPassingTest:(BOOL(^)(id obj))block;
- (id)objectPassingTestFull:(BOOL(^)(id obj, NSUInteger i, BOOL *stop))block;

- (void)each:(void(^)(id obj))block;
- (NSArray *)map:(id(^)(id obj))block;
- (NSArray *)grep:(BOOL(^)(id obj))block;
- (id)find:(BOOL(^)(id obj))block;

@end

@interface NSMutableArray (CollectionsExt)

- (id)shift;
- (void)push:(id)obj;

@end

@interface NSDictionary (CollectionsExt)
- (void)each:(void(^)(id key, id val))block;
@end

@interface NonModalAlertViewWithBlocks : UIView {
    
}

@property (nonatomic, copy) void(^tapBlock)(NonModalAlertViewWithBlocks *view);

+ (id)showNonModalAlertViewForView:(UIView *)parentView withText:(NSString *)text tapBlock:(void(^)(NonModalAlertViewWithBlocks *alertView))aTapBlock;
- (void)hide;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


NSDictionary *DictFromFile(NSString *filename);
NSString *NSStringFromCFUUID(CFUUIDRef UUIDRef);
CFUUIDRef CFUUIDFromNSString(NSString *UUIDStr);

id ReadValue(NSString *storageKey);
void StoreValue(NSString *storageKey, id value);

NSArray *LoadObjects(NSString *storageKey);
void StoreObjects(NSString *storageKey, NSArray *objects, BOOL immediately);

void PostNoteBLE(NSString *key, id object);
void PostNoteWithInfo(NSString *key, id object, NSDictionary *info);
void RegisterForNote(NSString *key, id observer);
void RegisterForNoteFromObject(NSString *key, id observer, id object);
void RegisterForNotes(NSArray *noteKeys, id observer);
void RegisterForNotesFromObject(NSArray *noteKeys, id observer, id object);
void UnregisterFromNotes(id observer);
void UnregisterFromNotesFromObject(id observer, id object);
void UnregisterFromNotesFromObjectWithName(id observer, id object, NSString *name);

void ShowAlert(NSString *title, NSString *message);

NSArray *CBUUIDsFromNSStrings(NSArray *strings);
NSString *NSStringFromCBUUID(CBUUID *uuid);
NSArray *NSStringsFromCBUUIDs(NSArray *cbUUIDs);

BOOL saveImageToDocumentDirectory(UIImage *profileImage);
UIImage * getProfileImageFromDocumentDirectory();
UIImage* drawTextOnImage(NSString* text, UIImage *image, CGPoint point);

BOOL ValidateEmailWithString(NSString *email);
int AgeCalculationFromDate(NSDate *date);
NSString * calculateMinuteToDDMMYY(NSInteger minutes);
NSString * calculateSecondsToMMSS(NSInteger seconds);
NSString* getDocumentDirectoryPath();

NSString * currentLanguageCode();

NSString* WebServiceURL();
NSString* WebServiceURLForSoap();

BOOL IsStudent();

@interface UITextField (Padding)
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;
@end




