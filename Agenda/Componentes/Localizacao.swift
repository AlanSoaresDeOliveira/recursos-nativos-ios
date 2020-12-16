//
//  Localizacao.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 16/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import CoreLocation

class Localizacao: NSObject {

    func converteEnderecoEmCoordenadas(endereco: String, local:@escaping(_ local:CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listadeLocalizacao, error) in
            if let localizacao = listadeLocalizacao?.first {
                local(localizacao)
            }
        }
    }
}
