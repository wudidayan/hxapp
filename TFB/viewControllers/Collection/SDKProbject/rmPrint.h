//
//  PrintTemplate.h
//  voclib
//
//  Created by apple on 14-1-18.
//
//

#ifndef __voclib__PrintTemplate__
#define __voclib__PrintTemplate__

//#include <iostream>
class PrintLine
{
public:
    int tempNo;//模板号
    int fontSize;//字体大小
    int lineAttr;//行属性
    char str[33];  //打印内容
    char res[40];
    int pos;
    char* toBytes();
};

class PrintLines{
public:
    PrintLines();
	PrintLine mLines[256];
    int mLinesCnt;
    char res[512];
    int pos;
	//增加新的打印行
    bool AddNewLine(int tmpno,int fsize,int lattr,char* str);
    bool findSameAttrLine(int lattr);
    char* toBytes();
};

class Template{
public:
    Template();
    int tempNo;// 模板号
    int fSize;// 字体大小
    char str[50]; // 打印内容
    char res[60];
    int pos;
    char* toBytes();
};

class PrintTemplate
{
public:
    PrintTemplate();
	Template mLists[256];
    int mListsCnt;
	bool AddNewLine(int tmpno,int fsize,char* str);
    char res[512];
    int  pos;
	char* toBytes();
};

#endif /* defined(__voclib__PrintTemplate__) */
