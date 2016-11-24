//
//  HttpRequest.h
//  12365auto
//
//  Created by bangong on 16/3/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLFile.h"
@class  UIImage;

@interface HttpRequest : NSObject

+ (BOOL)connectedToNetwork;

/**GET请求*/
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure;
/**附带网络策略GET请求*/
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                       policy:(NSURLRequestCachePolicy)policy
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure;
/**POST请求*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure;

/**上传单单张图片*/
+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image
                                url:(NSString *)URLString
                           fileName:(NSString *)name
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError * error))failure;

/**批量上传图片*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                        images:(NSArray <__kindof UIImage *> *)images
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError * error))failure;



@end
