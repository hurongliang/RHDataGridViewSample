//
//  RHDataGridView.m
//  RHDataGridViewSample
//
//  Created by Ron Hu on 8/26/14.
//
//

#import "RHDataGridView.h"

@implementation RHDataGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.dataGridViewDelegate respondsToSelector:@selector(numberOfRowsInDataGridView:)]){
        return [self.dataGridViewDelegate numberOfRowsInDataGridView:self];
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:heightForRowAtIndex:)]){
        return [self.dataGridViewDelegate dataGridView:self heightForRowAtIndex:indexPath.row];
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowIndex = indexPath.row;
    
    NSInteger rowHeight = 44;
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:heightForRowAtIndex:)]){
        rowHeight = [self.dataGridViewDelegate dataGridView:self heightForRowAtIndex:rowIndex];
    }
    
    static NSString *cellid = @"multipletableviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, rowHeight)];
    }
    
    NSInteger offsetX = 20;
    for(NSInteger columnIndex=0;columnIndex<[self.dataGridViewDelegate numberOfColumnsInDataGridView:self];columnIndex++){
        NSInteger columnWidth = [self.dataGridViewDelegate dataGridView:self widthForColumnAtIndex:columnIndex];
        UIView *dataGridCell = [self.dataGridViewDelegate dataGridView:self cellForRowAtIndex:rowIndex columnAtIndex:columnIndex];
        
        [dataGridCell setFrame:CGRectMake(offsetX, 0, columnWidth, rowHeight)];
        
        [cell addSubview:dataGridCell];
        
        offsetX += columnWidth;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger width = self.frame.size.width;
    NSInteger height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    NSInteger offsetX = 20;
    for(NSInteger columnIndex = 0; columnIndex < [self.dataGridViewDelegate numberOfColumnsInDataGridView:self]; columnIndex++){
        NSInteger headerWidth = [self.dataGridViewDelegate dataGridView:self widthForColumnAtIndex:columnIndex];
        
        UIView *header = [self.dataGridViewDelegate dataGridView:self headerForColumnAtIndex:columnIndex];
        
        [header setFrame:CGRectMake(offsetX, 0, headerWidth, height)];
        
        [headerView addSubview:header];
        
        offsetX += headerWidth;
    }
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:didSelectRowAtIndex:)]){
        [self.dataGridViewDelegate dataGridView:self didSelectRowAtIndex:indexPath.row];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:didDeselectRowAtIndex:)]){
        [self.dataGridViewDelegate dataGridView:self didDeselectRowAtIndex:indexPath.row];
    }
}
@end
