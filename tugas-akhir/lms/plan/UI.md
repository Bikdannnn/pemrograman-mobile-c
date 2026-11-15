# LMS (Lele Management System) - UI/UX Implementation Plan & Technical Blueprint

> **Status**: Ready for Direct Agent Implementation  
> **Target Framework**: Flutter (Dart)  
> **Primary Language**: Bahasa Indonesia  
> **Source Specification**: `Product_specs.md` (Dated Nov 16, 2026)

---

## 1. Executive Summary & Design Philosophy

LMS is an offline-first mobile application built for small-to-medium Indonesian lele (catfish) pond farmers (operating 3–20 ponds, primarily plastic tarpaulin / *kolam terpal*).

According to `Product_specs.md`, LMS is strictly a **"Medicine, not a Vitamin"**:
1. **Primary Purpose**: Stop sudden fish deaths (MAS/Aeromonas, hypoxia), prevent wasted feed (60–70% of farm costs), and eliminate delayed farmer reactions.
2. **The Golden Rule**: Every screen must directly or immediately answer: *"Apa yang harus dilakukan peternak sekarang?"* (What should the farmer do now?).
3. **Safety Guarantee**: LMS **NEVER** prescribes drugs, antibiotics, or exact chemical dosages. It provides risk estimates (*Perkiraan Risiko*) and environmental action steps (aeration, feeding reduction/pause, dead fish removal, water flushing, expert escalation).
4. **Outdoor Usability**: Designed for high-glare sunlight, wet pond environments, and low-cost Android phones. Features minimum 56dp touch targets, bold high-contrast status colors, prominent icons paired with plain Indonesian text, and completion of daily checks in under 1 minute.
5. **Radical Transparency (The Anti-eFishery Trust Core)**: All proof, avoided losses, and FCR metrics disclose their exact mathematical formulas and baselines.

---

## 2. Core UI Design Tokens (High-Contrast Outdoor Design System)

Farmers operate in bright sunlight near reflective water with wet or muddy hands. The color palette avoids subtle pastels and uses bold, deeply saturated colors with high contrast ratios (WCAG AAA compliant where possible).

### 2.1 Color Tokens
| Token Name | Hex Code | UI Usage & Semantics |
| :--- | :--- | :--- |
| `AppColors.riskLow` | `#1B5E20` | Safe / Aman (Deep forest green card background, badges) |
| `AppColors.riskLowText` | `#E8F5E9` | Light green text/icons on safe backgrounds |
| `AppColors.riskMedium` | `#E65100` | Warning / Waspada (Deep amber/orange, warning borders) |
| `AppColors.riskMediumText` | `#FFF3E0` | Light amber text on warning backgrounds |
| `AppColors.riskHigh` | `#B71C1C` | Danger / Bahaya (Intense blood red for urgent alert banners) |
| `AppColors.riskHighText` | `#FFEBEE` | Crisp white/pinkish text on danger banners |
| `AppColors.brandNavy` | `#1A237E` | App bar, pond switcher, primary buttons |
| `AppColors.brandNavySurface` | `#E8EAF6` | Subtle blue tint for highlighted cards |
| `AppColors.feedAccent` | `#00695C` | Teal for feed guard & FCR metrics |
| `AppColors.surfaceBg` | `#F4F5F7` | Neutral grey background to prevent sun glare |
| `AppColors.cardBg` | `#FFFFFF` | Crisp white elevated cards |
| `AppColors.textPrimary` | `#111827` | High-contrast near-black for body & labels |
| `AppColors.textSecondary` | `#4B5563` | Subtitle & timestamp grey |
| `AppColors.border` | `#D1D5DB` | 1.5dp distinct borders for outdoor form inputs |

### 2.2 Typography Tokens (Large Readable Scale)
* Base Font: System Default Sans (Roboto / Android Sans) with bold weights for outdoors.
* `headlineRisk`: 24sp, Bold, LineHeight 1.2
* `titleSection`: 18sp, Bold, LineHeight 1.3
* `titleCard`: 16sp, SemiBold
* `bodyMain`: 15sp, Regular/Medium (Minimum readable size outdoor)
* `labelBadge`: 13sp, Bold, Uppercase
* `timerCountdown`: 22sp, Monospace / Bold (for action deadlines)

### 2.3 Component Dimension Guidelines
* **Minimum Touch Target**: 56dp x 56dp for primary action buttons; 48dp x 48dp for input chips.
* **Card Elevation**: 2dp to 4dp with crisp 1.5dp borders for distinction under glare.
* **Form Inputs**: Segmented buttons, visual chips, and big `+` / `-` incrementers rather than manual numeric keyboard inputs.

---

## 3. Complete Data Architecture & State Contracts

The app is 100% offline-first. The following data models define the state contracts:

