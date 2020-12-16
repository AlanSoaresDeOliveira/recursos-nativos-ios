//
//  MapaViewController.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 16/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController{
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - Variaveis
    
    var aluno: Aluno?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = getTitulo()
        localizacaoInicial()
        localizarAluno()
    }
    
    // MARK: - Métodos
    
    func getTitulo() -> String {
        return "Localizar Alunos"
    }
    
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Martinópolis - São Paulo") { (localizacaoEncontrada) in
            let pino = self.configuraPino(titulo: "Prefeitura", localizacao: localizacaoEncontrada)
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 5000, 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func localizarAluno() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: aluno!.endereco!) { (localizacaoEncontrada) in
            let pino = self.configuraPino(titulo: self.aluno!.nome!, localizacao: localizacaoEncontrada)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark) -> MKPointAnnotation {
        let pino = MKPointAnnotation()
        pino.title = titulo
        pino.coordinate = localizacao.location!.coordinate
        
        return pino
    }
    

}
