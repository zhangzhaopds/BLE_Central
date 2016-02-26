//
//  PeripheralVC.m
//  BLE_Central
//
//  Created by 张昭 on 16/2/25.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import "PeripheralVC.h"
#import "CharacheristicVC.h"

@interface PeripheralVC ()<CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CBPeripheral *per;

@property (nonatomic, strong) NSMutableArray *services;

@end

@implementation PeripheralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.services = [NSMutableArray array];
    
    self.title = @"Services";
    
    // 初始化并设置委托和线程队列，默认main线程
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerOptionShowPowerAlertKey, nil];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.rowHeight = 200;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.centralManager stopScan];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.centralManager != nil) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        [self.services removeAllObjects];
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
    if ([peripheral.name isEqualToString:self.peripheral.name]) {
        NSLog(@"faxian");
        self.per = peripheral;
        [self.centralManager connectPeripheral:self.per options:nil];
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接成功：%@", peripheral.name);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"找到服务：%@", peripheral.services);
    [self.services removeAllObjects];
    for (CBService *ser in peripheral.services) {
        [self.services addObject:ser];
    }
    
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    CBService *ser = [self.services objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\nUUID=%@\nperipheral=%@", ser, ser.UUID, ser.peripheral];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacheristicVC *ch = [[CharacheristicVC alloc] init];
    ch.myService = [self.services objectAtIndex:indexPath.row];
    ch.myPeripheral = self.per;
    [self.navigationController pushViewController:ch animated:YES];
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
