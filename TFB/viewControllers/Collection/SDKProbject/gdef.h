//
//  gdef.h
//  voclib
//
//  Created by apple on 14-8-9.
//
//

#ifndef voclib_gdef_h
#define voclib_gdef_h


/*********************** 返回字段类型定义 ************************/
enum
{
    FIELD_CARD_MINGWEN = 1, //卡号明文
    FIELD_PASS_ENCRYPT = 2, //密码密文
    FIELD_MONEY = 3,
    FIELD_CD2 = 4,
    FIELD_CD3 = 5,
    FIELD_CD1 = 6,
    FIELD_RANDOM = 7,
    FIELD_HARDNO = 8,
    FIELD_PSAMNO = 9,
    FIELD_USER_INPUT = 10,
    FIELD_CARD_VALID_DATE = 11,
    FIELD_FKEY = 12,
    FIELD_MAC = 13,
    FIELD_TERMNO = 14,
    FIELD_MERCHNO = 15,
    FILED_IC_RETURN_DATA = 16,
    FIELD_MAC2 = 17,
    FIELD_UPDATE_TMK_RANDOM = 18,
    FIELD_GENERATEAC_RET = 19,
    FILED_8583_55 = 20,
    FIELD_GEN_AC2_RET = 21,
    FIELD_PAN = 22,
    FIELD_TRADE_TYPE = 23,
    FIELD_TRADE_CARD_TYPE = 24,
    FIELD_8583_PAK = 25,
    FIELD_8583_MAC = 26,
    FIELD_POS_PARA = 27,
    FIELD_MEMORY = 28,
    FIELD_TERMNO2 = 29,
    FIELD_MERCHNO2 = 30,
    
    //内部使用
    FIELD_PBOC_CERT = 31,
    FIELD_PBOC_AID = 32,
    FIELD_BIGDATA = 33, // 大数据
    FIELD_MISS_PAK = 34, // 未收到的报文序列号
    FIELD_BIGDATA_ID = 35, // 发送大数据ID号码
    FIELD_BIGDATA_CRC=36,//大数据的CRC校验码
    
    FIELD_BAT_LEFT=37,   //锂电池电量
    FIELD_USER_PDNO=38,   //用户产品编号
    FIELD_TMK=40,         //传输密钥
    FIELD_WORK_KEY=41,     //工作密钥
    FIELD_9F1E_DEVICE_NO=42, //Pboc设备编号
    FIELD_9F4E_MERCH_NO=43,   //pboc商户号码
    FIELD_AID=44   //多应用卡的AID
};
enum
{
    CMD_ERR, //指令
    //测试蓝牙连接
    CMD_TEST_BLUETOOTH_ALIVE = 1,
    //手机连接上pos通知报文
    CMD_BLUETOOTH_CONNECTD = 2,
    //刷卡
    CMD_SWIPECARD = 3,
    //连续操作指令
    CMD_OPS = 4,
    //输入密码指令
    CMD_INPUTPASS = 5,
    //输入金额
    CMD_INPUTMONEY = 6,
    //用户输入
    CMD_USER_INPUT = 7,
    CMD_FKEY = 8,
    CMD_ZUHE = 9,
    CMD_SHOWMONEY = 10,
    //显示字符
    CMD_SHOWINFO = 11,
    CMD_PRINT = 12,
    CMD_SAVE_PRINT_TEMPLATE = 13,
    //读取硬件编号和PSAM卡编号
    CMD_READ_NO = 14,
    // 更新签到密钥
    CMD_UPDATE_KEY = 15,
    // 读取商户和终端号码
    CMD_READ_MECH_TERM_NO = 16,
    // 保存商户和终端号吗
    CMD_SAVE_MECH_TERM_NO = 17,
    // 显示金额
    CMD_SHOW_MONEY = 18,
    // 计算mac
    CMD_CAL_MAC = 19,
    
    CMD_IC_RESET = 20,
    CMD_IC_CMD = 21,
    CMD_CAL_MAC2 = 22,
    //更新传输密钥-取随机数
    CMD_UPDATE_TMK_GETRANDOM = 23,
    
    //更新传输密钥-更新密钥
    CMD_UPDATE_TMK = 24,
    
    //PBOC IC卡数据
    CMD_PBOC_ICDATA = 25,
    
    //PBOC 静态认证数据
    CMD_PBOC_STATIC_VALID_DATA = 26,
    
    //PBOC内部认证数据
    CMD_INTERNAL_AUTH_RET_DATA = 27,
    
    //生成应用密文指令
    CMD_GENERATE_AC = 28,
    
    //PBOC_IC卡数据接收确认指令
    CMD_PBOC_ICDATA_CONFIRM = 29,
    
    //插卡指令
    CMD_INSERT_PBOC_IC_CARD = 30,
    
    //交易结束
    CMD_PBOC_END_DEAL = 31,
    
    //蓝牙连接检测应答
    CMD_TEST_BLUETOOTH_ALIVE_ACK = 32,
    
    //POS主动刷卡指令
    CMD_POS_SWIPE_CARD = 33, //已作废
    