```dart
// Enums
enum RiskLevel { aman, waspada, bahaya }

enum WaterColor {
  hijauTua,      // Normal/good phytoplankton
  hijauCokelat,  // Shifting bloom
  cokelatKeruh,  // High organic waste/turbidity
  merahBerbusa,  // High bacterial crash or toxic bloom
}

enum WaterSmell {
  segar,         // Fresh earthy pond smell
  amonia,        // Pungent chemical ammonia
  busuk,         // Decaying organic matter / H2S
}

enum FishBehavior {
  normal,        // Swimming actively below surface
  menggantung,   // Gasping / hanging vertically at surface (hypoxia)
  pasif,         // Lethargic at corners
  berenangMiring // Erratic / spiraling / flashing
}

enum FeedSession { pagi, siang, sore, malam }

enum PondType { terpal, tanah, semen, bioflok }

// Models
class Pond {
  final String id;
  final String name;             // e.g. "Kolam Terpal 01"
  final PondType type;
  final double diameterOrLength; // meters
  final double depth;            // meters
  final int fishCount;           // current alive estimate
  final DateTime stockingDate;   // tebar benih date
  final String activeCycleId;
  final bool isArchived;
}

class DailyCheck {
  final String id;
  final String pondId;
  final String cycleId;
  final DateTime timestamp;
  final bool isMorningCheck;      // true = 05:30 check, false = 15:00 check
  final WaterColor waterColor;
  final WaterSmell waterSmell;
  final FishBehavior fishBehavior;
  final bool hasUneatenFeed;
  final double? waterTempC;       // e.g. 28.5
  final int deadFishCount;        // >= 0
  final double? phValue;          // e.g. 7.2 (optional)
  final RiskEvaluation evaluation;
}

class ActionStep {
  final String id;
  final String title;             // e.g. "Nyalakan Aerasi / Kocor Air"
  final String detail;            // "Tingkatkan oksigen terlarut segera"
  final int deadlineMinutes;      // e.g. 30
  final DateTime createdAt;
  bool isCompleted;
}

class RiskEvaluation {
  final RiskLevel level;
  final String summaryTitle;      // e.g. "Risiko Bahaya: Indikasi Hipoksia Berat"
  final List<String> reasons;     // ["Ikan menggantung di permukaan", "Pakan semalam sisa"]
  final List<ActionStep> actions;
  final int recommendedFeedReductionPercent; // 0, 30, 50, or 100 (puasa)
  final int maxFeedPauseHours;    // maximum fasting allowed before next mandatory check
  final DateTime nextCheckDue;    // e.g. 09:00 WIB
  final bool requiresExpertEscalation;
}

class FeedLog {
  final String id;
  final String pondId;
  final String cycleId;
  final DateTime timestamp;
  final FeedSession session;
  final double plannedWeightKg;   // target according to feeding table
  final double actualGivenKg;     // amount actually fed
  final bool leftoverNoticed;     // uneaten feed found before session
  final String? note;
}

class FishSampling {
  final String id;
  final String pondId;
  final String cycleId;
  final DateTime date;
  final int sampleCount;          // e.g. 30 ekor
  final double totalSampleWeightKg; // e.g. 3.0 kg
  final double avgWeightGram;     // 100 gram/ekor
}

class CycleSummary {
  final String cycleId;
  final String pondId;
  final DateTime startDate;
  final DateTime? harvestDate;
  final int initialSeedCount;     // e.g. 5,000 ekor
  final int totalMortality;       // sum of daily dead fish
  final double totalFeedGivenKg;  // sum of feed logs
  final double? harvestedWeightKg;// final biomass harvested
  final double currentFcr;        // feed / biomass gained
  final double estimatedAvoidedLossRp; // Transparent calculation
  final String baselineComparison; // e.g. "Dibanding siklus lalu (Mortalitas 28%)"
  final bool isCompleted;
}

class FalseAlarmReport {
  final String id;
  final String pondId;
  final DateTime timestamp;
  final RiskLevel evaluatedLevel;
  final String farmerFeedback;    // e.g. "Ikan sebenarnya kenyang, air jernih"
  final DateTime createdAt;
}

class ExtensionOfficer {
  final String name;
  final String phone;             // WhatsApp compatible phone number
  final String institution;       // e.g. "Penyuluh Dinas Perikanan Buleleng"
}
```

---

## 4. Deterministic Offline Rule Engine (Strict Product Logic)

`Product_specs.md` explicitly mandates deterministic expert rules with full transparency (no opaque AI/ML black box). The engine must produce consistent, explainable results offline.

### 4.1 Evaluation Rules Matrix

