import CabinMacro
import Foundation

@DecodeInit
struct abc {
    let id:Int
}


@DecodeInit
public struct CrewDutyModelNew: Codable {
    
    public var id: Int
    public var foMaDV: String
    public var tripID: Int
    public var crewID: String
    public var foNight: Int
    public var crewFirstName: String
    public var isReadOnly: Bool
    public var foRpt: String
    public var isPurser: Bool
    public var foIntTime, autoJob, foLoai, foFromPlace: String
    public var foRptime, crewLastName, dutyFree, textColor: String
    public var foCham, foFlyTime, ca, foNote: String
    public var foCh: Int
    public var foOffSplit, foTimeOff, foEndTime, foStartTime: String
    public var trainingCrewName: String
    public var flightID: Int
    public var vip, training: String
    public var foTimeFor: Int
    public var ability, foCFG, foUser, foDutyTime: String
    public var autoCA, ann, job, foStatus: String
    public var foJob: String
    public var avatarURL: String
    public var isTrainee: Bool
    public var foTimeMin: Int
    public var foEndPlace, other, foEOD: String
    public var userID, version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case foMaDV = "FO_Ma_DV"
        case tripID = "TripID"
        case crewID = "CrewID"
        case foNight = "FO_Night"
        case crewFirstName = "CrewFirstName"
        case isReadOnly = "IsReadOnly"
        case foRpt = "FO_Rpt"
        case isPurser = "IsPurser"
        case foIntTime = "FO_Int_Time"
        case autoJob = "AutoJob"
        case foLoai = "FO_Loai"
        case foFromPlace = "FO_From_Place"
        case foRptime = "FO_Rptime"
        case crewLastName = "CrewLastName"
        case dutyFree = "DutyFree"
        case textColor = "TextColor"
        case foCham = "FO_Cham"
        case foFlyTime = "FO_Fly_Time"
        case ca = "CA"
        case foNote = "FO_Note"
        case foCh = "FO_Ch"
        case foOffSplit = "FO_Off_Split"
        case foTimeOff = "FO_Time_Off"
        case foEndTime = "FO_End_Time"
        case foStartTime = "FO_Start_Time"
        case trainingCrewName = "TrainingCrewName"
        case flightID = "FlightID"
        case vip = "VIP"
        case training = "Training"
        case foTimeFor = "FO_Time_For"
        case ability = "Ability"
        case foCFG = "FO_Cfg"
        case foUser = "FO_User"
        case foDutyTime = "FO_Duty_Time"
        case autoCA = "AutoCA"
        case ann = "ANN"
        case job = "Job"
        case foStatus = "FO_Status"
        case foJob = "FO_Job"
        case avatarURL = "AvatarURL"
        case isTrainee = "IsTrainee"
        case foTimeMin = "FO_Time_Min"
        case foEndPlace = "FO_End_Place"
        case other = "Other"
        case foEOD = "FO_Eod"
        case userID = "UserId"
        case version = "Version"
    }
}
