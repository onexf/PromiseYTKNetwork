结合PromiseKit和YTKNetwork的网络请求组件，地址：[PromiseYTKNetwork](https://github.com/onexf/PromiseYTKNetwork)

## 一、 安装

```
pod 'PromiseYTKNetwork'
```

## 二、 配置

### 1. 配置`baseurl`
这里监听了App启动设置基本配置
切换环境时重新配置即可
```

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initThirdSDKsWhenApplicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

+ (void)initThirdSDKsWhenApplicationDidFinishLaunching:(NSNotification *)info {
    NSLog(@"%@", info.userInfo);
    
    YTKNetworkConfig *networkConfig = [YTKNetworkConfig sharedConfig];
    // 配置域名
    networkConfig.baseUrl = API_HOST;
    // 资源域名
    networkConfig.cdnUrl = API_json_HOST;
    
}

```

### 2. 配置基本请求

##### 1. 新建类继承`PromiseRequest`


```
#import "PromiseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTPromiseRequest : PromiseRequest

@end

NS_ASSUME_NONNULL_END

```

##### 2. 实现相关方法



```
#import "BTPromiseRequest.h"

@implementation BTPromiseRequest

/// 设置请求头，验签
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {

    NSMutableDictionary *requestSerializers = [NSMutableDictionary dictionary];

    requestSerializers[@"Content-Type"] = @"application/json";

    requestSerializers[@"User-Agent"] = userAgent;

    requestSerializers[@"platform"] = @"iOSApp";

    requestSerializers[@"version"] = [NSString stringWithFormat:@"V-%@", kAppVersion];






    if (token) {

        requestSerializers[@"X-bt-Json-Api-Token"] = token;

        NSString *timeNum = timeNum;
        requestSerializers[@"X-bt-Json-Api-Signature-Timestamp"] = timeNum;

        NSString *randomNum = [NSString stringWithFormat:@"%d",arc4random() % 10000];
        requestSerializers[@"X-bt-Json-Api-Nonce"] = randomNum;

        NSString *Signature = [PUB_INTERFACE sha1:[NSString stringWithFormat:@"%@%@%@", token, randomNum, timeNum]];
        requestSerializers[@"X-bt-Json-Api-Signature"] = Signature;
    }

    return requestSerializers;
}


/// 超时时间
- (NSTimeInterval)requestTimeoutInterval {
    return 15;
}

@end

```

其他主要可设置的配置

* 取消请求

    ```
    - (void)stop;
    ```
    
* 特殊请求设置域名
```
- (NSString *)baseUrl;
```

* 设置请求路径
```
- (NSString *)requestUrl;
```

* 设置资源域名
```
- (NSString *)cdnUrl;
```

* 设置请求参数
```
- (nullable id)requestArgument;
```

* 设置请求方式
```
- (YTKRequestMethod)requestMethod;
```

* 请求和接收解析类型
```
- (YTKRequestSerializerType)requestSerializerType;
```

    ```
    - (YTKResponseSerializerType)responseSerializerType;
    
    ```
    
### 3. 发送请求


```
/// 发起请求
- (AnyPromise *)launch;

```

    
### 4. 使用

##### 1. 基本使用

* OC

    接口： `banner/index`

    新建`HomeBannerRequest`继承自`BTPromiseRequest`
    
    ```
    #import "HomeBannerRequest.h"
    
    @implementation HomeBannerRequest
    
    
    - (NSString *)requestUrl {
        return @"/banner/index";
    }
    
    
    - (YTKRequestMethod)requestMethod {
        
        return YTKRequestMethodPOST;
    }
    
    @end
    
    ```
    
    发送请求监听结果
        
    ```
        HomeBannerRequest *bannerReq = [[HomeBannerRequest alloc] init];
        
        [bannerReq launch].then(^(NSDictionary *response) {
            NSLog(@"🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩%@", response);
        }).catch(^(NSError *error){
            NSLog(@"🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩%@", error);
        }).ensure(^{ // 隐藏HUD
            NSLog(@"无论成功还是失败，都结束了");
        });
        
        // 取消请求
    //    [bannerReq stop];
    
    ```
    打印结果：

    ![](https://user-gold-cdn.xitu.io/2020/7/20/1736b64e2efc07c6?w=1814&h=692&f=png&s=648562)

* Swift

    接口： `/Invoice/Order/List`


    ```
    /// 可开票订单
    class InvoiceOrderListRequest: BTPromiseRequest {
        
        
        /// 请求方式
        override func requestMethod() -> YTKRequestMethod {
            return .POST
        }
    
        /// 接口路径
        override func requestUrl() -> String {
            return "/Invoice/Order/List"
        }
        
        /// 统一域名，通过YTKNetworkConfig配置，yapi地址这里也可以重写
        override func baseUrl() -> String {
            return "http://yapi.bt.com"
        }
        
    
        
    }
    ```
    
    发送
```
    /// 请求数据
    func loadNewData() {
        
        let request = InvoiceOrderListRequest()

        request.launch().done { response in
            
           
        }.catch { error in
            let errMsg = error.localizedDescription
        }.finally {
            self.tableView.mj_header.endRefreshing()
        }
    }
```
结果

![](https://user-gold-cdn.xitu.io/2020/7/20/1736b666f96a7c23?w=1626&h=1458&f=png&s=905123)

##### 2. 带参数请求
* OC

    接口： /Customer/Goods/QueryCategoryGoods

    请求类：`QueryCategoryGoodsRequest`
    
    ```
    #import "BTPromiseRequest.h"
    
    NS_ASSUME_NONNULL_BEGIN
    
    @interface QueryCategoryGoodsRequest : BTPromiseRequest
    
    
    - (instancetype)initWithCategoryCode:(NSString *)categoryCode channel:(NSString *)channel;
    
    @end
    
    NS_ASSUME_NONNULL_END
    
    ```
        
    ```
    #import "QueryCategoryGoodsRequest.h"
    
    @implementation QueryCategoryGoodsRequest {
        /// 分类编码
        NSString *_categoryCode;
        /// 渠道，1：鼓励师推荐  2：其他
        NSString *_channel;
    }
    
    - (instancetype)initWithCategoryCode:(NSString *)categoryCode channel:(NSString *)channel {
        
        if (self = [super init]) {
            _categoryCode = categoryCode;
            _channel = channel;
        }
        return self;
    }
    
    - (id)requestArgument {
        return @{
            @"categoryCode": _categoryCode,
            @"channel": _channel
        };
    }
    
    - (NSString *)requestUrl {
        return @"/Customer/Goods/QueryCategoryGoods";
    }
    
    - (YTKRequestMethod)requestMethod {
        
        return YTKRequestMethodPOST;
    }
    
    
    @end
    
    ```
    
    使用：
    
    ```
        QueryCategoryGoodsRequest *queryCategoryGoodsRequest = [[QueryCategoryGoodsRequest alloc] initWithCategoryCode:@"010401" channel:@"2"];
        [queryCategoryGoodsRequest launch].then(^(NSDictionary *response) {
            NSLog(@"🌲🌲🌲🌲🌲🌲🌲🌲🌲🌲%@", response);
        }).catch(^(NSError *error){
            NSLog(@"🌲🌲🌲🌲🌲🌲🌲🌲🌲🌲%@", error);
        }).ensure(^{ // 隐藏HUD
            NSLog(@"无论成功还是失败，都结束了");
        });
    ```
    
    结果：

    ![](https://user-gold-cdn.xitu.io/2020/7/20/1736b6213d2a0de7?w=2428&h=1094&f=png&s=1054642)

* Swift

    接口： `/Invoice/Submit`


    ```
    
    class InvoiceCommitRequest: BTPromiseRequest {
    
        private var invoiceTitle: String?
        
        private var taxNo: String?
        
        private var buyerType: String?
    
        private var invoiceItems: [Dictionary<String, Any>]?
    
        private var email: String?
    
        init(invoiceTitle: String, taxNo: String, buyerType: String, invoiceItems: [Dictionary<String, Any>], email: String) {
            super.init()
            self.invoiceTitle = invoiceTitle
            self.taxNo = taxNo
            self.buyerType = buyerType
            self.invoiceItems = invoiceItems
            self.email = email
        }
        
        /// 设置
        /// - Returns: 请求参数
        override func requestArgument() -> Any {
            let params = [
                "invoiceTitle": invoiceTitle!,
                "taxNo": taxNo!,
                "buyerType": buyerType!,
                "invoiceItems": invoiceItems!,
                "email": email!
            ] as [String : Any]
                    
            return params
        }
        
        override func requestMethod() -> YTKRequestMethod {
            return .POST
        }
    
        override func requestUrl() -> String {
            return "/Invoice/Submit"
        }
        
    }
    
    ```
    
    使用： 
```
    @IBAction func commitData(_ sender: CustomBtn) {
        
        let buyerType = invoiceType == .personal ? "03" : "01"
        
        let request = InvoiceCommitRequest(invoiceTitle: invoiceTitle!, taxNo: taxNo!, buyerType: buyerType, invoiceItems: invoiceItems!, email: email!)
        request.launch().done { response in
        }.catch { error in
        }
        
    }
```

结果：
![](https://user-gold-cdn.xitu.io/2020/7/20/1736b625cbe8fb86?w=2616&h=888&f=png&s=628912)


##### 3. 链式（嵌套）请求

第一个请求： `/Bigclass/Course/Detail`

```
#import "BTPromiseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BigclassCourseDetailRequest : BTPromiseRequest


- (instancetype)initWithSubjectId:(NSString *)subjectId StudyId:(NSString *)myStudyId;


@end

NS_ASSUME_NONNULL_END

```


```
#import "BigclassCourseDetailRequest.h"

@implementation BigclassCourseDetailRequest {
    
    
    NSString *_subjectId;
    
    NSString *_myStudyId;
    
}



- (instancetype)initWithSubjectId:(NSString *)subjectId StudyId:(NSString *)myStudyId {
    
    if (self = [super init]) {
        _subjectId = subjectId;
        _myStudyId = myStudyId;
    }
    return self;

}



- (id)requestArgument {
    return @{
        @"subjectId": _subjectId,
        @"myStudyId": _myStudyId,
        @"version": @""
    };
}

- (NSString *)requestUrl {
    return @"/Bigclass/Course/Detail";
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}



@end

```
第二个请求： `/Bigclass/Course/progressData`


```
#import "BTPromiseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BigclassCourseprogressDataRequest : BTPromiseRequest


- (instancetype)initWithSubjectId:(NSString *)subjectId StudyId:(NSString *)myStudyId version:(NSString *)version;

@end

NS_ASSUME_NONNULL_END

```


```

#import "BigclassCourseprogressDataRequest.h"

@implementation BigclassCourseprogressDataRequest {
    
    
    NSString *_subjectId;
    
    NSString *_myStudyId;
    
    NSString *_version;
}


- (instancetype)initWithSubjectId:(NSString *)subjectId StudyId:(NSString *)myStudyId version:(NSString *)version {
    if (self = [super init]) {
        _subjectId = subjectId;
        _myStudyId = myStudyId;
        _version = version;
    }
    return self;

}


- (id)requestArgument {
    return @{
        @"subjectId": _subjectId,
        @"myStudyId": _myStudyId,
        @"version": _version
    };
}


- (NSString *)requestUrl {
    return @"/Bigclass/Course/progressData";
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}



@end

```

使用：

```
    
    BigclassCourseDetailRequest *courseDetailRequest = [[BigclassCourseDetailRequest alloc] initWithSubjectId:self.SubjectId StudyId:self.myStudyId];
    [courseDetailRequest launch].then(^(NSDictionary *response) { // 第一个请求结果
        NSString *version = response[@"message"][@"version"];
        
        BigclassCourseprogressDataRequest *courseprogressDataRequest = [[BigclassCourseprogressDataRequest alloc] initWithSubjectId:self.SubjectId StudyId:self.myStudyId version:version];
        
        return [courseprogressDataRequest launch];
        
    }).then(^(NSDictionary *response) { // 第二个请求结果

        NSLog(@"%@", response);
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
    });

```

结果： 

![](https://user-gold-cdn.xitu.io/2020/7/20/1736b632783b7279?w=2390&h=1202&f=png&s=1110916)


![](https://user-gold-cdn.xitu.io/2020/7/20/1736b634d6ff8507?w=1958&h=958&f=png&s=735849)
##### 4. 组合（同时发起）请求
前者接口2
接口3： `/Class/Trial`


```

#import "ClassTrialRequest.h"

@implementation ClassTrialRequest {
    
    
    NSString *_subjectId;
    
    NSString *_myStudyId;
    
}




- (instancetype)initWithSubjectId:(NSString *)subjectId StudyId:(NSString *)myStudyId {
    
    if (self = [super init]) {
        _subjectId = subjectId;
        _myStudyId = myStudyId;
    }
    return self;

}



- (id)requestArgument {
    return @{
        @"subjectId": _subjectId,
        @"myStudyId": _myStudyId,
    };
}

- (NSString *)requestUrl {
    return @"/Class/Trial";
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}


```

使用：

```
    BigclassCourseDetailRequest *courseDetailRequest = [[BigclassCourseDetailRequest alloc] initWithSubjectId:self.SubjectId StudyId:self.myStudyId];
    [courseDetailRequest launch].then(^(NSDictionary *response) { // 第一个请求结果
        
        NSLog(@"第一个请求：%@", response);
        NSString *version = response[@"message"][@"version"];
        // 第二个
        BigclassCourseprogressDataRequest *courseprogressDataRequest = [[BigclassCourseprogressDataRequest alloc] initWithSubjectId:self.SubjectId StudyId:self.myStudyId version:version];
        // 第三个
        ClassTrialRequest *trialRequest = [[ClassTrialRequest alloc] initWithSubjectId:self.SubjectId StudyId:self.myStudyId];
        
        
        return PMKWhen(@[[courseprogressDataRequest launch], [trialRequest launch]]);
//        return [courseprogressDataRequest launch];
        
    }).then(^(NSArray <NSDictionary *> *responseArray) { // 组合请求结果

        NSLog(@"第二、三个请求：%@", responseArray);
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
    });

```


结果：

![](https://user-gold-cdn.xitu.io/2020/7/20/1736b6378d26f729?w=2060&h=1018&f=png&s=969444)
