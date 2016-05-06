//
//  OpPara.h
//  voclib
//
//  Created by apple on 14-1-17.
//
//

#ifndef __voclib__OpPara__
#define __voclib__OpPara__

#include <iostream>

class OpPara {
public:
    int mType;
    int paramsLen;
    unsigned char params[512];
    
    static OpPara* NewCalMac(unsigned char method,char* random,int randomLen);
    static OpPara* NewUserInputParam(unsigned char  timeout,unsigned char type,unsigned char len,unsigned char confirm,unsigned char gdlen);
	static  OpPara* NewInputMoneyParam(unsigned char timeoutSec,unsigned char country);
	
    static OpPara* NewInputPassParam(unsigned char timeoutSec,unsigned char keyIndex, char* random,
                                     int randomLen,unsigned char needPan, char* money,
                                     int moneyLen, char* pan);
    static  OpPara* NewSwipeCardOpParam(unsigned char timeoutSec,
                                        unsigned char keyIndex,
                                         char* random,
                                        int randomLen,
                                        unsigned char needCardMingWen,
                                        unsigned char needValidDate,
                                        unsigned char needConfirmKey,
                                        char* money,int moneyLen,unsigned char desmode);
};

#endif /* defined(__voclib__OpPara__) */
