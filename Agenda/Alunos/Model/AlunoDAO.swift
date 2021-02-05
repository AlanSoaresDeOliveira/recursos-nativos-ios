//
//  AlunoDAO.swift
//  Agenda
//
//  Created by Alan Soares de Oliveira on 04/02/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDAO: NSObject, NSFetchedResultsControllerDelegate {
    var gerenciadorDeResultados: NSFetchedResultsController<Aluno>?
    
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func recuperarAlunos() -> Array<Aluno> {
        let pesquisaAluno: NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let odernaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [odernaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else { return [] }
        
        return listaDeAlunos
        
    }

    func salvaAluno(dicionarioAluno: [String: String]) {
        let aluno = Aluno(context: contexto)
        
        guard let id = UUID(uuidString: dicionarioAluno["id"]!) else { return }
        
        aluno.id = id        
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
