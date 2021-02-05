//
//  AlunoAPI.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 04/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import Alamofire

class AlunoAPI: NSObject {
    
    // MARK: - GET
    
    func recuperaAlunos(completion: @escaping() -> Void) {
        let respose = AF.request("http://localhost:3333/alunos")
        respose.responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                guard let listaAlunos = data as? Array<Dictionary<String, String>> else { return  }
                for dicionarioDeAluno in listaAlunos {
                    AlunoDAO().salvaAluno(dicionarioAluno: dicionarioDeAluno)
                }
                completion()
                break
            case .failure(let error):
                print(error)
                completion()
                break
            }
        }
    }
    
    // MARK: - POST
    
    func salvaAlunosNoServidor(parametros: [String: String]) {
        
        AF.request("http://localhost:3333/alunos", method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseJSON { respnse in
            debugPrint(respnse)
        }
    }
    
    // MARK: - DELETE
    
    func deletaAluno(id: String) {
        AF.request("http://localhost:3333/alunos/\(id)", method: .delete).responseJSON { (resposta) in
            switch resposta.result {
            case .failure(let error):
                print(error)
                break
            default:
                break
            }
        }
    }
}
