import { useTranslations } from "next-intl";

export default function HomePage() {
  const t = useTranslations("HomePage");

  return (
    <main className="flex flex-1 flex-col items-center justify-center px-6 py-24">
      <div className="max-w-2xl text-center space-y-6">
        <h1 className="font-serif text-5xl md:text-6xl font-normal leading-tight tracking-tight text-foreground">
          {t("title")}
        </h1>
        <p className="text-lg text-muted-foreground leading-relaxed">
          {t("subtitle")}
        </p>
      </div>
    </main>
  );
}
