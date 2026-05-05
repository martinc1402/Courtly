import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import type { Database } from "./database.types";

/**
 * Supabase client for Server Components, Server Actions, and Route Handlers.
 * Reads cookies from the Next.js cookies() store. Set/remove operations are
 * tolerant of being called from a Server Component — those will silently
 * no-op since cookies cannot be mutated outside a Route Handler / Action.
 */
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) => {
              cookieStore.set(name, value, options);
            });
          } catch {
            // Called from a Server Component — proxy.ts will refresh the
            // session on the next request, so this no-op is safe.
          }
        },
      },
    }
  );
}
