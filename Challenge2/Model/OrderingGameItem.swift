//
//  OrderingGameItem.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 18/11/2026.
//

import Foundation

struct OrderingGameItem: Identifiable {
       let id = UUID()
       let emoji: String
       let order: Int   // correct position, 0 = first
   }