```dart
RiskEvaluation evaluateDailyCheck({
  required WaterColor color,
  required WaterSmell smell,
  required FishBehavior behavior,
  required bool hasUneatenFeed,
  required int deadFish,
  required double? ph,
  required double? temp,
}) {
  List<String> reasons = [];
  List<ActionStep> actions = [];
  RiskLevel level = RiskLevel.aman;
  int feedReduction = 0;
  int maxPauseHours = 0;
  bool expertEscalation = false;

  // 1. High Risk (Bahaya) Triggers
  if (behavior == FishBehavior.menggantung && hasUneatenFeed) {
    level = RiskLevel.bahaya;
    reasons.add("Ikan menggantung di permukaan & pakan semalam sisa (Indikasi Oksigen Kritis / Hipoksia)");
    actions.add(ActionStep(
      id: "a1",
      title: "Nyalakan Aerasi / Kocor Air Segera",
      detail: "Alirkan air segar atau nyalakan aerator untuk menambah oksigen terlarut.",
      deadlineMinutes: 30,
      createdAt: DateTime.now(),
    ));
    actions.add(ActionStep(
      id: "a2",
      title: "Tunda Pakan Pagi Ini",
      detail: "Jangan tebar pakan hingga pengecekan ulang pukul 09:00 WIB.",
      deadlineMinutes: 180,
      createdAt: DateTime.now(),
    ));
    feedReduction = 100;
    maxPauseHours = 6;
  }

  if (deadFish >= 10 || (deadFish > 0 && behavior != FishBehavior.normal)) {
    level = RiskLevel.bahaya;
    reasons.add("Kematian ikan signifikan ($deadFish ekor) terdeteksi hari ini");
    actions.add(ActionStep(
      id: "a3",
      title: "Serok & Ambil Bangkai Ikan Segera",
      detail: "Keluarkan bangkai agar amonia dan bakteri tidak menyebar.",
      deadlineMinutes: 45,
      createdAt: DateTime.now(),
    ));
    expertEscalation = true;
  }

  if (smell == WaterSmell.amonia || smell == WaterSmell.busuk) {
    if (level != RiskLevel.bahaya) level = RiskLevel.waspada;
    reasons.add("Air berbau menyengat (${smell == WaterSmell.amonia ? 'Amonia tinggi' : 'Pembusukan sisa organik'})");
    actions.add(ActionStep(
      id: "a4",
      title: "Buka Pembuangan Dasar (Siphon) 10-20%",
      detail: "Buang endapan kotoran dasar kolam dan ganti dengan air baru secara perlahan.",
      deadlineMinutes: 120,
      createdAt: DateTime.now(),
    ));
    feedReduction = feedReduction < 30 ? 30 : feedReduction;
  }

  if (color == WaterColor.merahBerbusa || color == WaterColor.cokelatKeruh) {
    if (level != RiskLevel.bahaya) level = RiskLevel.waspada;
    reasons.add("Warna air menunjukkan ledakan bakteri atau tumpukan feses");
    feedReduction = feedReduction < 30 ? 30 : feedReduction;
  }

  // 2. Medium Risk (Waspada) Triggers
  if (level == RiskLevel.aman) {
    if (hasUneatenFeed) {
      level = RiskLevel.waspada;
      reasons.add("Terdapat sisa pakan yang tidak habis dikonsumsi");
      actions.add(ActionStep(
        id: "a5",
        title: "Kurangi Porsi Pakan Berikutnya 30-50%",
        detail: "Cegah pembusukan pakan di dasar kolam.",
        deadlineMinutes: 180,
        createdAt: DateTime.now(),
      ));
      feedReduction = 30;
      maxPauseHours = 6;
    } else if (deadFish > 0 && deadFish < 10) {
      level = RiskLevel.waspada;
      reasons.add("Terlihat $deadFish ekor bangkai ikan di permukaan");
      actions.add(ActionStep(
        id: "a6",
        title: "Angkat Bangkai Ikan Segera",
        detail: "Cek tanda fisik bintik merah atau luka pada ikan mati.",
        deadlineMinutes: 60,
        createdAt: DateTime.now(),
      ));
    }
  }

  // 3. Low Risk (Aman) Fallback
  if (level == RiskLevel.aman) {
    reasons.add("Kondisi air segar, nafsu makan aktif, dan tidak ada kematian mencurigakan");
    actions.add(ActionStep(
      id: "a7",
      title: "Lanjutkan Jadwal Pakan Sesuai Rencana",
      detail: "Pertahankan aerasi dan pantau kembali sore hari pukul 15:00 WIB.",
      deadlineMinutes: 480,
      createdAt: DateTime.now(),
    ));
    feedReduction = 0;
  }

  // Next check timing
  final now = DateTime.now();
  final nextCheck = level == RiskLevel.bahaya 
      ? now.add(const Duration(hours: 3)) 
      : (now.hour < 12 
          ? DateTime(now.year, now.month, now.day, 15, 0)
          : DateTime(now.year, now.month, now.day + 1, 5, 30));

  return RiskEvaluation(
    level: level,
    summaryTitle: level == RiskLevel.bahaya
        ? "BAHAYA: Butuh Tindakan Cepat!"
        : (level == RiskLevel.waspada ? "WASPADA: Lakukan Penyesuaian" : "AMAN: Kondisi Stabil"),
    reasons: reasons,
    actions: actions.take(3).toList(), // Maximum 3 concrete steps
    recommendedFeedReductionPercent: feedReduction,
    maxFeedPauseHours: maxPauseHours,
    nextCheckDue: nextCheck,
    requiresExpertEscalation: expertEscalation || (level == RiskLevel.bahaya),
  );
}
```

---

## 5. Screen-by-Screen Specifications & Wireframes

The app architecture comprises **4 Primary Navigation Tabs** and **6 Contextual Modals/Workflows**.

