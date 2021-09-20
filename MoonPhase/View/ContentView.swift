//
//  SmallWidgetView.swift
//  MoonPhase
//
//  Created by Dylan Park on 20/9/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import SwiftUI
import WidgetKit

struct ContentView: View {

    var body: some View {
        
        ZStack(alignment: .center) {
                Color(UIColor(named: "Background Blue")!)
                    .edgesIgnoringSafeArea(.all)
            
                HStack(alignment: .center) {
                    PhaseView()
                    RiseAndSetView()
                }
                .padding()

        }.frame(width: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Phase Image

struct PhaseView: View {
    var body: some View {
        VStack{
            Image("New Moon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
            
            Text("New Moon")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(UIColor(named: "Super Light Grey")!))
                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
        }
    }
}


//MARK: - MoonPhaseView

//struct PhaseLabelView: View {
//    var body: some View {
//        Text("New Moon")
//            .font(.largeTitle)
//            .foregroundColor(Color(UIColor(named: "Super Light Grey")!))
//    }
//}

// MARK: - Rise and Set Stack

struct RiseAndSetView: View {
    var body: some View {
        HStack {
            FirstRiseSetView()
            SecondRiseSetView()
        }
        .padding(.horizontal)
        .padding(.vertical)
        .aspectRatio(contentMode: .fit)
    }
}

//MARK: - Sunrise

struct FirstRiseSetView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("Sunset")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 30, idealWidth: 30, maxWidth: 30, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipped()
            
            Text("6:20pm").frame(minWidth: 0,
                                 maxWidth: .infinity,
                                 minHeight: 0,
                                 maxHeight: .infinity)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white)
        }
        .aspectRatio(contentMode: .fit)
    }
}

//MARK: - Sunset

struct SecondRiseSetView: View {
    var body: some View {
        VStack {
            Image("Moonrise")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 30, idealWidth: 30, maxWidth: 30, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipped()
            
            Text("8:20pm").frame(minWidth: 0,
                                 maxWidth: .infinity,
                                 minHeight: 0,
                                 maxHeight: .infinity)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white)
        }
        .aspectRatio(contentMode: .fit)
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
