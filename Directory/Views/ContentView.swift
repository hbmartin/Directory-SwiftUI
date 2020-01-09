//
//  ContentView.swift
//  Directory
//
//  Created by Harold Martin on 1/1/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.lastName, ascending: true)]
    ) var persons: FetchedResults<Person>

    var body: some View {
        ZStack {
            GradientView().edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        ForEach(self.persons) { person in
                            PersonRow(
                                person: person,
                                addedToContactsState: person.addedToContacts
                            ).padding(15)
                        }
                    }.frame(width: geometry.size.width)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
