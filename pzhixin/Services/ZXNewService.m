//
//  ZXNewService.m
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewService.h"
#import "ZXLoginViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

static ZXNewService *serviceManager = nil;
static AFHTTPSessionManager *sessionManager = nil;

@implementation ZXNewService

- (id)init {
    self = [super init];
    if (self) {
        [self initOpreationManager];
    }
    return self;
}

+ (ZXNewService *)sharedManager {
    if (serviceManager == nil) {
        serviceManager = [[ZXNewService alloc] init];
    }
    return serviceManager;
}

- (void)initOpreationManager {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setTimeoutIntervalForRequest:10.0];
    sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableSet *typeSet = [NSMutableSet setWithSet:sessionManager.responseSerializer.acceptableContentTypes];
    [typeSet addObject:@"text/html"];
    [typeSet addObject:@"text/plain"];
    [typeSet addObject:@"image/png"];
    sessionManager.responseSerializer.acceptableContentTypes = typeSet;
}

#pragma mark - POST请求

- (void)postRequestWithUri:(NSString *)inUri
             andParameters:(NSMutableDictionary *)inParameters
           completionBlock:(void (^)(ZXResponse * response))completionBlock
                errorBlock:(void (^)(ZXResponse * response))errorBlock {
    //获取时间戳
    NSString *timeStamp = [[UtilsMacro getNowTimeTimestamp] substringWithRange:NSMakeRange(0, 10)];
    //获取APP当前版本
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //平台 iOS=1 Android=2
    NSString *platformStr = @"1";
    //imei
    NSString *imeiStr = [UtilsMacro fetchUUID];
    if (timeStamp) {
        [inParameters addEntriesFromDictionary:@{@"time":timeStamp}];
    }
    if (versionStr) {
        [inParameters addEntriesFromDictionary:@{@"version":versionStr}];
    }
    [inParameters addEntriesFromDictionary:@{@"platform":platformStr}];
    if (imeiStr) {
        [inParameters addEntriesFromDictionary:@{@"imei":imeiStr}];
    }
    
    [inParameters addEntriesFromDictionary:@{@"token":[UtilsMacro sha1WithString:[NSString stringWithFormat:@"%@%@",[UtilsMacro MD5ForLower32Bate:[UtilsMacro sortedDictionary:inParameters]],[UtilsMacro MD5ForLower32Bate:@"PZhiXin"]]]}];
    
//    NSLog(@"inParameters:%@",[UtilsMacro DataTOjsonString:inParameters]);
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZX_FORMAL_SERVER_URI, inUri];
    [self requestWithUrl:urlString andParameters:inParameters completionBlock:completionBlock errorBlock:errorBlock];
}

- (void)requestWithUrl:(NSString *)inUrl
         andParameters:(NSDictionary *)inParameters
         completionBlock:(void (^)(ZXResponse * response))completionBlock
              errorBlock:(void (^)(ZXResponse * response))errorBlock {
    NSString *urlString = inUrl;
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"urlString:%@", urlString);
    NSString *url = [[NSURL URLWithString:urlString] absoluteString];
    //创建一个请求对象，并这是请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    NSError *parseError = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:inParameters options:NSJSONWritingPrettyPrinted error:&parseError];
    request.HTTPBody = bodyData;
    //设置HTTPHeader中Content-Type的值
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", (int)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    [sessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    //在请求头添加authorization
    if ([[ZXLoginHelper sharedInstance] authorization] != nil) {
        [sessionManager.requestSerializer setValue:[[ZXLoginHelper sharedInstance] authorization] forHTTPHeaderField:@"authorization"];
    }
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"charset=utf-8", @"application/json", @"text/json", @"text/javascript", @"application/x-json", @"text/html", @"text/plain", nil];
    
    //用于区分初始化接口和其他接口，初始化接口的completionQueue不能设置为主线程，否则会导致APP启动时设置信号量等待形成死锁！！！
    if ([inUrl rangeOfString:APP_CONFIG].location != NSNotFound) {
        sessionManager.completionQueue = dispatch_get_global_queue(0, 0);
    } else {
        sessionManager.completionQueue = dispatch_get_main_queue();
    }
    
    [sessionManager POST:url parameters:inParameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"result:%@",[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        ZXResponse *response = [ZXResponse yy_modelWithJSON:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]];
        if (response != nil && ![response isEqual:[NSNull null]]) {
            if (response.status == UN_LOGIN || response.status == OTHER_PLACE_LOGIN || response.status == LOGIN_PAST_DUE) {
                //清除本地用户信息
                [[ZXLoginHelper sharedInstance] setLoginState:NO];
                [[ZXLoginHelper sharedInstance] setAuthorization:@""];
                [[ZXDatabaseUtil sharedDataBase] clearUserWithUser:[[ZXMyHelper sharedInstance] userInfo]];
                [[ZXMyHelper sharedInstance] setUserInfo:[[ZXUser alloc] init]];
                [[ZXTBAuthHelper sharedInstance] setTBAuthState:NO];
                [[ALBBSDK sharedInstance] logout];
                
                //唤起登录页
                ZXLoginViewController *loginVC = [[ZXLoginViewController alloc] init];
                [loginVC setTabIndex:[[[AppDelegate sharedInstance] homeTabBarController] selectedIndex]];
                UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                [[[[AppDelegate sharedInstance] homeTabBarController] selectedViewController] presentViewController:loginNavi animated:YES completion:nil];
                [ZXProgressHUD hideAllHUD];
                errorBlock(response);
                return;
            }
            if (response.status == 200) {
                if (completionBlock) {
                    completionBlock(response);
                }
                return;
            }
            if (errorBlock) {
                errorBlock(response);
            }
            return;
        } else {
            if (errorBlock) {
                ZXResponse *response = [[ZXResponse alloc] init];
                [response setInfo:@"请求失败"];
                [response setData:@{}];
                [response setStatus:-1];
                errorBlock(response);
            }
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            if (errorBlock) {
                ZXResponse *response = [[ZXResponse alloc] init];
                [response setInfo:@"请求超时"];
                [response setData:@{}];
                [response setStatus:-1001];
                errorBlock(response);
            }
            return;
        }
        if (error.code == -999) {
            return;
        }
        ZXResponse *response = [[ZXResponse alloc] init];
        [response setInfo:@"请求失败"];
        [response setData:@{}];
        [response setStatus:-1];
        errorBlock(response);
        return;
    }];
}

#pragma mark - GET

- (void)getRequestWithUri:(NSString *)inUri
          completionBlock:(void (^)(id result))completionBlock
               errorBlock:(void (^)(ZXResponse *response))errorBlock {
    NSString *urlString = [inUri stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"GET";
    [sessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"charset=utf-8", @"application/json", @"text/json", @"text/javascript", @"application/x-json", @"text/html", @"text/plain", nil];
    [sessionManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"版本检测更新失败");
        ZXResponse *response = [[ZXResponse alloc] init];
        response.status = -1;
        response.data = @{};
        response.info = @"请求失败";
        errorBlock(response);
    }];
}

#pragma mark - 取消当前请求

- (void)cancelCurrentRequest {
    if ([sessionManager.tasks count] > 0) {
        [sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

@end
