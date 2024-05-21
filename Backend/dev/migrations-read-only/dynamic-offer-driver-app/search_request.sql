CREATE TABLE atlas_driver_offer_bpp.search_request ();

ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN area text ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN auto_assign_enabled boolean  default false;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN bap_city text ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN bap_country text ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN bap_id character varying(255) NOT NULL;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN bap_uri character varying(255) NOT NULL;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN created_at timestamp with time zone NOT NULL default CURRENT_TIMESTAMP;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN currency character varying(255) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN customer_cancellation_dues double precision  default 0;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN customer_language character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN device text ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN disability_tag text ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN driver_default_extra_fee double precision ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN driver_default_extra_fee_amount double precision ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN estimated_distance integer ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN estimated_duration integer ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN from_location_id character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN id character varying(36) NOT NULL;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN is_blocked_route boolean ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN is_customer_preffered_search_route boolean ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN is_reallocation_enabled boolean ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN is_scheduled boolean ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN merchant_operating_city_id character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN message_id character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN pickup_zone_gate_id character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN provider_id character varying(255) NOT NULL;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN rider_id character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN special_location_tag text ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN start_time timestamp with time zone ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN to_location_id character varying(36) ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN toll_charges double precision ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN toll_names text[] ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN transaction_id character varying(36) NOT NULL;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN valid_till timestamp with time zone ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD PRIMARY KEY ( id);


------- SQL updates -------

ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN round_trip boolean ;
ALTER TABLE atlas_driver_offer_bpp.search_request ADD COLUMN return_time timestamp with time zone ;