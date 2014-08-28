//
//  RHDataGridView.m
//  RHDataGridViewSample
//
//  Created by Ron Hu on 8/26/14.
//
//

#import "RHDataGridView.h"

@implementation RHDataGridView{
    NSMutableDictionary *widthOfColumns;
    NSMutableDictionary *cellCache;
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
    
    widthOfColumns = [[NSMutableDictionary alloc] init];
    cellCache = [[NSMutableDictionary alloc] init];
}
-(void)reloadData{
    [widthOfColumns removeAllObjects];
    [cellCache removeAllObjects];
    [super reloadData];
}
-(void)setDataSource:(id<UITableViewDataSource>)dataSource{
    if(dataSource!=self){
        NSLog(@"Warinng: delegate cannot be assigned outside.");
        return;
    }
    [super setDataSource:dataSource];
}
-(void)setDelegate:(id<UITableViewDelegate>)delegate{
    if(delegate!=self){
        NSLog(@"Warning: delegate cannot be assigned outside.");
        return;
    }
    [super setDelegate:delegate];
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
    if([cellCache objectForKey:indexPath]!=nil){
        return [cellCache objectForKey:indexPath];
    }
    
    NSInteger rowIndex = indexPath.row;
    NSInteger rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    /* create cell */
    static NSString *cellid = @"multipletableviewcell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, rowHeight)];
    
    if([self.dataGridViewDelegate respondsToSelector:@selector(numberOfColumnsInDataGridView:)]){
        NSInteger offsetX = 20;
        for(NSInteger columnIndex=0;columnIndex<[self.dataGridViewDelegate numberOfColumnsInDataGridView:self];columnIndex++){
            UILabel *cellLabel = [[UILabel alloc] init];;
            
            /* set text */
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:contentForRowAtIndex:columnAtIndex:)]){
                NSString *dataGridCellText = [self.dataGridViewDelegate dataGridView:self contentForRowAtIndex:rowIndex columnAtIndex:columnIndex];
                [cellLabel setText:dataGridCellText];
            }
            
            /* set text alignment */
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:textAlignmentForColumnAtIndex:)]){
                [cellLabel setTextAlignment:[self.dataGridViewDelegate dataGridView:self textAlignmentForColumnAtIndex:columnIndex]];
            }
            
            /* set frame */
            NSInteger columnWidth = [self widthForColumnAtIndex:columnIndex withFont:cellLabel.font];
            [cellLabel setFrame:CGRectMake(offsetX, 0, columnWidth, rowHeight)];
            
            [cell addSubview:cellLabel];
            
            offsetX += columnWidth+self.columnSpacing;
        }
    }
    
    [cellCache setObject:cell forKey:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger width = self.frame.size.width;
    NSInteger height = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    if([self.dataGridViewDelegate respondsToSelector:@selector(numberOfColumnsInDataGridView:)]){
        NSInteger offsetX = 20;
        for(NSInteger columnIndex = 0; columnIndex < [self.dataGridViewDelegate numberOfColumnsInDataGridView:self]; columnIndex++){
            UILabel *headerLabel = [[UILabel alloc] init];
            
            /* set text */
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:titleForColumnAtIndex:)]){
                [headerLabel setText: [self.dataGridViewDelegate dataGridView:self titleForColumnAtIndex:columnIndex]];
            }
            
            /* set text alignment */
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:textAlignmentForColumnAtIndex:)]){
                [headerLabel setTextAlignment:[self.dataGridViewDelegate dataGridView:self textAlignmentForColumnAtIndex:columnIndex]];
            }
            
            /* set frame */
            NSInteger width = [self widthForColumnAtIndex:columnIndex withFont:headerLabel.font];
            [headerLabel setFrame:CGRectMake(offsetX, 0, width, height)];
            
            [headerView addSubview:headerLabel];
            
            offsetX += width+self.columnSpacing;
        }
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:willDisplayCell:forRowAtIndex:)]){
        [self.dataGridViewDelegate dataGridView:self willDisplayCell:cell forRowAtIndex:indexPath.row];
    }
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:didEndDisplayingCell:forRowAtIndex:)]){
        [self.dataGridViewDelegate dataGridView:self didEndDisplayingCell:cell forRowAtIndex:indexPath.row];
    }
}
#pragma mark - autoresize column width according content

/**
 *  Calc content width for column with specified font
 *
 *  @param columnIndex column index
 *  @param font        font of column
 *
 *  @return content width
 */
-(NSInteger)widthForColumnAtIndex:(NSInteger)columnIndex withFont:(UIFont *)font{
    
    NSNumber *existedWidth = [widthOfColumns objectForKey:[NSNumber numberWithInteger:columnIndex]];
    if(existedWidth!=nil){
        return [existedWidth integerValue];
    }
    
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:widthForColumnAtIndex:)]){
        return [self.dataGridViewDelegate dataGridView:self widthForColumnAtIndex:columnIndex];
    }
    
    NSInteger width = 0;
    
    //header width
    if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:titleForColumnAtIndex:)]){
        NSString *headerText = [self.dataGridViewDelegate dataGridView:self titleForColumnAtIndex:columnIndex];
        width = [self widthOfText:headerText andFont:font];
    }
    
    //cell width
    if([self.dataGridViewDelegate respondsToSelector:@selector(numberOfRowsInDataGridView:)]){
        for (NSInteger rowIndex = 0; rowIndex < [self.dataGridViewDelegate numberOfRowsInDataGridView:self]; rowIndex++) {
            if([self.dataGridViewDelegate respondsToSelector:@selector(dataGridView:contentForRowAtIndex:columnAtIndex:)]){
                NSString *text = [self.dataGridViewDelegate dataGridView:self contentForRowAtIndex:rowIndex columnAtIndex:columnIndex];
                NSInteger curWidth = [self widthOfText:text andFont:font];
                if(width<curWidth){
                    width = curWidth;
                }
            }
        }
    }
    
    [widthOfColumns setObject:[NSNumber numberWithInteger:width] forKey:[NSNumber numberWithInteger:columnIndex]];
    
    return width;
}

/**
 *  return text width with specified font
 *
 *  @param text text
 *  @param font font of text
 *
 *  @return text width
 */
-(NSInteger) widthOfText:(NSString *)text andFont:(UIFont *)font{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    return ceilf(size.width);
}
@end