```
┌────────────────────────────────────────────────────────┐
│ [Kolam 01 - Terpal (Aktif) ▼]         [● Offline OK]  │ (Global App Bar)
├────────────────────────────────────────────────────────┤
│                                                        │
│                    MAIN TAB CONTENT                    │
│   (1. Beranda  |  2. Pakan  |  3. Bukti  | 4. Kolam)  │
│                                                        │
├────────────────────────────────────────────────────────┤
│ [🏠 Beranda]   [🌾 Pakan]    [📊 Bukti]   [⚙️ Pengaturan] │ (Bottom Nav)
└────────────────────────────────────────────────────────┘
```

---

### 5.1 Tab 1: Beranda (Home / Action Center)
The entry screen is optimized for the **10-Second Test**: The farmer must grasp what is wrong and what to do within 10 seconds under broad daylight.

#### ASCII Layout:
```
┌────────────────────────────────────────────────────────┐
│ LMS (Lele Sehat) - Kolam 01 ▼           [● Offline OK] │
├────────────────────────────────────────────────────────┤
│ ┌────────────────────────────────────────────────────┐ │
│ │ 🚨 RISIKO BAHAYA: OKSIGEN KRITIS TERDETEKSI        │ │
│ │ Karena: Ikan gantung permukaan & pakan sisa        │ │
│ │ Cek: Pagi Ini (05:32 WIB)                          │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ ⚡ APA YANG HARUS DILAKUKAN SEKARANG:                  │
│ ┌────────────────────────────────────────────────────┐ │
│ │ [ ] 1. Nyalakan Aerasi / Kocor Air Segera          │ │
│ │     Batas Waktu: 28 Menit Lagi (06:00 WIB)         │ │
│ │     [Tandai Selesai ✓]                             │ │
│ ├────────────────────────────────────────────────────┤ │
│ │ [ ] 2. Tunda Pemberian Pakan Pagi Ini              │ │
│ │     Batas Waktu: Sampai Cek Ulang 09:00 WIB        │ │
│ │     [Tandai Selesai ✓]                             │ │
│ ├────────────────────────────────────────────────────┤ │
│ │ [ ] 3. Angkat & Buang Bangkai Ikan Terlihat        │ │
│ │     Batas Waktu: 40 Menit Lagi                     │ │
│ │     [Tandai Selesai ✓]                             │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ ┌────────────────────────────────────────────────────┐ │
│ │ 👨‍🌾 Hubungi Penyuluh / Ahli Perikanan               │ │
│ │ Pak Budi (Dinas Perikanan) - WA / Telepon           │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ ┌────────────────────────────────────────────────────┐ │
│ │ 🕒 JADWAL CEK BERIKUTNYA:                          │ │
│ │ Cek Ulang Kondisi: 09:00 WIB (Dalam 3 Jam 15 Menit) │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ ┌────────────────────────────────────────────────────┐ │
│ │ [ 📝 INPUT CEK KONDISI AIR & IKAN (< 1 MENIT) ]    │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ [ ⚠️ Lapor Alarm Palsu ]     [ ℹ️ Lihat Riwayat Cek ]   │
└────────────────────────────────────────────────────────┘
```

#### Detailed Interaction Elements:
1. **Pond Selector Dropdown**: Tapping opens a quick bottom sheet listing all ponds (Kolam 1–20) with mini status badges (`Aman`, `Waspada`, `Bahaya`). Switching updates the entire screen context immediately.
2. **Dynamic Risk Banner**:
   - `Bahaya`: Intense red background (`#B71C1C`), white bold text, pulsing warning icon.
   - `Waspada`: Deep amber background (`#E65100`), white bold text.
   - `Aman`: Dark green background (`#1B5E20`), white text, "Kondisi Kolam Prima".
3. **Action Step Checklist**: Each step card includes an interactive checkbox and "Tandai Selesai" button. Marking complete strikes through the text and saves the timestamp locally.
4. **Escalation Button**: Visible when Risk is `Bahaya` or when high risk persists for 2 consecutive checks. Tapping opens WhatsApp directly with a pre-formatted message:
   *"Halo Pak Budi, saya peternak Kolam 01. Aplikasi LMS mendeteksi risiko Bahaya: Ikan menggantung dan pakan sisa. Mohon arahannya."*
5. **Report False Alarm**: Small secondary text button at bottom. Opens the False Alarm Feedback dialog.
6. **Primary CTA**: Floating/pinned large button (`56dp` height) labeled **"Input Cek Kondisi Air & Ikan"** leading to Screen 5.2.

---

### 5.2 Modal Workflow: Form Cek Harian (Daily Check Form)
Strict requirement: Must be completable in **under 1 minute** using single-tap visual chips and large increment buttons.

