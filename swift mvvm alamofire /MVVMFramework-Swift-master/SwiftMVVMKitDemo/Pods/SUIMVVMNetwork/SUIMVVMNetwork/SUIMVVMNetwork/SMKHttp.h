//
//  SMKHttp.h
//  DevelopFramework
//
//  Created by momo on 15/12/23.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  请求成功block
 */
typedef void (^requestSuccessBlock)(id responseObj);

/**
 *  请求失败block
 */
typedef void (^requestFailureBlock) (NSError *error);

/**
 *  请求响应block
 */
typedef void (^responseBlock)(id dataObj, NSError *error);

/**
 *  监听进度响应block
 */
typedef void (^progressBlock)(NSProgress * progress);


typedef NS_ENUM(NSUInteger, SMKHttpRequestCachePolicy){
    /** 不作任何处理，只请求数据 */
    SMKHttpReturnDefault = 0,
    /** 有缓存就先返回缓存，同步请求数据 */
    SMKHttpReturnCacheDataThenLoad,
    /** 忽略缓存，重新请求 */
    SMKHttpReloadIgnoringLocalCacheData,
    /** 有缓存就用缓存，没有缓存就重新请求(用于数据不变时) */
    SMKHttpReturnCacheDataElseLoad,
    /** 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）*/
    SMKHttpReturnCacheDataDontLoad
};

#pragma mark - 定义请求工具类

@class SMKHttpFileConfig;

@interface SMKHttp : NSObject

/**
 *  请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 *  创建单例对象
 */
+ (instancetype)defaultHttp;

/**
 *  移除所有缓存
 */
+ (void)removeAllCaches;

/**
 *  取消所有网络请求
 */
+ (void)cancelAllOperations;

/**
 *  GET请求 - 默认 MVVMHttpReloadIgnoringLocalCacheData 的缓存方式
 */
+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(requestSuccessBlock)successHandler
    failure:(requestFailureBlock)failureHandler;

/**
 *  POST请求 - 默认 MVVMHttpReloadIgnoringLocalCacheData 的缓存方式
 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(requestSuccessBlock)successHandler
     failure:(requestFailureBlock)failureHandler;

/**
 *  GET请求
 */
+ (void)get:(NSString *)url
     params:(NSDictionary *)params
cachePolicy:(SMKHttpRequestCachePolicy)cachePolicy
    success:(requestSuccessBlock)successHandler
    failure:(requestFailureBlock)failureHandler;

/**
 *  POST请求
 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
 cachePolicy:(SMKHttpRequestCachePolicy)cachePolicy
     success:(requestSuccessBlock)successHandler
     failure:(requestFailureBlock)failureHandler;

/**
 *  PUT请求
 */
+ (void)put:(NSString *)url
     params:(NSDictionary *)params
    success:(requestSuccessBlock)successHandler
    failure:(requestFailureBlock)failureHandler;

/**
 *  DELETE请求
 */
+ (void)deleteWithUrl:(NSString *)url
    params:(NSDictionary *)params
    success:(requestSuccessBlock)successHandler
    failure:(requestFailureBlock)failureHandler;

/**
 *  下载文件，监听下载进度
 */
+ (void)download:(NSString *)url
successAndProgress:(progressBlock)progressHandler
        complete:(responseBlock)completionHandler;

/**
 *  文件上传
 */
+ (void)upload:(NSString *)url
        params:(NSDictionary *)params fileConfig:(SMKHttpFileConfig *)fileConfig
       success:(requestSuccessBlock)successHandler
       failure:(requestFailureBlock)failureHandler;

/**
 *   文件上传，监听上传进度
 */
+ (void)upload:(NSString *)url
        params:(NSDictionary *)params
    fileConfig:(SMKHttpFileConfig *)fileConfig
successAndProgress:(progressBlock)progressHandler
      complete:(responseBlock)completionHandler;

@end


/**
 *  用来封装上文件数据的模型类
 */
@interface SMKHttpFileConfig : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *fileData;

/**
 *  服务器接收参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

+ (instancetype)fileConfigWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

- (instancetype)initWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
