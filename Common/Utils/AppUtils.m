//
//  AppUtils.m
//
//
//  Created by Ashok on 20/08/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "AppUtils.h"
#import "RegexKitLite.h"

@implementation AppUtils

@end


#define PROFILE_IMAGE_PATH @"profilepath"

@implementation NSData (NSString)

- (NSString *)hexString {
    Byte *dataPointer = (Byte *)[self bytes];
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [self length]; i++)     {
        [result appendFormat:@"%02x", dataPointer[i]];
    }
    return result;
}

- (Byte)byteAtIndex:(NSUInteger)i {
    const Byte *bytes = (const Byte *)self.bytes;
    bytes += i;
    Byte b = *bytes;
    return b;
}

- (NSString *)string {
    NSInteger len = self.length;
    if (len > 0) {
        if ('\x00' == [self byteAtIndex:len - 1]) {
            return [NSString stringWithUTF8String:self.bytes];
        }
        char *bytes = malloc(len + 1);
        memcpy(bytes, self.bytes, len);
        bytes[len] = '\x00';
        NSString *str = [NSString stringWithUTF8String:(const char *)bytes];
        free(bytes);
        return str;
    }
    
    return nil;
}

@end

@implementation NSArray (CollectionsExt)

- (void)forEachObjectPerformBlock:(void(^)(id obj))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *stop) {
		block(obj);
    }];
}

- (NSArray *)arrayByMappingObjectsUsingFullBlock:(id(^)(id obj, NSUInteger idx, BOOL *stop))block {
    NSMutableArray *arr = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[arr addObject:block(obj, idx, stop)];
    }];
    return arr;
}

- (NSArray *)arrayByMappingObjectsUsingBlock:(id(^)(id obj))block {
    return [self arrayByMappingObjectsUsingFullBlock:^id(id obj, NSUInteger idx, BOOL *stop) {
		return block(obj);
    }];
}

- (NSArray *)arrayByFilteringObjectsUsingFullBlock:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))block {
    NSMutableArray *arr = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj, idx, stop)) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

- (NSArray *)arrayByFilteringObjectsUsingBlock:(BOOL(^)(id obj))block {
    return [self arrayByFilteringObjectsUsingFullBlock:^BOOL(id obj, NSUInteger i, BOOL *stop) {
		return block(obj);
    }];
}

- (id)objectPassingTest:(BOOL (^)(id obj))block {
    return [self objectPassingTestFull:^BOOL(id obj, NSUInteger i, BOOL *stop) {
		return block(obj);
    }];
}

- (id)objectPassingTestFull:(BOOL (^)(id obj, NSUInteger i, BOOL *stop))block {
    NSUInteger i = [self indexOfObjectPassingTest:block];
    if (NSNotFound == i) {
        return nil;
    }
    return self[i];
}

- (void)each:(void(^)(id obj))block {
	return [self enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *stop) {
		block(obj);
    }];
}

- (NSArray *)map:(id(^)(id obj))block {
	return [self arrayByMappingObjectsUsingBlock:block];
}

- (NSArray *)grep:(BOOL(^)(id obj))block {
	return [self arrayByFilteringObjectsUsingBlock:block];
}

- (id)find:(BOOL(^)(id obj))block {
	return [self objectPassingTest:block];
}

@end

@implementation NSMutableArray (CollectionsExt)

- (id)shift {
    if (self.count == 0) {
        return nil;
    }
    id el = self[0];
    [self removeObjectAtIndex:0];
    return el;
}

- (void)push:(id)obj {
    [self addObject:obj];
}

@end


@implementation NSDictionary (CollectionsExt)

- (void)each:(void(^)(id key, id val))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
		block(key, val);
    }];
}

@end


@implementation NSString (DataFromHexString)

- (NSData *)dataUsingStringAsHex {
    NSMutableData *data = [NSMutableData data];
    for (NSUInteger i = 0; i < self.length; i += 2) {
		unsigned short b; sscanf([[self substringWithRange:(NSRange) {i, 2}] UTF8String], "%2hx", &b);
        [data appendBytes:&b length:1];
    }
    return data;
}

- (NSString *)uppercasedFirstString {
    ZAssert([self length] > 0, @"string must have at least one character");
    return [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1]];
}

- (NSString *)stringWithDigitsOnly {
    return [self stringByReplacingOccurrencesOfRegex:@"[^\\d]" withString:@""];
}

@end


