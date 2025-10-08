//
//  ReceiptVC.swift
//  Little
//
//  Created by Gabriel John on 06/06/2019.
//  Copyright © 2019 Craft Silicon Ltd. All rights reserved.
//

import UIKit

public class ReceiptVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Constants
    
    let am = SDKAllMethods()
    let hc = SDKHandleCalls()
    let littleHandleCalls = LittleHandleCalls()
    
    // Variables
    
    var sdkBundle: Bundle?
    var popToRestorationID: UIViewController?
    var navShown: Bool?
    
    var CCArr: [String] = []
    var CNArr: [String] = []
    var payDescArr: [String] = []
    var payCostArr: [String] = []
    
    var isCorporate: Bool = false
    var corporateIndex: Int = 0
    var tip = "0"
    var TIMESTAMP=""
    
    var paymentMode: String = "Cash"
    var paymentModeID: String = "CASH"
    var paymentModes: [String] = []
    var paymentModeIDs: [String] = []
    var paymentModeCount: Int = 0
    
    var paymentVC: UIViewController?
    
    private var finishedLoadingInitialTableCells = false
    
    @IBOutlet weak var btnPaymentType: UIButton!
    @IBOutlet weak var lblAmountToPay: UILabel!
    
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    
    @IBOutlet weak var lblTripType: UILabel!
    
    @IBOutlet weak var extraChargesTable: UITableView!
    @IBOutlet weak var minimumCostsLbl: UILabel!
    @IBOutlet weak var baseFareLbl: UILabel!
    @IBOutlet weak var distanceCostLbl: UILabel!
    @IBOutlet weak var timeCostLbl: UILabel!
    @IBOutlet weak var costPerKmLbl: UILabel!
    @IBOutlet weak var costPerMinLbl: UILabel!
    
    
    @IBOutlet weak var paymentBtn: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkBundle = Bundle.module
        
        setupData()
        
        if am.getSDKLastEndTripNotificationTripID() != am.getTRIPID() {
            sendEndTripSmsNotification()
        }
        
        getTripCost()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    // MARK: - Functions

    @objc func postBackHome() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LITTLE_SDK_CLOSED"), object: nil, userInfo: nil)
        
        navigationController?.dismiss(animated: true)
        
    }
    
    @objc func paymentResultReceived(_ notification: Notification) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PAYMENT_RESULT"), object: nil)
        
        let success = notification.userInfo?["success"] as? Bool
        let status = notification.userInfo?["status"] as? String
        
        if status == "000" {
            proceedToRating()
        } else if let success = success {
            if success {
                proceedToRating()
            } else {
                self.showAlerts(title: "", message: "Error occured completing payment. Please retry.".localized)
            }
        } else if status == "091" {
            showAlerts(title: "", message: "Error occured completing payment. Please retry.".localized)
        } else {
            printVal(object: "Include a success boolean value with the PAYMENT_RESULT Notification Post")
        }
        
    }
    
    private func simulateSuccessfulTransaction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         let userInfo = [
            "success": true,
            "status": "000",
            "transactionRef": UUID().uuidString
         ] as [String : Any]
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENT_RESULT"), object: nil, userInfo: userInfo)
         }
    }
    
    private func proceedToRating() {
        if let viewController = UIStoryboard(name: "Trip", bundle: self.sdkBundle!).instantiateViewController(withIdentifier: "TripRatingVC") as? TripRatingVC {
            if let navigator = self.navigationController {
                viewController.popToRestorationID = self.popToRestorationID
                viewController.navShown = self.navShown
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - IBOutlet Actions
    
    @IBAction func makePaymentPressed(_ sender: UIButton) {
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(paymentResultReceived(_:)),name: NSNotification.Name(rawValue: "PAYMENT_RESULT"), object: nil)
        
        
        let reference = am.getTRIPID() ?? ""
        
        let userInfo = ["amount":Double(am.getLIVEFARE() ?? "0") ?? 0,"reference":reference, "additionalData": am.getSDKAdditionalData()] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENT_REQUEST"), object: nil, userInfo: userInfo)*/
        
        postPaymentRequestNotification()
        
        // TODO: Comment
//            simulateSuccessfulTransaction()
        
        #warning("remove post order notification")
        if SDKConstants.SDK_CLIENT == .VOOMA {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let userInfo = ["success": true] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENT_RESULT"), object: nil, userInfo: userInfo)
            }
        }
        
        /*if let viewController = UIStoryboard(name: "Trip", bundle: self.sdkBundle!).instantiateViewController(withIdentifier: "TripRatingVC") as? TripRatingVC {
            if let navigator = self.navigationController {
                viewController.popToRestorationID = self.popToRestorationID
                viewController.navShown = self.navShown
                navigator.pushViewController(viewController, animated: true)
            }
        }*/
        
    }
    
    private func postPaymentRequestNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(paymentResultReceived(_:)),name: NSNotification.Name(rawValue: "PAYMENT_RESULT"), object: nil)
        
        let amount = Double(am.getLIVEFARE() ?? "0") ?? 0
        
        let merchantId = "LITTLE"
        let merchantName = "Little"
        
        let userInfo = [
            "amount": amount,
            "reference": am.getTRIPID() ?? "",
            "additionalData": am.getSDKAdditionalData(),
            "merchantName": merchantName,
            "merchantId": merchantId,
            "accountNumber": "",
            "module": "ORDERRIDE"
        ] as [String : Any]
        
        printVal(object: "postPaymentRequestNotification: \(userInfo)")
                
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENT_REQUEST"), object: nil, userInfo: userInfo)
    }
    
    // MARK: - Table Delegates & Data Sources

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return payDescArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! BreakdownTableViewCell
        if payCostArr[indexPath.item].contains("-") {
            cell.plusMinusImage.image = getImage(named: "minus", bundle: sdkBundle!)
        } else {
            cell.plusMinusImage.image = getImage(named: "add", bundle: sdkBundle!)
        }
        let amount = Double(payCostArr[indexPath.item].replacingOccurrences(of: "-", with: ""))
        cell.payAmountLbl.text = String(format: "\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). %.2f", amount!)
        cell.payDescLbl.text = payDescArr[indexPath.item]
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if payDescArr.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 10)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
    /*private func getTripCost() {
        view.createLoadingNormal()
        NotificationCenter.default.addObserver(self, selector: #selector(loadTripCost),name:NSNotification.Name(rawValue: "GETREQUESTSTATUSTripCostJSONData"), object: nil)
                
        var params = SDKUtils.commonJsonTags(formId: "GETREQUESTSTATUS")
        params["TripID"] = am.getTRIPID()
        params["GetRequestStatus"] = [
            "TripID": am.getTRIPID() ?? ""
        ]
        
        SDKHandleCalls().makeServerCall(sb: params.toJsonString(), method: "GETREQUESTSTATUSTripCostJSONData", switchnum: 0)
        
    }
    
    @objc private func loadTripCost(_ notification: Notification) {
        view.removeAnimation()
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: "GETREQUESTSTATUSTripCostJSONData"), object: nil)
        
        guard let data = notification.userInfo?["data"] as? Data else { return }
        
        var STATUS = ""
        var TRIPSTATUS = ""
        var WIFIPASS = ""
        var DRIVERLATITUDE = ""
        var DRIVERLONGITUDE = ""
        var DRIVERBEARING = ""
        var VEHICLETYPE = ""
        var LIVEFARE = ""
        var BASEPRICE = ""
        var PERMIN = ""
        var PERKM = ""
        var CORPORATECODE = ""
        var BASEFARE = ""
        var DISTANCE = ""
        var TIME = ""
        var DISTANCETOTALCOST = ""
        var TIMETOTALCOST = ""
        var PAYMENTCODES = ""
        var PAYMENTCOSTS = ""
        var ET = ""
        var ED = ""
        var MESSAGE = ""
        var CURRENCY = ""
        var STARTOTP = ""
        var ENDOTP = ""
        var PARKOTP = ""
        var CHAT = ""
        
        am.saveTRIPSTATUS(data: TRIPSTATUS)
        am.saveWIFIPASS(data: WIFIPASS)
        am.saveDRIVERLATITUDE(data: DRIVERLATITUDE)
        am.saveDRIVERLONGITUDE(data: DRIVERLONGITUDE)
        am.saveDRIVERBEARING(data: DRIVERBEARING)
        am.saveVEHICLETYPE(data: VEHICLETYPE)
        am.savePERMIN(data: PERMIN)
        am.savePERKM(data: PERKM)
        am.saveCORPORATECODE(data: CORPORATECODE)
        am.saveLIVEFARE(data: LIVEFARE)
        am.saveBASEPRICE(data: BASEPRICE)
        am.saveBASEFARE(data: BASEFARE)
        am.saveDISTANCE(data: DISTANCE)
        am.saveTIME(data: TIME)
        am.saveGLOBALCURRENCY(data: CURRENCY)
        am.saveDISTANCETOTALCOST(data: DISTANCETOTALCOST)
        am.saveTIMETOTALCOST(data: TIMETOTALCOST)
        am.savePAYMENTCODES(data: PAYMENTCODES)
        am.savePAYMENTCOSTS(data: PAYMENTCOSTS)
        am.saveET(data: ET)
        am.saveED(data: ED)
        am.saveMESSAGE(data: MESSAGE)
        am.saveStartTripOTP(data: STARTOTP)
        am.saveEndTripOTP(data: ENDOTP)
        am.saveParkingFeeOTP(data: PARKOTP)
        am.saveCHAT(data: CHAT)
        
        do {
            let requestStatusResponse = try JSONDecoder().decode(RequestStatusResponse.self, from: data)
            guard let response = requestStatusResponse[safe: 0] else { return }
            
            STATUS = response.status ?? ""
            TRIPSTATUS = response.tripStatus ?? ""
            WIFIPASS = response.wifiPass ?? ""
            DRIVERLATITUDE = "\(response.driverLatitude ?? "0.0")"
            DRIVERLONGITUDE = "\(response.driverLongitude ?? "0.0")"
            DRIVERBEARING = "\(response.driverBearing ?? "0.0")"
            VEHICLETYPE = response.vehicleType ?? ""
            LIVEFARE = response.liveFare ?? ""
            BASEFARE = response.minimumFare ?? ""
            BASEPRICE = response.basePrice ?? ""
            PERMIN = "\(response.costPerMinute ?? "0.0")"
            PERKM = "\(response.costPerKilometer ?? "0.0")"
            CORPORATECODE = response.corporateID ?? ""
            DISTANCE = response.distance ?? ""
            TIME = response.time ?? ""
            DISTANCETOTALCOST = response.distanceTotalCost ?? ""
            TIMETOTALCOST = response.timeTotalCost ?? ""
            PAYMENTCODES = response.paymentCodes ?? ""
            PAYMENTCOSTS = response.paymentCosts ?? ""
            ET = response.et ?? ""
            ED = response.ed ?? ""
            MESSAGE = response.message ?? ""
            CURRENCY = response.currency ?? ""
            STARTOTP = response.startOTP ?? ""
            ENDOTP = response.endOTP ?? ""
            PARKOTP = response.parkingOTP ?? ""
            CHAT = response.tripChat ?? ""
            
            am.saveTRIPSTATUS(data: TRIPSTATUS)
            am.saveWIFIPASS(data: WIFIPASS)
            am.saveDRIVERLATITUDE(data: DRIVERLATITUDE)
            am.saveDRIVERLONGITUDE(data: DRIVERLONGITUDE)
            am.saveDRIVERBEARING(data: DRIVERBEARING)
            am.saveVEHICLETYPE(data: VEHICLETYPE)
            am.savePERMIN(data: PERMIN)
            am.savePERKM(data: PERKM)
            am.saveCORPORATECODE(data: CORPORATECODE)
            am.saveLIVEFARE(data: LIVEFARE)
            am.saveBASEPRICE(data: BASEPRICE)
            am.saveBASEFARE(data: BASEFARE)
            am.saveDISTANCE(data: DISTANCE)
            am.saveTIME(data: TIME)
            am.saveGLOBALCURRENCY(data: CURRENCY)
            am.saveDISTANCETOTALCOST(data: DISTANCETOTALCOST)
            am.saveTIMETOTALCOST(data: TIMETOTALCOST)
            am.savePAYMENTCODES(data: PAYMENTCODES)
            am.savePAYMENTCOSTS(data: PAYMENTCOSTS)
            am.saveET(data: ET)
            am.saveED(data: ED)
            am.saveMESSAGE(data: MESSAGE)
            am.saveStartTripOTP(data: STARTOTP)
            am.saveEndTripOTP(data: ENDOTP)
            am.saveParkingFeeOTP(data: PARKOTP)
            am.saveCHAT(data: CHAT)
            am.savePaymentMode(data: response.paymentMode ?? "")
            am.saveTollChargeOTP(data: response.tollChargeOTP ?? "")
            
            if STATUS != "000" {
                am.saveTRIPSTATUS(data: "")
            }
            
            setupData()
            
        } catch {}
    }*/
    
    private func getTripCost() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadTripCost),name:NSNotification.Name(rawValue: "GETREQUESTSTATUS_REDISJSONData"), object: nil)
        
        view.createLoadingNormal()
                
        var params = SDKUtils.commonJsonTags(formId: "GETREQUESTSTATUS_REDIS_NEW")
        params["GETET"] = "Y"
        params["GetET"] = "Y"
        params["GetEt"] = "Y"
        params["TripID"] = am.getTRIPID() ?? ""
        params["AgentUniqueID"] = ""
        params["FleetEngine"] = ""
        
        let dataToSend = (try? SDKUtils.dictionaryToJson(from: params)) ?? ""
        
        LittleHandleCalls().makeServerCall(sb: dataToSend, method: "GETREQUESTSTATUS_REDISJSONData", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
        
    }
    
    @objc private func loadTripCost(_ notification: Notification) {
        let data = notification.userInfo?["data"] as? Data
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: "GETREQUESTSTATUS_REDISJSONData"), object: nil)
        
        view.removeAnimation()
        
        if data != nil {
            var STATUS = ""
            var TRIPSTATUS = ""
            var DROP_OFF_LL = ""
            var LIVEFARE: Double = 0
            var DISTANCE = ""
            var TIME = ""
            var ENDOTP = ""
            var ET = ""
            var ED = ""
            
            var PAYMENTCODES = ""
            var PAYMENTCOSTS = ""
            var DISTANCETOTALCOST: Double = 0
            var TIMETOTALCOST: Double = 0
            var MESSAGE = ""
            var PERMIN : Double = 0
            var PERKM: Double = 0
            var BASEPRICE: Double = 0
            var PAYMENT_MODE = ""
            var BASEFARE: Double = 0
                        
            am.saveTRIPSTATUS(data: "")
            am.saveLIVEFARE(data: "")
            am.saveDISTANCE(data: "")
            am.saveTIME(data: "")
            am.saveED(data: "")
            am.saveET(data: "")
            
            do {
                let response = try JSONDecoder().decode(RedisTripStatus.self, from: data!)
                
                STATUS = response.status ?? ""
                TRIPSTATUS = response.tripStatus ?? ""
                DROP_OFF_LL = response.dropOffLL ?? ""
                LIVEFARE = response.liveFare ?? 0
                DISTANCE = response.distance ?? ""
                TIME = response.time ?? ""
                ET = response.et ?? ""
                ED = response.ed ?? ""
                
                PAYMENTCODES = response.paymentCodes ?? ""
                PAYMENTCOSTS = response.paymentCosts ?? ""
                DISTANCETOTALCOST = response.distanceTotalCost ?? 0
                TIMETOTALCOST = response.timeTotalCost ?? 0
                MESSAGE = response.message ?? ""
                PERMIN = response.perMin ?? 0
                PERKM = response.perKM ?? 0
                BASEPRICE = response.minimumFare ?? 0
                BASEFARE = response.basePrice ?? 0
                PAYMENT_MODE = response.paymentMode ?? ""
                
                am.saveTRIPSTATUS(data: TRIPSTATUS)
                am.saveLIVEFARE(data: String(LIVEFARE))
                am.saveDISTANCE(data: DISTANCE)
                am.saveTIME(data: TIME)
                am.saveEndTripOTP(data: ENDOTP)
                am.saveED(data: ED)
                am.saveET(data: ET)
                                
                am.saveDISTANCETOTALCOST(data: String(DISTANCETOTALCOST))
                am.saveTIMETOTALCOST(data: String(TIMETOTALCOST))
                am.saveBASEPRICE(data: String(BASEPRICE))
                am.saveBASEFARE(data: String(BASEFARE))
//                am.savePERKM(data: String(PERKM))
                am.savePERMIN(data: String(PERMIN))
                
                if !PAYMENTCODES.isEmpty {
                    am.savePAYMENTCODES(data: PAYMENTCODES)
                }
                
                if !PAYMENTCOSTS.isEmpty {
                    am.savePAYMENTCOSTS(data: PAYMENTCOSTS)
                }
                
                if !MESSAGE.isEmpty {
                    am.saveMESSAGE(data: MESSAGE)
                }
                
                if !PAYMENT_MODE.isEmpty {
                    am.savePaymentMode(data: PAYMENT_MODE)
                }
                
                setupData()
                
            } catch {
                showGeneralErrorAlert()
            }
        }
        
    }
    
    private func setupData() {
        var amount = Double(am.getLIVEFARE())
        lblAmountToPay.text = String(format: "\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). %.2f", amount ?? 0)
        lblPickUp.text = am.getPICKUPADDRESS()
        lblDropOff.text = am.getDROPOFFADDRESS()
        costPerKmLbl.text = "Distance Cost (\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). \(am.getPERKM() ?? "0")/km)"
        costPerMinLbl.text = "Time Cost (\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). \(am.getPERMIN() ?? "0")/min)"
        amount = Double(am.getBASEPRICE())
        minimumCostsLbl.text = String(format: "\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). %.2f", amount ?? 0)
        amount = Double(am.getBASEFARE())
        baseFareLbl.text = String(format: "\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). %.2f", amount ?? 0)
        amount = Double(am.getDISTANCETOTALCOST())
        distanceCostLbl.text = String(format: "\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). %.2f", amount ?? 0)
        amount = Double(am.getTIMETOTALCOST())
        timeCostLbl.text = String(format: "\(am.getGLOBALCURRENCY()?.capitalized ?? "KES"). %.2f", amount ?? 0)
        
        if am.getCORPORATECODE() != "" {
            paymentMode = "COPORATE"
            paymentModeID = ""
            isCorporate = true
            amount = Double(am.getLIVEFARE())
            btnPaymentType.setTitle("Corporate", for: UIControl.State())
            lblTripType.text = "Corporate"
            paymentBtn.setTitle("Proceed", for: .normal)
        } else {
            if am.getPaymentModes() != "" {
                paymentModes = am.getPaymentModes().components(separatedBy: ";")
                paymentModes = paymentModes.filter { $0 != "" }
                paymentModeIDs = am.getPaymentModeIDs().components(separatedBy: ";")
                paymentModeIDs = paymentModeIDs.filter { $0 != "" }
                btnPaymentType.setTitle("\(am.getPaymentMode()?.capitalized ?? "Cash")", for: UIControl.State())
                paymentMode = am.getPaymentMode()
                paymentModeID = am.getPaymentModeID()
            }
            lblTripType.text = "Individual"
            paymentBtn.setTitle("Proceed", for: .normal)
        }
        
        payDescArr = am.getPAYMENTCODES().components(separatedBy: ";")
        payDescArr = payDescArr.filter { $0 != "" }
        payCostArr = am.getPAYMENTCOSTS().components(separatedBy: ";")
        payCostArr = payCostArr.filter { $0 != "" }
        extraChargesTable.delegate = self
        extraChargesTable.dataSource = self
        finishedLoadingInitialTableCells = false
        extraChargesTable.reloadData()
    }
    
    private func sendEndTripSmsNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadSendEndTripSmsNotification),name:NSNotification.Name(rawValue: "SendEndTripNotificationSimple"), object: nil)
        
        var name = am.getFullName().trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").first ?? ""
        
        if name.hasSuffix("s") {
            name += "'"
        } else {
            name += "'s"
        }
                
        let message = String(format: "%@ ride with Little has ended. Thank you for choosing us.".localized, name)
        
        printVal(object: "SendNotification message: \(message)")
        
        var params = SDKUtils.commonJsonTags(formId: "SendNotification")
        params["SendNotification"] = [
            "NotificationType": "SMS",
            "MobileNumber": am.getSDKNotificationPhoneNo(),
            "NotificationText": message
        ]
        params["MobileNumber"] = "0"
        
        let dataToSend = (try? SDKUtils.dictionaryToJson(from: params)) ?? ""
                
        littleHandleCalls.makeServerCall(sb: dataToSend, method: "SendEndTripNotificationSimple", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
    }
    
    @objc private func loadSendEndTripSmsNotification(_ notification: Notification) {
        
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: "SendEndTripNotificationSimple"), object: nil)
        
        if let userInfo = notification.userInfo, let data = userInfo["data"] as? Data {
            do {
                let response = try JSONDecoder().decode(CommonResponseData.self, from: data)
                if response.status == "000" {
                    am.saveSDKLastEndTripNotificationTripID(data: am.getTRIPID())
                } else {
//                    self.showAlerts(title: "", message: response.message ??  "\n\("Ooops, something went wrong.".localized)\n")
                }
                
            } catch (let error) {
//                showGeneralErrorAlert()
                printVal(object: "error: \(error.localizedDescription)")
            }
        } else {
//            showGeneralErrorAlert()
        }
        
    }
}
