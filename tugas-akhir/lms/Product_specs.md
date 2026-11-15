# LMS (Lele Management System): Concept Document

Concept draft, November 16, 2026. Working name: LMS. This document assumes that lele means lele (catfish) farming. Sources are listed at the end.

## 1. Summary

LMS is a phone app for lele farmers. Its main job is to prevent losses and to tell the farmer what to do next. It works like a medicine, not a vitamin. A vitamin makes a good farm slightly better. A medicine stops a loss that already hurts. LMS targets the costliest problems in lele farming: sudden fish deaths, wasted feed, and late action. LMS is not a feed seller, a lender, or a marketplace.

The first version works offline and runs on low-cost Android phones. Each alert shows its reason and one clear action. The app also logs actions and outcomes. At the end of a cycle, the log shows the losses the farmer avoided and the feed the farmer saved. The farmer then decides, based on evidence, whether the app is worth paying for.

## 2. The Medicine Test

Start with the rule. A product is a medicine when the user has a problem that costs money now and needs action now. A product is a vitamin when the user wants it but can wait without losing money. Every feature in LMS must pass this rule. A feature that fails moves to the later list.

Lele farming fits the medicine rule. Motile Aeromonas septicemia (MAS) is a bacterial disease. In outbreaks, it can kill 80 to 100 percent of fish within one to two weeks, according to an Indonesian research paper. Poor water quality also causes stress, disease, and mass death. In one pond in Buleleng, Bali, mortality reached 50 percent. The researchers named poor water quality and too few pH checks as the main causes.

The table below turns the rule into five questions.

| Question | A medicine passes | A vitamin fails |
| --- | --- | --- |
| Does the problem cost money within days? | Yes. Deaths and wasted feed cost money fast. | No. Losses show up only in reports or at harvest. |
| Does the farmer face it often? | Yes. The farmer lost fish in the last cycle. | No. The farmer never lost fish. |
| Does the product give one clear action? | Yes. For example, run the aerator now. | No. The product shows a chart to read. |
| Can the farmer see saved money within one cycle? | Yes. The log shows avoided losses. | No. The benefit stays vague. |
| Would the farmer miss it if it stopped? | Yes. The farmer would miss the warnings. | No. The farmer would shrug. |

Most tools in my search results were university prototypes, record tools, or feed and finance platforms. By this test, most record tools and prototypes are vitamins. That gap is the opening for LMS.

Design implication: every core screen must answer one question. What should the farmer do now?

## 3. The Problem

Lele farms can lose fish fast. Ammonia, low oxygen, and disease cause stress and death. Feed that fish do not eat becomes waste, and waste pollutes the water. University research in Indonesia links feed residue and fish waste to a buildup of ammonia and nitrite. That buildup limits growth and raises disease risk.

Farmers often act late. A community study of household-scale lele farmers found little water monitoring equipment and little access to technical information. Late action turns a small water problem into a mass death. Many farmers also keep records by hand, which makes patterns hard to see.

Margins are thin, so each loss is expensive. Feed makes up about 60 to 70 percent of production cost in several Indonesian sources. A 2022 study in Madiun estimated the production cost of lele at about Rp 16,998 per kilogram. Sale prices in the sources I found ranged from about Rp 13,700 to Rp 19,000 per kilogram. The sources come from different years, so treat that range as rough. Take a crash that kills 30 percent of the fish as an example. Revenue falls by about 30 percent, but most feed and seed costs stay spent. A single event can erase the profit of a whole cycle.

Scale matters too. Indonesia produced about 1.16 million metric tons of lele in 2024, according to the Ministry of Marine Affairs and Fisheries (KKP). That places lele among the three highest-volume aquaculture commodities. The market is large enough for a focused product.

I did not find a verified 2026 farm-gate price for lele. The team must verify current prices before it sets the final price model.

## 4. Users

The likely primary user is a small or medium pond owner. This user runs three to twenty ponds with family members or a small group. Many use plastic tarpaulin ponds (kolam terpal), which cost less and are easy to manage. The user has an Android phone with limited memory, often has weak signal at the pond, reads Bahasa Indonesia, and uses WhatsApp daily. These traits are assumptions. Interviews must confirm them.

Secondary users include extension officers (penyuluh perikanan), farmer groups (kelompok pembudidaya), and feed dealers. They do not control LMS in the first version. They can recommend the app, and some can sponsor farmer licenses later.

Out of scope for the first version are large commercial farms with dedicated staff, sensor systems, seed hatcheries, and fish processors.

## 5. The Product: Three Treatments

LMS has three treatments. The first warns. The second tells the farmer what to do. The third proves the result. The treatments work together. Without proof, a warning is only an opinion. Without a warning, proof arrives too late.

### Warning

The app asks for a short check twice a day. The morning check matters most, because dissolved oxygen is usually lowest before dawn. A check takes under one minute. The farmer enters water color and smell. The farmer also enters fish behavior at the surface, uneaten feed, water temperature, the dead fish count, and any pH reading.

