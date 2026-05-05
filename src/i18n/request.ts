import { getRequestConfig } from "next-intl/server";
import { hasLocale } from "next-intl";
import { routing } from "./routing";

export default getRequestConfig(async ({ requestLocale }) => {
  const requested = await requestLocale;
  const locale = hasLocale(routing.locales, requested)
    ? requested
    : routing.defaultLocale;

  // Share message catalogs across regions of the same language
  // (en-BE and future en-NL both load messages/en.json).
  const baseLocale = locale.split("-")[0];

  return {
    locale,
    messages: (await import(`../../messages/${baseLocale}.json`)).default,
  };
});
