--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 14.4

-- Started on 2023-07-14 14:16:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 1229821)
-- Name: langflow; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA langflow;


--
-- TOC entry 205 (class 1259 OID 1229924)
-- Name: ExecutionLogs; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow."ExecutionLogs" (
    id integer NOT NULL,
    "tenantId" character varying(255),
    "workflowId" character varying(255),
    "createdAt" timestamp with time zone,
    "runId" character varying(255),
    "runTime" bigint,
    data text,
    "currentState" character varying(255),
    "nextState" character varying(255),
    "outputPort" character varying(255),
    "updatedAt" timestamp with time zone NOT NULL,
    logs text
);


--
-- TOC entry 204 (class 1259 OID 1229922)
-- Name: ExecutionLogs_id_seq; Type: SEQUENCE; Schema: langflow; Owner: -
--

CREATE SEQUENCE langflow."ExecutionLogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2885 (class 0 OID 0)
-- Dependencies: 204
-- Name: ExecutionLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: langflow; Owner: -
--

ALTER SEQUENCE langflow."ExecutionLogs_id_seq" OWNED BY langflow."ExecutionLogs".id;


--
-- TOC entry 199 (class 1259 OID 1229891)
-- Name: Jobs; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow."Jobs" (
    id integer NOT NULL,
    "tenantId" character varying(255),
    "workflowId" character varying(255),
    "currentTaskState" character varying(255),
    "createdAt" timestamp with time zone,
    "runId" character varying(255),
    data text,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 1229889)
-- Name: Jobs_id_seq; Type: SEQUENCE; Schema: langflow; Owner: -
--

CREATE SEQUENCE langflow."Jobs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2886 (class 0 OID 0)
-- Dependencies: 198
-- Name: Jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: langflow; Owner: -
--

ALTER SEQUENCE langflow."Jobs_id_seq" OWNED BY langflow."Jobs".id;


--
-- TOC entry 207 (class 1259 OID 1229935)
-- Name: Nodes; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow."Nodes" (
    id integer NOT NULL,
    "tenantId" character varying(255),
    uuid character varying(255),
    name character varying(255),
    code character varying(255),
    css character varying(255),
    "outputNodes" json,
    "editableFields" json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL,
    description text
);


--
-- TOC entry 206 (class 1259 OID 1229933)
-- Name: Nodes_id_seq; Type: SEQUENCE; Schema: langflow; Owner: -
--

CREATE SEQUENCE langflow."Nodes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2887 (class 0 OID 0)
-- Dependencies: 206
-- Name: Nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: langflow; Owner: -
--

ALTER SEQUENCE langflow."Nodes_id_seq" OWNED BY langflow."Nodes".id;