LMS sets a risk level for the next 12 to 24 hours: low, medium, or high. Each level shows its reason in plain words. For example, the app might state that fish gather at the surface and feed stays uneaten. The first version uses explicit rules, not machine learning. Rules are easy to check, easy to explain, and easy for experts to change.

### Action

Each alert gives one to three steps, and each step has a time limit. Steps address the cause. They can reduce or pause feed, run the aerator, remove dead fish, change part of the water, or set a new check time. LMS never names drugs, antibiotics, or doses. If the risk stays high after the next check, LMS asks the farmer to contact an extension officer or a fish health expert. A button starts a call or message to that contact.

Feed pauses have limits. LMS does not advise a pause longer than the set limit without a new check, because long fasting slows growth.

### Feed guard

Feed is the largest cost. LMS keeps a feed plan for each pond. The plan starts from the feed table that the farmer chooses. It uses the number of fish and the average fish weight from a sample. The plan lowers feed when the check shows leftover feed or a medium or high risk level. The farmer records feed given and feed left. Over time, LMS shows the feed conversion ratio (FCR). FCR is the feed weight needed for each kilogram of fish gained. A lower FCR means the feed works better.

LMS must not favor any feed brand in its advice.

### Proof

Each alert, action, and outcome goes into the cycle log. At the end of a cycle, LMS shows fish deaths by week, feed used, the FCR trend, and an estimate of avoided losses. The estimate compares the cycle with the farm's own past cycle or with another stated baseline. LMS shows the method. It labels the result as an estimate. It never shows a number that the data does not support.

## 6. What Waits

Some features fail the medicine test today. They wait until the medicine works. These features include market price forecasts, a marketplace, detailed accounting, invoices, staff payroll, social features, badges, growth charts that lead to no action, multi-user roles, a general AI chat assistant, and photo-based disease detection. Each feature can return later with a clear reason to exist.

## 7. A Morning Example

This example is illustrative. A farmer checks a pond at 05:30. The water looks darker than usual. Several fish gather at the surface. Feed from last night remains on the bottom. LMS sets the risk to high. It names the likely causes: low oxygen and too much uneaten feed. It gives three steps: run the aerator now, do not feed until 09:00, and remove visible dead fish. It sets a check for 09:00.

At 09:00, the farmer records a second check. The risk falls to medium. LMS keeps the medium level, reduces the next feed amount, and asks for a check at 15:00. The log records the alert, the actions, and the fish counts. In the following days, the farmer sees fewer deaths than in the last event on the same pond. That result becomes part of the proof.

## 8. Safety and Trust

LMS does not name drugs, antibiotics, or doses in any version. Fish medicines and antibiotics are regulated in Indonesia, and treatment decisions need a qualified expert.

Every alert shows its reason and the data behind it. LMS calls each output a risk estimate, not a diagnosis.

Thresholds need expert approval before launch, because the sources disagree. Several sources use 5 mg/L as a dissolved oxygen target. A university prototype cited Indonesian Government Regulation 82 of 2001 for an oxygen level of 4 mg/L and an ammonia limit of 0.02 mg/L. One table lists ammonia at 5 ppm, a value far above the other limits. The team must settle these differences with a fisheries expert. Each threshold must record its source and review date.

Track false alarms. If farmers receive many wrong alerts, they stop reading alerts. The team reviews wrong alerts every week during the pilot. A wrong-alert button lets farmers report errors.

Farmers own their data. LMS offers export and deletion. LMS asks for consent before any upload, and it does not sell farm data.

Publish results with their methods, including failures. Invite outside audits. The eFishery case shows what happens when reported numbers are inflated.

## 9. Technical Plan

Build for Android first. Budget Android phones are common in Indonesia. Use Kotlin and Jetpack Compose. Use large text, high contrast for outdoor light, icons next to words, and Bahasa Indonesia as the default language.

Use an offline-first design. A local database (Room) holds all farm data. The rules run on the phone. The app syncs with a cloud service, such as Firebase or Supabase, only when a connection exists. A weak signal must never block an alert.

Use WorkManager for background sync and reminders that do not need exact timing. Use exact alarms only for the morning check, and ask for permission first. Test reminders on low-cost phones with battery saving turned on.

Write rules as pure Kotlin functions with unit tests. Store thresholds in a versioned file. Experts can review and update thresholds without a code change. Each rule records its source and review date.

Add sensors in the second phase. Low-cost probes can connect through Bluetooth Low Energy or a Wi-Fi microcontroller. The same rules read sensor values. Manual checks stay available, because sensors can fail.

Add machine learning only after two or three cycles of labeled farm data. A model ranks risk. It never replaces the rules alone. Photo-based disease detection needs expert-labeled images and careful validation before any farmer sees it.

## 10. Business Model

Farmers earn most of their income at harvest. A monthly fee fits that cash flow poorly. The base model charges per pond per cycle. A free pilot covers one pond for one cycle. The price must come from willingness-to-pay tests, not from guesses. The price must also be far lower than the value of one avoided loss.

Partners can pay for farmer licenses. Feed dealers and farmer groups gain when farmers stay in business and keep buying. Local government programs can also sponsor pilots. Partners must not control feed advice or access farm data without consent.

