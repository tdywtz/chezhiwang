//
//  HttpRequest.m
//  12365auto
//
//  Created by bangong on 16/3/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import <netinet/in.h>

@implementation HttpRequest

/**检测网络是否可用*/
+ (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        // printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (AFHTTPSessionManager *)sessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",@"text/plain",
                                                         @"text/html",@"application/x-javascript",@"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = 10;
    return manager;
}

/**GET请求*/
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure{
 NSLog(@"%@",URLString);
    //汉子编码处理
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //默认的缓存策略， 如果缓存不存在，直接从服务端获取。如果缓存存在，会根据response中的Cache-Control字段判断下一步操作，如: Cache-Control字段为must-revalidata, 则询问服务端该数据是否有更新，无更新的话直接返回给用户缓存数据，若已更新，则请求服务端.
    NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;
    if ([self connectedToNetwork] == NO) {
        policy = NSURLRequestReturnCacheDataElseLoad;//取本地缓存
    }
    AFHTTPSessionManager *session = [self sessionManager];
    session.requestSerializer.cachePolicy = policy;
    
    NSURLSessionDataTask *task = [session GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    return task;
}

/**附带网络策略GET请求*/
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                       policy:(NSURLRequestCachePolicy)policy
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError * error))failure{
    //汉子编码处理
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPSessionManager *session = [self sessionManager];
    session.requestSerializer.cachePolicy = policy;
    
    NSURLSessionDataTask *task = [session GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

/**POST请求*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError * error))failure{
  
    NSURLSessionDataTask *task = [[self sessionManager] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

/**上传单单张图片*/
+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image
                                url:(NSString *)URLString
                           fileName:(NSString *)name
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError * error))failure{
    
    
    return  [[self sessionManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [formData appendPartWithFileData:data name:@"" fileName:name mimeType:@"image/jpg/file"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}

/**批量上传图片*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                        images:(NSArray <__kindof UIImage *> *)images
                       success:(void (^)(id _Nullable responseObject))success
                       failure:(void (^)(NSError * _Nonnull error))failure{
    
    NSURLSessionDataTask *task = [[self sessionManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0;i < images.count ; i++) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *name = [NSString stringWithFormat:@"%d",i];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,i];
            NSData *date = UIImageJPEGRepresentation(images[i], 1);
            [formData appendPartWithFileData:date name:name fileName:fileName mimeType:@"image/jpg/file"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    return task;
}

@end
