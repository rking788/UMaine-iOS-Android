

#import "Person.h"

@implementation Person

@synthesize type, firstName, lastName;


+ (id)personWithType:(NSString *)type firstName:(NSString *)firstName  lastName:(NSString *)lastName
{
	Person *newPerson = [[[self alloc] init] autorelease];
	newPerson.type = type;
	newPerson.firstName = firstName;
    newPerson.lastName = lastName;
	return newPerson;
}


- (void)dealloc
{
	[type release];
	[firstName release];
    [lastName release];
	[super dealloc];
}

@end
