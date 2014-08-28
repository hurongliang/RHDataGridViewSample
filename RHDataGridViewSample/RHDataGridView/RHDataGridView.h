//
//  RHDataGridView.h
//  RHDataGridViewSample
//
//  Created by Ron Hu on 8/26/14.
//
//

#import <UIKit/UIKit.h>

@class RHDataGridView;

@protocol RHDataGridViewDelegate <NSObject>
-(NSInteger)numberOfColumnsInDataGridView:(RHDataGridView *)dataGridView;
-(NSInteger)numberOfRowsInDataGridView:(RHDataGridView *)dataGridView;

@optional
-(NSString *)dataGridView:(RHDataGridView *)dataGridView titleForColumnAtIndex:(NSInteger)columnIndex;
-(NSInteger)dataGridView:(RHDataGridView *)dataGridView widthForColumnAtIndex:(NSInteger)columnIndex;
-(NSInteger)dataGridView:(RHDataGridView *)dataGridView heightForRowAtIndex:(NSInteger)rowIndex;
-(NSTextAlignment)dataGridView:(RHDataGridView *)dataGridView textAlignmentForColumnAtIndex:(NSInteger)columnIndex;
-(NSString *)dataGridView:(RHDataGridView *)dataGridView contentForRowAtIndex:(NSInteger)rowIndex columnAtIndex:(NSInteger)columnIndex;
-(void)dataGridView:(RHDataGridView *)dataGridView didSelectRowAtIndex:(NSInteger)rowIndex;
-(void)dataGridView:(RHDataGridView *)dataGridView didDeselectRowAtIndex:(NSInteger)rowIndex;
-(void)dataGridView:(RHDataGridView *)dataGridView willDisplayCell:(UITableViewCell *)cell forRowAtIndex:(NSInteger)rowIndex;
-(void)dataGridView:(RHDataGridView *)dataGridView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndex:(NSInteger)rowIndex;
@end

@interface RHDataGridView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(weak,nonatomic)id<RHDataGridViewDelegate> dataGridViewDelegate;
@property(assign,nonatomic)NSInteger columnSpacing;

-(NSInteger)widthForColumnAtIndex:(NSInteger)columnIndex;
@end
