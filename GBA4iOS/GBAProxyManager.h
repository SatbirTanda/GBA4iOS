//
//  GBAProxyManager.h
//  GBA4iOS
//
//  Created by Tanda, Satbir (S.S.) on 12/3/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBAProxyManager : NSObject

+ (instancetype)sharedInstance;

- (void)connect;

@end

NS_ASSUME_NONNULL_END
