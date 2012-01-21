
#import <UIKit/UIKit.h>


@interface DirectoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
	UITableView     *mainTableView;
	
	NSMutableArray  *employeeArr;
	NSMutableArray  *searchResults;
	NSString        *savedSearchTerm;
    NSString* campusEmployees;
}

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *employeeArr;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong)   NSString *savedSearchTerm;
@property (nonatomic, strong) NSString* campusEmployees;

- (void)handleSearchForTerm:(NSString *)searchTerm;

- (void) fillEmployees;

@end