--
-- TOC entry 203 (class 1259 OID 1229913)
-- Name: RunLogs; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow."RunLogs" (
    id integer NOT NULL,
    "tenantId" character varying(255),
    "workflowId" character varying(255),
    "createdAt" timestamp with time zone,
    "runId" character varying(255),
    "runTime" bigint,
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 202 (class 1259 OID 1229911)
-- Name: RunLogs_id_seq; Type: SEQUENCE; Schema: langflow; Owner: -
--

CREATE SEQUENCE langflow."RunLogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2888 (class 0 OID 0)
-- Dependencies: 202
-- Name: RunLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: langflow; Owner: -
--

ALTER SEQUENCE langflow."RunLogs_id_seq" OWNED BY langflow."RunLogs".id;


--
-- TOC entry 209 (class 1259 OID 1229946)
-- Name: Triggers; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow."Triggers" (
    id integer NOT NULL,
    "tenantId" character varying(255),
    uuid character varying(255),
    name character varying(255),
    shortcode character varying(255),
    "createdAt" timestamp with time zone,
    "workflowId" character varying(255),
    "updatedAt" timestamp with time zone NOT NULL
);


--
-- TOC entry 208 (class 1259 OID 1229944)
-- Name: Triggers_id_seq; Type: SEQUENCE; Schema: langflow; Owner: -
--

CREATE SEQUENCE langflow."Triggers_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2889 (class 0 OID 0)
-- Dependencies: 208
-- Name: Triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: langflow; Owner: -
--

ALTER SEQUENCE langflow."Triggers_id_seq" OWNED BY langflow."Triggers".id;


--
-- TOC entry 201 (class 1259 OID 1229902)
-- Name: Workflows; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow."Workflows" (
    id integer NOT NULL,
    "tenantId" character varying(255),
    name character varying(255),
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL,
    style text,
    description text,
    uuid uuid,
    data json
);


--
-- TOC entry 200 (class 1259 OID 1229900)
-- Name: Workflows_id_seq; Type: SEQUENCE; Schema: langflow; Owner: -
--

CREATE SEQUENCE langflow."Workflows_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2890 (class 0 OID 0)
-- Dependencies: 200
-- Name: Workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: langflow; Owner: -
--

ALTER SEQUENCE langflow."Workflows_id_seq" OWNED BY langflow."Workflows".id;


--
-- TOC entry 210 (class 1259 OID 1229980)
-- Name: flow; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow.flow (
    data json,
    name character varying NOT NULL,
    description character varying,
    id uuid NOT NULL
);


--
-- TOC entry 211 (class 1259 OID 1229990)
-- Name: flowstyle; Type: TABLE; Schema: langflow; Owner: -
--

CREATE TABLE langflow.flowstyle (
    color character varying NOT NULL,
    emoji character varying NOT NULL,
    flow_id uuid,
    id uuid NOT NULL
);


--
-- TOC entry 2721 (class 2604 OID 1229927)
-- Name: ExecutionLogs id; Type: DEFAULT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."ExecutionLogs" ALTER COLUMN id SET DEFAULT nextval('langflow."ExecutionLogs_id_seq"'::regclass);


--
-- TOC entry 2718 (class 2604 OID 1229894)
-- Name: Jobs id; Type: DEFAULT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Jobs" ALTER COLUMN id SET DEFAULT nextval('langflow."Jobs_id_seq"'::regclass);


--
-- TOC entry 2722 (class 2604 OID 1229938)
-- Name: Nodes id; Type: DEFAULT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Nodes" ALTER COLUMN id SET DEFAULT nextval('langflow."Nodes_id_seq"'::regclass);


--
-- TOC entry 2720 (class 2604 OID 1229916)
-- Name: RunLogs id; Type: DEFAULT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."RunLogs" ALTER COLUMN id SET DEFAULT nextval('langflow."RunLogs_id_seq"'::regclass);


--
-- TOC entry 2723 (class 2604 OID 1229949)
-- Name: Triggers id; Type: DEFAULT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Triggers" ALTER COLUMN id SET DEFAULT nextval('langflow."Triggers_id_seq"'::regclass);


--
-- TOC entry 2719 (class 2604 OID 1229905)
-- Name: Workflows id; Type: DEFAULT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Workflows" ALTER COLUMN id SET DEFAULT nextval('langflow."Workflows_id_seq"'::regclass);


--
-- TOC entry 2873 (class 0 OID 1229924)
-- Dependencies: 205
-- Data for Name: ExecutionLogs; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (1, '1', '1', '2023-07-11 10:29:12.399+08', '9bdd9a56-a382-46b7-be28-58154a3fe2ef', 1, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '1', '2', '0', '2023-07-11 10:29:12.399+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (2, '1', '1', '2023-07-11 10:29:16.172+08', '9bdd9a56-a382-46b7-be28-58154a3fe2ef', 7, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '2', '2a', '1', '2023-07-11 10:29:16.172+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (3, '1', '1', '2023-07-11 10:29:18.532+08', '9bdd9a56-a382-46b7-be28-58154a3fe2ef', 2, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '2a', '2c', '0', '2023-07-11 10:29:18.532+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (4, '1', '1', '2023-07-11 10:29:19.809+08', '9bdd9a56-a382-46b7-be28-58154a3fe2ef', 1, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '2c', '3c', '0', '2023-07-11 10:29:19.809+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (5, '1', '1', '2023-07-11 10:29:21.363+08', '9bdd9a56-a382-46b7-be28-58154a3fe2ef', 0, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '3c', '4b', '0', '2023-07-11 10:29:21.363+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (6, '1', '1', '2023-07-11 10:50:42.156+08', '16ed1929-8f99-4274-b44a-0502afb4f7c1', 0, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '1', '2', '0', '2023-07-11 10:50:42.156+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (7, '1', '1', '2023-07-11 10:50:46.721+08', '16ed1929-8f99-4274-b44a-0502afb4f7c1', 1, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '2', '2a', '1', '2023-07-11 10:50:46.721+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (8, '1', '1', '2023-07-11 10:50:56.615+08', '16ed1929-8f99-4274-b44a-0502afb4f7c1', 1, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '2a', '2c', '0', '2023-07-11 10:50:56.616+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (9, '1', '1', '2023-07-11 10:50:57.746+08', '16ed1929-8f99-4274-b44a-0502afb4f7c1', 2, '{"order":{"id":450789469,"admin_graphql_api_id":"gid://shopify/Order/450789469","app_id":null,"browser_ip":"0.0.0.0","buyer_accepts_marketing":false,"cancel_reason":null,"cancelled_at":null,"cart_token":"68778783ad298f1c80c3bafcddeea02f","checkout_id":901414060,"checkout_token":"bd5a8aa1ecd019dd3520ff791ee3a24c","client_details":{"accept_language":null,"browser_height":null,"browser_ip":"0.0.0.0","browser_width":null,"session_hash":null,"user_agent":null},"closed_at":null,"confirmed":true,"contact_email":"bob.norman@mail.example.com","created_at":"2008-01-10T11:00:00-05:00","currency":"USD","current_subtotal_price":"195.67","current_subtotal_price_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"current_total_discounts":"3.33","current_total_discounts_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"current_total_duties_set":null,"current_total_price":"199.65","current_total_price_set":{"shop_money":{"amount":"199.65","currency_code":"USD"},"presentment_money":{"amount":"199.65","currency_code":"USD"}},"current_total_tax":"3.98","current_total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"customer_locale":null,"device_id":null,"discount_codes":[{"code":"TENOFF","amount":"10.00","type":"fixed_amount"}],"email":"bob.norman@mail.example.com","estimated_taxes":false,"financial_status":"partially_refunded","fulfillment_status":null,"gateway":"authorize_net","landing_site":"http://www.example.com?source=abc","landing_site_ref":"abc","location_id":null,"name":"#1001","note":null,"note_attributes":[{"name":"custom engraving","value":"Happy Birthday"},{"name":"colour","value":"green"}],"number":1,"order_number":1001,"order_status_url":"https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod","original_total_duties_set":null,"payment_gateway_names":["bogus"],"phone":"+557734881234","presentment_currency":"USD","processed_at":"2008-01-10T11:00:00-05:00","processing_method":"direct","reference":"fhwdgads","referring_site":"http://www.otherexample.com","source_identifier":"fhwdgads","source_name":"web","source_url":null,"subtotal_price":"597.00","subtotal_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"tags":"","tax_lines":[{"price":"11.94","rate":0.06,"title":"State Tax","price_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"channel_liable":null}],"taxes_included":false,"test":false,"token":"b1946ac92492d2347c6235b4d2611184","total_discounts":"10.00","total_discounts_set":{"shop_money":{"amount":"10.00","currency_code":"USD"},"presentment_money":{"amount":"10.00","currency_code":"USD"}},"total_line_items_price":"597.00","total_line_items_price_set":{"shop_money":{"amount":"597.00","currency_code":"USD"},"presentment_money":{"amount":"597.00","currency_code":"USD"}},"total_outstanding":"0.00","total_price":"598.94","total_price_set":{"shop_money":{"amount":"598.94","currency_code":"USD"},"presentment_money":{"amount":"598.94","currency_code":"USD"}},"total_price_usd":"598.94","total_shipping_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_tax":"11.94","total_tax_set":{"shop_money":{"amount":"11.94","currency_code":"USD"},"presentment_money":{"amount":"11.94","currency_code":"USD"}},"total_tip_received":"0.00","total_weight":0,"updated_at":"2008-01-10T11:00:00-05:00","user_id":null,"billing_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"customer":{"id":207119551,"email":"bob.norman@mail.example.com","accepts_marketing":false,"created_at":"2022-04-05T13:05:24-04:00","updated_at":"2022-04-05T13:05:24-04:00","first_name":"Bob","last_name":"Norman","state":"disabled","note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":"+16136120707","tags":"","currency":"USD","accepts_marketing_updated_at":"2005-06-12T11:57:11-04:00","marketing_opt_in_level":null,"tax_exemptions":[],"email_marketing_consent":{"state":"not_subscribed","opt_in_level":null,"consent_updated_at":"2004-06-13T11:57:11-04:00"},"sms_marketing_consent":null,"sms_transactional_consent":null,"admin_graphql_api_id":"gid://shopify/Customer/207119551","default_address":{"id":207119551,"customer_id":207119551,"first_name":null,"last_name":null,"company":null,"address1":"Chestnut Street 92","address2":"","city":"Louisville","province":"Kentucky","country":"United States","zip":"40202","phone":"555-625-1199","name":"","province_code":"KY","country_code":"US","country_name":"United States","default":true}},"discount_applications":[{"target_type":"line_item","type":"discount_code","value":"10.0","value_type":"fixed_amount","allocation_method":"across","target_selection":"all","code":"TENOFF"}],"fulfillments":[{"id":255858046,"admin_graphql_api_id":"gid://shopify/Fulfillment/255858046","created_at":"2022-04-05T13:05:24-04:00","location_id":655441491,"name":"#1001.0","order_id":450789469,"origin_address":{},"receipt":{"testcase":true,"authorization":"123456"},"service":"manual","shipment_status":null,"status":"failure","tracking_company":"USPS","tracking_number":"1Z2345","tracking_numbers":["1Z2345"],"tracking_url":"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345","tracking_urls":["https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"],"updated_at":"2022-04-05T13:05:24-04:00","line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}]}],"line_items":[{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]},{"id":518995019,"admin_graphql_api_id":"gid://shopify/LineItem/518995019","fulfillable_quantity":1,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - red","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008RED","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":49148385,"variant_inventory_management":"shopify","variant_title":"red","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]},{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}],"payment_details":{"credit_card_bin":null,"avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 4242","credit_card_company":"Visa","credit_card_name":null,"credit_card_wallet":null,"credit_card_expiration_month":null,"credit_card_expiration_year":null},"refunds":[{"id":509562969,"admin_graphql_api_id":"gid://shopify/Refund/509562969","created_at":"2022-04-05T13:05:24-04:00","note":"it broke during shipping","order_id":450789469,"processed_at":"2022-04-05T13:05:24-04:00","restock":true,"total_additional_fees_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"total_duties_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"user_id":548380009,"order_adjustments":[],"transactions":[{"id":179259969,"admin_graphql_api_id":"gid://shopify/OrderTransaction/179259969","amount":"209.00","authorization":"authorization-key","created_at":"2005-08-05T12:59:12-04:00","currency":"USD","device_id":null,"error_code":null,"gateway":"bogus","kind":"refund","location_id":null,"message":null,"order_id":450789469,"parent_id":801038806,"processed_at":"2005-08-05T12:59:12-04:00","receipt":{},"source_name":"web","status":"success","test":false,"user_id":null}],"refund_line_items":[{"id":104689539,"line_item_id":703073504,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.66,"subtotal_set":{"shop_money":{"amount":"195.66","currency_code":"USD"},"presentment_money":{"amount":"195.66","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":703073504,"admin_graphql_api_id":"gid://shopify/LineItem/703073504","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - black","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[],"quantity":1,"requires_shipping":true,"sku":"IPOD2008BLACK","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":457924702,"variant_inventory_management":"shopify","variant_title":"black","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.33","amount_set":{"shop_money":{"amount":"3.33","currency_code":"USD"},"presentment_money":{"amount":"3.33","currency_code":"USD"}},"discount_application_index":0}]}},{"id":709875399,"line_item_id":466157049,"location_id":487838322,"quantity":1,"restock_type":"legacy_restock","subtotal":195.67,"subtotal_set":{"shop_money":{"amount":"195.67","currency_code":"USD"},"presentment_money":{"amount":"195.67","currency_code":"USD"}},"total_tax":3.98,"total_tax_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"line_item":{"id":466157049,"admin_graphql_api_id":"gid://shopify/LineItem/466157049","fulfillable_quantity":0,"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":200,"name":"IPod Nano - 8gb - green","price":"199.00","price_set":{"shop_money":{"amount":"199.00","currency_code":"USD"},"presentment_money":{"amount":"199.00","currency_code":"USD"}},"product_exists":true,"product_id":632910392,"properties":[{"name":"Custom Engraving Front","value":"Happy Birthday"},{"name":"Custom Engraving Back","value":"Merry Christmas"}],"quantity":1,"requires_shipping":true,"sku":"IPOD2008GREEN","taxable":true,"title":"IPod Nano - 8gb","total_discount":"0.00","total_discount_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"variant_id":39072856,"variant_inventory_management":"shopify","variant_title":"green","vendor":null,"tax_lines":[{"channel_liable":null,"price":"3.98","price_set":{"shop_money":{"amount":"3.98","currency_code":"USD"},"presentment_money":{"amount":"3.98","currency_code":"USD"}},"rate":0.06,"title":"State Tax"}],"duties":[],"discount_allocations":[{"amount":"3.34","amount_set":{"shop_money":{"amount":"3.34","currency_code":"USD"},"presentment_money":{"amount":"3.34","currency_code":"USD"}},"discount_application_index":0}]}}],"duties":[],"additional_fees":[]}],"shipping_address":{"first_name":"Bob","address1":"Chestnut Street 92","phone":"555-625-1199","city":"Louisville","zip":"40202","province":"Kentucky","country":"United States","last_name":"Norman","address2":"","company":null,"latitude":45.41634,"longitude":-75.6868,"name":"Bob Norman","country_code":"US","province_code":"KY"},"shipping_lines":[{"id":369256396,"carrier_identifier":null,"code":"Free Shipping","delivery_category":null,"discounted_price":"0.00","discounted_price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"phone":null,"price":"0.00","price_set":{"shop_money":{"amount":"0.00","currency_code":"USD"},"presentment_money":{"amount":"0.00","currency_code":"USD"}},"requested_fulfillment_service_id":null,"source":"shopify","title":"Free Shipping","tax_lines":[],"discount_allocations":[]}]}}', '2c', '3c', '0', '2023-07-11 10:50:57.746+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (10, '1', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-13 14:00:58.43573+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', 3028, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '1', '2', '0', '2023-07-13 14:00:58.43573+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (11, '1', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-13 15:37:01.999169+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', 44292, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '2', '2c', '0', '2023-07-13 15:37:02.793124+08', NULL);
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (12, '1', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-13 15:46:14.051961+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', 13957, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '2c', '3c', '0', '2023-07-13 15:46:14.28542+08', '[*] CURRENT STATE: 2c: Find All Locations with Complete Inventory
final output code:
  var outputPort = 0;
  return { obj, outputPort };
Error: eval code is occur in workflow! invalid syntax (<string>, line 1)
output port: 0
->NEXT STATE: 3c
');
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (13, '1', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-13 15:58:47.689487+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', 19303, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '3c', '4b', '0', '2023-07-13 15:58:47.891245+08', '[*] CURRENT STATE: 3c: Split Shipment ← →  based on Lowest Cost
output port: 0
->NEXT STATE: 4b
');
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (14, '1', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-13 15:59:29.470763+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', 13851, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '4b', '_COMPLETE', '0', '2023-07-13 15:59:30.10673+08', '[*] CURRENT STATE: 4b: Ship 📦
Complete.
');
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (15, '1', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '2023-07-13 17:14:51.656838+08', '8d7ee753-c8de-4049-93ff-bbb0de6b70e6', 10586, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '1', '2', '0', '2023-07-13 17:14:51.873075+08', '[*] CURRENT STATE: 1: 🛒 New Order
output port: 0
->NEXT STATE: 2
');
INSERT INTO langflow."ExecutionLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", data, "currentState", "nextState", "outputPort", "updatedAt", logs) VALUES (16, '1', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '2023-07-13 17:15:46.330436+08', '8d7ee753-c8de-4049-93ff-bbb0de6b70e6', 19738, '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '2', '2c', '0', '2023-07-13 17:15:46.330436+08', '[*] CURRENT STATE: 2: Fraud Check
final output code:
outputPort = 0;
 if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };
 return {obj, outputPort};
Error: eval code is occur in workflow! invalid syntax (<string>, line 1)
output port: 0
->NEXT STATE: 2c
');


--
-- TOC entry 2867 (class 0 OID 1229891)
-- Dependencies: 199
-- Data for Name: Jobs; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow."Jobs" (id, "tenantId", "workflowId", "currentTaskState", "createdAt", "runId", data, "updatedAt") VALUES (3, '1', '39b477cc-878b-461d-9ddb-f534c728abc3', '_COMPLETE', '2023-07-13 13:02:40.491768+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '2023-07-13 13:02:40.989584+08');
INSERT INTO langflow."Jobs" (id, "tenantId", "workflowId", "currentTaskState", "createdAt", "runId", data, "updatedAt") VALUES (4, '1', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '2c', '2023-07-13 17:14:12.16876+08', '8d7ee753-c8de-4049-93ff-bbb0de6b70e6', '{
  "order": {
    "id": 450789469,
    "admin_graphql_api_id": "gid://shopify/Order/450789469",
    "app_id": null,
    "browser_ip": "0.0.0.0",
    "buyer_accepts_marketing": false,
    "cancel_reason": null,
    "cancelled_at": null,
    "cart_token": "68778783ad298f1c80c3bafcddeea02f",
    "checkout_id": 901414060,
    "checkout_token": "bd5a8aa1ecd019dd3520ff791ee3a24c",
    "client_details": {
      "accept_language": null,
      "browser_height": null,
      "browser_ip": "0.0.0.0",
      "browser_width": null,
      "session_hash": null,
      "user_agent": null
    },
    "closed_at": null,
    "confirmed": true,
    "contact_email": "bob.norman@mail.example.com",
    "created_at": "2008-01-10T11:00:00-05:00",
    "currency": "USD",
    "current_subtotal_price": "195.67",
    "current_subtotal_price_set": {
      "shop_money": {
        "amount": "195.67",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "195.67",
        "currency_code": "USD"
      }
    },
    "current_total_discounts": "3.33",
    "current_total_discounts_set": {
      "shop_money": {
        "amount": "3.33",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.33",
        "currency_code": "USD"
      }
    },
    "current_total_duties_set": null,
    "current_total_price": "199.65",
    "current_total_price_set": {
      "shop_money": {
        "amount": "199.65",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "199.65",
        "currency_code": "USD"
      }
    },
    "current_total_tax": "3.98",
    "current_total_tax_set": {
      "shop_money": {
        "amount": "3.98",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "3.98",
        "currency_code": "USD"
      }
    },
    "customer_locale": null,
    "device_id": null,
    "discount_codes": [
      {
        "code": "TENOFF",
        "amount": "10.00",
        "type": "fixed_amount"
      }
    ],
    "email": "bob.norman@mail.example.com",
    "estimated_taxes": false,
    "financial_status": "partially_refunded",
    "fulfillment_status": null,
    "gateway": "authorize_net",
    "landing_site": "http://www.example.com?source=abc",
    "landing_site_ref": "abc",
    "location_id": null,
    "name": "#1001",
    "note": null,
    "note_attributes": [
      {
        "name": "custom engraving",
        "value": "Happy Birthday"
      },
      {
        "name": "colour",
        "value": "green"
      }
    ],
    "number": 1,
    "order_number": 1001,
    "order_status_url": "https://jsmith.myshopify.com/548380009/orders/b1946ac92492d2347c6235b4d2611184/authenticate?key=imasecretipod",
    "original_total_duties_set": null,
    "payment_gateway_names": [
      "bogus"
    ],
    "phone": "+557734881234",
    "presentment_currency": "USD",
    "processed_at": "2008-01-10T11:00:00-05:00",
    "processing_method": "direct",
    "reference": "fhwdgads",
    "referring_site": "http://www.otherexample.com",
    "source_identifier": "fhwdgads",
    "source_name": "web",
    "source_url": null,
    "subtotal_price": "597.00",
    "subtotal_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "tags": "",
    "tax_lines": [
      {
        "price": "11.94",
        "rate": 0.06,
        "title": "State Tax",
        "price_set": {
          "shop_money": {
            "amount": "11.94",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "11.94",
            "currency_code": "USD"
          }
        },
        "channel_liable": null
      }
    ],
    "taxes_included": false,
    "test": false,
    "token": "b1946ac92492d2347c6235b4d2611184",
    "total_discounts": "10.00",
    "total_discounts_set": {
      "shop_money": {
        "amount": "10.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "10.00",
        "currency_code": "USD"
      }
    },
    "total_line_items_price": "597.00",
    "total_line_items_price_set": {
      "shop_money": {
        "amount": "597.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "597.00",
        "currency_code": "USD"
      }
    },
    "total_outstanding": "0.00",
    "total_price": "598.94",
    "total_price_set": {
      "shop_money": {
        "amount": "598.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "598.94",
        "currency_code": "USD"
      }
    },
    "total_price_usd": "598.94",
    "total_shipping_price_set": {
      "shop_money": {
        "amount": "0.00",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "0.00",
        "currency_code": "USD"
      }
    },
    "total_tax": "11.94",
    "total_tax_set": {
      "shop_money": {
        "amount": "11.94",
        "currency_code": "USD"
      },
      "presentment_money": {
        "amount": "11.94",
        "currency_code": "USD"
      }
    },
    "total_tip_received": "0.00",
    "total_weight": 0,
    "updated_at": "2008-01-10T11:00:00-05:00",
    "user_id": null,
    "billing_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "customer": {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "accepts_marketing": false,
      "created_at": "2022-04-05T13:05:24-04:00",
      "updated_at": "2022-04-05T13:05:24-04:00",
      "first_name": "Bob",
      "last_name": "Norman",
      "state": "disabled",
      "note": null,
      "verified_email": true,
      "multipass_identifier": null,
      "tax_exempt": false,
      "phone": "+16136120707",
      "tags": "",
      "currency": "USD",
      "accepts_marketing_updated_at": "2005-06-12T11:57:11-04:00",
      "marketing_opt_in_level": null,
      "tax_exemptions": [],
      "email_marketing_consent": {
        "state": "not_subscribed",
        "opt_in_level": null,
        "consent_updated_at": "2004-06-13T11:57:11-04:00"
      },
      "sms_marketing_consent": null,
      "sms_transactional_consent": null,
      "admin_graphql_api_id": "gid://shopify/Customer/207119551",
      "default_address": {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": null,
        "last_name": null,
        "company": null,
        "address1": "Chestnut Street 92",
        "address2": "",
        "city": "Louisville",
        "province": "Kentucky",
        "country": "United States",
        "zip": "40202",
        "phone": "555-625-1199",
        "name": "",
        "province_code": "KY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    },
    "discount_applications": [
      {
        "target_type": "line_item",
        "type": "discount_code",
        "value": "10.0",
        "value_type": "fixed_amount",
        "allocation_method": "across",
        "target_selection": "all",
        "code": "TENOFF"
      }
    ],
    "fulfillments": [
      {
        "id": 255858046,
        "admin_graphql_api_id": "gid://shopify/Fulfillment/255858046",
        "created_at": "2022-04-05T13:05:24-04:00",
        "location_id": 655441491,
        "name": "#1001.0",
        "order_id": 450789469,
        "origin_address": {},
        "receipt": {
          "testcase": true,
          "authorization": "123456"
        },
        "service": "manual",
        "shipment_status": null,
        "status": "failure",
        "tracking_company": "USPS",
        "tracking_number": "1Z2345",
        "tracking_numbers": [
          "1Z2345"
        ],
        "tracking_url": "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345",
        "tracking_urls": [
          "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=1Z2345"
        ],
        "updated_at": "2022-04-05T13:05:24-04:00",
        "line_items": [
          {
            "id": 466157049,
            "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
            "fulfillable_quantity": 0,
            "fulfillment_service": "manual",
            "fulfillment_status": null,
            "gift_card": false,
            "grams": 200,
            "name": "IPod Nano - 8gb - green",
            "price": "199.00",
            "price_set": {
              "shop_money": {
                "amount": "199.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "199.00",
                "currency_code": "USD"
              }
            },
            "product_exists": true,
            "product_id": 632910392,
            "properties": [
              {
                "name": "Custom Engraving Front",
                "value": "Happy Birthday"
              },
              {
                "name": "Custom Engraving Back",
                "value": "Merry Christmas"
              }
            ],
            "quantity": 1,
            "requires_shipping": true,
            "sku": "IPOD2008GREEN",
            "taxable": true,
            "title": "IPod Nano - 8gb",
            "total_discount": "0.00",
            "total_discount_set": {
              "shop_money": {
                "amount": "0.00",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "0.00",
                "currency_code": "USD"
              }
            },
            "variant_id": 39072856,
            "variant_inventory_management": "shopify",
            "variant_title": "green",
            "vendor": null,
            "tax_lines": [
              {
                "channel_liable": null,
                "price": "3.98",
                "price_set": {
                  "shop_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.98",
                    "currency_code": "USD"
                  }
                },
                "rate": 0.06,
                "title": "State Tax"
              }
            ],
            "duties": [],
            "discount_allocations": [
              {
                "amount": "3.34",
                "amount_set": {
                  "shop_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  },
                  "presentment_money": {
                    "amount": "3.34",
                    "currency_code": "USD"
                  }
                },
                "discount_application_index": 0
              }
            ]
          }
        ]
      }
    ],
    "line_items": [
      {
        "id": 466157049,
        "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - green",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [
          {
            "name": "Custom Engraving Front",
            "value": "Happy Birthday"
          },
          {
            "name": "Custom Engraving Back",
            "value": "Merry Christmas"
          }
        ],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008GREEN",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 39072856,
        "variant_inventory_management": "shopify",
        "variant_title": "green",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.34",
            "amount_set": {
              "shop_money": {
                "amount": "3.34",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.34",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 518995019,
        "admin_graphql_api_id": "gid://shopify/LineItem/518995019",
        "fulfillable_quantity": 1,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - red",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008RED",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 49148385,
        "variant_inventory_management": "shopify",
        "variant_title": "red",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      },
      {
        "id": 703073504,
        "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
        "fulfillable_quantity": 0,
        "fulfillment_service": "manual",
        "fulfillment_status": null,
        "gift_card": false,
        "grams": 200,
        "name": "IPod Nano - 8gb - black",
        "price": "199.00",
        "price_set": {
          "shop_money": {
            "amount": "199.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "199.00",
            "currency_code": "USD"
          }
        },
        "product_exists": true,
        "product_id": 632910392,
        "properties": [],
        "quantity": 1,
        "requires_shipping": true,
        "sku": "IPOD2008BLACK",
        "taxable": true,
        "title": "IPod Nano - 8gb",
        "total_discount": "0.00",
        "total_discount_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "variant_id": 457924702,
        "variant_inventory_management": "shopify",
        "variant_title": "black",
        "vendor": null,
        "tax_lines": [
          {
            "channel_liable": null,
            "price": "3.98",
            "price_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "rate": 0.06,
            "title": "State Tax"
          }
        ],
        "duties": [],
        "discount_allocations": [
          {
            "amount": "3.33",
            "amount_set": {
              "shop_money": {
                "amount": "3.33",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.33",
                "currency_code": "USD"
              }
            },
            "discount_application_index": 0
          }
        ]
      }
    ],
    "payment_details": {
      "credit_card_bin": null,
      "avs_result_code": null,
      "cvv_result_code": null,
      "credit_card_number": "•••• •••• •••• 4242",
      "credit_card_company": "Visa",
      "credit_card_name": null,
      "credit_card_wallet": null,
      "credit_card_expiration_month": null,
      "credit_card_expiration_year": null
    },
    "refunds": [
      {
        "id": 509562969,
        "admin_graphql_api_id": "gid://shopify/Refund/509562969",
        "created_at": "2022-04-05T13:05:24-04:00",
        "note": "it broke during shipping",
        "order_id": 450789469,
        "processed_at": "2022-04-05T13:05:24-04:00",
        "restock": true,
        "total_additional_fees_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "total_duties_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "user_id": 548380009,
        "order_adjustments": [],
        "transactions": [
          {
            "id": 179259969,
            "admin_graphql_api_id": "gid://shopify/OrderTransaction/179259969",
            "amount": "209.00",
            "authorization": "authorization-key",
            "created_at": "2005-08-05T12:59:12-04:00",
            "currency": "USD",
            "device_id": null,
            "error_code": null,
            "gateway": "bogus",
            "kind": "refund",
            "location_id": null,
            "message": null,
            "order_id": 450789469,
            "parent_id": 801038806,
            "processed_at": "2005-08-05T12:59:12-04:00",
            "receipt": {},
            "source_name": "web",
            "status": "success",
            "test": false,
            "user_id": null
          }
        ],
        "refund_line_items": [
          {
            "id": 104689539,
            "line_item_id": 703073504,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.66,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.66",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.66",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 703073504,
              "admin_graphql_api_id": "gid://shopify/LineItem/703073504",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - black",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008BLACK",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 457924702,
              "variant_inventory_management": "shopify",
              "variant_title": "black",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.33",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.33",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          },
          {
            "id": 709875399,
            "line_item_id": 466157049,
            "location_id": 487838322,
            "quantity": 1,
            "restock_type": "legacy_restock",
            "subtotal": 195.67,
            "subtotal_set": {
              "shop_money": {
                "amount": "195.67",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "195.67",
                "currency_code": "USD"
              }
            },
            "total_tax": 3.98,
            "total_tax_set": {
              "shop_money": {
                "amount": "3.98",
                "currency_code": "USD"
              },
              "presentment_money": {
                "amount": "3.98",
                "currency_code": "USD"
              }
            },
            "line_item": {
              "id": 466157049,
              "admin_graphql_api_id": "gid://shopify/LineItem/466157049",
              "fulfillable_quantity": 0,
              "fulfillment_service": "manual",
              "fulfillment_status": null,
              "gift_card": false,
              "grams": 200,
              "name": "IPod Nano - 8gb - green",
              "price": "199.00",
              "price_set": {
                "shop_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "199.00",
                  "currency_code": "USD"
                }
              },
              "product_exists": true,
              "product_id": 632910392,
              "properties": [
                {
                  "name": "Custom Engraving Front",
                  "value": "Happy Birthday"
                },
                {
                  "name": "Custom Engraving Back",
                  "value": "Merry Christmas"
                }
              ],
              "quantity": 1,
              "requires_shipping": true,
              "sku": "IPOD2008GREEN",
              "taxable": true,
              "title": "IPod Nano - 8gb",
              "total_discount": "0.00",
              "total_discount_set": {
                "shop_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                },
                "presentment_money": {
                  "amount": "0.00",
                  "currency_code": "USD"
                }
              },
              "variant_id": 39072856,
              "variant_inventory_management": "shopify",
              "variant_title": "green",
              "vendor": null,
              "tax_lines": [
                {
                  "channel_liable": null,
                  "price": "3.98",
                  "price_set": {
                    "shop_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.98",
                      "currency_code": "USD"
                    }
                  },
                  "rate": 0.06,
                  "title": "State Tax"
                }
              ],
              "duties": [],
              "discount_allocations": [
                {
                  "amount": "3.34",
                  "amount_set": {
                    "shop_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    },
                    "presentment_money": {
                      "amount": "3.34",
                      "currency_code": "USD"
                    }
                  },
                  "discount_application_index": 0
                }
              ]
            }
          }
        ],
        "duties": [],
        "additional_fees": []
      }
    ],
    "shipping_address": {
      "first_name": "Bob",
      "address1": "Chestnut Street 92",
      "phone": "555-625-1199",
      "city": "Louisville",
      "zip": "40202",
      "province": "Kentucky",
      "country": "United States",
      "last_name": "Norman",
      "address2": "",
      "company": null,
      "latitude": 45.41634,
      "longitude": -75.6868,
      "name": "Bob Norman",
      "country_code": "US",
      "province_code": "KY"
    },
    "shipping_lines": [
      {
        "id": 369256396,
        "carrier_identifier": null,
        "code": "Free Shipping",
        "delivery_category": null,
        "discounted_price": "0.00",
        "discounted_price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "phone": null,
        "price": "0.00",
        "price_set": {
          "shop_money": {
            "amount": "0.00",
            "currency_code": "USD"
          },
          "presentment_money": {
            "amount": "0.00",
            "currency_code": "USD"
          }
        },
        "requested_fulfillment_service_id": null,
        "source": "shopify",
        "title": "Free Shipping",
        "tax_lines": [],
        "discount_allocations": []
      }
    ]
  }
}', '2023-07-13 17:14:12.605645+08');


--
-- TOC entry 2875 (class 0 OID 1229935)
-- Dependencies: 207
-- Data for Name: Nodes; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow."Nodes" (id, "tenantId", uuid, name, code, css, "outputNodes", "editableFields", "createdAt", "updatedAt", description) VALUES (11, '1', '103', 'default', 'console.log(''hello world'');', '{}', '["out_0"]', '[{"id":"label","label":"Title","type":"input","defaultValue":"","placeHolder":"Node Title"},{"id":"code","label":"Conditional Logic","type":"textarea","defaultValue":"","description":"Javascript that returns an object and output port {obj, outputPort}","placeHolder":"outputPort = 0;\nreturn {obj, outputPort};"}]', '1980-07-20 00:00:00+08', '2023-07-12 14:05:12.766+08', NULL);
INSERT INTO langflow."Nodes" (id, "tenantId", uuid, name, code, css, "outputNodes", "editableFields", "createdAt", "updatedAt", description) VALUES (15, '1', '62eef968-bc74-4e5d-8168-973b14aa6286', 'work-node', 'dict(obj=obj, outputNode=0)', '{
}', '["accept", "rejuest"]', '[{"id": "label", "label": "Title", "type": "input", "defaultValue": "", "placeHolder": "Node Title"}, {"id": "code", "label": "Conditional Logic", "type": "textarea", "defaultValue": "", "description": "Javascript that returns an object and output port {obj, outputPort}", "placeHolder": "outputPort = 0;\nreturn {obj, outputPort};"}]', '2023-07-12 17:21:53.448632+08', '2023-07-13 14:48:05.807353+08', '人工节点');
INSERT INTO langflow."Nodes" (id, "tenantId", uuid, name, code, css, "outputNodes", "editableFields", "createdAt", "updatedAt", description) VALUES (10, '1', '102', 'decision', 'outputNode = 0
if ({ifstatement}):
    outputNode = 1
else:
    outputNode = 0
return dict(obj=obj, outputNode=outputNode);', '{}', '["True","False"]', '[{"id":"label","label":"Title","type":"input","defaultValue":"","placeHolder":"Node Title"},{"id":"ifstatement","label":"If Statement","type":"input","defaultValue":"","placeHolder":"(obj.value == \"apple\")"}]', '1980-07-20 00:00:00+08', '2023-07-13 12:15:18.840967+08', '');
INSERT INTO langflow."Nodes" (id, "tenantId", uuid, name, code, css, "outputNodes", "editableFields", "createdAt", "updatedAt", description) VALUES (9, '1', '101', 'notification', 'dict(obj=obj, outputNode=0)', '{
  "background": "#FEEBC8",
  "color": "#333",
  "border": "none",
  "width": 80,
  "borderRadius": 20,
  "fontSize": 10,
  "padding": 5,
  "textAlign": "center"
}', '["out_0"]', '[{"id":"label","label":"Title","type":"input","defaultValue":"","placeHolder":"Node Title"},{"id":"url","label":"URL To call","type":"input","defaultValue":"","placeHolder":"https://external.url/webhook"}]', '1980-07-20 00:00:00+08', '2023-07-13 12:24:06.224084+08', '调用外部接口，发送通知');
INSERT INTO langflow."Nodes" (id, "tenantId", uuid, name, code, css, "outputNodes", "editableFields", "createdAt", "updatedAt", description) VALUES (12, '1', '104', 'comment', 'dict(obj=obj, outputNode=0)', '{
  "background": "#FEFCBF",
  "color": "#333",
  "border": "none",
  "width": 120,
  "borderRadius": 1,
  "fontSize": 8,
  "padding": 5,
  "borderTop": "3px solid #D69E2E"
}', '[]', '[{"id":"label","label":"Comment Text","type":"textarea","placeHolder":"Insert Comment here","defaultValue":""}]', '1980-07-20 00:00:00+08', '2023-07-13 12:25:57.321742+08', '');


--
-- TOC entry 2871 (class 0 OID 1229913)
-- Dependencies: 203
-- Data for Name: RunLogs; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow."RunLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", "updatedAt") VALUES (1, '1', '1', '2023-07-11 10:29:12.359+08', '9bdd9a56-a382-46b7-be28-58154a3fe2ef', 0, '2023-07-11 10:29:12.363+08');
INSERT INTO langflow."RunLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", "updatedAt") VALUES (2, '1', '1', '2023-07-11 10:50:42.15+08', '16ed1929-8f99-4274-b44a-0502afb4f7c1', 0, '2023-07-11 10:50:42.152+08');
INSERT INTO langflow."RunLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", "updatedAt") VALUES (3, '1', NULL, '2023-07-13 14:00:58.406749+08', 'f91e5a45-0545-4936-b32d-7e0e2e020e56', 0, '2023-07-13 15:59:20.164012+08');
INSERT INTO langflow."RunLogs" (id, "tenantId", "workflowId", "createdAt", "runId", "runTime", "updatedAt") VALUES (4, '1', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '2023-07-13 17:14:41.656318+08', '8d7ee753-c8de-4049-93ff-bbb0de6b70e6', 30324, '2023-07-13 17:15:46.312418+08');


--
-- TOC entry 2877 (class 0 OID 1229946)
-- Dependencies: 209
-- Data for Name: Triggers; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow."Triggers" (id, "tenantId", uuid, name, shortcode, "createdAt", "workflowId", "updatedAt") VALUES (1, '1', '101', 'New Order from Ecommerce', 'new_order', '2023-07-11 10:29:02.64+08', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-11 10:29:02.64+08');
INSERT INTO langflow."Triggers" (id, "tenantId", uuid, name, shortcode, "createdAt", "workflowId", "updatedAt") VALUES (2, '1', '102', 'Customer Update from Tulip', '3515', '2023-07-11 10:29:02.642+08', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-11 10:29:02.642+08');
INSERT INTO langflow."Triggers" (id, "tenantId", uuid, name, shortcode, "createdAt", "workflowId", "updatedAt") VALUES (3, '1', '103', 'New Order from Point of Sale', 'new_order_from_pos', '2023-07-11 10:29:02.643+08', '39b477cc-878b-461d-9ddb-f534c728abc3', '2023-07-11 10:29:02.643+08');
INSERT INTO langflow."Triggers" (id, "tenantId", uuid, name, shortcode, "createdAt", "workflowId", "updatedAt") VALUES (4, '1', '104', 'Event 22', 'event2', '2023-07-11 10:29:02.644+08', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '2023-07-13 16:56:33.475003+08');
INSERT INTO langflow."Triggers" (id, "tenantId", uuid, name, shortcode, "createdAt", "workflowId", "updatedAt") VALUES (5, '1', '105', '复杂流程 Event 2', 'event24', '2023-07-11 10:29:02.644+08', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '2023-07-13 16:57:13.324391+08');


--
-- TOC entry 2869 (class 0 OID 1229902)
-- Dependencies: 201
-- Data for Name: Workflows; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (2, '1', 'Returns Workflow', '2023-07-11 10:29:02.627+08', '2023-07-11 10:29:02.627+08', NULL, 'Returns Workflow', NULL, '[
  {
    "id": "1",
    "data": {
      "label": "🛒 New Order"
    },
    "position": {
      "x": 222,
      "y": 0
    },
    "style": {
      "background": "#BEE3F8",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "input",
    "draggable": true,
    "autoMove": true,
    "out": ["2"]
  },
  {
    "id": "2",
    "data": {
      "label": "Fraud Check",
      "ifstatement": "\"a\" == \"a\"",
      "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"
    },
    "position": {
      "x": 222,
      "y": 100
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "2a"]
  },
  {
    "id": "2a",
    "data": {
      "label": "Manual Approval",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };"
    },
    "position": {
      "x": 434,
      "y": 200
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "10a"]
  },
  {
    "id": "4c",
    "data": {
      "label": "Cancel Order ⛔"
    },
    "position": {
      "x": 400,
      "y": 700
    },
    "style": {
      "background": "#FEB2B2",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2c",
    "data": {
      "label": "Find All Locations with Complete Inventory",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };",
      "leftNodeName": "None",
      "rightNodeName": ">0"
    },
    "position": {
      "x": 111,
      "y": 300
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["3c", "2d"]
  },
  {
    "id": "3c",
    "data": {
      "label": "Split Shipment ← →  based on Lowest Cost"
    },
    "position": {
      "x": 0,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "type": "default",
    "out": ["4b"]
  },
  {
    "id": "4a",
    "data": {
      "label": "Problem Order ⚠️"
    },
    "position": {
      "x": 200,
      "y": 700
    },
    "style": {
      "background": "white",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2d",
    "data": {
      "label": "Sort Locations by Distance"
    },
    "position": {
      "x": 222,
      "y": 400
    },
    "draggable": true,
    "autoMove": true,
    "out": ["3b"]
  },
  {
    "id": "3b",
    "data": {
      "label": "Select Lowest Cost Shipping"
    },
    "position": {
      "x": 222,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "out": ["4b"]
  },
  {
    "id": "4b",
    "data": {
      "label": "Ship 📦"
    },
    "position": {
      "x": 0,
      "y": 700
    },
    "style": {
      "background": "#C6F6D5",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "10a",
    "data": {
      "label": "Notify Customer"
    },
    "position": {
      "x": 444,
      "y": 500
    },
    "type": "notification",
    "draggable": true,
    "autoMove": true,
    "out": ["4c"]
  },
  {
    "id": "comment-1",
    "data": {
      "label": "At this point the workflow waits on the third party system"
    },
    "position": {
      "x": 28.626315789473665,
      "y": 117.22631578947369
    },
    "style": {},
    "type": "comment",
    "draggable": true,
    "autoMove": false,
    "out": []
  }
]
');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (4, '1', 'New Order Workflow 2', '2023-07-11 10:29:02.627+08', '2023-07-12 20:30:43.41227+08', NULL, 'New Order Workflow 2', NULL, '[
  {
    "id": "1",
    "data": {
      "label": "🛒 New Order"
    },
    "position": {
      "x": 222,
      "y": 0
    },
    "style": {
      "background": "#BEE3F8",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "input",
    "draggable": true,
    "autoMove": true,
    "out": ["2"]
  },
  {
    "id": "2",
    "data": {
      "label": "Fraud Check",
      "ifstatement": "\"a\" == \"a\"",
      "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"
    },
    "position": {
      "x": 222,
      "y": 100
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "2a"]
  },
  {
    "id": "2a",
    "data": {
      "label": "Manual Approval",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };"
    },
    "position": {
      "x": 434,
      "y": 200
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "10a"]
  },
  {
    "id": "4c",
    "data": {
      "label": "Cancel Order ⛔"
    },
    "position": {
      "x": 400,
      "y": 700
    },
    "style": {
      "background": "#FEB2B2",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2c",
    "data": {
      "label": "Find All Locations with Complete Inventory",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };",
      "leftNodeName": "None",
      "rightNodeName": ">0"
    },
    "position": {
      "x": 111,
      "y": 300
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["3c", "2d"]
  },
  {
    "id": "3c",
    "data": {
      "label": "Split Shipment ← →  based on Lowest Cost"
    },
    "position": {
      "x": 0,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "type": "default",
    "out": ["4b"]
  },
  {
    "id": "4a",
    "data": {
      "label": "Problem Order ⚠️"
    },
    "position": {
      "x": 200,
      "y": 700
    },
    "style": {
      "background": "white",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2d",
    "data": {
      "label": "Sort Locations by Distance"
    },
    "position": {
      "x": 222,
      "y": 400
    },
    "draggable": true,
    "autoMove": true,
    "out": ["3b"]
  },
  {
    "id": "3b",
    "data": {
      "label": "Select Lowest Cost Shipping"
    },
    "position": {
      "x": 222,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "out": ["4b"]
  },
  {
    "id": "4b",
    "data": {
      "label": "Ship 📦"
    },
    "position": {
      "x": 0,
      "y": 700
    },
    "style": {
      "background": "#C6F6D5",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "10a",
    "data": {
      "label": "Notify Customer"
    },
    "position": {
      "x": 444,
      "y": 500
    },
    "type": "notification",
    "draggable": true,
    "autoMove": true,
    "out": ["4c"]
  },
  {
    "id": "comment-1",
    "data": {
      "label": "At this point the workflow waits on the third party system"
    },
    "position": {
      "x": 28.626315789473665,
      "y": 117.22631578947369
    },
    "style": {},
    "type": "comment",
    "draggable": true,
    "autoMove": false,
    "out": []
  }
]
');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (3, '1', 'Complex Workflow', '2023-07-11 10:29:02.627+08', '2023-07-12 21:02:43.451987+08', NULL, 'Complex Workflow', NULL, '[
  {
    "id": "1",
    "data": {
      "label": "🛒 New Order"
    },
    "position": {
      "x": 222,
      "y": 0
    },
    "style": {
      "background": "#BEE3F8",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "input",
    "draggable": true,
    "autoMove": true,
    "out": ["2"]
  },
  {
    "id": "2",
    "data": {
      "label": "Fraud Check",
      "ifstatement": "\"a\" == \"a\"",
      "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"
    },
    "position": {
      "x": 222,
      "y": 100
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "2a"]
  },
  {
    "id": "2a",
    "data": {
      "label": "Manual Approval",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };"
    },
    "position": {
      "x": 434,
      "y": 200
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "10a"]
  },
  {
    "id": "4c",
    "data": {
      "label": "Cancel Order ⛔"
    },
    "position": {
      "x": 400,
      "y": 700
    },
    "style": {
      "background": "#FEB2B2",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2c",
    "data": {
      "label": "Find All Locations with Complete Inventory",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };",
      "leftNodeName": "None",
      "rightNodeName": ">0"
    },
    "position": {
      "x": 111,
      "y": 300
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["3c", "2d"]
  },
  {
    "id": "3c",
    "data": {
      "label": "Split Shipment ← →  based on Lowest Cost"
    },
    "position": {
      "x": 0,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "type": "default",
    "out": ["4b"]
  },
  {
    "id": "4a",
    "data": {
      "label": "Problem Order ⚠️"
    },
    "position": {
      "x": 200,
      "y": 700
    },
    "style": {
      "background": "white",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2d",
    "data": {
      "label": "Sort Locations by Distance"
    },
    "position": {
      "x": 222,
      "y": 400
    },
    "draggable": true,
    "autoMove": true,
    "out": ["3b"]
  },
  {
    "id": "3b",
    "data": {
      "label": "Select Lowest Cost Shipping"
    },
    "position": {
      "x": 222,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "out": ["4b"]
  },
  {
    "id": "4b",
    "data": {
      "label": "Ship 📦"
    },
    "position": {
      "x": 0,
      "y": 700
    },
    "style": {
      "background": "#C6F6D5",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "10a",
    "data": {
      "label": "Notify Customer"
    },
    "position": {
      "x": 444,
      "y": 500
    },
    "type": "notification",
    "draggable": true,
    "autoMove": true,
    "out": ["4c"]
  },
  {
    "id": "comment-1",
    "data": {
      "label": "At this point the workflow waits on the third party system"
    },
    "position": {
      "x": 28.626315789473665,
      "y": 117.22631578947369
    },
    "style": {},
    "type": "comment",
    "draggable": true,
    "autoMove": false,
    "out": []
  }
]
');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (5, '1', 'Returns Workflow 2', '2023-07-11 10:29:02.628+08', '2023-07-11 10:29:02.628+08', NULL, 'Returns Workflow 2', NULL, '[
  {
    "id": "1",
    "data": {
      "label": "🛒 New Order"
    },
    "position": {
      "x": 222,
      "y": 0
    },
    "style": {
      "background": "#BEE3F8",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "input",
    "draggable": true,
    "autoMove": true,
    "out": ["2"]
  },
  {
    "id": "2",
    "data": {
      "label": "Fraud Check",
      "ifstatement": "\"a\" == \"a\"",
      "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"
    },
    "position": {
      "x": 222,
      "y": 100
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "2a"]
  },
  {
    "id": "2a",
    "data": {
      "label": "Manual Approval",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };"
    },
    "position": {
      "x": 434,
      "y": 200
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "10a"]
  },
  {
    "id": "4c",
    "data": {
      "label": "Cancel Order ⛔"
    },
    "position": {
      "x": 400,
      "y": 700
    },
    "style": {
      "background": "#FEB2B2",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2c",
    "data": {
      "label": "Find All Locations with Complete Inventory",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };",
      "leftNodeName": "None",
      "rightNodeName": ">0"
    },
    "position": {
      "x": 111,
      "y": 300
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["3c", "2d"]
  },
  {
    "id": "3c",
    "data": {
      "label": "Split Shipment ← →  based on Lowest Cost"
    },
    "position": {
      "x": 0,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "type": "default",
    "out": ["4b"]
  },
  {
    "id": "4a",
    "data": {
      "label": "Problem Order ⚠️"
    },
    "position": {
      "x": 200,
      "y": 700
    },
    "style": {
      "background": "white",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2d",
    "data": {
      "label": "Sort Locations by Distance"
    },
    "position": {
      "x": 222,
      "y": 400
    },
    "draggable": true,
    "autoMove": true,
    "out": ["3b"]
  },
  {
    "id": "3b",
    "data": {
      "label": "Select Lowest Cost Shipping"
    },
    "position": {
      "x": 222,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "out": ["4b"]
  },
  {
    "id": "4b",
    "data": {
      "label": "Ship 📦"
    },
    "position": {
      "x": 0,
      "y": 700
    },
    "style": {
      "background": "#C6F6D5",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "10a",
    "data": {
      "label": "Notify Customer"
    },
    "position": {
      "x": 444,
      "y": 500
    },
    "type": "notification",
    "draggable": true,
    "autoMove": true,
    "out": ["4c"]
  },
  {
    "id": "comment-1",
    "data": {
      "label": "At this point the workflow waits on the third party system"
    },
    "position": {
      "x": 28.626315789473665,
      "y": 117.22631578947369
    },
    "style": {},
    "type": "comment",
    "draggable": true,
    "autoMove": false,
    "out": []
  }
]
');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (6, '1', 'Complex Workflow 2', '2023-07-11 10:29:02.628+08', '2023-07-11 10:29:02.628+08', NULL, 'Complex Workflow 2', NULL, '[
  {
    "id": "1",
    "data": {
      "label": "🛒 New Order"
    },
    "position": {
      "x": 222,
      "y": 0
    },
    "style": {
      "background": "#BEE3F8",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "input",
    "draggable": true,
    "autoMove": true,
    "out": ["2"]
  },
  {
    "id": "2",
    "data": {
      "label": "Fraud Check",
      "ifstatement": "\"a\" == \"a\"",
      "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"
    },
    "position": {
      "x": 222,
      "y": 100
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "2a"]
  },
  {
    "id": "2a",
    "data": {
      "label": "Manual Approval",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };"
    },
    "position": {
      "x": 434,
      "y": 200
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["2c", "10a"]
  },
  {
    "id": "4c",
    "data": {
      "label": "Cancel Order ⛔"
    },
    "position": {
      "x": 400,
      "y": 700
    },
    "style": {
      "background": "#FEB2B2",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2c",
    "data": {
      "label": "Find All Locations with Complete Inventory",
      "code": "  var outputPort = 0;\n  return { obj, outputPort };",
      "leftNodeName": "None",
      "rightNodeName": ">0"
    },
    "position": {
      "x": 111,
      "y": 300
    },
    "type": "decision",
    "draggable": true,
    "autoMove": true,
    "out": ["3c", "2d"]
  },
  {
    "id": "3c",
    "data": {
      "label": "Split Shipment ← →  based on Lowest Cost"
    },
    "position": {
      "x": 0,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "type": "default",
    "out": ["4b"]
  },
  {
    "id": "4a",
    "data": {
      "label": "Problem Order ⚠️"
    },
    "position": {
      "x": 200,
      "y": 700
    },
    "style": {
      "background": "white",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "2d",
    "data": {
      "label": "Sort Locations by Distance"
    },
    "position": {
      "x": 222,
      "y": 400
    },
    "draggable": true,
    "autoMove": true,
    "out": ["3b"]
  },
  {
    "id": "3b",
    "data": {
      "label": "Select Lowest Cost Shipping"
    },
    "position": {
      "x": 222,
      "y": 500
    },
    "draggable": true,
    "autoMove": true,
    "out": ["4b"]
  },
  {
    "id": "4b",
    "data": {
      "label": "Ship 📦"
    },
    "position": {
      "x": 0,
      "y": 700
    },
    "style": {
      "background": "#C6F6D5",
      "color": "#333",
      "border": "2px solid #222138"
    },
    "type": "output",
    "draggable": true,
    "autoMove": true,
    "out": []
  },
  {
    "id": "10a",
    "data": {
      "label": "Notify Customer"
    },
    "position": {
      "x": 444,
      "y": 500
    },
    "type": "notification",
    "draggable": true,
    "autoMove": true,
    "out": ["4c"]
  },
  {
    "id": "comment-1",
    "data": {
      "label": "At this point the workflow waits on the third party system"
    },
    "position": {
      "x": 28.626315789473665,
      "y": 117.22631578947369
    },
    "style": {},
    "type": "comment",
    "draggable": true,
    "autoMove": false,
    "out": []
  }
]
');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (1, '1', 'New Order Workflow', '2023-07-11 10:40:50.203+08', '2023-07-11 10:40:50.203+08', NULL, 'New Order Workflow', NULL, '[{"id":"1","data":{"label":"🛒 New Order"},"position":{"x":222,"y":0},"style":{"background":"#BEE3F8","color":"#333","border":"2px solid #222138"},"type":"input","draggable":true,"autoMove":true,"out":["2"]},{"id":"2","data":{"label":"Fraud Check","ifstatement":"\"a\" == \"a\"","code":"outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"},"position":{"x":222,"y":100},"type":"decision","draggable":true,"autoMove":true,"out":["2c","2a"]},{"id":"2a","data":{"label":"Manual Approval","code":"  var outputPort = 0;\n  return { obj, outputPort };"},"position":{"x":434,"y":200},"type":"decision","draggable":true,"autoMove":true,"out":["2c","10a"]},{"id":"4c","data":{"label":"Cancel Order ⛔"},"position":{"x":400,"y":700},"style":{"background":"#FEB2B2","color":"#333","border":"2px solid #222138"},"type":"output","draggable":true,"autoMove":true,"out":[]},{"id":"2c","data":{"label":"Find All Locations with Complete Inventory","code":"  var outputPort = 0;\n  return { obj, outputPort };","leftNodeName":"None","rightNodeName":">0"},"position":{"x":111,"y":300},"type":"decision","draggable":true,"autoMove":true,"out":["3c","2d"]},{"id":"3c","data":{"label":"Split Shipment ← →  based on Lowest Cost"},"position":{"x":0,"y":500},"type":"default","draggable":true,"autoMove":true,"out":["4b"]},{"id":"4a","data":{"label":"Problem Order ⚠️"},"position":{"x":200,"y":700},"style":{"background":"white","color":"#333","border":"2px solid #222138"},"type":"output","draggable":true,"autoMove":true,"out":[]},{"id":"2d","data":{"label":"Sort Locations by Distance"},"position":{"x":222,"y":400},"draggable":true,"autoMove":true,"out":["3b"]},{"id":"3b","data":{"label":"Select Lowest Cost Shipping"},"position":{"x":222,"y":500},"draggable":true,"autoMove":true,"out":["4b"]},{"id":"4b","data":{"label":"Ship 📦"},"position":{"x":0,"y":700},"style":{"background":"#C6F6D5","color":"#333","border":"2px solid #222138"},"type":"output","draggable":true,"autoMove":true,"out":[]},{"id":"10a","data":{"label":"Notify Customer"},"position":{"x":444,"y":500},"type":"notification","draggable":true,"autoMove":true,"out":["4c"]},{"id":"comment-1","data":{"label":"At this point the workflow waits on the third party system"},"position":{"x":28.626315789473665,"y":117.22631578947369},"style":{},"type":"comment","draggable":true,"autoMove":false,"out":[]},{"id":"5fe73d74-ea13-4c3b-9c81-dee00f805182","data":{"label":"notification","code":"console.log(''hello world'');"},"position":{"x":-314.12808746008363,"y":247.92754010279333},"style":{},"type":"notification","draggable":true,"autoMove":false,"out":[]}]');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (11, '1', '我的 Complex Workflow 2', '2023-07-13 14:39:51.460399+08', '2023-07-13 14:39:51.460399+08', NULL, 'Complex Workflow 2', '3b9c624b-9271-46b0-bfa3-a9db9353389e', '[{"id": "1", "data": {"label": "\ud83d\uded2 New Order"}, "position": {"x": 222, "y": 0}, "style": {"background": "#BEE3F8", "color": "#333", "border": "2px solid #222138"}, "type": "input", "draggable": true, "autoMove": true, "out": ["2"]}, {"id": "2", "data": {"label": "Fraud Check", "ifstatement": "\"a\" == \"a\"", "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"}, "position": {"x": 222, "y": 100}, "type": "decision", "draggable": true, "autoMove": true, "out": ["2c", "2a"]}, {"id": "2a", "data": {"label": "Manual Approval", "code": "  var outputPort = 0;\n  return { obj, outputPort };"}, "position": {"x": 434, "y": 200}, "type": "decision", "draggable": true, "autoMove": true, "out": ["2c", "10a"]}, {"id": "4c", "data": {"label": "Cancel Order \u26d4"}, "position": {"x": 400, "y": 700}, "style": {"background": "#FEB2B2", "color": "#333", "border": "2px solid #222138"}, "type": "output", "draggable": true, "autoMove": true, "out": []}, {"id": "2c", "data": {"label": "Find All Locations with Complete Inventory", "code": "  var outputPort = 0;\n  return { obj, outputPort };", "leftNodeName": "None", "rightNodeName": ">0"}, "position": {"x": 111, "y": 300}, "type": "decision", "draggable": true, "autoMove": true, "out": ["3c", "2d"]}, {"id": "3c", "data": {"label": "Split Shipment \u2190 \u2192  based on Lowest Cost"}, "position": {"x": 0, "y": 500}, "type": "default", "draggable": true, "autoMove": true, "out": ["4b"]}, {"id": "4a", "data": {"label": "Problem Order \u26a0\ufe0f"}, "position": {"x": 200, "y": 700}, "style": {"background": "white", "color": "#333", "border": "2px solid #222138"}, "type": "output", "draggable": true, "autoMove": true, "out": []}, {"id": "2d", "data": {"label": "Sort Locations by Distance"}, "position": {"x": 222, "y": 400}, "draggable": true, "autoMove": true, "out": ["3b"]}, {"id": "3b", "data": {"label": "Select Lowest Cost Shipping"}, "position": {"x": 222, "y": 500}, "draggable": true, "autoMove": true, "out": ["4b"]}, {"id": "4b", "data": {"label": "Ship \ud83d\udce6"}, "position": {"x": 0, "y": 700}, "style": {"background": "#C6F6D5", "color": "#333", "border": "2px solid #222138"}, "type": "output", "draggable": true, "autoMove": true, "out": []}, {"id": "10a", "data": {"label": "Notify Customer"}, "position": {"x": 444, "y": 500}, "type": "notification", "draggable": true, "autoMove": true, "out": ["4c"]}, {"id": "comment-1", "data": {"label": "At this point the workflow waits on the third party system"}, "position": {"x": 28.626315789473665, "y": 117.22631578947369}, "style": {}, "type": "comment", "draggable": true, "autoMove": false, "out": []}]');
INSERT INTO langflow."Workflows" (id, "tenantId", name, "createdAt", "updatedAt", style, description, uuid, data) VALUES (10, '1', '我复制的New Order Workflow', '2023-07-12 22:05:25.297827+08', '2023-07-13 19:16:00.939427+08', NULL, 'New Order Workflow', '39b477cc-878b-461d-9ddb-f534c728abc3', '[{"id": "1", "data": {"label": "\ud83d\uded2 New Order"}, "position": {"x": 222, "y": 0}, "style": {"background": "#BEE3F8", "color": "#333", "border": "2px solid #222138"}, "type": "input", "draggable": true, "autoMove": true, "out": ["2"]}, {"id": "2", "data": {"label": "Fraud Check", "ifstatement": "\"a\" == \"a\"", "code": "outputPort = 0;\n if ({{{ifstatement}}}) { outputPort = 1 } else { outputPort = 0 };\n return {obj, outputPort};"}, "position": {"x": 222, "y": 100}, "type": "decision", "draggable": true, "autoMove": true, "out": ["2c", "2a"]}, {"id": "2a", "data": {"label": "Manual Approval", "code": "  var outputPort = 0;\n  return { obj, outputPort };"}, "position": {"x": 425.7242078580482, "y": 261.0339670468948}, "type": "decision", "draggable": true, "autoMove": true, "out": ["2c", "10a"]}, {"id": "4c", "data": {"label": "Cancel Order \u26d4"}, "position": {"x": 400, "y": 700}, "style": {"background": "#FEB2B2", "color": "#333", "border": "2px solid #222138"}, "type": "output", "draggable": true, "autoMove": true, "out": []}, {"id": "2c", "data": {"label": "Find All Locations with Complete Inventory", "code": "  var outputPort = 0;\n  return { obj, outputPort };", "leftNodeName": "None", "rightNodeName": ">0"}, "position": {"x": 82.03472750316843, "y": 255.51761723700884}, "type": "decision", "draggable": true, "autoMove": true, "out": ["3c", "2d"]}, {"id": "3c", "data": {"label": "Split Shipment \u2190 \u2192  based on Lowest Cost"}, "position": {"x": 0, "y": 500}, "type": "default", "draggable": true, "autoMove": true, "out": ["4b"]}, {"id": "4a", "data": {"label": "Problem Order \u26a0\ufe0f"}, "position": {"x": 200, "y": 700}, "style": {"background": "white", "color": "#333", "border": "2px solid #222138"}, "type": "output", "draggable": true, "autoMove": true, "out": []}, {"id": "2d", "data": {"label": "Sort Locations by Distance"}, "position": {"x": 190.96577946768053, "y": 418.62053231939166}, "draggable": true, "autoMove": true, "out": ["3b"]}, {"id": "3b", "data": {"label": "Select Lowest Cost Shipping"}, "position": {"x": 190.9657794676806, "y": 529.9997465145755}, "draggable": true, "autoMove": true, "out": ["4b"]}, {"id": "4b", "data": {"label": "Ship \ud83d\udce6"}, "position": {"x": 0, "y": 700}, "style": {"background": "#C6F6D5", "color": "#333", "border": "2px solid #222138"}, "type": "output", "draggable": true, "autoMove": true, "out": []}, {"id": "10a", "data": {"label": "Notify Customer"}, "position": {"x": 444, "y": 500}, "type": "notification", "draggable": true, "autoMove": true, "out": ["4c"]}, {"id": "comment-1", "data": {"label": "At this point the workflow waits on the third party system"}, "position": {"x": -151.37216329797883, "y": 111.01947168300978}, "style": {}, "type": "comment", "draggable": true, "autoMove": false, "out": []}, {"id": "5fe73d74-ea13-4c3b-9c81-dee00f805182", "data": {"label": "notification", "code": "console.log(''hello world'');"}, "position": {"x": -314.12808746008363, "y": 247.92754010279333}, "style": {}, "type": "notification", "draggable": true, "autoMove": false, "out": []}]');


--
-- TOC entry 2878 (class 0 OID 1229980)
-- Dependencies: 210
-- Data for Name: flow; Type: TABLE DATA; Schema: langflow; Owner: -
--

INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 611, "id": "ChatOpenAI-xlqPH", "type": "genericNode", "position": {"x": 269.0350916065154, "y": 462.06723428323335}, "data": {"type": "ChatOpenAI", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "Any", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "max_tokens", "advanced": false, "type": "int", "list": false, "value": "2048"}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "gpt-3.5-turbo", "password": false, "options": ["gpt-3.5-turbo-0613", "gpt-3.5-turbo", "gpt-3.5-turbo-16k-0613", "gpt-3.5-turbo-16k", "gpt-4-0613", "gpt-4-32k-0613", "gpt-4", "gpt-4-32k"], "name": "model_name", "advanced": false, "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "type": "str", "list": false, "value": "http://172.16.29.92:5001/v1"}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "EMPTY", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "type": "str", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "type": "float", "list": false, "value": 60}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "type": "bool", "list": false}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "type": "float", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": false, "type": "bool", "list": false}, "_type": "ChatOpenAI"}, "description": "Wrapper around OpenAI Chat large language models.", "base_classes": ["BaseLanguageModel", "BaseChatModel", "ChatOpenAI"], "display_name": "ChatOpenAI"}, "id": "ChatOpenAI-xlqPH", "value": null}, "selected": false, "dragging": false, "positionAbsolute": {"x": 269.0350916065154, "y": 462.06723428323335}}, {"width": 384, "height": 287, "id": "ConversationChain-qohNp", "type": "genericNode", "position": {"x": 806, "y": 554}, "data": {"type": "ConversationChain", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "advanced": false, "type": "BaseLanguageModel", "list": false}, "memory": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "memory", "advanced": false, "type": "BaseMemory", "list": false}, "prompt": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": {"input_variables": ["history", "input"], "output_parser": null, "partial_variables": {}, "template": "The following is a friendly conversation between a human and an AI. The AI is talkative and provides lots of specific details from its context. If the AI does not know the answer to a question, it truthfully says it does not know.\n\nCurrent conversation:\n{history}\nHuman: {input}\nAI:", "template_format": "f-string", "validate_template": true, "_type": "prompt"}, "password": false, "name": "prompt", "advanced": false, "type": "BasePromptTemplate", "list": false}, "input_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "input", "password": false, "name": "input_key", "advanced": true, "type": "str", "list": false}, "output_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "response", "password": false, "name": "output_key", "advanced": true, "type": "str", "list": false}, "verbose": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "verbose", "advanced": true, "type": "bool", "list": false}, "_type": "ConversationChain"}, "description": "Chain to have a conversation and load context from memory.", "base_classes": ["ConversationChain", "LLMChain", "Chain", "function"], "display_name": "ConversationChain"}, "id": "ConversationChain-qohNp", "value": null}, "selected": false, "dragging": false, "positionAbsolute": {"x": 806, "y": 554}}], "edges": [{"source": "ChatOpenAI-xlqPH", "sourceHandle": "ChatOpenAI|ChatOpenAI-xlqPH|BaseLanguageModel|BaseChatModel|ChatOpenAI", "target": "ConversationChain-qohNp", "targetHandle": "BaseLanguageModel|llm|ConversationChain-qohNp", "className": "", "id": "reactflow__edge-ChatOpenAI-xlqPHChatOpenAI|ChatOpenAI-xlqPH|BaseChatModel|BaseLanguageModel|ChatOpenAI-ConversationChain-qohNpBaseLanguageModel|llm|ConversationChain-qohNp", "style": {"stroke": "#555555"}, "animated": false, "selected": false}], "viewport": {"x": -100.69105554621748, "y": -433.38395439812484, "zoom": 1.185519015780163}}', 'Basic Chat', 'Simplest possible chat model', '41cc88d7-fa19-4e5c-95ab-c363b80f8f0c');
INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 611, "id": "ChatOpenAI-taUwz", "type": "genericNode", "position": {"x": 98.35202667082615, "y": -40.997365184203815}, "data": {"type": "ChatOpenAI", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "Any", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "max_tokens", "advanced": false, "type": "int", "list": false}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "gpt-3.5-turbo", "password": false, "options": ["gpt-3.5-turbo-0613", "gpt-3.5-turbo", "gpt-3.5-turbo-16k-0613", "gpt-3.5-turbo-16k", "gpt-4-0613", "gpt-4-32k-0613", "gpt-4", "gpt-4-32k"], "name": "model_name", "advanced": false, "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "type": "str", "list": false, "value": "http://172.16.29.92:5001/v1"}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "EMPTY", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "type": "str", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "type": "float", "list": false, "value": 60}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "type": "bool", "list": false}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "type": "float", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": false, "type": "bool", "list": false}, "_type": "ChatOpenAI"}, "description": "Wrapper around OpenAI Chat large language models.", "base_classes": ["BaseLanguageModel", "BaseChatModel", "ChatOpenAI"], "display_name": "ChatOpenAI"}, "id": "ChatOpenAI-taUwz", "value": null}, "selected": false, "dragging": false, "positionAbsolute": {"x": 98.35202667082615, "y": -40.997365184203815}}, {"width": 384, "height": 307, "id": "LLMChain-hnuZj", "type": "genericNode", "position": {"x": 1371.327165654482, "y": 583.8506395511879}, "data": {"type": "LLMChain", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "advanced": false, "type": "BaseLanguageModel", "list": false}, "memory": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "memory", "advanced": false, "type": "BaseMemory", "list": false}, "prompt": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "prompt", "advanced": false, "type": "BasePromptTemplate", "list": false}, "output_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "text", "password": false, "name": "output_key", "advanced": true, "type": "str", "list": false}, "verbose": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": true, "type": "bool", "list": false}, "_type": "LLMChain"}, "description": "Chain to run queries against LLMs.", "base_classes": ["LLMChain", "Chain", "function"], "display_name": "LLMChain"}, "id": "LLMChain-hnuZj", "value": null}, "selected": false, "positionAbsolute": {"x": 1371.327165654482, "y": 583.8506395511879}, "dragging": false}, {"width": 384, "height": 265, "id": "PromptTemplate-dmc9s", "type": "genericNode", "position": {"x": 90.26252120445122, "y": 1148.3542215255002}, "data": {"type": "PromptTemplate", "node": {"template": {"output_parser": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "output_parser", "advanced": false, "type": "BaseOutputParser", "list": false}, "input_variables": {"required": true, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "input_variables", "advanced": false, "type": "str", "list": true}, "partial_variables": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "partial_variables", "advanced": false, "type": "code", "list": false}, "template": {"required": true, "placeholder": "", "show": true, "multiline": true, "password": false, "name": "template", "advanced": false, "type": "prompt", "list": false, "value": "The following is a friendly conversation between a human and an AI. The AI is talkative and provides lots of specific details from its context. If the AI does not know the answer to a question, it truthfully says it does not know.\n\nCurrent conversation:\n\n{history}\n<human>: {text}\n<bot>:"}, "template_format": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "f-string", "password": false, "name": "template_format", "advanced": false, "type": "str", "list": false}, "validate_template": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": true, "password": false, "name": "validate_template", "advanced": false, "type": "bool", "list": false}, "_type": "PromptTemplate"}, "description": "Schema to represent a prompt for an LLM.", "base_classes": ["PromptTemplate", "BasePromptTemplate", "StringPromptTemplate"], "display_name": "PromptTemplate"}, "id": "PromptTemplate-dmc9s", "value": null}, "selected": false, "dragging": false, "positionAbsolute": {"x": 90.26252120445122, "y": 1148.3542215255002}}, {"width": 384, "height": 520, "id": "ConversationBufferMemory-izH9p", "type": "genericNode", "position": {"x": 96.25743928330598, "y": 598.3955884904548}, "data": {"type": "ConversationBufferMemory", "node": {"template": {"chat_memory": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "chat_memory", "advanced": false, "type": "BaseChatMessageHistory", "list": false}, "ai_prefix": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "AI", "password": false, "name": "ai_prefix", "advanced": false, "type": "str", "list": false}, "human_prefix": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "Human", "password": false, "name": "human_prefix", "advanced": false, "type": "str", "list": false}, "input_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": false, "name": "input_key", "advanced": false, "type": "str", "list": false}, "memory_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "history", "password": false, "name": "memory_key", "advanced": false, "type": "str", "list": false}, "output_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": false, "name": "output_key", "advanced": false, "type": "str", "list": false}, "return_messages": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "return_messages", "advanced": false, "type": "bool", "list": false}, "_type": "ConversationBufferMemory"}, "description": "Buffer for storing conversation memory.", "base_classes": ["BaseChatMemory", "BaseMemory", "ConversationBufferMemory"], "display_name": "ConversationBufferMemory"}, "id": "ConversationBufferMemory-izH9p", "value": null}, "selected": false, "positionAbsolute": {"x": 96.25743928330598, "y": 598.3955884904548}, "dragging": false}], "edges": [{"source": "ChatOpenAI-taUwz", "sourceHandle": "ChatOpenAI|ChatOpenAI-taUwz|BaseLanguageModel|BaseChatModel|ChatOpenAI", "target": "LLMChain-hnuZj", "targetHandle": "BaseLanguageModel|llm|LLMChain-hnuZj", "className": "", "id": "reactflow__edge-ChatOpenAI-taUwzChatOpenAI|ChatOpenAI-taUwz|BaseChatModel|BaseLanguageModel|ChatOpenAI-LLMChain-hnuZjBaseLanguageModel|llm|LLMChain-hnuZj", "selected": false, "style": {"stroke": "#555555"}, "animated": false}, {"source": "PromptTemplate-dmc9s", "sourceHandle": "PromptTemplate|PromptTemplate-dmc9s|PromptTemplate|BasePromptTemplate|StringPromptTemplate", "target": "LLMChain-hnuZj", "targetHandle": "BasePromptTemplate|prompt|LLMChain-hnuZj", "className": "", "id": "reactflow__edge-PromptTemplate-dmc9sPromptTemplate|PromptTemplate-dmc9s|StringPromptTemplate|PromptTemplate|BasePromptTemplate-LLMChain-hnuZjBasePromptTemplate|prompt|LLMChain-hnuZj", "style": {"stroke": "#555555"}, "animated": false, "selected": false}, {"source": "ConversationBufferMemory-izH9p", "sourceHandle": "ConversationBufferMemory|ConversationBufferMemory-izH9p|BaseChatMemory|BaseMemory|ConversationBufferMemory", "target": "LLMChain-hnuZj", "targetHandle": "BaseMemory|memory|LLMChain-hnuZj", "className": "", "id": "reactflow__edge-ConversationBufferMemory-izH9pConversationBufferMemory|ConversationBufferMemory-izH9p|BaseChatMemory|BaseMemory|ConversationBufferMemory-LLMChain-hnuZjBaseMemory|memory|LLMChain-hnuZj", "style": {"stroke": "#555555"}, "animated": false, "selected": false}], "viewport": {"x": 73.69611053685082, "y": -235.80488141399894, "zoom": 0.8667190710459165}}', 'Basic Chat with Prompt and History', 'A simple chat with a custom prompt template and conversational memory buffer', 'c389da4b-8a0a-46a5-9dfa-70e684fe5c39');
INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 227, "id": "JsonToolkit-ElSfz", "type": "genericNode", "position": {"x": 1187.2084622072437, "y": 116.13738146259979}, "data": {"type": "JsonToolkit", "node": {"template": {"spec": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "spec", "advanced": false, "type": "JsonSpec", "list": false}, "_type": "JsonToolkit"}, "description": "Toolkit for interacting with a JSON spec.", "base_classes": ["BaseToolkit", "JsonToolkit", "Tool"], "display_name": "JsonToolkit"}, "id": "JsonToolkit-ElSfz", "value": null}, "selected": false, "positionAbsolute": {"x": 1187.2084622072437, "y": 116.13738146259979}, "dragging": false}, {"width": 384, "height": 267, "id": "JsonAgent-qBV86", "type": "genericNode", "position": {"x": 1659.6395547893094, "y": 397.52506741326164}, "data": {"type": "JsonAgent", "node": {"template": {"llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "display_name": "LLM", "advanced": false, "type": "BaseLanguageModel", "list": false}, "toolkit": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "toolkit", "advanced": false, "type": "BaseToolkit", "list": false}, "_type": "json_agent"}, "description": "Construct a json agent from an LLM and tools.", "base_classes": ["AgentExecutor"], "display_name": "JsonAgent"}, "id": "JsonAgent-qBV86", "value": null}, "selected": false, "positionAbsolute": {"x": 1659.6395547893094, "y": 397.52506741326164}, "dragging": false}, {"width": 384, "height": 611, "id": "OpenAI-s2OUC", "type": "genericNode", "position": {"x": 664.5046837368179, "y": 351.4165918614485}, "data": {"type": "OpenAI", "node": {"template": {"allowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": [], "password": false, "name": "allowed_special", "advanced": false, "type": "Literal''all''", "list": true}, "callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "disallowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "all", "password": false, "name": "disallowed_special", "advanced": false, "type": "Literal''all''", "list": false}, "batch_size": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 20, "password": false, "name": "batch_size", "advanced": false, "type": "int", "list": false}, "best_of": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "best_of", "advanced": false, "type": "int", "list": false}, "cache": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "cache", "advanced": false, "type": "bool", "list": false}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "Any", "list": false}, "frequency_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "frequency_penalty", "advanced": false, "type": "float", "list": false}, "logit_bias": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "logit_bias", "advanced": false, "type": "code", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 256, "password": true, "name": "max_tokens", "advanced": false, "type": "int", "list": false}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text-davinci-003", "password": false, "options": ["text-davinci-003", "text-davinci-002", "text-curie-001", "text-babbage-001", "text-ada-001"], "name": "model_name", "advanced": false, "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "type": "str", "list": false}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "type": "str", "list": false}, "presence_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "presence_penalty", "advanced": false, "type": "float", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "type": "float", "list": false}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "type": "bool", "list": false}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "type": "float", "list": false}, "top_p": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "top_p", "advanced": false, "type": "float", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "verbose", "advanced": false, "type": "bool", "list": false}, "_type": "OpenAI"}, "description": "Wrapper around OpenAI large language models.", "base_classes": ["BaseLLM", "BaseLanguageModel", "BaseOpenAI", "OpenAI"], "display_name": "OpenAI"}, "id": "OpenAI-s2OUC", "value": null}, "selected": true, "positionAbsolute": {"x": 664.5046837368179, "y": 351.4165918614485}, "dragging": false}, {"width": 384, "height": 331, "id": "JsonSpec-9iYGH", "type": "genericNode", "position": {"x": 644.1239078947345, "y": -74.06644565448788}, "data": {"type": "JsonSpec", "node": {"template": {"path": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "", "suffixes": [".json", ".yaml", ".yml"], "password": false, "name": "path", "advanced": false, "type": "file", "list": false, "fileTypes": ["json", "yaml", "yml"], "file_path": null}, "max_value_length": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "", "password": false, "name": "max_value_length", "advanced": false, "type": "int", "list": false}, "_type": "JsonSpec"}, "description": "", "base_classes": ["Tool", "JsonSpec"], "display_name": "JsonSpec"}, "id": "JsonSpec-9iYGH", "value": null}, "selected": false, "positionAbsolute": {"x": 644.1239078947345, "y": -74.06644565448788}, "dragging": false}], "edges": [{"source": "JsonToolkit-ElSfz", "sourceHandle": "JsonToolkit|JsonToolkit-ElSfz|BaseToolkit|JsonToolkit|Tool", "target": "JsonAgent-qBV86", "targetHandle": "BaseToolkit|toolkit|JsonAgent-qBV86", "className": "", "id": "reactflow__edge-JsonToolkit-ElSfzJsonToolkit|JsonToolkit-ElSfz|BaseToolkit|JsonToolkit|Tool-JsonAgent-qBV86BaseToolkit|toolkit|JsonAgent-qBV86", "selected": false, "style": {"stroke": "#555555"}, "animated": false}, {"source": "OpenAI-s2OUC", "sourceHandle": "OpenAI|OpenAI-s2OUC|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI", "target": "JsonAgent-qBV86", "targetHandle": "BaseLanguageModel|llm|JsonAgent-qBV86", "className": "", "id": "reactflow__edge-OpenAI-s2OUCOpenAI|OpenAI-s2OUC|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI-JsonAgent-qBV86BaseLanguageModel|llm|JsonAgent-qBV86", "selected": false, "style": {"stroke": "#555555"}, "animated": false}, {"source": "JsonSpec-9iYGH", "sourceHandle": "JsonSpec|JsonSpec-9iYGH|Tool|JsonSpec", "target": "JsonToolkit-ElSfz", "targetHandle": "JsonSpec|spec|JsonToolkit-ElSfz", "style": {"stroke": "#555555"}, "animated": false, "id": "reactflow__edge-JsonSpec-9iYGHJsonSpec|JsonSpec-9iYGH|Tool|JsonSpec-JsonToolkit-ElSfzJsonSpec|spec|JsonToolkit-ElSfz", "selected": false, "className": ""}], "viewport": {"x": -212.6640615606127, "y": 103.9029873034608, "zoom": 0.8253435073136858}}', 'JSON Agent', 'Query an API spec to get information about the endpoints, parameters, and responses.', '92077b9f-b275-4f75-b7a2-10a658dce867');
INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 399, "id": "VectorStoreInfo-2OG6C", "type": "genericNode", "position": {"x": 1535.1653139781452, "y": 232.33751183505882}, "data": {"type": "VectorStoreInfo", "node": {"template": {"vectorstore": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "vectorstore", "advanced": false, "type": "VectorStore", "list": false}, "description": {"required": true, "placeholder": "", "show": true, "multiline": true, "password": false, "name": "description", "advanced": false, "type": "str", "list": false}, "name": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "name", "advanced": false, "type": "str", "list": false}, "_type": "VectorStoreInfo"}, "description": "Information about a vectorstore.", "base_classes": ["VectorStoreInfo"], "display_name": "VectorStoreInfo"}, "id": "VectorStoreInfo-2OG6C", "value": null}, "selected": false, "positionAbsolute": {"x": 1535.1653139781452, "y": 232.33751183505882}, "dragging": false}, {"width": 384, "height": 267, "id": "VectorStoreAgent-bWMfj", "type": "genericNode", "position": {"x": 2008.370545823368, "y": 328.41251345211936}, "data": {"type": "VectorStoreAgent", "node": {"template": {"llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "display_name": "LLM", "advanced": false, "type": "BaseLanguageModel", "list": false}, "vectorstoreinfo": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "vectorstoreinfo", "display_name": "Vector Store Info", "advanced": false, "type": "VectorStoreInfo", "list": false}, "_type": "vectorstore_agent"}, "description": "Construct an agent from a Vector Store.", "base_classes": ["AgentExecutor"], "display_name": "VectorStoreAgent"}, "id": "VectorStoreAgent-bWMfj", "value": null}, "selected": false, "positionAbsolute": {"x": 2008.370545823368, "y": 328.41251345211936}, "dragging": false}, {"width": 384, "height": 611, "id": "OpenAI-CL150", "type": "genericNode", "position": {"x": 1536.5992692261616, "y": 671.127817727902}, "data": {"type": "OpenAI", "node": {"template": {"allowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": [], "password": false, "name": "allowed_special", "advanced": false, "type": "Literal''all''", "list": true}, "callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "disallowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "all", "password": false, "name": "disallowed_special", "advanced": false, "type": "Literal''all''", "list": false}, "batch_size": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 20, "password": false, "name": "batch_size", "advanced": false, "type": "int", "list": false}, "best_of": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "best_of", "advanced": false, "type": "int", "list": false}, "cache": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "cache", "advanced": false, "type": "bool", "list": false}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "Any", "list": false}, "frequency_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "frequency_penalty", "advanced": false, "type": "float", "list": false}, "logit_bias": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "logit_bias", "advanced": false, "type": "code", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 256, "password": true, "name": "max_tokens", "advanced": false, "type": "int", "list": false}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text-davinci-003", "password": false, "options": ["text-davinci-003", "text-davinci-002", "text-curie-001", "text-babbage-001", "text-ada-001"], "name": "model_name", "advanced": false, "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "type": "str", "list": false}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "type": "str", "list": false}, "presence_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "presence_penalty", "advanced": false, "type": "float", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "type": "float", "list": false}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "type": "bool", "list": false}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "type": "float", "list": false}, "top_p": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "top_p", "advanced": false, "type": "float", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "verbose", "advanced": false, "type": "bool", "list": false}, "_type": "OpenAI"}, "description": "Wrapper around OpenAI large language models.", "base_classes": ["BaseLLM", "BaseLanguageModel", "BaseOpenAI", "OpenAI"], "display_name": "OpenAI"}, "id": "OpenAI-CL150", "value": null}, "selected": false, "positionAbsolute": {"x": 1536.5992692261616, "y": 671.127817727902}, "dragging": false}, {"width": 384, "height": 343, "id": "PyPDFLoader-haMRI", "type": "genericNode", "position": {"x": 203.0208885714419, "y": 309.77109522791375}, "data": {"type": "PyPDFLoader", "node": {"template": {"file_path": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "", "suffixes": [".pdf"], "fileTypes": ["pdf"], "password": false, "name": "file_path", "advanced": false, "type": "file", "list": false, "file_path": null}, "metadata": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "{}", "password": false, "name": "metadata", "display_name": "Metadata", "advanced": false, "type": "code", "list": false}, "_type": "PyPDFLoader"}, "description": "Loads a PDF with pypdf and chunks at character level.", "base_classes": ["BaseLoader", "PyPDFLoader", "BasePDFLoader"], "display_name": "PyPDFLoader"}, "id": "PyPDFLoader-haMRI", "value": null}, "selected": false, "positionAbsolute": {"x": 203.0208885714419, "y": 309.77109522791375}, "dragging": false}, {"width": 384, "height": 505, "id": "CharacterTextSplitter-wGvuf", "type": "genericNode", "position": {"x": 634.6414182242057, "y": 265.318482539423}, "data": {"type": "CharacterTextSplitter", "node": {"template": {"documents": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "documents", "advanced": false, "type": "BaseLoader", "list": false}, "chunk_overlap": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": 200, "password": false, "name": "chunk_overlap", "display_name": "Chunk Overlap", "advanced": false, "type": "int", "list": false}, "chunk_size": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": 4000, "password": false, "name": "chunk_size", "display_name": "Chunk Size", "advanced": false, "type": "int", "list": false}, "separator": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": ".", "password": false, "name": "separator", "display_name": "Separator", "advanced": false, "type": "str", "list": false}, "_type": "CharacterTextSplitter"}, "description": "Implementation of splitting text that looks at characters.", "base_classes": ["BaseDocumentTransformer", "TextSplitter", "CharacterTextSplitter"], "display_name": "CharacterTextSplitter"}, "id": "CharacterTextSplitter-wGvuf", "value": null}, "selected": false, "positionAbsolute": {"x": 634.6414182242057, "y": 265.318482539423}, "dragging": false}, {"width": 384, "height": 273, "id": "OpenAIEmbeddings-AAJ5d", "type": "genericNode", "position": {"x": 663.3205231845225, "y": 846.070357985833}, "data": {"type": "OpenAIEmbeddings", "node": {"template": {"allowed_special": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": [], "password": false, "name": "allowed_special", "advanced": true, "type": "Literal''all''", "list": true}, "disallowed_special": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "all", "password": false, "name": "disallowed_special", "advanced": true, "type": "Literal''all''", "list": true}, "chunk_size": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 1000, "password": false, "name": "chunk_size", "advanced": true, "type": "int", "list": false}, "client": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "client", "advanced": true, "type": "Any", "list": false}, "deployment": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text-embedding-ada-002", "password": false, "name": "deployment", "advanced": true, "type": "str", "list": false}, "embedding_ctx_length": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 8191, "password": false, "name": "embedding_ctx_length", "advanced": true, "type": "int", "list": false}, "headers": {"required": false, "placeholder": "", "show": false, "multiline": true, "value": "{''Authorization'':\n            ''Bearer <token>''}", "password": false, "name": "headers", "advanced": true, "type": "Any", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": true, "type": "int", "list": false}, "model": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text-embedding-ada-002", "password": false, "name": "model", "advanced": true, "type": "str", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": true, "type": "str", "list": false}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_api_type": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "openai_api_type", "display_name": "OpenAI API Type", "advanced": true, "type": "str", "list": false}, "openai_api_version": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "openai_api_version", "display_name": "OpenAI API Version", "advanced": true, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": true, "type": "str", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "request_timeout", "advanced": true, "type": "float", "list": false}, "_type": "OpenAIEmbeddings"}, "description": "Wrapper around OpenAI embedding models.", "base_classes": ["Embeddings", "OpenAIEmbeddings"], "display_name": "OpenAIEmbeddings"}, "id": "OpenAIEmbeddings-AAJ5d", "value": null}, "selected": false, "positionAbsolute": {"x": 663.3205231845225, "y": 846.070357985833}, "dragging": false}, {"width": 384, "height": 514, "id": "Chroma-x5liG", "type": "genericNode", "position": {"x": 1100.6768738293495, "y": 308.3371399798977}, "data": {"type": "Chroma", "node": {"template": {"client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "chromadb.Client", "list": false}, "client_settings": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client_settings", "advanced": false, "type": "chromadb.config.Setting", "list": true}, "documents": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "documents", "display_name": "Documents", "advanced": false, "type": "TextSplitter", "list": true}, "embedding": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "embedding", "display_name": "Embedding", "advanced": false, "type": "Embeddings", "list": false}, "collection_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "langchain", "password": false, "name": "collection_name", "advanced": false, "type": "str", "list": false}, "ids": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "ids", "advanced": false, "type": "str", "list": true}, "kwargs": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "kwargs", "advanced": true, "type": "Any", "list": false}, "metadatas": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "metadatas", "advanced": false, "type": "code", "list": true}, "persist": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": true, "password": false, "name": "persist", "display_name": "Persist", "advanced": false, "type": "bool", "list": false}, "persist_directory": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "persist_directory", "advanced": false, "type": "str", "list": false}, "search_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "{}", "password": false, "name": "search_kwargs", "advanced": true, "type": "code", "list": false}, "_type": "Chroma"}, "description": "Create a Chroma vectorstore from a raw documents.", "base_classes": ["VectorStore", "Chroma", "BaseRetriever"], "display_name": "Chroma"}, "id": "Chroma-x5liG", "value": null}, "selected": false, "positionAbsolute": {"x": 1100.6768738293495, "y": 308.3371399798977}, "dragging": false}], "edges": [{"source": "VectorStoreInfo-2OG6C", "sourceHandle": "VectorStoreInfo|VectorStoreInfo-2OG6C|VectorStoreInfo", "target": "VectorStoreAgent-bWMfj", "targetHandle": "VectorStoreInfo|vectorstoreinfo|VectorStoreAgent-bWMfj", "className": "", "id": "reactflow__edge-VectorStoreInfo-2OG6CVectorStoreInfo|VectorStoreInfo-2OG6C|VectorStoreInfo-VectorStoreAgent-bWMfjVectorStoreInfo|vectorstoreinfo|VectorStoreAgent-bWMfj", "selected": false, "style": {"stroke": "#555555"}, "animated": false}, {"source": "OpenAI-CL150", "sourceHandle": "OpenAI|OpenAI-CL150|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI", "target": "VectorStoreAgent-bWMfj", "targetHandle": "BaseLanguageModel|llm|VectorStoreAgent-bWMfj", "className": "", "id": "reactflow__edge-OpenAI-CL150OpenAI|OpenAI-CL150|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI-VectorStoreAgent-bWMfjBaseLanguageModel|llm|VectorStoreAgent-bWMfj", "selected": false, "style": {"stroke": "#555555"}, "animated": false}, {"source": "PyPDFLoader-haMRI", "sourceHandle": "PyPDFLoader|PyPDFLoader-haMRI|BaseLoader|PyPDFLoader|BasePDFLoader", "target": "CharacterTextSplitter-wGvuf", "targetHandle": "BaseLoader|documents|CharacterTextSplitter-wGvuf", "style": {"stroke": "#555555"}, "animated": false, "id": "reactflow__edge-PyPDFLoader-haMRIPyPDFLoader|PyPDFLoader-haMRI|BaseLoader|PyPDFLoader|BasePDFLoader-CharacterTextSplitter-wGvufBaseLoader|documents|CharacterTextSplitter-wGvuf", "selected": false, "className": ""}, {"source": "CharacterTextSplitter-wGvuf", "sourceHandle": "CharacterTextSplitter|CharacterTextSplitter-wGvuf|BaseDocumentTransformer|TextSplitter|CharacterTextSplitter", "target": "Chroma-x5liG", "targetHandle": "TextSplitter|documents|Chroma-x5liG", "style": {"stroke": "#555555"}, "animated": false, "id": "reactflow__edge-CharacterTextSplitter-wGvufCharacterTextSplitter|CharacterTextSplitter-wGvuf|BaseDocumentTransformer|TextSplitter|CharacterTextSplitter-Chroma-x5liGTextSplitter|documents|Chroma-x5liG", "className": ""}, {"source": "OpenAIEmbeddings-AAJ5d", "sourceHandle": "OpenAIEmbeddings|OpenAIEmbeddings-AAJ5d|Embeddings|OpenAIEmbeddings", "target": "Chroma-x5liG", "targetHandle": "Embeddings|embedding|Chroma-x5liG", "style": {"stroke": "#555555"}, "animated": false, "id": "reactflow__edge-OpenAIEmbeddings-AAJ5dOpenAIEmbeddings|OpenAIEmbeddings-AAJ5d|Embeddings|OpenAIEmbeddings-Chroma-x5liGEmbeddings|embedding|Chroma-x5liG", "className": ""}, {"source": "Chroma-x5liG", "sourceHandle": "Chroma|Chroma-x5liG|VectorStore|Chroma|BaseRetriever", "target": "VectorStoreInfo-2OG6C", "targetHandle": "VectorStore|vectorstore|VectorStoreInfo-2OG6C", "style": {"stroke": "#555555"}, "animated": false, "id": "reactflow__edge-Chroma-x5liGChroma|Chroma-x5liG|VectorStore|Chroma|BaseRetriever-VectorStoreInfo-2OG6CVectorStore|vectorstore|VectorStoreInfo-2OG6C", "className": ""}], "viewport": {"x": -69.65175745240549, "y": -93.26981150790402, "zoom": 0.7445133282392076}}', 'PDF Loader', 'Load a PDF and start asking questions about it.', 'c6982008-0f0b-40db-a81d-63d79b1874b1');
INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 313, "id": "SQLAgent-VK7eF", "type": "genericNode", "position": {"x": 442.08809451744196, "y": -123.39733174414528}, "data": {"type": "SQLAgent", "node": {"template": {"llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "display_name": "LLM", "advanced": false, "type": "BaseLanguageModel", "list": false}, "database_uri": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "", "password": false, "name": "database_uri", "advanced": false, "type": "str", "list": false}, "_type": "sql_agent"}, "description": "Construct an SQL agent from an LLM and tools.", "base_classes": ["AgentExecutor"], "display_name": "SQLAgent"}, "id": "SQLAgent-VK7eF", "value": null}, "selected": false, "positionAbsolute": {"x": 442.08809451744196, "y": -123.39733174414528}, "dragging": false}, {"width": 384, "height": 387, "id": "SQLDatabaseChain-FZHVP", "type": "genericNode", "position": {"x": 1763.792277556177, "y": 140.30412278113894}, "data": {"type": "SQLDatabaseChain", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "database": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "database", "advanced": false, "type": "SQLDatabase", "list": false}, "llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "advanced": false, "type": "BaseLanguageModel", "list": false}, "llm_chain": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm_chain", "advanced": false, "type": "LLMChain", "list": false}, "memory": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "memory", "advanced": false, "type": "BaseMemory", "list": false}, "prompt": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "prompt", "advanced": false, "type": "BasePromptTemplate", "list": false}, "query_checker_prompt": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "query_checker_prompt", "advanced": false, "type": "BasePromptTemplate", "list": false}, "input_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "query", "password": false, "name": "input_key", "advanced": true, "type": "str", "list": false}, "output_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "result", "password": false, "name": "output_key", "advanced": true, "type": "str", "list": false}, "return_direct": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "return_direct", "advanced": false, "type": "bool", "list": false}, "return_intermediate_steps": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "return_intermediate_steps", "advanced": false, "type": "bool", "list": false}, "top_k": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 5, "password": false, "name": "top_k", "advanced": false, "type": "int", "list": false}, "use_query_checker": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "use_query_checker", "advanced": false, "type": "bool", "list": false}, "verbose": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": true, "type": "bool", "list": false}, "_type": "SQLDatabaseChain"}, "description": "Chain for interacting with SQL Database.", "base_classes": ["SQLDatabaseChain", "Chain", "function"], "display_name": "SQLDatabaseChain"}, "id": "SQLDatabaseChain-FZHVP", "value": null}, "selected": false, "positionAbsolute": {"x": 1763.792277556177, "y": 140.30412278113894}, "dragging": false}, {"width": 384, "height": 611, "id": "OpenAI-kkRYs", "type": "genericNode", "position": {"x": 388.0363128032957, "y": 289.10227759219623}, "data": {"type": "OpenAI", "node": {"template": {"allowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": [], "password": false, "name": "allowed_special", "advanced": false, "type": "Literal''all''", "list": true}, "callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "disallowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "all", "password": false, "name": "disallowed_special", "advanced": false, "type": "Literal''all''", "list": false}, "batch_size": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 20, "password": false, "name": "batch_size", "advanced": false, "type": "int", "list": false}, "best_of": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "best_of", "advanced": false, "type": "int", "list": false}, "cache": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "cache", "advanced": false, "type": "bool", "list": false}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "Any", "list": false}, "frequency_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "frequency_penalty", "advanced": false, "type": "float", "list": false}, "logit_bias": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "logit_bias", "advanced": false, "type": "code", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 256, "password": true, "name": "max_tokens", "advanced": false, "type": "int", "list": false}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text-davinci-003", "password": false, "options": ["text-davinci-003", "text-davinci-002", "text-curie-001", "text-babbage-001", "text-ada-001"], "name": "model_name", "advanced": false, "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "type": "str", "list": false}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "type": "str", "list": false}, "presence_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "presence_penalty", "advanced": false, "type": "float", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "type": "float", "list": false}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "type": "bool", "list": false}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "type": "float", "list": false}, "top_p": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "top_p", "advanced": false, "type": "float", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "verbose", "advanced": false, "type": "bool", "list": false}, "_type": "OpenAI"}, "description": "Wrapper around OpenAI large language models.", "base_classes": ["BaseLLM", "BaseLanguageModel", "BaseOpenAI", "OpenAI"], "display_name": "OpenAI"}, "id": "OpenAI-kkRYs", "value": null}, "selected": false, "positionAbsolute": {"x": 388.0363128032957, "y": 289.10227759219623}, "dragging": false}, {"width": 384, "height": 265, "id": "PromptTemplate-2AL3W", "type": "genericNode", "position": {"x": 1775.7709448901126, "y": 988.1941652520054}, "data": {"type": "PromptTemplate", "node": {"template": {"output_parser": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "output_parser", "advanced": false, "type": "BaseOutputParser", "list": false}, "input_variables": {"required": true, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "input_variables", "advanced": false, "type": "str", "list": true}, "partial_variables": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "partial_variables", "advanced": false, "type": "code", "list": false}, "template": {"required": true, "placeholder": "", "show": true, "multiline": true, "password": false, "name": "template", "advanced": false, "type": "prompt", "list": false}, "template_format": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "f-string", "password": false, "name": "template_format", "advanced": false, "type": "str", "list": false}, "validate_template": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": true, "password": false, "name": "validate_template", "advanced": false, "type": "bool", "list": false}, "_type": "PromptTemplate"}, "description": "Schema to represent a prompt for an LLM.", "base_classes": ["PromptTemplate", "BasePromptTemplate", "StringPromptTemplate"], "display_name": "PromptTemplate"}, "id": "PromptTemplate-2AL3W", "value": null}, "selected": false, "positionAbsolute": {"x": 1775.7709448901126, "y": 988.1941652520054}, "dragging": false}, {"width": 384, "height": 273, "id": "SQLDatabase-kqifA", "type": "genericNode", "position": {"x": 975.6352664503677, "y": -111.15403812360985}, "data": {"type": "SQLDatabase", "node": {"template": {"uri": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "", "password": false, "name": "uri", "advanced": false, "type": "str", "list": false}, "_type": "sql_database"}, "description": "SQLAlchemy wrapper around a database.", "base_classes": ["SQLDatabase"], "display_name": "SQLDatabase"}, "id": "SQLDatabase-kqifA", "value": null}, "selected": false, "positionAbsolute": {"x": 975.6352664503677, "y": -111.15403812360985}, "dragging": false}, {"width": 384, "height": 307, "id": "LLMChain-py44m", "type": "genericNode", "position": {"x": 1050.4738936842941, "y": 928.0823536929652}, "data": {"type": "LLMChain", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "advanced": false, "type": "BaseLanguageModel", "list": false}, "memory": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "memory", "advanced": false, "type": "BaseMemory", "list": false}, "prompt": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "prompt", "advanced": false, "type": "BasePromptTemplate", "list": false}, "output_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "text", "password": false, "name": "output_key", "advanced": true, "type": "str", "list": false}, "verbose": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": true, "type": "bool", "list": false}, "_type": "LLMChain"}, "description": "Chain to run queries against LLMs.", "base_classes": ["LLMChain", "Chain", "function"], "display_name": "LLMChain"}, "id": "LLMChain-py44m", "value": null}, "selected": false, "positionAbsolute": {"x": 1050.4738936842941, "y": 928.0823536929652}, "dragging": false}], "edges": [{"source": "OpenAI-kkRYs", "sourceHandle": "OpenAI|OpenAI-kkRYs|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI", "target": "SQLDatabaseChain-FZHVP", "targetHandle": "BaseLanguageModel|llm|SQLDatabaseChain-FZHVP", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "id": "reactflow__edge-OpenAI-kkRYsOpenAI|OpenAI-kkRYs|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI-SQLDatabaseChain-FZHVPBaseLanguageModel|llm|SQLDatabaseChain-FZHVP", "selected": false}, {"source": "PromptTemplate-2AL3W", "sourceHandle": "PromptTemplate|PromptTemplate-2AL3W|PromptTemplate|BasePromptTemplate|StringPromptTemplate", "target": "SQLDatabaseChain-FZHVP", "targetHandle": "BasePromptTemplate|prompt|SQLDatabaseChain-FZHVP", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "id": "reactflow__edge-PromptTemplate-2AL3WPromptTemplate|PromptTemplate-2AL3W|PromptTemplate|BasePromptTemplate|StringPromptTemplate-SQLDatabaseChain-FZHVPBasePromptTemplate|prompt|SQLDatabaseChain-FZHVP", "selected": false}, {"source": "SQLDatabase-kqifA", "sourceHandle": "SQLDatabase|SQLDatabase-kqifA|SQLDatabase", "target": "SQLDatabaseChain-FZHVP", "targetHandle": "SQLDatabase|database|SQLDatabaseChain-FZHVP", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "id": "reactflow__edge-SQLDatabase-kqifASQLDatabase|SQLDatabase-kqifA|SQLDatabase-SQLDatabaseChain-FZHVPSQLDatabase|database|SQLDatabaseChain-FZHVP", "selected": false}, {"source": "LLMChain-py44m", "sourceHandle": "LLMChain|LLMChain-py44m|LLMChain|Chain|function", "target": "SQLDatabaseChain-FZHVP", "targetHandle": "LLMChain|llm_chain|SQLDatabaseChain-FZHVP", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "id": "reactflow__edge-LLMChain-py44mLLMChain|LLMChain-py44m|LLMChain|Chain|function-SQLDatabaseChain-FZHVPLLMChain|llm_chain|SQLDatabaseChain-FZHVP", "selected": false}], "viewport": {"x": 114.40158525159347, "y": 167.53392586407665, "zoom": 0.5879316821574907}}', 'SQL Test', 'Language Models, Unleashed.', '29c02187-d9d4-459f-8b2a-ca34ddf465e1');
INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 609, "id": "ChatOpenAI-YfL5Y", "type": "genericNode", "position": {"x": 26.08950546637493, "y": 20}, "data": {"type": "ChatOpenAI", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "cache": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "cache", "advanced": false, "type": "bool", "list": false}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "type": "Any", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "max_tokens", "advanced": false, "type": "int", "list": false, "value": ""}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "gpt-3.5-turbo", "password": false, "options": ["gpt-3.5-turbo-0613", "gpt-3.5-turbo", "gpt-3.5-turbo-16k-0613", "gpt-3.5-turbo-16k", "gpt-4-0613", "gpt-4-32k-0613", "gpt-4", "gpt-4-32k"], "name": "model_name", "advanced": false, "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "type": "str", "list": false, "value": "http://172.16.29.92:5001/v1"}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "EMPTY", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "type": "str", "list": false}, "openai_proxy": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_proxy", "display_name": "OpenAI Proxy", "advanced": false, "type": "str", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "type": "float", "list": false, "value": 60}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "type": "bool", "list": false}, "tags": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "tags", "advanced": false, "type": "str", "list": true}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "type": "float", "list": false}, "tiktoken_model_name": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "tiktoken_model_name", "advanced": false, "type": "str", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": false, "type": "bool", "list": false}, "_type": "ChatOpenAI"}, "description": "Wrapper around OpenAI Chat large language models.", "base_classes": ["BaseLanguageModel", "BaseChatModel", "Serializable", "ChatOpenAI"], "display_name": "ChatOpenAI"}, "id": "ChatOpenAI-YfL5Y", "value": null}, "selected": false, "positionAbsolute": {"x": 26.08950546637493, "y": 20}, "dragging": false}, {"width": 384, "height": 306, "id": "LLMChain-ForHN", "type": "genericNode", "position": {"x": 1299.0646444500308, "y": 644.8480047353917}, "data": {"type": "LLMChain", "node": {"template": {"callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "advanced": false, "type": "BaseLanguageModel", "list": false}, "memory": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "memory", "advanced": false, "type": "BaseMemory", "list": false}, "output_parser": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "output_parser", "advanced": false, "type": "BaseLLMOutputParser", "list": false}, "prompt": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "prompt", "advanced": false, "type": "BasePromptTemplate", "list": false}, "llm_kwargs": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "llm_kwargs", "advanced": false, "type": "code", "list": false}, "output_key": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "text", "password": false, "name": "output_key", "advanced": true, "type": "str", "list": false}, "return_final_only": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": true, "password": false, "name": "return_final_only", "advanced": false, "type": "bool", "list": false}, "tags": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "tags", "advanced": false, "type": "str", "list": true}, "verbose": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": false, "password": false, "name": "verbose", "advanced": true, "type": "bool", "list": false}, "_type": "LLMChain"}, "description": "Chain to run queries against LLMs.", "base_classes": ["Chain", "LLMChain", "Serializable", "function"], "display_name": "LLMChain"}, "id": "LLMChain-ForHN", "value": null}, "selected": false, "positionAbsolute": {"x": 1299.0646444500308, "y": 644.8480047353917}}, {"width": 384, "height": 264, "id": "PromptTemplate-jNRyk", "type": "genericNode", "position": {"x": 18, "y": 1209.351586709704}, "data": {"type": "PromptTemplate", "node": {"template": {"output_parser": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "output_parser", "advanced": false, "type": "BaseOutputParser", "list": false}, "input_variables": {"required": true, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "input_variables", "advanced": false, "type": "str", "list": true}, "partial_variables": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "partial_variables", "advanced": false, "type": "code", "list": false}, "template": {"required": true, "placeholder": "", "show": true, "multiline": true, "password": false, "name": "template", "advanced": false, "type": "prompt", "list": false, "value": "<human>:\n\u4f60\u9700\u8981\u8fdb\u884c\u533b\u7597\u6587\u672c\u7684\u5173\u7cfb\u62bd\u53d6\uff0c\u62bd\u53d6\u7684\u5173\u7cfb\u9650\u5236\u4e3a\u5728\uff1a\u5e38\u89c1\u75c7\u72b6\uff0c\u57fa\u672c\u75c5\u56e0\uff0c\u76f8\u5173\u68c0\u67e5\uff0c\u4f34\u968f\u75c7\u72b6\uff0c\u836f\u7269\u6cbb\u7597\uff0c\u624b\u672f\u6cbb\u7597\uff0c\u53d1\u75c5\u5e74\u9f84\u503e\u5411\uff0c\u591a\u53d1\u7fa4\u4f53\uff0c\u540e\u9057\u75c7\u3002\n\u4f60\u8f93\u51fa\u7684\u683c\u5f0f\u8bf7\u4f7f\u7528\uff1a\u5173\u7cfb\u540d: [\u5c3e\u5b9e\u4f53\u5217\u8868]\u3002\n\u8303\u4f8b\uff1a\n\u5f85\u62bd\u53d6\u6587\u672c\uff1a\u4e00\u4e9b\u4e34\u5e8a\u7814\u7a76\u62a5\u544a\uff0c\u7cd6\u5c3f\u75c5\u60a3\u8005\u5e38\u5b58\u5728\u660e\u663e\u7684\u9ad8\u80f0\u5c9b\u7d20\u539f\u8840\u75c7\uff0c\u80f0\u5c9b\u7d20\u539f\u81f4\u52a8\u8109\u7ca5\u6837\u786c\u5316\u7684\u5371\u9669\u6027\u663e\u8457\u9ad8\u4e8e\u80f0\u5c9b\u7d20 4\u3001\u4f4e\u5ea6\u8840\u7ba1\u708e\u75c7\uff1a IGT\u3001\u7cd6\u5c3f\u75c5\u6216IR\u72b6\u6001\u65f6\uff0c\u5e38\u5b58\u5728\u4f4e\u5ea6\u7684\u8840\u7ba1\u708e\u75c7\u53cd\u5e94\n\u8f93\u51fa: \u57fa\u672c\u75c5\u56e0:[\u4f4e\u5ea6\u8840\u7ba1\u708e\u75c7],\u5e38\u89c1\u75c7\u72b6:[\u9ad8\u80f0\u5c9b\u7d20\u539f\u8840\u75c7,\u4f4e\u5ea6\u8840\u7ba1\u708e\u75c7]\n\u5f85\u62bd\u53d6\u6587\u672c\uff1a{text}\n<bot>: \u8f93\u51fa: "}, "template_format": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "f-string", "password": false, "name": "template_format", "advanced": false, "type": "str", "list": false}, "validate_template": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": true, "password": false, "name": "validate_template", "advanced": false, "type": "bool", "list": false}, "_type": "PromptTemplate"}, "description": "Schema to represent a prompt for an LLM.", "base_classes": ["PromptTemplate", "BasePromptTemplate", "StringPromptTemplate", "Serializable"], "display_name": "PromptTemplate"}, "id": "PromptTemplate-jNRyk", "value": null}, "selected": false, "positionAbsolute": {"x": 18, "y": 1209.351586709704}}, {"width": 384, "height": 519, "id": "ConversationBufferMemory-5jSyn", "type": "genericNode", "position": {"x": 23.994918078854766, "y": 659.3929536746585}, "data": {"type": "ConversationBufferMemory", "node": {"template": {"chat_memory": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "chat_memory", "advanced": false, "type": "BaseChatMessageHistory", "list": false}, "ai_prefix": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "AI", "password": false, "name": "ai_prefix", "advanced": false, "type": "str", "list": false}, "human_prefix": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "Human", "password": false, "name": "human_prefix", "advanced": false, "type": "str", "list": false}, "input_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text", "password": false, "name": "input_key", "advanced": false, "type": "str", "list": false}, "memory_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "history", "password": false, "name": "memory_key", "advanced": false, "type": "str", "list": false}, "output_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "", "password": false, "name": "output_key", "advanced": false, "type": "str", "list": false}, "return_messages": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "return_messages", "advanced": false, "type": "bool", "list": false}, "_type": "ConversationBufferMemory"}, "description": "Buffer for storing conversation memory.", "base_classes": ["BaseMemory", "ConversationBufferMemory", "BaseChatMemory", "Serializable"], "display_name": "ConversationBufferMemory"}, "id": "ConversationBufferMemory-5jSyn", "value": null}, "selected": false, "positionAbsolute": {"x": 23.994918078854766, "y": 659.3929536746585}, "dragging": false}], "edges": [{"source": "ChatOpenAI-YfL5Y", "target": "LLMChain-ForHN", "sourceHandle": "ChatOpenAI|ChatOpenAI-YfL5Y|BaseLanguageModel|BaseChatModel|Serializable|ChatOpenAI", "targetHandle": "BaseLanguageModel|llm|LLMChain-ForHN", "id": "reactflow__edge-ChatOpenAI-YfL5YChatOpenAI|ChatOpenAI-YfL5Y|BaseLanguageModel|BaseChatModel|Serializable|ChatOpenAI-LLMChain-ForHNBaseLanguageModel|llm|LLMChain-ForHN", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "selected": false}, {"source": "PromptTemplate-jNRyk", "target": "LLMChain-ForHN", "sourceHandle": "PromptTemplate|PromptTemplate-jNRyk|PromptTemplate|BasePromptTemplate|StringPromptTemplate|Serializable", "targetHandle": "BasePromptTemplate|prompt|LLMChain-ForHN", "id": "reactflow__edge-PromptTemplate-jNRykPromptTemplate|PromptTemplate-jNRyk|PromptTemplate|BasePromptTemplate|StringPromptTemplate|Serializable-LLMChain-ForHNBasePromptTemplate|prompt|LLMChain-ForHN", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "selected": false}, {"source": "ConversationBufferMemory-5jSyn", "target": "LLMChain-ForHN", "sourceHandle": "ConversationBufferMemory|ConversationBufferMemory-5jSyn|BaseMemory|ConversationBufferMemory|BaseChatMemory|Serializable", "targetHandle": "BaseMemory|memory|LLMChain-ForHN", "id": "reactflow__edge-ConversationBufferMemory-5jSynConversationBufferMemory|ConversationBufferMemory-5jSyn|BaseMemory|ConversationBufferMemory|BaseChatMemory|Serializable-LLMChain-ForHNBaseMemory|memory|LLMChain-ForHN", "style": {"stroke": "inherit"}, "className": "stroke-gray-900 dark:stroke-gray-200", "animated": false, "selected": false}], "viewport": {"x": 97.02613971654785, "y": -223.2740265245568, "zoom": 0.9053122052596204}}', '医学文本关系抽取', '关系抽取', '3c7aaea8-37e0-440d-b971-c39ff5d49c92');
INSERT INTO langflow.flow (data, name, description, id) VALUES ('{"nodes": [{"width": 384, "height": 398, "id": "VectorStoreInfo-bHBdS", "type": "genericNode", "position": {"x": 1435.7998825491445, "y": 1134.1585405230326}, "data": {"type": "VectorStoreInfo", "node": {"template": {"vectorstore": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "vectorstore", "advanced": false, "info": "", "type": "VectorStore", "list": false}, "description": {"required": true, "placeholder": "", "show": true, "multiline": true, "password": false, "name": "description", "advanced": false, "info": "", "type": "str", "list": false, "value": "\u4eba\u624d\u5e93"}, "name": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "name", "advanced": false, "info": "", "type": "str", "list": false, "value": "pepole"}, "_type": "VectorStoreInfo"}, "description": "Information about a vectorstore.", "base_classes": ["VectorStoreInfo"], "display_name": "VectorStoreInfo", "documentation": ""}, "id": "VectorStoreInfo-bHBdS", "value": null}, "selected": false, "positionAbsolute": {"x": 1435.7998825491445, "y": 1134.1585405230326}, "dragging": false}, {"width": 384, "height": 266, "id": "VectorStoreAgent-IDwgx", "type": "genericNode", "position": {"x": 2051.772059325433, "y": 785.7150582928086}, "data": {"type": "VectorStoreAgent", "node": {"template": {"llm": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "llm", "display_name": "LLM", "advanced": false, "info": "", "type": "BaseLanguageModel", "list": false}, "vectorstoreinfo": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "vectorstoreinfo", "display_name": "Vector Store Info", "advanced": false, "info": "", "type": "VectorStoreInfo", "list": false}, "_type": "vectorstore_agent"}, "description": "Construct an agent from a Vector Store.", "base_classes": ["AgentExecutor"], "display_name": "VectorStoreAgent", "documentation": ""}, "id": "VectorStoreAgent-IDwgx", "value": null}, "selected": false, "positionAbsolute": {"x": 2051.772059325433, "y": 785.7150582928086}, "dragging": false}, {"width": 384, "height": 358, "id": "CSVLoader-MqCoK", "type": "genericNode", "position": {"x": 186.78632205895929, "y": 277.1445474813193}, "data": {"type": "CSVLoader", "node": {"template": {"file_path": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "alex.csv", "suffixes": [".csv"], "fileTypes": ["csv"], "password": false, "name": "file_path", "advanced": false, "info": "", "type": "file", "list": false, "file_path": "C:\\Users\\admin\\AppData\\Local\\langflow\\langflow\\Cache\\7198949d-8ed2-48a9-abf2-0832cf82a97b\\c0e30fd1f84a130363c8e718b253bec730f8d5654b784e950a2bb46691dcdf50"}, "encoding": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "utf-8", "password": false, "name": "encoding", "display_name": "File encoding (utf-8)", "advanced": false, "info": "", "type": "str", "list": false}, "metadata": {"required": true, "placeholder": "", "show": true, "multiline": false, "value": "{\"encoding\":\"utf-8\"}", "password": false, "name": "metadata", "display_name": "Metadata", "advanced": true, "info": "", "type": "code", "list": false}, "_type": "CSVLoader"}, "description": "Loads a CSV file into a list of documents.", "base_classes": ["Document"], "display_name": "CSVLoader", "documentation": "https://python.langchain.com/docs/modules/data_connection/document_loaders/integrations/csv"}, "id": "CSVLoader-MqCoK", "value": null}, "selected": false, "positionAbsolute": {"x": 186.78632205895929, "y": 277.1445474813193}, "dragging": false}, {"width": 384, "height": 619, "id": "OpenAI-eXfnM", "type": "genericNode", "position": {"x": 1486.1350734959847, "y": 102.72399011121513}, "data": {"type": "OpenAI", "node": {"template": {"allowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": [], "password": false, "name": "allowed_special", "advanced": false, "info": "", "type": "Literal''all''", "list": true}, "callbacks": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "callbacks", "advanced": false, "info": "", "type": "langchain.callbacks.base.BaseCallbackHandler", "list": true}, "disallowed_special": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": "all", "password": false, "name": "disallowed_special", "advanced": false, "info": "", "type": "Literal''all''", "list": false}, "batch_size": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 20, "password": false, "name": "batch_size", "advanced": false, "info": "", "type": "int", "list": false}, "best_of": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "best_of", "advanced": false, "info": "", "type": "int", "list": false}, "cache": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "cache", "advanced": false, "info": "", "type": "bool", "list": false}, "client": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "client", "advanced": false, "info": "", "type": "Any", "list": false}, "frequency_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "frequency_penalty", "advanced": false, "info": "", "type": "float", "list": false}, "logit_bias": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "logit_bias", "advanced": false, "info": "", "type": "code", "list": false}, "max_retries": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 6, "password": false, "name": "max_retries", "advanced": false, "info": "", "type": "int", "list": false}, "max_tokens": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 256, "password": true, "name": "max_tokens", "advanced": false, "info": "", "type": "int", "list": false}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "info": "", "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "text-davinci-003", "password": false, "options": ["text-davinci-003", "text-davinci-002", "text-curie-001", "text-babbage-001", "text-ada-001"], "name": "model_name", "advanced": false, "info": "", "type": "str", "list": true}, "n": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "n", "advanced": false, "info": "", "type": "int", "list": false}, "openai_api_base": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "openai_api_base", "display_name": "OpenAI API Base", "advanced": false, "info": "\nThe base URL of the OpenAI API. Defaults to https://api.openai.com/v1.\n\nYou can change this to use other APIs like JinaChat, LocalAI and Prem.\n", "type": "str", "list": false, "value": "http://127.0.0.1:5001/v1"}, "openai_api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "EMPTY", "password": true, "name": "openai_api_key", "display_name": "OpenAI API Key", "advanced": false, "info": "", "type": "str", "list": false}, "openai_organization": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_organization", "display_name": "OpenAI Organization", "advanced": false, "info": "", "type": "str", "list": false}, "openai_proxy": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "openai_proxy", "display_name": "OpenAI Proxy", "advanced": false, "info": "", "type": "str", "list": false}, "presence_penalty": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 0, "password": false, "name": "presence_penalty", "advanced": false, "info": "", "type": "float", "list": false}, "request_timeout": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "request_timeout", "advanced": false, "info": "", "type": "float", "list": false}, "streaming": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": false, "password": false, "name": "streaming", "advanced": false, "info": "", "type": "bool", "list": false}, "tags": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "tags", "advanced": false, "info": "", "type": "str", "list": true}, "temperature": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 0.7, "password": false, "name": "temperature", "advanced": false, "info": "", "type": "float", "list": false}, "tiktoken_model_name": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "tiktoken_model_name", "advanced": false, "info": "", "type": "str", "list": false}, "top_p": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 1, "password": false, "name": "top_p", "advanced": false, "info": "", "type": "float", "list": false}, "verbose": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "verbose", "advanced": false, "info": "", "type": "bool", "list": false}, "_type": "OpenAI"}, "description": "Wrapper around OpenAI large language models.", "base_classes": ["OpenAI", "BaseLLM", "BaseLanguageModel", "BaseOpenAI"], "display_name": "OpenAI", "documentation": "https://python.langchain.com/docs/modules/model_io/models/llms/integrations/openai"}, "id": "OpenAI-eXfnM", "value": null}, "selected": false, "positionAbsolute": {"x": 1486.1350734959847, "y": 102.72399011121513}, "dragging": false}, {"width": 384, "height": 523, "id": "Qdrant-PVjVQ", "type": "genericNode", "position": {"x": 882.4037303991418, "y": 783.3093136048128}, "data": {"type": "Qdrant", "node": {"template": {"documents": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "documents", "display_name": "Documents", "advanced": false, "info": "", "type": "Document", "list": true}, "embedding": {"required": true, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "embedding", "display_name": "Embedding", "advanced": false, "info": "", "type": "Embeddings", "list": false}, "hnsw_config": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "hnsw_config", "advanced": false, "info": "", "type": "common_types.HnswConfigDiff", "list": false}, "init_from": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "init_from", "advanced": false, "info": "", "type": "common_types.InitFrom", "list": false}, "optimizers_config": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "optimizers_config", "advanced": false, "info": "", "type": "common_types.OptimizersConfigDiff", "list": false}, "quantization_config": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "quantization_config", "advanced": false, "info": "", "type": "common_types.QuantizationConfig", "list": false}, "wal_config": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "wal_config", "advanced": false, "info": "", "type": "common_types.WalConfigDiff", "list": false}, "api_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": true, "name": "api_key", "display_name": "API Key", "advanced": false, "info": "", "type": "str", "list": false, "value": "c_qJgCP6qprsSJfrnYrsgVuSdHh8aiZiIFT4RZ6SskncvRRlvd6MEw"}, "batch_size": {"required": false, "placeholder": "", "show": false, "multiline": false, "value": 64, "password": false, "name": "batch_size", "advanced": false, "info": "", "type": "int", "list": false}, "collection_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "collection_name", "advanced": false, "info": "", "type": "str", "list": false, "value": "MyCollection"}, "content_payload_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "page_content", "password": false, "name": "content_payload_key", "advanced": true, "info": "", "type": "str", "list": false}, "distance_func": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "Cosine", "password": false, "name": "distance_func", "advanced": true, "info": "", "type": "str", "list": false}, "grpc_port": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 6334, "password": false, "name": "grpc_port", "advanced": true, "info": "", "type": "int", "list": false}, "host": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "host", "advanced": true, "info": "", "type": "str", "list": false}, "https": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "https", "advanced": true, "info": "", "type": "bool", "list": false}, "ids": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "ids", "advanced": false, "info": "", "type": "str", "list": true}, "location": {"required": false, "placeholder": ":memory:", "show": true, "multiline": false, "value": ":memory:", "password": false, "name": "location", "advanced": false, "info": "", "type": "str", "list": false}, "metadata_payload_key": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "metadata", "password": false, "name": "metadata_payload_key", "advanced": true, "info": "", "type": "str", "list": false}, "metadatas": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "metadatas", "advanced": false, "info": "", "type": "code", "list": true}, "on_disk_payload": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "on_disk_payload", "advanced": false, "info": "", "type": "bool", "list": false}, "path": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "path", "advanced": true, "info": "", "type": "str", "list": false, "value": "qdrant.db"}, "port": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": 6333, "password": false, "name": "port", "advanced": true, "info": "", "type": "int", "list": false}, "prefer_grpc": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": false, "password": false, "name": "prefer_grpc", "advanced": true, "info": "", "type": "bool", "list": false}, "prefix": {"required": false, "placeholder": "", "show": true, "multiline": true, "password": false, "name": "prefix", "advanced": true, "info": "", "type": "str", "list": false}, "replication_factor": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "replication_factor", "advanced": false, "info": "", "type": "int", "list": false}, "search_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "{}", "password": false, "name": "search_kwargs", "advanced": true, "info": "", "type": "code", "list": false}, "shard_number": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "shard_number", "advanced": false, "info": "", "type": "int", "list": false}, "timeout": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "timeout", "advanced": true, "info": "", "type": "float", "list": false}, "url": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "url", "advanced": true, "info": "", "type": "str", "list": false}, "write_consistency_factor": {"required": false, "placeholder": "", "show": false, "multiline": false, "password": false, "name": "write_consistency_factor", "advanced": false, "info": "", "type": "int", "list": false}, "_type": "Qdrant"}, "description": "Construct Qdrant wrapper from a list of texts.", "base_classes": ["Qdrant", "VectorStore", "BaseRetriever", "VectorStoreRetriever"], "display_name": "Qdrant", "documentation": "https://python.langchain.com/docs/modules/data_connection/vectorstores/integrations/qdrant"}, "id": "Qdrant-PVjVQ", "value": null}, "selected": false, "positionAbsolute": {"x": 882.4037303991418, "y": 783.3093136048128}, "dragging": false}, {"width": 384, "height": 206, "id": "HuggingFaceEmbeddings-ePrNe", "type": "genericNode", "position": {"x": 196.3211777989717, "y": 1162.8842906127074}, "data": {"type": "HuggingFaceEmbeddings", "node": {"template": {"cache_folder": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "cache_folder", "advanced": true, "info": "", "type": "str", "list": false}, "client": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "client", "advanced": true, "info": "", "type": "Any", "list": false}, "encode_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "encode_kwargs", "advanced": true, "info": "", "type": "code", "list": false}, "model_kwargs": {"required": false, "placeholder": "", "show": true, "multiline": false, "password": false, "name": "model_kwargs", "advanced": true, "info": "", "type": "code", "list": false}, "model_name": {"required": false, "placeholder": "", "show": true, "multiline": false, "value": "sentence-transformers/all-mpnet-base-v2", "password": false, "name": "model_name", "advanced": true, "info": "", "type": "str", "list": false}, "_type": "HuggingFaceEmbeddings"}, "description": "Wrapper around sentence_transformers embedding models.", "base_classes": ["Embeddings", "HuggingFaceEmbeddings"], "display_name": "HuggingFaceEmbeddings", "documentation": "https://python.langchain.com/docs/modules/data_connection/text_embedding/integrations/sentence_transformers"}, "id": "HuggingFaceEmbeddings-ePrNe", "value": null}, "selected": true, "positionAbsolute": {"x": 196.3211777989717, "y": 1162.8842906127074}, "dragging": false}], "edges": [{"source": "VectorStoreInfo-bHBdS", "sourceHandle": "VectorStoreInfo|VectorStoreInfo-bHBdS|VectorStoreInfo", "target": "VectorStoreAgent-IDwgx", "targetHandle": "VectorStoreInfo|vectorstoreinfo|VectorStoreAgent-IDwgx", "className": "", "id": "reactflow__edge-VectorStoreInfo-bHBdSVectorStoreInfo|VectorStoreInfo-bHBdS|VectorStoreInfo-VectorStoreAgent-IDwgxVectorStoreInfo|vectorstoreinfo|VectorStoreAgent-IDwgx", "selected": false, "style": {"stroke": "#555555"}, "animated": false}, {"source": "OpenAI-eXfnM", "sourceHandle": "OpenAI|OpenAI-eXfnM|OpenAI|BaseLLM|BaseLanguageModel|BaseOpenAI", "target": "VectorStoreAgent-IDwgx", "targetHandle": "BaseLanguageModel|llm|VectorStoreAgent-IDwgx", "style": {"stroke": "#555555"}, "animated": false, "id": "reactflow__edge-OpenAI-eXfnMOpenAI|OpenAI-eXfnM|BaseLLM|BaseLanguageModel|BaseOpenAI|OpenAI-VectorStoreAgent-IDwgxBaseLanguageModel|llm|VectorStoreAgent-IDwgx", "className": "", "selected": false}, {"source": "Qdrant-PVjVQ", "sourceHandle": "Qdrant|Qdrant-PVjVQ|Qdrant|VectorStore|BaseRetriever|VectorStoreRetriever", "target": "VectorStoreInfo-bHBdS", "targetHandle": "VectorStore|vectorstore|VectorStoreInfo-bHBdS", "style": {"stroke": "#555555"}, "className": "", "animated": false, "id": "reactflow__edge-Qdrant-PVjVQQdrant|Qdrant-PVjVQ|VectorStore|Qdrant|BaseRetriever-VectorStoreInfo-bHBdSVectorStore|vectorstore|VectorStoreInfo-bHBdS", "selected": false}, {"source": "HuggingFaceEmbeddings-ePrNe", "sourceHandle": "HuggingFaceEmbeddings|HuggingFaceEmbeddings-ePrNe|Embeddings|HuggingFaceEmbeddings", "target": "Qdrant-PVjVQ", "targetHandle": "Embeddings|embedding|Qdrant-PVjVQ", "style": {"stroke": "#555555"}, "className": "", "animated": false, "id": "reactflow__edge-HuggingFaceEmbeddings-ePrNeHuggingFaceEmbeddings|HuggingFaceEmbeddings-ePrNe|HuggingFaceEmbeddings|Embeddings-Qdrant-PVjVQEmbeddings|embedding|Qdrant-PVjVQ", "selected": false}, {"source": "CSVLoader-MqCoK", "sourceHandle": "CSVLoader|CSVLoader-MqCoK|Document", "target": "Qdrant-PVjVQ", "targetHandle": "Document|documents|Qdrant-PVjVQ", "style": {"stroke": "#555555"}, "className": "", "animated": false, "id": "reactflow__edge-CSVLoader-MqCoKCSVLoader|CSVLoader-MqCoK|Document-Qdrant-PVjVQDocument|documents|Qdrant-PVjVQ"}], "viewport": {"x": 28.02289479658714, "y": -42.794423079883444, "zoom": 0.44828572160243746}}', 'CSV Loader', 'A Chain that loads a CSV file and queries it for answers', '7198949d-8ed2-48a9-abf2-0832cf82a97b');


