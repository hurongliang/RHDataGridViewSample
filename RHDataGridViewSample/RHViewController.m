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
@property (weak, nonatomic) IBOutlet RHDataGridView *tableView;

@end

@implementation RHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self prepareData];
    self.tableView.columnSpacing = 20;
    self.tableView.dataGridViewDelegate = self;
    
    for(NSInteger i=0;i<[self.tableView numberOfRowsInSection:0];i++){
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
}
-(void)prepareData{
    self.headers = [NSArray arrayWithObjects:@"Name",@"Age", @"Location",@"Tall",@"Job", nil];
    
    self.data = [[NSMutableArray alloc] init];
    [self.data addObject:[NSArray arrayWithObjects:@"Jack mamamam",@"2",@"Shanghai",@"18",@"Engineer", nil]];
    [self.data addObject:[NSArray arrayWithObjects:@"Jack mamamam",@"2",@"Shanghai",@"18",@"Engineer", nil]];
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
    NSString *headerTitle = [self.headers objectAtIndex:columnIndex];
    
    return headerTitle;
}
-(NSTextAlignment)dataGridView:(RHDataGridView *)dataGridView textAlignmentForColumnAtIndex:(NSInteger)columnIndex{
    return NSTextAlignmentCenter;
}
-(NSString *)dataGridView:(RHDataGridView *)dataGridView contentForRowAtIndex:(NSInteger)rowIndex columnAtIndex:(NSInteger)columnIndex{
    NSArray *rowData = [self.data objectAtIndex:rowIndex];
    NSString *text = [rowData objectAtIndex:columnIndex];
    return text;
}

@end
