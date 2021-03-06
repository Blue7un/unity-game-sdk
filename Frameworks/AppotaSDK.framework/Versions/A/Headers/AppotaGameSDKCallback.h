//
//  AppotaSDKCallback.h
//  AppotaSDK
//
//  Created by Tue Nguyen on 11/18/14.
//
//

#import <Foundation/Foundation.h>
#import "AppotaPaymentResult.h"
#import "AppotaUserLoginResult.h"

@protocol AppotaGameSDKCallback <NSObject>

@optional
/*
 * Callback after close loginview
 */
- (void) didCloseLoginView;
/*
 * Callback when login error
 */
- (void) didLoginErrorWithMessage:(NSString *)message withError:(NSError *)error;
/*
 * Callback when payment error
 */
- (void) didPaymentErrorWithMessage:(NSString *)message withError:(NSError *)error;
/*
 * Callback when close Payment View
 */
- (void) didClosePaymentView;
/*
 * Callback update userInfo
 */
- (void) didUpdateUserInfo:(AppotaUserLoginResult *)userLoginResult;


@required
/**
 *  Get payment state base on AppotaPaymentPackage
 *
 *  @return PAYMENT_STATE
 */
- (NSString*) getPaymentStateWithPackageID:(NSString *) packageID;

/*
 * Callback after login
 */
- (void) didLoginSuccess:(AppotaUserLoginResult*) userLoginResult;
/*
 * Callback after logout
 */
- (void) didLogOut:(NSString*) userName;
/*
 * Callback when Payment success
 */
- (void) didPaymentSuccessWithResult:(AppotaPaymentResult*) paymentResult withPackage:(NSString *) packageID;

@end