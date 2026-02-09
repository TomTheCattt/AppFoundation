
import SwiftUI

struct TodoTrackerView: View {
    @StateObject var viewModel: TodoTrackerViewModel
    @State private var newTodoTitle: String = ""

    var body: some View {
        SwiftUIBaseView(
            isLoading: viewModel.isLoading,
            error: viewModel.error,
            onRetry: { viewModel.refresh() }
        ) {
            VStack {
                // Input Area
                HStack {
                    TextField("New Task", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.createTodo(title: newTodoTitle)
                        newTodoTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .disabled(newTodoTitle.isEmpty)
                }
                .padding()

                // List Area
                switch viewModel.state {
                case .idle, .loading:
                    Spacer()
                case .empty:
                    Spacer()
                    Text("No tasks yet. Tap + to add one.")
                        .foregroundColor(.gray)
                    Spacer()
                case .loaded(let items):
                    List {
                        ForEach(items, id: \.id) { item in
                            HStack {
                                Text(item.title)
                                    .strikethrough(item.isCompleted)
                                    .foregroundColor(item.isCompleted ? .gray : .primary)
                                Spacer()
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        viewModel.toggleTodo(id: item.id)
                                    }
                            }
                            .accessibilityIdentifier("row_\(item.id)")
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let item = items[index]
                                viewModel.deleteTodo(id: item.id)
                            }
                        }
                    }
                case .error:
                    Spacer()
                }
            }
            .navigationTitle("Todo Tracker")
        }
        .onAppear {
            viewModel.viewDidLoad()
        }
    }
}
