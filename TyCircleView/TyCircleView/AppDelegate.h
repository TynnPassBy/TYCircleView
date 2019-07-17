//
//  AppDelegate.h
//  TyCircleView
//
//  Created by 刘庆贺 on 2019/7/17.
//  Copyright © 2019 Tynn丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