#### ASCII Layout:
```
┌────────────────────────────────────────────────────────┐
│ [✕] Cek Kondisi Kolam 01               [05:30 WIB Pagi]│
├────────────────────────────────────────────────────────┤
│ 1. Warna Air Kolam:                                    │
│ [🟢 Hijau Tua] [🟡 Hijau Cokelat]                      │
│ [🟤 Cokelat Keruh] [🔴 Merah / Berbusa]                │
│                                                        │
│ 2. Bau Air Kolam:                                      │
│ [💧 Normal/Segar] [🧪 Bau Amonia] [🦨 Bau Busuk]      │
│                                                        │
│ 3. Perilaku Ikan di Permukaan:                         │
│ [🐟 Berenang Normal] [🫧 Menggantung di Permukaan]     │
│ [😴 Pasif di Pojok]  [⚡ Gerakan Miring/Liar]         │
│                                                        │
│ 4. Pakan Sisa Tadi Malam / Sesi Terakhir:              │
│ [ (✓) Tidak Ada Sisa ]    [ ( ) Ada Pakan Mengapung ]  │
│                                                        │
│ 5. Jumlah Ikan Mati Ditemukan:                         │
│ ┌────────────────────────────────────────────────────┐ │
│ │      [ - 5 ]   [ - 1 ]    [  0  ]   [ + 1 ]   [ + 5 ]│
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ 6. Suhu Air (Opsional):                                │
│ [ 26°C ] [ 27°C ] [ 28°C (Normal) ] [ 29°C ] [ 30°C+ ] │
│                                                        │
│ 7. Nilai pH Air (Jika punya alat ukur / kertas lakmus):│
│ [ - ]  Nilai: [ 7.2 ]  [ + ]                           │
│                                                        │
├────────────────────────────────────────────────────────┤
│ [   HITUNG TINGKAT RISIKO & SIMPAN TINDAKAN (✓)   ]    │
└────────────────────────────────────────────────────────┘
```

#### Detailed Interaction Elements:
1. **Visual Choice Chips**: Single-select chips with clear active borders (3dp `#1A237E`) and contrasting backgrounds.
2. **Dead Fish Counter**: Big step buttons `[-5]`, `[-1]`, `[+1]`, `[+5]` so the farmer doesn't need to trigger the software keyboard with wet fingers.
3. **Optional Measurements**: Suhu and pH clearly labeled as optional. If skipped, default standard thresholds apply.
4. **Instant Evaluation Overlay**: Upon tapping Submit, the app runs `evaluateDailyCheck()` locally in 0 milliseconds and pops up an immediate modal result:
   - Evaluated Level (Aman / Waspada / Bahaya)
   - 1–3 concrete action tasks generated
   - Next check time recorded into phone notifications.

---

### 5.3 Tab 2: Cek Pakan (Feed Guard Screen)
Feed represents 60–70% of catfish production costs. Feed Guard stops wasted money and prevents water fouling.

#### ASCII Layout:
```
┌────────────────────────────────────────────────────────┐
│ Pakan Guard - Kolam 01                  [Target: 12 kg]│
├────────────────────────────────────────────────────────┤
│ ┌────────────────────────────────────────────────────┐ │
│ │ 📉 INSTRUKSI PAKAN HARI INI:                       │ │
│ │ KURANGI PAKAN 30% DARI RENCANA                     │ │
│ │ Alasan: Risiko Waspada & amonia terdeteksi tadi pagi │ │
│ │ Jatah Pagi: 2.8 kg (Normal: 4.0 kg)                │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ ┌────────────────────────────────────────────────────┐ │
│ │ 📊 INDIKATOR FCR SIKLUS INI:                       │ │
│ │ FCR Berjalan: 1.08  |  Target Ideal: ≤ 1.15         │ │
│ │ Total Pakan Masuk: 420 kg  | Biomassa Taksir: 388 kg│ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ [ ➕ CATAT PEMBERIAN PAKAN (SESI INI) ]                 │
│                                                        │
│ 📅 JADWAL & RIWAYAT PAKAN HARI INI:                    │
│ ┌────────────────────────────────────────────────────┐ │
│ │ 🌅 Pagi (07:00 WIB)  - 2.8 kg Diberikan [Selesai ✓]│ │
│ │ ☀️ Siang (12:00 WIB) - 4.0 kg Direncanakan         │ │
│ │ 🌙 Malam (19:00 WIB) - 4.0 kg Direncanakan         │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ ⚖️ SAMPLING BOBOT IKAN TERAKHIR:                       │
│ 14 Nov 2026: Rata-rata 85 gram/ekor (Sampling 30 ekor) │
│ [ ⚖️ Input Sampling Baru ]                              │
└────────────────────────────────────────────────────────┘
```

#### Detailed Interaction Elements:
1. **Feed Reduction Banner**: Directly reflects the latest `RiskEvaluation`. If feed pause is active, displays:
   *"⛔ TUNDA PAKAN SAMPAI 09:00 WIB - Maksimal puasa tersisa: 3.5 jam"*. (Guarantees compliance with Section 5 of Product Specs preventing over-fasting).
2. **FCR Metric Card**: Transparent calculation display. Shows formula helper tooltip:
   `FCR = Total Pakan Diberikan (kg) ÷ Pertambahan Bobot Ikan (kg)`.
3. **Modal Catat Pakan**: Quick pop-up allowing farmer to record:
   - Sesi: Pagi / Siang / Sore / Malam
   - Berat pakan diberikan (kg) with quick +/- buttons (e.g. 1kg, 0.5kg, 0.1kg)
   - Toggle: "Apakah ada sisa mengambang sebelum sesi ini?"
