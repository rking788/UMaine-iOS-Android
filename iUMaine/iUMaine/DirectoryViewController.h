
#import <UIKit/UIKit.h>


@interface DirectoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
	UITableView     *mainTableView;
	
	NSMutableArray  *contentsList;
	NSMutableArray  *searchResults;
	NSString        *savedSearchTerm;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy)   NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
