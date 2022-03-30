//
//  ContentView.swift
//  WeakSelfReferencesSTBC
//
//  Created by Vahtee Boo on 30.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("count") var count: Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate") {
                WeakSelfSecondScreen()
            }
            .navigationTitle("Screen 1")
        }
        .overlay(alignment: .topTrailing) {
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.mint.cornerRadius(10))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct WeakSelfSecondScreen: View {
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        Text("Second View")
            .font(.largeTitle)
            .foregroundColor(.red)
        
        if let data = vm.data {
            Text(data)
        }
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    
    @Published var data: String?
    
    init() {
        print("INITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit {
        print("DEINITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
            self?.data = "NEW DATA!!!"
        }
        
// bad idea
//        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//            self.data = "NEW DATA!!!"
//        }
        
//        DispatchQueue.global().async {
//            self.data = "NEW DATA!!!"
//        }
    }
}
