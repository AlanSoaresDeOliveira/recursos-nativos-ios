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
    lazy var localizacao = Localizacao()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = getTitulo()
        localizacaoInicial()
        localizarAluno()
        mapa.delegate = localizacao
    }
    
    // MARK: - Métodos
    
    func getTitulo() -> String {
        return "Localizar Alunos"
    }
    
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Martinópolis - São Paulo") { (localizacaoEncontrada) in
//            let pino = self.configuraPino(titulo: "Prefeitura", localizacao: localizacaoEncontrada)
            let pino = Localizacao().configuraPino(titulo: "Caelum", localizacao: localizacaoEncontrada, cor: .black, icone: UIImage(named: "icon_caelum"))
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 5000, 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func localizarAluno() {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                self.mapa.addAnnotation(pino)
            }
        }
    }
}
