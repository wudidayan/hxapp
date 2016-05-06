
//
//  TDParameterHeader.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#ifndef TFB_TDParameterHeader_h
#define TFB_TDParameterHeader_h

//==================域名================//

//#define HOST @"http://103.47.137.51:8098/mpcctp/"  //生产环境
#define HOST @"http://103.47.137.53:8098/mpcctp/"  // 测试服务器
//#define HOST @"http://192.168.0.232:8098/mpcctp/"      //标准版
//#define HOST @"http://210.22.153.30:8098/mpcctp/"      //标准版外网

#define ZMK @"11111111111111110123456789ABCDEF"
//===================end================//

//=================OEM_参数控制===========//
#define APP_NAME            @"满e刷"            //应用名称
#define APP_SERVICE_PHONE   @"021-65909780"     //客服电话
#define APP_CALL_PHOME      @"021-65909780"
//021-65909780

#define YZM_NUM_CODE        6                   //验证码位数
#define YZM_TIME_CODE       60                  //验证码时间
#define LAUNCH_TIME_CODE    2                  //launchTime

#define POSSDK_KSN_NUM_CODE 13                  //刷卡器截取位数
#define POSSDK_TREM_HX      @"2150"             //音频刷卡器ksn 头部字符串
#define POSDERVICE_PAY                          //是否需要购买刷卡器  //不需要则屏蔽
#define POSS_PAY_TYPE                         //是否刷卡支付  //若快捷则屏蔽

//#define PAY_SUBTYPE_ONE       @"01"           //订单子类型
#define PAY_SUB_TYPE     @"800001"                   //购买刷卡器 订单类型

//====================end================//

#define TITTLE_MESSAGE_TEXT  @"世界上最遥远的距离就是没有网络!"

#endif
