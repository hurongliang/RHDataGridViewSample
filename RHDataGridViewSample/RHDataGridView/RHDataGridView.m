//
//  RHDataGridView.m
//  RHDataGridViewSample
//
//  Created by Ron Hu on 8/26/14.
//
//

#import "RHDataGridView.h"

@implementation RHDataGridView{
    NSMutableArray *headers;
    NSMutableDictionary *rows;
    NSMutableArray *columnWidthList;
    NSMutableDictionary *tableViewCellMap;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        [self prepare];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self prepare];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        [self prepare];
    }
    return self;
}
-(void)prepare{
    self.dataSource = self;
    self.delegate = self;
    self.columnSpacing = 0;
    
    headers = [[NSMutableArray alloc] init];
    rows = [[NSMutableDictionary alloc] init];
    columnWidthList = [[NSMutableArray alloc] init];
    tableViewCellMap = [[NSMutableDictionary alloc] init];
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
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell for row %ld",(long)indexPath.row);
    
    UITableViewCell *cell = [tableViewCellMap objectForKey:indexPath];
    
    if(cell!=nil){
        return cell;
    }
    
    NSInteger rowIndex = indexPath.row;
    
    NSInteger rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    static NSString *cellid = @"multipletableviewcell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, rowHeight)];
    }
    
    NSMutableArray *gridCellList = [[NSMutableArray alloc] init];
    
    if([self.dataGridViewDelegate respondsToSelector:@selector(numberOfColumnsInDataGridView:)]){
        NSInteger offsetX = 20;
        for(NSInteger columnIndex=0;columnIndex<[self.dataGridViewDelegate numberOfColumnsInDataGridView:self];columnIndex++){
            UILabel *dataGridCell = [[UILabel alloc] init];;
            
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:textForRowAtIndex:columnAtIndex:)]){
                NSString *dataGridCellText = [self.dataGridViewDelegate dataGridView:self textForRowAtIndex:rowIndex columnAtIndex:columnIndex];
                [dataGridCell setText:dataGridCellText];
            }
            
            NSInteger columnWidth = 0;
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:widthForColumnAtIndex:)]){
                columnWidth = [self.dataGridViewDelegate dataGridView:self widthForColumnAtIndex:columnIndex];
            }else{
                CGSize size = [dataGridCell.text sizeWithAttributes:@{NSFontAttributeName:dataGridCell.font}];
                columnWidth = ceilf(size.width);
            }
            
            [dataGridCell setFrame:CGRectMake(offsetX, 0, columnWidth, rowHeight)];
            
            [gridCellList addObject:dataGridCell];
            [cell addSubview:dataGridCell];
            
            [self recordMaxColumnWidth:columnWidth atColumnIndex:columnIndex];
            
            offsetX += columnWidth+self.columnSpacing;
        }
    }
    
    [rows setObject:gridCellList forKey:indexPath];
    
    [tableViewCellMap setObject:cell forKey:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger width = self.frame.size.width;
    NSInteger height = [self tableView:tableView heightForHeaderInSection:section];
    
    [headers removeAllObjects];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    if([self.dataGridViewDelegate respondsToSelector:@selector(numberOfColumnsInDataGridView:)]){
        NSInteger offsetX = 20;
        for(NSInteger columnIndex = 0; columnIndex < [self.dataGridViewDelegate numberOfColumnsInDataGridView:self]; columnIndex++){
            UILabel *header = [[UILabel alloc] init];
            
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:headerTextForColumnAtIndex:)]){
                NSString *headerText = [self.dataGridViewDelegate dataGridView:self headerTextForColumnAtIndex:columnIndex];
                [header setText:headerText];
            }
            
            NSInteger width = 0;
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:widthForColumnAtIndex:)]){
                width = [self.dataGridViewDelegate dataGridView:self widthForColumnAtIndex:columnIndex];
            }else{
                CGSize size = [header.text sizeWithAttributes:@{NSFontAttributeName:header.font}];
                width = ceilf(size.width);
            }
            
            [header setFrame:CGRectMake(offsetX, 0, width, height)];
            
            [headers addObject:header];
            [headerView addSubview:header];
            
            [self recordMaxColumnWidth:width atColumnIndex:columnIndex];
            
            offsetX += width+self.columnSpacing;
        }
        
        [headerView setBackgroundColor:[UIColor whiteColor]];
    }
    
    if([self autoresizeColumnWidth]){
        [self adjustColumnWidth];
    }
    
    return headerView;
}
-(void)recordMaxColumnWidth:(NSInteger)newWidth atColumnIndex:(NSInteger)columnIndex{
    if(columnIndex<[columnWidthList count]){//exists
        NSNumber *oldWidthNumber = [columnWidthList objectAtIndex:columnIndex];
        NSInteger oldWidth = [oldWidthNumber integerValue];
        if(oldWidth<newWidth){
            [columnWidthList replaceObjectAtIndex:columnIndex withObject:[NSNumber numberWithInteger:newWidth]];
        }
    }else{//not exists
        for(NSInteger i=[columnWidthList count];i<=columnIndex;i++){
            if(i==columnIndex){
                [columnWidthList addObject:[NSNumber numberWithInteger:newWidth]];
            }else{
                [columnWidthList addObject:[NSNumber numberWithInteger:0]];
            }
        }
    }
}
-(void)updateLabel:(UILabel *)label toX:(NSInteger)x toWidth:(NSInteger)width{
        label.frame = CGRectMake(x, label.frame.origin.y, width, label.frame.size.height);
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        if([self autoresizeColumnWidth]){
            [self adjustColumnWidth];
        }
    }
}
-(BOOL)autoresizeColumnWidth{
    return ![self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:widthForColumnAtIndex:)];
}
-(void)adjustColumnWidth{
    NSInteger x = 20;
    for(NSInteger i=0;i<[headers count];i++){
        UILabel *header = headers[i];
        NSNumber *widthNumber = columnWidthList[i];
        NSInteger width = [widthNumber integerValue];
        
        [self updateLabel:header toX:x toWidth:width];
        
        x += width + self.columnSpacing;
    }
    
    for(NSIndexPath *indexPath in tableViewCellMap){
        NSMutableArray *cellList = [rows objectForKey:indexPath];
        x = 20;
        for(NSInteger i=0;i<[cellList count];i++){
            UILabel *cell = [cellList objectAtIndex:i];
            
            NSNumber *widthNumber = columnWidthList[i];
            NSInteger width = [widthNumber integerValue];
            
            [self updateLabel:cell toX:x toWidth:width];
            
            x += width += self.columnSpacing;
        }
    }
}
@end