4. **Modal Sampling Bobot Ikan**: Records number of sampled fish (e.g. 25 ekor) and combined bucket weight in kg. Calculates average weight per fish automatically to update biomass and daily feed table.

---

### 5.4 Tab 3: Riwayat & Bukti (Proof & Cycle Log Screen)
This tab passes Question 4 of the **Medicine Test**: *"Can the farmer see saved money within one cycle?"* It is the bedrock of renewal trust.

#### ASCII Layout:
```
┌────────────────────────────────────────────────────────┐
│ Bukti Penghematan & Siklus - Kolam 01   [Hari ke-48]   │
├────────────────────────────────────────────────────────┤
│ ┌────────────────────────────────────────────────────┐ │
│ │ 💰 ESTIMASI KERUGIAN DICEGAH:                      │ │
│ │ Rp 2.450.000                                       │ │
│ │                                                    │ │
│ │ ℹ️ METODE PERHITUNGAN TRANSPARAN:                  │ │
│ │ • Penurunan Kematian: 350 ekor vs siklus lalu      │ │
│ │   (Nilai ikan saat panen: Rp 1.400.000)             │ │
│ │ • Pakan Dihemat: 75 kg dari pencegahan overfeeding │ │
│ │   (Harga pakan Rp 14.000/kg = Rp 1.050.000)        │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ 📊 GRAFIK KEMATIAN MINGGUAN (EKOR):                   │
│ M1: ███ (18)                                           │
│ M2: █ (6)                                              │
│ M3: ████ (25 - Insiden Air Teratasi)                   │
│ M4: █ (4)                                              │
│ M5: █ (2)                                              │
│                                                        │
│ 📋 LOG KEJADIAN & TINDAKAN SIKLUS INI:                 │
│ ┌────────────────────────────────────────────────────┐ │
│ │ 12 Nov, 05:30 WIB - [Bahaya] Oksigen Rendah        │ │
│ │ Tindakan: Aerasi dinyalakan, pakan dipause 3 jam   │ │
│ │ Hasil: Kematian nihil, risiko turun ke Aman 09:00  │ │
│ ├────────────────────────────────────────────────────┤ │
│ │ 04 Nov, 15:10 WIB - [Waspada] Bau Amonia           │ │
│ │ Tindakan: Siphon dasar 15%, pakan dipotong 30%     │ │
│ │ Hasil: Kualitas air pulih dalam 24 jam             │ │
│ └────────────────────────────────────────────────────┘ │
│                                                        │
│ [ 🏁 Selesaikan Siklus / Catat Hasil Panen ]           │
└────────────────────────────────────────────────────────┘
```

#### Detailed Interaction Elements:
1. **Avoided Loss Card (`Bukti Penghematan`)**:
   - Explicitly displays the transparent arithmetic. Never produces an unexplained figure.
   - Includes baseline disclosure: *"Dibandingkan dengan rata-rata mortalitas 25% siklus sebelumnya"*.
2. **Weekly Mortality Chart**: High-contrast vertical/horizontal bars showing dead fish per week. Peaks highlight days where rapid farmer action averted mass die-offs.
3. **Chronological Action Timeline**: Shows each alert raised, action taken by the farmer, and the recorded recovery.
4. **End Cycle / Harvest Modal**:
   - Farmer enters actual harvested weight (kg), final fish count, and harvest sale price per kg (Rp).
   - Generates the final **Sertifikat Bukti Siklus** summarizing total profit saved, final FCR, and survival rate.

---

### 5.5 Tab 4: Pengaturan & Kelola Kolam (Ponds & Settings)
Manages multi-pond operations (3–20 ponds) and guarantees user data sovereignty.

#### ASCII Layout:
```
┌────────────────────────────────────────────────────────┐
│ Kelola Kolam & Pengaturan               [LMS v1.0]     │
├────────────────────────────────────────────────────────┤
│ 🏊 DAFTAR KOLAM SAYA (Total: 4 Kolam Aktif):           │
│ ┌────────────────────────────────────────────────────┐ │
│ │ • Kolam 01 - Terpal D3 (3.500 Ekor)  [🟢 Aman]    │ │
│ │ • Kolam 02 - Terpal D3 (3.800 Ekor)  [🔴 Bahaya]  │ │
│ │ • Kolam 03 - Terpal D2 (1.800 Ekor)  [🟡 Waspada] │ │
│ │ • Kolam 04 - Tanah 4x6 (5.000 Ekor)  [🟢 Aman]    │ │
│ └────────────────────────────────────────────────────┘ │
│ [ ➕ Tambah Kolam Baru ]                               │
│                                                        │
│ 👨‍🌾 KONTAK PENYULUH / PAKAR PERIKANAN:                 │
│ Nama: Budi Santoso, S.Pi                               │
│ Dinas: Penyuluh Swadaya Wilayah II                     │
│ No. WA: +62 812-3456-7890                              │
│ [ ✏️ Edit Kontak Penyuluh ]                             │
│                                                        │
│ ⚙️ DATA, PRIVASI & KEPERCAYAAN:                        │
│ [ 💾 Cadangkan / Ekspor Data Farm (JSON) ]             │
│ [ 🔄 Impor Data Cadangan ]                             │
│ [ 🗑️ Hapus Seluruh Data dari HP Ini ]                  │
│                                                        │
│ 📜 TRANSPARANSI ATURAN:                                │
│ • Logika Aturan: Versi 1.0 (Standar KKP & Riset MAS)  │
│ • Terakhir Diverifikasi Ahli: 16 Nov 2026              │
│ • Riwayat Laporan Alarm Palsu: 2 Laporan Terkirim      │
└────────────────────────────────────────────────────────┘
```

