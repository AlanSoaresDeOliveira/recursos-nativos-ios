//
//  AlunoDAO.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 04/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDAO: NSObject {
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func salvaAluno(dicionarioAluno: [String: String]) {
        let aluno = Aluno(context: contexto)
        
        aluno.nome = dicionarioAluno["nome"] ?? ""
        aluno.telefone = dicionarioAluno["telefone"] ?? ""
        aluno.endereco = dicionarioAluno["endereco"] ?? ""
        aluno.site = dicionarioAluno["site"] ?? ""
        
        guard let nota = dicionarioAluno["nota"] else { return }
        
        if type(of: nota) == String.self {
            aluno.nota = (dicionarioAluno["nota"]! as NSString).doubleValue
        } else {
            let conversaoDeNota = String(describing: nota)
            aluno.nota = (conversaoDeNota as NSString).doubleValue
        }
        
        aluno.nota = (dicionarioAluno["nota"]! as NSString).doubleValue  
        
        atualizaContexto()
    }
    
    func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
