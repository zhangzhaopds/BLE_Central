//
//  CharacheristicVC.h
//  BLE_Central
//
//  Created by 张昭 on 16/2/25.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CharacheristicVC : UIViewController

@property (nonatomic, strong) CBService *myService;
@property (nonatomic, strong) CBPeripheral *myPeripheral;
@end
