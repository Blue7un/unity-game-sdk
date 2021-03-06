#import "AppotaWrapper.h"
#import "AppotaSDK/AppotaSDK.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppotaWrapper()
+ (NSMutableDictionary *) unpackToDictionary: (NSString *) parameters;
@end

@implementation AppotaWrapper

static AppotaWrapper* sharedMyInstance = nil;

+ (id) sharedInstance {
    @synchronized(self) {
        if( sharedMyInstance == nil )
            sharedMyInstance = [[super allocWithZone:NULL] init];
    }
    return sharedMyInstance;
} // end sharedInstance()


+ (NSMutableDictionary *) unpackToDictionary: (NSString *) parameters {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [parameters componentsSeparatedByString:@";"];
    
    for (NSString *str in pairs) {
        NSArray *contentPair = [str componentsSeparatedByString:@":"];
        [dictionary setValue:[contentPair objectAtIndex:1] forKey:[contentPair objectAtIndex:0]];
    }
    
    return dictionary;
}

extern "C" {
    char* cStringCopy(const char* string)
    {
        if (string == NULL)
            return NULL;
        
        char* res = (char*)malloc(strlen(string) + 1);
        strcpy(res, string);
        
        return res;
    }
    
    // SDK Functions
    const void init() {
        [AppotaGameSDK configure];
        [AppotaGameSDK sharedInstance].delegate = [AppotaWrapper sharedInstance];
    }
    
    const void setSDKButtonVisibility(bool isVisible) {
        [[AppotaGameSDK sharedInstance] setSDKButtonVisibility:isVisible];
    }
    
    const void setAutoShowLogin(bool autoShowLogin) {
        [[AppotaGameSDK sharedInstance] setAutoShowLoginDialog: autoShowLogin];
    }
    
    const void setHideWelcomeView(bool property) {
        [[AppotaGameSDK sharedInstance] setHideWelcomeView: property];
    }

    const void setHidePaymentView(bool property) {
        [[AppotaGameSDK sharedInstance] setHidePaymentView: property];
    }
    
    const void setKeepLoginSession(bool isKeepLoginSession) {
        [[AppotaGameSDK sharedInstance] setKeepLoginSession:isKeepLoginSession];
    }
    
    const void inviteFacebookFriends(){
        [AppotaGameSDK inviteFacebookFriendsWithCompleteBlock:^(NSDictionary *dict) {
            
        } andErorrBlock:^(NSError *error) {
            
        }];
    }
    
    // User Functions
    const void showUserInfoView(){
        [AppotaGameSDK showUserInfoView];
    }
    
    const void showLoginView(){
        [AppotaGameSDK showLoginView];
    }
    
    const void showGoogleLogin(){
        [AppotaGameSDK showGoogleLogin];
    }
    
    const void showFacebookLogin(){
        [AppotaGameSDK showFacebookLogin];
    }
    
    const void showFacebookLoginWithPermissions(const char *permissions){
        NSString *_permissions = [NSString stringWithUTF8String:permissions];
        NSArray *permissionArray = [_permissions componentsSeparatedByString:@"|"];
        [AppotaGameSDK showFacebookLoginWithPermissions:permissionArray andWithCompleteBlock:^(AppotaUserLoginResult *object) {
            
        } andErrorBlock:^(NSError *error) {
            
        }];
    }
    
    const void showTwitterLogin(){
        [AppotaGameSDK showTwitterLogin];
    }
    
    const void showRegisterView(){
        [AppotaGameSDK showRegisterView];
    }
    
    const void switchAccount(){
        [AppotaGameSDK switchAccount];
    }
    
    const void showTransactionHistory(){
        [AppotaGameSDK showTransactionHistory];
    }
    
    const void logout(){
        [AppotaGameSDK logOut];
    }
    
    const bool isUserLoggedIn(){
        return [AppotaGameSDK isUserLoggedIn];
    }
    
    // Payment Functions
    const void showPaymentView(){
        [AppotaGameSDK showPaymentView];
    }
    
    const void showPaymentViewWithPackageID(const char *packageID){
        [AppotaGameSDK showPaymentViewWithPackageID:[NSString stringWithUTF8String:packageID]];
    }
    
    const void sendStateToWrapper(const char *state){
        sharedMyInstance.wrapperPaymentState = cStringCopy(state);
    }
    
    const void setCharacter(const char *name, const char *characterID, const char *serverName, const char *serverID){
        [AppotaGameSDK setCharacterWithCharacterName: [NSString stringWithUTF8String:name] characterID:[NSString stringWithUTF8String:characterID] serverName:[NSString stringWithUTF8String:serverName] serverID:[NSString stringWithUTF8String:serverID] onCompleteBlock:^(NSDictionary *dict) {
            
        } onErrorBlock:^(NSError *error) {
            
        }];
    }
    
    const void closePaymentView(){
        [AppotaGameSDK closePaymentView];
    }
    
    // Track Functions
    const void sendEventWithCategoryWithValue(const char *category, const char *action, const char *label, int value){
        [AppotaGameSDK sendEventWithCategory:[NSString stringWithUTF8String:category] withEventAction:[NSString stringWithUTF8String:action] withLabel:[NSString stringWithUTF8String:label] withValue:value];
        
    }
    
    const void sendEventWithCategory(const char *category, const char *action, const char *label){
        [AppotaGameSDK sendEventWithCategory:[NSString stringWithUTF8String:category] withEventAction:[NSString stringWithUTF8String:action] withLabel:[NSString stringWithUTF8String:label]];
        
    }
    
    const void sendViewWithName(const char *name){
        [AppotaGameSDK sendViewWithName:[NSString stringWithUTF8String:name]];
    }
    
    // Notification Functions
    const void registerPushNotificationWithGroupName(const char *name){
        [AppotaGameSDK registerPushNotificationWithGroupName:[NSString stringWithUTF8String:name]];
    }
    
    // Facebook AppEvent functions
    const void fbLogEvent(const char *name){
        [FBSDKAppEvents logEvent:[NSString stringWithUTF8String:name]];
    }
    
    const void fbLogEventWithParameter(const char *name, double value, const char *parameters){
        NSDictionary *paramDictionary = [AppotaWrapper unpackToDictionary:[NSString stringWithUTF8String:parameters]];
        NSLog(@"FBLogEvent: %@", paramDictionary);
        [FBSDKAppEvents logEvent:[NSString stringWithUTF8String:name] valueToSum:value parameters:paramDictionary];
        
    }
}

