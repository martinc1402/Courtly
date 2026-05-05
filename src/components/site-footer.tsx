import { useLocale } from "next-intl";
import { Link } from "@/i18n/navigation";
import { routing, type Locale } from "@/i18n/routing";

// TODO: migrate strings to messages catalog and arrange professional
//       FR / NL (and future DE) translations. The legal disclaimers in the
//       bottom strip MUST be translated by qualified legal counsel before
//       launch in non-EN locales.

const browseItems = [
  { href: "/companions", label: "Companions" },
  { href: "/cities/brussels", label: "Brussels" },
  { href: "/cities/antwerp", label: "Antwerp" },
  { href: "/cities/ghent", label: "Ghent" },
  { href: "/cities/liege", label: "Liège" },
  { href: "/cities/charleroi", label: "Charleroi" },
  { href: "/cities/bruges", label: "Bruges" },
  { href: "/companions?featured=true", label: "Featured companions" },
  { href: "/companions?available=now", label: "Available now" },
];

const providerItems = [
  { href: "/apply", label: "Apply as a provider" },
  { href: "/sign-in", label: "Provider login" },
  { href: "/pricing", label: "Pricing" },
  { href: "/verification", label: "Verification process" },
  { href: "/help", label: "Provider help" },
];

const trustItems = [
  { href: "/about", label: "About Courtly" },
  { href: "/verification", label: "How we verify" },
  { href: "/editorial-values", label: "Editorial values" },
  { href: "/report", label: "Report a concern" },
  { href: "/safeguarding", label: "Safeguarding & anti-trafficking" },
  { href: "/transparency", label: "Transparency reports" },
];

const legalItems = [
  { href: "/terms", label: "Terms of Service" },
  { href: "/privacy", label: "Privacy Policy" },
  { href: "/cookies", label: "Cookie Policy" },
  { href: "/cookie-settings", label: "Cookie Settings" },
  { href: "/acceptable-use", label: "Acceptable Use Policy" },
  { href: "/imprint", label: "Imprint / Mentions légales" },
  { href: "/dsa-contact", label: "DSA point of contact" },
];

const localeLabels: Record<Locale, string> = {
  "en-BE": "EN",
  "fr-BE": "FR",
  "nl-BE": "NL",
};

function FooterColumn({
  heading,
  items,
}: {
  heading: string;
  items: { href: string; label: string }[];
}) {
  return (
    <div className="space-y-4">
      <h3 className="text-[11px] font-bold uppercase tracking-widest text-foreground">
        {heading}
      </h3>
      <ul className="space-y-3 text-sm">
        {items.map((item) => (
          <li key={item.href + item.label}>
            <Link
              href={item.href}
              className="text-muted-foreground hover:text-foreground hover:underline underline-offset-4 transition-colors"
            >
              {item.label}
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

export function SiteFooter() {
  const locale = useLocale() as Locale;

  return (
    <footer className="border-t border-border bg-muted text-foreground">
      {/* 5-column grid: brand col-span-2 + 4 link columns */}
      <div className="mx-auto grid w-full max-w-screen-2xl grid-cols-1 gap-12 px-6 py-20 md:grid-cols-5 md:px-12">
        {/* Brand column */}
        <div className="space-y-6 md:col-span-2">
          <div className="font-serif text-2xl italic text-foreground">
            Courtly
          </div>
          <p className="max-w-xs text-sm leading-relaxed text-muted-foreground">
            A curated advertising directory for independent companions across
            Belgium.
          </p>
          {/* Language switcher */}
          <nav aria-label="Language" className="flex gap-4 pt-2 text-xs">
            {routing.locales.map((l) => (
              <Link
                key={l}
                href="/"
                locale={l}
                className={
                  l === locale
                    ? "border-b border-current pb-1 font-bold text-foreground"
                    : "text-muted-foreground hover:text-foreground transition-colors"
                }
              >
                {localeLabels[l]}
              </Link>
            ))}
          </nav>
        </div>

        <FooterColumn heading="Browse" items={browseItems} />
        <FooterColumn heading="For providers" items={providerItems} />
        <FooterColumn heading="Trust & safety" items={trustItems} />
        <FooterColumn heading="Legal" items={legalItems} />
      </div>

      {/* Bottom legal strip — three stacked blocks, no labels */}
      <div className="border-t border-border px-6 py-12 md:px-12">
        <div className="mx-auto flex w-full max-w-screen-2xl flex-col items-center space-y-5 text-center text-[10px] leading-relaxed text-muted-foreground/80">
          {/* Block 1 — age statement (uppercase tracking-widest) */}
          <p className="max-w-2xl uppercase tracking-widest">
            Users must be 18+ to access this site. Please consult local laws in
            your jurisdiction. This website is a curated advertising platform.
          </p>
          {/* Block 2 — canonical disclaimer (italic, sentence case) */}
          <p className="max-w-3xl italic">
            Courtly is an adult advertising directory for independent providers.
            Courtly does not arrange bookings, collect client payments, process
            deposits, or act as an agency.
          </p>
          {/* Block 3 — copyright */}
          <p>Copyright © 2026 Courtly. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
}
