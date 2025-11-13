--
-- TOC entry 207 (class 1259 OID 113725)
-- Name: article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.article (
    id numeric(19,0) NOT NULL,
    pubmedid numeric(19,0),
    doiid character varying(255),
    title character varying(4000),
    article_abstract text,
    factor numeric,
    publisheddate timestamp without time zone,
    publisheddateforprint character varying(4000),
    journal_id numeric(19,0),
    volume character varying(255),
    issue character varying(255),
    pagination character varying(255),
    textlink character varying(512),
    issn character varying(255),
    affiliation text,
    journalrankingsbasedonpubtype character varying(255),
    include_in_rankings boolean,
    type character varying(255),
    view_count numeric(16,0) DEFAULT 0,
    first_evaluated timestamp without time zone,
    free boolean DEFAULT false,
    published_on_pubmed_central boolean DEFAULT false,
    bibleinstitution_id bigint,
    added_date timestamp without time zone DEFAULT now(),
    journal_info_last_updated timestamp without time zone,
    journal_info_updated boolean,
    super_article boolean DEFAULT false NOT NULL,
    till2013views numeric DEFAULT 0 NOT NULL,
    highly_accessed boolean DEFAULT false NOT NULL,
    pubmed_published_date timestamp without time zone,
    pubmed_keywords text,
    citation_count numeric(19,0),
    last_citation_update timestamp without time zone,
    last_indexed timestamp without time zone,
    book_info_id numeric(19,0),
    invalid_pubmedid boolean,
    conference_id numeric(19,0)
);


ALTER TABLE public.article OWNER TO f1000;

--
-- TOC entry 208 (class 1259 OID 113738)
-- Name: article_author_affiliation_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_author_affiliation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_author_affiliation_id_seq OWNER TO f1000;

--
-- TOC entry 209 (class 1259 OID 113740)
-- Name: article_conference_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_conference_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_conference_seq OWNER TO f1000;

--
-- TOC entry 210 (class 1259 OID 113742)
-- Name: article_grant_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_grant_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_grant_seq OWNER TO f1000;

--
-- TOC entry 211 (class 1259 OID 113744)
-- Name: article_reference_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_reference_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_reference_seq OWNER TO f1000;

--
-- TOC entry 212 (class 1259 OID 113746)
-- Name: article_retracted_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_retracted_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_retracted_id_sequence OWNER TO f1000;

--
-- TOC entry 213 (class 1259 OID 113748)
-- Name: article_top_ten_rank_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_top_ten_rank_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_top_ten_rank_seq OWNER TO f1000;

--
-- TOC entry 214 (class 1259 OID 113750)
-- Name: article_tracking_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.article_tracking_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.article_tracking_seq OWNER TO f1000;

--
-- TOC entry 215 (class 1259 OID 113752)
-- Name: articles_thesaurus_terms; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.articles_thesaurus_terms (
    article_id numeric(19,0) NOT NULL,
    term_id numeric(19,0) NOT NULL
);


ALTER TABLE public.articles_thesaurus_terms OWNER TO f1000;

--
-- TOC entry 216 (class 1259 OID 113755)
-- Name: bible_institution; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.bible_institution (
    id bigint NOT NULL,
    name character varying NOT NULL,
    displayname character varying NOT NULL,
    type character varying(10) NOT NULL,
    address character varying,
    website character varying,
    country_cou_id bigint,
    parent_id bigint,
    manually_added boolean DEFAULT false
);


ALTER TABLE public.bible_institution OWNER TO f1000;

--
-- TOC entry 217 (class 1259 OID 113762)
-- Name: bible_institution_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.bible_institution_seq
    START WITH 211000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bible_institution_seq OWNER TO f1000;

--
-- TOC entry 218 (class 1259 OID 113764)
-- Name: bmc_iip_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.bmc_iip_sequence
    START WITH 4494835
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bmc_iip_sequence OWNER TO f1000;

--
-- TOC entry 219 (class 1259 OID 113766)
-- Name: bmc_ins_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.bmc_ins_sequence
    START WITH 583203
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bmc_ins_sequence OWNER TO f1000;

--
-- TOC entry 220 (class 1259 OID 113768)
-- Name: bmc_usb_inst_trial_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.bmc_usb_inst_trial_sequence
    START WITH 2434389
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bmc_usb_inst_trial_sequence OWNER TO f1000;

--
-- TOC entry 221 (class 1259 OID 113770)
-- Name: bmc_uss_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.bmc_uss_sequence
    START WITH 24297406
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bmc_uss_sequence OWNER TO f1000;

--
-- TOC entry 222 (class 1259 OID 113772)
-- Name: book_editor_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.book_editor_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_editor_id_sequence OWNER TO f1000;

--
-- TOC entry 223 (class 1259 OID 113774)
-- Name: book_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.book_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_info_seq OWNER TO f1000;

--
-- TOC entry 224 (class 1259 OID 113776)
-- Name: campaign_member_updates_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.campaign_member_updates_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campaign_member_updates_seq OWNER TO f1000;

--
-- TOC entry 225 (class 1259 OID 113778)
-- Name: changed_passwords; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.changed_passwords (
    usr_id numeric(19,0),
    hashed_password character(64)
);


ALTER TABLE public.changed_passwords OWNER TO f1000;

--
-- TOC entry 226 (class 1259 OID 113781)
-- Name: clinical_trial_article_history_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.clinical_trial_article_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clinical_trial_article_history_seq OWNER TO f1000;

--
-- TOC entry 227 (class 1259 OID 113783)
-- Name: clinical_trial_email_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.clinical_trial_email_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clinical_trial_email_seq OWNER TO f1000;

--
-- TOC entry 228 (class 1259 OID 113785)
-- Name: clustered_search_task_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.clustered_search_task_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clustered_search_task_sequence OWNER TO f1000;

--
-- TOC entry 790 (class 1259 OID 27632832)
-- Name: collective_author_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.collective_author_file (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    file_size numeric(19,0)
);


ALTER TABLE public.collective_author_file OWNER TO f1000;

--
-- TOC entry 229 (class 1259 OID 113787)
-- Name: commissioned_report_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.commissioned_report_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commissioned_report_id_sequence OWNER TO f1000;

--
-- TOC entry 230 (class 1259 OID 113789)
-- Name: conference_editor_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.conference_editor_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conference_editor_id_sequence OWNER TO f1000;

--
-- TOC entry 231 (class 1259 OID 113791)
-- Name: core_research_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.core_research_topic (
    topic_id numeric(19,0) NOT NULL,
    subtopic_id numeric(19,0) NOT NULL
);


ALTER TABLE public.core_research_topic OWNER TO f1000;

--
-- TOC entry 232 (class 1259 OID 113797)
-- Name: counter5_platform_report_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.counter5_platform_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.counter5_platform_report_seq OWNER TO f1000;

--
-- TOC entry 233 (class 1259 OID 113799)
-- Name: counter5_title_report_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.counter5_title_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.counter5_title_report_seq OWNER TO f1000;

--
-- TOC entry 234 (class 1259 OID 113801)
-- Name: counter_report_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.counter_report_id_sequence
    START WITH 2192341
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.counter_report_id_sequence OWNER TO f1000;

--
-- TOC entry 235 (class 1259 OID 113803)
-- Name: counter_statistic_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.counter_statistic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.counter_statistic_id_seq OWNER TO f1000;

--
-- TOC entry 236 (class 1259 OID 113805)
-- Name: csl_style_repository_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.csl_style_repository_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.csl_style_repository_seq OWNER TO f1000;

--
-- TOC entry 237 (class 1259 OID 113807)
-- Name: cursor; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.cursor (
    id numeric NOT NULL,
    name character varying(30) NOT NULL,
    "position" numeric DEFAULT 0 NOT NULL
);


ALTER TABLE public.cursor OWNER TO f1000;

--
-- TOC entry 238 (class 1259 OID 113814)
-- Name: database_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.database_version (
    version character varying(255)
);


ALTER TABLE public.database_version OWNER TO f1000;

--
-- TOC entry 789 (class 1259 OID 22420340)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO f1000;

--
-- TOC entry 788 (class 1259 OID 22420335)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO f1000;

--
-- TOC entry 779 (class 1259 OID 8221481)
-- Name: dataset_additional_details_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.dataset_additional_details_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_additional_details_seq OWNER TO f1000;

--
-- TOC entry 780 (class 1259 OID 8221483)
-- Name: dataset_additional_details; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.dataset_additional_details (
    id numeric(19,0) DEFAULT nextval('public.dataset_additional_details_seq'::regclass) NOT NULL,
    dataset_shared boolean,
    additional_data boolean,
    additional_data_details text,
    confirmation boolean,
    no_data_associated boolean,
    no_data_associated_details text,
    ethical_and_security boolean,
    ethical_and_security_details text,
    data_protection_issue boolean,
    data_protection_issue_details text,
    too_large boolean,
    too_large_details text,
    under_license boolean,
    under_license_details text,
    no_confirmation boolean,
    new_dataset_details boolean
);


ALTER TABLE public.dataset_additional_details OWNER TO f1000;

--
-- TOC entry 776 (class 1259 OID 6244886)
-- Name: dataset_details; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.dataset_details (
    id uuid NOT NULL,
    platform character varying NOT NULL,
    version_id bigint NOT NULL,
    type_of_sharing character varying,
    persistent_identifier character varying,
    dataset_title character varying NOT NULL,
    dataset_url character varying NOT NULL,
    repository_name character varying,
    dataset_creators character varying,
    type_of_data character varying NOT NULL,
    license character varying,
    equivalent_open_license character varying,
    yes_confirmation boolean NOT NULL
);


ALTER TABLE public.dataset_details OWNER TO f1000;

--
-- TOC entry 239 (class 1259 OID 113817)
-- Name: department; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.department (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    institution_id numeric(19,0) NOT NULL
);


ALTER TABLE public.department OWNER TO f1000;

--
-- TOC entry 240 (class 1259 OID 113820)
-- Name: dic_known_mistake_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.dic_known_mistake_id_sequence
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dic_known_mistake_id_sequence OWNER TO f1000;

--
-- TOC entry 241 (class 1259 OID 113822)
-- Name: doi_prefix_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.doi_prefix_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doi_prefix_seq OWNER TO f1000;

--
-- TOC entry 242 (class 1259 OID 113824)
-- Name: editor_external_count_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.editor_external_count_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.editor_external_count_seq OWNER TO f1000;

--
-- TOC entry 243 (class 1259 OID 113826)
-- Name: editor_faculty_member_bookmark_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.editor_faculty_member_bookmark_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.editor_faculty_member_bookmark_seq OWNER TO f1000;

--
-- TOC entry 244 (class 1259 OID 113828)
-- Name: evaluation_history_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.evaluation_history_sequence
    START WITH 34601
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluation_history_sequence OWNER TO f1000;

--
-- TOC entry 245 (class 1259 OID 113830)
-- Name: event_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.event_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_seq OWNER TO f1000;

--
-- TOC entry 246 (class 1259 OID 113832)
-- Name: f1000_article_view_tracking_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_article_view_tracking_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_article_view_tracking_sequence OWNER TO f1000;

--
-- TOC entry 247 (class 1259 OID 113834)
-- Name: f1000_far_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_far_id_sequence
    START WITH 14358956
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_far_id_sequence OWNER TO f1000;

--
-- TOC entry 248 (class 1259 OID 113836)
-- Name: f1000_fev_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_fev_sequence
    START WITH 15869056
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_fev_sequence OWNER TO f1000;

--
-- TOC entry 249 (class 1259 OID 113838)
-- Name: f1000_fevt_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_fevt_sequence
    START WITH 51762
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_fevt_sequence OWNER TO f1000;

--
-- TOC entry 250 (class 1259 OID 113840)
-- Name: f1000_fug_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_fug_sequence
    START WITH 9999671273955704
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_fug_sequence OWNER TO f1000;

--
-- TOC entry 251 (class 1259 OID 113842)
-- Name: f1000_fut_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_fut_sequence
    START WITH 81801
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_fut_sequence OWNER TO f1000;

--
-- TOC entry 252 (class 1259 OID 113844)
-- Name: f1000_trending_views_count_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_trending_views_count_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_trending_views_count_seq OWNER TO f1000;

--
-- TOC entry 253 (class 1259 OID 113846)
-- Name: f1000_trending_views_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_trending_views_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_trending_views_seq OWNER TO f1000;

--
-- TOC entry 254 (class 1259 OID 113848)
-- Name: f1000_trending_views_summary_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_trending_views_summary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_trending_views_summary_seq OWNER TO f1000;

--
-- TOC entry 255 (class 1259 OID 113850)
-- Name: f1000_upo_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000_upo_sequence
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000_upo_sequence OWNER TO f1000;

--
-- TOC entry 256 (class 1259 OID 113852)
-- Name: f1000_user_specified_job_type; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000_user_specified_job_type (
    ujt_id numeric(19,0) NOT NULL,
    ujt_usi_id numeric(19,0),
    ujt_specified_job_type character varying(256)
);


ALTER TABLE public.f1000_user_specified_job_type OWNER TO f1000;

--
-- TOC entry 257 (class 1259 OID 113855)
-- Name: f1000r_affiliation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_affiliation (
    id numeric(19,0) NOT NULL,
    department character varying(255),
    place character varying(64),
    zip_code character varying(64),
    institution_id bigint,
    country_id numeric(19,0),
    version_id numeric(19,0),
    affiliation_position numeric DEFAULT 0,
    state character varying(255),
    unique_id uuid,
    user_id numeric(19,0)
);


ALTER TABLE public.f1000r_affiliation OWNER TO f1000;

--
-- TOC entry 258 (class 1259 OID 113862)
-- Name: f1000r_affiliation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_affiliation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_affiliation_seq OWNER TO f1000;

--
-- TOC entry 259 (class 1259 OID 113864)
-- Name: f1000r_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article (
    id numeric(19,0) NOT NULL,
    text_license_type character varying(255),
    data_license_type character varying(255),
    contract_signed boolean,
    status character varying(100),
    next_action_date timestamp without time zone,
    notes text,
    volume integer,
    publication_number integer,
    feeds_exclude boolean,
    product_id character varying,
    paid boolean DEFAULT false NOT NULL,
    payment_request_date timestamp without time zone,
    waive_payment_option character varying,
    views_count integer DEFAULT 0,
    downloads_count integer DEFAULT 0,
    emails_count integer DEFAULT 0,
    shares_count integer DEFAULT 0,
    payment_request_resubmitted boolean DEFAULT false,
    payment_selected boolean,
    vat_number character varying,
    customer_name character varying,
    customer_aff character varying,
    payment_date timestamp without time zone,
    waive_payment_date timestamp without time zone,
    archived_date timestamp without time zone,
    monthly_views_count integer DEFAULT 0,
    customer_email character varying,
    product_type character varying(20),
    discount_type character varying(20),
    invoice_reason character varying(255),
    payment_method character varying(9),
    prepay_membership_id numeric,
    data_license_other_name character varying(255),
    text_license_other_name character varying(255),
    notes_from_author character varying,
    author_declaration_author boolean DEFAULT false,
    author_declaration_not_published boolean DEFAULT false,
    author_declaration_all_authors_agreed boolean DEFAULT false,
    paypal_payment_status character varying(255),
    latest_indexed_feeds_exclude boolean,
    latest_submissions_feeds_exclude boolean,
    submitted_by_referee_flag boolean DEFAULT false,
    promotional_code_id numeric(19,0),
    referee_status character varying(100),
    referee_status_updated timestamp without time zone,
    xml_downloads_count integer DEFAULT 0,
    referees_approved boolean,
    author_declaration_all_author_have_permissions boolean DEFAULT false,
    nih_text_license boolean DEFAULT false,
    used_as_featured boolean DEFAULT false,
    excluded_referees_author_text text,
    article_payment_id numeric(19,0),
    is_editorial boolean DEFAULT false NOT NULL,
    author_declaration_author_list_changes boolean DEFAULT false,
    author_study_declaration boolean DEFAULT false,
    exclude_in_experts_panel boolean DEFAULT false,
    remaining_suggested_referees integer DEFAULT 0,
    is_faculty_review boolean DEFAULT false,
    excluded_from_dashboard boolean DEFAULT false,
    citation_name character varying(100),
    main_collection_id numeric(19,0),
    is_vip boolean DEFAULT false,
    sent_to_kudos boolean DEFAULT false,
    referee_emails_blurb text,
    chase_manually boolean DEFAULT false,
    next_chase_author_date timestamp without time zone,
    close_peer_review_date timestamp without time zone,
    close_peer_review_source character varying(100),
    website_id numeric(19,0),
    pubmed_indexed boolean DEFAULT false,
    no_other_funding boolean DEFAULT false,
    confirm_grants boolean DEFAULT false,
    referee_finder_type character varying(50) DEFAULT NULL::character varying,
    suppress_overdue_status boolean DEFAULT false,
    top_level_subject character varying(50) DEFAULT NULL::character varying,
    social_keywords text,
    suppress_prx_revisions_reminder boolean DEFAULT true,
    alternate_language character varying(255),
    publish_in_alternate_language boolean,
    broad_subject_area character varying(50) DEFAULT NULL::character varying,
    specific_subject_area_term_id numeric(19,0) DEFAULT NULL::numeric,
    awaiting_name_finding boolean DEFAULT false NOT NULL,
    is_under_ethical_investigation boolean DEFAULT false NOT NULL,
    is_editor_only_peer_review boolean DEFAULT false NOT NULL,
    is_controversial boolean DEFAULT false NOT NULL,
    requested_check_level character varying(100),
    version_of_record character varying(100),
    vor_confirmed boolean DEFAULT false NOT NULL,
    third_party_permissions_declaration boolean DEFAULT false NOT NULL,
    ai_policy_compliance_declaration boolean DEFAULT false NOT NULL
);


ALTER TABLE public.f1000r_article OWNER TO f1000;

--
-- TOC entry 260 (class 1259 OID 113903)
-- Name: f1000r_article_citation_count; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_citation_count (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    pubmed_citation_count integer DEFAULT 0,
    scopus_citation_count integer DEFAULT 0,
    last_scopus_update_time date,
    last_pubmed_update_time date
);


ALTER TABLE public.f1000r_article_citation_count OWNER TO f1000;

--
-- TOC entry 261 (class 1259 OID 113908)
-- Name: f1000r_article_citation_count_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_citation_count_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_citation_count_seq OWNER TO f1000;

--
-- TOC entry 262 (class 1259 OID 113910)
-- Name: f1000r_article_citation_statistics; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_citation_statistics (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    pubmed_citation_count integer DEFAULT 0,
    scopus_citation_count integer DEFAULT 0,
    cited_by_fbwalls_count integer DEFAULT 0,
    cited_by_feeds_count integer DEFAULT 0,
    cited_by_gplus_count integer DEFAULT 0,
    cited_by_linkedin_count integer DEFAULT 0,
    cited_by_msm_count integer DEFAULT 0,
    cited_by_peer_review_sites_count integer DEFAULT 0,
    cited_by_pinners_count integer DEFAULT 0,
    cited_by_posts_count integer DEFAULT 0,
    cited_by_rh_count integer DEFAULT 0,
    cited_by_tweeters_count integer DEFAULT 0,
    cited_by_videos_count integer DEFAULT 0,
    cited_by_weibo_count integer DEFAULT 0,
    cited_by_wikipedia_count integer DEFAULT 0,
    cited_by_accounts_count integer DEFAULT 0,
    readers_count integer DEFAULT 0,
    mendeley integer DEFAULT 0,
    connotea integer DEFAULT 0,
    citeulike integer DEFAULT 0,
    altmetric_id integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.f1000r_article_citation_statistics OWNER TO f1000;

--
-- TOC entry 263 (class 1259 OID 113935)
-- Name: f1000r_article_citation_statistics_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_citation_statistics_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_citation_statistics_seq OWNER TO f1000;

--
-- TOC entry 264 (class 1259 OID 113937)
-- Name: f1000r_article_collection_suggestion; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_collection_suggestion (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    decision character varying(255),
    preselected boolean DEFAULT false
);


ALTER TABLE public.f1000r_article_collection_suggestion OWNER TO f1000;

--
-- TOC entry 265 (class 1259 OID 113941)
-- Name: f1000r_article_collection_suggestion_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_collection_suggestion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_collection_suggestion_seq OWNER TO f1000;

--
-- TOC entry 266 (class 1259 OID 113943)
-- Name: f1000r_article_collection_tracking; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_collection_tracking (
    article_id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    article_added_to_collection timestamp without time zone
);


ALTER TABLE public.f1000r_article_collection_tracking OWNER TO f1000;

--
-- TOC entry 267 (class 1259 OID 113946)
-- Name: f1000r_article_collection_view; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_collection_view (
    id numeric(19,0) NOT NULL,
    url text,
    asset_view_id numeric(19,0) NOT NULL,
    article_collection_id numeric(19,0)
);


ALTER TABLE public.f1000r_article_collection_view OWNER TO f1000;

--
-- TOC entry 268 (class 1259 OID 113952)
-- Name: f1000r_article_collection_view_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_collection_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_collection_view_seq OWNER TO f1000;

--
-- TOC entry 269 (class 1259 OID 113954)
-- Name: f1000r_article_country; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_country (
    article_id numeric(19,0) NOT NULL,
    country_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_article_country OWNER TO f1000;

--
-- TOC entry 270 (class 1259 OID 113957)
-- Name: f1000r_article_dataset; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_dataset (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    file_size numeric(19,0),
    title character varying,
    description character varying,
    doi character varying(100),
    plottable boolean DEFAULT false NOT NULL,
    selectable_x character varying(100),
    plottable_columns character varying(100),
    selected_x smallint,
    thumbnail_file_name character varying(1024),
    excluded_from_pubmed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.f1000r_article_dataset OWNER TO f1000;

--
-- TOC entry 271 (class 1259 OID 113965)
-- Name: f1000r_article_dataset_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_dataset_draft (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    file_size numeric(19,0),
    title character varying,
    description character varying,
    pos numeric,
    version_id numeric(19,0),
    original_article_dataset_id numeric(19,0)
);


ALTER TABLE public.f1000r_article_dataset_draft OWNER TO f1000;

--
-- TOC entry 272 (class 1259 OID 113971)
-- Name: f1000r_article_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_log (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    editor_id numeric(19,0),
    version_status character varying(100),
    version_id numeric(19,0) NOT NULL,
    tracking_date timestamp without time zone,
    editors_full_name character varying(512),
    audit_type character varying,
    article_status character varying(100)
);


ALTER TABLE public.f1000r_article_log OWNER TO f1000;

--
-- TOC entry 273 (class 1259 OID 113977)
-- Name: f1000r_article_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_log_seq OWNER TO f1000;

--
-- TOC entry 274 (class 1259 OID 113979)
-- Name: f1000r_article_payment; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_payment (
    id numeric(19,0) NOT NULL,
    paid boolean DEFAULT false NOT NULL,
    payment_request_date timestamp without time zone,
    payment_date timestamp without time zone,
    article_pricing_category_id numeric(19,0),
    full_price boolean DEFAULT true NOT NULL,
    payment_request_resubmitted boolean DEFAULT false,
    vat_number character varying,
    customer_name character varying,
    customer_email character varying,
    customer_aff character varying,
    payment_type character varying(20),
    promotional_code_id numeric(19,0),
    manual_discount character varying(30),
    vat_included boolean DEFAULT false NOT NULL,
    interactive_payment_method character varying(20),
    invoice_reason character varying(255),
    prepay_membership_id numeric,
    waive_payment_option character varying(50),
    invoice_number character varying(255),
    automatic_invoice_info_id numeric(19,0),
    sage_payment_response_id numeric(19,0),
    paypal_payment_id numeric(19,0),
    uuid character varying(36),
    refunded boolean DEFAULT false NOT NULL,
    refunded_notes character varying,
    country_cou_id numeric(19,0),
    vat_number_verified boolean DEFAULT false,
    hinari_agora boolean DEFAULT false,
    author_notes text,
    sent_to_accounts_date timestamp without time zone,
    notes_to_accounts text,
    customer_address text,
    agreed_payment boolean DEFAULT false,
    payment_request_cc character varying,
    currency character varying(3) DEFAULT 'USD'::character varying,
    requested_rate numeric(19,6),
    set_price_selected boolean DEFAULT false,
    set_price_value numeric DEFAULT 0.00,
    cost_type character varying(30),
    customer_first_name character varying(30),
    customer_last_name character varying(30),
    user_article_payment_form_submitted boolean DEFAULT false,
    draft_article_payment_id numeric(19,0),
    final_price_gross numeric(19,2),
    exchange_rate numeric(19,6),
    payer_type character varying(30),
    date_of_exchange_rate timestamp without time zone,
    paid_status_type character varying(20),
    customer_address1 character varying,
    customer_address2 character varying,
    customer_postal_code character varying,
    platform_membership_id text,
    eligible_for_discount boolean DEFAULT false,
    customer_city character varying,
    ringgold_id character varying,
    selected_product_code character varying,
    customer_state character varying(255)
);


ALTER TABLE public.f1000r_article_payment OWNER TO f1000;

--
-- TOC entry 275 (class 1259 OID 113997)
-- Name: f1000r_article_payment_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_payment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_payment_seq OWNER TO f1000;

--
-- TOC entry 276 (class 1259 OID 113999)
-- Name: f1000r_article_person_orcid; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_person_orcid (
    id numeric(19,0) NOT NULL,
    orcid_access_data_id numeric(19,0),
    article_id numeric(19,0),
    email character varying(255),
    user_id numeric(19,0),
    version_id numeric(19,0),
    put_code numeric(19,0)
);


ALTER TABLE public.f1000r_article_person_orcid OWNER TO f1000;

--
-- TOC entry 277 (class 1259 OID 114002)
-- Name: f1000r_article_pricing_category; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_pricing_category (
    id numeric(19,0) NOT NULL,
    pricing_category character varying(30) NOT NULL,
    price numeric NOT NULL,
    enabled boolean NOT NULL,
    website_id numeric(19,0),
    count_low integer,
    count_high integer,
    valid_from date,
    valid_to date
);


ALTER TABLE public.f1000r_article_pricing_category OWNER TO f1000;

--
-- TOC entry 278 (class 1259 OID 114008)
-- Name: f1000r_article_pricing_category_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_pricing_category_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_pricing_category_seq OWNER TO f1000;

--
-- TOC entry 279 (class 1259 OID 114010)
-- Name: f1000r_article_question; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_question (
    id numeric(19,0) NOT NULL,
    website_id numeric(19,0) NOT NULL,
    article_type text,
    question_description text,
    information_description text,
    answers text,
    "position" numeric(19,0),
    version_id numeric(19,0),
    article_discipline_type text,
    alternate_language character varying(255),
    valid_from date
);


ALTER TABLE public.f1000r_article_question OWNER TO f1000;

--
-- TOC entry 280 (class 1259 OID 114016)
-- Name: f1000r_article_question_result; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_question_result (
    id numeric(19,0) NOT NULL,
    article_referee_id numeric(19,0) NOT NULL,
    question_id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    result text,
    created_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.f1000r_article_question_result OWNER TO f1000;

--
-- TOC entry 281 (class 1259 OID 114023)
-- Name: f1000r_article_question_result_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_question_result_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_question_result_seq OWNER TO f1000;

--
-- TOC entry 282 (class 1259 OID 114025)
-- Name: f1000r_article_question_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_question_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_question_seq OWNER TO f1000;

--
-- TOC entry 283 (class 1259 OID 114027)
-- Name: f1000r_article_referee; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_referee (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    referee_id numeric(19,0) NOT NULL,
    response_status character varying(100),
    response_date timestamp without time zone,
    submission_status character varying(100),
    submission_date timestamp without time zone,
    notes text,
    status_response_date timestamp without time zone,
    declined_reason character varying(255),
    invitation_date timestamp without time zone,
    article_referee_status character varying(100),
    non_appropriate_status character varying(100),
    excluded_referee_notes text,
    declined_status character varying(150),
    article_referee_sub_status character varying(100),
    article_referee_status_updated timestamp without time zone,
    exclude_in_experts_panel boolean DEFAULT false,
    created timestamp without time zone,
    article_referee_source character varying(100),
    contact_author boolean,
    uuid character varying(36),
    contact_date date
);


ALTER TABLE public.f1000r_article_referee OWNER TO f1000;

--
-- TOC entry 284 (class 1259 OID 114034)
-- Name: f1000r_article_referee_affiliation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_referee_affiliation (
    id numeric(19,0) NOT NULL,
    article_referee_id numeric(19,0) NOT NULL,
    affiliation_id numeric(19,0),
    affiliation_uid uuid
);


ALTER TABLE public.f1000r_article_referee_affiliation OWNER TO f1000;

--
-- TOC entry 285 (class 1259 OID 114037)
-- Name: f1000r_article_referee_affiliation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_referee_affiliation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_referee_affiliation_seq OWNER TO f1000;

--
-- TOC entry 286 (class 1259 OID 114039)
-- Name: f1000r_article_referee_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_referee_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_referee_seq OWNER TO f1000;

--
-- TOC entry 287 (class 1259 OID 114041)
-- Name: f1000r_article_referee_status_tracker; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_referee_status_tracker (
    id numeric(19,0) NOT NULL,
    before_article_referee_status character varying(100),
    after_article_referee_status character varying(100),
    before_non_appropriate_status character varying(100),
    after_non_appropriate_status character varying(100),
    tracking_date timestamp without time zone NOT NULL,
    article_referee_id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL,
    before_article_referee_sub_status character varying(100),
    after_article_referee_sub_status character varying(100)
);


ALTER TABLE public.f1000r_article_referee_status_tracker OWNER TO f1000;

--
-- TOC entry 288 (class 1259 OID 114047)
-- Name: f1000r_article_referee_status_tracker_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_referee_status_tracker_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_referee_status_tracker_seq OWNER TO f1000;

--
-- TOC entry 289 (class 1259 OID 114049)
-- Name: f1000r_article_referee_survey; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_referee_survey (
    id numeric(19,0) NOT NULL,
    website_id numeric(19,0) NOT NULL,
    question_description text,
    information_description text,
    "position" numeric(19,0)
);


ALTER TABLE public.f1000r_article_referee_survey OWNER TO f1000;

--
-- TOC entry 290 (class 1259 OID 114055)
-- Name: f1000r_article_referee_survey_answer; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_referee_survey_answer (
    id numeric(19,0) NOT NULL,
    article_referee_id numeric(19,0) NOT NULL,
    question_id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    answer boolean
);


ALTER TABLE public.f1000r_article_referee_survey_answer OWNER TO f1000;

--
-- TOC entry 291 (class 1259 OID 114058)
-- Name: f1000r_article_referee_survey_answer_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_referee_survey_answer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_referee_survey_answer_seq OWNER TO f1000;

--
-- TOC entry 292 (class 1259 OID 114060)
-- Name: f1000r_article_referee_survey_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_referee_survey_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_referee_survey_seq OWNER TO f1000;

--
-- TOC entry 293 (class 1259 OID 114062)
-- Name: f1000r_article_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_seq OWNER TO f1000;

--
-- TOC entry 294 (class 1259 OID 114064)
-- Name: f1000r_article_statistic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_statistic (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0),
    milestone_views_date timestamp without time zone,
    views_count integer,
    milestone_views character varying(100)
);


ALTER TABLE public.f1000r_article_statistic OWNER TO f1000;

--
-- TOC entry 295 (class 1259 OID 114067)
-- Name: f1000r_article_statistic_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_statistic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_statistic_seq OWNER TO f1000;

--
-- TOC entry 296 (class 1259 OID 114069)
-- Name: f1000r_article_tracking; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_tracking (
    user_id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    last_tracked_event_time timestamp without time zone,
    new_version_published timestamp without time zone,
    new_referee_report_published timestamp without time zone,
    referee_report_status_changed timestamp without time zone,
    commented_on_referee_report timestamp without time zone,
    new_article_comment_published timestamp without time zone,
    author_response_published timestamp without time zone,
    created_on timestamp without time zone,
    new_f1000_evaluation_published timestamp without time zone,
    date_indexed_first_time timestamp without time zone,
    new_objection_published timestamp without time zone,
    update_objection timestamp without time zone,
    tracking_individually boolean DEFAULT false,
    retraction_date timestamp without time zone
);


ALTER TABLE public.f1000r_article_tracking OWNER TO f1000;

--
-- TOC entry 297 (class 1259 OID 114073)
-- Name: f1000r_article_tracking_delete_channels; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_tracking_delete_channels (
    user_id numeric(19,0),
    article_id numeric(19,0),
    last_tracked_event_time timestamp without time zone,
    new_version_published timestamp without time zone,
    new_referee_report_published timestamp without time zone,
    referee_report_status_changed timestamp without time zone,
    commented_on_referee_report timestamp without time zone,
    new_article_comment_published timestamp without time zone,
    author_response_published timestamp without time zone,
    created_on timestamp without time zone,
    new_f1000_evaluation_published timestamp without time zone,
    date_indexed_first_time timestamp without time zone,
    new_objection_published timestamp without time zone,
    update_objection timestamp without time zone,
    tracking_individually boolean
);


ALTER TABLE public.f1000r_article_tracking_delete_channels OWNER TO f1000;

--
-- TOC entry 298 (class 1259 OID 114076)
-- Name: f1000r_article_type_display_order; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_type_display_order (
    id numeric(19,0) NOT NULL,
    discipline_type character varying(100),
    version_type character varying(100),
    "position" numeric(19,0)
);


ALTER TABLE public.f1000r_article_type_display_order OWNER TO f1000;

--
-- TOC entry 299 (class 1259 OID 114079)
-- Name: f1000r_article_type_display_order_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_type_display_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_type_display_order_seq OWNER TO f1000;

--
-- TOC entry 300 (class 1259 OID 114081)
-- Name: f1000r_article_view_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_article_view_log (
    id numeric(19,0) NOT NULL,
    view_date timestamp without time zone,
    article_id numeric(19,0)
);


ALTER TABLE public.f1000r_article_view_log OWNER TO f1000;

--
-- TOC entry 301 (class 1259 OID 114084)
-- Name: f1000r_article_view_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_article_view_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_article_view_log_seq OWNER TO f1000;

--
-- TOC entry 302 (class 1259 OID 114086)
-- Name: f1000r_asset; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset (
    id numeric(19,0) NOT NULL,
    status character varying(50),
    asset_metadata_id numeric(19,0) NOT NULL,
    asset_type character varying(50) NOT NULL,
    doi character varying(200),
    main_asset boolean DEFAULT false,
    last_updated timestamp without time zone,
    notes text,
    editor_id numeric(19,0),
    presenter_id numeric(19,0),
    presented_at_conference boolean DEFAULT false,
    published_date timestamp without time zone,
    publication_number numeric(6,0),
    volume numeric(2,0),
    thumbnail_id numeric(19,0),
    asset_file_id numeric(19,0),
    original_file_id numeric(19,0),
    views_count integer DEFAULT 0,
    downloads_count integer DEFAULT 0,
    monthly_views_count integer DEFAULT 0,
    hide_for_editors boolean DEFAULT false,
    f1000_id numeric(19,0),
    em_status character varying(100),
    citation_name character varying(100),
    main_collection_id numeric(19,0),
    compressed_status character varying(100) DEFAULT 'NOT_COMPRESSED'::character varying,
    archived boolean DEFAULT false,
    compressed_file_id numeric(19,0),
    evaluation_id numeric(19,0),
    thumbnail_status character varying(100) DEFAULT 'NOT_PROCESSED'::character varying,
    converted_file_id numeric(19,0),
    conversion_status character varying(100) DEFAULT 'NOT_PROCESSED'::character varying,
    indexed boolean DEFAULT false,
    unpublished_reason character varying(50),
    contract_signed boolean DEFAULT false,
    cc_license_agreed boolean DEFAULT false,
    author_declaration_author boolean DEFAULT false,
    author_declaration_all_authors_agreed boolean DEFAULT false,
    author_declaration_all_author_have_permissions boolean DEFAULT false,
    author_declaration_not_published boolean DEFAULT false,
    author_contributions text,
    data_availability text,
    do_not_encourage_submission boolean DEFAULT false,
    feature_asset boolean DEFAULT false,
    website_id numeric(19,0),
    document_type_id numeric(19,0),
    cc_by_nc_sa_license_agreed boolean DEFAULT false,
    prime_recommended boolean DEFAULT false,
    citation_text text
);


ALTER TABLE public.f1000r_asset OWNER TO f1000;

--
-- TOC entry 303 (class 1259 OID 114113)
-- Name: f1000r_asset_affiliation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_affiliation (
    id numeric(19,0) NOT NULL,
    city character varying(255),
    country_id numeric,
    department character varying(255),
    institution character varying(255),
    f1000_id numeric(19,0),
    department_id numeric(19,0),
    state character varying(255),
    place character varying(255),
    unique_id uuid
);


ALTER TABLE public.f1000r_asset_affiliation OWNER TO f1000;

--
-- TOC entry 304 (class 1259 OID 114119)
-- Name: f1000r_asset_affiliation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_affiliation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_affiliation_seq OWNER TO f1000;

--
-- TOC entry 305 (class 1259 OID 114121)
-- Name: f1000r_asset_author; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_author (
    id numeric(19,0) NOT NULL,
    asset_metadata_id numeric(19,0),
    author_id numeric(19,0) NOT NULL,
    author_position numeric(19,0),
    corresponding boolean DEFAULT false
);


ALTER TABLE public.f1000r_asset_author OWNER TO f1000;

--
-- TOC entry 782 (class 1259 OID 13534084)
-- Name: f1000r_asset_author_affiliation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_author_affiliation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_author_affiliation_seq OWNER TO f1000;

--
-- TOC entry 306 (class 1259 OID 114125)
-- Name: f1000r_asset_author_affiliation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_author_affiliation (
    author_id numeric(19,0) NOT NULL,
    asset_metadata_id numeric(19,0) NOT NULL,
    affiliation_id numeric(19,0),
    affiliation_uid uuid,
    id numeric(19,0) DEFAULT nextval('public.f1000r_asset_author_affiliation_seq'::regclass) NOT NULL
);


ALTER TABLE public.f1000r_asset_author_affiliation OWNER TO f1000;

--
-- TOC entry 307 (class 1259 OID 114128)
-- Name: f1000r_asset_author_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_author_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_author_seq OWNER TO f1000;

--
-- TOC entry 308 (class 1259 OID 114130)
-- Name: f1000r_asset_classification; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_classification (
    asset_metadata_id numeric(19,0) NOT NULL,
    classification character varying(50)
);


ALTER TABLE public.f1000r_asset_classification OWNER TO f1000;

--
-- TOC entry 309 (class 1259 OID 114133)
-- Name: f1000r_asset_collection_suggestion; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_collection_suggestion (
    id numeric(19,0) NOT NULL,
    asset_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    decision character varying(255),
    preselected boolean DEFAULT false
);


ALTER TABLE public.f1000r_asset_collection_suggestion OWNER TO f1000;

--
-- TOC entry 310 (class 1259 OID 114137)
-- Name: f1000r_asset_collection_suggestion_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_collection_suggestion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_collection_suggestion_seq OWNER TO f1000;

--
-- TOC entry 311 (class 1259 OID 114139)
-- Name: f1000r_asset_country; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_country (
    asset_id numeric(19,0) NOT NULL,
    country_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_asset_country OWNER TO f1000;

--
-- TOC entry 312 (class 1259 OID 114142)
-- Name: f1000r_asset_department; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_department (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    institution_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_asset_department OWNER TO f1000;

--
-- TOC entry 313 (class 1259 OID 114145)
-- Name: f1000r_asset_department_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_department_seq
    START WITH 54
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_department_seq OWNER TO f1000;

--
-- TOC entry 314 (class 1259 OID 114147)
-- Name: f1000r_asset_editor_submitter_view; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_editor_submitter_view (
    id numeric(19,0) NOT NULL,
    asset_view_id numeric(19,0) NOT NULL,
    first_name text,
    last_name text,
    full_name text,
    email text,
    asset_user_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_asset_editor_submitter_view OWNER TO f1000;

--
-- TOC entry 315 (class 1259 OID 114153)
-- Name: f1000r_asset_editor_submitter_view_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_editor_submitter_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_editor_submitter_view_seq OWNER TO f1000;

--
-- TOC entry 316 (class 1259 OID 114155)
-- Name: f1000r_asset_grant; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_grant (
    id numeric(19,0) NOT NULL,
    funder character varying(255) NOT NULL,
    grant_number character varying(255) NOT NULL,
    asset_metadata_id numeric(19,0),
    f1000_id numeric(19,0)
);


ALTER TABLE public.f1000r_asset_grant OWNER TO f1000;

--
-- TOC entry 317 (class 1259 OID 114161)
-- Name: f1000r_asset_grant_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_grant_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_grant_seq OWNER TO f1000;

--
-- TOC entry 318 (class 1259 OID 114163)
-- Name: f1000r_asset_institution; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_institution (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    included_in_gateway_default boolean DEFAULT true
);


ALTER TABLE public.f1000r_asset_institution OWNER TO f1000;

--
-- TOC entry 319 (class 1259 OID 114167)
-- Name: f1000r_asset_metadata; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_metadata (
    id numeric(19,0) NOT NULL,
    title character varying(5000) NOT NULL,
    language_id numeric(19,0),
    submitter_id numeric(19,0) NOT NULL,
    submit_date timestamp without time zone,
    creation_date timestamp without time zone NOT NULL,
    last_updated timestamp without time zone,
    grant_information boolean DEFAULT false,
    competing_interests boolean DEFAULT false,
    competing_interests_text text,
    keywords character varying(1000),
    summary text,
    f1000_id numeric(19,0),
    nih_text_license boolean DEFAULT false,
    license character varying(100) DEFAULT 'CC_BY'::character varying NOT NULL,
    license_version character varying(10) DEFAULT '4.0'::character varying NOT NULL,
    grant_information_text text,
    linked_asset_text text,
    grant_id text,
    new_asset_flag boolean DEFAULT false,
    is_new_asset boolean DEFAULT false
);


ALTER TABLE public.f1000r_asset_metadata OWNER TO f1000;

--
-- TOC entry 320 (class 1259 OID 114180)
-- Name: f1000r_asset_metadata_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_metadata_seq
    START WITH 1000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_metadata_seq OWNER TO f1000;

--
-- TOC entry 321 (class 1259 OID 114182)
-- Name: f1000r_asset_related_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_related_article (
    asset_metadata_id numeric(19,0) NOT NULL,
    article_id character varying(255) NOT NULL
);


ALTER TABLE public.f1000r_asset_related_article OWNER TO f1000;

--
-- TOC entry 322 (class 1259 OID 114185)
-- Name: f1000r_asset_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_seq
    START WITH 1000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_seq OWNER TO f1000;

--
-- TOC entry 323 (class 1259 OID 114187)
-- Name: f1000r_asset_share_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_share_log (
    id numeric(19,0) NOT NULL,
    share_date timestamp without time zone,
    asset_id numeric(19,0),
    share_type character varying(50)
);


ALTER TABLE public.f1000r_asset_share_log OWNER TO f1000;

--
-- TOC entry 324 (class 1259 OID 114190)
-- Name: f1000r_asset_share_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_share_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_share_log_seq OWNER TO f1000;

--
-- TOC entry 325 (class 1259 OID 114192)
-- Name: f1000r_asset_submitter_view; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_submitter_view (
    id numeric(19,0) NOT NULL,
    first_name text,
    last_name text,
    full_name text,
    email text,
    asset_user_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_asset_submitter_view OWNER TO f1000;

--
-- TOC entry 326 (class 1259 OID 114198)
-- Name: f1000r_asset_submitter_view_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_submitter_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_submitter_view_seq OWNER TO f1000;

--
-- TOC entry 327 (class 1259 OID 114200)
-- Name: f1000r_asset_supplementary_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_supplementary_file (
    id numeric(19,0) NOT NULL,
    asset_id numeric(19,0) NOT NULL,
    supplementary_file_id numeric(19,0) NOT NULL,
    "position" numeric(3,0)
);


ALTER TABLE public.f1000r_asset_supplementary_file OWNER TO f1000;

--
-- TOC entry 328 (class 1259 OID 114203)
-- Name: f1000r_asset_supplementary_file_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_supplementary_file_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_supplementary_file_seq OWNER TO f1000;

--
-- TOC entry 329 (class 1259 OID 114205)
-- Name: f1000r_asset_thesaurus_term; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_thesaurus_term (
    id numeric(19,0) NOT NULL,
    asset_id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL,
    from_algorithm boolean DEFAULT false,
    shown boolean DEFAULT false
);


ALTER TABLE public.f1000r_asset_thesaurus_term OWNER TO f1000;

--
-- TOC entry 330 (class 1259 OID 114210)
-- Name: f1000r_asset_thesaurus_term_f1000ont; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_thesaurus_term_f1000ont (
    id numeric(19,0) NOT NULL,
    asset_id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL,
    from_algorithm boolean,
    shown boolean
);


ALTER TABLE public.f1000r_asset_thesaurus_term_f1000ont OWNER TO f1000;

--
-- TOC entry 331 (class 1259 OID 114213)
-- Name: f1000r_asset_thesaurus_term_f1000ont_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_thesaurus_term_f1000ont_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_thesaurus_term_f1000ont_seq OWNER TO f1000;

--
-- TOC entry 332 (class 1259 OID 114215)
-- Name: f1000r_asset_thesaurus_term_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_thesaurus_term_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_thesaurus_term_seq OWNER TO f1000;

--
-- TOC entry 333 (class 1259 OID 114217)
-- Name: f1000r_asset_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_topic (
    asset_metadata_id numeric(19,0) NOT NULL,
    topic_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_asset_topic OWNER TO f1000;

--
-- TOC entry 334 (class 1259 OID 114220)
-- Name: f1000r_asset_upload_info; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_upload_info (
    id numeric(19,0) NOT NULL,
    mime_type character varying(255),
    file_type character varying(50) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(32),
    file_size numeric(19,0) DEFAULT 0,
    f1000_id numeric(19,0),
    asset_id numeric(19,0)
);


ALTER TABLE public.f1000r_asset_upload_info OWNER TO f1000;

--
-- TOC entry 335 (class 1259 OID 114227)
-- Name: f1000r_asset_upload_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_upload_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_upload_info_seq OWNER TO f1000;

--
-- TOC entry 336 (class 1259 OID 114229)
-- Name: f1000r_asset_view; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_view (
    id numeric(19,0) NOT NULL,
    asset_platform_id numeric(19,0) NOT NULL,
    published_date numeric(19,0),
    title character varying(5000),
    url text,
    type_asset text,
    last_updated numeric(19,0),
    status text,
    platform_id numeric NOT NULL,
    editor text,
    asset_submitter_view_id numeric(19,0),
    unpublished_reason text,
    indexed boolean DEFAULT false
);


ALTER TABLE public.f1000r_asset_view OWNER TO f1000;

--
-- TOC entry 337 (class 1259 OID 114236)
-- Name: f1000r_asset_view_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_asset_view_log (
    id numeric(19,0) NOT NULL,
    view_date timestamp without time zone,
    asset_id numeric(19,0)
);


ALTER TABLE public.f1000r_asset_view_log OWNER TO f1000;

--
-- TOC entry 338 (class 1259 OID 114239)
-- Name: f1000r_asset_view_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_view_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_view_log_seq OWNER TO f1000;

--
-- TOC entry 339 (class 1259 OID 114241)
-- Name: f1000r_asset_view_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_asset_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_asset_view_seq OWNER TO f1000;

--
-- TOC entry 340 (class 1259 OID 114243)
-- Name: f1000r_attachment_email_info; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_attachment_email_info (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    email_tracking_id numeric(19,0),
    status character varying(32),
    file_size numeric(19,0) DEFAULT 0
);


ALTER TABLE public.f1000r_attachment_email_info OWNER TO f1000;

--
-- TOC entry 341 (class 1259 OID 114250)
-- Name: f1000r_author; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author (
    id numeric(19,0) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    collective_name character varying(255),
    f1000_id numeric(19,0)
);


ALTER TABLE public.f1000r_author OWNER TO f1000;

--
-- TOC entry 342 (class 1259 OID 114256)
-- Name: f1000r_author_aff_draft_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_author_aff_draft_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_author_aff_draft_seq OWNER TO f1000;

--
-- TOC entry 343 (class 1259 OID 114258)
-- Name: f1000r_author_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_author_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_author_seq OWNER TO f1000;

--
-- TOC entry 344 (class 1259 OID 114260)
-- Name: f1000r_author_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author_version (
    author_id numeric(19,0),
    version_id numeric(19,0),
    author_position numeric,
    corresponding boolean DEFAULT false NOT NULL,
    equal_contributor boolean DEFAULT false NOT NULL,
    deceased boolean DEFAULT false NOT NULL,
    id numeric(19,0) NOT NULL,
    invalid_email boolean DEFAULT false,
    cc boolean DEFAULT false,
    user_id numeric(19,0),
    collective_author_file_id numeric(19,0)
);


ALTER TABLE public.f1000r_author_version OWNER TO f1000;

--
-- TOC entry 345 (class 1259 OID 114271)
-- Name: f1000r_author_version_affiliation_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author_version_affiliation_draft (
    id numeric(19,0) NOT NULL,
    author_version_draft_id numeric(19,0) NOT NULL,
    affiliation_full_text text,
    affiliation_id numeric(19,0),
    affiliation_position integer,
    affiliation_uid uuid
);


ALTER TABLE public.f1000r_author_version_affiliation_draft OWNER TO f1000;

--
-- TOC entry 346 (class 1259 OID 114277)
-- Name: f1000r_author_version_contributor_role; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author_version_contributor_role (
    author_version_id numeric(19,0) NOT NULL,
    contributor_role_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_author_version_contributor_role OWNER TO f1000;

--
-- TOC entry 347 (class 1259 OID 114280)
-- Name: f1000r_author_version_contributor_role_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author_version_contributor_role_draft (
    author_version_draft_id numeric(19,0) NOT NULL,
    contributor_role_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_author_version_contributor_role_draft OWNER TO f1000;

--
-- TOC entry 348 (class 1259 OID 114283)
-- Name: f1000r_author_version_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author_version_draft (
    id numeric(19,0) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    version_id numeric(19,0),
    corresponding boolean DEFAULT false NOT NULL,
    author_position numeric,
    collective_name character varying(255),
    previous_author_version_id numeric(19,0),
    deleted boolean DEFAULT false,
    user_id numeric(19,0),
    collective_author_file_id numeric(19,0)
);


ALTER TABLE public.f1000r_author_version_draft OWNER TO f1000;

--
-- TOC entry 349 (class 1259 OID 114291)
-- Name: f1000r_author_version_draft_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_author_version_draft_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_author_version_draft_seq OWNER TO f1000;

--
-- TOC entry 350 (class 1259 OID 114293)
-- Name: f1000r_author_version_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_author_version_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_author_version_seq OWNER TO f1000;

--
-- TOC entry 351 (class 1259 OID 114295)
-- Name: f1000r_author_view; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_author_view (
    id numeric(19,0) NOT NULL,
    asset_view_id numeric(19,0) NOT NULL,
    first_name text,
    last_name text,
    email text,
    collective_name text,
    collective boolean,
    author_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_author_view OWNER TO f1000;

--
-- TOC entry 352 (class 1259 OID 114301)
-- Name: f1000r_author_view_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_author_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_author_view_seq OWNER TO f1000;

--
-- TOC entry 353 (class 1259 OID 114303)
-- Name: f1000r_automatic_invoice_info; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_automatic_invoice_info (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(32),
    file_size numeric(19,0) DEFAULT 0,
    amount_requested numeric(15,2) NOT NULL,
    sent_to_accounts boolean DEFAULT false NOT NULL
);


ALTER TABLE public.f1000r_automatic_invoice_info OWNER TO f1000;

--
-- TOC entry 354 (class 1259 OID 114311)
-- Name: f1000r_automatic_invoice_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_automatic_invoice_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_automatic_invoice_info_seq OWNER TO f1000;

--
-- TOC entry 355 (class 1259 OID 114313)
-- Name: f1000r_citedby_data; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_citedby_data (
    version_id numeric(19,0) NOT NULL,
    doi character varying(50),
    scopus_url character varying(500),
    scopus_citedby_count integer DEFAULT 0,
    pubmed_id numeric(19,0),
    pubmed_citedby_count integer DEFAULT 0
);


ALTER TABLE public.f1000r_citedby_data OWNER TO f1000;

--
-- TOC entry 356 (class 1259 OID 114321)
-- Name: f1000r_co_author_email_notification_tracking; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_co_author_email_notification_tracking (
    id numeric(19,0) NOT NULL,
    author_version_id numeric(19,0),
    updated_date timestamp without time zone,
    is_sent boolean DEFAULT false
);


ALTER TABLE public.f1000r_co_author_email_notification_tracking OWNER TO f1000;

--
-- TOC entry 357 (class 1259 OID 114325)
-- Name: f1000r_co_author_email_notification_tracking_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_co_author_email_notification_tracking_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_co_author_email_notification_tracking_seq OWNER TO f1000;

--
-- TOC entry 358 (class 1259 OID 114327)
-- Name: f1000r_collection; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection (
    id numeric(19,0) NOT NULL,
    name character varying(1000),
    url character varying(255),
    created timestamp without time zone,
    banner_file_name character varying(1024),
    external_banner_url character varying(1024),
    short_summary text,
    thumbnail_file_name character varying(1024),
    published boolean DEFAULT false,
    doi_submit_status character varying(50),
    editorial_article_id numeric(19,0),
    description text,
    internal_short_name character varying(255),
    editorial_notes text,
    expected_pub_date timestamp without time zone,
    deadline_submissions timestamp without time zone,
    calls_for_papers text,
    subtitle text,
    exclude_calls_for_papers boolean DEFAULT false,
    calls_for_papers_title character varying(255),
    doi character varying(200),
    offer_expiry_date timestamp without time zone,
    call_for_paper_offer character varying(256),
    citation_name character varying(100),
    gateway_name character varying(100),
    gateway_position numeric(4,0) DEFAULT 0,
    is_closed_collection boolean DEFAULT false,
    posters_not_allowed boolean DEFAULT false,
    slides_not_allowed boolean DEFAULT false,
    featured_collection boolean DEFAULT false,
    preprints_not_allowed boolean DEFAULT false,
    referee_emails_blurb text,
    website_id numeric(19,0),
    channel_hidden boolean DEFAULT false,
    documents_not_allowed boolean DEFAULT true,
    allow_cc_by_nc_sa boolean DEFAULT false,
    document_publish_note character varying(500),
    show_country_filter boolean DEFAULT false,
    parent_gateway_id numeric(19,0),
    gateway boolean DEFAULT false,
    gateway_advertisement_text text,
    gateway_advertisement_banner_file_name character varying(1024),
    imported boolean DEFAULT false,
    wide_thumbnail_file_name character varying(1024),
    enable_homepage boolean DEFAULT false,
    use_wide_thumbnail_for_banner boolean DEFAULT true,
    home_url character varying(255),
    home_hero_image_file_name character varying(1024),
    home_hero_heading character varying(1024),
    home_hero_text character varying(1024),
    home_blog_url character varying(1024),
    home_heading character varying(1024),
    linkedin character varying(1024),
    twitter character varying(1024),
    facebook character varying(1024),
    youtube character varying(1024),
    home_text text,
    special_rules boolean DEFAULT false,
    special_rules_note text,
    browsable boolean DEFAULT true,
    home_hero_credit text,
    show_epmc boolean DEFAULT false,
    show_name_on_banner boolean DEFAULT true,
    has_faqs boolean DEFAULT false,
    faqs text,
    default_epmc text,
    institutional boolean DEFAULT false,
    home_disable_thumbnail boolean DEFAULT false,
    suppress_banner_mask boolean DEFAULT false,
    alternate_language character varying(255),
    gateway_payment_id numeric(19,0),
    product_code character varying,
    preprint_check_level character varying(100),
    hide_on_main_browse boolean DEFAULT false,
    homepage_wordpress_id numeric(19,0)
);


ALTER TABLE public.f1000r_collection OWNER TO f1000;

--
-- TOC entry 359 (class 1259 OID 114357)
-- Name: f1000r_collection_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_article (
    collection_id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    article_position numeric,
    added_to_collection_date timestamp without time zone
);


ALTER TABLE public.f1000r_collection_article OWNER TO f1000;

--
-- TOC entry 360 (class 1259 OID 114363)
-- Name: f1000r_collection_asset; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_asset (
    collection_id numeric(19,0) NOT NULL,
    asset_id numeric(19,0) NOT NULL,
    "position" numeric(4,0) DEFAULT 0
);


ALTER TABLE public.f1000r_collection_asset OWNER TO f1000;

--
-- TOC entry 795 (class 1259 OID 30964185)
-- Name: f1000r_collection_custompages_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_collection_custompages_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_collection_custompages_seq OWNER TO f1000;

--
-- TOC entry 796 (class 1259 OID 30964187)
-- Name: f1000r_collection_custompages; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_custompages (
    id numeric(19,0) DEFAULT nextval('public.f1000r_collection_custompages_seq'::regclass) NOT NULL,
    collection_id numeric(19,0),
    title character varying(1024),
    slug character varying(1024),
    wordpress_id numeric(19,0)
);


ALTER TABLE public.f1000r_collection_custompages OWNER TO f1000;

--
-- TOC entry 361 (class 1259 OID 114367)
-- Name: f1000r_collection_document_type; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_document_type (
    collection_id numeric(19,0) NOT NULL,
    document_type_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_collection_document_type OWNER TO f1000;

--
-- TOC entry 362 (class 1259 OID 114370)
-- Name: f1000r_collection_editorial_board_editors; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_editorial_board_editors (
    collection_id numeric(19,0) NOT NULL,
    user_collection_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_collection_editorial_board_editors OWNER TO f1000;

--
-- TOC entry 363 (class 1259 OID 114373)
-- Name: f1000r_collection_guest_editors; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_guest_editors (
    collection_id numeric(19,0) NOT NULL,
    user_collection_id numeric(19,0) NOT NULL,
    "position" integer
);


ALTER TABLE public.f1000r_collection_guest_editors OWNER TO f1000;

--
-- TOC entry 364 (class 1259 OID 114376)
-- Name: f1000r_collection_link; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_link (
    id numeric(19,0) NOT NULL,
    collection_id numeric(19,0),
    label character varying(1024),
    url character varying(1024),
    "position" numeric(3,0) DEFAULT 0
);


ALTER TABLE public.f1000r_collection_link OWNER TO f1000;

--
-- TOC entry 365 (class 1259 OID 114383)
-- Name: f1000r_collection_link_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_collection_link_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_collection_link_seq OWNER TO f1000;

--
-- TOC entry 366 (class 1259 OID 114385)
-- Name: f1000r_collection_news; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_news (
    id numeric(19,0) NOT NULL,
    collection_id numeric(19,0),
    title character varying(1024),
    date_added timestamp without time zone,
    description text,
    url character varying(1024)
);


ALTER TABLE public.f1000r_collection_news OWNER TO f1000;

--
-- TOC entry 367 (class 1259 OID 114391)
-- Name: f1000r_collection_news_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_collection_news_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_collection_news_seq OWNER TO f1000;

--
-- TOC entry 368 (class 1259 OID 114393)
-- Name: f1000r_collection_related_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_related_article (
    collection_id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    article_position numeric
);


ALTER TABLE public.f1000r_collection_related_article OWNER TO f1000;

--
-- TOC entry 369 (class 1259 OID 114399)
-- Name: f1000r_collection_research_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_research_topic (
    collection_id numeric NOT NULL,
    research_topic_id numeric NOT NULL
);


ALTER TABLE public.f1000r_collection_research_topic OWNER TO f1000;

--
-- TOC entry 370 (class 1259 OID 114405)
-- Name: f1000r_collection_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_collection_seq OWNER TO f1000;

--
-- TOC entry 371 (class 1259 OID 114407)
-- Name: f1000r_collection_sponsor; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_sponsor (
    id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    name character varying(1024),
    logo_file_name character varying(1024),
    url character varying(1024),
    sponsor_position numeric NOT NULL
);


ALTER TABLE public.f1000r_collection_sponsor OWNER TO f1000;

--
-- TOC entry 372 (class 1259 OID 114413)
-- Name: f1000r_collection_sponsor_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_collection_sponsor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_collection_sponsor_seq OWNER TO f1000;

--
-- TOC entry 373 (class 1259 OID 114415)
-- Name: f1000r_collection_tracking; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_tracking (
    user_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    tracked_date timestamp without time zone
);


ALTER TABLE public.f1000r_collection_tracking OWNER TO f1000;

--
-- TOC entry 374 (class 1259 OID 114418)
-- Name: f1000r_collection_urls_not_in_lowercase; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_urls_not_in_lowercase (
    id numeric(19,0),
    name character varying(1000),
    url character varying(255)
);


ALTER TABLE public.f1000r_collection_urls_not_in_lowercase OWNER TO f1000;

--
-- TOC entry 375 (class 1259 OID 114424)
-- Name: f1000r_collection_version_type; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_collection_version_type (
    collection_id numeric(19,0) NOT NULL,
    type character varying(255)
);


ALTER TABLE public.f1000r_collection_version_type OWNER TO f1000;

--
-- TOC entry 376 (class 1259 OID 114427)
-- Name: f1000r_comment; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_comment (
    id numeric(19,0) NOT NULL,
    text text,
    creation_date timestamp without time zone,
    usr_id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    moderated boolean DEFAULT false NOT NULL,
    report_id numeric(19,0),
    status character varying(50),
    notes text,
    author_comment boolean DEFAULT false,
    competing_interests text,
    objection boolean DEFAULT false,
    date_approved timestamp without time zone,
    excluded_from_dashboard boolean DEFAULT false,
    object_related_type character varying(100),
    asset_id numeric(19,0),
    f1000_id numeric(19,0),
    last_updated timestamp without time zone,
    affiliation_id numeric(19,0),
    affiliation_uid uuid
);


ALTER TABLE public.f1000r_comment OWNER TO f1000;

--
-- TOC entry 377 (class 1259 OID 114437)
-- Name: f1000r_comment_commenter_role; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_comment_commenter_role (
    comment_id numeric(19,0) NOT NULL,
    commenter_role character varying(100) NOT NULL
);


ALTER TABLE public.f1000r_comment_commenter_role OWNER TO f1000;

--
-- TOC entry 378 (class 1259 OID 114440)
-- Name: f1000r_comment_report; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_comment_report (
    comment_id numeric(19,0) NOT NULL,
    report_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_comment_report OWNER TO f1000;

--
-- TOC entry 379 (class 1259 OID 114443)
-- Name: f1000r_comment_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_comment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_comment_seq OWNER TO f1000;

--
-- TOC entry 380 (class 1259 OID 114445)
-- Name: f1000r_conference; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_conference (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    start_date date,
    end_date date,
    url character varying(500),
    approved_date timestamp without time zone,
    approver_id numeric(19,0),
    status character varying(50),
    f1000_id numeric(19,0),
    year numeric(4,0),
    solicited boolean DEFAULT false,
    website_id numeric(19,0)
);


ALTER TABLE public.f1000r_conference OWNER TO f1000;

--
-- TOC entry 381 (class 1259 OID 114452)
-- Name: f1000r_conference_detail; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_conference_detail (
    id numeric(19,0) NOT NULL,
    asset_metadata_id numeric(19,0) NOT NULL,
    conference_id numeric(19,0) NOT NULL,
    conference_poster_number character varying(255),
    f1000_id numeric(19,0)
);


ALTER TABLE public.f1000r_conference_detail OWNER TO f1000;

--
-- TOC entry 382 (class 1259 OID 114455)
-- Name: f1000r_conference_detail_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_conference_detail_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_conference_detail_seq OWNER TO f1000;

--
-- TOC entry 383 (class 1259 OID 114457)
-- Name: f1000r_conference_organization; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_conference_organization (
    conference_id numeric(19,0) NOT NULL,
    organization_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_conference_organization OWNER TO f1000;

--
-- TOC entry 384 (class 1259 OID 114460)
-- Name: f1000r_conference_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_conference_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_conference_seq OWNER TO f1000;

--
-- TOC entry 385 (class 1259 OID 114462)
-- Name: f1000r_conference_view; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_conference_view (
    id numeric(19,0) NOT NULL,
    conference_name text,
    approve boolean,
    conference_id numeric(19,0) NOT NULL,
    asset_view_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_conference_view OWNER TO f1000;

--
-- TOC entry 386 (class 1259 OID 114468)
-- Name: f1000r_conference_view_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_conference_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_conference_view_seq OWNER TO f1000;

--
-- TOC entry 387 (class 1259 OID 114470)
-- Name: f1000r_content; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_content (
    id numeric(19,0) NOT NULL,
    publication_id text NOT NULL,
    platform_id numeric(19,0) NOT NULL,
    content_type character varying(100),
    content_id numeric(19,0) NOT NULL,
    published_date timestamp without time zone,
    status text,
    facultyreview boolean,
    title text
);


ALTER TABLE public.f1000r_content OWNER TO f1000;

--
-- TOC entry 388 (class 1259 OID 114476)
-- Name: f1000r_content_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_content_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_content_seq OWNER TO f1000;

--
-- TOC entry 389 (class 1259 OID 114478)
-- Name: f1000r_content_usage_stats; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_content_usage_stats (
    id bigint NOT NULL,
    content_type character varying NOT NULL,
    content_id bigint NOT NULL,
    country_code character varying NOT NULL,
    views_count integer NOT NULL,
    downloads_count integer DEFAULT 0 NOT NULL,
    usage_date date DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.f1000r_content_usage_stats OWNER TO f1000;

--
-- TOC entry 390 (class 1259 OID 114486)
-- Name: f1000r_content_usage_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_content_usage_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_content_usage_stats_id_seq OWNER TO f1000;

--
-- TOC entry 7193 (class 0 OID 0)
-- Dependencies: 390
-- Name: f1000r_content_usage_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: f1000
--

ALTER SEQUENCE public.f1000r_content_usage_stats_id_seq OWNED BY public.f1000r_content_usage_stats.id;


--
-- TOC entry 391 (class 1259 OID 114488)
-- Name: f1000r_contributor_role; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_contributor_role (
    id numeric(19,0) NOT NULL,
    role_name character varying(255),
    role_definition text
);


ALTER TABLE public.f1000r_contributor_role OWNER TO f1000;

--
-- TOC entry 392 (class 1259 OID 114494)
-- Name: f1000r_contributor_role_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_contributor_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_contributor_role_seq OWNER TO f1000;

--
-- TOC entry 393 (class 1259 OID 114496)
-- Name: f1000r_corresponding_author_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_corresponding_author_version (
    author_id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_corresponding_author_version OWNER TO f1000;

--
-- TOC entry 394 (class 1259 OID 114499)
-- Name: f1000r_country_nationality; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_country_nationality (
    country_id numeric(19,0) NOT NULL,
    nationality_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_country_nationality OWNER TO f1000;

--
-- TOC entry 395 (class 1259 OID 114502)
-- Name: f1000r_crosscheck; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_crosscheck (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    status character varying(20) NOT NULL,
    document_id integer,
    message character varying,
    approvedby_usr_id numeric(19,0)
);


ALTER TABLE public.f1000r_crosscheck OWNER TO f1000;

--
-- TOC entry 396 (class 1259 OID 114508)
-- Name: f1000r_crosscheck_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_crosscheck_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_crosscheck_seq OWNER TO f1000;

--
-- TOC entry 397 (class 1259 OID 114510)
-- Name: f1000r_currency_rate; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_currency_rate (
    currency character varying(3) NOT NULL,
    rate numeric(19,6) NOT NULL,
    symbol character(1) NOT NULL
);


ALTER TABLE public.f1000r_currency_rate OWNER TO f1000;

--
-- TOC entry 398 (class 1259 OID 114513)
-- Name: f1000r_dashboard_layout; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_dashboard_layout (
    id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL,
    pos numeric(19,0),
    module_name character varying(150)
);


ALTER TABLE public.f1000r_dashboard_layout OWNER TO f1000;

--
-- TOC entry 399 (class 1259 OID 114516)
-- Name: f1000r_dashboard_layout_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_dashboard_layout_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_dashboard_layout_seq OWNER TO f1000;

--
-- TOC entry 400 (class 1259 OID 114518)
-- Name: f1000r_dashboard_module_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_dashboard_module_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_dashboard_module_seq OWNER TO f1000;

--
-- TOC entry 401 (class 1259 OID 114520)
-- Name: f1000r_document_type; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_document_type (
    id numeric(19,0) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1000) NOT NULL,
    default_submitter boolean DEFAULT false,
    CONSTRAINT non_empty_description CHECK (((description)::text <> ''::text)),
    CONSTRAINT non_empty_name CHECK (((name)::text <> ''::text))
);


ALTER TABLE public.f1000r_document_type OWNER TO f1000;

--
-- TOC entry 402 (class 1259 OID 114529)
-- Name: f1000r_document_type_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_document_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_document_type_seq OWNER TO f1000;

--
-- TOC entry 403 (class 1259 OID 114531)
-- Name: f1000r_doi_status; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_doi_status (
    id numeric(19,0) NOT NULL,
    object_id numeric(10,0) NOT NULL,
    object_type character varying(100) NOT NULL,
    submission_status character varying(100),
    doi_provider character varying(100) NOT NULL
);


ALTER TABLE public.f1000r_doi_status OWNER TO f1000;

--
-- TOC entry 404 (class 1259 OID 114534)
-- Name: f1000r_doi_status_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_doi_status_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_doi_status_seq OWNER TO f1000;

--
-- TOC entry 405 (class 1259 OID 114536)
-- Name: f1000r_editor_external_count; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_editor_external_count (
    id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL,
    website_id numeric(19,0) NOT NULL,
    from_date timestamp without time zone NOT NULL
);


ALTER TABLE public.f1000r_editor_external_count OWNER TO f1000;

--
-- TOC entry 781 (class 1259 OID 8551245)
-- Name: f1000r_email_alert_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_email_alert_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_email_alert_seq OWNER TO f1000;

--
-- TOC entry 406 (class 1259 OID 114539)
-- Name: f1000r_email_alert; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_alert (
    id numeric DEFAULT nextval('public.f1000r_email_alert_seq'::regclass) NOT NULL,
    frequency character varying,
    email_address character varying(64),
    user_id numeric(19,0),
    last_sent date,
    uuid character varying(40),
    created timestamp without time zone,
    signedup_origin character varying(100),
    unsubscribed date,
    website_id numeric(19,0) DEFAULT 1 NOT NULL,
    unmodified_alert boolean DEFAULT true
);


ALTER TABLE public.f1000r_email_alert OWNER TO f1000;

--
-- TOC entry 407 (class 1259 OID 114547)
-- Name: f1000r_email_alert_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_alert_log (
    id numeric(19,0) NOT NULL,
    alert_type character varying(100) NOT NULL,
    updated_date timestamp without time zone,
    frequency character varying,
    user_id numeric(19,0),
    email_alert_id numeric(19,0),
    is_following_items boolean
);


ALTER TABLE public.f1000r_email_alert_log OWNER TO f1000;

--
-- TOC entry 408 (class 1259 OID 114553)
-- Name: f1000r_email_alert_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_email_alert_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_email_alert_log_seq OWNER TO f1000;

--
-- TOC entry 409 (class 1259 OID 114555)
-- Name: f1000r_email_internal; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_internal (
    id numeric(19,0) NOT NULL,
    subject text,
    content text,
    user_id_from numeric(19,0) NOT NULL,
    type character varying(255) NOT NULL,
    data_id numeric(19,0) NOT NULL,
    tracking_date timestamp without time zone NOT NULL,
    is_read boolean DEFAULT false,
    status character varying(100) DEFAULT 'ACTIVE'::character varying
);


ALTER TABLE public.f1000r_email_internal OWNER TO f1000;

--
-- TOC entry 410 (class 1259 OID 114563)
-- Name: f1000r_email_internal_recipients; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_internal_recipients (
    email_internal_id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_email_internal_recipients OWNER TO f1000;

--
-- TOC entry 411 (class 1259 OID 114566)
-- Name: f1000r_email_internal_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_email_internal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_email_internal_seq OWNER TO f1000;

--
-- TOC entry 412 (class 1259 OID 114568)
-- Name: f1000r_email_message; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_message (
    id numeric(19,0) NOT NULL,
    author_id numeric(19,0),
    referee_id numeric(19,0),
    article_id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    sender_address text,
    recipient_address text,
    subject text,
    body_content text,
    version_id numeric(19,0),
    website_id numeric(19,0),
    miscellaneous boolean DEFAULT false,
    status_referee text,
    is_corresponding boolean DEFAULT false,
    sender_date timestamp without time zone,
    receiver_date timestamp without time zone,
    is_coreferee boolean
);


ALTER TABLE public.f1000r_email_message OWNER TO f1000;

--
-- TOC entry 413 (class 1259 OID 114576)
-- Name: f1000r_email_message_attachement; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_message_attachement (
    id numeric(19,0) NOT NULL,
    email_message_id numeric(19,0),
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    created timestamp without time zone,
    file_extension text,
    file_size numeric(19,0)
);


ALTER TABLE public.f1000r_email_message_attachement OWNER TO f1000;

--
-- TOC entry 414 (class 1259 OID 114582)
-- Name: f1000r_email_message_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_email_message_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_email_message_seq OWNER TO f1000;

--
-- TOC entry 415 (class 1259 OID 114584)
-- Name: f1000r_email_template; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_template (
    id numeric(19,0) NOT NULL,
    type character varying(255),
    subject character varying(255),
    content text,
    current boolean DEFAULT false,
    updated_date timestamp without time zone,
    notes text,
    website_id numeric(19,0) DEFAULT 1 NOT NULL,
    alternate_language character varying(255)
);


ALTER TABLE public.f1000r_email_template OWNER TO f1000;

--
-- TOC entry 416 (class 1259 OID 114592)
-- Name: f1000r_email_template_ore_temp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_template_ore_temp (
    id numeric(19,0),
    type character varying(255),
    subject character varying(255),
    content text,
    current boolean,
    updated_date timestamp without time zone,
    notes text,
    website_id numeric(19,0),
    alternate_language character varying(255)
);


ALTER TABLE public.f1000r_email_template_ore_temp OWNER TO f1000;

--
-- TOC entry 417 (class 1259 OID 114598)
-- Name: f1000r_email_template_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_email_template_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_email_template_seq OWNER TO f1000;

--
-- TOC entry 418 (class 1259 OID 114600)
-- Name: f1000r_email_tracking; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_email_tracking (
    id numeric(19,0) NOT NULL,
    subject text,
    content text,
    sent_from character varying(255) NOT NULL,
    sent_to text,
    sent_cc text,
    sent_bcc text,
    type character varying(255) NOT NULL,
    data_id numeric(19,0) NOT NULL,
    tracking_date timestamp without time zone NOT NULL,
    is_encrypted boolean DEFAULT false,
    sub_data_id numeric(19,0)
);


ALTER TABLE public.f1000r_email_tracking OWNER TO f1000;

--
-- TOC entry 419 (class 1259 OID 114607)
-- Name: f1000r_email_tracking_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_email_tracking_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_email_tracking_seq OWNER TO f1000;

--
-- TOC entry 420 (class 1259 OID 114609)
-- Name: f1000r_enquiry_reason; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_enquiry_reason (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    enquiry_author_status text,
    concern_status text,
    reason_enabled boolean
);


ALTER TABLE public.f1000r_enquiry_reason OWNER TO f1000;

--
-- TOC entry 421 (class 1259 OID 114615)
-- Name: f1000r_enquiry_reason_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_enquiry_reason_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_enquiry_reason_seq OWNER TO f1000;

--
-- TOC entry 422 (class 1259 OID 114617)
-- Name: f1000r_enquiry_reason_template; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_enquiry_reason_template (
    id numeric(19,0) NOT NULL,
    type character varying(255),
    content text,
    website_id numeric(19,0),
    alternate_language character varying(255)
);


ALTER TABLE public.f1000r_enquiry_reason_template OWNER TO f1000;

--
-- TOC entry 423 (class 1259 OID 114623)
-- Name: f1000r_enquiry_reason_template_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_enquiry_reason_template_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_enquiry_reason_template_seq OWNER TO f1000;

--
-- TOC entry 424 (class 1259 OID 114625)
-- Name: f1000r_enquiry_reason_template_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_enquiry_reason_template_version (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    reason_temp_text text,
    reason_type text,
    reason_email_sent boolean DEFAULT false
);


ALTER TABLE public.f1000r_enquiry_reason_template_version OWNER TO f1000;

--
-- TOC entry 425 (class 1259 OID 114632)
-- Name: f1000r_enquiry_reason_template_version_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_enquiry_reason_template_version_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_enquiry_reason_template_version_seq OWNER TO f1000;

--
-- TOC entry 426 (class 1259 OID 114634)
-- Name: f1000r_etoc_alert_term; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_etoc_alert_term (
    id numeric(19,0) NOT NULL,
    email_alert_id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL,
    parent_id numeric(19,0),
    created timestamp without time zone,
    parent boolean,
    checked boolean
);


ALTER TABLE public.f1000r_etoc_alert_term OWNER TO f1000;

--
-- TOC entry 427 (class 1259 OID 114637)
-- Name: f1000r_etoc_alert_term_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_etoc_alert_term_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_etoc_alert_term_seq OWNER TO f1000;

--
-- TOC entry 428 (class 1259 OID 114639)
-- Name: f1000r_external_api_user_authentication; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_external_api_user_authentication (
    id numeric(19,0) NOT NULL,
    ip character varying(100),
    date_access timestamp without time zone
);


ALTER TABLE public.f1000r_external_api_user_authentication OWNER TO f1000;

--
-- TOC entry 429 (class 1259 OID 114642)
-- Name: f1000r_external_api_user_authentication_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_external_api_user_authentication_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_external_api_user_authentication_seq OWNER TO f1000;

--
-- TOC entry 430 (class 1259 OID 114644)
-- Name: f1000r_external_indexer_submission; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_external_indexer_submission (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    sent_to_indexer boolean,
    revision_number numeric(3,0),
    indexer character varying(100),
    number_of_attempts integer DEFAULT 0
);


ALTER TABLE public.f1000r_external_indexer_submission OWNER TO f1000;

--
-- TOC entry 431 (class 1259 OID 114647)
-- Name: f1000r_external_indexer_submission_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_external_indexer_submission_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_external_indexer_submission_seq OWNER TO f1000;

--
-- TOC entry 432 (class 1259 OID 114649)
-- Name: f1000r_external_item; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_external_item (
    id numeric(19,0) NOT NULL,
    internal_id numeric(19,0) NOT NULL,
    external_id numeric(19,0) NOT NULL,
    website_id numeric(19,0) NOT NULL,
    type character varying(50) NOT NULL
);


ALTER TABLE public.f1000r_external_item OWNER TO f1000;

--
-- TOC entry 433 (class 1259 OID 114652)
-- Name: f1000r_external_item_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_external_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_external_item_seq OWNER TO f1000;

--
-- TOC entry 434 (class 1259 OID 114654)
-- Name: f1000r_external_submission_data; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_external_submission_data (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    external_id character varying(255),
    ext_submit_confirmation_url character varying(500),
    ext_publish_confirmation_url character varying(500),
    ext_new_version_url character varying(500),
    external_source character varying(100)
);


ALTER TABLE public.f1000r_external_submission_data OWNER TO f1000;

--
-- TOC entry 435 (class 1259 OID 114660)
-- Name: f1000r_external_submission_data_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_external_submission_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_external_submission_data_seq OWNER TO f1000;

--
-- TOC entry 436 (class 1259 OID 114662)
-- Name: f1000r_featured_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_featured_article (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    thumbnail_file_name character varying(1204),
    author_text text,
    title text,
    updated_date timestamp without time zone
);


ALTER TABLE public.f1000r_featured_article OWNER TO f1000;

--
-- TOC entry 437 (class 1259 OID 114668)
-- Name: f1000r_featured_article_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_featured_article_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_featured_article_seq OWNER TO f1000;

--
-- TOC entry 438 (class 1259 OID 114670)
-- Name: f1000r_featured_blog_post; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_featured_blog_post (
    id numeric(19,0) NOT NULL,
    blog_url character varying(1204),
    blog_title text,
    blog_text text,
    date_posted timestamp without time zone,
    updated_date timestamp without time zone
);


ALTER TABLE public.f1000r_featured_blog_post OWNER TO f1000;

--
-- TOC entry 439 (class 1259 OID 114676)
-- Name: f1000r_featured_blog_post_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_featured_blog_post_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_featured_blog_post_seq OWNER TO f1000;

--
-- TOC entry 440 (class 1259 OID 114678)
-- Name: f1000r_featured_collection; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_featured_collection (
    id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    thumbnail_file_name character varying(1204),
    updated_date timestamp without time zone
);


ALTER TABLE public.f1000r_featured_collection OWNER TO f1000;

--
-- TOC entry 441 (class 1259 OID 114684)
-- Name: f1000r_featured_collection_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_featured_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_featured_collection_seq OWNER TO f1000;

--
-- TOC entry 442 (class 1259 OID 114686)
-- Name: f1000r_featured_report; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_featured_report (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    referee_text text,
    report_text text,
    updated_date timestamp without time zone,
    article_author_snippet text,
    thumbnail_file_name character varying(1024),
    referee_id numeric(19,0)
);


ALTER TABLE public.f1000r_featured_report OWNER TO f1000;

--
-- TOC entry 443 (class 1259 OID 114692)
-- Name: f1000r_featured_report_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_featured_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_featured_report_seq OWNER TO f1000;

--
-- TOC entry 444 (class 1259 OID 114694)
-- Name: f1000r_feedback; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_feedback (
    id numeric(19,0) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    institution character varying(255),
    website_id numeric(19,0),
    affiliated_with_funder boolean DEFAULT false,
    enquiry_date timestamp without time zone,
    terms_id numeric(19,0),
    agreement_text text,
    header_text text,
    country text,
    funding_risk_area text
);


ALTER TABLE public.f1000r_feedback OWNER TO f1000;

--
-- TOC entry 445 (class 1259 OID 114701)
-- Name: f1000r_feedback_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_feedback_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_feedback_seq OWNER TO f1000;

--
-- TOC entry 446 (class 1259 OID 114703)
-- Name: f1000r_feedback_terms; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_feedback_terms (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    terms text NOT NULL,
    gateway_name text
);


ALTER TABLE public.f1000r_feedback_terms OWNER TO f1000;

--
-- TOC entry 447 (class 1259 OID 114709)
-- Name: f1000r_feedback_terms_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_feedback_terms_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_feedback_terms_seq OWNER TO f1000;

--
-- TOC entry 448 (class 1259 OID 114711)
-- Name: f1000r_funder_information; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_funder_information (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    grant_id text,
    funder text,
    funder_ref_id text,
    is_primary_funder boolean DEFAULT false NOT NULL
);


ALTER TABLE public.f1000r_funder_information OWNER TO f1000;

--
-- TOC entry 449 (class 1259 OID 114718)
-- Name: f1000r_funder_information_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_funder_information_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_funder_information_seq OWNER TO f1000;

--
-- TOC entry 450 (class 1259 OID 114720)
-- Name: f1000r_gateway_names; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_gateway_names (
    name character varying(1000),
    published boolean DEFAULT false
);


ALTER TABLE public.f1000r_gateway_names OWNER TO f1000;

--
-- TOC entry 775 (class 1259 OID 3276932)
-- Name: f1000r_gateway_payment; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_gateway_payment (
    id numeric(19,0) NOT NULL,
    apcpaid boolean DEFAULT false NOT NULL,
    customer_name character varying,
    customer_email character varying,
    customer_aff character varying,
    customer_address character varying DEFAULT ''::character varying,
    customer_address1 character varying DEFAULT ''::character varying,
    customer_address2 character varying DEFAULT ''::character varying,
    customer_postal_code character varying DEFAULT ''::character varying,
    country_cou_id numeric(19,0),
    currency character varying DEFAULT ''::character varying,
    exchange_rate numeric(19,6),
    requested_rate numeric(19,2),
    payment_type character varying(20),
    cost_type character varying(30),
    full_price boolean DEFAULT true NOT NULL,
    set_price_selected boolean DEFAULT false,
    set_price_value numeric DEFAULT 0.00,
    manual_discount character varying,
    agreed_payment boolean DEFAULT false,
    waive_payment_option character varying,
    notes_to_accounts text,
    customer_city character varying DEFAULT ''::character varying,
    ringgold_id character varying,
    customer_state character varying(255)
);


ALTER TABLE public.f1000r_gateway_payment OWNER TO f1000;

--
-- TOC entry 774 (class 1259 OID 3276930)
-- Name: f1000r_gateway_payment_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_gateway_payment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_gateway_payment_seq OWNER TO f1000;

--
-- TOC entry 451 (class 1259 OID 114727)
-- Name: f1000r_grant_information; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_grant_information (
    id numeric(19,0) NOT NULL,
    first_name text,
    last_name text,
    grant_id text,
    version_id numeric(19,0) NOT NULL,
    funder text,
    title text
);


ALTER TABLE public.f1000r_grant_information OWNER TO f1000;

--
-- TOC entry 452 (class 1259 OID 114733)
-- Name: f1000r_grant_information_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_grant_information_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_grant_information_seq OWNER TO f1000;

--
-- TOC entry 453 (class 1259 OID 114735)
-- Name: f1000r_internal_advert_box; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_internal_advert_box (
    id numeric(19,0) NOT NULL,
    content_url character varying(1024),
    thumbnail_file_name character varying(1204)
);


ALTER TABLE public.f1000r_internal_advert_box OWNER TO f1000;

--
-- TOC entry 454 (class 1259 OID 114741)
-- Name: f1000r_internal_advert_box_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_internal_advert_box_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_internal_advert_box_seq OWNER TO f1000;

--
-- TOC entry 455 (class 1259 OID 114743)
-- Name: f1000r_invoice_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_invoice_file (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    file_size numeric(19,0),
    article_payment_id numeric(19,0),
    selected boolean DEFAULT false
);


ALTER TABLE public.f1000r_invoice_file OWNER TO f1000;

--
-- TOC entry 456 (class 1259 OID 114750)
-- Name: f1000r_invoice_number_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_invoice_number_seq
    START WITH 23000
    INCREMENT BY 1
    MINVALUE 23000
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_invoice_number_seq OWNER TO f1000;

--
-- TOC entry 457 (class 1259 OID 114752)
-- Name: f1000r_language; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_language (
    id numeric(19,0) NOT NULL,
    name character varying(255)
);


ALTER TABLE public.f1000r_language OWNER TO f1000;

--
-- TOC entry 458 (class 1259 OID 114755)
-- Name: f1000r_language_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_language_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_language_seq OWNER TO f1000;

--
-- TOC entry 459 (class 1259 OID 114757)
-- Name: f1000r_link_parser; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_link_parser (
    id numeric(19,0) NOT NULL,
    uuid character varying(36),
    type character varying(50),
    parameters character varying(1024)
);


ALTER TABLE public.f1000r_link_parser OWNER TO f1000;

--
-- TOC entry 460 (class 1259 OID 114763)
-- Name: f1000r_link_parser_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_link_parser_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_link_parser_seq OWNER TO f1000;

--
-- TOC entry 461 (class 1259 OID 114765)
-- Name: f1000r_linked_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_linked_file (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    file_size numeric(19,0),
    notes text
);


ALTER TABLE public.f1000r_linked_file OWNER TO f1000;

--
-- TOC entry 462 (class 1259 OID 114771)
-- Name: f1000r_living_figure_uploader_details; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_living_figure_uploader_details (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    uploader_name text,
    uploader_lab text,
    uploader_lab_address text,
    uploader_email_address character varying(255),
    uploader_lab_initials text,
    fly_genotype character varying(100),
    group_name character varying(100),
    upload_time timestamp without time zone,
    article_dataset_id numeric(19,0)
);


ALTER TABLE public.f1000r_living_figure_uploader_details OWNER TO f1000;

--
-- TOC entry 463 (class 1259 OID 114777)
-- Name: f1000r_logging_excluded_ip; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_logging_excluded_ip (
    id numeric NOT NULL,
    cidr_expression character varying(255),
    type character varying(255)
);


ALTER TABLE public.f1000r_logging_excluded_ip OWNER TO f1000;

--
-- TOC entry 464 (class 1259 OID 114783)
-- Name: f1000r_marketing_disease_waiver_code; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_marketing_disease_waiver_code (
    id numeric(19,0) NOT NULL,
    first_name character varying,
    last_name character varying,
    email character varying,
    organization character varying,
    disease_area character varying
);


ALTER TABLE public.f1000r_marketing_disease_waiver_code OWNER TO f1000;

--
-- TOC entry 465 (class 1259 OID 114789)
-- Name: f1000r_marketing_disease_waiver_code_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_marketing_disease_waiver_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_marketing_disease_waiver_code_seq OWNER TO f1000;

--
-- TOC entry 466 (class 1259 OID 114791)
-- Name: f1000r_media; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_media (
    id numeric(19,0) NOT NULL,
    title character varying(255),
    description text,
    content_url character varying(1024),
    pos numeric(19,0),
    published_date timestamp without time zone
);


ALTER TABLE public.f1000r_media OWNER TO f1000;

--
-- TOC entry 467 (class 1259 OID 114797)
-- Name: f1000r_media_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_media_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_media_seq OWNER TO f1000;

--
-- TOC entry 468 (class 1259 OID 114799)
-- Name: f1000r_msf_asset; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_msf_asset (
    id numeric(19,0) NOT NULL,
    poster_id numeric(19,0) NOT NULL,
    channel_name character varying(255),
    pos numeric(4,0) DEFAULT 0,
    asset_id numeric(19,0)
);


ALTER TABLE public.f1000r_msf_asset OWNER TO f1000;

--
-- TOC entry 469 (class 1259 OID 114803)
-- Name: f1000r_msf_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_msf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_msf_seq OWNER TO f1000;

--
-- TOC entry 470 (class 1259 OID 114808)
-- Name: f1000r_nationality_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_nationality_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_nationality_seq OWNER TO f1000;

--
-- TOC entry 471 (class 1259 OID 114810)
-- Name: f1000r_note; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_note (
    id numeric(19,0) NOT NULL,
    note_type character varying(100),
    notes text,
    article_id numeric(19,0),
    version_id numeric(19,0),
    article_referee_id numeric(19,0),
    editor_id numeric(19,0),
    created timestamp without time zone,
    priority boolean DEFAULT false,
    email_message_id numeric(19,0)
);


ALTER TABLE public.f1000r_note OWNER TO f1000;

--
-- TOC entry 472 (class 1259 OID 114817)
-- Name: f1000r_note_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_note_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_note_seq OWNER TO f1000;

--
-- TOC entry 792 (class 1259 OID 28552880)
-- Name: f1000r_opposed_reviewers_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_opposed_reviewers_draft (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0),
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    institution_name character varying
);


ALTER TABLE public.f1000r_opposed_reviewers_draft OWNER TO f1000;

--
-- TOC entry 791 (class 1259 OID 28552878)
-- Name: f1000r_opposed_reviewers_draft_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_opposed_reviewers_draft_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_opposed_reviewers_draft_seq OWNER TO f1000;

--
-- TOC entry 473 (class 1259 OID 114819)
-- Name: f1000r_organization; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_organization (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(500),
    created timestamp without time zone,
    last_updated timestamp without time zone,
    creator_id numeric(19,0) NOT NULL,
    status character varying(50),
    f1000_id numeric(19,0),
    website_id numeric(19,0)
);


ALTER TABLE public.f1000r_organization OWNER TO f1000;

--
-- TOC entry 474 (class 1259 OID 114825)
-- Name: f1000r_organization_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_organization_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_organization_seq OWNER TO f1000;

--
-- TOC entry 786 (class 1259 OID 15859943)
-- Name: f1000r_partner_target_selected_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_partner_target_selected_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_partner_target_selected_seq OWNER TO f1000;

--
-- TOC entry 787 (class 1259 OID 15859945)
-- Name: f1000r_partner_target_selected; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_partner_target_selected (
    id numeric(19,0) DEFAULT nextval('public.f1000r_partner_target_selected_seq'::regclass) NOT NULL,
    partner_id numeric(19,0) NOT NULL,
    target_id numeric(19,0) NOT NULL,
    target_type character varying(16) NOT NULL,
    selected boolean DEFAULT false
);


ALTER TABLE public.f1000r_partner_target_selected OWNER TO f1000;

--
-- TOC entry 784 (class 1259 OID 15859931)
-- Name: f1000r_partners_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_partners_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_partners_seq OWNER TO f1000;

--
-- TOC entry 785 (class 1259 OID 15859933)
-- Name: f1000r_partners; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_partners (
    id numeric(19,0) DEFAULT nextval('public.f1000r_partners_seq'::regclass) NOT NULL,
    partner_title character varying(255) NOT NULL
);


ALTER TABLE public.f1000r_partners OWNER TO f1000;

--
-- TOC entry 475 (class 1259 OID 114827)
-- Name: f1000r_paypal_ipn_log_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_paypal_ipn_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_paypal_ipn_log_id_seq OWNER TO f1000;

--
-- TOC entry 476 (class 1259 OID 114829)
-- Name: f1000r_paypal_payment; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_paypal_payment (
    id numeric(19,0) NOT NULL,
    paypal_payment_status character varying(255),
    paypal_product_id character varying
);


ALTER TABLE public.f1000r_paypal_payment OWNER TO f1000;

--
-- TOC entry 477 (class 1259 OID 114835)
-- Name: f1000r_paypal_payment_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_paypal_payment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_paypal_payment_seq OWNER TO f1000;

--
-- TOC entry 478 (class 1259 OID 114837)
-- Name: f1000r_paypal_product; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_paypal_product (
    id character varying NOT NULL,
    title character varying,
    button_code character varying,
    merchant_email character varying NOT NULL,
    amount numeric NOT NULL,
    discount numeric DEFAULT 0 NOT NULL,
    currency character varying NOT NULL,
    vat_included boolean DEFAULT false NOT NULL
);


ALTER TABLE public.f1000r_paypal_product OWNER TO f1000;

--
-- TOC entry 479 (class 1259 OID 114845)
-- Name: f1000r_permanently_deleted_user; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_permanently_deleted_user (
    user_id numeric(19,0) NOT NULL,
    added_date timestamp without time zone DEFAULT now(),
    status character varying(10) DEFAULT 'CREATED'::character varying
);


ALTER TABLE public.f1000r_permanently_deleted_user OWNER TO f1000;

--
-- TOC entry 480 (class 1259 OID 114850)
-- Name: f1000r_platform_user; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_platform_user (
    user_id numeric(19,0) NOT NULL,
    website_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_platform_user OWNER TO f1000;

--
-- TOC entry 481 (class 1259 OID 114853)
-- Name: f1000r_pmc_files_download; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_pmc_files_download (
    id numeric(19,0) NOT NULL,
    pmc_month numeric,
    pmc_year numeric,
    usage_date date,
    executed boolean
);


ALTER TABLE public.f1000r_pmc_files_download OWNER TO f1000;

--
-- TOC entry 482 (class 1259 OID 114859)
-- Name: f1000r_pmc_files_download_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_pmc_files_download_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_pmc_files_download_seq OWNER TO f1000;

--
-- TOC entry 483 (class 1259 OID 114861)
-- Name: f1000r_potential_referee_affiliations; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_potential_referee_affiliations (
    id numeric(19,0) NOT NULL,
    pot_ref_id numeric(19,0) NOT NULL,
    affiliation text
);


ALTER TABLE public.f1000r_potential_referee_affiliations OWNER TO f1000;

--
-- TOC entry 484 (class 1259 OID 114867)
-- Name: f1000r_potential_referee_refs; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_potential_referee_refs (
    id numeric(19,0) NOT NULL,
    pot_ref_id numeric(19,0) NOT NULL,
    title text,
    authors text,
    journal text,
    refdate timestamp without time zone,
    doi text
);


ALTER TABLE public.f1000r_potential_referee_refs OWNER TO f1000;

--
-- TOC entry 794 (class 1259 OID 29711972)
-- Name: f1000r_preprint_check_options; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_preprint_check_options (
    id numeric(19,0) NOT NULL,
    requested_check_level character varying(100) NOT NULL,
    verified_preprint_checked boolean DEFAULT false NOT NULL,
    open_data boolean DEFAULT false NOT NULL,
    reporting_guidelines boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    last_updated_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.f1000r_preprint_check_options OWNER TO f1000;

--
-- TOC entry 793 (class 1259 OID 29711970)
-- Name: f1000r_preprint_check_options_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_preprint_check_options_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_preprint_check_options_seq OWNER TO f1000;

--
-- TOC entry 7194 (class 0 OID 0)
-- Dependencies: 793
-- Name: f1000r_preprint_check_options_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: f1000
--

ALTER SEQUENCE public.f1000r_preprint_check_options_seq OWNED BY public.f1000r_preprint_check_options.id;


--
-- TOC entry 778 (class 1259 OID 6763403)
-- Name: f1000r_prescreening_feedback; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_prescreening_feedback (
    id numeric(19,0) NOT NULL,
    editors_full_name character varying(512),
    feedback text,
    rejection_reason character varying(100),
    user_id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    created timestamp without time zone
);


ALTER TABLE public.f1000r_prescreening_feedback OWNER TO f1000;

--
-- TOC entry 777 (class 1259 OID 6763401)
-- Name: f1000r_prescreening_feedback_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_prescreening_feedback_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_prescreening_feedback_seq OWNER TO f1000;

--
-- TOC entry 485 (class 1259 OID 114873)
-- Name: f1000r_presenter; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_presenter (
    id numeric(19,0) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255)
);


ALTER TABLE public.f1000r_presenter OWNER TO f1000;

--
-- TOC entry 486 (class 1259 OID 114879)
-- Name: f1000r_presenter_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_presenter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_presenter_seq OWNER TO f1000;

--
-- TOC entry 487 (class 1259 OID 114881)
-- Name: f1000r_prime_related_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_prime_related_article (
    article_id numeric(19,0) NOT NULL,
    url character varying(255) NOT NULL
);


ALTER TABLE public.f1000r_prime_related_article OWNER TO f1000;

--
-- TOC entry 488 (class 1259 OID 114884)
-- Name: f1000r_project_info; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_project_info (
    id numeric(19,0) NOT NULL,
    project_id character varying(32) NOT NULL,
    project_acronym text NOT NULL,
    project_title text NOT NULL,
    pic numeric(19,0) NOT NULL,
    country_code text NOT NULL,
    project_code character varying(255) NOT NULL
);


ALTER TABLE public.f1000r_project_info OWNER TO f1000;

--
-- TOC entry 489 (class 1259 OID 114890)
-- Name: f1000r_project_info_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_project_info_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_project_info_sequence OWNER TO f1000;

--
-- TOC entry 490 (class 1259 OID 114892)
-- Name: f1000r_project_info_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_project_info_version (
    id numeric(19,0) NOT NULL,
    project_id character varying(32) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    pic numeric(19,0) DEFAULT NULL::numeric
);


ALTER TABLE public.f1000r_project_info_version OWNER TO f1000;

--
-- TOC entry 491 (class 1259 OID 114896)
-- Name: f1000r_project_info_version_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_project_info_version_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_project_info_version_sequence OWNER TO f1000;

--
-- TOC entry 492 (class 1259 OID 114898)
-- Name: f1000r_promotional_code; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_promotional_code (
    id numeric(19,0) NOT NULL,
    code character varying(50) NOT NULL,
    campaign character varying,
    valid_from timestamp without time zone NOT NULL,
    valid_to timestamp without time zone NOT NULL,
    product_type character varying(20),
    waiver boolean,
    product_id character varying,
    times_used numeric(19,0) DEFAULT 0,
    discount_percentage character varying(20)
);


ALTER TABLE public.f1000r_promotional_code OWNER TO f1000;

--
-- TOC entry 493 (class 1259 OID 114905)
-- Name: f1000r_promotional_code_pricing_categories; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_promotional_code_pricing_categories (
    promotional_code_id numeric(19,0) NOT NULL,
    pricing_category character varying(20) NOT NULL
);


ALTER TABLE public.f1000r_promotional_code_pricing_categories OWNER TO f1000;

--
-- TOC entry 494 (class 1259 OID 114908)
-- Name: f1000r_promotional_code_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_promotional_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_promotional_code_seq OWNER TO f1000;

--
-- TOC entry 495 (class 1259 OID 114910)
-- Name: f1000r_published_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_published_version (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0),
    status character varying(255) NOT NULL,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.f1000r_published_version OWNER TO f1000;

--
-- TOC entry 496 (class 1259 OID 114914)
-- Name: f1000r_published_version_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_published_version_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_published_version_seq OWNER TO f1000;

--
-- TOC entry 497 (class 1259 OID 114916)
-- Name: f1000r_referee; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee (
    id numeric(19,0) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    contact_start date,
    editor_notes text,
    status character varying(100) DEFAULT 'ACTIVE'::character varying NOT NULL,
    last_status_changed timestamp without time zone NOT NULL,
    user_id numeric(19,0),
    exclude_in_experts_panel boolean DEFAULT true,
    created timestamp without time zone,
    affiliation_id numeric(19,0),
    nick_name text,
    chase_manually boolean DEFAULT false,
    is_automaton boolean DEFAULT false,
    affiliation_uid uuid
);


ALTER TABLE public.f1000r_referee OWNER TO f1000;

--
-- TOC entry 498 (class 1259 OID 114925)
-- Name: f1000r_referee_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_draft (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0),
    report_id numeric(19,0),
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    institution_name character varying,
    country_id numeric(19,0),
    department character varying(255),
    place character varying(64),
    zip_code character varying(64),
    referee_type character varying(100),
    state character varying(255),
    referee_match character varying(100),
    nick_name character varying(255),
    source_article_url character varying(255),
    source_article_published_date character varying(10),
    score numeric(5,2),
    active boolean DEFAULT true,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    suggested_institution character varying,
    country_code character varying(3)
);


ALTER TABLE public.f1000r_referee_draft OWNER TO f1000;

--
-- TOC entry 499 (class 1259 OID 114932)
-- Name: f1000r_referee_draft_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_draft_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_draft_seq OWNER TO f1000;

--
-- TOC entry 500 (class 1259 OID 114934)
-- Name: f1000r_referee_email; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_email (
    id numeric(19,0) NOT NULL,
    email character varying(255) NOT NULL,
    email_type character varying(20),
    referee_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_referee_email OWNER TO f1000;

--
-- TOC entry 501 (class 1259 OID 114937)
-- Name: f1000r_referee_email_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_email_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_email_seq OWNER TO f1000;

--
-- TOC entry 502 (class 1259 OID 114939)
-- Name: f1000r_referee_related_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_related_article (
    id numeric(19,0) NOT NULL,
    article_referee_id numeric(19,0) NOT NULL,
    article_id character varying(255) NOT NULL
);


ALTER TABLE public.f1000r_referee_related_article OWNER TO f1000;

--
-- TOC entry 503 (class 1259 OID 114942)
-- Name: f1000r_referee_related_article_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_related_article_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_related_article_seq OWNER TO f1000;

--
-- TOC entry 504 (class 1259 OID 114944)
-- Name: f1000r_referee_report; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_report (
    referee_id numeric(19,0) NOT NULL,
    report_id numeric(19,0) NOT NULL,
    is_coreferee boolean NOT NULL,
    updated_date timestamp without time zone,
    added_date timestamp without time zone,
    article_referee_id numeric,
    "position" numeric(4,0) DEFAULT 0
);


ALTER TABLE public.f1000r_referee_report OWNER TO f1000;

--
-- TOC entry 505 (class 1259 OID 114951)
-- Name: f1000r_referee_report_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_report_draft (
    id numeric(19,0) NOT NULL,
    report_id numeric(19,0) NOT NULL,
    first_name text,
    last_name text,
    email text,
    co_referee boolean DEFAULT false,
    affiliations text
);


ALTER TABLE public.f1000r_referee_report_draft OWNER TO f1000;

--
-- TOC entry 506 (class 1259 OID 114958)
-- Name: f1000r_referee_report_draft_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_report_draft_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_report_draft_seq OWNER TO f1000;

--
-- TOC entry 507 (class 1259 OID 114960)
-- Name: f1000r_referee_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_seq OWNER TO f1000;

--
-- TOC entry 508 (class 1259 OID 114962)
-- Name: f1000r_referee_suggestion; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_suggestion (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    ref_tool_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_referee_suggestion OWNER TO f1000;

--
-- TOC entry 509 (class 1259 OID 114965)
-- Name: f1000r_referee_suggestion_draft; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_suggestion_draft (
    id numeric(19,0) NOT NULL,
    article_id numeric(19,0),
    report_id numeric(19,0),
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    institution_name character varying,
    country_id numeric(19,0),
    department character varying(255),
    place character varying(64),
    state character varying(255),
    zip_code character varying(64),
    referee_type character varying(100),
    nick_name character varying(255),
    referee_match character varying(100),
    source_article_url character varying(255),
    source_article_published_date character varying(10),
    score numeric(5,2),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    suggested_institution character varying
);


ALTER TABLE public.f1000r_referee_suggestion_draft OWNER TO f1000;

--
-- TOC entry 510 (class 1259 OID 114971)
-- Name: f1000r_referee_suggestion_draft_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_suggestion_draft_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_suggestion_draft_seq OWNER TO f1000;

--
-- TOC entry 511 (class 1259 OID 114973)
-- Name: f1000r_referee_suggestion_potential_affiliation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_suggestion_potential_affiliation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_suggestion_potential_affiliation_seq OWNER TO f1000;

--
-- TOC entry 512 (class 1259 OID 114975)
-- Name: f1000r_referee_suggestion_potential_ref; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_suggestion_potential_ref (
    id numeric(19,0) NOT NULL,
    referee_suggestion_id numeric(19,0) NOT NULL,
    first_name text,
    last_name text,
    latest_published date,
    score numeric(10,2),
    expert boolean,
    user_id numeric(19,0),
    referee_id numeric(19,0),
    latestpublisheddoi text,
    lastpublishedpubmedid numeric(19,0),
    email text,
    conflict_interest boolean,
    latestpublishedpubmed numeric(19,0),
    candidate_score real DEFAULT 0.0,
    affiliation_latest_published date
);


ALTER TABLE public.f1000r_referee_suggestion_potential_ref OWNER TO f1000;

--
-- TOC entry 513 (class 1259 OID 114982)
-- Name: f1000r_referee_suggestion_potential_ref_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_suggestion_potential_ref_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_suggestion_potential_ref_seq OWNER TO f1000;

--
-- TOC entry 514 (class 1259 OID 114984)
-- Name: f1000r_referee_suggestion_related_articles; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_suggestion_related_articles (
    id numeric(19,0) NOT NULL,
    pot_ref_id numeric(19,0) NOT NULL,
    f1000_article_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_referee_suggestion_related_articles OWNER TO f1000;

--
-- TOC entry 515 (class 1259 OID 114987)
-- Name: f1000r_referee_suggestion_related_articles_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_suggestion_related_articles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_suggestion_related_articles_seq OWNER TO f1000;

--
-- TOC entry 516 (class 1259 OID 114989)
-- Name: f1000r_referee_suggestion_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_suggestion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_suggestion_seq OWNER TO f1000;

--
-- TOC entry 517 (class 1259 OID 114991)
-- Name: f1000r_referee_supplementary_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_supplementary_file (
    report_id numeric(19,0) NOT NULL,
    supplementary_file_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_referee_supplementary_file OWNER TO f1000;

--
-- TOC entry 518 (class 1259 OID 114994)
-- Name: f1000r_referee_user_feedback; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_referee_user_feedback (
    id numeric(19,0) NOT NULL,
    user_id numeric(19,0),
    feedback text,
    ref_id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.f1000r_referee_user_feedback OWNER TO f1000;

--
-- TOC entry 519 (class 1259 OID 115001)
-- Name: f1000r_referee_user_feedback_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_referee_user_feedback_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_referee_user_feedback_sequence OWNER TO f1000;

--
-- TOC entry 520 (class 1259 OID 115003)
-- Name: f1000r_related_article; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_related_article (
    first_article_id numeric(19,0) NOT NULL,
    second_article_id numeric(19,0) NOT NULL,
    related timestamp without time zone NOT NULL,
    follow_up boolean DEFAULT false
);


ALTER TABLE public.f1000r_related_article OWNER TO f1000;

--
-- TOC entry 521 (class 1259 OID 115007)
-- Name: f1000r_report; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_report (
    id numeric(19,0) NOT NULL,
    comment text,
    updated_date timestamp without time zone,
    decision character varying(255),
    competing_interests text,
    version_id numeric(19,0) NOT NULL,
    status character varying(100),
    published_date timestamp without time zone,
    first_published_date timestamp without time zone,
    is_retracted boolean DEFAULT false,
    has_competing_interests boolean,
    submitted_date timestamp without time zone,
    silent boolean DEFAULT false,
    views_count integer DEFAULT 0,
    affiliation_update text,
    areas_of_research text,
    confirm_authorise_reportcc boolean DEFAULT false,
    survey_opinion boolean,
    questionnaire_survey_answer_reasoning text,
    nih_text_license boolean DEFAULT false,
    is_automated boolean DEFAULT false,
    doi character varying(255),
    citation_text text
);


ALTER TABLE public.f1000r_report OWNER TO f1000;

--
-- TOC entry 522 (class 1259 OID 115018)
-- Name: f1000r_report_article_thesaurus_term; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_report_article_thesaurus_term (
    id numeric(19,0) NOT NULL,
    report_article_id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_report_article_thesaurus_term OWNER TO f1000;

--
-- TOC entry 523 (class 1259 OID 115021)
-- Name: f1000r_report_article_thesaurus_term_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_report_article_thesaurus_term_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_report_article_thesaurus_term_seq OWNER TO f1000;

--
-- TOC entry 524 (class 1259 OID 115023)
-- Name: f1000r_report_history; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_report_history (
    id numeric(19,0) NOT NULL,
    report_id numeric(19,0) NOT NULL,
    comment text,
    updated_date timestamp without time zone,
    history_version numeric NOT NULL,
    usr_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_report_history OWNER TO f1000;

--
-- TOC entry 525 (class 1259 OID 115029)
-- Name: f1000r_report_history_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_report_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_report_history_seq OWNER TO f1000;

--
-- TOC entry 526 (class 1259 OID 115031)
-- Name: f1000r_report_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_report_seq OWNER TO f1000;

--
-- TOC entry 527 (class 1259 OID 115033)
-- Name: f1000r_report_view_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_report_view_log (
    id numeric(19,0) NOT NULL,
    view_date timestamp without time zone,
    report_id numeric(19,0)
);


ALTER TABLE public.f1000r_report_view_log OWNER TO f1000;

--
-- TOC entry 528 (class 1259 OID 115036)
-- Name: f1000r_report_view_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_report_view_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_report_view_log_seq OWNER TO f1000;

--
-- TOC entry 529 (class 1259 OID 115038)
-- Name: f1000r_sage_response; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_sage_response (
    id numeric(19,0) NOT NULL,
    product_id numeric(19,0),
    status character varying(100),
    status_detail character varying,
    internal_transaction_id character varying(100),
    amount_paid numeric,
    response_string character varying,
    received timestamp without time zone
);


ALTER TABLE public.f1000r_sage_response OWNER TO f1000;

--
-- TOC entry 530 (class 1259 OID 115044)
-- Name: f1000r_sage_response_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_sage_response_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_sage_response_seq OWNER TO f1000;

--
-- TOC entry 531 (class 1259 OID 115046)
-- Name: f1000r_scheduled_task; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_scheduled_task (
    id bigint NOT NULL,
    name character varying NOT NULL,
    status character varying(8) NOT NULL,
    last_run timestamp without time zone,
    log_enabled boolean DEFAULT false
);


ALTER TABLE public.f1000r_scheduled_task OWNER TO f1000;

--
-- TOC entry 532 (class 1259 OID 115053)
-- Name: f1000r_scheduled_task_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_scheduled_task_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_scheduled_task_seq OWNER TO f1000;

--
-- TOC entry 533 (class 1259 OID 115055)
-- Name: f1000r_scoups_citation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_scoups_citation (
    version_id numeric(19,0) NOT NULL,
    doi character varying(50),
    scopus_url character varying(500),
    citedby_count integer DEFAULT 0
);


ALTER TABLE public.f1000r_scoups_citation OWNER TO f1000;

--
-- TOC entry 534 (class 1259 OID 115062)
-- Name: f1000r_stored_search; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_stored_search (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    terms character varying NOT NULL,
    frequency character varying(40),
    results numeric(19,0) DEFAULT 0,
    user_id numeric(19,0) NOT NULL,
    created timestamp without time zone
);


ALTER TABLE public.f1000r_stored_search OWNER TO f1000;

--
-- TOC entry 535 (class 1259 OID 115069)
-- Name: f1000r_stored_search_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_stored_search_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_stored_search_seq OWNER TO f1000;

--
-- TOC entry 536 (class 1259 OID 115071)
-- Name: f1000r_submitter; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_submitter (
    id numeric(19,0) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    user_id numeric(19,0),
    nick_name text,
    orcid character varying(19)
);


ALTER TABLE public.f1000r_submitter OWNER TO f1000;

--
-- TOC entry 537 (class 1259 OID 115077)
-- Name: f1000r_submitter_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_submitter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_submitter_seq OWNER TO f1000;

--
-- TOC entry 538 (class 1259 OID 115079)
-- Name: f1000r_subtoken; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_subtoken (
    id numeric(19,0) NOT NULL,
    parent_id numeric(19,0) NOT NULL,
    name character varying(50) NOT NULL,
    article_payment_id numeric(19,0),
    date_used timestamp without time zone,
    created_user_id numeric(19,0),
    created_on timestamp without time zone
);


ALTER TABLE public.f1000r_subtoken OWNER TO f1000;

--
-- TOC entry 539 (class 1259 OID 115082)
-- Name: f1000r_subtoken_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_subtoken_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_subtoken_seq OWNER TO f1000;

--
-- TOC entry 540 (class 1259 OID 115084)
-- Name: f1000r_suggested_referee_rejected_template; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_suggested_referee_rejected_template (
    id numeric(19,0) NOT NULL,
    article_referee_sub_status text,
    rejected_template text
);


ALTER TABLE public.f1000r_suggested_referee_rejected_template OWNER TO f1000;

--
-- TOC entry 541 (class 1259 OID 115090)
-- Name: f1000r_suggested_referee_rejected_template_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_suggested_referee_rejected_template_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_suggested_referee_rejected_template_seq OWNER TO f1000;

--
-- TOC entry 542 (class 1259 OID 115092)
-- Name: f1000r_supplementary_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_supplementary_file (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    notes character varying,
    status character varying(10),
    file_size numeric(19,0),
    title character varying(1000),
    description text,
    doi character varying(100)
);


ALTER TABLE public.f1000r_supplementary_file OWNER TO f1000;

--
-- TOC entry 543 (class 1259 OID 115098)
-- Name: f1000r_table_doi_status; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_table_doi_status (
    id numeric(19,0) NOT NULL,
    table_id character varying(256),
    submission_status character varying(100),
    version_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_table_doi_status OWNER TO f1000;

--
-- TOC entry 544 (class 1259 OID 115101)
-- Name: f1000r_table_doi_status_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_table_doi_status_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_table_doi_status_seq OWNER TO f1000;

--
-- TOC entry 545 (class 1259 OID 115103)
-- Name: f1000r_thesaurus_term_cache; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_thesaurus_term_cache (
    id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) DEFAULT NULL::numeric,
    website_id numeric(19,0) DEFAULT NULL::numeric,
    articles numeric(19,0) DEFAULT 0 NOT NULL,
    faculty_review numeric(19,0) DEFAULT 0 NOT NULL,
    posters numeric(19,0) DEFAULT 0 NOT NULL,
    slides numeric(19,0) DEFAULT 0 NOT NULL,
    documents numeric(19,0) DEFAULT 0 NOT NULL
);


ALTER TABLE public.f1000r_thesaurus_term_cache OWNER TO f1000;

--
-- TOC entry 546 (class 1259 OID 115113)
-- Name: f1000r_thesaurus_term_cache_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_thesaurus_term_cache_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_thesaurus_term_cache_seq OWNER TO f1000;

--
-- TOC entry 547 (class 1259 OID 115115)
-- Name: f1000r_token; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_token (
    id numeric(19,0) NOT NULL,
    name character varying(50) NOT NULL,
    created_date timestamp without time zone,
    details character varying,
    expiry_date timestamp without time zone,
    price numeric,
    csv_exported boolean DEFAULT false,
    is_multipletoken boolean DEFAULT false,
    multipletoken_url character varying(150),
    url_expiry_date timestamp without time zone
);


ALTER TABLE public.f1000r_token OWNER TO f1000;

--
-- TOC entry 548 (class 1259 OID 115123)
-- Name: f1000r_token_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_token_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_token_seq OWNER TO f1000;

--
-- TOC entry 549 (class 1259 OID 115125)
-- Name: f1000r_tomcat_sessions; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_tomcat_sessions (
    session_id character varying(100) NOT NULL,
    valid_session character(1) NOT NULL,
    max_inactive integer NOT NULL,
    last_access bigint NOT NULL,
    app_name character varying(255),
    session_data bytea
);


ALTER TABLE public.f1000r_tomcat_sessions OWNER TO f1000;

--
-- TOC entry 550 (class 1259 OID 115131)
-- Name: f1000r_translation_affiliation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_affiliation (
    id bigint,
    translated_language character varying NOT NULL,
    department character varying,
    place character varying,
    state character varying,
    zip_code character varying,
    affiliation_uid uuid NOT NULL,
    institution_name character varying
);


ALTER TABLE public.f1000r_translation_affiliation OWNER TO f1000;

--
-- TOC entry 551 (class 1259 OID 115137)
-- Name: f1000r_translation_author; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_author (
    id bigint NOT NULL,
    translated_language character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL
);


ALTER TABLE public.f1000r_translation_author OWNER TO f1000;

--
-- TOC entry 552 (class 1259 OID 115143)
-- Name: f1000r_translation_cou; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_cou (
    translated_language character varying NOT NULL,
    cou_id bigint NOT NULL,
    cou_name character varying NOT NULL
);


ALTER TABLE public.f1000r_translation_cou OWNER TO f1000;

--
-- TOC entry 553 (class 1259 OID 115149)
-- Name: f1000r_translation_institution; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_institution (
    id bigint NOT NULL,
    translated_language character varying NOT NULL,
    name character varying
);


ALTER TABLE public.f1000r_translation_institution OWNER TO f1000;

--
-- TOC entry 554 (class 1259 OID 115155)
-- Name: f1000r_translation_submitter; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_submitter (
    id bigint NOT NULL,
    translated_language character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL
);


ALTER TABLE public.f1000r_translation_submitter OWNER TO f1000;

--
-- TOC entry 555 (class 1259 OID 115161)
-- Name: f1000r_translation_user; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_user (
    id bigint NOT NULL,
    translated_language character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL
);


ALTER TABLE public.f1000r_translation_user OWNER TO f1000;

--
-- TOC entry 556 (class 1259 OID 115167)
-- Name: f1000r_translation_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_translation_version (
    id bigint NOT NULL,
    translated_language character varying NOT NULL,
    title character varying,
    subtitle character varying,
    abstract_text character varying
);


ALTER TABLE public.f1000r_translation_version OWNER TO f1000;

--
-- TOC entry 557 (class 1259 OID 115173)
-- Name: f1000r_unsubscribe_email; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_unsubscribe_email (
    id numeric(19,0) NOT NULL,
    email character varying(255),
    unsubscribe_date timestamp without time zone,
    email_type character varying(100)
);


ALTER TABLE public.f1000r_unsubscribe_email OWNER TO f1000;

--
-- TOC entry 558 (class 1259 OID 115176)
-- Name: f1000r_unsubscribe_email_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_unsubscribe_email_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_unsubscribe_email_seq OWNER TO f1000;

--
-- TOC entry 559 (class 1259 OID 115178)
-- Name: f1000r_upload_info; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_upload_info (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    type character varying(255),
    version_id numeric(19,0),
    status character varying(32),
    file_size numeric(19,0) DEFAULT 0,
    is_source_file boolean DEFAULT false
);


ALTER TABLE public.f1000r_upload_info OWNER TO f1000;

--
-- TOC entry 560 (class 1259 OID 115186)
-- Name: f1000r_upload_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_upload_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_upload_info_seq OWNER TO f1000;

--
-- TOC entry 561 (class 1259 OID 115188)
-- Name: f1000r_usage_stats_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_usage_stats_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_usage_stats_seq OWNER TO f1000;

--
-- TOC entry 562 (class 1259 OID 115190)
-- Name: f1000r_usage_stats; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_usage_stats (
    id numeric(19,0) DEFAULT nextval('public.f1000r_usage_stats_seq'::regclass) NOT NULL,
    article_id numeric(19,0) NOT NULL,
    download_count numeric,
    view_count numeric,
    usage_date date
);


ALTER TABLE public.f1000r_usage_stats OWNER TO f1000;

--
-- TOC entry 563 (class 1259 OID 115197)
-- Name: f1000r_usage_stats_pmc; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_usage_stats_pmc (
    id numeric(19,0) NOT NULL,
    download_count numeric,
    view_count numeric,
    usage_date date,
    pmc_id text,
    pubmed_id text,
    doi text
);


ALTER TABLE public.f1000r_usage_stats_pmc OWNER TO f1000;

--
-- TOC entry 564 (class 1259 OID 115203)
-- Name: f1000r_usage_stats_pmc_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_usage_stats_pmc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_usage_stats_pmc_seq OWNER TO f1000;

--
-- TOC entry 565 (class 1259 OID 115205)
-- Name: f1000r_user_collection; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_user_collection (
    id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL,
    collection_id numeric(19,0) NOT NULL,
    type character varying(64) NOT NULL,
    active boolean DEFAULT false,
    thumbnail_file_name character varying(1024),
    "position" numeric(3,0) DEFAULT 0,
    view_profile_url text
);


ALTER TABLE public.f1000r_user_collection OWNER TO f1000;

--
-- TOC entry 566 (class 1259 OID 115213)
-- Name: f1000r_user_collection_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_user_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_user_collection_seq OWNER TO f1000;

--
-- TOC entry 567 (class 1259 OID 115215)
-- Name: f1000r_user_demographic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_user_demographic (
    usr_id numeric(19,0) NOT NULL,
    gender character varying(256),
    other_gender character varying(256),
    prefer_not_to_say_gender boolean DEFAULT false,
    ethnicity character varying(256),
    prefer_not_to_say_ethnicity boolean DEFAULT false,
    prefer_not_to_say_nationality boolean DEFAULT false
);


ALTER TABLE public.f1000r_user_demographic OWNER TO f1000;

--
-- TOC entry 568 (class 1259 OID 115224)
-- Name: f1000r_user_demographic_nationality; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_user_demographic_nationality (
    usr_id numeric(19,0) NOT NULL,
    nationality_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_user_demographic_nationality OWNER TO f1000;

--
-- TOC entry 569 (class 1259 OID 115227)
-- Name: f1000r_user_demographic_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_user_demographic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_user_demographic_seq OWNER TO f1000;

--
-- TOC entry 570 (class 1259 OID 115229)
-- Name: f1000r_user_gateway_interest; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_user_gateway_interest (
    usr_id numeric(19,0) NOT NULL,
    gateway_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_user_gateway_interest OWNER TO f1000;

--
-- TOC entry 571 (class 1259 OID 115232)
-- Name: f1000r_user_orcid_temp_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_user_orcid_temp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_user_orcid_temp_seq OWNER TO f1000;

--
-- TOC entry 572 (class 1259 OID 115234)
-- Name: f1000r_user_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_user_topic (
    user_id numeric(19,0) NOT NULL,
    topic_id numeric(19,0) NOT NULL,
    created timestamp without time zone
);


ALTER TABLE public.f1000r_user_topic OWNER TO f1000;

--
-- TOC entry 573 (class 1259 OID 115237)
-- Name: fro; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.fro (
    fro_id numeric(19,0) NOT NULL,
    fro_role_name character varying(50)
);


ALTER TABLE public.fro OWNER TO f1000;

--
-- TOC entry 574 (class 1259 OID 115240)
-- Name: fug; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.fug (
    fug_id numeric(19,0) NOT NULL,
    fug_usr_id numeric(19,0) NOT NULL,
    fug_fgr_id numeric(19,0) NOT NULL
);


ALTER TABLE public.fug OWNER TO f1000;

--
-- TOC entry 575 (class 1259 OID 115243)
-- Name: f1000r_usr_roles; Type: VIEW; Schema: public; Owner: f1000
--

CREATE VIEW public.f1000r_usr_roles AS
 SELECT fug.fug_usr_id AS usr_id,
    fro.fro_role_name AS role
   FROM (public.fug
     LEFT JOIN public.fro ON ((fro.fro_id = fug.fug_fgr_id)));


ALTER TABLE public.f1000r_usr_roles OWNER TO f1000;

--
-- TOC entry 576 (class 1259 OID 115247)
-- Name: f1000r_version; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version (
    id numeric(19,0) NOT NULL,
    title character varying(5000),
    subtitle character varying(5000),
    abstract_text text,
    competing_interests_text text,
    competing_interests boolean,
    grant_information boolean,
    grant_information_text text,
    indexed boolean DEFAULT false,
    status character varying(100),
    keywords character varying(1000),
    type character varying(100),
    data_status character varying(100),
    version_number numeric DEFAULT 1 NOT NULL,
    article_id numeric(19,0) NOT NULL,
    created timestamp without time zone NOT NULL,
    submitted timestamp without time zone,
    submitter_id numeric(19,0),
    editor_id numeric(19,0),
    notes text,
    published timestamp without time zone,
    status_last_modified timestamp without time zone,
    doi_submit_status character varying(50),
    referee_status character varying(100),
    external_metadata character varying,
    first_approved_date timestamp without time zone,
    pdf_size bigint,
    url_slug character varying,
    update_text text,
    tmp_is_new boolean DEFAULT true,
    short_url character varying(7),
    indexed_date timestamp without time zone,
    has_priority boolean,
    sent_to_pubmed boolean DEFAULT false,
    last_edited_date timestamp without time zone,
    sent_to_doaj boolean DEFAULT false,
    author_submitted_date timestamp without time zone,
    new_version_reason character varying(20),
    future_feature boolean,
    author_names text,
    has_priority_update_date timestamp without time zone,
    future_feature_update_date timestamp without time zone,
    retracted_after_published boolean DEFAULT false,
    retraction_text text,
    retraction_date timestamp without time zone,
    last_reports_by_referee_summary character varying(20),
    doi_table_submission_processed boolean DEFAULT false,
    has_priority_text text,
    doi character varying(200),
    pubmed_revision_number numeric(19,0) DEFAULT 0 NOT NULL,
    author_affiliations_draft text,
    datasets_changes boolean DEFAULT false,
    text_license_type character varying(255),
    data_license_type character varying(255),
    data_license_other_name character varying(255),
    text_license_other_name character varying(255),
    nih_text_license boolean DEFAULT false,
    hide_for_editors boolean DEFAULT false,
    contract_signed boolean,
    notes_from_author character varying,
    title_additional_info character varying(1000),
    has_problem boolean DEFAULT false,
    has_problem_update_date timestamp without time zone,
    excluded_from_dashboard boolean DEFAULT false,
    include_default_study_declaration boolean DEFAULT false NOT NULL,
    external_submission boolean DEFAULT false,
    title_additional_info_backup character varying(1000),
    embargo_publish_date timestamp without time zone,
    who_text_license boolean DEFAULT false,
    submission_url character varying(500),
    publication_url character varying(500),
    ext_new_version_url character varying(1000),
    ext_publish_confirmation_url character varying(1000),
    ext_submit_confirmation_url character varying(1000),
    show_faculty_review_reports boolean DEFAULT false,
    workspace_submission boolean DEFAULT false,
    sent_to_portico_success boolean,
    archive_reason character varying(255),
    referee_generation_required boolean DEFAULT false,
    grant_pi_decision text,
    permission_to_publish_denied boolean DEFAULT false,
    last_updated_date timestamp without time zone DEFAULT now(),
    tags_generation_required boolean DEFAULT false,
    external_submission_id character varying(255),
    prime_recommended boolean DEFAULT false,
    em_status character varying(100) DEFAULT 'PREACCEPTANCE'::character varying,
    imported boolean DEFAULT false,
    pdf_refresh_required boolean DEFAULT false,
    external_submission_data_id numeric(19,0),
    extended_data_id numeric(19,0),
    sent_to_eds boolean,
    lay_summaries text,
    discipline_type character varying(100),
    migrated boolean DEFAULT false NOT NULL,
    dataset_additional_details_id numeric(19,0),
    preprint_check_options_id numeric(19,0)
);


ALTER TABLE public.f1000r_version OWNER TO f1000;

--
-- TOC entry 577 (class 1259 OID 115279)
-- Name: f1000r_version_article_dataset; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_article_dataset (
    version_id numeric(19,0),
    article_dataset_id numeric(19,0),
    id numeric(19,0) NOT NULL,
    "position" numeric
);


ALTER TABLE public.f1000r_version_article_dataset OWNER TO f1000;

--
-- TOC entry 578 (class 1259 OID 115285)
-- Name: f1000r_version_article_dataset_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_article_dataset_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_article_dataset_seq OWNER TO f1000;

--
-- TOC entry 579 (class 1259 OID 115287)
-- Name: f1000r_version_author_affiliation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_author_affiliation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_author_affiliation_seq OWNER TO f1000;

--
-- TOC entry 580 (class 1259 OID 115289)
-- Name: f1000r_version_author_affiliation; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_author_affiliation (
    author_id numeric(19,0),
    affiliation_id numeric(19,0),
    version_id numeric(19,0),
    id numeric(19,0) DEFAULT nextval('public.f1000r_version_author_affiliation_seq'::regclass) NOT NULL,
    author_affiliation_position bigint DEFAULT 0,
    affiliation_uid uuid
);


ALTER TABLE public.f1000r_version_author_affiliation OWNER TO f1000;

--
-- TOC entry 581 (class 1259 OID 115294)
-- Name: f1000r_version_classification; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_classification (
    version_id numeric(19,0) NOT NULL,
    classification character varying(255)
);


ALTER TABLE public.f1000r_version_classification OWNER TO f1000;

--
-- TOC entry 582 (class 1259 OID 115313)
-- Name: f1000r_version_editor; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_editor (
    version_id numeric(19,0) NOT NULL,
    user_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_version_editor OWNER TO f1000;

--
-- TOC entry 583 (class 1259 OID 115316)
-- Name: f1000r_version_email_chronos; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_email_chronos (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0)
);


ALTER TABLE public.f1000r_version_email_chronos OWNER TO f1000;

--
-- TOC entry 584 (class 1259 OID 115319)
-- Name: f1000r_version_email_chronos_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_email_chronos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_email_chronos_seq OWNER TO f1000;

--
-- TOC entry 585 (class 1259 OID 115321)
-- Name: f1000r_version_extended_data; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_extended_data (
    id numeric(19,0) NOT NULL,
    cannotprovidedatafiles boolean,
    cannotprovidedatafilesreason text,
    latest_version_downloaded boolean,
    referees_removed boolean DEFAULT false,
    overdue_weeks character varying(100),
    overdue_date date,
    times_in_prepub smallint DEFAULT 0,
    eds_revision_number numeric(19,0) DEFAULT 0 NOT NULL,
    requires_data_files_guidance boolean DEFAULT false,
    last_overdue_email_sent character varying(255),
    was_in_editing boolean DEFAULT false,
    last_overdue_email_date date,
    approved_with_reservations_version numeric(2,0) DEFAULT 2 NOT NULL,
    duplicate_flag character varying(20),
    closeddatamodeldatalinks text,
    closeddatamodelsharedata boolean,
    has_automated_reports boolean DEFAULT false,
    citation_text text,
    vor_suitability_status character varying(100),
    preprint_doi character varying(200),
    sent_to_vor boolean DEFAULT false,
    auto_completed boolean DEFAULT false
);


ALTER TABLE public.f1000r_version_extended_data OWNER TO f1000;

--
-- TOC entry 586 (class 1259 OID 115333)
-- Name: f1000r_version_extended_data_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_extended_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_extended_data_seq OWNER TO f1000;

--
-- TOC entry 587 (class 1259 OID 115335)
-- Name: f1000r_version_fulltext; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_fulltext (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    full_text text
);


ALTER TABLE public.f1000r_version_fulltext OWNER TO f1000;

--
-- TOC entry 588 (class 1259 OID 115341)
-- Name: f1000r_version_pdf_detail; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_pdf_detail (
    version_id numeric(19,0) NOT NULL,
    file_hash character varying(256) NOT NULL,
    file_size numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_version_pdf_detail OWNER TO f1000;

--
-- TOC entry 589 (class 1259 OID 115344)
-- Name: f1000r_version_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_seq OWNER TO f1000;

--
-- TOC entry 590 (class 1259 OID 115346)
-- Name: f1000r_version_status_check; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_status_check (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    status character varying(255),
    checked boolean
);


ALTER TABLE public.f1000r_version_status_check OWNER TO f1000;

--
-- TOC entry 591 (class 1259 OID 115349)
-- Name: f1000r_version_status_check_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_status_check_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_status_check_seq OWNER TO f1000;

--
-- TOC entry 592 (class 1259 OID 115351)
-- Name: f1000r_version_subtopic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_subtopic (
    version_id numeric(19,0) NOT NULL,
    topic_id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_version_subtopic OWNER TO f1000;

--
-- TOC entry 593 (class 1259 OID 115354)
-- Name: f1000r_version_supplementary_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_supplementary_file (
    version_id numeric(19,0) NOT NULL,
    supplementary_file_id numeric(19,0) NOT NULL,
    "position" numeric(3,0),
    id numeric(19,0) NOT NULL
);


ALTER TABLE public.f1000r_version_supplementary_file OWNER TO f1000;

--
-- TOC entry 594 (class 1259 OID 115357)
-- Name: f1000r_version_supplementary_file_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_supplementary_file_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_supplementary_file_seq OWNER TO f1000;

--
-- TOC entry 595 (class 1259 OID 115359)
-- Name: f1000r_version_thesaurus_term; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_thesaurus_term (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL,
    from_algorithm boolean DEFAULT false,
    shown boolean DEFAULT false
);


ALTER TABLE public.f1000r_version_thesaurus_term OWNER TO f1000;

--
-- TOC entry 596 (class 1259 OID 115364)
-- Name: f1000r_version_thesaurus_term_f1000ont; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_thesaurus_term_f1000ont (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    thesaurus_term_id numeric(19,0) NOT NULL,
    from_algorithm boolean,
    shown boolean
);


ALTER TABLE public.f1000r_version_thesaurus_term_f1000ont OWNER TO f1000;

--
-- TOC entry 597 (class 1259 OID 115367)
-- Name: f1000r_version_thesaurus_term_f1000ont_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_thesaurus_term_f1000ont_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_thesaurus_term_f1000ont_seq OWNER TO f1000;

--
-- TOC entry 598 (class 1259 OID 115369)
-- Name: f1000r_version_thesaurus_term_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_thesaurus_term_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_thesaurus_term_seq OWNER TO f1000;

--
-- TOC entry 599 (class 1259 OID 115371)
-- Name: f1000r_version_visualized_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_version_visualized_file (
    id numeric(19,0),
    version_id numeric(19,0) NOT NULL,
    visualized_file_id numeric(19,0) NOT NULL,
    "position" numeric
);


ALTER TABLE public.f1000r_version_visualized_file OWNER TO f1000;

--
-- TOC entry 600 (class 1259 OID 115377)
-- Name: f1000r_version_visualized_file_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_version_visualized_file_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_version_visualized_file_seq OWNER TO f1000;

--
-- TOC entry 601 (class 1259 OID 115379)
-- Name: f1000r_visualized_file; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_visualized_file (
    id numeric(19,0) NOT NULL,
    created timestamp without time zone,
    target_filename character varying(300),
    original_filename character varying(300),
    status character varying(10),
    file_size numeric(19,0),
    title character varying,
    description character varying,
    doi character varying(100)
);


ALTER TABLE public.f1000r_visualized_file OWNER TO f1000;

--
-- TOC entry 602 (class 1259 OID 115385)
-- Name: f1000r_website; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_website (
    id numeric(19,0) NOT NULL,
    website text,
    display_name text,
    host_name text,
    name text,
    editorial_email character varying(255),
    info_email character varying(255),
    orcid_group_id character varying(255),
    primary_site boolean DEFAULT false NOT NULL
);


ALTER TABLE public.f1000r_website OWNER TO f1000;

--
-- TOC entry 603 (class 1259 OID 115391)
-- Name: f1000r_website_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_website_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_website_seq OWNER TO f1000;

--
-- TOC entry 604 (class 1259 OID 115393)
-- Name: f1000r_wellcome_grant_holder; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_wellcome_grant_holder (
    id numeric(19,0) NOT NULL,
    first_name text,
    second_name text,
    email text,
    grant_information_id numeric(19,0),
    wellcome_grant_id numeric(19,0)
);


ALTER TABLE public.f1000r_wellcome_grant_holder OWNER TO f1000;

--
-- TOC entry 605 (class 1259 OID 115399)
-- Name: f1000r_wellcome_grant_holder_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_wellcome_grant_holder_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_wellcome_grant_holder_sequence OWNER TO f1000;

--
-- TOC entry 606 (class 1259 OID 115401)
-- Name: f1000r_wellcome_grant_information; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_wellcome_grant_information (
    id numeric(19,0) NOT NULL,
    contact_number numeric(19,0),
    reference text,
    title text,
    forenames text,
    surname text,
    organisation_name text,
    government_region text,
    country_desc text,
    device text,
    email text,
    applicant_type text,
    grant_type text,
    funding_type text,
    funding_area text,
    grant_status text,
    outcome text,
    application_title text,
    financial_year text
);


ALTER TABLE public.f1000r_wellcome_grant_information OWNER TO f1000;

--
-- TOC entry 607 (class 1259 OID 115407)
-- Name: f1000r_wellcome_grant_information_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_wellcome_grant_information_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_wellcome_grant_information_sequence OWNER TO f1000;

--
-- TOC entry 608 (class 1259 OID 115409)
-- Name: f1000r_wellcome_grant_pi_email; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.f1000r_wellcome_grant_pi_email (
    id numeric(19,0) NOT NULL,
    pi_email character varying(255) NOT NULL,
    version_id numeric(19,0) NOT NULL,
    date_sent date,
    email_tracking_id numeric(19,0)
);


ALTER TABLE public.f1000r_wellcome_grant_pi_email OWNER TO f1000;

--
-- TOC entry 609 (class 1259 OID 115412)
-- Name: f1000r_wellcome_grant_pi_email_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.f1000r_wellcome_grant_pi_email_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.f1000r_wellcome_grant_pi_email_sequence OWNER TO f1000;

--
-- TOC entry 610 (class 1259 OID 115414)
-- Name: faculty; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.faculty (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    science character varying(8) NOT NULL,
    short_name character varying(50),
    posters_exclusive boolean DEFAULT false NOT NULL
);


ALTER TABLE public.faculty OWNER TO f1000;

--
-- TOC entry 611 (class 1259 OID 115418)
-- Name: faculty_commissioner_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_commissioner_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_commissioner_seq OWNER TO f1000;

--
-- TOC entry 612 (class 1259 OID 115420)
-- Name: faculty_member; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.faculty_member (
    id numeric(19,0) NOT NULL,
    status character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    contractenddate timestamp without time zone NOT NULL,
    contractstartdate timestamp without time zone NOT NULL,
    sabbaticalenddate timestamp without time zone,
    sabbaticalstartdate timestamp without time zone,
    science character varying(255) NOT NULL,
    faculty_id numeric(19,0),
    section_id numeric(19,0),
    parent numeric(19,0),
    city character varying(255),
    state character varying(255),
    country_id numeric(19,0),
    last_reinstated_date timestamp without time zone,
    clinical_trial boolean DEFAULT false NOT NULL,
    is_productive boolean DEFAULT false NOT NULL,
    deleted_email_holiday boolean DEFAULT false,
    deleted_email_holiday_start_date timestamp without time zone,
    deleted_email_holiday_end_date timestamp without time zone,
    suggested_content_alert_frequency numeric DEFAULT 7,
    suggested_content_last_sent timestamp without time zone,
    prime_related_email_holiday boolean DEFAULT false,
    profile_strength numeric(10,6) DEFAULT 0,
    restrictive_key_words character varying(4000),
    recommendation_alert_sent_count numeric(19,0) DEFAULT 0 NOT NULL,
    shown_in_trials boolean DEFAULT false,
    article_view_count numeric(19,0),
    etoc_alert_last_sent date,
    is_ct_productive boolean DEFAULT true NOT NULL,
    trials_assistant_emails text,
    member_notes text,
    member_notes_last_edit_date timestamp without time zone,
    next_contact_date timestamp without time zone,
    next_contact_notes text,
    contact_method character varying(10),
    metal character(1) DEFAULT 'B'::bpchar NOT NULL,
    rf numeric(1,0),
    ef numeric(1,0),
    contact_details text,
    last_updated_date timestamp without time zone DEFAULT now() NOT NULL,
    next_contact_timezone numeric(2,0),
    outstanding_member_award numeric(4,0),
    migrated_type character varying(100),
    next_contact_last_edited_editor_id numeric(19,0),
    next_contact_last_edited_date timestamp without time zone,
    commissioner_id numeric(19,0),
    accepted_giving_feedback boolean DEFAULT false,
    email_bounce boolean DEFAULT false,
    nomination_emails boolean DEFAULT true,
    commissioning_status character varying(255),
    society_member boolean DEFAULT false,
    society character varying(255),
    deleted_date timestamp without time zone,
    anonymization_date timestamp without time zone
);


ALTER TABLE public.faculty_member OWNER TO f1000;

--
-- TOC entry 613 (class 1259 OID 115441)
-- Name: faculty_member_awards_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_awards_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_awards_seq OWNER TO f1000;

--
-- TOC entry 614 (class 1259 OID 115443)
-- Name: faculty_member_history_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_history_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_history_sequence OWNER TO f1000;

--
-- TOC entry 615 (class 1259 OID 115445)
-- Name: faculty_member_internal_nomination_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_internal_nomination_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_internal_nomination_seq OWNER TO f1000;

--
-- TOC entry 616 (class 1259 OID 115447)
-- Name: faculty_member_nomination_endorsement_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_nomination_endorsement_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_nomination_endorsement_seq OWNER TO f1000;

--
-- TOC entry 617 (class 1259 OID 115449)
-- Name: faculty_member_nomination_rejection_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_nomination_rejection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_nomination_rejection_seq OWNER TO f1000;

--
-- TOC entry 618 (class 1259 OID 115451)
-- Name: faculty_member_nomination_section_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_nomination_section_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_nomination_section_seq OWNER TO f1000;

--
-- TOC entry 619 (class 1259 OID 115453)
-- Name: faculty_member_nomination_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_nomination_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_nomination_seq OWNER TO f1000;

--
-- TOC entry 620 (class 1259 OID 115455)
-- Name: faculty_member_nomination_vote_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_nomination_vote_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_nomination_vote_seq OWNER TO f1000;

--
-- TOC entry 621 (class 1259 OID 115457)
-- Name: faculty_member_video_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.faculty_member_video_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_member_video_seq OWNER TO f1000;

--
-- TOC entry 622 (class 1259 OID 115459)
-- Name: feedback_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.feedback_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feedback_seq OWNER TO f1000;

--
-- TOC entry 623 (class 1259 OID 115461)
-- Name: fgr; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.fgr (
    fgr_id numeric(19,0) NOT NULL,
    fgr_group_name character varying(50)
);


ALTER TABLE public.fgr OWNER TO f1000;

--
-- TOC entry 624 (class 1259 OID 115464)
-- Name: fm_monthly_statistics_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.fm_monthly_statistics_sequence
    START WITH 250687175
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fm_monthly_statistics_sequence OWNER TO f1000;

--
-- TOC entry 625 (class 1259 OID 115466)
-- Name: fm_statistic_detail_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.fm_statistic_detail_sequence
    START WITH 250687178
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fm_statistic_detail_sequence OWNER TO f1000;

--
-- TOC entry 626 (class 1259 OID 115468)
-- Name: free_article_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.free_article_id_seq
    START WITH 89001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.free_article_id_seq OWNER TO f1000;

--
-- TOC entry 627 (class 1259 OID 115470)
-- Name: frg; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.frg (
    frg_id numeric(19,0) NOT NULL,
    frg_fgr_id numeric(19,0) NOT NULL,
    frg_fro_id numeric(19,0) NOT NULL
);


ALTER TABLE public.frg OWNER TO f1000;

--
-- TOC entry 801 (class 1259 OID 32237932)
-- Name: fug_export_tmp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.fug_export_tmp (
    fug_id numeric(19,0) NOT NULL,
    fug_usr_id numeric(19,0) NOT NULL,
    fug_fgr_id numeric(19,0) NOT NULL
);


ALTER TABLE public.fug_export_tmp OWNER TO f1000;

--
-- TOC entry 628 (class 1259 OID 115473)
-- Name: google_doc_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.google_doc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.google_doc_seq OWNER TO f1000;

--
-- TOC entry 629 (class 1259 OID 115475)
-- Name: grocerystore_groceryitemavailability; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.grocerystore_groceryitemavailability (
    "itemId" character varying NOT NULL,
    name character varying NOT NULL,
    price character varying NOT NULL,
    "quantityRequested" character varying NOT NULL,
    "quantityAvailable" character varying NOT NULL
);


ALTER TABLE public.grocerystore_groceryitemavailability OWNER TO f1000;

--
-- TOC entry 630 (class 1259 OID 115481)
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.hibernate_sequence
    START WITH 250688221
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO f1000;

--
-- TOC entry 631 (class 1259 OID 115483)
-- Name: ins; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.ins (
    ins_id numeric(19,0) NOT NULL,
    ins_name character varying(255) NOT NULL,
    ins_main_usr_id numeric(19,0),
    ins_subscriber_id character varying(32),
    ins_tech_usr_id numeric(19,0),
    ins_sfx character varying(255),
    ins_docdel character varying(32),
    ins_linkout character varying(32),
    ins_homepage character varying(256),
    ins_member_emaillist character varying(512),
    ins_member_namelist character varying(512),
    ins_member_details character varying(1024),
    ins_loginrequired numeric(1,0),
    ins_sfxgif character varying(255),
    ins_alt_subscriber_id character varying(32),
    ins_member_suppress_page boolean DEFAULT false,
    ins_member_allow_claim boolean DEFAULT false,
    ins_renewal_reminder boolean DEFAULT true,
    ins_mainuser_ren_reminder boolean DEFAULT true,
    ins_techuser_ren_reminder boolean DEFAULT false,
    ins_mainuser_sub_notification boolean DEFAULT true,
    ins_techuser_sub_notification boolean DEFAULT false,
    ins_mainuser_usage_report boolean DEFAULT true,
    ins_techuser_usage_report boolean DEFAULT false,
    ins_think_cus_id character varying(32),
    main_contact_id numeric(19,0),
    sec_contact_id numeric(19,0),
    ip_display text,
    show_splashpage boolean DEFAULT true NOT NULL,
    bibleinstitution_id bigint,
    parent_id numeric(19,0),
    librarian_email character varying(255),
    request_librarian_enabled boolean DEFAULT false,
    discount_level numeric,
    discount_expiry_date timestamp without time zone,
    email_domains text,
    proxy_url character varying(1024),
    status character varying(256) DEFAULT 'ACTIVE'::character varying NOT NULL,
    type character varying(64) DEFAULT 'INSTITUTION'::character varying,
    nonbiomed boolean DEFAULT false,
    openathens_org_id numeric,
    openathens_scope character varying(512)
);


ALTER TABLE public.ins OWNER TO f1000;

--
-- TOC entry 632 (class 1259 OID 115503)
-- Name: ins_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.ins_contact_id_seq
    START WITH 1401
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ins_contact_id_seq OWNER TO f1000;

--
-- TOC entry 633 (class 1259 OID 115505)
-- Name: institution; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.institution (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    banner character varying(255),
    logo_id numeric(19,0),
    included_in_gateway_default boolean DEFAULT true
);


ALTER TABLE public.institution OWNER TO f1000;

--
-- TOC entry 634 (class 1259 OID 115512)
-- Name: interaction_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.interaction_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.interaction_seq OWNER TO f1000;

--
-- TOC entry 635 (class 1259 OID 115514)
-- Name: iscb_member_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.iscb_member_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.iscb_member_sequence OWNER TO f1000;

--
-- TOC entry 636 (class 1259 OID 115516)
-- Name: job; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.job (
    id numeric(19,0) NOT NULL,
    name character varying(100) NOT NULL,
    "position" numeric(19,0) DEFAULT 0 NOT NULL
);


ALTER TABLE public.job OWNER TO f1000;

--
-- TOC entry 637 (class 1259 OID 115520)
-- Name: journal_club_invitation_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_invitation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_invitation_id_seq OWNER TO f1000;

--
-- TOC entry 638 (class 1259 OID 115522)
-- Name: journal_club_meeting_article_vote_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_article_vote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_article_vote_id_seq OWNER TO f1000;

--
-- TOC entry 639 (class 1259 OID 115524)
-- Name: journal_club_meeting_conclusion_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_conclusion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_conclusion_seq OWNER TO f1000;

--
-- TOC entry 640 (class 1259 OID 115526)
-- Name: journal_club_meeting_discussion_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_discussion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_discussion_id_seq OWNER TO f1000;

--
-- TOC entry 641 (class 1259 OID 115528)
-- Name: journal_club_meeting_due_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_due_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_due_notification_id_seq OWNER TO f1000;

--
-- TOC entry 642 (class 1259 OID 115530)
-- Name: journal_club_meeting_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_id_seq OWNER TO f1000;

--
-- TOC entry 643 (class 1259 OID 115532)
-- Name: journal_club_meeting_presenter_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_presenter_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_presenter_notification_id_seq OWNER TO f1000;

--
-- TOC entry 644 (class 1259 OID 115534)
-- Name: journal_club_meeting_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_meeting_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_meeting_resource_id_seq OWNER TO f1000;

--
-- TOC entry 645 (class 1259 OID 115536)
-- Name: journal_club_member_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_member_id_seq OWNER TO f1000;

--
-- TOC entry 646 (class 1259 OID 115538)
-- Name: journal_club_preference_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_preference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_preference_id_seq OWNER TO f1000;

--
-- TOC entry 647 (class 1259 OID 115540)
-- Name: journal_club_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_club_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_club_seq OWNER TO f1000;

--
-- TOC entry 648 (class 1259 OID 115542)
-- Name: journal_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.journal_id_sequence
    START WITH 24401
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_id_sequence OWNER TO f1000;

--
-- TOC entry 649 (class 1259 OID 115544)
-- Name: last_institutional_access; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.last_institutional_access (
    user_id numeric(19,0) NOT NULL,
    last_access_date timestamp without time zone,
    institution_id numeric(19,0),
    id numeric(19,0)
);


ALTER TABLE public.last_institutional_access OWNER TO f1000;

--
-- TOC entry 650 (class 1259 OID 115547)
-- Name: library_annotation_image_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_annotation_image_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_annotation_image_seq OWNER TO f1000;

--
-- TOC entry 651 (class 1259 OID 115549)
-- Name: library_annotation_range_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_annotation_range_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_annotation_range_seq OWNER TO f1000;

--
-- TOC entry 652 (class 1259 OID 115551)
-- Name: library_annotation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_annotation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_annotation_seq OWNER TO f1000;

--
-- TOC entry 653 (class 1259 OID 115553)
-- Name: library_article_failed_pdf_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_article_failed_pdf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_article_failed_pdf_seq OWNER TO f1000;

--
-- TOC entry 654 (class 1259 OID 115555)
-- Name: library_author_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_author_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_author_seq OWNER TO f1000;

--
-- TOC entry 655 (class 1259 OID 115557)
-- Name: library_collection_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_collection_seq OWNER TO f1000;

--
-- TOC entry 656 (class 1259 OID 115559)
-- Name: library_comment_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_comment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_comment_seq OWNER TO f1000;

--
-- TOC entry 657 (class 1259 OID 115561)
-- Name: library_document_citation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_document_citation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_document_citation_seq OWNER TO f1000;

--
-- TOC entry 658 (class 1259 OID 115563)
-- Name: library_editor_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_editor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_editor_seq OWNER TO f1000;

--
-- TOC entry 659 (class 1259 OID 115565)
-- Name: library_interaction_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_interaction_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_interaction_seq OWNER TO f1000;

--
-- TOC entry 660 (class 1259 OID 115567)
-- Name: library_item_file_dictionary_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_item_file_dictionary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_item_file_dictionary_id_seq OWNER TO f1000;

--
-- TOC entry 661 (class 1259 OID 115569)
-- Name: library_item_file_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_item_file_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_item_file_info_seq OWNER TO f1000;

--
-- TOC entry 662 (class 1259 OID 115571)
-- Name: library_item_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_item_resource_id_seq
    START WITH 802
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_item_resource_id_seq OWNER TO f1000;

--
-- TOC entry 663 (class 1259 OID 115573)
-- Name: library_item_resource_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_item_resource_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_item_resource_seq OWNER TO f1000;

--
-- TOC entry 664 (class 1259 OID 115575)
-- Name: library_item_resource_summary_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_item_resource_summary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_item_resource_summary_seq OWNER TO f1000;

--
-- TOC entry 665 (class 1259 OID 115577)
-- Name: library_item_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_item_seq OWNER TO f1000;

--
-- TOC entry 666 (class 1259 OID 115579)
-- Name: library_linked_items_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_linked_items_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_linked_items_seq OWNER TO f1000;

--
-- TOC entry 667 (class 1259 OID 115581)
-- Name: library_pdf_drawing_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_pdf_drawing_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_pdf_drawing_seq OWNER TO f1000;

--
-- TOC entry 668 (class 1259 OID 115583)
-- Name: library_research_author_email_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_research_author_email_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_research_author_email_sequence OWNER TO f1000;

--
-- TOC entry 669 (class 1259 OID 115585)
-- Name: library_research_author_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_research_author_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_research_author_sequence OWNER TO f1000;

--
-- TOC entry 670 (class 1259 OID 115587)
-- Name: library_resource_pdf_url_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_resource_pdf_url_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_resource_pdf_url_seq OWNER TO f1000;

--
-- TOC entry 671 (class 1259 OID 115589)
-- Name: library_sharing_invitation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_sharing_invitation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_sharing_invitation_seq OWNER TO f1000;

--
-- TOC entry 672 (class 1259 OID 115591)
-- Name: library_suggested_recommendation_interaction_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_suggested_recommendation_interaction_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_suggested_recommendation_interaction_seq OWNER TO f1000;

--
-- TOC entry 673 (class 1259 OID 115593)
-- Name: library_suggestion_interaction_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_suggestion_interaction_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_suggestion_interaction_seq OWNER TO f1000;

--
-- TOC entry 674 (class 1259 OID 115595)
-- Name: library_tag_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_tag_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_tag_seq OWNER TO f1000;

--
-- TOC entry 675 (class 1259 OID 115597)
-- Name: library_user_collection_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_user_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_user_collection_seq OWNER TO f1000;

--
-- TOC entry 676 (class 1259 OID 115599)
-- Name: library_user_count_sent_emails_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_user_count_sent_emails_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_user_count_sent_emails_seq OWNER TO f1000;

--
-- TOC entry 677 (class 1259 OID 115601)
-- Name: library_user_import_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_user_import_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_user_import_seq OWNER TO f1000;

--
-- TOC entry 678 (class 1259 OID 115603)
-- Name: library_user_item_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_user_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_user_item_seq OWNER TO f1000;

--
-- TOC entry 679 (class 1259 OID 115605)
-- Name: library_user_product_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_user_product_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_user_product_info_seq OWNER TO f1000;

--
-- TOC entry 680 (class 1259 OID 115607)
-- Name: library_user_resources_size_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_user_resources_size_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_user_resources_size_seq OWNER TO f1000;

--
-- TOC entry 681 (class 1259 OID 115609)
-- Name: library_version_info_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.library_version_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.library_version_info_seq OWNER TO f1000;

--
-- TOC entry 682 (class 1259 OID 115611)
-- Name: local_file_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.local_file_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.local_file_seq OWNER TO f1000;

--
-- TOC entry 683 (class 1259 OID 115613)
-- Name: logentry_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.logentry_id_seq
    START WITH 122317408
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logentry_id_seq OWNER TO f1000;

--
-- TOC entry 684 (class 1259 OID 115615)
-- Name: logging_excluded_ip; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.logging_excluded_ip (
    id numeric NOT NULL,
    cidr_expression character varying(255),
    type character varying(255)
);


ALTER TABLE public.logging_excluded_ip OWNER TO f1000;

--
-- TOC entry 685 (class 1259 OID 115621)
-- Name: magic_member_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.magic_member_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.magic_member_seq OWNER TO f1000;

--
-- TOC entry 686 (class 1259 OID 115623)
-- Name: manual_journal_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.manual_journal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manual_journal_seq OWNER TO f1000;

--
-- TOC entry 687 (class 1259 OID 115625)
-- Name: microservice_deployment; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.microservice_deployment (
    id bigint NOT NULL,
    name character varying NOT NULL,
    port bigint NOT NULL,
    devserver character varying NOT NULL,
    stageserver character varying NOT NULL,
    liveserver character varying NOT NULL,
    latest_version character varying NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.microservice_deployment OWNER TO f1000;

--
-- TOC entry 688 (class 1259 OID 115632)
-- Name: microservice_deployment_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.microservice_deployment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.microservice_deployment_id_seq OWNER TO f1000;

--
-- TOC entry 7195 (class 0 OID 0)
-- Dependencies: 688
-- Name: microservice_deployment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: f1000
--

ALTER SEQUENCE public.microservice_deployment_id_seq OWNED BY public.microservice_deployment.id;


--
-- TOC entry 689 (class 1259 OID 115634)
-- Name: microsite_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.microsite_customer_id_seq
    START WITH 1021
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.microsite_customer_id_seq OWNER TO f1000;

--
-- TOC entry 690 (class 1259 OID 115636)
-- Name: multiserver_responsibility_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.multiserver_responsibility_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.multiserver_responsibility_seq OWNER TO f1000;

--
-- TOC entry 691 (class 1259 OID 115638)
-- Name: non_subscriber_access_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.non_subscriber_access_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.non_subscriber_access_sequence OWNER TO f1000;

--
-- TOC entry 692 (class 1259 OID 115640)
-- Name: note_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.note_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.note_seq OWNER TO f1000;

--
-- TOC entry 693 (class 1259 OID 115642)
-- Name: oauth_code; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.oauth_code (
    id bigint NOT NULL,
    usr_id numeric(19,0) NOT NULL,
    client_id character varying NOT NULL,
    scope character varying NOT NULL,
    auth_code character varying NOT NULL,
    is_valid boolean NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.oauth_code OWNER TO f1000;

--
-- TOC entry 694 (class 1259 OID 115649)
-- Name: oauth_code_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.oauth_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oauth_code_id_seq OWNER TO f1000;

--
-- TOC entry 7196 (class 0 OID 0)
-- Dependencies: 694
-- Name: oauth_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: f1000
--

ALTER SEQUENCE public.oauth_code_id_seq OWNED BY public.oauth_code.id;


--
-- TOC entry 695 (class 1259 OID 115651)
-- Name: oauth_token; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.oauth_token (
    id bigint NOT NULL,
    usr_id numeric(19,0) NOT NULL,
    client_id character varying NOT NULL,
    scope character varying NOT NULL,
    access_token character varying NOT NULL,
    created timestamp without time zone NOT NULL,
    access_token_expired timestamp without time zone NOT NULL,
    refresh_token character varying NOT NULL,
    refresh_token_expired timestamp without time zone NOT NULL
);


ALTER TABLE public.oauth_token OWNER TO f1000;

--
-- TOC entry 696 (class 1259 OID 115657)
-- Name: oauth_token_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.oauth_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oauth_token_id_seq OWNER TO f1000;

--
-- TOC entry 7197 (class 0 OID 0)
-- Dependencies: 696
-- Name: oauth_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: f1000
--

ALTER SEQUENCE public.oauth_token_id_seq OWNED BY public.oauth_token.id;


--
-- TOC entry 697 (class 1259 OID 115659)
-- Name: old_f1000_ypp_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.old_f1000_ypp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.old_f1000_ypp_seq OWNER TO f1000;

--
-- TOC entry 698 (class 1259 OID 115661)
-- Name: ontology; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.ontology (
    id bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.ontology OWNER TO f1000;

--
-- TOC entry 699 (class 1259 OID 115667)
-- Name: openathens_scopes_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.openathens_scopes_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.openathens_scopes_seq OWNER TO f1000;

--
-- TOC entry 700 (class 1259 OID 115669)
-- Name: orcid_access_data; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.orcid_access_data (
    faculty_member_id numeric(19,0),
    access_token character varying(36) NOT NULL,
    refresh_token character varying(36),
    token_type character varying(100),
    orcid character varying(19) NOT NULL,
    access_scope character varying(100),
    expires_in numeric NOT NULL,
    id numeric(19,0) NOT NULL,
    permission_enabled boolean DEFAULT false,
    created_on timestamp without time zone DEFAULT now() NOT NULL,
    f1000research boolean DEFAULT false,
    email character varying(255),
    website_id numeric(19,0)
);


ALTER TABLE public.orcid_access_data OWNER TO f1000;

--
-- TOC entry 701 (class 1259 OID 115678)
-- Name: paypal_ipn_log_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.paypal_ipn_log_id_seq
    START WITH 3983
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paypal_ipn_log_id_seq OWNER TO f1000;

--
-- TOC entry 702 (class 1259 OID 115680)
-- Name: paypal_subscr_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.paypal_subscr_id_seq
    START WITH 4601
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paypal_subscr_id_seq OWNER TO f1000;

--
-- TOC entry 703 (class 1259 OID 115682)
-- Name: peersguru_excluded_referees_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.peersguru_excluded_referees_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.peersguru_excluded_referees_seq OWNER TO f1000;

--
-- TOC entry 704 (class 1259 OID 115684)
-- Name: peersguru_invitation_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.peersguru_invitation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.peersguru_invitation_seq OWNER TO f1000;

--
-- TOC entry 705 (class 1259 OID 115686)
-- Name: photograph; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.photograph (
    id numeric(19,0) NOT NULL,
    content bytea
);


ALTER TABLE public.photograph OWNER TO f1000;

--
-- TOC entry 706 (class 1259 OID 115692)
-- Name: poster_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.poster_id_seq
    START WITH 1091927
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poster_id_seq OWNER TO f1000;

--
-- TOC entry 707 (class 1259 OID 115694)
-- Name: prepay_membership_log_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.prepay_membership_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prepay_membership_log_seq OWNER TO f1000;

--
-- TOC entry 708 (class 1259 OID 115696)
-- Name: prepay_membership_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.prepay_membership_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prepay_membership_seq OWNER TO f1000;

--
-- TOC entry 709 (class 1259 OID 115698)
-- Name: publisher_quote_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.publisher_quote_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.publisher_quote_sequence OWNER TO f1000;

--
-- TOC entry 710 (class 1259 OID 115700)
-- Name: ranked_journal_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.ranked_journal_id_seq
    START WITH 242601
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ranked_journal_id_seq OWNER TO f1000;

--
-- TOC entry 711 (class 1259 OID 115702)
-- Name: recommend_f1000_details_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.recommend_f1000_details_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recommend_f1000_details_seq OWNER TO f1000;

--
-- TOC entry 712 (class 1259 OID 115704)
-- Name: recommender_engine; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.recommender_engine (
    id bigint NOT NULL,
    name character varying NOT NULL,
    capabilities character varying NOT NULL
);


ALTER TABLE public.recommender_engine OWNER TO f1000;

--
-- TOC entry 713 (class 1259 OID 115710)
-- Name: recommender_recommendationrequest; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.recommender_recommendationrequest (
    title character varying NOT NULL,
    abstract character varying NOT NULL,
    journal character varying NOT NULL,
    authors character varying NOT NULL,
    exclude character varying NOT NULL,
    dois character varying NOT NULL,
    maxyears character varying NOT NULL,
    keywords character varying NOT NULL
);


ALTER TABLE public.recommender_recommendationrequest OWNER TO f1000;

--
-- TOC entry 714 (class 1259 OID 115716)
-- Name: recommender_recommendationresponse; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.recommender_recommendationresponse (
    "firstName" character varying NOT NULL,
    "lastName" character varying NOT NULL,
    "pubMedIds" character varying NOT NULL,
    score character varying NOT NULL,
    dois character varying NOT NULL,
    affiliations character varying NOT NULL,
    "latestPublished" character varying NOT NULL,
    "conflictInterest" character varying NOT NULL,
    "lastPublishedDoi" character varying NOT NULL,
    "lastPublishedPubmedId" bigint NOT NULL,
    "affiliationPublished" character varying NOT NULL,
    "refSugId" bigint NOT NULL,
    expert character varying NOT NULL,
    emails character varying NOT NULL,
    referee character varying NOT NULL,
    "user" character varying NOT NULL
);


ALTER TABLE public.recommender_recommendationresponse OWNER TO f1000;

--
-- TOC entry 715 (class 1259 OID 115722)
-- Name: references_optimizer_submission_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.references_optimizer_submission_seq
    START WITH 1037
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.references_optimizer_submission_seq OWNER TO f1000;

--
-- TOC entry 716 (class 1259 OID 115724)
-- Name: related_research_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.related_research_topic (
    dummy_topic_id numeric(19,0) NOT NULL,
    related_topic_id numeric(19,0) NOT NULL
);


ALTER TABLE public.related_research_topic OWNER TO f1000;

--
-- TOC entry 717 (class 1259 OID 115727)
-- Name: report_article_auth_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.report_article_auth_seq
    START WITH 3641
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_article_auth_seq OWNER TO f1000;

--
-- TOC entry 718 (class 1259 OID 115729)
-- Name: report_article_author; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.report_article_author (
    report_article_author_id numeric(19,0) NOT NULL,
    report_article_id numeric(19,0) NOT NULL,
    author_name character varying(500)
);


ALTER TABLE public.report_article_author OWNER TO f1000;

--
-- TOC entry 719 (class 1259 OID 115735)
-- Name: report_article_history_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.report_article_history_id_seq
    START WITH 5501
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_article_history_id_seq OWNER TO f1000;

--
-- TOC entry 720 (class 1259 OID 115737)
-- Name: report_article_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.report_article_id_seq
    START WITH 2701
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_article_id_seq OWNER TO f1000;

--
-- TOC entry 721 (class 1259 OID 115739)
-- Name: report_issue; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.report_issue (
    id numeric(19,0) NOT NULL,
    journal_id numeric(19,0) NOT NULL,
    volume numeric NOT NULL,
    year numeric NOT NULL,
    month numeric(2,0) NOT NULL
);


ALTER TABLE public.report_issue OWNER TO f1000;

--
-- TOC entry 722 (class 1259 OID 115745)
-- Name: report_issue_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.report_issue_id_seq
    START WITH 2001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_issue_id_seq OWNER TO f1000;

--
-- TOC entry 723 (class 1259 OID 115747)
-- Name: research_grant; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.research_grant (
    id numeric(19,0) NOT NULL,
    funder character varying(255) NOT NULL,
    grant_number character varying(255) NOT NULL,
    poster_summary_id numeric(19,0)
);


ALTER TABLE public.research_grant OWNER TO f1000;

--
-- TOC entry 724 (class 1259 OID 115753)
-- Name: research_member; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.research_member (
    id numeric NOT NULL,
    status character varying NOT NULL,
    "position" character varying NOT NULL,
    subtopic_id numeric,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.research_member OWNER TO f1000;

--
-- TOC entry 725 (class 1259 OID 115760)
-- Name: research_member_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.research_member_topic (
    research_member_id numeric(19,0) NOT NULL,
    topic_id numeric(19,0) NOT NULL
);


ALTER TABLE public.research_member_topic OWNER TO f1000;

--
-- TOC entry 726 (class 1259 OID 115763)
-- Name: research_topic_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.research_topic_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.research_topic_sequence OWNER TO f1000;

--
-- TOC entry 727 (class 1259 OID 115765)
-- Name: research_topic; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.research_topic (
    id numeric DEFAULT nextval('public.research_topic_sequence'::regclass) NOT NULL,
    name character varying NOT NULL,
    parent_id numeric,
    short_name character varying
);


ALTER TABLE public.research_topic OWNER TO f1000;

--
-- TOC entry 728 (class 1259 OID 115772)
-- Name: research_topic_section_special_mapping; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.research_topic_section_special_mapping (
    topic_id numeric NOT NULL,
    section_id numeric(19,0) NOT NULL
);


ALTER TABLE public.research_topic_section_special_mapping OWNER TO f1000;

--
-- TOC entry 729 (class 1259 OID 115778)
-- Name: sagepay_transaction; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.sagepay_transaction (
    id numeric(19,0) NOT NULL,
    description character varying(255),
    curency character varying(255),
    sendemail boolean,
    status character varying(40),
    transaction_payer_id numeric(19,0),
    vendor_transaction_code character varying(40),
    unique_request_id numeric(19,0),
    sagepay_return text
);


ALTER TABLE public.sagepay_transaction OWNER TO f1000;

--
-- TOC entry 803 (class 1259 OID 34444888)
-- Name: scheduledtasks_retries_log; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.scheduledtasks_retries_log (
    uid uuid NOT NULL,
    object_id bigint NOT NULL,
    object_type character varying(255) NOT NULL,
    task_name character varying(255) NOT NULL,
    log text,
    failed_attempts integer DEFAULT 0 NOT NULL,
    last_run timestamp without time zone NOT NULL
);


ALTER TABLE public.scheduledtasks_retries_log OWNER TO f1000;

--
-- TOC entry 730 (class 1259 OID 115784)
-- Name: section; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.section (
    id numeric(19,0) NOT NULL,
    name character varying(255) NOT NULL,
    science character varying(8) NOT NULL,
    short_name character varying(50),
    active boolean DEFAULT true,
    clinical_trial boolean DEFAULT true NOT NULL,
    posters_exclusive boolean DEFAULT false NOT NULL,
    section_notes text,
    section_notes_last_edit_date timestamp without time zone,
    section_notes_last_updater numeric(19,0)
);


ALTER TABLE public.section OWNER TO f1000;

--
-- TOC entry 731 (class 1259 OID 115793)
-- Name: statistics_paper_type_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.statistics_paper_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statistics_paper_type_seq OWNER TO f1000;

--
-- TOC entry 732 (class 1259 OID 115795)
-- Name: statistics_summary_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.statistics_summary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statistics_summary_seq OWNER TO f1000;

--
-- TOC entry 733 (class 1259 OID 115797)
-- Name: stored_search_pk_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.stored_search_pk_seq
    START WITH 48203
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stored_search_pk_seq OWNER TO f1000;

--
-- TOC entry 734 (class 1259 OID 115799)
-- Name: stored_search_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.stored_search_seq
    START WITH 47185
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stored_search_seq OWNER TO f1000;

--
-- TOC entry 735 (class 1259 OID 115801)
-- Name: sub_section_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.sub_section_seq
    START WITH 32
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sub_section_seq OWNER TO f1000;

--
-- TOC entry 736 (class 1259 OID 115803)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.subscription_id_seq
    START WITH 71069408
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_id_seq OWNER TO f1000;

--
-- TOC entry 737 (class 1259 OID 115805)
-- Name: subscription; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.subscription (
    id numeric(19,0) DEFAULT nextval('public.subscription_id_seq'::regclass) NOT NULL,
    user_id numeric(19,0) NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone,
    subscription_type character varying(50) NOT NULL,
    notification_status character varying(30) DEFAULT 'NO_NOTIFICATION_SENT'::character varying,
    status character varying(50),
    custom_subscription_id character varying(32),
    creator_id numeric(19,0),
    creation_date timestamp without time zone,
    active boolean DEFAULT false NOT NULL,
    subscription_code_id numeric(19,0)
);


ALTER TABLE public.subscription OWNER TO f1000;

--
-- TOC entry 738 (class 1259 OID 115811)
-- Name: subscription_code_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.subscription_code_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_code_id_sequence OWNER TO f1000;

--
-- TOC entry 739 (class 1259 OID 115813)
-- Name: subscription_group_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.subscription_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_group_seq OWNER TO f1000;

--
-- TOC entry 740 (class 1259 OID 115815)
-- Name: subscription_token_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.subscription_token_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_token_id_sequence OWNER TO f1000;

--
-- TOC entry 741 (class 1259 OID 115817)
-- Name: subscription_user_group_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.subscription_user_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_user_group_seq OWNER TO f1000;

--
-- TOC entry 742 (class 1259 OID 115819)
-- Name: term; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.term (
    id bigint NOT NULL,
    ontology_id bigint NOT NULL,
    term_name character varying NOT NULL,
    external_id character varying NOT NULL,
    child_count integer NOT NULL
);


ALTER TABLE public.term OWNER TO f1000;

--
-- TOC entry 743 (class 1259 OID 115825)
-- Name: term_relationship; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.term_relationship (
    child_id bigint NOT NULL,
    parent_id bigint NOT NULL,
    ontology_id bigint NOT NULL
);


ALTER TABLE public.term_relationship OWNER TO f1000;

--
-- TOC entry 744 (class 1259 OID 115828)
-- Name: thesaurus_synonym; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.thesaurus_synonym (
    id numeric(19,0) NOT NULL,
    synonym character varying(512) NOT NULL,
    term_id numeric(19,0) NOT NULL
);


ALTER TABLE public.thesaurus_synonym OWNER TO f1000;

--
-- TOC entry 745 (class 1259 OID 115834)
-- Name: thesaurus_synonym_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.thesaurus_synonym_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.thesaurus_synonym_id_sequence OWNER TO f1000;

--
-- TOC entry 746 (class 1259 OID 115836)
-- Name: thesaurus_term; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.thesaurus_term (
    id numeric(19,0) NOT NULL,
    term_name character varying(512) NOT NULL,
    reference_count bigint DEFAULT 0,
    child_count bigint DEFAULT 0
);


ALTER TABLE public.thesaurus_term OWNER TO f1000;

--
-- TOC entry 747 (class 1259 OID 115844)
-- Name: thesaurus_term_backup; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.thesaurus_term_backup (
    id numeric(19,0),
    term_name character varying(512)
);


ALTER TABLE public.thesaurus_term_backup OWNER TO f1000;

--
-- TOC entry 748 (class 1259 OID 115850)
-- Name: thesaurus_term_id_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.thesaurus_term_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.thesaurus_term_id_sequence OWNER TO f1000;

--
-- TOC entry 749 (class 1259 OID 115852)
-- Name: thesaurus_term_parent; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.thesaurus_term_parent (
    term_id numeric(19,0) NOT NULL,
    parent_id numeric(19,0) NOT NULL
);


ALTER TABLE public.thesaurus_term_parent OWNER TO f1000;

--
-- TOC entry 750 (class 1259 OID 115855)
-- Name: thumbnail; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.thumbnail (
    id numeric(19,0) NOT NULL,
    processed boolean,
    processing boolean DEFAULT false NOT NULL,
    name character varying(255),
    mime_type character varying(255) DEFAULT 'image/jpeg'::character varying,
    manual boolean DEFAULT false NOT NULL,
    file_size numeric(19,0) DEFAULT 0
);


ALTER TABLE public.thumbnail OWNER TO f1000;

--
-- TOC entry 751 (class 1259 OID 115871)
-- Name: unsubscribe_email_sequence; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.unsubscribe_email_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unsubscribe_email_sequence OWNER TO f1000;

--
-- TOC entry 752 (class 1259 OID 115873)
-- Name: upo; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.upo (
    usr_id numeric(19,0) NOT NULL,
    email_format character varying(256) DEFAULT 'HTML'::character varying,
    f1000_updates boolean DEFAULT false,
    f1000_partner_updates boolean DEFAULT false,
    sections_alert_frequency numeric,
    sections_alert_results_limit numeric,
    sections_alert_last_sent timestamp without time zone,
    updates_last_change timestamp without time zone,
    partner_updates_last_change timestamp without time zone,
    pubmed_search_email_frequency integer DEFAULT 7,
    pubmed_email_results_limit integer DEFAULT 5,
    pubmed_search_email_last_sent timestamp without time zone,
    f1000_librarian_newsletter boolean DEFAULT false,
    librarian_newsletter_last_change timestamp without time zone,
    draft_submissions_reminder boolean DEFAULT true,
    sms_filter_type character varying(255) DEFAULT 'WITH_NEIGHBOR_SCORE'::character varying,
    following_articles_alerts boolean DEFAULT false,
    following_members_alerts boolean DEFAULT false,
    sections_alert_frequency_trials numeric,
    sections_alert_last_sent_trials timestamp without time zone,
    sections_alert_results_limit_trials numeric,
    journal_club_meeting_creation_alert boolean DEFAULT true,
    journal_club_short_list_completed_alert boolean DEFAULT true,
    journal_club_meeting_reminder_days numeric(5,0) DEFAULT 1,
    f1kr_tracking_alert_frequency character varying(40) DEFAULT 'DAILY'::character varying,
    f1kr_tracking_alert_last_sent timestamp without time zone,
    f1kr_stop_tracking_alerts_once_indexed boolean DEFAULT false,
    home_teaser_alert_frequency numeric DEFAULT 7,
    home_teaser_alert_last_sent timestamp without time zone,
    f1kr_subjects_alert_frequency character varying(40),
    f1kr_subjects_alert_results_limit numeric(6,0),
    f1kr_subjects_alert_last_sent timestamp without time zone,
    trials_pubmed_search_email_last_sent timestamp without time zone,
    home_teaser_alert_previous_sent timestamp without time zone,
    jc_show_help_admin boolean DEFAULT true,
    jc_show_help_home_page boolean DEFAULT true,
    jc_show_help_article_selection boolean DEFAULT true,
    jc_show_help_shortlist boolean DEFAULT true,
    jc_show_help_meeting_log boolean DEFAULT true,
    f1kr_tracking_alert_frequency_updated timestamp without time zone,
    library_new_references_in_project_email_frequency integer DEFAULT 1,
    library_new_references_in_project_email_last_sent timestamp without time zone,
    proxy_url character varying(1024),
    library_new_suggestions_email_frequency integer,
    library_new_suggestions_email_last_sent timestamp without time zone,
    do_not_contact boolean DEFAULT false,
    f1000_updates_date timestamp without time zone DEFAULT now(),
    f1000_partner_updates_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.upo OWNER TO f1000;

--
-- TOC entry 798 (class 1259 OID 32237914)
-- Name: upo_export_tmp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.upo_export_tmp (
    usr_id numeric(19,0) NOT NULL,
    email_format character varying(256),
    f1000_updates boolean,
    f1000_partner_updates boolean,
    sections_alert_frequency numeric,
    sections_alert_results_limit numeric,
    sections_alert_last_sent timestamp without time zone,
    updates_last_change timestamp without time zone,
    partner_updates_last_change timestamp without time zone,
    pubmed_search_email_frequency integer,
    pubmed_email_results_limit integer,
    pubmed_search_email_last_sent timestamp without time zone,
    f1000_librarian_newsletter boolean,
    librarian_newsletter_last_change timestamp without time zone,
    draft_submissions_reminder boolean,
    sms_filter_type character varying(255),
    following_articles_alerts boolean,
    following_members_alerts boolean,
    sections_alert_frequency_trials numeric,
    sections_alert_last_sent_trials timestamp without time zone,
    sections_alert_results_limit_trials numeric,
    journal_club_meeting_creation_alert boolean,
    journal_club_short_list_completed_alert boolean,
    journal_club_meeting_reminder_days numeric(5,0),
    f1kr_tracking_alert_frequency character varying(40),
    f1kr_tracking_alert_last_sent timestamp without time zone,
    f1kr_stop_tracking_alerts_once_indexed boolean,
    home_teaser_alert_frequency numeric,
    home_teaser_alert_last_sent timestamp without time zone,
    f1kr_subjects_alert_frequency character varying(40),
    f1kr_subjects_alert_results_limit numeric(6,0),
    f1kr_subjects_alert_last_sent timestamp without time zone,
    trials_pubmed_search_email_last_sent timestamp without time zone,
    home_teaser_alert_previous_sent timestamp without time zone,
    jc_show_help_admin boolean,
    jc_show_help_home_page boolean,
    jc_show_help_article_selection boolean,
    jc_show_help_shortlist boolean,
    jc_show_help_meeting_log boolean,
    f1kr_tracking_alert_frequency_updated timestamp without time zone,
    library_new_references_in_project_email_frequency integer,
    library_new_references_in_project_email_last_sent timestamp without time zone,
    proxy_url character varying(1024),
    library_new_suggestions_email_frequency integer,
    library_new_suggestions_email_last_sent timestamp without time zone,
    do_not_contact boolean,
    f1000_updates_date timestamp without time zone,
    f1000_partner_updates_date timestamp without time zone
);


ALTER TABLE public.upo_export_tmp OWNER TO f1000;

--
-- TOC entry 753 (class 1259 OID 115904)
-- Name: usa_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.usa_seq
    START WITH 21035019691080961
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usa_seq OWNER TO f1000;

--
-- TOC entry 754 (class 1259 OID 115906)
-- Name: usa; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usa (
    usa_id numeric(19,0) DEFAULT nextval('public.usa_seq'::regclass) NOT NULL,
    usa_usr_id numeric(19,0),
    usa_type character varying(10) NOT NULL,
    usa_addr1 character varying(200),
    usa_addr2 character varying(200),
    usa_city character varying(100),
    usa_state character varying(64),
    usa_zip character varying(200),
    usa_tel character varying(64),
    usa_fax character varying(64),
    usa_cou_id numeric(19,0),
    usa_ins_id numeric(19,0),
    usa_think_state character varying(15)
);


ALTER TABLE public.usa OWNER TO f1000;

--
-- TOC entry 800 (class 1259 OID 32237926)
-- Name: usa_export_tmp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usa_export_tmp (
    usa_id numeric(19,0) NOT NULL,
    usa_usr_id numeric(19,0),
    usa_type character varying(10) NOT NULL,
    usa_addr1 character varying(200),
    usa_addr2 character varying(200),
    usa_city character varying(100),
    usa_state character varying(64),
    usa_zip character varying(200),
    usa_tel character varying(64),
    usa_fax character varying(64),
    usa_cou_id numeric(19,0),
    usa_ins_id numeric(19,0),
    usa_think_state character varying(15)
);


ALTER TABLE public.usa_export_tmp OWNER TO f1000;

--
-- TOC entry 755 (class 1259 OID 115913)
-- Name: usb; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usb (
    usb_id character varying(32) NOT NULL,
    usb_subscriber_id character varying(32) NOT NULL,
    usb_mailing_usa_id numeric(19,0) NOT NULL,
    usb_billing_usa_id numeric(19,0),
    usb_jou_id numeric(19,0),
    usb_start_date timestamp without time zone,
    usb_end_date timestamp without time zone,
    usb_duration numeric,
    usb_type character varying(25),
    usb_media character varying(25),
    usb_email character varying(64),
    usb_lab_usb_id character varying(32),
    usb_reminder_status character varying(20),
    usb_status character varying(15) DEFAULT 'LIVE'::character varying,
    usb_card_attempt boolean DEFAULT false,
    usb_prm_id numeric(19,0),
    usb_sms_payment_id character varying(32),
    usb_consortium_id character varying(32),
    active character varying(20),
    creator numeric(19,0),
    creation_date timestamp without time zone,
    likes_counter numeric DEFAULT 0
);


ALTER TABLE public.usb OWNER TO f1000;

--
-- TOC entry 756 (class 1259 OID 115922)
-- Name: user_area_of_interest; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.user_area_of_interest (
    user_id numeric(19,0) NOT NULL,
    area_of_interest_id numeric(19,0) NOT NULL
);


ALTER TABLE public.user_area_of_interest OWNER TO f1000;

--
-- TOC entry 757 (class 1259 OID 115925)
-- Name: user_job_type_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.user_job_type_seq
    START WITH 9996136691461370
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_job_type_seq OWNER TO f1000;

--
-- TOC entry 758 (class 1259 OID 115927)
-- Name: user_oauth; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.user_oauth (
    usr_id numeric(19,0) NOT NULL,
    oauth_id character varying(100),
    system character varying(10) NOT NULL
);


ALTER TABLE public.user_oauth OWNER TO f1000;

--
-- TOC entry 759 (class 1259 OID 115930)
-- Name: user_sso_key; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.user_sso_key (
    usr_id numeric(19,0) NOT NULL,
    key character varying(250),
    initialization_vector bytea,
    target_system character varying(8) DEFAULT 'PRIME'::character varying NOT NULL
);


ALTER TABLE public.user_sso_key OWNER TO f1000;

--
-- TOC entry 760 (class 1259 OID 115937)
-- Name: user_token; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.user_token (
    usr_id numeric(19,0) NOT NULL,
    token character varying(255),
    subscription_type character varying(255)
);


ALTER TABLE public.user_token OWNER TO f1000;

--
-- TOC entry 761 (class 1259 OID 115943)
-- Name: user_video; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.user_video (
    id numeric(19,0) NOT NULL,
    usr_id numeric(19,0) NOT NULL,
    title character varying(256) NOT NULL,
    blurb character varying(4096) NOT NULL,
    embed_code character varying(512),
    published boolean DEFAULT false NOT NULL,
    keywords text,
    story_id numeric(19,0)
);


ALTER TABLE public.user_video OWNER TO f1000;

--
-- TOC entry 762 (class 1259 OID 115950)
-- Name: user_video_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.user_video_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_video_seq OWNER TO f1000;

--
-- TOC entry 763 (class 1259 OID 115952)
-- Name: usi_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.usi_seq
    START WITH 20501837791000304
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usi_seq OWNER TO f1000;

--
-- TOC entry 764 (class 1259 OID 115954)
-- Name: usi; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usi (
    usi_id numeric(19,0) DEFAULT nextval('public.usi_seq'::regclass) NOT NULL,
    usi_usr_id numeric(19,0) NOT NULL,
    usi_title character varying(30),
    usi_ppl_id numeric(19,0),
    usi_org character varying(256),
    usi_dept character varying(256),
    usi_interests character varying(4000),
    usi_usj_id numeric(19,0),
    usi_usw_id numeric(19,0),
    usi_professional numeric(19,0),
    usi_specialty_other_life character varying(64),
    usi_specialty_other_non_life character varying(64),
    usi_email_format character varying(100),
    usi_think_cus_id character varying(32),
    usi_job_id numeric(19,0),
    bibleinstitution_id bigint,
    nickname text,
    biography text,
    photograph_id numeric,
    external_photograph character varying(256),
    priority_notes text,
    priority_notes_last_edit_date timestamp without time zone,
    facebook_link character varying(1024),
    twitter_link character varying(1024),
    linkedin_link character varying(1024),
    priority_notes_last_updater numeric(19,0),
    job_title character varying(255),
    affiliation_uid uuid
);


ALTER TABLE public.usi OWNER TO f1000;

--
-- TOC entry 799 (class 1259 OID 32237920)
-- Name: usi_export_tmp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usi_export_tmp (
    usi_id numeric(19,0) NOT NULL,
    usi_usr_id numeric(19,0) NOT NULL,
    usi_title character varying(30),
    usi_ppl_id numeric(19,0),
    usi_org character varying(256),
    usi_dept character varying(256),
    usi_interests character varying(4000),
    usi_usj_id numeric(19,0),
    usi_usw_id numeric(19,0),
    usi_professional numeric(19,0),
    usi_specialty_other_life character varying(64),
    usi_specialty_other_non_life character varying(64),
    usi_email_format character varying(100),
    usi_think_cus_id character varying(32),
    usi_job_id numeric(19,0),
    bibleinstitution_id bigint,
    nickname text,
    biography text,
    photograph_id numeric,
    external_photograph character varying(256),
    priority_notes text,
    priority_notes_last_edit_date timestamp without time zone,
    facebook_link character varying(1024),
    twitter_link character varying(1024),
    linkedin_link character varying(1024),
    priority_notes_last_updater numeric(19,0),
    job_title character varying(255),
    affiliation_uid uuid
);


ALTER TABLE public.usi_export_tmp OWNER TO f1000;

--
-- TOC entry 765 (class 1259 OID 115961)
-- Name: usr_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.usr_seq
    START WITH 9999995421943818
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usr_seq OWNER TO f1000;

--
-- TOC entry 766 (class 1259 OID 115963)
-- Name: usr; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usr (
    usr_id numeric(19,0) DEFAULT nextval('public.usr_seq'::regclass) NOT NULL,
    usr_email character varying(64),
    usr_fname character varying(64),
    usr_lname character varying(64),
    usr_passwd character varying(64),
    usr_terms boolean,
    usr_status character varying(16) NOT NULL,
    usr_email_status character varying(16),
    usr_registered timestamp without time zone DEFAULT now(),
    usr_joined_via character varying(32),
    usr_subscriber_id character varying(32),
    usr_ins_id numeric(19,0),
    usr_homepage character varying(1024),
    usr_middle_initials character varying(64),
    usr_source character varying(32),
    usr_ins_authdate date,
    usr_merged_into_usr_id numeric(19,0),
    usr_xml_rebuild boolean,
    usr_xml text,
    accepted_terms_and_conditions boolean DEFAULT false NOT NULL,
    accepted_comment_terms_and_con boolean DEFAULT false NOT NULL,
    microsite_id numeric(19,0),
    microsite_username character varying(256),
    usr_referral character varying(32),
    api_shared_secret character varying(256),
    last_access timestamp without time zone,
    institution_id bigint,
    blocked_comments boolean,
    accepted_terms_and_conditions_research boolean DEFAULT false NOT NULL,
    user_type character varying(16) DEFAULT 'F1000'::character varying,
    accepted_comment_terms_and_con_research boolean DEFAULT false,
    welcome_email_sent timestamp without time zone,
    hashed_password character(64),
    workbench_access boolean DEFAULT false,
    workbench_status character varying(64) DEFAULT 'NEVER_ACCESSED'::character varying
);


ALTER TABLE public.usr OWNER TO f1000;

--
-- TOC entry 767 (class 1259 OID 115978)
-- Name: usr_com_abuse_report_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.usr_com_abuse_report_seq
    START WITH 1291
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usr_com_abuse_report_seq OWNER TO f1000;

--
-- TOC entry 797 (class 1259 OID 32237908)
-- Name: usr_export_tmp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usr_export_tmp (
    usr_id numeric(19,0) NOT NULL,
    usr_email character varying(64),
    usr_fname character varying(64),
    usr_lname character varying(64),
    usr_passwd character varying(64),
    usr_terms boolean,
    usr_status character varying(16) NOT NULL,
    usr_email_status character varying(16),
    usr_registered timestamp without time zone,
    usr_joined_via character varying(32),
    usr_subscriber_id character varying(32),
    usr_ins_id numeric(19,0),
    usr_homepage character varying(1024),
    usr_middle_initials character varying(64),
    usr_source character varying(32),
    usr_ins_authdate date,
    usr_merged_into_usr_id numeric(19,0),
    usr_xml_rebuild boolean,
    usr_xml text,
    accepted_terms_and_conditions boolean NOT NULL,
    accepted_comment_terms_and_con boolean NOT NULL,
    microsite_id numeric(19,0),
    microsite_username character varying(256),
    usr_referral character varying(32),
    api_shared_secret character varying(256),
    last_access timestamp without time zone,
    institution_id bigint,
    blocked_comments boolean,
    accepted_terms_and_conditions_research boolean NOT NULL,
    user_type character varying(16),
    accepted_comment_terms_and_con_research boolean,
    welcome_email_sent timestamp without time zone,
    hashed_password character(64),
    workbench_access boolean,
    workbench_status character varying(64)
);


ALTER TABLE public.usr_export_tmp OWNER TO f1000;

--
-- TOC entry 768 (class 1259 OID 115980)
-- Name: usr_fav_faculty_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.usr_fav_faculty_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usr_fav_faculty_seq OWNER TO f1000;

--
-- TOC entry 802 (class 1259 OID 32237944)
-- Name: usr_import_tmp; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.usr_import_tmp (
    usr_id numeric(19,0)
);


ALTER TABLE public.usr_import_tmp OWNER TO f1000;

--
-- TOC entry 769 (class 1259 OID 115982)
-- Name: uss; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.uss (
    uss_id numeric(19,0) NOT NULL,
    uss_usr_id numeric(19,0) NOT NULL,
    uss_spc_id numeric(19,0) NOT NULL
);


ALTER TABLE public.uss OWNER TO f1000;

--
-- TOC entry 783 (class 1259 OID 13534117)
-- Name: version_affiliation_position; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.version_affiliation_position (
    uid uuid NOT NULL,
    version_id numeric(19,0),
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.version_affiliation_position OWNER TO f1000;

--
-- TOC entry 773 (class 1259 OID 274198)
-- Name: version_editor_role; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.version_editor_role (
    id numeric(19,0) NOT NULL,
    version_id numeric(19,0),
    editor_id numeric(19,0),
    email character varying(255),
    full_name character varying(255),
    role character varying(255)
);


ALTER TABLE public.version_editor_role OWNER TO f1000;

--
-- TOC entry 772 (class 1259 OID 274196)
-- Name: version_editor_role_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.version_editor_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.version_editor_role_seq OWNER TO f1000;

--
-- TOC entry 770 (class 1259 OID 115985)
-- Name: warehouse_itemstockavailability; Type: TABLE; Schema: public; Owner: f1000
--

CREATE TABLE public.warehouse_itemstockavailability (
    "itemId" character varying NOT NULL,
    "quantityAvailable" character varying NOT NULL
);


ALTER TABLE public.warehouse_itemstockavailability OWNER TO f1000;

--
-- TOC entry 771 (class 1259 OID 115991)
-- Name: weekly_top_rated_article_id_seq; Type: SEQUENCE; Schema: public; Owner: f1000
--

CREATE SEQUENCE public.weekly_top_rated_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weekly_top_rated_article_id_seq OWNER TO f1000;

--
-- TOC entry 5852 (class 2604 OID 5954770)
-- Name: f1000r_content_usage_stats id; Type: DEFAULT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_content_usage_stats ALTER COLUMN id SET DEFAULT nextval('public.f1000r_content_usage_stats_id_seq'::regclass);


--
-- TOC entry 6071 (class 2604 OID 29711975)
-- Name: f1000r_preprint_check_options id; Type: DEFAULT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_preprint_check_options ALTER COLUMN id SET DEFAULT nextval('public.f1000r_preprint_check_options_seq'::regclass);


--
-- TOC entry 5992 (class 2604 OID 115994)
-- Name: microservice_deployment id; Type: DEFAULT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.microservice_deployment ALTER COLUMN id SET DEFAULT nextval('public.microservice_deployment_id_seq'::regclass);


--
-- TOC entry 5994 (class 2604 OID 115995)
-- Name: oauth_code id; Type: DEFAULT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.oauth_code ALTER COLUMN id SET DEFAULT nextval('public.oauth_code_id_seq'::regclass);


--
-- TOC entry 5996 (class 2604 OID 115996)
-- Name: oauth_token id; Type: DEFAULT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.oauth_token ALTER COLUMN id SET DEFAULT nextval('public.oauth_token_id_seq'::regclass);


--
-- TOC entry 6736 (class 2606 OID 158272)
-- Name: user_oauth PK_user_oauth_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_oauth
    ADD CONSTRAINT "PK_user_oauth_id" PRIMARY KEY (usr_id, system);


--
-- TOC entry 6738 (class 2606 OID 158274)
-- Name: user_sso_key PK_user_sso_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_sso_key
    ADD CONSTRAINT "PK_user_sso_key" PRIMARY KEY (usr_id, target_system);


--
-- TOC entry 6123 (class 2606 OID 26389912)
-- Name: f1000r_article_citation_statistics acs_unique_article_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_citation_statistics
    ADD CONSTRAINT acs_unique_article_id UNIQUE (article_id);


--
-- TOC entry 6084 (class 2606 OID 158276)
-- Name: article article_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id);


--
-- TOC entry 6092 (class 2606 OID 158278)
-- Name: articles_thesaurus_terms articles_thesaurus_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.articles_thesaurus_terms
    ADD CONSTRAINT articles_thesaurus_terms_pkey PRIMARY KEY (article_id, term_id);


--
-- TOC entry 6207 (class 2606 OID 158282)
-- Name: f1000r_asset_department asset_department_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_department
    ADD CONSTRAINT asset_department_pkey PRIMARY KEY (id);


--
-- TOC entry 6211 (class 2606 OID 158284)
-- Name: f1000r_asset_grant asset_grant_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_grant
    ADD CONSTRAINT asset_grant_pk PRIMARY KEY (id);


--
-- TOC entry 6213 (class 2606 OID 158286)
-- Name: f1000r_asset_institution asset_institution_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_institution
    ADD CONSTRAINT asset_institution_pkey PRIMARY KEY (id);


--
-- TOC entry 6185 (class 2606 OID 158288)
-- Name: f1000r_asset asset_metadata_id_unique; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT asset_metadata_id_unique UNIQUE (asset_metadata_id);


--
-- TOC entry 6215 (class 2606 OID 158290)
-- Name: f1000r_asset_metadata asset_metadata_unique_f1000_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_metadata
    ADD CONSTRAINT asset_metadata_unique_f1000_id UNIQUE (f1000_id);


--
-- TOC entry 6187 (class 2606 OID 158292)
-- Name: f1000r_asset asset_unique_f1000_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT asset_unique_f1000_id UNIQUE (f1000_id);


--
-- TOC entry 6099 (class 2606 OID 158294)
-- Name: bible_institution bible_institution_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.bible_institution
    ADD CONSTRAINT bible_institution_pkey PRIMARY KEY (id);


--
-- TOC entry 6726 (class 2606 OID 158298)
-- Name: usa cbmc_usa_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.usa
    ADD CONSTRAINT cbmc_usa_pk PRIMARY KEY (usa_id);


--
-- TOC entry 6729 (class 2606 OID 158300)
-- Name: usb cbmc_usb_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.usb
    ADD CONSTRAINT cbmc_usb_pk PRIMARY KEY (usb_id);


--
-- TOC entry 6750 (class 2606 OID 158302)
-- Name: usi cbmc_usi_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.usi
    ADD CONSTRAINT cbmc_usi_pk PRIMARY KEY (usi_id);


--
-- TOC entry 6762 (class 2606 OID 158304)
-- Name: uss cbmc_uss_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.uss
    ADD CONSTRAINT cbmc_uss_pk PRIMARY KEY (uss_id);


--
-- TOC entry 6785 (class 2606 OID 27632839)
-- Name: collective_author_file collective_author_file_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.collective_author_file
    ADD CONSTRAINT collective_author_file_pkey PRIMARY KEY (id);


--
-- TOC entry 6103 (class 2606 OID 158306)
-- Name: cursor cursor_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.cursor
    ADD CONSTRAINT cursor_pkey PRIMARY KEY (id);


--
-- TOC entry 6783 (class 2606 OID 22420339)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 6772 (class 2606 OID 8221491)
-- Name: dataset_additional_details dataset_additional_details_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.dataset_additional_details
    ADD CONSTRAINT dataset_additional_details_pkey PRIMARY KEY (id);


--
-- TOC entry 6563 (class 2606 OID 158308)
-- Name: f1000r_user_demographic demographic_usr_id_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_demographic
    ADD CONSTRAINT demographic_usr_id_pk PRIMARY KEY (usr_id);


--
-- TOC entry 6105 (class 2606 OID 158310)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- TOC entry 6364 (class 2606 OID 158312)
-- Name: f1000r_external_item external_item_unique_internal_id_type_unq; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_item
    ADD CONSTRAINT external_item_unique_internal_id_type_unq UNIQUE (internal_id, type);


--
-- TOC entry 6641 (class 2606 OID 158314)
-- Name: fgr f1000_fgr_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.fgr
    ADD CONSTRAINT f1000_fgr_pk PRIMARY KEY (fgr_id);


--
-- TOC entry 6643 (class 2606 OID 158316)
-- Name: frg f1000_frg_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.frg
    ADD CONSTRAINT f1000_frg_pk PRIMARY KEY (frg_id);


--
-- TOC entry 6567 (class 2606 OID 158318)
-- Name: fro f1000_fro_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.fro
    ADD CONSTRAINT f1000_fro_pk PRIMARY KEY (fro_id);


--
-- TOC entry 6569 (class 2606 OID 158320)
-- Name: fug f1000_fug_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.fug
    ADD CONSTRAINT f1000_fug_pk PRIMARY KEY (fug_id);


--
-- TOC entry 6107 (class 2606 OID 158322)
-- Name: f1000_user_specified_job_type f1000_ujt_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000_user_specified_job_type
    ADD CONSTRAINT f1000_ujt_pk PRIMARY KEY (ujt_id);


--
-- TOC entry 6121 (class 2606 OID 158324)
-- Name: f1000r_article_citation_count f1000r_article_citation_count_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_citation_count
    ADD CONSTRAINT f1000r_article_citation_count_pkey PRIMARY KEY (id);


--
-- TOC entry 6126 (class 2606 OID 158326)
-- Name: f1000r_article_citation_statistics f1000r_article_citation_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_citation_statistics
    ADD CONSTRAINT f1000r_article_citation_statistics_pkey PRIMARY KEY (id);


--
-- TOC entry 6138 (class 2606 OID 158328)
-- Name: f1000r_article_dataset_draft f1000r_article_dataset_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_dataset_draft
    ADD CONSTRAINT f1000r_article_dataset_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 6136 (class 2606 OID 158330)
-- Name: f1000r_article_dataset f1000r_article_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_dataset
    ADD CONSTRAINT f1000r_article_dataset_pkey PRIMARY KEY (id);


--
-- TOC entry 6146 (class 2606 OID 158332)
-- Name: f1000r_article_person_orcid f1000r_article_person_orcid_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_person_orcid
    ADD CONSTRAINT f1000r_article_person_orcid_pkey PRIMARY KEY (id);


--
-- TOC entry 6152 (class 2606 OID 158334)
-- Name: f1000r_article_question f1000r_article_question_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_question
    ADD CONSTRAINT f1000r_article_question_pkey PRIMARY KEY (id);


--
-- TOC entry 6154 (class 2606 OID 158336)
-- Name: f1000r_article_question_result f1000r_article_question_resul_question_id_version_id_articl_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_question_result
    ADD CONSTRAINT f1000r_article_question_resul_question_id_version_id_articl_key UNIQUE (question_id, version_id, article_referee_id);


--
-- TOC entry 6156 (class 2606 OID 158338)
-- Name: f1000r_article_question_result f1000r_article_question_result_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_question_result
    ADD CONSTRAINT f1000r_article_question_result_pkey PRIMARY KEY (id);


--
-- TOC entry 6171 (class 2606 OID 158340)
-- Name: f1000r_article_referee_survey_answer f1000r_article_referee_survey_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_survey_answer
    ADD CONSTRAINT f1000r_article_referee_survey_answer_pkey PRIMARY KEY (id);


--
-- TOC entry 6169 (class 2606 OID 158342)
-- Name: f1000r_article_referee_survey f1000r_article_referee_survey_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_survey
    ADD CONSTRAINT f1000r_article_referee_survey_pkey PRIMARY KEY (id);


--
-- TOC entry 6173 (class 2606 OID 158344)
-- Name: f1000r_article_statistic f1000r_article_statistic_article_id_milestone_views_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_statistic
    ADD CONSTRAINT f1000r_article_statistic_article_id_milestone_views_key UNIQUE (article_id, milestone_views);


--
-- TOC entry 6179 (class 2606 OID 158346)
-- Name: f1000r_article_type_display_order f1000r_article_type_display_order_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_type_display_order
    ADD CONSTRAINT f1000r_article_type_display_order_pkey PRIMARY KEY (id);


--
-- TOC entry 6182 (class 2606 OID 158348)
-- Name: f1000r_article_view_log f1000r_article_view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_view_log
    ADD CONSTRAINT f1000r_article_view_log_pkey PRIMARY KEY (id);


--
-- TOC entry 6195 (class 2606 OID 158350)
-- Name: f1000r_asset_affiliation f1000r_asset_affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_affiliation
    ADD CONSTRAINT f1000r_asset_affiliation_pkey PRIMARY KEY (id);


--
-- TOC entry 6200 (class 2606 OID 13534088)
-- Name: f1000r_asset_author_affiliation f1000r_asset_author_affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author_affiliation
    ADD CONSTRAINT f1000r_asset_author_affiliation_pkey PRIMARY KEY (id);


--
-- TOC entry 6219 (class 2606 OID 158352)
-- Name: f1000r_asset_share_log f1000r_asset_share_log_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_share_log
    ADD CONSTRAINT f1000r_asset_share_log_pkey PRIMARY KEY (id);


--
-- TOC entry 6223 (class 2606 OID 158354)
-- Name: f1000r_asset_supplementary_file f1000r_asset_supplementary_file_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_supplementary_file
    ADD CONSTRAINT f1000r_asset_supplementary_file_pkey PRIMARY KEY (id);


--
-- TOC entry 6227 (class 2606 OID 158356)
-- Name: f1000r_asset_thesaurus_term_f1000ont f1000r_asset_thesaurus_term_f1000ont_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_thesaurus_term_f1000ont
    ADD CONSTRAINT f1000r_asset_thesaurus_term_f1000ont_pkey PRIMARY KEY (id);


--
-- TOC entry 6225 (class 2606 OID 158358)
-- Name: f1000r_asset_thesaurus_term f1000r_asset_thesaurus_term_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_thesaurus_term
    ADD CONSTRAINT f1000r_asset_thesaurus_term_pkey PRIMARY KEY (id);


--
-- TOC entry 6236 (class 2606 OID 158360)
-- Name: f1000r_asset_view_log f1000r_asset_view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_view_log
    ADD CONSTRAINT f1000r_asset_view_log_pkey PRIMARY KEY (id);


--
-- TOC entry 6253 (class 2606 OID 158362)
-- Name: f1000r_author_version_contributor_role_draft f1000r_author_version_contributor_role_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_contributor_role_draft
    ADD CONSTRAINT f1000r_author_version_contributor_role_draft_pkey PRIMARY KEY (author_version_draft_id, contributor_role_id);


--
-- TOC entry 6251 (class 2606 OID 158364)
-- Name: f1000r_author_version_contributor_role f1000r_author_version_contributor_role_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_contributor_role
    ADD CONSTRAINT f1000r_author_version_contributor_role_pkey PRIMARY KEY (author_version_id, contributor_role_id);


--
-- TOC entry 6255 (class 2606 OID 158366)
-- Name: f1000r_author_version_draft f1000r_author_version_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_draft
    ADD CONSTRAINT f1000r_author_version_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 6261 (class 2606 OID 158368)
-- Name: f1000r_citedby_data f1000r_citedby_data_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_citedby_data
    ADD CONSTRAINT f1000r_citedby_data_pkey PRIMARY KEY (version_id);


--
-- TOC entry 6263 (class 2606 OID 158370)
-- Name: f1000r_co_author_email_notification_tracking f1000r_co_author_email_notification_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_co_author_email_notification_tracking
    ADD CONSTRAINT f1000r_co_author_email_notification_tracking_pkey PRIMARY KEY (id);


--
-- TOC entry 6791 (class 2606 OID 30964195)
-- Name: f1000r_collection_custompages f1000r_collection_custompages_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_custompages
    ADD CONSTRAINT f1000r_collection_custompages_pkey PRIMARY KEY (id);


--
-- TOC entry 6275 (class 2606 OID 158372)
-- Name: f1000r_collection_link f1000r_collection_link_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_link
    ADD CONSTRAINT f1000r_collection_link_pkey PRIMARY KEY (id);


--
-- TOC entry 6277 (class 2606 OID 158374)
-- Name: f1000r_collection_news f1000r_collection_news_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_news
    ADD CONSTRAINT f1000r_collection_news_pkey PRIMARY KEY (id);


--
-- TOC entry 6296 (class 2606 OID 158376)
-- Name: f1000r_comment_report f1000r_comment_report_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment_report
    ADD CONSTRAINT f1000r_comment_report_pkey PRIMARY KEY (comment_id, report_id);


--
-- TOC entry 6306 (class 2606 OID 158378)
-- Name: f1000r_content f1000r_content_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_content
    ADD CONSTRAINT f1000r_content_pkey PRIMARY KEY (id);


--
-- TOC entry 6310 (class 2606 OID 158380)
-- Name: f1000r_content_usage_stats f1000r_content_usage_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_content_usage_stats
    ADD CONSTRAINT f1000r_content_usage_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 6325 (class 2606 OID 158382)
-- Name: f1000r_document_type f1000r_document_type_name_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_document_type
    ADD CONSTRAINT f1000r_document_type_name_key UNIQUE (name);


--
-- TOC entry 6329 (class 2606 OID 158384)
-- Name: f1000r_doi_status f1000r_doi_status_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_doi_status
    ADD CONSTRAINT f1000r_doi_status_pkey PRIMARY KEY (id);


--
-- TOC entry 6331 (class 2606 OID 158386)
-- Name: f1000r_editor_external_count f1000r_editor_external_count_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_editor_external_count
    ADD CONSTRAINT f1000r_editor_external_count_pkey PRIMARY KEY (id);


--
-- TOC entry 6343 (class 2606 OID 158388)
-- Name: f1000r_email_message_attachement f1000r_email_message_attachement_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message_attachement
    ADD CONSTRAINT f1000r_email_message_attachement_pkey PRIMARY KEY (id);


--
-- TOC entry 6341 (class 2606 OID 158390)
-- Name: f1000r_email_message f1000r_email_message_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message
    ADD CONSTRAINT f1000r_email_message_pkey PRIMARY KEY (id);


--
-- TOC entry 6348 (class 2606 OID 158392)
-- Name: f1000r_enquiry_reason f1000r_enquiry_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_enquiry_reason
    ADD CONSTRAINT f1000r_enquiry_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 6352 (class 2606 OID 158394)
-- Name: f1000r_enquiry_reason_template f1000r_enquiry_reason_template_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_enquiry_reason_template
    ADD CONSTRAINT f1000r_enquiry_reason_template_pkey PRIMARY KEY (id);


--
-- TOC entry 6354 (class 2606 OID 158396)
-- Name: f1000r_enquiry_reason_template_version f1000r_enquiry_reason_template_version_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_enquiry_reason_template_version
    ADD CONSTRAINT f1000r_enquiry_reason_template_version_pkey PRIMARY KEY (id);


--
-- TOC entry 6356 (class 2606 OID 158398)
-- Name: f1000r_etoc_alert_term f1000r_etoc_alert_term_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_etoc_alert_term
    ADD CONSTRAINT f1000r_etoc_alert_term_pkey PRIMARY KEY (id);


--
-- TOC entry 6362 (class 2606 OID 158400)
-- Name: f1000r_external_indexer_submission f1000r_external_indexer_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_indexer_submission
    ADD CONSTRAINT f1000r_external_indexer_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 6367 (class 2606 OID 158402)
-- Name: f1000r_external_item f1000r_external_item_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_item
    ADD CONSTRAINT f1000r_external_item_pkey PRIMARY KEY (id);


--
-- TOC entry 6369 (class 2606 OID 158404)
-- Name: f1000r_external_submission_data f1000r_external_submission_data_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_submission_data
    ADD CONSTRAINT f1000r_external_submission_data_pkey PRIMARY KEY (id);


--
-- TOC entry 6379 (class 2606 OID 158406)
-- Name: f1000r_feedback f1000r_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_feedback
    ADD CONSTRAINT f1000r_feedback_pkey PRIMARY KEY (id);


--
-- TOC entry 6381 (class 2606 OID 158408)
-- Name: f1000r_feedback_terms f1000r_feedback_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_feedback_terms
    ADD CONSTRAINT f1000r_feedback_terms_pkey PRIMARY KEY (id);


--
-- TOC entry 6383 (class 2606 OID 158410)
-- Name: f1000r_funder_information f1000r_funder_information_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_funder_information
    ADD CONSTRAINT f1000r_funder_information_pkey PRIMARY KEY (id);


--
-- TOC entry 6385 (class 2606 OID 158412)
-- Name: f1000r_grant_information f1000r_grant_information_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_grant_information
    ADD CONSTRAINT f1000r_grant_information_pkey PRIMARY KEY (id);


--
-- TOC entry 6389 (class 2606 OID 158414)
-- Name: f1000r_invoice_file f1000r_invoice_file_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_invoice_file
    ADD CONSTRAINT f1000r_invoice_file_pk PRIMARY KEY (id);


--
-- TOC entry 6397 (class 2606 OID 158416)
-- Name: f1000r_linked_file f1000r_linked_file_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_linked_file
    ADD CONSTRAINT f1000r_linked_file_pk PRIMARY KEY (id);


--
-- TOC entry 6787 (class 2606 OID 28552887)
-- Name: f1000r_opposed_reviewers_draft f1000r_opposed_reviewers_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_opposed_reviewers_draft
    ADD CONSTRAINT f1000r_opposed_reviewers_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 6778 (class 2606 OID 15859951)
-- Name: f1000r_partner_target_selected f1000r_partner_target_selected_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_partner_target_selected
    ADD CONSTRAINT f1000r_partner_target_selected_pkey PRIMARY KEY (id);


--
-- TOC entry 6781 (class 2606 OID 15859953)
-- Name: f1000r_partner_target_selected f1000r_partner_target_uk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_partner_target_selected
    ADD CONSTRAINT f1000r_partner_target_uk UNIQUE (partner_id, target_id, target_type);


--
-- TOC entry 6776 (class 2606 OID 15859938)
-- Name: f1000r_partners f1000r_partners_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_partners
    ADD CONSTRAINT f1000r_partners_pkey PRIMARY KEY (id);


--
-- TOC entry 6418 (class 2606 OID 158418)
-- Name: f1000r_permanently_deleted_user f1000r_permanently_deleted_user_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_permanently_deleted_user
    ADD CONSTRAINT f1000r_permanently_deleted_user_pkey PRIMARY KEY (user_id);


--
-- TOC entry 6426 (class 2606 OID 158420)
-- Name: f1000r_potential_referee_affiliations f1000r_potential_referee_affiliations_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_potential_referee_affiliations
    ADD CONSTRAINT f1000r_potential_referee_affiliations_pkey PRIMARY KEY (id);


--
-- TOC entry 6428 (class 2606 OID 158422)
-- Name: f1000r_potential_referee_refs f1000r_potential_referee_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_potential_referee_refs
    ADD CONSTRAINT f1000r_potential_referee_refs_pkey PRIMARY KEY (id);


--
-- TOC entry 6789 (class 2606 OID 29711982)
-- Name: f1000r_preprint_check_options f1000r_preprint_check_options_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_preprint_check_options
    ADD CONSTRAINT f1000r_preprint_check_options_pkey PRIMARY KEY (id);


--
-- TOC entry 6436 (class 2606 OID 158424)
-- Name: f1000r_project_info f1000r_project_info_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_project_info
    ADD CONSTRAINT f1000r_project_info_pkey PRIMARY KEY (id);


--
-- TOC entry 6442 (class 2606 OID 158426)
-- Name: f1000r_project_info_version f1000r_project_info_version_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_project_info_version
    ADD CONSTRAINT f1000r_project_info_version_pkey PRIMARY KEY (id);


--
-- TOC entry 6464 (class 2606 OID 158428)
-- Name: f1000r_referee_related_article f1000r_referee_related_article_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_related_article
    ADD CONSTRAINT f1000r_referee_related_article_pkey PRIMARY KEY (id);


--
-- TOC entry 6469 (class 2606 OID 158430)
-- Name: f1000r_referee_report_draft f1000r_referee_report_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_report_draft
    ADD CONSTRAINT f1000r_referee_report_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 6476 (class 2606 OID 158432)
-- Name: f1000r_referee_suggestion_draft f1000r_referee_suggestion_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion_draft
    ADD CONSTRAINT f1000r_referee_suggestion_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 6471 (class 2606 OID 158434)
-- Name: f1000r_referee_suggestion f1000r_referee_suggestion_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion
    ADD CONSTRAINT f1000r_referee_suggestion_pkey PRIMARY KEY (id);


--
-- TOC entry 6478 (class 2606 OID 158436)
-- Name: f1000r_referee_suggestion_potential_ref f1000r_referee_suggestion_potential_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion_potential_ref
    ADD CONSTRAINT f1000r_referee_suggestion_potential_ref_pkey PRIMARY KEY (id);


--
-- TOC entry 6481 (class 2606 OID 158438)
-- Name: f1000r_referee_suggestion_related_articles f1000r_referee_suggestion_related_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion_related_articles
    ADD CONSTRAINT f1000r_referee_suggestion_related_articles_pkey PRIMARY KEY (id);


--
-- TOC entry 6473 (class 2606 OID 158440)
-- Name: f1000r_referee_suggestion f1000r_referee_suggestion_version_id_ref_tool_id_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion
    ADD CONSTRAINT f1000r_referee_suggestion_version_id_ref_tool_id_key UNIQUE (version_id, ref_tool_id);


--
-- TOC entry 6486 (class 2606 OID 158442)
-- Name: f1000r_referee_user_feedback f1000r_referee_user_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_user_feedback
    ADD CONSTRAINT f1000r_referee_user_feedback_pkey PRIMARY KEY (id);


--
-- TOC entry 6496 (class 2606 OID 158444)
-- Name: f1000r_report_article_thesaurus_term f1000r_report_article_thesaurus_term_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report_article_thesaurus_term
    ADD CONSTRAINT f1000r_report_article_thesaurus_term_pkey PRIMARY KEY (id);


--
-- TOC entry 6500 (class 2606 OID 158446)
-- Name: f1000r_report_view_log f1000r_report_view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report_view_log
    ADD CONSTRAINT f1000r_report_view_log_pkey PRIMARY KEY (id);


--
-- TOC entry 6507 (class 2606 OID 158448)
-- Name: f1000r_scoups_citation f1000r_scoups_citation_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_scoups_citation
    ADD CONSTRAINT f1000r_scoups_citation_pkey PRIMARY KEY (version_id);


--
-- TOC entry 6519 (class 2606 OID 158450)
-- Name: f1000r_suggested_referee_rejected_template f1000r_suggested_referee_rejected_template_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_suggested_referee_rejected_template
    ADD CONSTRAINT f1000r_suggested_referee_rejected_template_pkey PRIMARY KEY (id);


--
-- TOC entry 6522 (class 2606 OID 158452)
-- Name: f1000r_supplementary_file f1000r_supplementary_file_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_supplementary_file
    ADD CONSTRAINT f1000r_supplementary_file_pkey PRIMARY KEY (id);


--
-- TOC entry 6527 (class 2606 OID 158454)
-- Name: f1000r_thesaurus_term_cache f1000r_thesaurus_term_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_thesaurus_term_cache
    ADD CONSTRAINT f1000r_thesaurus_term_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 6561 (class 2606 OID 158456)
-- Name: f1000r_user_collection f1000r_user_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_collection
    ADD CONSTRAINT f1000r_user_collection_pkey PRIMARY KEY (id);


--
-- TOC entry 6585 (class 2606 OID 158458)
-- Name: f1000r_version_author_affiliation f1000r_version_author_affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_author_affiliation
    ADD CONSTRAINT f1000r_version_author_affiliation_pkey PRIMARY KEY (id);


--
-- TOC entry 6592 (class 2606 OID 158460)
-- Name: f1000r_version_email_chronos f1000r_version_email_chronos_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_email_chronos
    ADD CONSTRAINT f1000r_version_email_chronos_pkey PRIMARY KEY (id);


--
-- TOC entry 6594 (class 2606 OID 158462)
-- Name: f1000r_version_email_chronos f1000r_version_email_chronos_version_id_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_email_chronos
    ADD CONSTRAINT f1000r_version_email_chronos_version_id_key UNIQUE (version_id);


--
-- TOC entry 6598 (class 2606 OID 158464)
-- Name: f1000r_version_fulltext f1000r_version_fulltext_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_fulltext
    ADD CONSTRAINT f1000r_version_fulltext_pkey PRIMARY KEY (id);


--
-- TOC entry 6600 (class 2606 OID 158466)
-- Name: f1000r_version_fulltext f1000r_version_fulltext_version_id_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_fulltext
    ADD CONSTRAINT f1000r_version_fulltext_version_id_key UNIQUE (version_id);


--
-- TOC entry 6607 (class 2606 OID 158468)
-- Name: f1000r_version_status_check f1000r_version_status_check_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_status_check
    ADD CONSTRAINT f1000r_version_status_check_pkey PRIMARY KEY (id);


--
-- TOC entry 6613 (class 2606 OID 158470)
-- Name: f1000r_version_supplementary_file f1000r_version_supplementary_file_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_supplementary_file
    ADD CONSTRAINT f1000r_version_supplementary_file_pkey PRIMARY KEY (id);


--
-- TOC entry 6617 (class 2606 OID 158472)
-- Name: f1000r_version_thesaurus_term_f1000ont f1000r_version_thesaurus_term_f1000ont_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_thesaurus_term_f1000ont
    ADD CONSTRAINT f1000r_version_thesaurus_term_f1000ont_pkey PRIMARY KEY (id);


--
-- TOC entry 6615 (class 2606 OID 158474)
-- Name: f1000r_version_thesaurus_term f1000r_version_thesaurus_term_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_thesaurus_term
    ADD CONSTRAINT f1000r_version_thesaurus_term_pkey PRIMARY KEY (id);


--
-- TOC entry 6621 (class 2606 OID 158476)
-- Name: f1000r_visualized_file f1000r_visualized_file_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_visualized_file
    ADD CONSTRAINT f1000r_visualized_file_pkey PRIMARY KEY (id);


--
-- TOC entry 6625 (class 2606 OID 158478)
-- Name: f1000r_wellcome_grant_holder f1000r_wellcome_grant_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_wellcome_grant_holder
    ADD CONSTRAINT f1000r_wellcome_grant_holder_pkey PRIMARY KEY (id);


--
-- TOC entry 6627 (class 2606 OID 158480)
-- Name: f1000r_wellcome_grant_information f1000r_wellcome_grant_information_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_wellcome_grant_information
    ADD CONSTRAINT f1000r_wellcome_grant_information_pkey PRIMARY KEY (id);


--
-- TOC entry 6630 (class 2606 OID 158482)
-- Name: f1000r_wellcome_grant_pi_email f1000r_wellcome_grant_pi_email_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_wellcome_grant_pi_email
    ADD CONSTRAINT f1000r_wellcome_grant_pi_email_pkey PRIMARY KEY (id);


--
-- TOC entry 6636 (class 2606 OID 158484)
-- Name: faculty_member faculty_member_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.faculty_member
    ADD CONSTRAINT faculty_member_pkey PRIMARY KEY (id);


--
-- TOC entry 6632 (class 2606 OID 158486)
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- TOC entry 6688 (class 2606 OID 158488)
-- Name: research_grant grant_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_grant
    ADD CONSTRAINT grant_pk PRIMARY KEY (id);


--
-- TOC entry 6645 (class 2606 OID 158490)
-- Name: ins ins_open_athens_org_id_scope_unique; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.ins
    ADD CONSTRAINT ins_open_athens_org_id_scope_unique UNIQUE (openathens_org_id, openathens_scope);


--
-- TOC entry 6647 (class 2606 OID 158492)
-- Name: ins ins_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.ins
    ADD CONSTRAINT ins_pkey PRIMARY KEY (ins_id);


--
-- TOC entry 6649 (class 2606 OID 158494)
-- Name: institution institution_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.institution
    ADD CONSTRAINT institution_pkey PRIMARY KEY (id);


--
-- TOC entry 6657 (class 2606 OID 158496)
-- Name: logging_excluded_ip logging_excluded_ip_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.logging_excluded_ip
    ADD CONSTRAINT logging_excluded_ip_pkey PRIMARY KEY (id);


--
-- TOC entry 6659 (class 2606 OID 158498)
-- Name: microservice_deployment microservice_deployment_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.microservice_deployment
    ADD CONSTRAINT microservice_deployment_pkey PRIMARY KEY (id);


--
-- TOC entry 6662 (class 2606 OID 158500)
-- Name: oauth_code oauth_code_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.oauth_code
    ADD CONSTRAINT oauth_code_pkey PRIMARY KEY (id);


--
-- TOC entry 6669 (class 2606 OID 158502)
-- Name: oauth_token oauth_token_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.oauth_token
    ADD CONSTRAINT oauth_token_pkey PRIMARY KEY (id);


--
-- TOC entry 6672 (class 2606 OID 158504)
-- Name: ontology ontology_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.ontology
    ADD CONSTRAINT ontology_pkey PRIMARY KEY (id);


--
-- TOC entry 6677 (class 2606 OID 158506)
-- Name: orcid_access_data orcid_access_data_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.orcid_access_data
    ADD CONSTRAINT orcid_access_data_pkey PRIMARY KEY (id);


--
-- TOC entry 6680 (class 2606 OID 158508)
-- Name: photograph photograph_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.photograph
    ADD CONSTRAINT photograph_pkey PRIMARY KEY (id);


--
-- TOC entry 6710 (class 2606 OID 158510)
-- Name: term_relationship pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.term_relationship
    ADD CONSTRAINT pk PRIMARY KEY (child_id, parent_id);


--
-- TOC entry 6111 (class 2606 OID 158512)
-- Name: f1000r_affiliation pk_affiliation; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_affiliation
    ADD CONSTRAINT pk_affiliation PRIMARY KEY (id);


--
-- TOC entry 6117 (class 2606 OID 158514)
-- Name: f1000r_article pk_article; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article
    ADD CONSTRAINT pk_article PRIMARY KEY (id);


--
-- TOC entry 6128 (class 2606 OID 158516)
-- Name: f1000r_article_collection_suggestion pk_article_collection_suggestion; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_suggestion
    ADD CONSTRAINT pk_article_collection_suggestion PRIMARY KEY (id);


--
-- TOC entry 6134 (class 2606 OID 158518)
-- Name: f1000r_article_country pk_article_country; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_country
    ADD CONSTRAINT pk_article_country PRIMARY KEY (article_id, country_id);


--
-- TOC entry 6141 (class 2606 OID 158520)
-- Name: f1000r_article_log pk_article_log; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_log
    ADD CONSTRAINT pk_article_log PRIMARY KEY (id);


--
-- TOC entry 6144 (class 2606 OID 158522)
-- Name: f1000r_article_payment pk_article_payment; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_payment
    ADD CONSTRAINT pk_article_payment PRIMARY KEY (id);


--
-- TOC entry 6148 (class 2606 OID 158524)
-- Name: f1000r_article_pricing_category pk_article_pricing_type; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_pricing_category
    ADD CONSTRAINT pk_article_pricing_type PRIMARY KEY (id);


--
-- TOC entry 6160 (class 2606 OID 158526)
-- Name: f1000r_article_referee pk_article_referee; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee
    ADD CONSTRAINT pk_article_referee PRIMARY KEY (id);


--
-- TOC entry 6164 (class 2606 OID 158528)
-- Name: f1000r_article_referee_affiliation pk_article_referee_affiliation; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_affiliation
    ADD CONSTRAINT pk_article_referee_affiliation PRIMARY KEY (id);


--
-- TOC entry 6167 (class 2606 OID 158530)
-- Name: f1000r_article_referee_status_tracker pk_article_referee_status_tracker; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_status_tracker
    ADD CONSTRAINT pk_article_referee_status_tracker PRIMARY KEY (id);


--
-- TOC entry 6193 (class 2606 OID 158532)
-- Name: f1000r_asset pk_asset; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT pk_asset PRIMARY KEY (id);


--
-- TOC entry 6198 (class 2606 OID 158534)
-- Name: f1000r_asset_author pk_asset_author; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author
    ADD CONSTRAINT pk_asset_author PRIMARY KEY (id);


--
-- TOC entry 6203 (class 2606 OID 158536)
-- Name: f1000r_asset_collection_suggestion pk_asset_collection_suggestion; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_collection_suggestion
    ADD CONSTRAINT pk_asset_collection_suggestion PRIMARY KEY (id);


--
-- TOC entry 6205 (class 2606 OID 158538)
-- Name: f1000r_asset_country pk_asset_country; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_country
    ADD CONSTRAINT pk_asset_country PRIMARY KEY (asset_id, country_id);


--
-- TOC entry 6217 (class 2606 OID 158540)
-- Name: f1000r_asset_metadata pk_asset_metadata; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_metadata
    ADD CONSTRAINT pk_asset_metadata PRIMARY KEY (id);


--
-- TOC entry 6230 (class 2606 OID 158542)
-- Name: f1000r_asset_topic pk_asset_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_topic
    ADD CONSTRAINT pk_asset_topic PRIMARY KEY (asset_metadata_id, topic_id);


--
-- TOC entry 6232 (class 2606 OID 158544)
-- Name: f1000r_asset_upload_info pk_asset_upload_info; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_upload_info
    ADD CONSTRAINT pk_asset_upload_info PRIMARY KEY (id);


--
-- TOC entry 6234 (class 2606 OID 158546)
-- Name: f1000r_asset_view pk_asset_view; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_view
    ADD CONSTRAINT pk_asset_view PRIMARY KEY (id);


--
-- TOC entry 6238 (class 2606 OID 158548)
-- Name: f1000r_attachment_email_info pk_attachment_email_info; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_attachment_email_info
    ADD CONSTRAINT pk_attachment_email_info PRIMARY KEY (id);


--
-- TOC entry 6243 (class 2606 OID 158550)
-- Name: f1000r_author pk_author; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author
    ADD CONSTRAINT pk_author PRIMARY KEY (id);


--
-- TOC entry 6246 (class 2606 OID 158552)
-- Name: f1000r_author_version pk_author_version; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version
    ADD CONSTRAINT pk_author_version PRIMARY KEY (id);


--
-- TOC entry 6249 (class 2606 OID 158554)
-- Name: f1000r_author_version_affiliation_draft pk_author_version_affiliation_draft; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_affiliation_draft
    ADD CONSTRAINT pk_author_version_affiliation_draft PRIMARY KEY (id);


--
-- TOC entry 6257 (class 2606 OID 158556)
-- Name: f1000r_author_view pk_author_view; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_view
    ADD CONSTRAINT pk_author_view PRIMARY KEY (id);


--
-- TOC entry 6259 (class 2606 OID 158558)
-- Name: f1000r_automatic_invoice_info pk_automatic_invoice_info; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_automatic_invoice_info
    ADD CONSTRAINT pk_automatic_invoice_info PRIMARY KEY (id);


--
-- TOC entry 6266 (class 2606 OID 158560)
-- Name: f1000r_collection pk_collection; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection
    ADD CONSTRAINT pk_collection PRIMARY KEY (id);


--
-- TOC entry 6269 (class 2606 OID 158562)
-- Name: f1000r_collection_article pk_collection_article; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_article
    ADD CONSTRAINT pk_collection_article PRIMARY KEY (collection_id, article_id);


--
-- TOC entry 6271 (class 2606 OID 158564)
-- Name: f1000r_collection_asset pk_collection_asset; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_asset
    ADD CONSTRAINT pk_collection_asset PRIMARY KEY (collection_id, asset_id);


--
-- TOC entry 6273 (class 2606 OID 158566)
-- Name: f1000r_collection_document_type pk_collection_document_type; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_document_type
    ADD CONSTRAINT pk_collection_document_type PRIMARY KEY (collection_id, document_type_id);


--
-- TOC entry 6279 (class 2606 OID 158568)
-- Name: f1000r_collection_related_article pk_collection_related_article; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_related_article
    ADD CONSTRAINT pk_collection_related_article PRIMARY KEY (collection_id, article_id);


--
-- TOC entry 6281 (class 2606 OID 158570)
-- Name: f1000r_collection_research_topic pk_collection_research_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_research_topic
    ADD CONSTRAINT pk_collection_research_topic PRIMARY KEY (collection_id, research_topic_id);


--
-- TOC entry 6283 (class 2606 OID 158572)
-- Name: f1000r_collection_sponsor pk_collection_sponsor; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_sponsor
    ADD CONSTRAINT pk_collection_sponsor PRIMARY KEY (id);


--
-- TOC entry 6292 (class 2606 OID 158574)
-- Name: f1000r_comment pk_comment; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment
    ADD CONSTRAINT pk_comment PRIMARY KEY (id);


--
-- TOC entry 6294 (class 2606 OID 158576)
-- Name: f1000r_comment_commenter_role pk_comment_commenter_role; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment_commenter_role
    ADD CONSTRAINT pk_comment_commenter_role PRIMARY KEY (comment_id, commenter_role);


--
-- TOC entry 6300 (class 2606 OID 158578)
-- Name: f1000r_conference_detail pk_conference_details; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_detail
    ADD CONSTRAINT pk_conference_details PRIMARY KEY (id);


--
-- TOC entry 6101 (class 2606 OID 158580)
-- Name: core_research_topic pk_core_research_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.core_research_topic
    ADD CONSTRAINT pk_core_research_topic PRIMARY KEY (topic_id, subtopic_id);


--
-- TOC entry 6316 (class 2606 OID 158582)
-- Name: f1000r_corresponding_author_version pk_corresponding_author_version; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_corresponding_author_version
    ADD CONSTRAINT pk_corresponding_author_version PRIMARY KEY (author_id, version_id);


--
-- TOC entry 6319 (class 2606 OID 158584)
-- Name: f1000r_crosscheck pk_crosscheck; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_crosscheck
    ADD CONSTRAINT pk_crosscheck PRIMARY KEY (id);


--
-- TOC entry 6327 (class 2606 OID 158586)
-- Name: f1000r_document_type pk_document_type; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_document_type
    ADD CONSTRAINT pk_document_type PRIMARY KEY (id);


--
-- TOC entry 6335 (class 2606 OID 158588)
-- Name: f1000r_email_alert_log pk_email_alert_log_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_alert_log
    ADD CONSTRAINT pk_email_alert_log_id PRIMARY KEY (id);


--
-- TOC entry 6337 (class 2606 OID 158590)
-- Name: f1000r_email_internal pk_email_internal; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_internal
    ADD CONSTRAINT pk_email_internal PRIMARY KEY (id);


--
-- TOC entry 6339 (class 2606 OID 158592)
-- Name: f1000r_email_internal_recipients pk_email_internal_recipients; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_internal_recipients
    ADD CONSTRAINT pk_email_internal_recipients PRIMARY KEY (email_internal_id, user_id);


--
-- TOC entry 6360 (class 2606 OID 158594)
-- Name: f1000r_external_api_user_authentication pk_external_api_user_authentication; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_api_user_authentication
    ADD CONSTRAINT pk_external_api_user_authentication PRIMARY KEY (id);


--
-- TOC entry 6387 (class 2606 OID 158596)
-- Name: f1000r_internal_advert_box pk_f1000r_advert_box; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_internal_advert_box
    ADD CONSTRAINT pk_f1000r_advert_box PRIMARY KEY (id);


--
-- TOC entry 6130 (class 2606 OID 158598)
-- Name: f1000r_article_collection_tracking pk_f1000r_article_collection_tracking; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_tracking
    ADD CONSTRAINT pk_f1000r_article_collection_tracking PRIMARY KEY (article_id, user_id, collection_id);


--
-- TOC entry 6132 (class 2606 OID 158600)
-- Name: f1000r_article_collection_view pk_f1000r_article_collection_view; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_view
    ADD CONSTRAINT pk_f1000r_article_collection_view PRIMARY KEY (id);


--
-- TOC entry 6175 (class 2606 OID 158602)
-- Name: f1000r_article_statistic pk_f1000r_article_statistic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_statistic
    ADD CONSTRAINT pk_f1000r_article_statistic PRIMARY KEY (id);


--
-- TOC entry 6177 (class 2606 OID 158604)
-- Name: f1000r_article_tracking pk_f1000r_article_tracking; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_tracking
    ADD CONSTRAINT pk_f1000r_article_tracking PRIMARY KEY (user_id, article_id);


--
-- TOC entry 6209 (class 2606 OID 158606)
-- Name: f1000r_asset_editor_submitter_view pk_f1000r_asset_editor_submitter_view; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_editor_submitter_view
    ADD CONSTRAINT pk_f1000r_asset_editor_submitter_view PRIMARY KEY (id);


--
-- TOC entry 6221 (class 2606 OID 158608)
-- Name: f1000r_asset_submitter_view pk_f1000r_asset_submitter_view; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_submitter_view
    ADD CONSTRAINT pk_f1000r_asset_submitter_view PRIMARY KEY (id);


--
-- TOC entry 6285 (class 2606 OID 158610)
-- Name: f1000r_collection_tracking pk_f1000r_collection_tracking; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_tracking
    ADD CONSTRAINT pk_f1000r_collection_tracking PRIMARY KEY (user_id, collection_id);


--
-- TOC entry 6298 (class 2606 OID 158612)
-- Name: f1000r_conference pk_f1000r_conference; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference
    ADD CONSTRAINT pk_f1000r_conference PRIMARY KEY (id);


--
-- TOC entry 6302 (class 2606 OID 158614)
-- Name: f1000r_conference_organization pk_f1000r_conference_organization; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_organization
    ADD CONSTRAINT pk_f1000r_conference_organization PRIMARY KEY (conference_id, organization_id);


--
-- TOC entry 6304 (class 2606 OID 158616)
-- Name: f1000r_conference_view pk_f1000r_conference_view; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_view
    ADD CONSTRAINT pk_f1000r_conference_view PRIMARY KEY (id);


--
-- TOC entry 6312 (class 2606 OID 158618)
-- Name: f1000r_contributor_role pk_f1000r_contributor_role; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_contributor_role
    ADD CONSTRAINT pk_f1000r_contributor_role PRIMARY KEY (id);


--
-- TOC entry 6321 (class 2606 OID 158620)
-- Name: f1000r_currency_rate pk_f1000r_currency_rate; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_currency_rate
    ADD CONSTRAINT pk_f1000r_currency_rate PRIMARY KEY (currency);


--
-- TOC entry 6323 (class 2606 OID 158622)
-- Name: f1000r_dashboard_layout pk_f1000r_dashboard_layout; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_dashboard_layout
    ADD CONSTRAINT pk_f1000r_dashboard_layout PRIMARY KEY (id);


--
-- TOC entry 6333 (class 2606 OID 158624)
-- Name: f1000r_email_alert pk_f1000r_email_alert; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_alert
    ADD CONSTRAINT pk_f1000r_email_alert PRIMARY KEY (id);


--
-- TOC entry 6346 (class 2606 OID 158626)
-- Name: f1000r_email_tracking pk_f1000r_email_track; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_tracking
    ADD CONSTRAINT pk_f1000r_email_track PRIMARY KEY (id);


--
-- TOC entry 6371 (class 2606 OID 158628)
-- Name: f1000r_featured_article pk_f1000r_featured_article; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_article
    ADD CONSTRAINT pk_f1000r_featured_article PRIMARY KEY (id);


--
-- TOC entry 6373 (class 2606 OID 158630)
-- Name: f1000r_featured_blog_post pk_f1000r_featured_blog_post; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_blog_post
    ADD CONSTRAINT pk_f1000r_featured_blog_post PRIMARY KEY (id);


--
-- TOC entry 6375 (class 2606 OID 158632)
-- Name: f1000r_featured_collection pk_f1000r_featured_collection; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_collection
    ADD CONSTRAINT pk_f1000r_featured_collection PRIMARY KEY (id);


--
-- TOC entry 6377 (class 2606 OID 158634)
-- Name: f1000r_featured_report pk_f1000r_featured_report; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_report
    ADD CONSTRAINT pk_f1000r_featured_report PRIMARY KEY (id);


--
-- TOC entry 6395 (class 2606 OID 158636)
-- Name: f1000r_link_parser pk_f1000r_link_parser; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_link_parser
    ADD CONSTRAINT pk_f1000r_link_parser PRIMARY KEY (id);


--
-- TOC entry 6399 (class 2606 OID 158638)
-- Name: f1000r_living_figure_uploader_details pk_f1000r_living_figure_uploader_details; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_living_figure_uploader_details
    ADD CONSTRAINT pk_f1000r_living_figure_uploader_details PRIMARY KEY (id);


--
-- TOC entry 6405 (class 2606 OID 158640)
-- Name: f1000r_media pk_f1000r_media; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_media
    ADD CONSTRAINT pk_f1000r_media PRIMARY KEY (id);


--
-- TOC entry 6412 (class 2606 OID 158642)
-- Name: f1000r_organization pk_f1000r_organization; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_organization
    ADD CONSTRAINT pk_f1000r_organization PRIMARY KEY (id);


--
-- TOC entry 6432 (class 2606 OID 158644)
-- Name: f1000r_prime_related_article pk_f1000r_prime_ebola_article; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_prime_related_article
    ADD CONSTRAINT pk_f1000r_prime_ebola_article PRIMARY KEY (article_id);


--
-- TOC entry 6451 (class 2606 OID 158646)
-- Name: f1000r_published_version pk_f1000r_published_version; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_published_version
    ADD CONSTRAINT pk_f1000r_published_version PRIMARY KEY (id);


--
-- TOC entry 6484 (class 2606 OID 158648)
-- Name: f1000r_referee_supplementary_file pk_f1000r_ref_sup_file; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_supplementary_file
    ADD CONSTRAINT pk_f1000r_ref_sup_file PRIMARY KEY (report_id, supplementary_file_id);


--
-- TOC entry 6550 (class 2606 OID 158650)
-- Name: f1000r_unsubscribe_email pk_f1000r_unsubscribe_email; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_unsubscribe_email
    ADD CONSTRAINT pk_f1000r_unsubscribe_email PRIMARY KEY (id);


--
-- TOC entry 6583 (class 2606 OID 158652)
-- Name: f1000r_version_article_dataset pk_f1000r_version_article_dataset; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_article_dataset
    ADD CONSTRAINT pk_f1000r_version_article_dataset PRIMARY KEY (id);


--
-- TOC entry 6590 (class 2606 OID 158654)
-- Name: f1000r_version_editor pk_f1000r_version_editor; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_editor
    ADD CONSTRAINT pk_f1000r_version_editor PRIMARY KEY (version_id, user_id);


--
-- TOC entry 6596 (class 2606 OID 158656)
-- Name: f1000r_version_extended_data pk_f1000r_version_extended_data; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_extended_data
    ADD CONSTRAINT pk_f1000r_version_extended_data PRIMARY KEY (id);


--
-- TOC entry 6619 (class 2606 OID 158658)
-- Name: f1000r_version_visualized_file pk_f1000r_version_visualized_file; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_visualized_file
    ADD CONSTRAINT pk_f1000r_version_visualized_file PRIMARY KEY (version_id, visualized_file_id);


--
-- TOC entry 6767 (class 2606 OID 3276949)
-- Name: f1000r_gateway_payment pk_gateway_payment; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_gateway_payment
    ADD CONSTRAINT pk_gateway_payment PRIMARY KEY (id);


--
-- TOC entry 6651 (class 2606 OID 158660)
-- Name: job pk_job_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT pk_job_id PRIMARY KEY (id);


--
-- TOC entry 6391 (class 2606 OID 158662)
-- Name: f1000r_language pk_language; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_language
    ADD CONSTRAINT pk_language PRIMARY KEY (id);


--
-- TOC entry 6655 (class 2606 OID 158664)
-- Name: last_institutional_access pk_last_access_user_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.last_institutional_access
    ADD CONSTRAINT pk_last_access_user_id PRIMARY KEY (user_id);


--
-- TOC entry 6401 (class 2606 OID 158666)
-- Name: f1000r_logging_excluded_ip pk_logging_excluded_ip; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_logging_excluded_ip
    ADD CONSTRAINT pk_logging_excluded_ip PRIMARY KEY (id);


--
-- TOC entry 6403 (class 2606 OID 158668)
-- Name: f1000r_marketing_disease_waiver_code pk_marketing_disease_waiver_code_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_marketing_disease_waiver_code
    ADD CONSTRAINT pk_marketing_disease_waiver_code_id PRIMARY KEY (id);


--
-- TOC entry 6407 (class 2606 OID 158670)
-- Name: f1000r_msf_asset pk_msf_asset; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_msf_asset
    ADD CONSTRAINT pk_msf_asset PRIMARY KEY (id);


--
-- TOC entry 6410 (class 2606 OID 158672)
-- Name: f1000r_note pk_note; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_note
    ADD CONSTRAINT pk_note PRIMARY KEY (id);


--
-- TOC entry 6414 (class 2606 OID 158674)
-- Name: f1000r_paypal_payment pk_paypal_payment; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_paypal_payment
    ADD CONSTRAINT pk_paypal_payment PRIMARY KEY (id);


--
-- TOC entry 6416 (class 2606 OID 158676)
-- Name: f1000r_paypal_product pk_paypal_product; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_paypal_product
    ADD CONSTRAINT pk_paypal_product PRIMARY KEY (id);


--
-- TOC entry 6422 (class 2606 OID 158678)
-- Name: f1000r_pmc_files_download pk_pmc_files_download; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_pmc_files_download
    ADD CONSTRAINT pk_pmc_files_download PRIMARY KEY (id);


--
-- TOC entry 6430 (class 2606 OID 158680)
-- Name: f1000r_presenter pk_presenter; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_presenter
    ADD CONSTRAINT pk_presenter PRIMARY KEY (id);


--
-- TOC entry 6447 (class 2606 OID 158682)
-- Name: f1000r_promotional_code pk_promotional_code_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_promotional_code
    ADD CONSTRAINT pk_promotional_code_id PRIMARY KEY (id);


--
-- TOC entry 6770 (class 2606 OID 6763410)
-- Name: f1000r_prescreening_feedback pk_ps_feedback; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_prescreening_feedback
    ADD CONSTRAINT pk_ps_feedback PRIMARY KEY (id);


--
-- TOC entry 6456 (class 2606 OID 158684)
-- Name: f1000r_referee pk_referee; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee
    ADD CONSTRAINT pk_referee PRIMARY KEY (id);


--
-- TOC entry 6459 (class 2606 OID 158686)
-- Name: f1000r_referee_draft pk_referee_draft; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_draft
    ADD CONSTRAINT pk_referee_draft PRIMARY KEY (id);


--
-- TOC entry 6462 (class 2606 OID 158688)
-- Name: f1000r_referee_email pk_referee_email_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_email
    ADD CONSTRAINT pk_referee_email_id PRIMARY KEY (id);


--
-- TOC entry 6467 (class 2606 OID 158690)
-- Name: f1000r_referee_report pk_referee_report; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_report
    ADD CONSTRAINT pk_referee_report PRIMARY KEY (referee_id, report_id);


--
-- TOC entry 6490 (class 2606 OID 158692)
-- Name: f1000r_related_article pk_related_article; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_related_article
    ADD CONSTRAINT pk_related_article PRIMARY KEY (first_article_id, second_article_id);


--
-- TOC entry 6682 (class 2606 OID 158694)
-- Name: related_research_topic pk_related_research_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.related_research_topic
    ADD CONSTRAINT pk_related_research_topic PRIMARY KEY (dummy_topic_id, related_topic_id);


--
-- TOC entry 6494 (class 2606 OID 158696)
-- Name: f1000r_report pk_report; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report
    ADD CONSTRAINT pk_report PRIMARY KEY (id);


--
-- TOC entry 6498 (class 2606 OID 158698)
-- Name: f1000r_report_history pk_report_history; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report_history
    ADD CONSTRAINT pk_report_history PRIMARY KEY (id);


--
-- TOC entry 6693 (class 2606 OID 158700)
-- Name: research_member_topic pk_research_member_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_member_topic
    ADD CONSTRAINT pk_research_member_topic PRIMARY KEY (research_member_id, topic_id);


--
-- TOC entry 6503 (class 2606 OID 158702)
-- Name: f1000r_sage_response pk_sage_response; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_sage_response
    ADD CONSTRAINT pk_sage_response PRIMARY KEY (id);


--
-- TOC entry 6505 (class 2606 OID 158704)
-- Name: f1000r_scheduled_task pk_scheduled_task; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_scheduled_task
    ADD CONSTRAINT pk_scheduled_task PRIMARY KEY (id);


--
-- TOC entry 6703 (class 2606 OID 158706)
-- Name: subscription pk_sscrpt_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT pk_sscrpt_id PRIMARY KEY (id);


--
-- TOC entry 6509 (class 2606 OID 158708)
-- Name: f1000r_stored_search pk_stored_search; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_stored_search
    ADD CONSTRAINT pk_stored_search PRIMARY KEY (id);


--
-- TOC entry 6513 (class 2606 OID 158710)
-- Name: f1000r_submitter pk_submitter; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_submitter
    ADD CONSTRAINT pk_submitter PRIMARY KEY (id);


--
-- TOC entry 6515 (class 2606 OID 158712)
-- Name: f1000r_subtoken pk_subtoken; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_subtoken
    ADD CONSTRAINT pk_subtoken PRIMARY KEY (id);


--
-- TOC entry 6525 (class 2606 OID 158714)
-- Name: f1000r_table_doi_status pk_table_doi_status; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_table_doi_status
    ADD CONSTRAINT pk_table_doi_status PRIMARY KEY (id);


--
-- TOC entry 6529 (class 2606 OID 158716)
-- Name: f1000r_token pk_token; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_token
    ADD CONSTRAINT pk_token PRIMARY KEY (id);


--
-- TOC entry 6536 (class 2606 OID 13534114)
-- Name: f1000r_translation_affiliation pk_translation_affiliation; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_affiliation
    ADD CONSTRAINT pk_translation_affiliation PRIMARY KEY (affiliation_uid, translated_language);


--
-- TOC entry 6538 (class 2606 OID 158720)
-- Name: f1000r_translation_author pk_translation_author; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_author
    ADD CONSTRAINT pk_translation_author PRIMARY KEY (id, translated_language);


--
-- TOC entry 6540 (class 2606 OID 158722)
-- Name: f1000r_translation_cou pk_translation_cou; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_cou
    ADD CONSTRAINT pk_translation_cou PRIMARY KEY (cou_id, translated_language);


--
-- TOC entry 6542 (class 2606 OID 158724)
-- Name: f1000r_translation_institution pk_translation_institution; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_institution
    ADD CONSTRAINT pk_translation_institution PRIMARY KEY (id, translated_language);


--
-- TOC entry 6544 (class 2606 OID 158726)
-- Name: f1000r_translation_submitter pk_translation_submitter; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_submitter
    ADD CONSTRAINT pk_translation_submitter PRIMARY KEY (id, translated_language);


--
-- TOC entry 6546 (class 2606 OID 158728)
-- Name: f1000r_translation_user pk_translation_user; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_user
    ADD CONSTRAINT pk_translation_user PRIMARY KEY (id, translated_language);


--
-- TOC entry 6548 (class 2606 OID 158730)
-- Name: f1000r_translation_version pk_translation_version; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_translation_version
    ADD CONSTRAINT pk_translation_version PRIMARY KEY (id, translated_language);


--
-- TOC entry 6554 (class 2606 OID 158732)
-- Name: f1000r_upload_info pk_upload_info; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_upload_info
    ADD CONSTRAINT pk_upload_info PRIMARY KEY (id);


--
-- TOC entry 6557 (class 2606 OID 158734)
-- Name: f1000r_usage_stats pk_usage_stats; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_usage_stats
    ADD CONSTRAINT pk_usage_stats PRIMARY KEY (id);


--
-- TOC entry 6559 (class 2606 OID 158736)
-- Name: f1000r_usage_stats_pmc pk_usage_stats_pmc; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_usage_stats_pmc
    ADD CONSTRAINT pk_usage_stats_pmc PRIMARY KEY (id);


--
-- TOC entry 6565 (class 2606 OID 158738)
-- Name: f1000r_user_topic pk_user_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_topic
    ADD CONSTRAINT pk_user_topic PRIMARY KEY (user_id, topic_id);


--
-- TOC entry 6580 (class 2606 OID 158740)
-- Name: f1000r_version pk_version; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version
    ADD CONSTRAINT pk_version PRIMARY KEY (id);


--
-- TOC entry 6765 (class 2606 OID 274205)
-- Name: version_editor_role pk_version_editor_role; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.version_editor_role
    ADD CONSTRAINT pk_version_editor_role PRIMARY KEY (id);


--
-- TOC entry 6605 (class 2606 OID 158742)
-- Name: f1000r_version_pdf_detail pk_version_pdf_detail; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_pdf_detail
    ADD CONSTRAINT pk_version_pdf_detail PRIMARY KEY (version_id, file_hash, file_size);


--
-- TOC entry 6611 (class 2606 OID 158744)
-- Name: f1000r_version_subtopic pk_version_topic; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_subtopic
    ADD CONSTRAINT pk_version_topic PRIMARY KEY (version_id, topic_id);


--
-- TOC entry 6623 (class 2606 OID 158746)
-- Name: f1000r_website pk_website; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_website
    ADD CONSTRAINT pk_website PRIMARY KEY (id);


--
-- TOC entry 6684 (class 2606 OID 158748)
-- Name: report_article_author report_article_author_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.report_article_author
    ADD CONSTRAINT report_article_author_pk PRIMARY KEY (report_article_author_id);


--
-- TOC entry 6686 (class 2606 OID 158750)
-- Name: report_issue report_issue_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.report_issue
    ADD CONSTRAINT report_issue_pk PRIMARY KEY (id);


--
-- TOC entry 6691 (class 2606 OID 158752)
-- Name: research_member research_member_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_member
    ADD CONSTRAINT research_member_pkey PRIMARY KEY (id);


--
-- TOC entry 6697 (class 2606 OID 158754)
-- Name: research_topic research_topic_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_topic
    ADD CONSTRAINT research_topic_pkey PRIMARY KEY (id);


--
-- TOC entry 6699 (class 2606 OID 158756)
-- Name: sagepay_transaction sagepay_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.sagepay_transaction
    ADD CONSTRAINT sagepay_transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 6793 (class 2606 OID 34444898)
-- Name: scheduledtasks_retries_log scheduledtasks_retries_log_object_id_object_type_task_name_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.scheduledtasks_retries_log
    ADD CONSTRAINT scheduledtasks_retries_log_object_id_object_type_task_name_key UNIQUE (object_id, object_type, task_name);


--
-- TOC entry 6795 (class 2606 OID 34444896)
-- Name: scheduledtasks_retries_log scheduledtasks_retries_log_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.scheduledtasks_retries_log
    ADD CONSTRAINT scheduledtasks_retries_log_pkey PRIMARY KEY (uid);


--
-- TOC entry 6701 (class 2606 OID 158758)
-- Name: section section_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_pkey PRIMARY KEY (id);


--
-- TOC entry 6708 (class 2606 OID 158760)
-- Name: term term_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.term
    ADD CONSTRAINT term_pkey PRIMARY KEY (id);


--
-- TOC entry 6712 (class 2606 OID 158762)
-- Name: thesaurus_synonym thesaurus_synonym_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thesaurus_synonym
    ADD CONSTRAINT thesaurus_synonym_pkey PRIMARY KEY (id);


--
-- TOC entry 6719 (class 2606 OID 158764)
-- Name: thesaurus_term_parent thesaurus_term_parent_temp_parent_ids; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thesaurus_term_parent
    ADD CONSTRAINT thesaurus_term_parent_temp_parent_ids UNIQUE (term_id, parent_id);


--
-- TOC entry 6715 (class 2606 OID 158766)
-- Name: thesaurus_term thesaurus_term_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thesaurus_term
    ADD CONSTRAINT thesaurus_term_pkey PRIMARY KEY (id);


--
-- TOC entry 6722 (class 2606 OID 158768)
-- Name: thumbnail thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thumbnail
    ADD CONSTRAINT thumbnail_pkey PRIMARY KEY (id);


--
-- TOC entry 6533 (class 2606 OID 158770)
-- Name: f1000r_tomcat_sessions tomcat_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_tomcat_sessions
    ADD CONSTRAINT tomcat_sessions_pkey PRIMARY KEY (session_id);


--
-- TOC entry 6308 (class 2606 OID 158772)
-- Name: f1000r_content uk_content_id_type; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_content
    ADD CONSTRAINT uk_content_id_type UNIQUE (content_id, content_type);


--
-- TOC entry 6424 (class 2606 OID 158774)
-- Name: f1000r_pmc_files_download uk_usage_stats_pmc_year_month; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_pmc_files_download
    ADD CONSTRAINT uk_usage_stats_pmc_year_month UNIQUE (pmc_month, pmc_year);


--
-- TOC entry 6741 (class 2606 OID 158776)
-- Name: user_token uk_usr_tkn_tkn; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_token
    ADD CONSTRAINT uk_usr_tkn_tkn UNIQUE (token);


--
-- TOC entry 6602 (class 2606 OID 158778)
-- Name: f1000r_version_fulltext uk_version_fulltext_version_id; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_fulltext
    ADD CONSTRAINT uk_version_fulltext_version_id UNIQUE (version_id);


--
-- TOC entry 6287 (class 2606 OID 158780)
-- Name: f1000r_collection_version_type unique_collection_id_type; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_version_type
    ADD CONSTRAINT unique_collection_id_type UNIQUE (collection_id, type);


--
-- TOC entry 6358 (class 2606 OID 158782)
-- Name: f1000r_etoc_alert_term unique_email_alert_thesaurus; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_etoc_alert_term
    ADD CONSTRAINT unique_email_alert_thesaurus UNIQUE (email_alert_id, thesaurus_term_id, parent_id);


--
-- TOC entry 6445 (class 2606 OID 27632828)
-- Name: f1000r_project_info_version unique_f1000r_project_info_version; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_project_info_version
    ADD CONSTRAINT unique_f1000r_project_info_version UNIQUE (project_id, version_id);


--
-- TOC entry 6393 (class 2606 OID 158786)
-- Name: f1000r_language unique_name; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_language
    ADD CONSTRAINT unique_name UNIQUE (name);


--
-- TOC entry 6420 (class 2606 OID 158788)
-- Name: f1000r_platform_user unique_platform_user; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_platform_user
    ADD CONSTRAINT unique_platform_user UNIQUE (user_id, website_id);


--
-- TOC entry 6150 (class 2606 OID 14825168)
-- Name: f1000r_article_pricing_category unique_website_pricing_category; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_pricing_category
    ADD CONSTRAINT unique_website_pricing_category UNIQUE (pricing_category, website_id, valid_from, valid_to);


--
-- TOC entry 6089 (class 2606 OID 158792)
-- Name: article uniqueq_pubmedid; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT uniqueq_pubmedid UNIQUE (pubmedid);


--
-- TOC entry 6449 (class 2606 OID 158794)
-- Name: f1000r_promotional_code unq_promotional_code; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_promotional_code
    ADD CONSTRAINT unq_promotional_code UNIQUE (code);


--
-- TOC entry 6517 (class 2606 OID 158796)
-- Name: f1000r_subtoken unq_subtoken; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_subtoken
    ADD CONSTRAINT unq_subtoken UNIQUE (name);


--
-- TOC entry 6531 (class 2606 OID 158798)
-- Name: f1000r_token unq_token; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_token
    ADD CONSTRAINT unq_token UNIQUE (name);


--
-- TOC entry 6724 (class 2606 OID 158802)
-- Name: upo upo_usr_id_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.upo
    ADD CONSTRAINT upo_usr_id_pk PRIMARY KEY (usr_id);


--
-- TOC entry 6350 (class 2606 OID 39262286)
-- Name: f1000r_enquiry_reason uq_version_enquiry_author_status; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_enquiry_reason
    ADD CONSTRAINT uq_version_enquiry_author_status UNIQUE (version_id, enquiry_author_status);


--
-- TOC entry 6119 (class 2606 OID 158804)
-- Name: f1000r_article uqc_volume_publication_number; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article
    ADD CONSTRAINT uqc_volume_publication_number UNIQUE (website_id, volume, publication_number);


--
-- TOC entry 6733 (class 2606 OID 158806)
-- Name: user_area_of_interest user_area_of_interest_pkey; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_area_of_interest
    ADD CONSTRAINT user_area_of_interest_pkey PRIMARY KEY (user_id, area_of_interest_id);


--
-- TOC entry 6743 (class 2606 OID 158808)
-- Name: user_token user_token_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_token
    ADD CONSTRAINT user_token_pk PRIMARY KEY (usr_id);


--
-- TOC entry 6746 (class 2606 OID 158810)
-- Name: user_video user_video_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_video
    ADD CONSTRAINT user_video_pk PRIMARY KEY (id);


--
-- TOC entry 6748 (class 2606 OID 158812)
-- Name: user_video user_video_story_id_key; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_video
    ADD CONSTRAINT user_video_story_id_key UNIQUE (story_id);


--
-- TOC entry 6758 (class 2606 OID 158814)
-- Name: usr usr_id_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.usr
    ADD CONSTRAINT usr_id_pk PRIMARY KEY (usr_id);


--
-- TOC entry 6774 (class 2606 OID 13534122)
-- Name: version_affiliation_position version_affiliation_pk; Type: CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.version_affiliation_position
    ADD CONSTRAINT version_affiliation_pk PRIMARY KEY (uid);


--
-- TOC entry 6079 (class 1259 OID 158815)
-- Name: article_added_date_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX article_added_date_idx ON public.article USING btree (added_date NULLS FIRST);


--
-- TOC entry 6080 (class 1259 OID 158816)
-- Name: article_doiid_index; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX article_doiid_index ON public.article USING btree (doiid);


--
-- TOC entry 6081 (class 1259 OID 158817)
-- Name: article_journalid_index; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX article_journalid_index ON public.article USING btree (journal_id);


--
-- TOC entry 6082 (class 1259 OID 158818)
-- Name: article_last_indexed_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX article_last_indexed_idx ON public.article USING btree (last_indexed);


--
-- TOC entry 6085 (class 1259 OID 158819)
-- Name: article_pubmedid_index; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX article_pubmedid_index ON public.article USING btree (pubmedid);


--
-- TOC entry 6090 (class 1259 OID 158820)
-- Name: articles_thesaurus_terms_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX articles_thesaurus_terms_article_id_idx ON public.articles_thesaurus_terms USING btree (article_id);


--
-- TOC entry 6093 (class 1259 OID 158821)
-- Name: articles_thesaurus_terms_term_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX articles_thesaurus_terms_term_id_idx ON public.articles_thesaurus_terms USING btree (term_id);


--
-- TOC entry 6094 (class 1259 OID 158822)
-- Name: bible_institution_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX bible_institution_id_idx ON public.bible_institution USING btree (id);


--
-- TOC entry 6095 (class 1259 OID 158823)
-- Name: bible_institution_manually_added_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX bible_institution_manually_added_id_idx ON public.bible_institution USING btree (manually_added, id);


--
-- TOC entry 6096 (class 1259 OID 158824)
-- Name: bible_institution_name_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX bible_institution_name_idx ON public.bible_institution USING btree (name NULLS FIRST);


--
-- TOC entry 6097 (class 1259 OID 158825)
-- Name: bible_institution_parent_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX bible_institution_parent_id_idx ON public.bible_institution USING btree (parent_id);


--
-- TOC entry 6108 (class 1259 OID 158826)
-- Name: f1000_user_specified_job_type_ujt_usi_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000_user_specified_job_type_ujt_usi_id_idx ON public.f1000_user_specified_job_type USING btree (ujt_usi_id);


--
-- TOC entry 6109 (class 1259 OID 158827)
-- Name: f1000r_affiliation_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_affiliation_version_id_idx ON public.f1000r_affiliation USING btree (version_id);


--
-- TOC entry 6112 (class 1259 OID 158828)
-- Name: f1000r_article_article_payment_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_article_payment_id_idx ON public.f1000r_article USING btree (article_payment_id);


--
-- TOC entry 6124 (class 1259 OID 158829)
-- Name: f1000r_article_citation_statistics_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_citation_statistics_idx ON public.f1000r_article_citation_statistics USING btree (article_id);


--
-- TOC entry 6113 (class 1259 OID 158830)
-- Name: f1000r_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_id_idx ON public.f1000r_article USING btree (id);


--
-- TOC entry 6139 (class 1259 OID 158831)
-- Name: f1000r_article_log_version_status_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_log_version_status_idx ON public.f1000r_article_log USING btree (version_status);


--
-- TOC entry 6142 (class 1259 OID 158832)
-- Name: f1000r_article_payment_uuid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_payment_uuid_idx ON public.f1000r_article_payment USING btree (uuid);


--
-- TOC entry 6161 (class 1259 OID 158833)
-- Name: f1000r_article_referee_affiliation_article_referee_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_referee_affiliation_article_referee_id_idx ON public.f1000r_article_referee_affiliation USING btree (article_referee_id);


--
-- TOC entry 6162 (class 1259 OID 13950474)
-- Name: f1000r_article_referee_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_referee_affiliation_uid_idx ON public.f1000r_article_referee_affiliation USING btree (affiliation_uid);


--
-- TOC entry 6157 (class 1259 OID 158834)
-- Name: f1000r_article_referee_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_referee_article_id_idx ON public.f1000r_article_referee USING btree (article_id);


--
-- TOC entry 6158 (class 1259 OID 158835)
-- Name: f1000r_article_referee_referee_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_referee_referee_id_idx ON public.f1000r_article_referee USING btree (referee_id);


--
-- TOC entry 6165 (class 1259 OID 158836)
-- Name: f1000r_article_referee_status_tracker_user_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_referee_status_tracker_user_id_idx ON public.f1000r_article_referee_status_tracker USING btree (user_id);


--
-- TOC entry 6180 (class 1259 OID 158837)
-- Name: f1000r_article_view_log_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_view_log_article_id_idx ON public.f1000r_article_view_log USING btree (article_id);


--
-- TOC entry 6183 (class 1259 OID 158838)
-- Name: f1000r_article_view_log_view_date_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_view_log_view_date_idx ON public.f1000r_article_view_log USING btree (view_date);


--
-- TOC entry 6114 (class 1259 OID 158839)
-- Name: f1000r_article_volume_publication_number_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_volume_publication_number_idx ON public.f1000r_article USING btree (volume, publication_number);


--
-- TOC entry 6115 (class 1259 OID 158840)
-- Name: f1000r_article_website_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_article_website_id_idx ON public.f1000r_article USING btree (website_id);


--
-- TOC entry 6188 (class 1259 OID 158841)
-- Name: f1000r_asset_asset_file_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_asset_file_id_idx ON public.f1000r_asset USING btree (asset_file_id);


--
-- TOC entry 6189 (class 1259 OID 158842)
-- Name: f1000r_asset_asset_metadata_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_asset_metadata_id_idx ON public.f1000r_asset USING btree (asset_metadata_id);


--
-- TOC entry 6201 (class 1259 OID 13950478)
-- Name: f1000r_asset_author_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_author_affiliation_uid_idx ON public.f1000r_asset_author_affiliation USING btree (affiliation_uid);


--
-- TOC entry 6196 (class 1259 OID 158843)
-- Name: f1000r_asset_author_asset_metadata_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_author_asset_metadata_id_idx ON public.f1000r_asset_author USING btree (asset_metadata_id);


--
-- TOC entry 6190 (class 1259 OID 158844)
-- Name: f1000r_asset_compressed_file_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_compressed_file_id_idx ON public.f1000r_asset USING btree (compressed_file_id);


--
-- TOC entry 6191 (class 1259 OID 158845)
-- Name: f1000r_asset_thumbnail_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_thumbnail_id_idx ON public.f1000r_asset USING btree (thumbnail_id);


--
-- TOC entry 6228 (class 1259 OID 158846)
-- Name: f1000r_asset_topic_asset_metadata_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_asset_topic_asset_metadata_id_idx ON public.f1000r_asset_topic USING btree (asset_metadata_id);


--
-- TOC entry 6239 (class 1259 OID 158847)
-- Name: f1000r_author_email_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_author_email_idx ON public.f1000r_author USING btree (email);


--
-- TOC entry 6240 (class 1259 OID 158848)
-- Name: f1000r_author_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_author_id_idx ON public.f1000r_author USING btree (id);


--
-- TOC entry 6247 (class 1259 OID 13950476)
-- Name: f1000r_author_version_affiliation_draft_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_author_version_affiliation_draft_affiliation_uid_idx ON public.f1000r_author_version_affiliation_draft USING btree (affiliation_uid);


--
-- TOC entry 6244 (class 1259 OID 158849)
-- Name: f1000r_author_version_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_author_version_version_id_idx ON public.f1000r_author_version USING btree (version_id);


--
-- TOC entry 6267 (class 1259 OID 158850)
-- Name: f1000r_collection_article_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_collection_article_article_id_idx ON public.f1000r_collection_article USING btree (article_id);


--
-- TOC entry 6288 (class 1259 OID 13950477)
-- Name: f1000r_comment_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_comment_affiliation_uid_idx ON public.f1000r_comment USING btree (affiliation_uid);


--
-- TOC entry 6289 (class 1259 OID 158851)
-- Name: f1000r_comment_usr_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_comment_usr_id_idx ON public.f1000r_comment USING btree (usr_id);


--
-- TOC entry 6290 (class 1259 OID 158852)
-- Name: f1000r_comment_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_comment_version_id_idx ON public.f1000r_comment USING btree (version_id);


--
-- TOC entry 6313 (class 1259 OID 158853)
-- Name: f1000r_corresponding_author_version_author_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_corresponding_author_version_author_id_idx ON public.f1000r_corresponding_author_version USING btree (author_id);


--
-- TOC entry 6314 (class 1259 OID 158854)
-- Name: f1000r_corresponding_author_version_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_corresponding_author_version_version_id_idx ON public.f1000r_corresponding_author_version USING btree (version_id);


--
-- TOC entry 6317 (class 1259 OID 158855)
-- Name: f1000r_crosscheck_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_crosscheck_version_id_idx ON public.f1000r_crosscheck USING btree (version_id);


--
-- TOC entry 6344 (class 1259 OID 22239176)
-- Name: f1000r_email_tracking_data_id_type_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_email_tracking_data_id_type_idx ON public.f1000r_email_tracking USING btree (data_id, type);


--
-- TOC entry 6365 (class 1259 OID 158856)
-- Name: f1000r_external_item_internal_id_type_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_external_item_internal_id_type_idx ON public.f1000r_external_item USING btree (internal_id, type);


--
-- TOC entry 6264 (class 1259 OID 3276960)
-- Name: f1000r_gateway_payment_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_gateway_payment_id_idx ON public.f1000r_collection USING btree (gateway_payment_id);


--
-- TOC entry 6408 (class 1259 OID 11464526)
-- Name: f1000r_note_article_referee_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_note_article_referee_id_idx ON public.f1000r_note USING btree (article_referee_id);


--
-- TOC entry 6779 (class 1259 OID 15859955)
-- Name: f1000r_partner_target_selected_target_id_target_type_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_partner_target_selected_target_id_target_type_idx ON public.f1000r_partner_target_selected USING btree (target_id, target_type);


--
-- TOC entry 6768 (class 1259 OID 6763425)
-- Name: f1000r_prescreening_feedback_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_prescreening_feedback_version_id_idx ON public.f1000r_prescreening_feedback USING btree (version_id);


--
-- TOC entry 6433 (class 1259 OID 27632825)
-- Name: f1000r_project_info_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_info_idx ON public.f1000r_project_info USING btree (project_id);


--
-- TOC entry 6434 (class 1259 OID 158858)
-- Name: f1000r_project_info_pic_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_info_pic_idx ON public.f1000r_project_info USING btree (pic);


--
-- TOC entry 6438 (class 1259 OID 27632829)
-- Name: f1000r_project_info_version_pid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_info_version_pid_idx ON public.f1000r_project_info_version USING btree (project_id);


--
-- TOC entry 6439 (class 1259 OID 27632830)
-- Name: f1000r_project_info_version_pid_version_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_info_version_pid_version_idx ON public.f1000r_project_info_version USING btree (project_id, version_id);


--
-- TOC entry 6440 (class 1259 OID 27632831)
-- Name: f1000r_project_info_version_pidwithpic_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_info_version_pidwithpic_idx ON public.f1000r_project_info_version USING btree (project_id, version_id, pic);


--
-- TOC entry 6443 (class 1259 OID 158862)
-- Name: f1000r_project_info_version_version_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_info_version_version_idx ON public.f1000r_project_info_version USING btree (version_id);


--
-- TOC entry 6437 (class 1259 OID 27632826)
-- Name: f1000r_project_pidwithpic_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_project_pidwithpic_idx ON public.f1000r_project_info USING btree (project_id, pic);


--
-- TOC entry 6452 (class 1259 OID 13950473)
-- Name: f1000r_referee_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_affiliation_uid_idx ON public.f1000r_referee USING btree (affiliation_uid);


--
-- TOC entry 6457 (class 1259 OID 158864)
-- Name: f1000r_referee_draft_active_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_draft_active_idx ON public.f1000r_referee_draft USING btree (active);


--
-- TOC entry 6453 (class 1259 OID 158865)
-- Name: f1000r_referee_email_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_email_idx ON public.f1000r_referee USING btree (email);


--
-- TOC entry 6460 (class 1259 OID 158866)
-- Name: f1000r_referee_email_referee_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_email_referee_id_idx ON public.f1000r_referee_email USING btree (referee_id);


--
-- TOC entry 6454 (class 1259 OID 158867)
-- Name: f1000r_referee_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_id_idx ON public.f1000r_referee USING btree (id);


--
-- TOC entry 6465 (class 1259 OID 158868)
-- Name: f1000r_referee_report_report_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_report_report_id_idx ON public.f1000r_referee_report USING btree (report_id);


--
-- TOC entry 6479 (class 1259 OID 158869)
-- Name: f1000r_referee_suggestion_potential_ref_sug_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_suggestion_potential_ref_sug_idx ON public.f1000r_referee_suggestion_potential_ref USING btree (referee_suggestion_id);


--
-- TOC entry 6482 (class 1259 OID 158870)
-- Name: f1000r_referee_suggestion_related_articles_pot_ref_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_suggestion_related_articles_pot_ref_idx ON public.f1000r_referee_suggestion_related_articles USING btree (pot_ref_id);


--
-- TOC entry 6474 (class 1259 OID 158871)
-- Name: f1000r_referee_suggestion_version_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_suggestion_version_idx ON public.f1000r_referee_suggestion USING btree (version_id);


--
-- TOC entry 6487 (class 1259 OID 158872)
-- Name: f1000r_referee_user_feedback_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_referee_user_feedback_version_id_idx ON public.f1000r_referee_user_feedback USING btree (version_id);


--
-- TOC entry 6488 (class 1259 OID 158873)
-- Name: f1000r_related_article_first_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_related_article_first_article_id_idx ON public.f1000r_related_article USING btree (first_article_id);


--
-- TOC entry 6491 (class 1259 OID 158874)
-- Name: f1000r_report_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_report_version_id_idx ON public.f1000r_report USING btree (version_id);


--
-- TOC entry 6492 (class 1259 OID 158875)
-- Name: f1000r_report_version_id_status_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_report_version_id_status_idx ON public.f1000r_report USING btree (version_id, status);


--
-- TOC entry 6501 (class 1259 OID 158876)
-- Name: f1000r_report_view_log_report_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_report_view_log_report_id_idx ON public.f1000r_report_view_log USING btree (report_id);


--
-- TOC entry 6510 (class 1259 OID 158877)
-- Name: f1000r_submitter_email_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_submitter_email_idx ON public.f1000r_submitter USING btree (email);


--
-- TOC entry 6511 (class 1259 OID 158878)
-- Name: f1000r_submitter_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_submitter_id_idx ON public.f1000r_submitter USING btree (id);


--
-- TOC entry 6520 (class 1259 OID 158879)
-- Name: f1000r_supplementary_file_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_supplementary_file_id_idx ON public.f1000r_supplementary_file USING btree (id);


--
-- TOC entry 6523 (class 1259 OID 158880)
-- Name: f1000r_table_doi_status_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_table_doi_status_version_id_idx ON public.f1000r_table_doi_status USING btree (version_id);


--
-- TOC entry 6534 (class 1259 OID 13950479)
-- Name: f1000r_translation_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_translation_affiliation_uid_idx ON public.f1000r_translation_affiliation USING btree (affiliation_uid);


--
-- TOC entry 6551 (class 1259 OID 158881)
-- Name: f1000r_upload_info_type_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_upload_info_type_version_id_idx ON public.f1000r_upload_info USING btree (type, version_id);


--
-- TOC entry 6552 (class 1259 OID 158882)
-- Name: f1000r_upload_info_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_upload_info_version_id_idx ON public.f1000r_upload_info USING btree (version_id);


--
-- TOC entry 6555 (class 1259 OID 158883)
-- Name: f1000r_usage_stats_article_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_usage_stats_article_idx ON public.f1000r_usage_stats USING btree (article_id);


--
-- TOC entry 6571 (class 1259 OID 158884)
-- Name: f1000r_version_article_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_article_id_idx ON public.f1000r_version USING btree (article_id);


--
-- TOC entry 6586 (class 1259 OID 13950475)
-- Name: f1000r_version_author_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_author_affiliation_uid_idx ON public.f1000r_version_author_affiliation USING btree (affiliation_uid);


--
-- TOC entry 6587 (class 1259 OID 158885)
-- Name: f1000r_version_author_affiliation_version_id_author_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_author_affiliation_version_id_author_id_idx ON public.f1000r_version_author_affiliation USING btree (version_id, author_id);


--
-- TOC entry 6588 (class 1259 OID 158886)
-- Name: f1000r_version_classification_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_classification_version_id_idx ON public.f1000r_version_classification USING btree (version_id);


--
-- TOC entry 6572 (class 1259 OID 158887)
-- Name: f1000r_version_doi_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_doi_idx ON public.f1000r_version USING btree (doi);


--
-- TOC entry 6573 (class 1259 OID 158888)
-- Name: f1000r_version_extended_data_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_extended_data_idx ON public.f1000r_version USING btree (extended_data_id);


--
-- TOC entry 6603 (class 1259 OID 158889)
-- Name: f1000r_version_pdf_detail_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_pdf_detail_version_id_idx ON public.f1000r_version_pdf_detail USING btree (file_hash, file_size);


--
-- TOC entry 6574 (class 1259 OID 6763424)
-- Name: f1000r_version_prescreen_in_progress_em_status_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_prescreen_in_progress_em_status_idx ON public.f1000r_version USING btree (em_status) WHERE ((em_status)::text = 'PRESCREENING_IN_PROGRESS'::text);


--
-- TOC entry 6575 (class 1259 OID 6763423)
-- Name: f1000r_version_prescreen_pending_em_status_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_prescreen_pending_em_status_idx ON public.f1000r_version USING btree (em_status) WHERE ((em_status)::text = 'PRESCREENING'::text);


--
-- TOC entry 6576 (class 1259 OID 6763422)
-- Name: f1000r_version_prescreen_rejected_em_status_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_prescreen_rejected_em_status_idx ON public.f1000r_version USING btree (em_status) WHERE ((em_status)::text = 'PRESCREENING_REJECTED'::text);


--
-- TOC entry 6577 (class 1259 OID 6763421)
-- Name: f1000r_version_prescreen_status_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_prescreen_status_idx ON public.f1000r_version USING btree (status) WHERE ((status)::text = 'PRESCREENING'::text);


--
-- TOC entry 6578 (class 1259 OID 158890)
-- Name: f1000r_version_short_url_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_short_url_idx ON public.f1000r_version USING btree (short_url);


--
-- TOC entry 6608 (class 1259 OID 34925973)
-- Name: f1000r_version_status_check_version_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_status_check_version_id_idx ON public.f1000r_version_status_check USING btree (version_id);


--
-- TOC entry 6609 (class 1259 OID 158891)
-- Name: f1000r_version_subtopic_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_version_subtopic_idx ON public.f1000r_version_subtopic USING btree (version_id);


--
-- TOC entry 6628 (class 1259 OID 158892)
-- Name: f1000r_wellcome_grant_information_reference_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX f1000r_wellcome_grant_information_reference_idx ON public.f1000r_wellcome_grant_information USING btree (reference);


--
-- TOC entry 6633 (class 1259 OID 158893)
-- Name: faculty_member_faculty_index; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX faculty_member_faculty_index ON public.faculty_member USING btree (faculty_id);


--
-- TOC entry 6634 (class 1259 OID 158894)
-- Name: faculty_member_parent_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX faculty_member_parent_idx ON public.faculty_member USING btree (parent);


--
-- TOC entry 6637 (class 1259 OID 158895)
-- Name: faculty_member_section_index; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX faculty_member_section_index ON public.faculty_member USING btree (section_id);


--
-- TOC entry 6638 (class 1259 OID 158896)
-- Name: faculty_member_status_index; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX faculty_member_status_index ON public.faculty_member USING btree (status);


--
-- TOC entry 6639 (class 1259 OID 158897)
-- Name: faculty_member_status_type_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX faculty_member_status_type_idx ON public.faculty_member USING btree (status, type);


--
-- TOC entry 6570 (class 1259 OID 158898)
-- Name: fug_fug_usr_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX fug_fug_usr_id_idx ON public.fug USING btree (fug_usr_id);


--
-- TOC entry 6706 (class 1259 OID 158899)
-- Name: idxExternalId; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX "idxExternalId" ON public.term USING btree (external_id);


--
-- TOC entry 6670 (class 1259 OID 158900)
-- Name: idxOntologyName; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX "idxOntologyName" ON public.ontology USING btree (name);


--
-- TOC entry 6663 (class 1259 OID 158901)
-- Name: idx_access_token; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_access_token ON public.oauth_token USING btree (access_token);


--
-- TOC entry 6241 (class 1259 OID 40545878)
-- Name: idx_author_lower_email; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_author_lower_email ON public.f1000r_author USING btree (lower((email)::text));


--
-- TOC entry 6664 (class 1259 OID 158902)
-- Name: idx_expired; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_expired ON public.oauth_token USING btree (access_token_expired);


--
-- TOC entry 6673 (class 1259 OID 40545877)
-- Name: idx_orcid_data_lower_email; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_orcid_data_lower_email ON public.orcid_access_data USING btree (lower((email)::text));


--
-- TOC entry 6674 (class 1259 OID 40545879)
-- Name: idx_orcid_data_website_faculty; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_orcid_data_website_faculty ON public.orcid_access_data USING btree (website_id, faculty_member_id);


--
-- TOC entry 6665 (class 1259 OID 158903)
-- Name: idx_refresh_token; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_refresh_token ON public.oauth_token USING btree (refresh_token);


--
-- TOC entry 6666 (class 1259 OID 158904)
-- Name: idx_refresh_token_expiry; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_refresh_token_expiry ON public.oauth_token USING btree (refresh_token_expired);


--
-- TOC entry 6667 (class 1259 OID 158905)
-- Name: idx_usr_id_combine; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX idx_usr_id_combine ON public.oauth_token USING btree (usr_id, client_id, scope);


--
-- TOC entry 6652 (class 1259 OID 158906)
-- Name: last_institutional_access_last_access_date_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX last_institutional_access_last_access_date_idx ON public.last_institutional_access USING btree (last_access_date);


--
-- TOC entry 6653 (class 1259 OID 158907)
-- Name: last_institutional_access_user_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX last_institutional_access_user_id_idx ON public.last_institutional_access USING btree (user_id NULLS FIRST);


--
-- TOC entry 6086 (class 1259 OID 158908)
-- Name: lower_case_article_title; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX lower_case_article_title ON public.article USING btree (lower((title)::text));


--
-- TOC entry 6087 (class 1259 OID 158909)
-- Name: lower_case_doi; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX lower_case_doi ON public.article USING btree (lower((doiid)::text));


--
-- TOC entry 6754 (class 1259 OID 158910)
-- Name: lower_case_usr_email; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX lower_case_usr_email ON public.usr USING btree (lower((usr_email)::text));


--
-- TOC entry 6755 (class 1259 OID 158911)
-- Name: lower_case_usr_fname; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX lower_case_usr_fname ON public.usr USING btree (lower((usr_fname)::text));


--
-- TOC entry 6756 (class 1259 OID 158912)
-- Name: lower_case_usr_lname; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX lower_case_usr_lname ON public.usr USING btree (lower((usr_lname)::text));


--
-- TOC entry 6660 (class 1259 OID 158913)
-- Name: name; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX name ON public.microservice_deployment USING btree (name);


--
-- TOC entry 6675 (class 1259 OID 158914)
-- Name: orcid_access_data_faculty_member_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX orcid_access_data_faculty_member_id_idx ON public.orcid_access_data USING btree (faculty_member_id);


--
-- TOC entry 6678 (class 1259 OID 158915)
-- Name: photograph_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX photograph_id_idx ON public.photograph USING btree (id);


--
-- TOC entry 6689 (class 1259 OID 158916)
-- Name: research_member_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX research_member_id_idx ON public.research_member USING btree (id);


--
-- TOC entry 6694 (class 1259 OID 158917)
-- Name: research_member_topic_ids; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX research_member_topic_ids ON public.research_member_topic USING btree (research_member_id);


--
-- TOC entry 6695 (class 1259 OID 158918)
-- Name: research_topic_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX research_topic_id_idx ON public.research_topic USING btree (id);


--
-- TOC entry 6704 (class 1259 OID 158919)
-- Name: subscription_end_date_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX subscription_end_date_idx ON public.subscription USING btree (end_date);


--
-- TOC entry 6705 (class 1259 OID 158920)
-- Name: subscription_user_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX subscription_user_id_idx ON public.subscription USING btree (user_id);


--
-- TOC entry 6713 (class 1259 OID 158921)
-- Name: thesaurus_synonym_term_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX thesaurus_synonym_term_id_idx ON public.thesaurus_synonym USING btree (term_id);


--
-- TOC entry 6717 (class 1259 OID 158922)
-- Name: thesaurus_term_parent_parent_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX thesaurus_term_parent_parent_id_idx ON public.thesaurus_term_parent USING btree (parent_id);


--
-- TOC entry 6720 (class 1259 OID 158923)
-- Name: thesaurus_term_parent_term_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX thesaurus_term_parent_term_id_idx ON public.thesaurus_term_parent USING btree (term_id);


--
-- TOC entry 6716 (class 1259 OID 158924)
-- Name: thesaurus_term_term_name_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX thesaurus_term_term_name_idx ON public.thesaurus_term USING btree (term_name);


--
-- TOC entry 6581 (class 1259 OID 158925)
-- Name: url_slug_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX url_slug_idx ON public.f1000r_version USING btree (url_slug);


--
-- TOC entry 6727 (class 1259 OID 158926)
-- Name: usa_usa_usr_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usa_usa_usr_id_idx ON public.usa USING btree (usa_usr_id);


--
-- TOC entry 6730 (class 1259 OID 158927)
-- Name: usb_usb_subscriber_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usb_usb_subscriber_id_idx ON public.usb USING btree (usb_subscriber_id);


--
-- TOC entry 6731 (class 1259 OID 158928)
-- Name: user_area_area_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX user_area_area_idx ON public.user_area_of_interest USING btree (area_of_interest_id);


--
-- TOC entry 6734 (class 1259 OID 158929)
-- Name: user_area_usr_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX user_area_usr_idx ON public.user_area_of_interest USING btree (user_id);


--
-- TOC entry 6739 (class 1259 OID 158930)
-- Name: user_sso_key_key_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX user_sso_key_key_idx ON public.user_sso_key USING btree (key);


--
-- TOC entry 6744 (class 1259 OID 158931)
-- Name: user_token_usr_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX user_token_usr_id_idx ON public.user_token USING btree (usr_id);


--
-- TOC entry 6751 (class 1259 OID 13950471)
-- Name: usi_affiliation_uid_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usi_affiliation_uid_idx ON public.usi USING btree (affiliation_uid);


--
-- TOC entry 6752 (class 1259 OID 158932)
-- Name: usi_usi_job_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usi_usi_job_id_idx ON public.usi USING btree (usi_job_id);


--
-- TOC entry 6753 (class 1259 OID 158933)
-- Name: usi_usr_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usi_usr_id_idx ON public.usi USING btree (usi_usr_id);


--
-- TOC entry 6759 (class 1259 OID 158934)
-- Name: usr_upper_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usr_upper_idx ON public.usr USING btree (upper((usr_email)::text));


--
-- TOC entry 6760 (class 1259 OID 158935)
-- Name: usr_usr_lname_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX usr_usr_lname_idx ON public.usr USING btree (usr_lname);


--
-- TOC entry 6763 (class 1259 OID 158936)
-- Name: uss_uss_usr_id_idx; Type: INDEX; Schema: public; Owner: f1000
--

CREATE INDEX uss_uss_usr_id_idx ON public.uss USING btree (uss_usr_id);


--
-- TOC entry 7053 (class 2620 OID 158937)
-- Name: f1000r_usr_roles f1000r_usr_roles_create_trig; Type: TRIGGER; Schema: public; Owner: f1000
--

CREATE TRIGGER f1000r_usr_roles_create_trig INSTEAD OF INSERT ON public.f1000r_usr_roles FOR EACH ROW EXECUTE FUNCTION public.f1000r_usr_roles_create();


--
-- TOC entry 7044 (class 2606 OID 158938)
-- Name: user_oauth FK_user_oauth_usr_usr_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_oauth
    ADD CONSTRAINT "FK_user_oauth_usr_usr_id" FOREIGN KEY (usr_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7045 (class 2606 OID 158943)
-- Name: user_sso_key FK_user_sso_key_usr; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_sso_key
    ADD CONSTRAINT "FK_user_sso_key_usr" FOREIGN KEY (usr_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7025 (class 2606 OID 158948)
-- Name: frg f1000_frg_fgr_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.frg
    ADD CONSTRAINT f1000_frg_fgr_fk FOREIGN KEY (frg_fgr_id) REFERENCES public.fgr(fgr_id);


--
-- TOC entry 7026 (class 2606 OID 158953)
-- Name: frg f1000_frg_fro_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.frg
    ADD CONSTRAINT f1000_frg_fro_fk FOREIGN KEY (frg_fro_id) REFERENCES public.fro(fro_id);


--
-- TOC entry 7001 (class 2606 OID 158958)
-- Name: fug f1000_fug_fgr_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.fug
    ADD CONSTRAINT f1000_fug_fgr_fk FOREIGN KEY (fug_fgr_id) REFERENCES public.fgr(fgr_id);


--
-- TOC entry 6816 (class 2606 OID 158963)
-- Name: f1000r_article_dataset_draft f1000r_article_dataset_draft_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_dataset_draft
    ADD CONSTRAINT f1000r_article_dataset_draft_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6820 (class 2606 OID 158968)
-- Name: f1000r_article_payment f1000r_article_payment_currency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_payment
    ADD CONSTRAINT f1000r_article_payment_currency_fkey FOREIGN KEY (currency) REFERENCES public.f1000r_currency_rate(currency);


--
-- TOC entry 6821 (class 2606 OID 158973)
-- Name: f1000r_article_payment f1000r_article_payment_pricing_category; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_payment
    ADD CONSTRAINT f1000r_article_payment_pricing_category FOREIGN KEY (article_pricing_category_id) REFERENCES public.f1000r_article_pricing_category(id);


--
-- TOC entry 6829 (class 2606 OID 158978)
-- Name: f1000r_article_referee_affiliation f1000r_article_referee_affiliation_affiliation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_affiliation
    ADD CONSTRAINT f1000r_article_referee_affiliation_affiliation_id_fkey FOREIGN KEY (affiliation_id) REFERENCES public.f1000r_affiliation(id);


--
-- TOC entry 6830 (class 2606 OID 158983)
-- Name: f1000r_article_referee_affiliation f1000r_article_referee_affiliation_article_referee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_affiliation
    ADD CONSTRAINT f1000r_article_referee_affiliation_article_referee_id_fkey FOREIGN KEY (article_referee_id) REFERENCES public.f1000r_article_referee(id);


--
-- TOC entry 6893 (class 2606 OID 158988)
-- Name: f1000r_collection_editorial_board_editors f1000r_collection_editorial_board_editors_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_editorial_board_editors
    ADD CONSTRAINT f1000r_collection_editorial_board_editors_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6894 (class 2606 OID 158993)
-- Name: f1000r_collection_editorial_board_editors f1000r_collection_editorial_board_editors_user_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_editorial_board_editors
    ADD CONSTRAINT f1000r_collection_editorial_board_editors_user_collection_id_fk FOREIGN KEY (user_collection_id) REFERENCES public.f1000r_user_collection(id) ON DELETE CASCADE;


--
-- TOC entry 6895 (class 2606 OID 158998)
-- Name: f1000r_collection_guest_editors f1000r_collection_guest_editors_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_guest_editors
    ADD CONSTRAINT f1000r_collection_guest_editors_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6896 (class 2606 OID 159003)
-- Name: f1000r_collection_guest_editors f1000r_collection_guest_editors_user_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_guest_editors
    ADD CONSTRAINT f1000r_collection_guest_editors_user_collection_id_fk FOREIGN KEY (user_collection_id) REFERENCES public.f1000r_user_collection(id) ON DELETE CASCADE;


--
-- TOC entry 6997 (class 2606 OID 159008)
-- Name: f1000r_user_collection f1000r_collection_user_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_collection
    ADD CONSTRAINT f1000r_collection_user_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6998 (class 2606 OID 159013)
-- Name: f1000r_user_collection f1000r_collection_user_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_collection
    ADD CONSTRAINT f1000r_collection_user_user_id_fk FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6940 (class 2606 OID 159018)
-- Name: f1000r_external_indexer_submission f1000r_external_indexer_submission_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_indexer_submission
    ADD CONSTRAINT f1000r_external_indexer_submission_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6948 (class 2606 OID 159023)
-- Name: f1000r_invoice_file f1000r_invoice_file_article_payment_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_invoice_file
    ADD CONSTRAINT f1000r_invoice_file_article_payment_fk FOREIGN KEY (article_payment_id) REFERENCES public.f1000r_article_payment(id);


--
-- TOC entry 6959 (class 2606 OID 159028)
-- Name: f1000r_permanently_deleted_user f1000r_permanently_deleted_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_permanently_deleted_user
    ADD CONSTRAINT f1000r_permanently_deleted_user_fkey FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6965 (class 2606 OID 159033)
-- Name: f1000r_project_info_version f1000r_project_info_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_project_info_version
    ADD CONSTRAINT f1000r_project_info_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6989 (class 2606 OID 159038)
-- Name: f1000r_scoups_citation f1000r_scoups_citation_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_scoups_citation
    ADD CONSTRAINT f1000r_scoups_citation_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7008 (class 2606 OID 159048)
-- Name: f1000r_version_author_affiliation f1000r_version_author_affiliation_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_author_affiliation
    ADD CONSTRAINT f1000r_version_author_affiliation_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.f1000r_author(id);


--
-- TOC entry 7009 (class 2606 OID 159053)
-- Name: f1000r_version_author_affiliation f1000r_version_author_affiliation_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_author_affiliation
    ADD CONSTRAINT f1000r_version_author_affiliation_version_id_fkey FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7021 (class 2606 OID 159058)
-- Name: faculty_member faculty_member_commissioner_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.faculty_member
    ADD CONSTRAINT faculty_member_commissioner_fk FOREIGN KEY (commissioner_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7022 (class 2606 OID 159063)
-- Name: faculty_member faculty_member_next_contact_last_edited_editor_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.faculty_member
    ADD CONSTRAINT faculty_member_next_contact_last_edited_editor_fk FOREIGN KEY (next_contact_last_edited_editor_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6803 (class 2606 OID 159073)
-- Name: f1000r_affiliation fk_affiliation_institution_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_affiliation
    ADD CONSTRAINT fk_affiliation_institution_id FOREIGN KEY (institution_id) REFERENCES public.bible_institution(id);


--
-- TOC entry 6804 (class 2606 OID 159078)
-- Name: f1000r_affiliation fk_affiliation_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_affiliation
    ADD CONSTRAINT fk_affiliation_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6926 (class 2606 OID 159083)
-- Name: f1000r_email_alert fk_alert_email_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_alert
    ADD CONSTRAINT fk_alert_email_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6809 (class 2606 OID 159088)
-- Name: f1000r_article_collection_suggestion fk_article_article_collection_suggestion; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_suggestion
    ADD CONSTRAINT fk_article_article_collection_suggestion FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6805 (class 2606 OID 159093)
-- Name: f1000r_article fk_article_article_payment; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article
    ADD CONSTRAINT fk_article_article_payment FOREIGN KEY (article_payment_id) REFERENCES public.f1000r_article_payment(id);


--
-- TOC entry 6825 (class 2606 OID 159098)
-- Name: f1000r_article_person_orcid fk_article_author_orcid_access_data; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_person_orcid
    ADD CONSTRAINT fk_article_author_orcid_access_data FOREIGN KEY (orcid_access_data_id) REFERENCES public.orcid_access_data(id);


--
-- TOC entry 6814 (class 2606 OID 159103)
-- Name: f1000r_article_collection_view fk_article_collection_view_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_view
    ADD CONSTRAINT fk_article_collection_view_id FOREIGN KEY (asset_view_id) REFERENCES public.f1000r_asset_view(id);


--
-- TOC entry 6887 (class 2606 OID 159108)
-- Name: f1000r_collection_article fk_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_article
    ADD CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6942 (class 2606 OID 159113)
-- Name: f1000r_featured_article fk_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_article
    ADD CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6899 (class 2606 OID 159118)
-- Name: f1000r_collection_related_article fk_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_related_article
    ADD CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6827 (class 2606 OID 159123)
-- Name: f1000r_article_referee fk_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee
    ADD CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6815 (class 2606 OID 159128)
-- Name: f1000r_article_country fk_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_country
    ADD CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6817 (class 2606 OID 159133)
-- Name: f1000r_article_log fk_article_log_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_log
    ADD CONSTRAINT fk_article_log_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6818 (class 2606 OID 159138)
-- Name: f1000r_article_log fk_article_log_editor_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_log
    ADD CONSTRAINT fk_article_log_editor_id FOREIGN KEY (editor_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6819 (class 2606 OID 159143)
-- Name: f1000r_article_log fk_article_log_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_log
    ADD CONSTRAINT fk_article_log_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6806 (class 2606 OID 159148)
-- Name: f1000r_article fk_article_main_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article
    ADD CONSTRAINT fk_article_main_collection_id FOREIGN KEY (main_collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6822 (class 2606 OID 159153)
-- Name: f1000r_article_payment fk_article_payment_automatic_invoice_info_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_payment
    ADD CONSTRAINT fk_article_payment_automatic_invoice_info_id FOREIGN KEY (automatic_invoice_info_id) REFERENCES public.f1000r_automatic_invoice_info(id);


--
-- TOC entry 6823 (class 2606 OID 159163)
-- Name: f1000r_article_payment fk_article_payment_paypal_payment_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_payment
    ADD CONSTRAINT fk_article_payment_paypal_payment_id FOREIGN KEY (paypal_payment_id) REFERENCES public.f1000r_paypal_payment(id);


--
-- TOC entry 6824 (class 2606 OID 159168)
-- Name: f1000r_article_payment fk_article_payment_sage_payment_response_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_payment
    ADD CONSTRAINT fk_article_payment_sage_payment_response_id FOREIGN KEY (sage_payment_response_id) REFERENCES public.f1000r_sage_response(id);


--
-- TOC entry 6826 (class 2606 OID 159173)
-- Name: f1000r_article_question fk_article_question_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_question
    ADD CONSTRAINT fk_article_question_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6831 (class 2606 OID 159178)
-- Name: f1000r_article_referee_status_tracker fk_article_referee_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_status_tracker
    ADD CONSTRAINT fk_article_referee_id FOREIGN KEY (article_referee_id) REFERENCES public.f1000r_article_referee(id);


--
-- TOC entry 6833 (class 2606 OID 159183)
-- Name: f1000r_article_statistic fk_article_statistic; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_statistic
    ADD CONSTRAINT fk_article_statistic FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6834 (class 2606 OID 159188)
-- Name: f1000r_article_tracking fk_article_tracking_article; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_tracking
    ADD CONSTRAINT fk_article_tracking_article FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6835 (class 2606 OID 159193)
-- Name: f1000r_article_tracking fk_article_tracking_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_tracking
    ADD CONSTRAINT fk_article_tracking_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6797 (class 2606 OID 159198)
-- Name: articles_thesaurus_terms fk_articles_thesaurus_terms_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.articles_thesaurus_terms
    ADD CONSTRAINT fk_articles_thesaurus_terms_article_id FOREIGN KEY (article_id) REFERENCES public.article(id);


--
-- TOC entry 6798 (class 2606 OID 159203)
-- Name: articles_thesaurus_terms fk_articles_thesaurus_terms_term_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.articles_thesaurus_terms
    ADD CONSTRAINT fk_articles_thesaurus_terms_term_id FOREIGN KEY (term_id) REFERENCES public.thesaurus_term(id);


--
-- TOC entry 6853 (class 2606 OID 159208)
-- Name: f1000r_asset_collection_suggestion fk_asset_asset_collection_suggestion; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_collection_suggestion
    ADD CONSTRAINT fk_asset_asset_collection_suggestion FOREIGN KEY (asset_id) REFERENCES public.f1000r_asset(id);


--
-- TOC entry 6849 (class 2606 OID 159213)
-- Name: f1000r_asset_author_affiliation fk_asset_author_affiliation_author_aff_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author_affiliation
    ADD CONSTRAINT fk_asset_author_affiliation_author_aff_id FOREIGN KEY (affiliation_id) REFERENCES public.f1000r_asset_affiliation(id);


--
-- TOC entry 6850 (class 2606 OID 159218)
-- Name: f1000r_asset_author_affiliation fk_asset_author_affiliation_author_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author_affiliation
    ADD CONSTRAINT fk_asset_author_affiliation_author_asset_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6851 (class 2606 OID 159223)
-- Name: f1000r_asset_author_affiliation fk_asset_author_affiliation_author_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author_affiliation
    ADD CONSTRAINT fk_asset_author_affiliation_author_id FOREIGN KEY (author_id) REFERENCES public.f1000r_author(id);


--
-- TOC entry 6847 (class 2606 OID 159228)
-- Name: f1000r_asset_author fk_asset_author_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author
    ADD CONSTRAINT fk_asset_author_asset_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6848 (class 2606 OID 159233)
-- Name: f1000r_asset_author fk_asset_author_author_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_author
    ADD CONSTRAINT fk_asset_author_author_id FOREIGN KEY (author_id) REFERENCES public.f1000r_author(id);


--
-- TOC entry 6882 (class 2606 OID 159238)
-- Name: f1000r_author_view fk_asset_author_view_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_view
    ADD CONSTRAINT fk_asset_author_view_id FOREIGN KEY (asset_view_id) REFERENCES public.f1000r_asset_view(id);


--
-- TOC entry 6852 (class 2606 OID 159243)
-- Name: f1000r_asset_classification fk_asset_classification_article_asset_metadata_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_classification
    ADD CONSTRAINT fk_asset_classification_article_asset_metadata_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6846 (class 2606 OID 159248)
-- Name: f1000r_asset_affiliation fk_asset_department_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_affiliation
    ADD CONSTRAINT fk_asset_department_id FOREIGN KEY (department_id) REFERENCES public.f1000r_asset_department(id);


--
-- TOC entry 6836 (class 2606 OID 159253)
-- Name: f1000r_asset fk_asset_editor_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_editor_id FOREIGN KEY (editor_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6857 (class 2606 OID 159258)
-- Name: f1000r_asset_editor_submitter_view fk_asset_editor_submitter_view_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_editor_submitter_view
    ADD CONSTRAINT fk_asset_editor_submitter_view_id FOREIGN KEY (asset_view_id) REFERENCES public.f1000r_asset_view(id);


--
-- TOC entry 6889 (class 2606 OID 159263)
-- Name: f1000r_collection_asset fk_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_asset
    ADD CONSTRAINT fk_asset_id FOREIGN KEY (asset_id) REFERENCES public.f1000r_asset(id);


--
-- TOC entry 6855 (class 2606 OID 159268)
-- Name: f1000r_asset_country fk_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_country
    ADD CONSTRAINT fk_asset_id FOREIGN KEY (asset_id) REFERENCES public.f1000r_asset(id);


--
-- TOC entry 6856 (class 2606 OID 159273)
-- Name: f1000r_asset_department fk_asset_institution_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_department
    ADD CONSTRAINT fk_asset_institution_id FOREIGN KEY (institution_id) REFERENCES public.f1000r_asset_institution(id);


--
-- TOC entry 6837 (class 2606 OID 159278)
-- Name: f1000r_asset fk_asset_main_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_main_collection_id FOREIGN KEY (main_collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6838 (class 2606 OID 159283)
-- Name: f1000r_asset fk_asset_metadata_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_metadata_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6859 (class 2606 OID 159288)
-- Name: f1000r_asset_metadata fk_asset_metadata_language; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_metadata
    ADD CONSTRAINT fk_asset_metadata_language FOREIGN KEY (language_id) REFERENCES public.f1000r_language(id);


--
-- TOC entry 6860 (class 2606 OID 159293)
-- Name: f1000r_asset_metadata fk_asset_metadata_submitter; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_metadata
    ADD CONSTRAINT fk_asset_metadata_submitter FOREIGN KEY (submitter_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6839 (class 2606 OID 159298)
-- Name: f1000r_asset fk_asset_presenter_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_presenter_id FOREIGN KEY (presenter_id) REFERENCES public.f1000r_presenter(id);


--
-- TOC entry 6861 (class 2606 OID 159303)
-- Name: f1000r_asset_related_article fk_asset_related_article_asset_metadata_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_related_article
    ADD CONSTRAINT fk_asset_related_article_asset_metadata_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6867 (class 2606 OID 159308)
-- Name: f1000r_asset_view fk_asset_submitter_view_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_view
    ADD CONSTRAINT fk_asset_submitter_view_id FOREIGN KEY (asset_submitter_view_id) REFERENCES public.f1000r_asset_submitter_view(id);


--
-- TOC entry 6862 (class 2606 OID 159313)
-- Name: f1000r_asset_supplementary_file fk_asset_sup_file_asset; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_supplementary_file
    ADD CONSTRAINT fk_asset_sup_file_asset FOREIGN KEY (asset_id) REFERENCES public.f1000r_asset(id);


--
-- TOC entry 6863 (class 2606 OID 159318)
-- Name: f1000r_asset_supplementary_file fk_asset_sup_file_sup_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_supplementary_file
    ADD CONSTRAINT fk_asset_sup_file_sup_file FOREIGN KEY (supplementary_file_id) REFERENCES public.f1000r_supplementary_file(id);


--
-- TOC entry 6864 (class 2606 OID 159323)
-- Name: f1000r_asset_topic fk_asset_topic_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_topic
    ADD CONSTRAINT fk_asset_topic_asset_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6865 (class 2606 OID 159328)
-- Name: f1000r_asset_topic fk_asset_topic_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_topic
    ADD CONSTRAINT fk_asset_topic_topic_id FOREIGN KEY (topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6840 (class 2606 OID 159333)
-- Name: f1000r_asset fk_asset_upload_info_asset_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_upload_info_asset_file FOREIGN KEY (asset_file_id) REFERENCES public.f1000r_asset_upload_info(id);


--
-- TOC entry 6841 (class 2606 OID 159338)
-- Name: f1000r_asset fk_asset_upload_info_original_asset_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_upload_info_original_asset_file FOREIGN KEY (original_file_id) REFERENCES public.f1000r_asset_upload_info(id);


--
-- TOC entry 6842 (class 2606 OID 159343)
-- Name: f1000r_asset fk_asset_upload_info_thumbnail; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_asset_upload_info_thumbnail FOREIGN KEY (thumbnail_id) REFERENCES public.f1000r_asset_upload_info(id);


--
-- TOC entry 6868 (class 2606 OID 159348)
-- Name: f1000r_attachment_email_info fk_attachment_email_info_tracking_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_attachment_email_info
    ADD CONSTRAINT fk_attachment_email_info_tracking_id FOREIGN KEY (email_tracking_id) REFERENCES public.f1000r_email_internal(id);


--
-- TOC entry 6870 (class 2606 OID 159353)
-- Name: f1000r_author_version fk_author_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES public.f1000r_author(id);


--
-- TOC entry 6921 (class 2606 OID 159358)
-- Name: f1000r_corresponding_author_version fk_author_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_corresponding_author_version
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES public.f1000r_author(id);


--
-- TOC entry 6873 (class 2606 OID 159363)
-- Name: f1000r_author_version_affiliation_draft fk_author_version_draft_aff_draft; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_affiliation_draft
    ADD CONSTRAINT fk_author_version_draft_aff_draft FOREIGN KEY (author_version_draft_id) REFERENCES public.f1000r_author_version_draft(id);


--
-- TOC entry 6876 (class 2606 OID 159368)
-- Name: f1000r_author_version_contributor_role_draft fk_author_version_draft_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_contributor_role_draft
    ADD CONSTRAINT fk_author_version_draft_id FOREIGN KEY (author_version_draft_id) REFERENCES public.f1000r_author_version_draft(id);


--
-- TOC entry 6879 (class 2606 OID 159373)
-- Name: f1000r_author_version_draft fk_author_version_draft_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_draft
    ADD CONSTRAINT fk_author_version_draft_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6880 (class 2606 OID 159378)
-- Name: f1000r_author_version_draft fk_author_version_draft_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_draft
    ADD CONSTRAINT fk_author_version_draft_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6874 (class 2606 OID 159383)
-- Name: f1000r_author_version_contributor_role fk_author_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_contributor_role
    ADD CONSTRAINT fk_author_version_id FOREIGN KEY (author_version_id) REFERENCES public.f1000r_author_version(id);


--
-- TOC entry 6871 (class 2606 OID 159388)
-- Name: f1000r_author_version fk_author_version_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version
    ADD CONSTRAINT fk_author_version_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6810 (class 2606 OID 159393)
-- Name: f1000r_article_collection_suggestion fk_collection_article_collection_suggestion; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_suggestion
    ADD CONSTRAINT fk_collection_article_collection_suggestion FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6854 (class 2606 OID 159398)
-- Name: f1000r_asset_collection_suggestion fk_collection_asset_collection_suggestion; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_collection_suggestion
    ADD CONSTRAINT fk_collection_asset_collection_suggestion FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6884 (class 2606 OID 159403)
-- Name: f1000r_collection fk_collection_editorial_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection
    ADD CONSTRAINT fk_collection_editorial_article_id FOREIGN KEY (editorial_article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6888 (class 2606 OID 159408)
-- Name: f1000r_collection_article fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_article
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6900 (class 2606 OID 159413)
-- Name: f1000r_collection_related_article fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_related_article
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6890 (class 2606 OID 159418)
-- Name: f1000r_collection_asset fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_asset
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6901 (class 2606 OID 159423)
-- Name: f1000r_collection_research_topic fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_research_topic
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6891 (class 2606 OID 159428)
-- Name: f1000r_collection_document_type fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_document_type
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6898 (class 2606 OID 159433)
-- Name: f1000r_collection_news fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_news
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6897 (class 2606 OID 159438)
-- Name: f1000r_collection_link fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_link
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 7052 (class 2606 OID 30964196)
-- Name: f1000r_collection_custompages fk_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_custompages
    ADD CONSTRAINT fk_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6906 (class 2606 OID 159443)
-- Name: f1000r_collection_version_type fk_collection_version_type_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_version_type
    ADD CONSTRAINT fk_collection_version_type_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6869 (class 2606 OID 27632840)
-- Name: f1000r_author_version fk_collective_author_file_author_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version
    ADD CONSTRAINT fk_collective_author_file_author_version FOREIGN KEY (collective_author_file_id) REFERENCES public.collective_author_file(id);


--
-- TOC entry 6878 (class 2606 OID 27632845)
-- Name: f1000r_author_version_draft fk_collective_author_file_author_version_draft; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_draft
    ADD CONSTRAINT fk_collective_author_file_author_version_draft FOREIGN KEY (collective_author_file_id) REFERENCES public.collective_author_file(id);


--
-- TOC entry 6907 (class 2606 OID 159448)
-- Name: f1000r_comment fk_comment_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment
    ADD CONSTRAINT fk_comment_asset_id FOREIGN KEY (asset_id) REFERENCES public.f1000r_asset(id);


--
-- TOC entry 6911 (class 2606 OID 159453)
-- Name: f1000r_comment_commenter_role fk_comment_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment_commenter_role
    ADD CONSTRAINT fk_comment_id FOREIGN KEY (comment_id) REFERENCES public.f1000r_comment(id);


--
-- TOC entry 6908 (class 2606 OID 159458)
-- Name: f1000r_comment fk_comment_report_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment
    ADD CONSTRAINT fk_comment_report_id FOREIGN KEY (report_id) REFERENCES public.f1000r_report(id);


--
-- TOC entry 6909 (class 2606 OID 159463)
-- Name: f1000r_comment fk_comment_usr_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment
    ADD CONSTRAINT fk_comment_usr_id FOREIGN KEY (usr_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6910 (class 2606 OID 159468)
-- Name: f1000r_comment fk_comment_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment
    ADD CONSTRAINT fk_comment_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6916 (class 2606 OID 159473)
-- Name: f1000r_conference_detail fk_conference_details_asset_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_detail
    ADD CONSTRAINT fk_conference_details_asset_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 6917 (class 2606 OID 159478)
-- Name: f1000r_conference_detail fk_conference_details_conference_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_detail
    ADD CONSTRAINT fk_conference_details_conference_id FOREIGN KEY (conference_id) REFERENCES public.f1000r_conference(id);


--
-- TOC entry 6920 (class 2606 OID 159483)
-- Name: f1000r_conference_view fk_conference_view_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_view
    ADD CONSTRAINT fk_conference_view_id FOREIGN KEY (asset_view_id) REFERENCES public.f1000r_asset_view(id);


--
-- TOC entry 6914 (class 2606 OID 159488)
-- Name: f1000r_conference fk_conference_website_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference
    ADD CONSTRAINT fk_conference_website_id FOREIGN KEY (website_id) REFERENCES public.f1000r_website(id);


--
-- TOC entry 6877 (class 2606 OID 159493)
-- Name: f1000r_author_version_contributor_role_draft fk_contributor_role_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_contributor_role_draft
    ADD CONSTRAINT fk_contributor_role_id FOREIGN KEY (contributor_role_id) REFERENCES public.f1000r_contributor_role(id);


--
-- TOC entry 6875 (class 2606 OID 159498)
-- Name: f1000r_author_version_contributor_role fk_contributor_role_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_contributor_role
    ADD CONSTRAINT fk_contributor_role_id FOREIGN KEY (contributor_role_id) REFERENCES public.f1000r_contributor_role(id);


--
-- TOC entry 6800 (class 2606 OID 159503)
-- Name: core_research_topic fk_core_research_topic_subtopic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.core_research_topic
    ADD CONSTRAINT fk_core_research_topic_subtopic_id FOREIGN KEY (subtopic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6801 (class 2606 OID 159508)
-- Name: core_research_topic fk_core_research_topic_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.core_research_topic
    ADD CONSTRAINT fk_core_research_topic_topic_id FOREIGN KEY (topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6912 (class 2606 OID 159523)
-- Name: f1000r_comment_report fk_creport_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment_report
    ADD CONSTRAINT fk_creport_id FOREIGN KEY (report_id) REFERENCES public.f1000r_report(id);


--
-- TOC entry 6923 (class 2606 OID 159528)
-- Name: f1000r_crosscheck fk_crosscheck_approvedby_usr_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_crosscheck
    ADD CONSTRAINT fk_crosscheck_approvedby_usr_id FOREIGN KEY (approvedby_usr_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6924 (class 2606 OID 159533)
-- Name: f1000r_crosscheck fk_crosscheck_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_crosscheck
    ADD CONSTRAINT fk_crosscheck_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6966 (class 2606 OID 159538)
-- Name: f1000r_promotional_code fk_discount_product_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_promotional_code
    ADD CONSTRAINT fk_discount_product_id FOREIGN KEY (product_id) REFERENCES public.f1000r_paypal_product(id);


--
-- TOC entry 6892 (class 2606 OID 159543)
-- Name: f1000r_collection_document_type fk_document_type_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_document_type
    ADD CONSTRAINT fk_document_type_id FOREIGN KEY (document_type_id) REFERENCES public.f1000r_document_type(id);


--
-- TOC entry 6843 (class 2606 OID 159548)
-- Name: f1000r_asset fk_document_type_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_document_type_id FOREIGN KEY (document_type_id) REFERENCES public.f1000r_document_type(id);


--
-- TOC entry 6925 (class 2606 OID 159553)
-- Name: f1000r_editor_external_count fk_editor_external_count_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_editor_external_count
    ADD CONSTRAINT fk_editor_external_count_user_id FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6927 (class 2606 OID 159558)
-- Name: f1000r_email_alert_log fk_email_alert_log_email_alert; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_alert_log
    ADD CONSTRAINT fk_email_alert_log_email_alert FOREIGN KEY (email_alert_id) REFERENCES public.f1000r_email_alert(id);


--
-- TOC entry 6928 (class 2606 OID 159563)
-- Name: f1000r_email_alert_log fk_email_alert_log_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_alert_log
    ADD CONSTRAINT fk_email_alert_log_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6930 (class 2606 OID 159568)
-- Name: f1000r_email_internal_recipients fk_email_internal_recipients_emails; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_internal_recipients
    ADD CONSTRAINT fk_email_internal_recipients_emails FOREIGN KEY (email_internal_id) REFERENCES public.f1000r_email_internal(id);


--
-- TOC entry 6931 (class 2606 OID 159573)
-- Name: f1000r_email_internal_recipients fk_email_internal_recipients_user_to; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_internal_recipients
    ADD CONSTRAINT fk_email_internal_recipients_user_to FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6929 (class 2606 OID 159578)
-- Name: f1000r_email_internal fk_email_internal_user_from; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_internal
    ADD CONSTRAINT fk_email_internal_user_from FOREIGN KEY (user_id_from) REFERENCES public.usr(usr_id);


--
-- TOC entry 6932 (class 2606 OID 159583)
-- Name: f1000r_email_message fk_email_messages_article; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message
    ADD CONSTRAINT fk_email_messages_article FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6936 (class 2606 OID 159588)
-- Name: f1000r_email_message_attachement fk_email_messages_attached_messages; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message_attachement
    ADD CONSTRAINT fk_email_messages_attached_messages FOREIGN KEY (email_message_id) REFERENCES public.f1000r_email_message(id);


--
-- TOC entry 6933 (class 2606 OID 159593)
-- Name: f1000r_email_message fk_email_messages_authors; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message
    ADD CONSTRAINT fk_email_messages_authors FOREIGN KEY (author_id) REFERENCES public.f1000r_author(id);


--
-- TOC entry 6934 (class 2606 OID 159598)
-- Name: f1000r_email_message fk_email_messages_referees; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message
    ADD CONSTRAINT fk_email_messages_referees FOREIGN KEY (referee_id) REFERENCES public.f1000r_referee(id);


--
-- TOC entry 6935 (class 2606 OID 159603)
-- Name: f1000r_email_message fk_email_messages_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_email_message
    ADD CONSTRAINT fk_email_messages_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6937 (class 2606 OID 159608)
-- Name: f1000r_enquiry_reason fk_enquiry_author_reason_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_enquiry_reason
    ADD CONSTRAINT fk_enquiry_author_reason_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6938 (class 2606 OID 159613)
-- Name: f1000r_enquiry_reason_template_version fk_enquiry_reason_template_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_enquiry_reason_template_version
    ADD CONSTRAINT fk_enquiry_reason_template_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6939 (class 2606 OID 159618)
-- Name: f1000r_etoc_alert_term fk_etoc_alert_term_email_alert; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_etoc_alert_term
    ADD CONSTRAINT fk_etoc_alert_term_email_alert FOREIGN KEY (email_alert_id) REFERENCES public.f1000r_email_alert(id);


--
-- TOC entry 6915 (class 2606 OID 159623)
-- Name: f1000r_conference fk_f1000_conference_approver_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference
    ADD CONSTRAINT fk_f1000_conference_approver_id FOREIGN KEY (approver_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6956 (class 2606 OID 159628)
-- Name: f1000r_organization fk_f1000_organization_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_organization
    ADD CONSTRAINT fk_f1000_organization_creator_id FOREIGN KEY (creator_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6811 (class 2606 OID 159633)
-- Name: f1000r_article_collection_tracking fk_f1000r_article_collection_tracking_article; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_tracking
    ADD CONSTRAINT fk_f1000r_article_collection_tracking_article FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6812 (class 2606 OID 159638)
-- Name: f1000r_article_collection_tracking fk_f1000r_article_collection_tracking_collection; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_tracking
    ADD CONSTRAINT fk_f1000r_article_collection_tracking_collection FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6813 (class 2606 OID 159643)
-- Name: f1000r_article_collection_tracking fk_f1000r_article_collection_tracking_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_collection_tracking
    ADD CONSTRAINT fk_f1000r_article_collection_tracking_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6866 (class 2606 OID 159648)
-- Name: f1000r_asset_upload_info fk_f1000r_asset_upload_info_asset; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_upload_info
    ADD CONSTRAINT fk_f1000r_asset_upload_info_asset FOREIGN KEY (asset_id) REFERENCES public.f1000r_asset(id);


--
-- TOC entry 6844 (class 2606 OID 159653)
-- Name: f1000r_asset fk_f1000r_asset_upload_info_compressed; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_f1000r_asset_upload_info_compressed FOREIGN KEY (compressed_file_id) REFERENCES public.f1000r_asset_upload_info(id);


--
-- TOC entry 6845 (class 2606 OID 159658)
-- Name: f1000r_asset fk_f1000r_asset_upload_info_converted_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset
    ADD CONSTRAINT fk_f1000r_asset_upload_info_converted_file FOREIGN KEY (converted_file_id) REFERENCES public.f1000r_asset_upload_info(id);


--
-- TOC entry 6883 (class 2606 OID 159663)
-- Name: f1000r_co_author_email_notification_tracking fk_f1000r_author_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_co_author_email_notification_tracking
    ADD CONSTRAINT fk_f1000r_author_version_id FOREIGN KEY (author_version_id) REFERENCES public.f1000r_author_version(id);


--
-- TOC entry 6904 (class 2606 OID 159668)
-- Name: f1000r_collection_tracking fk_f1000r_collection_tracking_collection; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_tracking
    ADD CONSTRAINT fk_f1000r_collection_tracking_collection FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6905 (class 2606 OID 159673)
-- Name: f1000r_collection_tracking fk_f1000r_collection_tracking_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_tracking
    ADD CONSTRAINT fk_f1000r_collection_tracking_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6918 (class 2606 OID 159678)
-- Name: f1000r_conference_organization fk_f1000r_conference_organization_conference_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_organization
    ADD CONSTRAINT fk_f1000r_conference_organization_conference_id FOREIGN KEY (conference_id) REFERENCES public.f1000r_conference(id);


--
-- TOC entry 6919 (class 2606 OID 159683)
-- Name: f1000r_conference_organization fk_f1000r_conference_organization_organization_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_conference_organization
    ADD CONSTRAINT fk_f1000r_conference_organization_organization_id FOREIGN KEY (organization_id) REFERENCES public.f1000r_organization(id);


--
-- TOC entry 6943 (class 2606 OID 159688)
-- Name: f1000r_featured_collection fk_f1000r_featured_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_collection
    ADD CONSTRAINT fk_f1000r_featured_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6944 (class 2606 OID 159693)
-- Name: f1000r_featured_report fk_f1000r_featured_report_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_report
    ADD CONSTRAINT fk_f1000r_featured_report_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6964 (class 2606 OID 159698)
-- Name: f1000r_prime_related_article fk_f1000r_prime_ebola_article; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_prime_related_article
    ADD CONSTRAINT fk_f1000r_prime_ebola_article FOREIGN KEY (article_id) REFERENCES public.article(id);


--
-- TOC entry 6968 (class 2606 OID 159703)
-- Name: f1000r_published_version fk_f1000r_published_version_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_published_version
    ADD CONSTRAINT fk_f1000r_published_version_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6984 (class 2606 OID 159708)
-- Name: f1000r_related_article fk_first_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_related_article
    ADD CONSTRAINT fk_first_article_id FOREIGN KEY (first_article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 7023 (class 2606 OID 159713)
-- Name: faculty_member fk_fm_faculty_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.faculty_member
    ADD CONSTRAINT fk_fm_faculty_id FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- TOC entry 6946 (class 2606 OID 159718)
-- Name: f1000r_funder_information fk_funder_information_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_funder_information
    ADD CONSTRAINT fk_funder_information_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6885 (class 2606 OID 159723)
-- Name: f1000r_collection fk_gateway_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection
    ADD CONSTRAINT fk_gateway_id FOREIGN KEY (parent_gateway_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6886 (class 2606 OID 3276955)
-- Name: f1000r_collection fk_gateway_payment; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection
    ADD CONSTRAINT fk_gateway_payment FOREIGN KEY (gateway_payment_id) REFERENCES public.f1000r_gateway_payment(id);


--
-- TOC entry 6858 (class 2606 OID 159728)
-- Name: f1000r_asset_grant fk_grant_asset_metadata_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_asset_grant
    ADD CONSTRAINT fk_grant_asset_metadata_id FOREIGN KEY (asset_metadata_id) REFERENCES public.f1000r_asset_metadata(id);


--
-- TOC entry 7019 (class 2606 OID 159733)
-- Name: f1000r_wellcome_grant_holder fk_grant_information_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_wellcome_grant_holder
    ADD CONSTRAINT fk_grant_information_id FOREIGN KEY (grant_information_id) REFERENCES public.f1000r_grant_information(id) ON DELETE CASCADE;


--
-- TOC entry 6947 (class 2606 OID 159738)
-- Name: f1000r_grant_information fk_grant_information_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_grant_information
    ADD CONSTRAINT fk_grant_information_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6802 (class 2606 OID 159743)
-- Name: department fk_institution_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT fk_institution_id FOREIGN KEY (institution_id) REFERENCES public.institution(id);


--
-- TOC entry 6949 (class 2606 OID 159748)
-- Name: f1000r_living_figure_uploader_details fk_living_figure_article_dataset; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_living_figure_uploader_details
    ADD CONSTRAINT fk_living_figure_article_dataset FOREIGN KEY (article_dataset_id) REFERENCES public.f1000r_article_dataset(id) ON DELETE CASCADE;


--
-- TOC entry 6950 (class 2606 OID 159753)
-- Name: f1000r_living_figure_uploader_details fk_living_figure_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_living_figure_uploader_details
    ADD CONSTRAINT fk_living_figure_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6951 (class 2606 OID 159758)
-- Name: f1000r_note fk_note_article; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_note
    ADD CONSTRAINT fk_note_article FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6952 (class 2606 OID 159763)
-- Name: f1000r_note fk_note_article_referee; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_note
    ADD CONSTRAINT fk_note_article_referee FOREIGN KEY (article_referee_id) REFERENCES public.f1000r_article_referee(id);


--
-- TOC entry 6953 (class 2606 OID 159768)
-- Name: f1000r_note fk_note_email; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_note
    ADD CONSTRAINT fk_note_email FOREIGN KEY (email_message_id) REFERENCES public.f1000r_email_message(id);


--
-- TOC entry 6954 (class 2606 OID 159773)
-- Name: f1000r_note fk_note_usr; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_note
    ADD CONSTRAINT fk_note_usr FOREIGN KEY (editor_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6955 (class 2606 OID 159778)
-- Name: f1000r_note fk_note_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_note
    ADD CONSTRAINT fk_note_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7037 (class 2606 OID 159783)
-- Name: term fk_ontology; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.term
    ADD CONSTRAINT fk_ontology FOREIGN KEY (ontology_id) REFERENCES public.ontology(id);


--
-- TOC entry 7038 (class 2606 OID 159788)
-- Name: term_relationship fk_ontology; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.term_relationship
    ADD CONSTRAINT fk_ontology FOREIGN KEY (ontology_id) REFERENCES public.ontology(id);


--
-- TOC entry 7028 (class 2606 OID 159793)
-- Name: orcid_access_data fk_orcid_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.orcid_access_data
    ADD CONSTRAINT fk_orcid_user_id FOREIGN KEY (faculty_member_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6957 (class 2606 OID 159798)
-- Name: f1000r_organization fk_organization_website_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_organization
    ADD CONSTRAINT fk_organization_website_id FOREIGN KEY (website_id) REFERENCES public.f1000r_website(id);


--
-- TOC entry 7024 (class 2606 OID 159803)
-- Name: faculty_member fk_parent_faculty_member; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.faculty_member
    ADD CONSTRAINT fk_parent_faculty_member FOREIGN KEY (parent) REFERENCES public.faculty_member(id);


--
-- TOC entry 6958 (class 2606 OID 159808)
-- Name: f1000r_paypal_payment fk_paypal_payment_paypal_product; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_paypal_payment
    ADD CONSTRAINT fk_paypal_payment_paypal_product FOREIGN KEY (paypal_product_id) REFERENCES public.f1000r_paypal_product(id);


--
-- TOC entry 6960 (class 2606 OID 159813)
-- Name: f1000r_platform_user fk_platform_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_platform_user
    ADD CONSTRAINT fk_platform_user_id FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6961 (class 2606 OID 159818)
-- Name: f1000r_platform_user fk_platform_user_website; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_platform_user
    ADD CONSTRAINT fk_platform_user_website FOREIGN KEY (website_id) REFERENCES public.f1000r_website(id);


--
-- TOC entry 7002 (class 2606 OID 29711983)
-- Name: f1000r_version fk_preprint_check_options_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version
    ADD CONSTRAINT fk_preprint_check_options_id FOREIGN KEY (preprint_check_options_id) REFERENCES public.f1000r_preprint_check_options(id);


--
-- TOC entry 6881 (class 2606 OID 159823)
-- Name: f1000r_author_version_draft fk_previous_author_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version_draft
    ADD CONSTRAINT fk_previous_author_version_id FOREIGN KEY (previous_author_version_id) REFERENCES public.f1000r_author_version(id);


--
-- TOC entry 6807 (class 2606 OID 159828)
-- Name: f1000r_article fk_product_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article
    ADD CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES public.f1000r_paypal_product(id);


--
-- TOC entry 6808 (class 2606 OID 159833)
-- Name: f1000r_article fk_promotional_code_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article
    ADD CONSTRAINT fk_promotional_code_id FOREIGN KEY (promotional_code_id) REFERENCES public.f1000r_promotional_code(id);


--
-- TOC entry 6967 (class 2606 OID 159838)
-- Name: f1000r_promotional_code_pricing_categories fk_promotional_code_pricing_types_promotional_code; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_promotional_code_pricing_categories
    ADD CONSTRAINT fk_promotional_code_pricing_types_promotional_code FOREIGN KEY (promotional_code_id) REFERENCES public.f1000r_promotional_code(id);


--
-- TOC entry 7049 (class 2606 OID 6763411)
-- Name: f1000r_prescreening_feedback fk_ps_feedback_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_prescreening_feedback
    ADD CONSTRAINT fk_ps_feedback_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7050 (class 2606 OID 6763416)
-- Name: f1000r_prescreening_feedback fk_ps_usr; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_prescreening_feedback
    ADD CONSTRAINT fk_ps_usr FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6913 (class 2606 OID 159843)
-- Name: f1000r_comment_report fk_rcomment_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_comment_report
    ADD CONSTRAINT fk_rcomment_id FOREIGN KEY (comment_id) REFERENCES public.f1000r_comment(id);


--
-- TOC entry 6982 (class 2606 OID 159848)
-- Name: f1000r_referee_user_feedback fk_ref_feedback_id_potential; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_user_feedback
    ADD CONSTRAINT fk_ref_feedback_id_potential FOREIGN KEY (ref_id) REFERENCES public.f1000r_referee_suggestion_potential_ref(id) ON DELETE CASCADE;


--
-- TOC entry 6983 (class 2606 OID 159853)
-- Name: f1000r_referee_user_feedback fk_ref_feedback_id_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_user_feedback
    ADD CONSTRAINT fk_ref_feedback_id_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6980 (class 2606 OID 159858)
-- Name: f1000r_referee_supplementary_file fk_ref_sup_file_sup_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_supplementary_file
    ADD CONSTRAINT fk_ref_sup_file_sup_file FOREIGN KEY (supplementary_file_id) REFERENCES public.f1000r_supplementary_file(id);


--
-- TOC entry 6981 (class 2606 OID 159863)
-- Name: f1000r_referee_supplementary_file fk_ref_sup_file_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_supplementary_file
    ADD CONSTRAINT fk_ref_sup_file_version FOREIGN KEY (report_id) REFERENCES public.f1000r_report(id);


--
-- TOC entry 6969 (class 2606 OID 159868)
-- Name: f1000r_referee fk_referee_affiliation; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee
    ADD CONSTRAINT fk_referee_affiliation FOREIGN KEY (affiliation_id) REFERENCES public.f1000r_affiliation(id);


--
-- TOC entry 6971 (class 2606 OID 159873)
-- Name: f1000r_referee_draft fk_referee_draft_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_draft
    ADD CONSTRAINT fk_referee_draft_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6972 (class 2606 OID 159878)
-- Name: f1000r_referee_draft fk_referee_draft_report_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_draft
    ADD CONSTRAINT fk_referee_draft_report_id FOREIGN KEY (report_id) REFERENCES public.f1000r_report(id);


--
-- TOC entry 6975 (class 2606 OID 159883)
-- Name: f1000r_referee_report fk_referee_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_report
    ADD CONSTRAINT fk_referee_id FOREIGN KEY (referee_id) REFERENCES public.f1000r_referee(id);


--
-- TOC entry 6828 (class 2606 OID 159888)
-- Name: f1000r_article_referee fk_referee_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee
    ADD CONSTRAINT fk_referee_id FOREIGN KEY (referee_id) REFERENCES public.f1000r_referee(id);


--
-- TOC entry 6973 (class 2606 OID 159893)
-- Name: f1000r_referee_email fk_referee_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_email
    ADD CONSTRAINT fk_referee_id FOREIGN KEY (referee_id) REFERENCES public.f1000r_referee(id);


--
-- TOC entry 6945 (class 2606 OID 159898)
-- Name: f1000r_featured_report fk_referee_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_featured_report
    ADD CONSTRAINT fk_referee_id FOREIGN KEY (referee_id) REFERENCES public.f1000r_referee(id);


--
-- TOC entry 6977 (class 2606 OID 159903)
-- Name: f1000r_referee_suggestion_potential_ref fk_referee_referee_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion_potential_ref
    ADD CONSTRAINT fk_referee_referee_user FOREIGN KEY (referee_id) REFERENCES public.f1000r_referee(id);


--
-- TOC entry 6974 (class 2606 OID 159908)
-- Name: f1000r_referee_related_article fk_referee_related_article_article_referee_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_related_article
    ADD CONSTRAINT fk_referee_related_article_article_referee_id FOREIGN KEY (article_referee_id) REFERENCES public.f1000r_article_referee(id);


--
-- TOC entry 6962 (class 2606 OID 159913)
-- Name: f1000r_potential_referee_affiliations fk_referee_suggestion_potential_affiliation; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_potential_referee_affiliations
    ADD CONSTRAINT fk_referee_suggestion_potential_affiliation FOREIGN KEY (pot_ref_id) REFERENCES public.f1000r_referee_suggestion_potential_ref(id) ON DELETE CASCADE;


--
-- TOC entry 6963 (class 2606 OID 159918)
-- Name: f1000r_potential_referee_refs fk_referee_suggestion_potential_affiliation; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_potential_referee_refs
    ADD CONSTRAINT fk_referee_suggestion_potential_affiliation FOREIGN KEY (pot_ref_id) REFERENCES public.f1000r_referee_suggestion_potential_ref(id) ON DELETE CASCADE;


--
-- TOC entry 6979 (class 2606 OID 159923)
-- Name: f1000r_referee_suggestion_related_articles fk_referee_suggestion_potential_article; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion_related_articles
    ADD CONSTRAINT fk_referee_suggestion_potential_article FOREIGN KEY (pot_ref_id) REFERENCES public.f1000r_referee_suggestion_potential_ref(id) ON DELETE CASCADE;


--
-- TOC entry 6978 (class 2606 OID 159928)
-- Name: f1000r_referee_suggestion_potential_ref fk_referee_suggestion_potential_ref; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_suggestion_potential_ref
    ADD CONSTRAINT fk_referee_suggestion_potential_ref FOREIGN KEY (referee_suggestion_id) REFERENCES public.f1000r_referee_suggestion(id) ON DELETE CASCADE;


--
-- TOC entry 6970 (class 2606 OID 159933)
-- Name: f1000r_referee fk_referee_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee
    ADD CONSTRAINT fk_referee_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7029 (class 2606 OID 159938)
-- Name: related_research_topic fk_related_research_topic_dummy_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.related_research_topic
    ADD CONSTRAINT fk_related_research_topic_dummy_topic_id FOREIGN KEY (dummy_topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 7030 (class 2606 OID 159943)
-- Name: related_research_topic fk_related_research_topic_related_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.related_research_topic
    ADD CONSTRAINT fk_related_research_topic_related_topic_id FOREIGN KEY (related_topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6987 (class 2606 OID 159948)
-- Name: f1000r_report_history fk_report_history_report_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report_history
    ADD CONSTRAINT fk_report_history_report_id FOREIGN KEY (report_id) REFERENCES public.f1000r_report(id) ON DELETE CASCADE;


--
-- TOC entry 6988 (class 2606 OID 159953)
-- Name: f1000r_report_history fk_report_history_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report_history
    ADD CONSTRAINT fk_report_history_user_id FOREIGN KEY (usr_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6976 (class 2606 OID 159958)
-- Name: f1000r_referee_report fk_report_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_referee_report
    ADD CONSTRAINT fk_report_id FOREIGN KEY (report_id) REFERENCES public.f1000r_report(id);


--
-- TOC entry 6986 (class 2606 OID 159963)
-- Name: f1000r_report fk_report_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_report
    ADD CONSTRAINT fk_report_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7031 (class 2606 OID 159968)
-- Name: research_member fk_research_member_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_member
    ADD CONSTRAINT fk_research_member_id FOREIGN KEY (id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7032 (class 2606 OID 159973)
-- Name: research_member fk_research_member_subtopic; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_member
    ADD CONSTRAINT fk_research_member_subtopic FOREIGN KEY (subtopic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6902 (class 2606 OID 159978)
-- Name: f1000r_collection_research_topic fk_research_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_research_topic
    ADD CONSTRAINT fk_research_topic_id FOREIGN KEY (research_topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 7035 (class 2606 OID 159983)
-- Name: research_topic fk_research_topic_parent; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_topic
    ADD CONSTRAINT fk_research_topic_parent FOREIGN KEY (parent_id) REFERENCES public.research_topic(id);


--
-- TOC entry 7036 (class 2606 OID 159988)
-- Name: research_topic_section_special_mapping fk_research_topic_section_special_mapping_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_topic_section_special_mapping
    ADD CONSTRAINT fk_research_topic_section_special_mapping_topic_id FOREIGN KEY (topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 7033 (class 2606 OID 159993)
-- Name: research_member_topic fk_rmt_research_member_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_member_topic
    ADD CONSTRAINT fk_rmt_research_member_id FOREIGN KEY (research_member_id) REFERENCES public.research_member(id);


--
-- TOC entry 7034 (class 2606 OID 159998)
-- Name: research_member_topic fk_rmt_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.research_member_topic
    ADD CONSTRAINT fk_rmt_topic_id FOREIGN KEY (topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6985 (class 2606 OID 160003)
-- Name: f1000r_related_article fk_second_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_related_article
    ADD CONSTRAINT fk_second_article_id FOREIGN KEY (second_article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 6903 (class 2606 OID 160008)
-- Name: f1000r_collection_sponsor fk_sponsor_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_collection_sponsor
    ADD CONSTRAINT fk_sponsor_collection_id FOREIGN KEY (collection_id) REFERENCES public.f1000r_collection(id);


--
-- TOC entry 6991 (class 2606 OID 160013)
-- Name: f1000r_subtoken fk_subtoken_article_payment; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_subtoken
    ADD CONSTRAINT fk_subtoken_article_payment FOREIGN KEY (article_payment_id) REFERENCES public.f1000r_article_payment(id);


--
-- TOC entry 6992 (class 2606 OID 160018)
-- Name: f1000r_subtoken fk_subtoken_created_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_subtoken
    ADD CONSTRAINT fk_subtoken_created_user_id FOREIGN KEY (created_user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7039 (class 2606 OID 160023)
-- Name: term_relationship fk_term_child; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.term_relationship
    ADD CONSTRAINT fk_term_child FOREIGN KEY (child_id) REFERENCES public.term(id);


--
-- TOC entry 7040 (class 2606 OID 160028)
-- Name: term_relationship fk_term_parent; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.term_relationship
    ADD CONSTRAINT fk_term_parent FOREIGN KEY (parent_id) REFERENCES public.term(id);


--
-- TOC entry 7041 (class 2606 OID 160033)
-- Name: thesaurus_synonym fk_thesaurus_synonym_term_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thesaurus_synonym
    ADD CONSTRAINT fk_thesaurus_synonym_term_id FOREIGN KEY (term_id) REFERENCES public.thesaurus_term(id);


--
-- TOC entry 7042 (class 2606 OID 160038)
-- Name: thesaurus_term_parent fk_thesaurus_term_parent_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thesaurus_term_parent
    ADD CONSTRAINT fk_thesaurus_term_parent_parent_id FOREIGN KEY (parent_id) REFERENCES public.thesaurus_term(id);


--
-- TOC entry 7043 (class 2606 OID 160043)
-- Name: thesaurus_term_parent fk_thesaurus_term_parent_term_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.thesaurus_term_parent
    ADD CONSTRAINT fk_thesaurus_term_parent_term_id FOREIGN KEY (term_id) REFERENCES public.thesaurus_term(id);


--
-- TOC entry 6993 (class 2606 OID 160048)
-- Name: f1000r_subtoken fk_token_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_subtoken
    ADD CONSTRAINT fk_token_parent_id FOREIGN KEY (parent_id) REFERENCES public.f1000r_token(id);


--
-- TOC entry 7013 (class 2606 OID 160053)
-- Name: f1000r_version_subtopic fk_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_subtopic
    ADD CONSTRAINT fk_topic_id FOREIGN KEY (topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6999 (class 2606 OID 160058)
-- Name: f1000r_user_topic fk_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_topic
    ADD CONSTRAINT fk_topic_id FOREIGN KEY (topic_id) REFERENCES public.research_topic(id);


--
-- TOC entry 6995 (class 2606 OID 160068)
-- Name: f1000r_upload_info fk_upload_info_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_upload_info
    ADD CONSTRAINT fk_upload_info_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6996 (class 2606 OID 160073)
-- Name: f1000r_usage_stats fk_usage_stats_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_usage_stats
    ADD CONSTRAINT fk_usage_stats_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 7000 (class 2606 OID 160078)
-- Name: f1000r_user_topic fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_user_topic
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6990 (class 2606 OID 160083)
-- Name: f1000r_stored_search fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_stored_search
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 6832 (class 2606 OID 160088)
-- Name: f1000r_article_referee_status_tracker fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_article_referee_status_tracker
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7047 (class 2606 OID 160093)
-- Name: usi fk_usi_updater; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.usi
    ADD CONSTRAINT fk_usi_updater FOREIGN KEY (priority_notes_last_updater) REFERENCES public.usr(usr_id);


--
-- TOC entry 7003 (class 2606 OID 160098)
-- Name: f1000r_version fk_version_article_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version
    ADD CONSTRAINT fk_version_article_id FOREIGN KEY (article_id) REFERENCES public.f1000r_article(id);


--
-- TOC entry 7006 (class 2606 OID 160103)
-- Name: f1000r_version_article_dataset fk_version_dataset_dataset; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_article_dataset
    ADD CONSTRAINT fk_version_dataset_dataset FOREIGN KEY (article_dataset_id) REFERENCES public.f1000r_article_dataset(id) ON DELETE CASCADE;


--
-- TOC entry 7007 (class 2606 OID 160108)
-- Name: f1000r_version_article_dataset fk_version_dataset_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_article_dataset
    ADD CONSTRAINT fk_version_dataset_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7004 (class 2606 OID 160113)
-- Name: f1000r_version fk_version_editor_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version
    ADD CONSTRAINT fk_version_editor_id FOREIGN KEY (editor_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7011 (class 2606 OID 160118)
-- Name: f1000r_version_editor fk_version_editor_user; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_editor
    ADD CONSTRAINT fk_version_editor_user FOREIGN KEY (user_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7012 (class 2606 OID 160123)
-- Name: f1000r_version_editor fk_version_editor_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_editor
    ADD CONSTRAINT fk_version_editor_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6872 (class 2606 OID 160128)
-- Name: f1000r_author_version fk_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_author_version
    ADD CONSTRAINT fk_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6922 (class 2606 OID 160133)
-- Name: f1000r_corresponding_author_version fk_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_corresponding_author_version
    ADD CONSTRAINT fk_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7014 (class 2606 OID 160138)
-- Name: f1000r_version_subtopic fk_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_subtopic
    ADD CONSTRAINT fk_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6994 (class 2606 OID 160143)
-- Name: f1000r_table_doi_status fk_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_table_doi_status
    ADD CONSTRAINT fk_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7005 (class 2606 OID 160148)
-- Name: f1000r_version fk_version_submitter_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version
    ADD CONSTRAINT fk_version_submitter_id FOREIGN KEY (submitter_id) REFERENCES public.f1000r_submitter(id);


--
-- TOC entry 7015 (class 2606 OID 160153)
-- Name: f1000r_version_supplementary_file fk_version_sup_file_sup_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_supplementary_file
    ADD CONSTRAINT fk_version_sup_file_sup_file FOREIGN KEY (supplementary_file_id) REFERENCES public.f1000r_supplementary_file(id);


--
-- TOC entry 7016 (class 2606 OID 160158)
-- Name: f1000r_version_supplementary_file fk_version_sup_file_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_supplementary_file
    ADD CONSTRAINT fk_version_sup_file_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7017 (class 2606 OID 160163)
-- Name: f1000r_version_visualized_file fk_version_visualized_file_version; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_visualized_file
    ADD CONSTRAINT fk_version_visualized_file_version FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 7018 (class 2606 OID 160168)
-- Name: f1000r_version_visualized_file fk_version_visualized_file_visualized_file; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_visualized_file
    ADD CONSTRAINT fk_version_visualized_file_visualized_file FOREIGN KEY (visualized_file_id) REFERENCES public.f1000r_visualized_file(id);


--
-- TOC entry 7010 (class 2606 OID 160173)
-- Name: f1000r_version_classification fk_versionclassi_jt_version_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_version_classification
    ADD CONSTRAINT fk_versionclassi_jt_version_id FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


--
-- TOC entry 6941 (class 2606 OID 160178)
-- Name: f1000r_external_item fk_website_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_external_item
    ADD CONSTRAINT fk_website_id FOREIGN KEY (website_id) REFERENCES public.f1000r_website(id);


--
-- TOC entry 7020 (class 2606 OID 160183)
-- Name: f1000r_wellcome_grant_pi_email fk_wellcome_grant_pi_email_tracking_id; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.f1000r_wellcome_grant_pi_email
    ADD CONSTRAINT fk_wellcome_grant_pi_email_tracking_id FOREIGN KEY (email_tracking_id) REFERENCES public.f1000r_email_tracking(id);


--
-- TOC entry 6796 (class 2606 OID 160188)
-- Name: article fka5d2b4554bf4afbv; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT fka5d2b4554bf4afbv FOREIGN KEY (bibleinstitution_id) REFERENCES public.bible_institution(id);


--
-- TOC entry 7027 (class 2606 OID 160193)
-- Name: ins fka5d2b4554cd23fav; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.ins
    ADD CONSTRAINT fka5d2b4554cd23fav FOREIGN KEY (bibleinstitution_id) REFERENCES public.bible_institution(id);


--
-- TOC entry 7048 (class 2606 OID 160198)
-- Name: usi fka5d2b4554cd32dbc; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.usi
    ADD CONSTRAINT fka5d2b4554cd32dbc FOREIGN KEY (bibleinstitution_id) REFERENCES public.bible_institution(id);


--
-- TOC entry 6799 (class 2606 OID 160208)
-- Name: bible_institution fka5d2b45a50db8fc8; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.bible_institution
    ADD CONSTRAINT fka5d2b45a50db8fc8 FOREIGN KEY (parent_id) REFERENCES public.bible_institution(id);


--
-- TOC entry 7046 (class 2606 OID 160213)
-- Name: user_video user_video_usr_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.user_video
    ADD CONSTRAINT user_video_usr_id_fk FOREIGN KEY (usr_id) REFERENCES public.usr(usr_id);


--
-- TOC entry 7051 (class 2606 OID 13534123)
-- Name: version_affiliation_position version_affiliation_fk; Type: FK CONSTRAINT; Schema: public; Owner: f1000
--

ALTER TABLE ONLY public.version_affiliation_position
    ADD CONSTRAINT version_affiliation_fk FOREIGN KEY (version_id) REFERENCES public.f1000r_version(id);


