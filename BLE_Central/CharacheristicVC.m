//
//  CharacheristicVC.m
//  BLE_Central
//
//  Created by 张昭 on 16/2/25.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import "CharacheristicVC.h"
#import "DescriptionVC.h"

@interface CharacheristicVC ()<CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CBPeripheral *per;

@property (nonatomic, strong) NSMutableArray *charaArr;
@property (nonatomic, strong) NSMutableArray *descArr;


@end

@implementation CharacheristicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.charaArr = [NSMutableArray array];
    self.descArr = [NSMutableArray array];
    
    self.title = @"Characheristic";
    
    // 初始化并设置委托和线程队列，默认main线程
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerOptionShowPowerAlertKey, nil];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];

    self.tableView.rowHeight = 200;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.centralManager != nil) {
        [self.tableView reloadData];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([self.myPeripheral.name isEqualToString:peripheral.name]) {
        self.per = peripheral;
        [self.centralManager connectPeripheral:self.per options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:self.myService.UUID]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"%ld", service.characteristics.count);
    for (CBCharacteristic *ch in service.characteristics) {
        [self.charaArr addObject:ch];
        [peripheral discoverDescriptorsForCharacteristic:ch];
    }
//    [self.tableView reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    [self.descArr addObject:characteristic.descriptors];
    NSLog(@"%@", self.descArr);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.charaArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    CBCharacteristic *ch = [self.charaArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\nUUID=%@\nservice=%@\nvalue=%@\ndescriptors=%@\nproperties=%lu\nisNotifying=%@", ch, ch.UUID, ch.service, ch.value, ch.descriptors, (unsigned long)ch.properties, ch.isNotifying];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DescriptionVC *desc = [[DescriptionVC alloc] init];
    desc.dataArr = [NSMutableArray array];
    [desc.dataArr addObject:[self.descArr objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:desc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
