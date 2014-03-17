typedef id(^SVBindingBlock)(id value);

@interface NSObject (SVBindings)

#pragma mark - Binding
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath;
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath block:(SVBindingBlock)block;

#pragma mark - Unbinding
-(void)sv_unbind:(NSString*)keyPath;
-(void)sv_unbindAll;

@end
