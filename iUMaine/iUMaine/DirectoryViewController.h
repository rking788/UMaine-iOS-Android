
#import <UIKit/UIKit.h>


@interface DirectoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
	UITableView     *mainTableView;
	
	NSMutableArray  *employeeArr;
	NSMutableArray  *searchResults;
	NSString        *savedSearchTerm;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *employeeArr;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain)   NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

- (void) fillEmployees;

@end
