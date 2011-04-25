

@interface Person : NSObject {
	NSString *type;
	NSString *firstName;
    NSString *lastName;
}

@property (nonatomic, copy) NSString *type, *firstName, *lastName;

+ (id)personWithType:(NSString *)type firstName:(NSString *)firstName lastName:(NSString *)lastName;

@end
