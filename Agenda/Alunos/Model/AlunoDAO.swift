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
        
        var aluno: NSManagedObject?
        guard let id = UUID(uuidString: dicionarioAluno["id"]!) else { return }
        
        let alunos = recuperarAlunos().filter() { $0.id == id }
        
        if alunos.count > 0 {
            guard let alunoEncontrado = alunos.first else { return }
            aluno = alunoEncontrado
        } else {
            let entidade = NSEntityDescription.entity(forEntityName: "Aluno", in: contexto)
            aluno = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        
        aluno?.setValue(id, forKey: "id")
        aluno?.setValue(dicionarioAluno["nome"] ?? "", forKey: "nome")
        aluno?.setValue(dicionarioAluno["telefone"] ?? "", forKey: "telefone")
        aluno?.setValue(dicionarioAluno["endereco"] ?? "", forKey: "endereco")
        aluno?.setValue(dicionarioAluno["site"] ?? "", forKey: "site")
        
        
        guard let nota = dicionarioAluno["nota"] else { return }
        
        if type(of: nota) == String.self {
            aluno?.setValue((dicionarioAluno["nota"]! as NSString).doubleValue , forKey: "nota")
        } else {
            let conversaoDeNota = String(describing: nota)
            aluno?.setValue((conversaoDeNota as NSString).doubleValue, forKey: "nota")
        }
        
//        aluno.nota = (dicionarioAluno["nota"]! as NSString).doubleValue
        
        atualizaContexto()
    }
    
    func deletaAluno(aluno: Aluno) {
        contexto.delete(aluno)
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
