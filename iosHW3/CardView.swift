//
//  ContentView.swift
//  iosHW3
//
//  Created by User08 on 2020/10/28.
//

import SwiftUI
import AVFoundation

struct CardView: View {
    @State private var cardColor: Color = Color(red: 225/255, green: 200/255, blue:180/255)
    @State private var brightnessAmount: Double = 0
    @State private var isName: Bool = false
    @State private var makeTime = Date()
    @State private var selectedTheme = 0
    @State private var selectedIndex = 0
    @State private var messenge = ""
    @State private var name = ""
    @State private var picCount = 5
    
    @State private var showCard = false
    @State private var showAlert = false
    @State private var showingActionSheet = false
    
    let messenges = ["Time will abandon\nthose funny oath,\nuntil we also agree.",
                     "Happiness by adding those sad \nthere the elements.",
                     "No man or woman\nis worth your tears,\nand the one who is,\nwon’t make you cry.",
                     "Any one thing,\nas long as be most willing to,\nalways simple.",
                     "If just like\nwhy inflated into love.",
                     "When it has is lost,\nbrave to give up.",
                     "I always like to squat down\nto see the traces of time\non the ground,\nlike rows of ants\npassing through my memory.",
                     "I do not know where to go,\nbut I have been on the road.",
                     "No matter how much I practice\nI can’t make drawings\nof you pretty enough."
    ]
    