#pragma mark - Gameconfig delegate

- (void) didCloseLoginView {
    NSLog(@"Close login view");
    UnitySendMessage("AppotaSDKReceiver", "OnCloseLoginView", "");
}

- (NSString*) getPaymentStateWithPackageID:(NSString *) packageID {
    return [NSString stringWithFormat:@"%s", sharedMyInstance.wrapperPaymentState];
}

/*
 * Callback after login
 */
- (void) didLoginSuccess:(AppotaUserLoginResult*) userLoginResult {
    NSLog(@"Login Success!!!");
    if (!userLoginResult.accessToken) {
        return;
    }
    NSString *email = userLoginResult.email ? userLoginResult.email : @"";
    NSString *json = @"{";
    json = [json stringByAppendingString:@"\"accessToken\":\""];
    json = [json stringByAppendingString:userLoginResult.accessToken];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"email\":\""];
    json = [json stringByAppendingString:email];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"userId\":\""];
    json = [json stringByAppendingString:userLoginResult.userID];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"username\":\""];
    json = [json stringByAppendingString:userLoginResult.userName];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"}"];
    
    UnitySendMessage("AppotaSDKReceiver", "OnLoginSuccess", [json UTF8String]);
    
    [FBSDKAppEvents logEvent:@"appota_mobile_complete_login"];
}

/*
 * Callback when login error
 */
- (void) didLoginErrorWithMessage:(NSString *)message withError:(NSError *)error {
    UnitySendMessage("AppotaSDKReceiver", "OnLoginError", [message UTF8String]);
}

/*
 * Callback after logout
 */
- (void) didLogOut:(NSString*) userName {
    NSLog(@"Logout %@", userName);
    NSString *temp = @"Logout %@";
    temp = [temp stringByAppendingString:userName];
    
    UnitySendMessage("AppotaSDKReceiver", "OnLogoutSuccess", [temp UTF8String]);
}

- (void) didPaymentSuccessWithResult:(AppotaPaymentResult*) paymentResult withPackage:(NSString *) packageID {
    NSString *json = @"{";
    json = [json stringByAppendingString:@"\"packageID\":\""];
    json = [json stringByAppendingString:packageID];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"amount\":\""];
    json = [json stringByAppendingString:[[NSNumber numberWithFloat:paymentResult.getAmountPaymentResult] stringValue]];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"currency\":\""];
    json = [json stringByAppendingString:paymentResult.currency];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"time\":\""];
    json = [json stringByAppendingString:paymentResult.time];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"transactionId\":\""];
    json = [json stringByAppendingString:paymentResult.transactionID];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"type\":\""];
    json = [json stringByAppendingString:paymentResult.type];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"\"productID\":\""];
    NSString *productID = paymentResult.appleProductID ? paymentResult.appleProductID : @"";
    json = [json stringByAppendingString:productID];
    json = [json stringByAppendingString:@"\","];
    json = [json stringByAppendingString:@"}"];
    
    UnitySendMessage("AppotaSDKReceiver", "OnPaymentSuccess", [json UTF8String]);
    
    // Purchase
    [FBSDKAppEvents logPurchase:[paymentResult getAmountPaymentResult] currency:[paymentResult currency]
                     parameters:@{FBSDKAppEventParameterNameContentType:[paymentResult type],
                                  FBSDKAppEventParameterNameContentID:[paymentResult packageID]}];
}

- (void) didPaymentErrorWithMessage:(NSString *)message withError:(NSError *)error {
    UnitySendMessage("AppotaSDKReceiver", "OnPaymentFailed", [message UTF8String]);
}

@end
