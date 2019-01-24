//
//  Juegos.swift
//  FirebaseCrude
//
//  Created by Fernando Jt on 19/4/18.
//  Copyright © 2018 Fernando Jumbo Tandazo. All rights reserved.
//

import Foundation

class Juegos{
    var nombre:String?
    var genero:String?
    var id:String?
    var imagen: String?
    
    init(nombre:String?,genero:String?, id:String?, imagen:String?) { //constructor
        self.nombre = nombre
        self.genero = genero
        self.id = id
        self.imagen = imagen
    }
}
