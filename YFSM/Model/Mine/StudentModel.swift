//
//	RootClass.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class StudentModel: BaseModel {
    
    var aboutMeCount: Int = 0// 与我相关数
    var birthday: Int = 0// 生日
    var candidate: String = ""// 考号
    var classId: Int = 0// 班级id
    var className: String = ""// 班级
    var code: String = ""
    var collectionCount: Int = 0// 收藏数
    var collegeId: Int = 0
    var collegeName: String = ""
  
    var country: String = ""
    var education: Int = 0
//    var id: Int = 0
    var imCode: String = ""
    var imToken: String = ""// 融云token
    var invitationCount: Int = 0// 帖子数
    var isFollow: Int = 0// 是否关注 0否  1是
    var isHasStatus: Int = 0
    var joinSchool: Int = 0// 开学时间
    var majorId: Int = 0
    var majorName: String = ""
    var name: String = ""
    var nation: String = ""
    var nickName: String = ""
    var note: String = ""
    var phone: String = ""
    var politics: String = ""
    var proveId: Int = 0
    var roterId: Int = 0
    var roterName: String = ""
    var roterNote: String = ""
    var roterUpDay: Int = 9
    var sLength: Int = 0
    var schoolId: Int = 0
    var schoolName: String = ""
    var sex: Int = -1
    var smallPic: String = ""
    var sourceProve: String = ""
    var step: Int = 0
    var studentId: String = ""
    var token: String = ""
    var userPic: String = ""
    
    func descSex() -> String {
        
        var str = ""
        
        switch (sex) {
        case 0:
            str = "未知"
        case 1:
            str = "男"
        case 1:
            str = "女"
        default: break
        }
        
        return str
    }
    
    func descYYYDay() -> String {
        var str = ""
        
        if roterUpDay == 0 {
            str = "现在可以摇一摇花名~"
        } else {
            str = "距离下次摇花名还有\(roterUpDay)天"
        }
        
        return str
    }
    
    
    /**
     是否收藏
     
     - returns: true: 收藏
     */
    func isCollect() -> Bool {
        
        return isFollow == 1
    }
}


