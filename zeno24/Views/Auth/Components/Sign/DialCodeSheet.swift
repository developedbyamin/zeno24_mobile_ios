import SwiftUI

struct DialCodeSheet: View {
    @Binding var selected: Country
    let onPick: () -> Void

    @State private var vm = DialCodeViewModel()
    @FocusState private var searchFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            header
            countryList
        }
        .background(Color.white)
        .presentationDetents([.fraction(0.9)])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 16) {
            titleRow
                .frame(height: searchFocused ? 0 : 24, alignment: .top)
                .opacity(searchFocused ? 0 : 1)
                .scaleEffect(searchFocused ? 0.96 : 1, anchor: .top)
                .clipped()

            HStack(spacing: 12) {
                searchField

                Button {
                    vm.clearQuery()
                    searchFocused = false
                } label: {
                    Text(AppStrings.Common.cancel)
                        .font(AppTypography.bodyMdMedium)
                        .foregroundStyle(AppColors.brand)
                        .fixedSize()
                }
                .buttonStyle(.plain)
                .opacity(searchFocused ? 1 : 0)
                .frame(width: searchFocused ? nil : 0, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .animation(.smooth(duration: 0.28, extraBounce: 0.06), value: searchFocused)
    }

    private var titleRow: some View {
        ZStack {
            Text(AppStrings.CountryPicker.title)
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            HStack {
                Spacer()
                Button { onPick() } label: {
                    ZStack {
                        Circle()
                            .fill(AppColors.mainGray)
                            .frame(width: 24, height: 24)
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(AppColors.secondaryBlack)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AppColors.secondaryBlack)

            TextField(AppStrings.CountryPicker.search, text: Binding(
                get: { vm.query },
                set: { vm.query = $0 }
            ))
            .font(AppTypography.bodySmMedium)
            .foregroundStyle(AppColors.mainBlack)
            .tint(AppColors.brand)
            .focused($searchFocused)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            if !vm.query.isEmpty {
                Button { vm.clearQuery() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(AppColors.bodyTextGray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(AppColors.mainGray, in: Capsule())
    }

    // MARK: - List

    @ViewBuilder
    private var countryList: some View {
        if vm.query.isEmpty {
            groupedList
        } else {
            flatList
        }
    }

    @ViewBuilder
    private var flatList: some View {
        if vm.filtered.isEmpty {
            emptyState
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(vm.filtered) { country in
                        CountryRow(country: country, isSelected: country.id == selected.id)
                            .contentShape(Rectangle())
                            .onTapGesture { pick(country) }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.mainGray)
                    .frame(width: 64, height: 64)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(AppColors.bodyTextGray)
            }

            Text(AppStrings.CountryPicker.emptyTitle)
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            Text(AppStrings.CountryPicker.emptySubtitle)
                .font(AppTypography.bodySmMedium)
                .foregroundStyle(AppColors.bodyTextGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }

    private var groupedList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    let popular = vm.sortedPopular
                    if !popular.isEmpty {
                        Section {
                            ForEach(popular) { country in
                                CountryRow(country: country, isSelected: country.id == selected.id)
                                    .id("popular_\(country.id)")
                                    .contentShape(Rectangle())
                                    .onTapGesture { pick(country) }
                            }
                        } header: {
                            sectionHeader(AppStrings.CountryPicker.popular)
                        }
                    }

                    ForEach(vm.letters, id: \.self) { letter in
                        Section {
                            ForEach(vm.grouped[letter] ?? []) { country in
                                CountryRow(country: country, isSelected: country.id == selected.id)
                                    .id(country.id)
                                    .contentShape(Rectangle())
                                    .onTapGesture { pick(country) }
                            }
                        } header: {
                            sectionHeader(letter)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    try? await Task.sleep(for: .milliseconds(150))
                    let target = selected.isPopular ? "popular_\(selected.id)" : selected.id
                    withAnimation { proxy.scrollTo(target, anchor: .center) }
                }
            }
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(AppColors.bodyTextGray)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.secondaryGray)
    }

    private func pick(_ country: Country) {
        selected = country
        Haptics.selection()
        onPick()
    }
}

// MARK: - Row

private struct CountryRow: View {
    let country: Country
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.mainGray)
                    .frame(width: 44, height: 44)
                Text(country.flag)
                    .font(.system(size: 22))
            }

            HStack {
                Text(country.name)
                    .font(isSelected ? AppTypography.bodyMdSemiBold : AppTypography.bodyMdMedium)
                    .foregroundStyle(isSelected ? AppColors.brand : AppColors.mainBlack)

                Spacer()

                Text(country.dialCode)
                    .font(AppTypography.bodyMdRegular)
                    .foregroundStyle(isSelected ? AppColors.brand : AppColors.bodyTextGray)
            }
            .padding(.bottom, 12)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(AppColors.mainGray)
                    .frame(height: 1)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isSelected ? AppColors.brand.opacity(0.15) : Color.white)
    }
}
