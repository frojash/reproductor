//
//  ViewController.swift
//  Reproductor
//
//  Created by Fernando Rojas Hidalgo on 6/30/18.
//  Copyright © 2018 Rohisa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate {
   
    @IBOutlet weak var pickerCanciones: UIPickerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var btnAleatorio: UIButton!
    @IBOutlet weak var imgCancion: UIImageView!

    var pantallaCargada : Bool = false;
    var ModoAleatorio = false
    private var reproductor : AVAudioPlayer!
    var Canciones : [String] = ["Jamming","BlackRoses","Jerusalem","Herbalist","PartyNextDoor"]
    var Nombres : [String] = ["Jamming","Black Roses","Jerusalem","Herbalist","Party Next Door"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sonidoURL = Bundle.main.url(forResource: Canciones[0], withExtension: "mp3")
        
        lblMensaje.text = Nombres[0]
        
        do{
            try reproductor = AVAudioPlayer(contentsOf: sonidoURL!)
        }catch let myError{
            print(myError)
        }
        pickerCanciones.delegate = self
        pickerCanciones.dataSource = self

        stVolumen.wraps = false
        stVolumen.autorepeat = false
        stVolumen.minimumValue = 0
        stVolumen.stepValue = 0.1
        stVolumen.maximumValue = 1
        stVolumen.value = Double(reproductor.volume)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        if (flag == true){
            btnPlay.setTitle("Play", for: .normal)
            
            if ModoAleatorio {
                let cancion = Int(arc4random()) % Canciones.count
                print(cancion)
                pickerCanciones.selectRow(cancion, inComponent: 0, animated: true)
            }else{
                var cancion = pickerCanciones.selectedRow(inComponent: 0) + 1
                if (cancion > Canciones.count - 1){
                    cancion = 0
                }
                print(cancion)
                pickerCanciones.selectRow(cancion, inComponent: 0, animated: true)
            }

        }
    }

    @IBOutlet weak var stVolumen: UIStepper!
    @IBAction func stVolumen_Change(_ sender: UIStepper) {
        
        let volumen = sender.value

        reproductor.setVolume(Float(volumen), fadeDuration: 0)


    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Play() {
        pantallaCargada = true;
       tocar()
    }
    
    func tocar() {
        if !reproductor.isPlaying{
            reproductor.play()
            btnPlay.setTitle("Pause", for: .normal)
        
        }else {
            reproductor.pause()
            btnPlay.setTitle("Play", for: .normal)
        }
    }
    
    
    @IBAction func Aleatorio() {
        pantallaCargada = true;
        if (ModoAleatorio == false){
            ModoAleatorio = true;
            let cancion = Int(arc4random_uniform(UInt32(Canciones.count - 1)))
            print(cancion)
            pickerCanciones.selectRow(cancion, inComponent: 0, animated: true)
            btnAleatorio.setTitle("En Orden", for: .normal)

            
        }else{
            ModoAleatorio = false;
            btnAleatorio.setTitle("Aleatorio", for: .normal)
            pickerCanciones.selectRow(0, inComponent: 0, animated: true)

        }
    }
    
    @IBAction func Stop() {
        if reproductor.isPlaying{
            
            reproductor.stop()
            reproductor.currentTime = 0
            btnPlay.setTitle("Play", for: .normal)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Canciones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let sonidoURL = Bundle.main.url(forResource: Canciones[row], withExtension: "mp3")
        do{
            try reproductor = AVAudioPlayer(contentsOf: sonidoURL!)
        }catch let myError{
            print(myError)
        }
        
        imgCancion.image = UIImage(named: Canciones[row] + ".jpg")
        
        lblMensaje.text = Nombres[row]
        
        reproductor = try! AVAudioPlayer(contentsOf: sonidoURL!)
        reproductor.delegate = self
        
        tocar()
        return Canciones[row]

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

