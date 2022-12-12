//
//  ContentView.swift
//  msc
//
//  Created by Griffin Barnard on 12/12/22.
//

import SwiftUI
import Firebase

struct Response : Codable{
    let info: Info
    let results: [Individual]
}

struct Info : Codable {
    let count:Int
    let pages:Int
    let next:String?
    let prev: String?
}

struct Individual : Codable {
    let id: Int
    let name: String
    let status:String
    let species:String
    let type:String
    let gender:String
    let origin:Origin
    let location:Origin
    let image:String //hi
    let episode:[String]
    let url:String
    let created:String
}

struct Origin : Codable {
    let name:String
    let url:String
}


struct ContentView: View {
    @State private var email = "";
    @State private var password = "";
    @State private var userIsLoggedIn = false;
    @State private var isHome = 1;
    var img  = UIImage(systemName: "house")
    let homeButton = UIButton()
    @State private var chars:[Individual]?
//    init(){
//        getData()
//    }

    
    var body: some View {
        if userIsLoggedIn {
            main
            
        } else {
            content
        }
    }
    
    var main: some View {
        ZStack {
            mainBg
            if isHome == 1 {
                home
            } else if isHome == 2{
                saved
            } else {
                logout
            }
            ZStack {
                HStack{
                    Spacer()
                    VStack{
                        Button {
                            isHome = 1
                        } label: {
                            VStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }
                    }
                    Spacer()
                    VStack{
                        Button {
                            isHome = 2
                        } label: {
                            VStack {
                                Image(systemName: "folder")
                                Text("Saved")
                            }
                        }
                    }.frame(maxHeight: .infinity)
                    Spacer()
                    VStack{
                        Button {
                            isHome = 3
                        } label: {
                            VStack {
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                                Text("Logout")
                            }
                        }
                    }.frame(maxHeight: .infinity)
                    Spacer()
                }.bold()
                    .frame(width:450, height:80)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors:[.teal, .green], startPoint: .top , endPoint: .bottomTrailing))
                    )
                    .foregroundColor(.white)
            }.frame(maxHeight: .infinity, alignment: .bottom)
            
        }.ignoresSafeArea()
    }
    
    var home: some View {
        ZStack {
            Text("Characters").foregroundColor(Color.white).font(.system(size:40, weight: .bold, design: .rounded)).offset(x:-50, y:-300)
                
            apiList.offset(x:0, y:70).frame(height:600)
        }
    }
    
    var saved: some View {
        ZStack{
            Text("Saved").foregroundColor(Color.white).font(.system(size:40, weight: .bold, design: .rounded)).offset(x:-50, y:-300)
            Text("Feature \n Coming \n Soon...").foregroundColor(Color.white).font(.system(size:60, weight: .bold, design: .rounded))
        }
    }
    struct CustomColor {
        static let myColor = Color("CardColor")
        // Add more here...
    }
    
    var apiList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing:20) {
                ForEach(0..<(chars?.count ?? 0), id: \.self) {i in
                    renderCard(id: chars?[i])
                }
            }
        }.scrollIndicators(.hidden)
            .onAppear{
                getData()
            }
    }
    
    func renderCard(id:Individual?) -> some View {
        HStack {
            AsyncImage(url: URL(string: id?.image ?? "")) { image in
                      image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          
                  } placeholder: {//hi
                      Color.gray
                  }
                  .frame(width: 85, height: 85).offset(x:5)
            
            VStack (alignment:.leading, spacing:5) {
                HStack {
                    Text(id?.name ?? "").font(.system(size: 22)).bold()
                    HStack (spacing:5) {
                        if  (id?.status ?? "") == "Alive" {
                            Circle()
                                .fill(.green)
                                .frame(width: 8, height: 8)
                        } else if (id?.status ?? "") == "unknown" {
                            Circle()
                                .fill(.orange)//hi
                                .frame(width: 8, height: 8)
                        } else {
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                        }
                        Text(id?.status ?? "").font(.system(size: 12))
                    }.offset(x:10, y:2)
                }
                
                HStack {
                    Text("Species:").font(.system(size: 14))
                    Text(id?.species ?? "").font(.system(size: 14)).offset(x:0, y:0)
                    Text("Gender:").font(.system(size: 14)).offset(x:5, y:0)
                    Text(id?.gender ?? "").font(.system(size: 14)).offset(x:0, y:0)
                }
                HStack{
                    Text("Origin:").font(.system(size: 14))
                    Text(id?.origin.name ?? "").font(.system(size: 14)).offset(x:0, y:0)
                }
            }.offset(x:10, y:-5)
            
            Spacer()
        }.frame(width:360, height:100)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.linearGradient(colors:[CustomColor.myColor, CustomColor.myColor], startPoint: .top , endPoint: .bottomTrailing))
            )
            .foregroundColor(.white)
    }
    
    
    var logout: some View {
        ZStack{
            Text("Logout").foregroundColor(Color.white).font(.system(size:40, weight: .bold, design: .rounded)).offset(x:-50, y:-300)
            
            Button {
                signout()
            } label: {
                Text("Logout")
                    .bold()
                    .frame(width:200, height:40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors:[.teal, .green], startPoint: .top , endPoint: .bottomTrailing))
                    )
                    .foregroundColor(.white)
            }
            .padding(.top)
            .offset(y:100)
        }
    }
    
    var content: some View {
        ZStack {
            mainBg
            
            VStack(spacing: 20){
                Text("Welcome").foregroundColor(Color.white).font(.system(size:40, weight: .bold, design: .rounded)).offset(x:-100, y:-100)
                    
                TextField("Email", text:$email).foregroundColor(.white) .textFieldStyle(.plain)
                    .placeholder(when:email.isEmpty){
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle().frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text:$password).foregroundColor(.white) .textFieldStyle(.plain)
                    .placeholder(when:email.isEmpty){
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle().frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    register()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width:200, height:40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors:[.teal, .green], startPoint: .top , endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y:100)
                
                Button {
                    login()
                } label : {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y:110)
            }
            .frame(width: 350)
            .onAppear() {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var mainBg: some View {
        ZStack{
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous).foregroundStyle(.linearGradient(colors:[.green, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 1000, height: 400).rotationEffect(.degrees(135)).offset(y:-350)
        }
    }
    func getData(){
        let url = "https://rickandmortyapi.com/api/character"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return;
            }
            print(url)
            print(data)
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else {
                print("i got here")
                return
            }
            self.chars=json.results
//            print(json.results[0].name)
        }).resume()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    
    func signout(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        userIsLoggedIn=false
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content : View>(
        when shouldShow:Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
