//
//  EnumeratedForEach.swift
//  MarkdownUI
//
//  Created by David Walter on 15.03.25.
//

import SwiftUI

struct EnumeratedForEach<Data, Content>: View where Data: RandomAccessCollection, Data.Index == Int, Content: View {
    let data: Data
    let content: (_ index: Int, _ element: Data.Element) -> Content

    init(_ data: Data, @ViewBuilder content: @escaping (_ index: Int, _ item: Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        ForEach(data.indices, id: \.self) { index in
            content(index, data[index])
        }
    }
}
