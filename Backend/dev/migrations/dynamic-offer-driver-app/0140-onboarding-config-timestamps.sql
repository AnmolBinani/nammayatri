ALTER TABLE atlas_driver_offer_bpp.onboarding_document_configs ADD COLUMN created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL;
ALTER TABLE atlas_driver_offer_bpp.onboarding_document_configs ADD COLUMN updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL;