#### Detailed Interaction Elements:
1. **Pond Management**: Add/Edit/Archive pond. Input pond shape/dimensions, type (terpal/tanah/bioflok), and seed stocking date.
2. **Extension Officer Settings**: Input fields for name, title, and WhatsApp phone number.
3. **Data Export/Deletion**:
   - **Export Data**: Generates an offline `.json` or `.csv` file saved to device download folder.
   - **Delete Farm Data**: Red destructive button with safety confirmation dialog (*"Ketik HAPUS untuk konfirmasi data dihapus permanen"*).
4. **Rules Transparency Viewer**: Tapping displays the exact parameter thresholds (temperature limits, DO expectations, ammonia indicators) with citations to academic papers mentioned in `Product_specs.md`.

---

### 5.6 Secondary Dialogs & Modals

#### 5.6.1 Dialog: Lapor Alarm Palsu (False Alarm Feedback)
Essential for pilot tuning (Section 8 of Product Specs: *"Track false alarms. If farmers receive many wrong alerts, they stop reading alerts"*).
* Trigger: Tap `[Lapor Alarm Palsu]` from Home or Daily Check Result.
* Fields:
  1. Radio options:
     - [ ] Ikan sehat & berenang normal (bukan menggantung)
     - [ ] Pakan sebenarnya habis
     - [ ] Bau air normal, bukan amonia
     - [ ] Saran tindakan terlalu berlebihan
     - [ ] Lainnya
  2. Free text note: *"Catatan tambahan peternak..."*
* Result: Saves to local `FalseAlarmReport` repository and queues for background sync when online. Resets current alert status if requested.

#### 5.6.2 Dialog: Hubungi Penyuluh / Ahli
* Trigger: Tap `[Hubungi Penyuluh]` on Bahaya banner.
* Content:
  - Phone Number & Name of Officer.
  - Option 1: **Kirim Pesan WhatsApp** (Opens `whatsapp://send?phone=...&text=...` with auto-filled pond diagnosis).
  - Option 2: **Telepon Langsung** (Opens `tel:...`).

---

## 6. Project Directory Architecture (Flutter Implementation)

The application code follows a clean, offline-first architecture utilizing native Flutter tools (`ChangeNotifier` / `InheritedWidget` / `Provider`) with zero unnecessary external bloat:

```
lib/
├── main.dart                          # App entry, ThemeData, and Root MultiProvider
├── core/
│   ├── theme/
│   │   ├── app_colors.dart            # Complete outdoor contrast palette
│   │   ├── app_typography.dart        # Large bold readability typography
│   │   └── app_theme.dart             # Flutter ThemeData (light & high-contrast mode)
│   ├── constants/
│   │   ├── app_strings.dart           # Bahasa Indonesia text constants & tooltips
│   │   └── rule_thresholds.dart       # Versioned rule parameters & references
│   └── utils/
│       ├── formatters.dart            # Currency (Rp), Weight (kg), Date & Time formatters
│       └── rule_engine.dart           # Pure Dart deterministic evaluation functions
├── models/
│   ├── pond.dart                      # Pond and PondType models
│   ├── cycle.dart                     # CycleSummary and Harvest models
│   ├── daily_check.dart               # DailyCheck, Enums, and RiskEvaluation
│   ├── feed_log.dart                  # FeedLog, FeedSession, and FishSampling
│   └── false_alarm.dart               # FalseAlarmReport model
├── providers/                         # Reactive State & Offline Repositories
│   ├── farm_provider.dart             # Active pond selector, all ponds list
│   ├── daily_check_provider.dart      # Checks history, current risk, submit check
│   ├── feed_provider.dart             # Feed plans, sessions, FCR calculator, sampling
│   ├── proof_provider.dart            # Avoided loss calculator, weekly mortality
│   └── settings_provider.dart         # Penyuluh contact, export/import, rule version
└── views/
    ├── navigation/
    │   └── main_navigation_screen.dart # 4-Tab BottomNavigationBar Scaffold
    ├── screens/
    │   ├── home/
    │   │   └── home_screen.dart       # Action Center (Risk banner, 1-3 tasks, checklist)
    │   ├── daily_check/
    │   │   └── daily_check_form_modal.dart # Rapid < 1 min check form
    │   ├── feed_guard/
    │   │   ├── feed_guard_screen.dart # Feed plan, FCR card, session log list
    │   │   ├── feed_log_modal.dart    # Quick feed record modal
    │   │   └── fish_sampling_modal.dart # Weight sampling modal
    │   ├── proof/
    │   │   ├── proof_screen.dart      # Avoided losses card, weekly mortality chart
    │   │   └── harvest_modal.dart     # Cycle completion & harvest entry modal
    │   ├── ponds/
    │   │   ├── pond_list_view.dart    # 3-20 ponds manager
    │   │   └── pond_form_modal.dart   # Add/edit pond configuration
    │   └── settings/
    │       ├── settings_screen.dart   # Export, delete, rules info
    │       └── false_alarm_dialog.dart# False alarm reporter dialog
    └── widgets/
        ├── risk_banner_card.dart      # High-contrast Low/Med/High card
        ├── action_checklist_card.dart # Priority steps with countdown timer
        ├── visual_choice_chip.dart    # Large outdoor touch target selector
        ├── pond_selector_header.dart  # Global pond dropdown header
        ├── fcr_metric_card.dart       # FCR calculation display
        ├── avoided_loss_card.dart     # Transparent money saved widget
        └── expert_contact_sheet.dart  # WhatsApp/call escalation launcher
```

