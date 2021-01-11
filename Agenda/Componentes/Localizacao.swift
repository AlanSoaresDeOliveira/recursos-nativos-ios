//
//  Localizacao.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 16/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {

    func converteEnderecoEmCoordenadas(endereco: String, local:@escaping(_ local:CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listadeLocalizacao, error) in
            if let localizacao = listadeLocalizacao?.first {
                local(localizacao)
            }
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino {
        let pino = Pino(coordenada: localizacao.location!.coordinate)
        pino.title = titulo
        pino.color = cor
        pino.icon = icone
                
        return pino
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pino {
            let annotationView = annotation as! Pino
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView
            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationView.title!)
            
            pinoView?.annotation = annotationView
            pinoView?.glyphImage = annotationView.icon
            pinoView?.markerTintColor = annotationView.color
            
            return pinoView
        }
        
        return nil
    }
}
