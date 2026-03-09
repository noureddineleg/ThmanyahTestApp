//
//  HomeViewModel.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([Section])
        case loadingMore
        case error(String)
    }

    @Published private(set) var state: ViewState = .idle
    @Published var selectedContentFilter: ContentType?

    private let fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseProtocol
    private var allSections: [Section] = []
    private var currentPage = 1
    private var hasMorePages = true
    private var isLoadingMore = false

    init(fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseProtocol) {
        self.fetchHomeSectionsUseCase = fetchHomeSectionsUseCase
    }

    var filteredSections: [Section] {
        guard let filter = selectedContentFilter else {
            return allSections
        }
        return allSections.filter { $0.contentType == filter }
    }

    func loadSections() async {
        state = .loading
        currentPage = 1
        hasMorePages = true

        do {
            let sections = try await fetchHomeSectionsUseCase.execute(page: currentPage)
            allSections = sections
            state = .loaded(filteredSections)
        } catch let error as NetworkError {
            state = .error(error.localizedDescription)
        } catch {
            state = .error("حدث خطأ غير متوقع")
        }
    }

    func refresh() async {
        await loadSections()
    }

    func loadMoreSectionsIfNeeded(currentSection: Section) async {
        guard let lastSection = allSections.last,
              lastSection.id == currentSection.id,
              hasMorePages,
              !isLoadingMore else {
            return
        }

        isLoadingMore = true
        state = .loadingMore
        currentPage += 1

        do {
            let newSections = try await fetchHomeSectionsUseCase.execute(page: currentPage)
            if newSections.isEmpty {
                hasMorePages = false
            } else {
                allSections.append(contentsOf: newSections)
            }
            state = .loaded(filteredSections)
        } catch {
            currentPage -= 1
            state = .loaded(filteredSections)
        }

        isLoadingMore = false
    }

    func selectFilter(_ contentType: ContentType?) {
        selectedContentFilter = contentType
        if !allSections.isEmpty {
            state = .loaded(filteredSections)
        }
    }
}

#if DEBUG
extension HomeViewModel {
    private struct FetchHomeSectionsUseCaseStub: FetchHomeSectionsUseCaseProtocol {
        let sections: [Section]

        func execute(page: Int) async throws -> [Section] {
            sections
        }
    }

    static var previewLoaded: HomeViewModel {
        let viewModel = HomeViewModel(
            fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseStub(sections: PreviewData.homeSections)
        )
        viewModel.allSections = PreviewData.homeSections
        viewModel.state = .loaded(viewModel.filteredSections)
        return viewModel
    }

    static var previewEmpty: HomeViewModel {
        let viewModel = HomeViewModel(
            fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseStub(sections: [])
        )
        viewModel.allSections = []
        viewModel.state = .loaded([])
        return viewModel
    }

    static var previewLoading: HomeViewModel {
        HomeViewModel(
            fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseStub(sections: PreviewData.homeSections)
        ).with { viewModel in
            viewModel.state = .loading
        }
    }

    static var previewError: HomeViewModel {
        let viewModel = HomeViewModel(
            fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseStub(sections: [])
        )
        viewModel.state = .error("تعذر تحميل المحتوى. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.")
        return viewModel
    }
}

private extension HomeViewModel {
    func with(_ configure: (HomeViewModel) -> Void) -> HomeViewModel {
        configure(self)
        return self
    }
}
#endif