--
-- TOC entry 2879 (class 0 OID 1229990)
-- Dependencies: 211
-- Data for Name: flowstyle; Type: TABLE DATA; Schema: langflow; Owner: -
--



--
-- TOC entry 2891 (class 0 OID 0)
-- Dependencies: 204
-- Name: ExecutionLogs_id_seq; Type: SEQUENCE SET; Schema: langflow; Owner: -
--

SELECT pg_catalog.setval('langflow."ExecutionLogs_id_seq"', 16, true);


--
-- TOC entry 2892 (class 0 OID 0)
-- Dependencies: 198
-- Name: Jobs_id_seq; Type: SEQUENCE SET; Schema: langflow; Owner: -
--

SELECT pg_catalog.setval('langflow."Jobs_id_seq"', 4, true);


--
-- TOC entry 2893 (class 0 OID 0)
-- Dependencies: 206
-- Name: Nodes_id_seq; Type: SEQUENCE SET; Schema: langflow; Owner: -
--

SELECT pg_catalog.setval('langflow."Nodes_id_seq"', 15, true);


--
-- TOC entry 2894 (class 0 OID 0)
-- Dependencies: 202
-- Name: RunLogs_id_seq; Type: SEQUENCE SET; Schema: langflow; Owner: -
--

SELECT pg_catalog.setval('langflow."RunLogs_id_seq"', 4, true);