NSArray *CBUUIDsFromNSStrings(NSArray *strings) {
    DLog(@"CBUUIDsFromNSStrings %@",strings);
    return [strings map:^id(NSString *uuidStr) {
        DLog(@"UUIDWithString %@ from string %@",[CBUUID UUIDWithString:uuidStr],uuidStr);
        return [CBUUID UUIDWithString:uuidStr];
    }];
}

NSArray *NSStringsFromCBUUIDs(NSArray *cbUUIDs) {
    return [cbUUIDs map:^id(CBUUID *uuid) {
		return NSStringFromCBUUID(uuid);
    }];
}

NSString *NSStringFromCBUUID(CBUUID *uuid) {
    return [uuid.data hexString];
}

void WithSavingUserDefaults(void(^block)(NSUserDefaults *defaults)) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    block(defaults);
    [defaults synchronize];
}

NSDictionary *DictFromFile(NSString *filename) {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [NSDictionary dictionaryWithContentsOfFile:filepath];
}

NSString *NSStringFromCFUUID(CFUUIDRef UUIDRef) {
	if (NULL == UUIDRef) {
        return nil;
    }
	return CFBridgingRelease(CFUUIDCreateString(nil, UUIDRef));
}

CFUUIDRef CFUUIDFromNSString(NSString *UUIDStr) {
    if (nil == UUIDStr) {
        return NULL;
    }
    return CFUUIDCreateFromString(nil, (CFStringRef)UUIDStr);
}


NSArray *LoadObjects(NSString *storageKey) {
	NSData *archived = ReadValue(storageKey);
    DLog(@"archived: %@", archived);
    if (!archived) {
        return @[];
    }
    NSArray *objects = [NSKeyedUnarchiver unarchiveObjectWithData:archived];
    DLog(@"%@: %@", storageKey, objects);
    return objects;
}

void StoreObjects(NSString *storageKey, NSArray *objects, BOOL immediately) {
    NSData *archived = [NSKeyedArchiver archivedDataWithRootObject:objects];
    DLog(@"%@: %@, archived: %@", storageKey, objects, archived);
    void(^block)(NSUserDefaults *) = ^(NSUserDefaults *def) {
        [def setValue:archived forKey:storageKey];
    };
    immediately ? WithSavingUserDefaults(block) : block([NSUserDefaults standardUserDefaults]);
}

id ReadValue(NSString *storageKey) {
	return [[NSUserDefaults standardUserDefaults] valueForKey:storageKey];
}

void StoreValue(NSString *storageKey, id value) {
    WithSavingUserDefaults(^(NSUserDefaults *def) {
		[def setValue:value forKey:storageKey];
    });
}

BOOL ValidateEmailWithString(NSString *email)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

BOOL IsStudent(){
#ifdef LT_STUDENT
    return TRUE;
#else
    return FALSE;
#endif
}

void PostNoteBLE(NSString *key, id object) {
    DLog(@"posting notification %@ with object %@", key, object);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:key object:object];
    });
}

void PostNoteWithInfo(NSString *key, id object, NSDictionary *info) {
    DLog(@"posting notification %@ with object %@, info: %@", key, object, info);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:key object:object userInfo:info];
    });
}

void RegisterForNotes(NSArray *noteKeys, id observer) {
	[noteKeys forEachObjectPerformBlock:^(NSString *key) {
		RegisterForNote(key, observer);
    }];
}

void RegisterForNotesFromObject(NSArray *noteKeys, id observer, id object) {
	[noteKeys forEachObjectPerformBlock:^(NSString *key) {
		RegisterForNoteFromObject(key, observer, object);
    }];
}

NSString *NoteHandlerSelector(NSString *key) {
	return [NSString stringWithFormat:@"%@%@:", [[key substringToIndex:1] lowercaseString], [key substringFromIndex:1]];
}

void RegisterForNote(NSString *key, id observer) {
    RegisterForNoteFromObject(key, observer, nil);
}

void RegisterForNoteFromObject(NSString *key, id observer, id object) {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:NSSelectorFromString(NoteHandlerSelector(key)) name:key object:object];
}

void UnregisterFromNotes(id observer) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

void UnregisterFromNotesFromObject(id observer, id object) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:nil object:object];
}
void UnregisterFromNotesFromObjectWithName(id observer, id object, NSString *name){
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
}

void ShowAlert(NSString *title, NSString *message) {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}



@implementation NonModalAlertViewWithBlocks

@synthesize tapBlock;

#define NON_MODAL_ALERT_VIEW_WIDTH 280.
#define NON_MODAL_ALERT_VIEW_HEIGHT 120.

- (void)handleTap {
    if (nil == self.tapBlock) {
        [self hide];
    }
    else {
        self.tapBlock(self);
    }
    
}

