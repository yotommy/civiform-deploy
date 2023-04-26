#! /usr/bin/env bash

# CiviForm deployment configuration file.
#
# Copy this file to civiform_config.sh in the same directory and edit the copy.
#
# cp civiform_config.example.sh civiform_config.sh
#
# Configuration variables must be specified in SCREAMING_SNAKE_CASE with the
# "export" keyword preceding them. If the value contains whitespace it must be
# surrounded by quotes. There should be no spaces before or after the equals sign.

#################################################
# Global variables for all CiviForm deployments
#################################################

# REQUIRED
# One of prod, staging, or dev.
export CIVIFORM_MODE="staging"

# REQUIRED
# CiviForm server version to deploy.
#
# For dev and staging civiform modes, can be "latest". For prod, must be a version from
# https://github.com/civiform/civiform/releases, for example "v1.2.3".
export CIVIFORM_VERSION="latest"

# REQUIRED
# Version of the infrastructure to use.
# Needs to be either:
# - Label from https://hub.docker.com/r/civiform/civiform-cloud-deployment if USE_DOCKER=true
# - Commit sha from https://github.com/civiform/cloud-deploy-infra if USE_DOCKER=false
# - "latest" to use latest version of either docker image or code from the repo, 
#    depending on USE_DOCKER flag.
#
# Using "latest" is recommended.
export CIVIFORM_CLOUD_DEPLOYMENT_VERSION="latest"

# Terraform configuration
#################################################

# REQUIRED
# A supported CiviForm cloud provider, lower case.
# "aws" or "azure"
export CIVIFORM_CLOUD_PROVIDER="aws"


# REQUIRED
# The template directory for this deployment.
# For aws, use "cloud/aws/templates/aws_oidc"
# For azure, use "cloud/azure/templates/azure_saml_ses"
export TERRAFORM_TEMPLATE_DIR="cloud/aws/templates/aws_oidc"

# REQUIRED
# The docker repository name for retrieving server images.
export DOCKER_REPOSITORY_NAME="civiform"

# REQUIRED
# The docker user name for retrieving server images.
export DOCKER_USERNAME="civiform"

# REQUIRED
# The authentication protocal used for applicant and trusted intermediary accounts.
# Supported values: "oidc", "saml"
export CIVIFORM_APPLICANT_AUTH_PROTOCOL="oidc"



# Deployment-specific Civiform configuration
#################################################

# REQUIRED
# The short name for the civic entity. Ex. "Rochester"
export CIVIC_ENTITY_SHORT_NAME="Seattle"

# REQUIRED
# The full name for the civic entity. Ex. "City of Rochester"
export CIVIC_ENTITY_FULL_NAME="City of Seattle"

# REQUIRED
# The email address to contact for support with using Civiform. Ex. "Civiform@CityOfRochester.gov
export CIVIC_ENTITY_SUPPORT_EMAIL_ADDRESS="civiform.staging@seattle.gov"

# REQUIRED
# A link to an image of the civic entity logo that includes the entity name, to be used in the header for the "Get Benefits" page
export CIVIC_ENTITY_LOGO_WITH_NAME_URL="https://raw.githubusercontent.com/seattle-civiform/civiform-deploy-tf/main/logos/civiform-long-logo.png"

# REQUIRED
# A link to an image of the civic entity logo, to be used on the login page
export CIVIC_ENTITY_SMALL_LOGO_URL="https://raw.githubusercontent.com/seattle-civiform/civiform-deploy-tf/main/logos/civiform-small-logo.png"

# OPTIONAL
# A link to an 16x16 of 32x32 pixel favicon of the civic entity,
# in format .ico, .png, or .gif.
export FAVICON_URL="https://seattle.gov/favicon.ico"

# REQUIRED
# The email address to use for the "from" field in emails sent from CiviForm.
export SENDER_EMAIL_ADDRESS="civiform.staging@seattle.gov"

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the program administrator's email, as would happen in prod.
export STAGING_PROGRAM_ADMIN_NOTIFICATION_MAILING_LIST="civiform.staging@seattle.gov"

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the trusted intermediary's email, as would happen in prod.
export STAGING_TI_NOTIFICATION_MAILING_LIST="civiform.staging@seattle.gov"

