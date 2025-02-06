import SwiftUI

// MARK: - タブバー View

public struct TabBarView: View {
    // プロパティ
    @Binding private var selectedIndex: Int // 選択されたタブのインデックス
    private let titles: [String] // タブのタイトル
    private let selectedColor: Color // 選択時の文字色

    // 定数
    private let leftOffset: CGFloat = 0.1 // スクロール位置の左オフセット

    // 名前空間
    @Namespace var tabChangeNamespace // タブ切り替えのアニメーション用の名前空間

    /// イニシャライザ
    /// - Parameters:
    ///  - selectedIndex: 選択されたタブのインデックス
    ///  - titles: タブのタイトル
    ///  - selectedColor: 選択時の文字色
    public init(selectedIndex: Binding<Int>,
                titles: [String],
                selectedColor: Color = .gray) {
        self._selectedIndex = selectedIndex
        self.titles = titles
        self.selectedColor = selectedColor
    }

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(titles.indices, id: \.self) { id in
                        VStack(spacing: 5) {
                            // タブタイトル
                            Text(titles[id])
                                .font(.system(size: 14))
                                .foregroundColor(selectedIndex == id ? selectedColor : .gray)
                                .fontWeight(selectedIndex == id ? .bold : .regular)
                                .padding(.top, 12)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = id
                                    }
                                }
                                .animation(nil, value: selectedIndex) // mathedGeometryEffectによるアニメーションを無効にする
                            // 下線
                            if selectedIndex == id {
                                Capsule()
                                    .fill(selectedColor)
                                    .frame(height: 3) // 下線の高さ
                                    .matchedGeometryEffect(id: "underline", in: tabChangeNamespace) // アニメーション
                            } else {
                                Spacer().frame(height: 3) // 空のスペースで揃える
                            }
                        }
                        .id(id)
                    }
                }
            }
            .onChange(of: selectedIndex, initial: false) {
                withAnimation {
                    proxy.scrollTo(selectedIndex, anchor: UnitPoint(x: UnitPoint.leading.x + leftOffset, y: UnitPoint.leading.y))
                }
            }
            .background(.white)
        }
    }
}

// MARK: - プレビュー

#Preview {
    @Previewable @State var selectedIndex = 2
    let tabs = (1 ... 10).map { "Tab\($0)" }

    return VStack(spacing: 0) {
        TabBarView(selectedIndex: $selectedIndex,
                   titles: tabs,
                   selectedColor: .blue)
        TabView(selection: $selectedIndex) {
            ForEach(tabs.indices, id: \.self) { index in
                Text("Page \(tabs[index])").tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(Color(.systemGray6))
    }
}