The revenue model needs numbers from the pilot. Until then, the team must avoid fixed revenue promises.

## 11. Market and Competitors

eFishery was Indonesia's best-known aquaculture platform. It rented and sold automated feeders, sold feed on credit, provided financing, and offered market access. In 2025, investigators reported fabricated revenue and operating data. The founder admitted to falsifying accounts in April 2025. Police detained the founder and two former senior executives on July 31, 2025. A July 2026 review also reported that the company claimed more than 400,000 feeders, while investigators estimated about 24,000.

The lesson is that trust is part of the product. LMS must publish its methods and results, and it must accept outside checks.

University papers describe many lele water monitors and phone alert prototypes. They show that the idea works in theory. I found no sign of wide use. LMS can use these papers as technical references, not as finished products.

Record tools also exist. A 2024 BRIN paper describes training lele farmers to keep financial records in an app called SIAPIK. Record keeping is a real need, but it is a vitamin under the medicine test, so it waits.

One company claims harvests after 45 days and feed savings of 50 percent. I did not verify this claim. A product claim needs a method and independent data.

This search covered a limited set of sources. Check app stores and business registries before launch.

## 12. Validation Before Building

Write the go or no-go rules before the interviews. Use the same questions for every farmer.

Interview 15 to 20 farmers. Ask when they last lost fish, what they did, how long action took, and what the loss cost. Ask which checks they already do and which tools they use.

Show one alert screen on paper or as a clickable mock-up. Ask the farmer to say what to do within ten seconds. If the farmer cannot, redesign the screen.

Run a price test with about 30 farmers. Ask whether they would pay per pond for one cycle. Record actual payments when possible. Stated intent is weaker evidence.

Ask two fisheries experts to review thresholds, actions, and safety rules.

Use these starting criteria: at least half of the interviewed farmers describe a loss in the last cycle, and at least one third say they would pay for a warning that prevents one. These numbers start the discussion. They do not prove demand.

## 13. Pilot

Run the pilot with 20 to 30 farmers for one full cycle, which lasts about two to three months in the sources I found. Include different pond types. Measure fish survival, FCR, time from alert to action, the number of alerts, the number of wrong alerts, and whether farmers keep using the app.

Use control ponds if farmers agree. If no control exists, compare each farm with its last cycle and label the comparison as weaker evidence. Report every result, including misses and wrong alerts.

## 14. Roadmap

MVP means minimum viable product, the first version that can run a real pilot.

| Period | Goal |
| --- | --- |
| Weeks 1 to 3 | Interviews, prototype test, expert review, and price test |
| Weeks 4 to 12 | Offline MVP with warnings, actions, feed guard, and cycle log |
| Months 4 to 7 | Pilot one cycle with 20 to 30 farmers and fix wrong alerts |
| Months 7 to 10 | Paid plan, partner channels, and one or two sensor types |
| Months 10 to 18 | Data pipeline, machine learning on pilot data, and photo guides after expert review |

## 15. Risks

| Risk | Response |
| --- | --- |
| Too many wrong alerts | Use conservative thresholds, a wrong-alert button, and weekly reviews |
| Wrong thresholds cause harm | Expert sign-off, source notes, and version history |
| Weak signal blocks features | Offline first. Alerts run on the phone |
| Low digital skill limits use | Simple screens, Bahasa Indonesia, and setup help from extension officers |
| Trust gap after eFishery | Public method notes and outside audits |
| Harvest timing blocks payment | Per-cycle price and a free pilot |
| Partner pressure biases advice | Brand-neutral logic and public disclosure of partners |
| Sensor failure creates false confidence | Keep manual checks and show sensor health |

## 16. Open Questions

Which region should the pilot use? Which pond types should version one support? Should LMS stay independent, or should it partner with a feed company? Which public name should the product use? One option is Lele Sehat, which means healthy lele. The team must check trademarks and app store names first. What budget and team size does the pilot need? Which fisheries expert will review the thresholds?

## Sources

Indonesian research paper on Aeromonas hydrophila and Motile Aeromonas Septicemia, citing Lukistyowati and Kurniasih (2012), Airlangga University repository.

Community service report on a lele farmer group in Buleleng, Bali, Undiksha (Universitas Pendidikan Ganesha).

Community paper on household lele farming and natural treatments, Universitas Negeri Gorontalo.

Paper on nano bubble aeration in lele ponds, Universitas Mataram.

Ministry of Marine Affairs and Fisheries (KKP), 2024 lele production figure, as cited in a 2025 journal article.

Kreanova journal (STIESIA, 2022), production cost study for lele farmers in Madiun.

Detik Finance (October 2024), report on a bioflok lele farm in Malang.

Antara report on KKP promotion of bioflok, including a cycle cost example.

Business Today Malaysia (July 2026) and South China Morning Post (August 2025), on the eFishery case.

BRIN (2024), paper on financial recordkeeping for lele farmers.

Prices, regulations, and app markets change. Recheck all figures before launch.