---

## 7. Step-by-Step Implementation Guide for an Agent

An autonomous agent implementing this UI in Flutter should execute in the following sequential order:

1. **Step 1: Theme & Design Tokens (`core/theme/`)**:
   - Implement `AppColors` with the exact hex values specified in Section 2.1.
   - Implement `AppTypography` with large scalable font styles.
   - Configure `ThemeData` with high-contrast surfaces, 56dp minimum button heights, and distinct card borders.
2. **Step 2: Data Models & Offline Rule Engine (`models/` & `core/utils/`)**:
   - Implement all Dart models (`Pond`, `DailyCheck`, `RiskEvaluation`, `ActionStep`, `FeedLog`, `FishSampling`, `CycleSummary`).
   - Implement `rule_engine.dart` containing `evaluateDailyCheck()`.
   - Implement calculation utilities for FCR:
     $$\text{FCR} = \frac{\sum \text{Feed Given (kg)}}{\text{Current Biomass (kg)} - \text{Initial Stock Biomass (kg)} + \text{Dead Fish Biomass (kg)}}$$
   - Implement Avoided Loss calculation:
     $$\text{Avoided Loss (Rp)} = (\text{Baseline Mortality Rate} - \text{Actual Mortality Rate}) \times \text{Initial Fish Count} \times \text{Estimated Market Value/Ekor} + \text{Feed Saved (kg)} \times \text{Feed Price/kg}$$
3. **Step 3: Reactive State Providers (`providers/`)**:
   - Implement `FarmProvider`, `DailyCheckProvider`, `FeedProvider`, `ProofProvider`, and `SettingsProvider` with mock seed data (covering 4 realistic ponds: 1 in High Risk, 1 in Medium Risk, 2 in Low Risk).
4. **Step 4: Shared Reusable Widgets (`views/widgets/`)**:
   - Build `PondSelectorHeader`, `RiskBannerCard`, `ActionChecklistCard`, `VisualChoiceChip`, and `AvoidedLossCard`.
5. **Step 5: Tab Screens (`views/screens/`)**:
   - Screen 1: `HomeScreen` (with instant 10-second readability, countdown timers, checklist, escalation button).
   - Screen 2: `DailyCheckFormModal` (with visual chips and dead fish step buttons).
   - Screen 3: `FeedGuardScreen`, `FeedLogModal`, and `FishSamplingModal`.
   - Screen 4: `ProofScreen` and `HarvestModal`.
   - Screen 5: `SettingsScreen`, `PondFormModal`, and `FalseAlarmDialog`.
6. **Step 6: Navigation Container & Wire-up (`views/navigation/main_navigation_screen.dart` & `main.dart`)**:
   - Assemble `MainNavigationScreen` with `BottomNavigationBar` switching smoothly between the 4 tabs while preserving the global active pond selection.

---

## 8. Verification & Acceptance Criteria (Quality Gate)

Any agent or reviewer can verify that the UI implementation is complete and correct against these tests:

| Test ID | Test Name | Passing Criteria |
| :--- | :--- | :--- |
| **TC-01** | **The 10-Second Test** | On `HomeScreen` in Bahaya state, the user can identify the danger reason and the first action step within 10 seconds. |
| **TC-02** | **1-Minute Check Speed** | Completing `DailyCheckFormModal` requires fewer than 7 taps/gestures and under 60 seconds. |
| **TC-03** | **No Drug / Antibiotic Advice** | UI never displays chemical drug dosages, antibiotic names, or commercial feed brands anywhere. |
| **TC-04** | **Outdoor Sunlight Contrast** | All status text on banners passes WCAG AAA contrast against its background. Touch targets measure $\ge 48\text{dp} \times 48\text{dp}$. |
| **TC-05** | **Offline Usability** | App loads immediately and runs all risk evaluations without network calls or loading spinners. |
| **TC-06** | **Transparent Proof Arithmetic** | Avoided Loss card clearly displays the exact subtraction and multiplication steps used to derive the Rupiah amount. |
| **TC-07** | **False Alarm Escalation** | Tapping "Lapor Alarm Palsu" allows peternak to submit corrective feedback in 2 taps. |
| **TC-08** | **Penyuluh Direct Action** | High Risk screen triggers direct WhatsApp message pre-filled with water check diagnostics. |
