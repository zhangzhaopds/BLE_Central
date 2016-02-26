//
//  DescriptionVC.m
//  BLE_Central
//
//  Created by 张昭 on 16/2/25.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import "DescriptionVC.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DescriptionVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;


@end

@implementation DescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Description";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.rowHeight = 200;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    CBDescriptor *desc = [self.dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", desc];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
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
