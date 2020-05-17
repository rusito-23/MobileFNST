//
//  Utils.h
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#define DefineWeakSelf __weak typeof(self) weakSelf = self
#define DefineStrongSelf __strong typeof(weakSelf) self = weakSelf; if (!self) return

#endif /* Utils_h */