# REQUIRED
# The email address that receives a notifications email each time an applicant
# submits an application to a program in the staging environments, instead of
# sending it to the applicant's email, as would happen in prod.
export STAGING_APPLICANT_NOTIFICATION_MAILING_LIST="civiform.staging@seattle.gov"

# REQUIRED
# The domain name for this CiviForm deployment, including the protocol. 
# E.g. "https://civiform.seattle.gov"
export BASE_URL="https://civiformtest.seattle.gov"

# OPTIONAL
# When set enables demo mode for the civiform application. Should be set for
# staging but not prod. The value is hostname without protocol and should correspond
# BASE_URl. Example: "civiform.seattle.gov"
export STAGING_HOSTNAME="civiformtest.seattle.gov"

# OPTIONAL
# The time zone to be used when rendering any times within the CiviForm
# UI. A list of valid time zone identifiers can be found at:
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
export CIVIFORM_TIME_ZONE_ID="America/Los_Angeles"

# OPTIONAL
# If enabled, allows exporting Prometheus server metrics over HTTP at "/metrics"
# Defaults to false.
export CIVIFORM_SERVER_METRICS_ENABLED=true




#########################################################################
# Template variables for AWS. Skip if deploying to other cloud providers.
#########################################################################

# REQUIRED
# AWS region where civiform server and supporting infra will be deployed.
# Unofficial list of available regions: https://gist.github.com/colinvh/14e4b7fb6b66c29f79d3
export AWS_REGION="us-west-2"

# REQUIRED
# The name to prefix all resources with.
export APP_PREFIX="civiform-test-" # max 19 chars, only numbers, letters, dashes, and underscores

# REQUIRED
# ARN of the SSL certificate that will be used to handle HTTPS traffic. The certiciate
# should be created and validated before the deployment is done. Certificate can be created
# in AWS web console: https://console.aws.amazon.com/acm/home#/certificates/list
# WARNING: certificate needs to be created in the same region as AWS_REGION above, make sure
# select correct region in web AWS console when creating certificate.
export SSL_CERTIFICATE_ARN="arn:aws:acm:us-west-2:405662711265:certificate/fc9201c7-c715-4c8e-bd1f-a20ae1828e8f"

# RERUIRED
# Number of Civiform server tasks to run. This value can be set to 0 to shutdown servers.
# It can be useful, for example, when server continiously fails on startup: set this to 0
# to shutdown servers while figuring out the error.
export FARGATE_DESIRED_TASK_COUNT=2



# generic-oidc Auth configuration
#################################################

# REQUIRED
# Which auth provider to use for applicants to login.
# If set to a non-disabled value, you must configure the respective auth parameters
export CIVIFORM_APPLICANT_IDP="idcs"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc"
# The name of the OIDC provider. Must be URL-safe.
# Gets appended to the auth callback URL.
export APPLICANT_OIDC_PROVIDER_NAME="OidcClient"

# REQUIRED if CIVIFORM_APPLICANT_IDP="generic-oidc"
# The discovery metadata URI provideded by the OIDC provider.
# Usually ends in .well-known/openid-configuration
export APPLICANT_OIDC_DISCOVERY_URI="https://idcs-f582fefb879b4db5a88a370e8f2f6013.identity.oraclecloud.com/.well-known/openid-configuration"

# OPTIONAL
# The type of OIDC flow to execute, and how the data is encoded.
# See https://auth0.com/docs/authenticate/protocols/oauth#authorization-endpoint
export APPLICANT_OIDC_RESPONSE_MODE="form_post"
export APPLICANT_OIDC_RESPONSE_TYPE="id_token token"

# OPTIONAL
# Any additional claims to request, in addition to the default scopes "openid profile email"
export APPLICANT_OIDC_ADDITIONAL_SCOPES=""

# OPTIONAL
# If your OIDC provider provides the user's language preference,
# provide the profile field it's returned in.
export APPLICANT_OIDC_LOCALE_ATTRIBUTE=""