    //交易请求
    CMD_POS_REQUREST_TRANS = 34,
    
    //许可交易
    CMD_ALLOW_TRANS = 35,
    
    //禁止交易
    CMD_REJECT_TRANS = 36,
    
    //POS交易数据上送
    CMD_POS_TRADE_REQ_DATA = 37,
    
    //POS交易结果返回
    CMD_POS_T97 = 38,
    
    //8583报文确认
    CMD_POS_8583_PAK_ACK = 39,
    //8583请求报文
    CMD_POS_8583_PAK = 40,
    //8583响应报文
    CMD_POS_8583_RES = 41,
    //保存POS参数
    CMD_SAVE_POS_PARA = 42,
    //获取pos参数
    CMD_GET_POS_PARA = 43,
    //更新界面提示
    CMD_UPDATE_MAIN_INTERFACE = 44,
    //保存tmk到cpu中
    CMD_SAVE_TMK_IN_CPU = 45,
    //保存通用数据
    CMD_SAVE_GENERAL_DATA = 46,
    //读取通用数据
    CMD_READ_GENERAL_DATA = 47,
    //清除falsh数据
    CMD_CLEAR_FLASH_DATA = 48,
    
    //保存大数据指令
    CMD_SAVE_BIG_DATA=49,
    
    //保存批量数据
    CMD_BATCH_SAVE=50,
    
    //PBOC AID用户选择
    CMD_SELECT_AID=51,
    ////////////////////////////内部指令
    //获得空闲内存
    CMD_GET_MEMORY = 100,
    //更新硬件编号
    CMD_UPDATE_HARDNO = 101,
    //数据接收确认
    CMD_RECV_CONFIRM = 102,
    //使能自毁
    CMD_ENABLE_TAMPER_DETECT = 103,
    //FKEY接收确认
    CMD_FKEY_RECV_CONFIRM = 104,
    CMD_BEEP = 105,
    CMD_RESEND=106,
    CMD_TEST_DOG=107,
    CMD_PROGUPDATE=108
};
/*********************** 打印参数定义 ************************/
enum{
    // 字体大小,1号最大，4号最小
    PRT_FONT_SIZE_0 = 0,
    PRT_FONT_SIZE_1 = 1,
    PRT_FONT_SIZE_2 = 2,
    PRT_FONT_SIZE_3 = 3,
    PRT_FONT_SIZE_4 = 4
};

enum{
    // 行属性
    PRT_LINE_NORMAL = 1,// 普通
    PRT_LINE_TITLE1 = 2,// 首联标题
    PRT_LINE_TITLE2 = 3,// 第二联标题
    PRT_LINE_ENDNOTE1 = 4,// 首联尾注
    PRT_LINE_ENDNOTE2 = 5,// 第二联尾注
    PRT_LINE_BITMAP = 6,// 位图
    PRT_LINE_HEAD = 7// 两联公用标题
};
enum{
    WITHOUT_PAN=0,                //不需PAN码
    WITH_PAN_FROM_SWIPE_CARD=1,    //使用上一个刷卡指令的PAN码
    WITH_PAN_FROM_VCMD_PARAM=2     //使用音频指令提供的PAN码
};

enum{
    CARD_TYPE_IC=1,
    CARD_TYPE_MAG=2
};

enum{
    IC_SRC_LKT=0,
    IC_SRC_IC=1,
    IC_SRC_PSAM=2
};
enum{
    ERR_NONE = 0,
    SUCC_SAVE_CERT_PARA = 200,// 更新证书成功
    SUCC_SAVE_BIG_DATA = 201,// 保存大数据成功
    SUCC_SAVE_BANK_PARA = 202,// 保存银行参数成功    ERR_CONFIRM = 1, // 指令接收确认
    ERR_NO_PAPER = 2, // 缺纸
    ERR_PSAM = 3, // PSAM卡错误
    ERR_WRONG_CMD_PARAM = 4, // 随机数长度错误，只能是3或者8
    ERR_TIME_OUT = 5, // 超时无操作返回
    ERR_USER_CANCEL = 6, // 用户取消
    ERR_PRINT_TEMPLATE_INDEX_OVERFLOW = 7, // 打印模板编号越界
    ERR_PRINT_TEMP_LINE_NOTMATCH = 8, // 打印模板和行内容不匹配
    ERR_RPINT_LEN_OVER_FLOW = 9, // 单行打印长度溢出
    ERR_CMD_NOT_SURPPORT_IN_ZUHE = 10, // 组合指令命令不支持。
    ERR_ZUHE_RETDATA_OVERFLOW = 11, // 组合指令的返回数据长度溢出
    ERR_BUSY = 12, // 用户忙
    ERR_LOW_MEMORY = 13, // 内存不足
    ERR_WRONG_IC_STATE = 14,// IC卡不在等待交易结束状态
    ERR_LOGIC = 15, //系统错误
    ERR_SAVE_GEN_DATA_ERROR = 16, //保存错误
    ERR_READ_GEN_DATA_ERROR = 17,
    ERR_NOT_SURPPORT_CMD = 18, //不支持指令
    ERR_WRONG_CMD_PARA = 19, //指令参数错误
    ERR_IC_TIMEOUTC = 20, //IC指令等待返回错误
    ERR_IC_RETURN_DATA = 21, //IC没有返回成功指令
    ERR_SWIPE_CARD = 22, //刷卡解析失败
    ERR_IC_CARD_OUT = 23, //ic中途拔卡
    ERR_IC_NOT_SUPPORT_FKH_AUTH = 24, //银行卡不支持发卡行认证
    ERR_WRONG_FLASH_DATA_TYPE = 25, //错误的flash数据类型
    ERR_KEY_INDEX_OVER_FLOW = 26, //密钥索引错误
    ERR_WRONG_RANDOM_LEN = 27, //随机数长度错误
    ERR_TMK_INDEX = 28, //主密钥索引错误
    ERR_KEY_CNT = 29, //一次更新密钥数量错误，最多支持3个密钥
    ERR_FLASH_LOW_ON_SPACE = 30,//FLASH空间不足
    ERR_BIG_DATA_SEQ_OVERFLOW=31, //大数据序号越界
    ERR_NO_CERT_DATA=32, //更新证书没有先保存证书数据
    ERR_BIG_DATA_CRC=33 //大数据CRC校验错误
};

