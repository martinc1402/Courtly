import { defineRouting } from "next-intl/routing";

// Locales use BCP-47 region codes so we can scale to additional countries.
// MVP: Belgium with English, French, Dutch.
// German is architected-for but not shipped at MVP (per project scope).
// Future country expansion adds locales like 'en-NL', 'fr-FR' etc.
export const routing = defineRouting({
  locales: ["en-BE", "fr-BE", "nl-BE"],
  defaultLocale: "en-BE",
  localePrefix: {
    mode: "always",
    prefixes: {
      "en-BE": "/be/en",
      "fr-BE": "/be/fr",
      "nl-BE": "/be/nl",
    },
  },
});

export type Locale = (typeof routing.locales)[number];