--
-- TOC entry 2895 (class 0 OID 0)
-- Dependencies: 208
-- Name: Triggers_id_seq; Type: SEQUENCE SET; Schema: langflow; Owner: -
--

SELECT pg_catalog.setval('langflow."Triggers_id_seq"', 5, true);


--
-- TOC entry 2896 (class 0 OID 0)
-- Dependencies: 200
-- Name: Workflows_id_seq; Type: SEQUENCE SET; Schema: langflow; Owner: -
--

SELECT pg_catalog.setval('langflow."Workflows_id_seq"', 11, true);


--
-- TOC entry 2731 (class 2606 OID 1229932)
-- Name: ExecutionLogs ExecutionLogs_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."ExecutionLogs"
    ADD CONSTRAINT "ExecutionLogs_pkey" PRIMARY KEY (id);


--
-- TOC entry 2725 (class 2606 OID 1229899)
-- Name: Jobs Jobs_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Jobs"
    ADD CONSTRAINT "Jobs_pkey" PRIMARY KEY (id);


--
-- TOC entry 2733 (class 2606 OID 1229943)
-- Name: Nodes Nodes_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Nodes"
    ADD CONSTRAINT "Nodes_pkey" PRIMARY KEY (id);


--
-- TOC entry 2729 (class 2606 OID 1229921)
-- Name: RunLogs RunLogs_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."RunLogs"
    ADD CONSTRAINT "RunLogs_pkey" PRIMARY KEY (id);


