//
//  CrewListView.swift
//  A-SHARP
//
//  Created by Will Weber on 10/27/26.
//

import SwiftUI
import SwiftData

struct CrewListView: View {
    @Binding var navigationPath: [SelectedItem]
    @Binding var searchText: String
    
    @Query(sort: [
        SortDescriptor(\Person.lastName, order: .forward),
        SortDescriptor(\Person.firstName, order: .forward)
    ])
    var people: [Person]
    
    init(navigationPath: Binding<[SelectedItem]>, searchText: Binding<String>) {
        _navigationPath = navigationPath
        _searchText = searchText
        
        let queryText = searchText.wrappedValue
        _people = Query(filter: #Predicate {
            if queryText.isEmpty { return true }
            else {
                return $0.lastName?.contains(queryText) ?? false ||
                $0.firstName?.contains(queryText) ?? false
            }
        }, sort: [
            SortDescriptor(\Person.lastName, order: .forward),
            SortDescriptor(\Person.firstName, order: .forward)
        ])
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Crew")
                        .font(.system(size: 34, weight: .bold, design: .default))
                    Spacer()
                }
                .padding(.top, 25)
                .padding(.bottom, 5)
                .padding([.horizontal])
                searchBarView(searchText: $searchText)
                List(people) { person in
                    NavigationLink(value: SelectedItem.person(item: person)) {
                        Text(person.fullName)
                    }
                    .listRowBackground(Color.viewBackground)
                }
                .navigationDestination(for: SelectedItem.self) { item in
                    if case .person(let person) = item {
                        CrewDetailView(person: person)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.inset)
            }
            .background(Color.viewBackground)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct CrewDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(person.fullName).font(.largeTitle)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(5)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
            .padding([.horizontal])
            List(person.flights ?? []) { flight in
                FlightRowView(flight: flight).listRowBackground(Color.viewBackground)
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
            

        }.toolbar(.hidden, for: .navigationBar)
            .background(Color.viewBackground)
    }
    
}