    var body: some View {
        GeometryReader{ geometry in
            //let h = geometry.size.height
            let w = geometry.size.width
            ZStack{
                cardColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    MyCardView(cardColor: cardColor, brightnessAmount: brightnessAmount, isName: isName, makeTime: makeTime, selectedTheme: selectedTheme, selectedIndex: selectedIndex, messenge: messenge, name: name, picCount: picCount, w: w-50)
                    
                    Button("Show Card ʕ·ᴥ·ʔ"){
                        if(messenge == ""){
                            showingActionSheet = true
                        }
                        else{
                            showCard = true
                        }
                    }
                    .accentColor(.white)
                    .sheet(isPresented: $showCard){
                        ZStack{
                            cardColor
                                .edgesIgnoringSafeArea(.all)
                            VStack{
                                MyCardView(cardColor: cardColor, brightnessAmount: brightnessAmount, isName: isName, makeTime: makeTime, selectedTheme: selectedTheme, selectedIndex: selectedIndex, messenge: messenge, name: name, picCount: picCount, w: w)
                            
                                Button(action: {showAlert = true}) {
                                    Text("喜歡嗎 ʕ·ᴥ·ʔ")
                                        .modifier(FormTextViewModifier(cardColor: cardColor))
                                 }.alert(isPresented: $showAlert) { () -> Alert in
                                    let answer = "喜歡"
                                    return Alert(title: Text(answer))
                                 }
                            }
                        }
                    }
                    .actionSheet(isPresented: $showingActionSheet){
                        ActionSheet(title: Text("您沒有輸入文字！"), message: Text("或者您想：..."), buttons: [.default(Text("隨機選")){showCard = true
                            messenge = messenges[Int.random(in: 0 ..< messenges.count)]
                        }, .default(Text("自行填寫"))])
                    }
                    
                    FormView(cardColor: $cardColor, brightnessAmount: $brightnessAmount, isName: $isName, makeTime: $makeTime, selectedTheme: $selectedTheme, selectedIndex: $selectedIndex, messenge: $messenge, name: $name, picCount: $picCount)
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}

struct MyCardView: View {
    let cardColor: Color
    let brightnessAmount: Double
    let isName: Bool
    let makeTime:Date
    let selectedTheme:Int
    let selectedIndex:Int
    let messenge:String
    let name:String
    let picCount:Int
    
    let w:CGFloat
    
    var body: some View {
        ZStack{
            cardColor
            Image("bg\(selectedTheme)")
                .resizable()
                .scaledToFill()
                .frame(width: w, height: w)
                .clipped()
                .colorMultiply(cardColor)
                .blendMode(.overlay)
                .opacity(0.8)
                .brightness(brightnessAmount)
            Group{
                ZStack{
                    ForEach(0 ..< picCount){(index) in
                        let num = Int.random(in: 0 ..< themes[selectedTheme].picCount)
                        let ranX = CGFloat.random(in: 25...w-25)
                        let ranY = CGFloat.random(in: 25...w-25)
                        let ranDegree = Double.random(in: 0...360)
                        Image("\(themes[selectedTheme].picName)\(num)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: w/3)
                            .rotationEffect(.degrees(ranDegree)).offset(x: ranX - w/2, y: ranY - w/2)
//                                    .blendMode(.normal)
                    }
                }.frame(width: w, height: w)
            }
            VStack{
                Spacer()
                ZStack{
//                    cardColor.colorInvert()
//                        .frame(width: w-100, height: w-200)
//                        .opacity(0.75)
                    Text(messenge)
                        .font(.custom("OliverBlush-Regular", size: 35))
                        .foregroundColor(Color(red: 0.65, green: 0.65, blue: 0.65))
                    Text(messenge)
                        .font(.custom("OliverBlush-Regular", size: 35))
                        .foregroundColor(Color.white)
                        .offset(x: -3.0, y:-2.0)
                }.padding()
                
                Color.white
                    .frame(width: w-50, height: 10)
                Color.white
                    .frame(width: w-100, height: 5)
                
                HStack{
                    Spacer()
                    Text(name + "   ")
                        .font(.custom("", size: 20))
                        .foregroundColor(Color.white)
                }.padding()
                HStack{
                    Spacer()
                    Text(makeTime, style: .date)
                        .font(.custom("", size: 15))
                        .foregroundColor(Color.white)
                }.padding()
            }
        }.frame(width: w, height: w)
    }
}

struct FormView: View {
    @Binding var cardColor: Color
    @Binding var brightnessAmount: Double
    @Binding var isName: Bool
    @Binding var makeTime:Date
    @Binding var selectedTheme:Int
    @Binding var selectedIndex:Int
    @Binding var messenge:String
    @Binding var name:String
    @Binding var picCount:Int
    
    var body: some View {
        Form{
            HStack{
                Text("> 選擇卡片顏色")
                    .modifier(FormTextViewModifier(cardColor: cardColor))
                Spacer()
                ColorPicker("Set your card color", selection: $cardColor)
                    .labelsHidden()
            }
            Picker(selection: $selectedTheme, label: Text("Choose a theme")){
                ForEach(0 ..< themes.count){
                    (index) in
                    Text(themes[index].theme)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextEditor(text: $messenge)
                .foregroundColor(cardColor)
                .padding(5)
                .border(cardColor, width: 5)
                .background(cardColor.colorInvert())
            
            HStack{
                Text("\(brightnessAmount, specifier: "%.2f")")
                    .modifier(FormTextViewModifier(cardColor: cardColor))
                Slider(value: $brightnessAmount, in: -1...1, step: 0.01)
                    .accentColor(cardColor)
            }
            HStack{
                Text("> 輸入名字")
                    .modifier(FormTextViewModifier(cardColor: cardColor))
                Spacer()
                Toggle("Input Name", isOn: $isName)
                    .labelsHidden()
                    .onChange(of: isName, perform: { value in
                        if !value{
                            name = ""
                        }
                    })
            }
            if isName{
                TextField("Name: ", text: $name)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(cardColor, lineWidth: 5))
            }
            
            HStack{
                Text("> 選擇日期")
                    .modifier(FormTextViewModifier(cardColor: cardColor))
                Spacer()
                DatePicker("Make time", selection: $makeTime, in: Date()..., displayedComponents: .date)
                    .labelsHidden()
                    .accentColor(cardColor)
            }
            DisclosureGroup(""){
                Stepper(value: $picCount, in: 4...12){
                    Text("click me!")
                        .modifier(FormTextViewModifier(cardColor: cardColor))
                }
            }
        }
        .background(cardColor)
        .cornerRadius(20)
        .padding()
    }
}

struct FormTextViewModifier: ViewModifier {
    let cardColor:Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(cardColor)
            .padding(15)
            .background(cardColor.colorInvert())
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(cardColor, lineWidth: 5))
    }
}