--
-- TOC entry 2735 (class 2606 OID 1229954)
-- Name: Triggers Triggers_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Triggers"
    ADD CONSTRAINT "Triggers_pkey" PRIMARY KEY (id);


--
-- TOC entry 2727 (class 2606 OID 1229910)
-- Name: Workflows Workflows_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Workflows"
    ADD CONSTRAINT "Workflows_pkey" PRIMARY KEY (id);


--
-- TOC entry 2739 (class 2606 OID 1229987)
-- Name: flow flow_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow.flow
    ADD CONSTRAINT flow_pkey PRIMARY KEY (id);


--
-- TOC entry 2743 (class 2606 OID 1229997)
-- Name: flowstyle flowstyle_pkey; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow.flowstyle
    ADD CONSTRAINT flowstyle_pkey PRIMARY KEY (id);


--
-- TOC entry 2737 (class 2606 OID 1230024)
-- Name: Triggers shortcode; Type: CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow."Triggers"
    ADD CONSTRAINT shortcode UNIQUE (shortcode);


--
-- TOC entry 2740 (class 1259 OID 1229989)
-- Name: ix_flow_description; Type: INDEX; Schema: langflow; Owner: -
--

CREATE INDEX ix_flow_description ON langflow.flow USING btree (description);


--
-- TOC entry 2741 (class 1259 OID 1229988)
-- Name: ix_flow_name; Type: INDEX; Schema: langflow; Owner: -
--

CREATE INDEX ix_flow_name ON langflow.flow USING btree (name);


--
-- TOC entry 2744 (class 2606 OID 1229998)
-- Name: flowstyle flowstyle_flow_id_fkey; Type: FK CONSTRAINT; Schema: langflow; Owner: -
--

ALTER TABLE ONLY langflow.flowstyle
    ADD CONSTRAINT flowstyle_flow_id_fkey FOREIGN KEY (flow_id) REFERENCES langflow.flow(id);


-- Completed on 2023-07-14 14:16:09

--
-- PostgreSQL database dump complete
--