# OPTIONAL
# The name of the profile field where the user's email is stored.
# Defaults to "email"
export APPLICANT_OIDC_EMAIL_ATTRIBUTE="email"

# OPTIONAL
# The name of the profile field where the user's name is stored.
# If there is only one name field(the display name) use APPLICANT_OIDC_FIRST_NAME_ATTRIBUTE.
# If the name is split into multiple fields, use the APPLICANT_OIDC_MIDDLE_NAME_ATTRIBUTE
# and APPLICANT_OIDC_LAST_NAME_ATTRIBUTE as necessary.
export APPLICANT_OIDC_FIRST_NAME_ATTRIBUTE="name"
export APPLICANT_OIDC_MIDDLE_NAME_ATTRIBUTE=""
export APPLICANT_OIDC_LAST_NAME_ATTRIBUTE=""

# REQUIRED
export APPLICANT_REGISTER_URI="https://qalogin.seattle.gov:12443/#/registration?appName=CIVIFORM_STAGE"
export APPLICANT_OIDC_OVERRIDE_LOGOUT_URL="https://qalogin.seattle.gov:12443/#/logout?appName=CIVIFORM_STAGE"
export APPLICANT_OIDC_POST_LOGOUT_REDIRECT_PARAM=""
export APPLICANT_OIDC_PROVIDER_LOGOUT=true


# ADFS and Azure AD configuration
# More information on https://docs.civiform.us/contributor-guide/developer-guide/authentication-providers
#########################################################################################################

# REQUIRED
# The discovery metadata URI provideded by the ADFS provider.
# Usually ends in .well-known/openid-configuration
export ADFS_DISCOVERY_URI="https://sts.seattle.gov/adfs/.well-known/openid-configuration"

# OPTIONAL
# Should be set to "allatclaims" for ADFS and empty value for Azure AD.
export ADFS_ADDITIONAL_SCOPES="allatclaims"

# OPTIONAL
# Should be set to "group" for ADFS and "groups" for Azure AD.
export AD_GROUPS_ATTRIBUTE_NAME="group"

# OPTIONAL
# The ADFS group name for specifying CiviForm admins. If using Azure AD this is
# the group's object ID
export ADFS_ADMIN_GROUP="ad\ITD_CiviForm_Admins_Test"



#################################################
# Additional settings
#################################################

# API
export CIVIFORM_API_KEYS_BAN_GLOBAL_SUBNET=false

# Evolutions
export DATABASE_APPLY_DESTRUCTIVE_CHANGES=true

# Analytics
export MEASUREMENT_ID="G-HXM0Y35TGE"

# ESRI
export ESRI_ADDRESS_CORRECTION_ENABLED=true
export ESRI_FIND_ADDRESS_CANDIDATES_URL="https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_ENABLED=true
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_URLS.0="https://gisdata.seattle.gov/server/rest/services/COS/Seattle_City_Limits/MapServer/1/query"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_LABELS.0="Seattle"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_IDS.0="Seattle"
export ESRI_ADDRESS_SERVICE_AREA_VALIDATION_ATTRIBUTES.0="CITYNAME"

# Allow Feature Flags
export FEATURE_FLAG_OVERRIDES_ENABLED=true

# Feature Flags
export ALLOW_CIVIFORM_ADMIN_ACCESS_PROGRAMS=true
export CIVIFORM_APPLICATION_STATUS_TRACKING_ENABLED=true
export PREDICATES_MULTIPLE_QUESTIONS_ENABLED=true
export PROGRAM_ELIGIBILITY_CONDITIONS_ENABLED=true
export CIVIFORM_ADMIN_REPORTING_UI_ENABLED=true

# Common Intake
export COMMON_INTAKE_MORE_RESOURCES_LINK_TEXT="Affordable Seattle"
export COMMON_INTAKE_MORE_RESOURCES_LINK_HREF="https://www.affordableseattle.org"

# Email
export SES_SENDER_EMAIL="civiform.staging@seattle.gov"
export AWS_SES_SENDER="civiform.staging@seattle.gov"
