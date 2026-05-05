import { Link } from "@/i18n/navigation";

// TODO: migrate nav labels to messages catalogs (HomePage / Nav namespace)
//       once additional locales are translated. Currently EN-only.
const navItems = [
  { href: "/companions", label: "Companions" },
  { href: "/cities", label: "Cities" },
  { href: "/apply", label: "For providers" },
  { href: "/sign-in", label: "Sign in" },
];

export function SiteHeader() {
  return (
    <header className="border-b border-border bg-background">
      <div className="mx-auto flex w-full max-w-screen-2xl items-center justify-between px-6 py-5 md:px-12">
        <Link
          href="/"
          className="font-serif text-2xl italic text-foreground hover:opacity-80 transition-opacity"
        >
          Courtly
        </Link>
        <nav aria-label="Primary">
          <ul className="flex items-center gap-8 text-sm">
            {navItems.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className="text-muted-foreground hover:text-foreground transition-colors"
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
}
