# TouchIDTool
###两步集成TouchID功能

> 第一步 
> 
> `#import "TouchIDTool.h"`

> 第二步
>
	- (void)openTouchID
	{
	    NSError *error = [TouchIDTool canSupportTouchID];
	    if (!error) {	        
	        __weak __typeof(self)weakSelf = self;
	        [TouchIDTool openTouchIDWithTitle:@"TOUCH ME" success:^{
	        	//验证成功，主线程处理UI
	            NSLog(@"tool success");
	        } enterPassword:^{
	        	//用户选择输入密码，切换主线程处理
	            NSLog(@"enter password");
	        } failure:^(LAError *error) {
	            //验证失败，切换主线程处理
	            NSLog(@"tool failure");
	        }]; 
	    } else {
	        NSLog(@"%@",error.localizedDescription);
	    }
	}