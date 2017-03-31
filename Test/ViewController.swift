//
//  ViewController.swift
//  Test
//
//  Created by kangsik choi on 2017. 3. 31..
//  Copyright © 2017년 kangsik choi. All rights reserved.
//

import UIKit

import RxBluetoothKit
import RxSwift
import CoreBluetooth

class ViewController: UIViewController {
    
     private var scanningDisposable: Disposable?
     let manager = BluetoothManager(queue: .main,  options: [CBCentralManagerOptionRestoreIdentifierKey:"SMARTPLUS" as AnyObject])
     private var scheduler: ConcurrentDispatchQueueScheduler!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerQueue = DispatchQueue(label: "com.polidea.rxbluetoothkit.timer")
        scheduler = ConcurrentDispatchQueueScheduler(queue: timerQueue)
        
        
        self.initListen()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clickScan(_ sender: Any) {
        scanningDisposable = manager.rx_state
            .timeout(4.0, scheduler: scheduler)
            .take(1)
            .flatMap { _ in self.manager.scanForPeripherals(withServices: nil, options:nil) }
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            }, onError: { error in
            })
    }
    
    @IBAction func clickKill(_ sender: Any) {
        
        kill(getpid(), SIGKILL);
    }
    
    func initListen(){
        _ = self.manager.listenOnRestoredState()
            .subscribe(onNext: { (restoredState) in
                print("onNext")
            },onError: {error in
                print(error)
            },onCompleted:{
                print("onCompleted")
            },onDisposed:{
                print("onDisposed" )
            })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

