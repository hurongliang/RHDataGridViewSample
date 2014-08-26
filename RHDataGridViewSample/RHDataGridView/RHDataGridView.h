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
-(NSString *)dataGridView:(RHDataGridView *)dataGridView headerTextForColumnAtIndex:(NSInteger)columnIndex;
-(NSInteger)dataGridView:(RHDataGridView *)dataGridView widthForColumnAtIndex:(NSInteger)columnIndex;
-(NSInteger)dataGridView:(RHDataGridView *)dataGridView heightForRowAtIndex:(NSInteger)rowIndex;
-(NSString *)dataGridView:(RHDataGridView *)dataGridView textForRowAtIndex:(NSInteger)rowIndex columnAtIndex:(NSInteger)columnIndex;
-(void)dataGridView:(RHDataGridView *)dataGridView didSelectRowAtIndex:(NSInteger)rowIndex;
-(void)dataGridView:(RHDataGridView *)dataGridView didDeselectRowAtIndex:(NSInteger)rowIndex;
@end

@interface RHDataGridView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(weak,nonatomic)id<RHDataGridViewDelegate> dataGridViewDelegate;
@property(assign,nonatomic)NSInteger columnSpacing;

@end