/*fuyou的接口声明*/
#define AUTO_ADAPTER_INTERVAL   3     //自动适配超时时间

//刷卡器版本
#define POSEEY_VERSION_1        0x00
#define POSEEY_VERSION_2        0x21

//刷卡器应答码
#define POSEEY_RSP_SUCCESS  0x00	//成功
#define POSEEY_RSP_NO_PSAM  0x01	//没有psam卡
#define POSEEY_RSP_PSAM_NO_POWER  0x02	//sim卡已下电
#define POSEEY_RSP_PSAM_INIT_ERR  0x03	//psam初始化失败
#define POSEEY_RSP_PSAM_SELECT_DF_ERR  0x04	//psam选择DF错误
#define POSEEY_RSP_PSAM_AUTH_ERR  0x05	//psam双向认证失败
#define POSEEY_RSP_DES_PIN_ERR  0x06	//加密密码错误
#define POSEEY_RSP_DES_DATA_ERR  0x07	//加密数据错误
#define POSEEY_RSP_CAL_MAC_ERR  0x08		//计算MAC错误
#define POSEEY_RSP_PSAM_READ_FILE_ERR  0x09	//读记录文件错误
#define POSEEY_RSP_PSAM_NO_RSP  0x0A		//psam卡没有响应
#define POSEEY_RSP_PSAM_EXEC_CMD_ERR  0x0B		//执行pasm指令错误
#define POSEEY_RSP_PSAM_UPDATE_RECORD_ERR  0x0C		//更新psam记录错误
#define POSEEY_RSP_PSAM_UPDATE_AUTHKEY_ERR  0x0D		//更新认证密钥错误
#define POSEEY_RSP_NO_TKEY_CARD  0x0E		//没有插入TKEY卡
#define POSEEY_RSP_TKEY_INIT_ERR  0x0F		//TKEY卡初始化错误
#define POSEEY_RSP_TKEY_SELECT_DF_ERR  0x10		//TKEY卡选择DF错误
#define POSEEY_RSP_TKEY_CHECK_PIN_ERR  0x11		//TKEY卡校验pin错误
#define POSEEY_RSP_TKEY_GET_AUTH_KEY_ERR  0x12		//TKEY卡获取认证密钥错误
#define POSEEY_RSP_INIT_DES_ERROR 0x13
#define POSEEY_RSP_MSR_ERR 0x14             //刷卡失败
#define POSEEY_RSP_DES_ERROR 0x15
#define POSEEY_RSP_SIM_TIMEOUT 0x16
#define POSEEY_RSP_SIM_CHECKERR  0x17		//写密钥到NV错误
#define POSEEY_RSP_SIM_CMD_NO_SUPPORT 0x18		//读版本信息失败
#define POSEEY_RSP_SIM_CMD_NO_SUCCESS 0x19  //命令返回不是9000
#define POSEEY_RSP_SIM_KEYINDEX_ERR   0x1A  //密钥索引错误
#define POSEEY_RSP_SIM_WKEY_NO_UPDATE 0x1B  //WKEY没有更新
#define POSEEY_RSP_SIM_MKEY_NO_UPDATE 0x1C  //MKEY没有更新
#define POSEEY_RSP_SIM_WKEY_CHK_ERR   0x1D  //WKEY没有更新
#define POSEEY_RSP_SIM_MKEY_CHK_ERR   0x1E  //MKEY没有更新


//刷卡类型
#define MSR_TYPE_GET_MSR    0
#define MSR_TYPE_GET_PAN    1
#define MSR_TYPE_GET_MSR_DES 2

//加密类型
#define DES_DATA_TYPE_PSWD        0x00
#define DES_DATA_TYPE_COMMON      0x01
#define DES_DATA_TYPE_MAC         0x02
#define DES_DATA_TYPE_PSWD_CIPHER 0x03
#define DES_DATA_TYPE_PSWD_BY_RSA 0x04


#endif
