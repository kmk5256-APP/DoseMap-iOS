import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("DoseMap", systemImage: "map.fill")
                            .font(.title2.bold())
                            .foregroundStyle(Color(red: 0.20, green: 0.70, blue: 0.72))

                        Text("A map-based practice companion for nursing and pharmacy dosage calculations.")
                            .foregroundStyle(.secondary)

                        Text("Version 1.0")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 6)
                }

                Section("Privacy") {
                    Label("No account or sign-in", systemImage: "person.crop.circle.badge.xmark")
                    Label("Progress stays on this device", systemImage: "iphone.and.arrow.forward")
                    Label("No ads, analytics, or tracking", systemImage: "hand.raised.fill")
                }

                Section("Important") {
                    Text("DoseMap is an educational practice tool. It is not medical advice and must not be used to calculate or verify doses for patient care. Always follow your school, employer, and current clinical references.")
                    Text("NCLEX® and NAPLEX® are trademarks of their respective owners. DoseMap is not affiliated with or endorsed by NCSBN or NABP.")
                }

                Section("Ai2Life Technologies") {
                    Text("Designed and developed in Pennsylvania by Ai2Life Technologies.")
                    Link("Support", destination: URL(string: "https://ai2life.org/support/dosemap")!)
                    Link("Privacy Policy", destination: URL(string: "https://ai2life.org/dosemap/privacy")!)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
