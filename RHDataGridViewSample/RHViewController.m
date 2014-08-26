//
//  RHViewController.m
//  RHDataGridViewSample
//
//  Created by Ron Hu on 8/26/14.
//
//

#import "RHViewController.h"

@interface RHViewController ()
@property(strong,nonatomic)NSArray *headers;
@property(strong,nonatomic)NSMutableArray *data;
@property(strong,nonatomic)NSMutableArray *columnWidth;
@property (weak, nonatomic) IBOutlet RHDataGridView *tableView;

@end

@implementation RHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self prepareData];
    
    self.tableView.dataSource = self.tableView;
    self.tableView.delegate = self.tableView;
    self.tableView.dataGridViewDelegate = self;
}
-(void)prepareData{
    self.headers = [NSArray arrayWithObjects:@"Name",@"Age", @"Location",@"Tall",@"Job", nil];
    
    NSArray *row1 = [NSArray arrayWithObjects:@"Jack",@"2",@"Shanghai",@"18",@"Engineer", nil];
    NSArray *row2 = [NSArray arrayWithObjects:@"Boo",@"23",@"Shanghai",@"18",@"Software Engineer", nil];
    
    self.data = [[NSMutableArray alloc] init];
    [self.data addObject:row1];
    [self.data addObject:row2];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfColumnsInDataGridView:(RHDataGridView *)dataGridView{
    return [self.headers count];
}
-(NSInteger)numberOfRowsInDataGridView:(RHDataGridView *)dataGridView{
    return [self.data count];
}

-(NSString *)dataGridView:(RHDataGridView *)dataGridView titleForColumnAtIndex:(NSInteger)columnIndex{
    return [self.headers objectAtIndex:columnIndex];
}
-(NSInteger)dataGridView:(RHDataGridView *)dataGridView heightForRowAtIndex:(NSInteger)rowIndex{
    return 44;
}
-(NSInteger)dataGridView:(RHDataGridView *)dataGridView widthForColumnAtIndex:(NSInteger)columnIndex{
    // NSInteger width = [self.headers[columnIndex] sizeWithFont:UIFontTextStyleBody];
    
    return 100;
}
-(UIView *)dataGridView:(RHDataGridView *)dataGridView cellForRowAtIndex:(NSInteger)rowIndex columnAtIndex:(NSInteger)columnIndex{
    NSArray *rowData = [self.data objectAtIndex:rowIndex];
    NSString *text = [rowData objectAtIndex:columnIndex];
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    
    return label;
}

@end
