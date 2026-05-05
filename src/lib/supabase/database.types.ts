export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      cities: {
        Row: {
          active: boolean
          country_code: string
          created_at: string
          id: string
          intro_copy: string | null
          name: string
          slug: string
          sort_order: number
          updated_at: string
        }
        Insert: {
          active?: boolean
          country_code?: string
          created_at?: string
          id?: string
          intro_copy?: string | null
          name: string
          slug: string
          sort_order?: number
          updated_at?: string
        }
        Update: {
          active?: boolean
          country_code?: string
          created_at?: string
          id?: string
          intro_copy?: string | null
          name?: string
          slug?: string
          sort_order?: number
          updated_at?: string
        }
        Relationships: []
      }
      contact_methods: {
        Row: {
          created_at: string
          id: string
          is_primary: boolean
          is_public: boolean
          method: Database["public"]["Enums"]["contact_method_type"]
          profile_id: string
          sort_order: number
          updated_at: string
          value: string
        }
        Insert: {
          created_at?: string
          id?: string
          is_primary?: boolean
          is_public?: boolean
          method: Database["public"]["Enums"]["contact_method_type"]
          profile_id: string
          sort_order?: number
          updated_at?: string
          value: string
        }
        Update: {
          created_at?: string
          id?: string
          is_primary?: boolean
          is_public?: boolean
          method?: Database["public"]["Enums"]["contact_method_type"]
          profile_id?: string
          sort_order?: number
          updated_at?: string
          value?: string
        }
        Relationships: [
          {
            foreignKeyName: "contact_methods_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profile_events: {
        Row: {
          event_type: string
          id: number
          metadata: Json | null
          occurred_at: string
          profile_id: string | null
          visitor_session_id: string | null
        }
        Insert: {
          event_type: string
          id?: number
          metadata?: Json | null
          occurred_at?: string
          profile_id?: string | null
          visitor_session_id?: string | null
        }
        Update: {
          event_type?: string
          id?: number
          metadata?: Json | null
          occurred_at?: string
          profile_id?: string | null
          visitor_session_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "profile_events_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profile_photos: {
        Row: {
          alt_text: string | null
          blur_data_url: string | null
          created_at: string
          height: number | null
          id: string
          is_cover: boolean
          moderation_status: Database["public"]["Enums"]["photo_moderation_status"]
          profile_id: string
          sort_order: number
          storage_path: string
          updated_at: string
          width: number | null
        }
        Insert: {
          alt_text?: string | null
          blur_data_url?: string | null
          created_at?: string
          height?: number | null
          id?: string
          is_cover?: boolean
          moderation_status?: Database["public"]["Enums"]["photo_moderation_status"]
          profile_id: string
          sort_order?: number
          storage_path: string
          updated_at?: string
          width?: number | null
        }
        Update: {
          alt_text?: string | null
          blur_data_url?: string | null
          created_at?: string
          height?: number | null
          id?: string
          is_cover?: boolean
          moderation_status?: Database["public"]["Enums"]["photo_moderation_status"]
          profile_id?: string
          sort_order?: number
          storage_path?: string
          updated_at?: string
          width?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "profile_photos_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profile_reports: {
        Row: {
          admin_notes: string | null
          created_at: string
          details: string | null
          id: string
          profile_id: string | null
          reason: string
          reported_url: string | null
          reporter_email: string | null
          resolved_at: string | null
          resolved_by: string | null
          status: Database["public"]["Enums"]["report_status"]
          updated_at: string
        }
        Insert: {
          admin_notes?: string | null
          created_at?: string
          details?: string | null
          id?: string
          profile_id?: string | null
          reason: string
          reported_url?: string | null
          reporter_email?: string | null
          resolved_at?: string | null
          resolved_by?: string | null
          status?: Database["public"]["Enums"]["report_status"]
          updated_at?: string
        }
        Update: {
          admin_notes?: string | null
          created_at?: string
          details?: string | null
          id?: string
          profile_id?: string | null
          reason?: string
          reported_url?: string | null
          reporter_email?: string | null
          resolved_at?: string | null
          resolved_by?: string | null
          status?: Database["public"]["Enums"]["report_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "profile_reports_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profile_translations: {
        Row: {
          availability_notes: string | null
          bio: string | null
          created_at: string
          id: string
          locale: string
          profile_id: string
          rates_notes: string | null
          tagline: string | null
          updated_at: string
        }
        Insert: {
          availability_notes?: string | null
          bio?: string | null
          created_at?: string
          id?: string
          locale: string
          profile_id: string
          rates_notes?: string | null
          tagline?: string | null
          updated_at?: string
        }
        Update: {
          availability_notes?: string | null
          bio?: string | null
          created_at?: string
          id?: string
          locale?: string
          profile_id?: string
          rates_notes?: string | null
          tagline?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "profile_translations_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          age_verified: boolean
          availability_status: Database["public"]["Enums"]["availability_status"]
          city_id: string
          created_at: string
          display_name: string
          featured: boolean
          id: string
          languages: string[]
          last_active_at: string | null
          modalities: string[]
          photo_verified: boolean
          provider_type: Database["public"]["Enums"]["provider_type"]
          rates_currency: string
          rates_from_minor_units: number | null
          rates_text: string | null
          service_areas: string[]
          slug: string
          status: Database["public"]["Enums"]["profile_status"]
          updated_at: string
          user_id: string
          verification_status: Database["public"]["Enums"]["verification_status"]
        }
        Insert: {
          age_verified?: boolean
          availability_status?: Database["public"]["Enums"]["availability_status"]
          city_id: string
          created_at?: string
          display_name: string
          featured?: boolean
          id?: string
          languages?: string[]
          last_active_at?: string | null
          modalities?: string[]
          photo_verified?: boolean
          provider_type?: Database["public"]["Enums"]["provider_type"]
          rates_currency?: string
          rates_from_minor_units?: number | null
          rates_text?: string | null
          service_areas?: string[]
          slug: string
          status?: Database["public"]["Enums"]["profile_status"]
          updated_at?: string
          user_id: string
          verification_status?: Database["public"]["Enums"]["verification_status"]
        }
        Update: {
          age_verified?: boolean
          availability_status?: Database["public"]["Enums"]["availability_status"]
          city_id?: string
          created_at?: string
          display_name?: string
          featured?: boolean
          id?: string
          languages?: string[]
          last_active_at?: string | null
          modalities?: string[]
          photo_verified?: boolean
          provider_type?: Database["public"]["Enums"]["provider_type"]
          rates_currency?: string
          rates_from_minor_units?: number | null
          rates_text?: string | null
          service_areas?: string[]
          slug?: string
          status?: Database["public"]["Enums"]["profile_status"]
          updated_at?: string
          user_id?: string
          verification_status?: Database["public"]["Enums"]["verification_status"]
        }
        Relationships: [
          {
            foreignKeyName: "profiles_city_id_fkey"
            columns: ["city_id"]
            isOneToOne: false
            referencedRelation: "cities"
            referencedColumns: ["id"]
          },
        ]
      }
      provider_applications: {
        Row: {
          age_confirmed: boolean
          applicant_email: string
          applicant_name: string | null
          city_id: string | null
          consent_privacy_at: string | null
          consent_safety_at: string | null
          consent_terms_at: string | null
          created_at: string
          id: string
          payload: Json
          resulting_profile_id: string | null
          review_notes: string | null
          reviewed_at: string | null
          reviewed_by: string | null
          status: Database["public"]["Enums"]["application_status"]
          updated_at: string
        }
        Insert: {
          age_confirmed?: boolean
          applicant_email: string
          applicant_name?: string | null
          city_id?: string | null
          consent_privacy_at?: string | null
          consent_safety_at?: string | null
          consent_terms_at?: string | null
          created_at?: string
          id?: string
          payload?: Json
          resulting_profile_id?: string | null
          review_notes?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: Database["public"]["Enums"]["application_status"]
          updated_at?: string
        }
        Update: {
          age_confirmed?: boolean
          applicant_email?: string
          applicant_name?: string | null
          city_id?: string | null
          consent_privacy_at?: string | null
          consent_safety_at?: string | null
          consent_terms_at?: string | null
          created_at?: string
          id?: string
          payload?: Json
          resulting_profile_id?: string | null
          review_notes?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: Database["public"]["Enums"]["application_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "provider_applications_city_id_fkey"
            columns: ["city_id"]
            isOneToOne: false
            referencedRelation: "cities"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "provider_applications_resulting_profile_id_fkey"
            columns: ["resulting_profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      subscriptions: {
        Row: {
          cancel_at_period_end: boolean
          created_at: string
          current_period_end: string | null
          current_period_start: string | null
          founding_free_until: string | null
          id: string
          plan: Database["public"]["Enums"]["subscription_plan"]
          processor: string | null
          processor_subscription_id: string | null
          profile_id: string
          status: Database["public"]["Enums"]["subscription_status"]
          updated_at: string
        }
        Insert: {
          cancel_at_period_end?: boolean
          created_at?: string
          current_period_end?: string | null
          current_period_start?: string | null
          founding_free_until?: string | null
          id?: string
          plan?: Database["public"]["Enums"]["subscription_plan"]
          processor?: string | null
          processor_subscription_id?: string | null
          profile_id: string
          status?: Database["public"]["Enums"]["subscription_status"]
          updated_at?: string
        }
        Update: {
          cancel_at_period_end?: boolean
          created_at?: string
          current_period_end?: string | null
          current_period_start?: string | null
          founding_free_until?: string | null
          id?: string
          plan?: Database["public"]["Enums"]["subscription_plan"]
          processor?: string | null
          processor_subscription_id?: string | null
          profile_id?: string
          status?: Database["public"]["Enums"]["subscription_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "subscriptions_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      verification_checks: {
        Row: {
          created_at: string
          document_path: string | null
          id: string
          method: string
          notes: string | null
          profile_id: string
          reviewed_at: string | null
          reviewed_by: string | null
          status: Database["public"]["Enums"]["verification_status"]
          updated_at: string
        }
        Insert: {
          created_at?: string
          document_path?: string | null
          id?: string
          method: string
          notes?: string | null
          profile_id: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: Database["public"]["Enums"]["verification_status"]
          updated_at?: string
        }
        Update: {
          created_at?: string
          document_path?: string | null
          id?: string
          method?: string
          notes?: string | null
          profile_id?: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: Database["public"]["Enums"]["verification_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "verification_checks_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      is_admin: { Args: never; Returns: boolean }
    }
    Enums: {
      application_status:
        | "submitted"
        | "in_review"
        | "requested_clarification"
        | "approved"
        | "rejected"
      availability_status:
        | "available_today"
        | "available_this_week"
        | "taking_enquiries"
        | "unavailable"
        | "touring"
      contact_method_type:
        | "whatsapp"
        | "telegram"
        | "phone"
        | "email"
        | "website"
      photo_moderation_status: "pending" | "approved" | "rejected"
      profile_status:
        | "draft"
        | "pending_review"
        | "approved"
        | "published"
        | "paused_by_provider"
        | "suspended"
        | "rejected"
        | "deleted"
      provider_type: "independent" | "agency"
      report_status: "open" | "in_review" | "resolved" | "dismissed"
      subscription_plan: "founding_free" | "starter" | "pro"
      subscription_status: "active" | "past_due" | "cancelled" | "expired"
      verification_status:
        | "unverified"
        | "pending"
        | "verified"
        | "failed"
        | "expired"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      application_status: [
        "submitted",
        "in_review",
        "requested_clarification",
        "approved",
        "rejected",
      ],
      availability_status: [
        "available_today",
        "available_this_week",
        "taking_enquiries",
        "unavailable",
        "touring",
      ],
      contact_method_type: [
        "whatsapp",
        "telegram",
        "phone",
        "email",
        "website",
      ],
      photo_moderation_status: ["pending", "approved", "rejected"],
      profile_status: [
        "draft",
        "pending_review",
        "approved",
        "published",
        "paused_by_provider",
        "suspended",
        "rejected",
        "deleted",
      ],
      provider_type: ["independent", "agency"],
      report_status: ["open", "in_review", "resolved", "dismissed"],
      subscription_plan: ["founding_free", "starter", "pro"],
      subscription_status: ["active", "past_due", "cancelled", "expired"],
      verification_status: [
        "unverified",
        "pending",
        "verified",
        "failed",
        "expired",
      ],
    },
  },
} as const
