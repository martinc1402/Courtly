# Courtly — Stitch Canonical Snapshots

Local backup of the 8 locked canonical screens from Google Stitch project `Courtly Luxury Companion Directory` (id `3313222353777729921`).

Snapshot taken: 2026-05-04.

These files represent ~30 patches of iterative work and are the authoritative versions of each surface. If a Stitch screen is later regressed, regenerated, or accidentally deleted, restore from the corresponding file here.

## File index

| # | File | Surface | Stitch screen ID | Height | Status |
|---|---|---|---|---|---|
| 01 | `01-homepage.html` | Homepage | `359ab900580b4f8ea7d5c867ddf9c252` | 8680px | Locked |
| 02 | `02-directory-search.html` | Directory / Search (`/companions`) | `e94b0abc6d97495dbd1ebe7013f5573e` | 10158px | Locked |
| 03 | `03-brussels-city-guide.html` | Brussels city guide (`/cities/brussels`) | `c298373b8da24e3ca2fb25b1279aa06f` | 12880px | Locked — template for the other 5 city guides |
| 04 | `04-provider-profile-isabella.html` | Provider profile example (`/companions/isabella`) | `edf0f499119a43b488b43802f031c6b3` | 8648px | Locked — template for all provider profiles |
| 05 | `05-apply-step-1-eligibility.html` | Apply step 1 — Eligibility (Agency-selected state) | `2121f6ff66724a2bb1b5144162a87d34` | 5872px | Locked |
| 06 | `06-apply-step-2-account.html` | Apply step 2 — Account (email + password + phone) | `41eeef5c71544c58bb7de9cac090940e` | 4780px | Locked |
| 07 | `07-apply-step-3-verify-identity.html` | Apply step 3 — Verify identity (ID + selfie upload) | `6fbda42a52cc45bba0513a5a122f44b0` | 5404px | Locked |
| 08 | `08-apply-step-4-profile.html` | Apply step 4 — Profile (name, age, gender, languages, tagline, bio) | `108ee9e343d840d3999d53d2b76e2550` | 5610px | Locked |
| 09 | `09-apply-step-5-service-location.html` | Apply step 5 — Service & location (base city, primary service areas, modality, welcomes) | `04f3f5de68c04632aae9dab9030afa07` | 5518px | Locked |
| 10 | `10-apply-step-6-photos-rates.html` | Apply step 6 — Photos, rates table, contact methods | `670c93ecc884471d984e7d71fd16b116` | 8134px | Locked |
| 11 | `11-apply-step-7-submit.html` | Apply step 7 — Submit (review summary, pricing tier, legal acknowledgments) | `5f78e215486842f3b4e1a9928085ccf8` | 7056px | Locked |
| 12 | `12-apply-step-8-confirmation.html` | Apply step 8 — Application Submitted (confirmation screen) | `cfe8b6239b164450adf1bbd18954fc15` | 4870px | Locked |

## Surfaces still to design (referenced in `~/.claude/projects/-Users-martincasey-Projects-courtly/memory/`)

- 5 sister city guides (Antwerp, Ghent, Liège, Bruges, Charleroi) — content swaps on `03-brussels-city-guide.html`
- `/cities` index page (6 large editorial tiles)
- About Courtly, How we verify, Editorial values, Safeguarding & anti-trafficking, Transparency reports
- Terms / Privacy / Cookie / Acceptable Use Policy / Imprint / DSA contact (legal templates)
- Provider login + Provider dashboard
- 404, age gate, suspended profile, empty search results, report flow

## Canonical wording verified across all 8 files

Each file should contain (verbatim, no paraphrase):

**Footer canonical disclaimer:**
> Courtly is an adult advertising directory for independent providers. Courtly does not arrange bookings, collect client payments, process deposits, or act as an agency.

**Compliance band canonical disclaimer (where present):**
> Courtly is an advertising directory only. Providers are independent adults who publish and manage their own profiles. Courtly does not arrange meetings, process client payments, collect deposits, set rates, manage schedules, employ providers, or act as an agency.

**Footer brand tagline:**
> A curated advertising directory for independent companions across Belgium.

**Footer columns (5 total — Brand col-span-2 + 4 link columns):**
- Browse: Companions + 6 Belgian cities (Brussels, Antwerp, Ghent, Liège, Charleroi, Bruges) + Featured companions + Available now
- For providers: Apply as a provider, Provider login, Pricing, Verification process, Provider help
- Trust & safety: About Courtly, How we verify, Editorial values, Report a concern, Safeguarding & anti-trafficking, Transparency reports
- Legal: Terms of Service, Privacy Policy, Cookie Policy, Cookie Settings, Acceptable Use Policy, Imprint / Mentions légales, DSA point of contact

**Language switcher:** FR · NL · EN · DE (EN bolded as active)

**Bottom legal strip 3-block stack (no labels):**
1. Age statement: *USERS MUST BE 18+ TO ACCESS THIS SITE. PLEASE CONSULT LOCAL LAWS IN YOUR JURISDICTION. THIS WEBSITE IS A CURATED ADVERTISING PLATFORM.*
2. Canonical disclaimer (verbatim, italic, sentence case)
3. Copyright: *Copyright © 2026 Courtly. All rights reserved.*

## Forbidden wording (must NOT appear in any file)

Per `project_courtly_compliance.md`:

- CTAs: "Book now", "Reserve", "Hire", "Pay deposit", "Request booking", "Checkout"
- Badges: "Safe", "Guaranteed", "Trusted", "Background checked", "Approved companion"
- Footer items: "Agencies" (independents-only at MVP), "Top Rated", "All Companions", "The Journal", "Latest Stories", "Press Inquiry", "Heritage Group", "LUXURY DIRECTORY", "CRAFTED FOR THE DISCERNING"
- Technical overclaim: "AES-256", "encrypted", "bank-grade encryption", "biometric face match", "secure deletion protocols", "internal access controls"
- International cities in BROWSE: "London", "Paris", "Milan", "New York" (Belgium only)
- "Caters to" (replaced by "Welcomes")
- Per `project_courtly_filter_set.md`: ethnicity, hair colour, eye colour, breast size, body type, height, weight as filter or profile fields

## Quality gate

If a Stitch regression appears in a future session, compare the regressed file against the corresponding snapshot here. The snapshot is authoritative.