+ (id)showNonModalAlertViewForView:(UIView *)parentView withText:(NSString *)text tapBlock:(void(^)(NonModalAlertViewWithBlocks *alertView))aTapBlock{
    NSString *imageName = @"toastbg.png";
    UIImage *alertViewImage = [UIImage imageNamed:imageName];
    CGSize viewSize = alertViewImage.size;
    CGRect viewFrame = parentView.bounds;
    viewFrame.origin.x = (viewFrame.size.width - viewSize.width) / 2;
    viewFrame.origin.y = viewFrame.size.height;
    viewFrame.size = CGSizeMake(viewSize.width, viewSize.height);
    NonModalAlertViewWithBlocks *view = [[NonModalAlertViewWithBlocks alloc] initWithFrame:viewFrame];
    UIImageView *alertViewImageView = [[UIImageView alloc] initWithImage:alertViewImage];
    alertViewImageView.backgroundColor = [UIColor clearColor];
    [view addSubview:alertViewImageView];
    
    view.gestureRecognizers = @[([[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(handleTap)])];
    if (nil != aTapBlock) {
        view.tapBlock = [aTapBlock copy];
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 10., 280., 50.)];
    textLabel.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds) - 5);
    textLabel.text = text;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 4.;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:16.];
    [view addSubview:textLabel];
    view.alpha = 0;
    
    CGRect showFrame = viewFrame;
    showFrame.origin.y -= (viewFrame.size.height+10);
    [parentView addSubview:view];
    [UIView animateWithDuration:.5 animations:^{
        view.frame = showFrame;
        view.alpha = 1;
        
        [view performSelector:@selector(hide) withObject:nil afterDelay:5.0];
    }];
    
    return view;
}

- (void)hide {
    if (self.superview) {
        [UIView animateWithDuration:.8 animations:^{
            self.alpha = 0;
        } completion:^(BOOL isFinished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)dealloc {
    self.tapBlock = nil;
}



int AgeCalculationFromDate(NSDate *date)
{
    @try{
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:date
                                           toDate:[NSDate new]
                                           options:0];
        return (int)[ageComponents year];
    } @catch (NSException *exception) {
        
    }
}

NSString * calculateMinuteToDDMMYY(NSInteger minutes)
{
    @try{
        if (minutes == 0) {
            return @"0d 0h 0m";
        }
        
        NSInteger day = (minutes / (24 * 60));
        minutes = minutes -  (day * 24 * 60);
        NSInteger hours = (minutes /  60);
        minutes = minutes - hours * 60;
        return [NSString stringWithFormat:@"%ldd %ldh %ldm",(long)day,(long)hours,(long)minutes];
    } @catch (NSException *exception) {
        
    }
}

NSString * calculateSecondsToMMSS(NSInteger seconds)
{
    @try{
        if (seconds == 0) {
            return @"00 sec";
        }else if(seconds < 60){
            return [NSString stringWithFormat:@"%ld sec",(long)seconds];
        }
        
        NSInteger mins = (seconds /  60);
        seconds = seconds - mins * 60;
        return [NSString stringWithFormat:@"%ld min %ld sec",(long)mins,(long)seconds];
    } @catch (NSException *exception) {
        
    }
}




BOOL saveImageToDocumentDirectory(UIImage *profileImage)
{
    @try{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"ProfilePic.png"];
        StoreValue(PROFILE_IMAGE_PATH, savedImagePath);
        NSData *imageData = UIImagePNGRepresentation(profileImage);
        return [imageData writeToFile:savedImagePath atomically:YES];
    } @catch (NSException *exception) {
        
    }
}

UIImage * getProfileImageFromDocumentDirectory()
{
    @try{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"ProfilePic.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
        return img;
    } @catch (NSException *exception) {
        
    }
}


@end


@implementation UITextField (Padding)
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y , bounds.size.width - 10, bounds.size.height);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
@end

NSString* WebServiceURLForSoap()
{
    return @"http://151.80.186.97:8080/GetFeed/GetFeed.asmx";
}

NSString* WebServiceURL()
{
    return @"http://206.72.192.56/LearnTonight/";
}

NSString * currentLanguageCode(){
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:language];
    NSString *languageCode = [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];
    return languageCode;
}

NSString* getDocumentDirectoryPath()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

UIImage* drawTextOnImage(NSString* text, UIImage *image, CGPoint point)
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    
    [[UIColor whiteColor] set];
    
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        NSDictionary *att = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
        [text drawInRect:rect withAttributes:att];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}








