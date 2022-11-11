Alias: PLANNETOrganization = http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Organization
Alias: Qualification = http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/qualification


Profile: HSDSOrganization
Parent: PLANNETOrganization
Id: hsds-Organization
Title:    "HSDSOrganization"
Description: "The HSDSOrganization resource is a formal or informal grouping of people or organizations set up to assist people in coping with issues related to various social issues, including but not limited to: adequate housing, substance abuse, domestic conflict, mental health and/or personal/familial problems.
Guidance:   When the contact is a department name, rather than a human (e.g., patient help line), include a blank family and given name, and provide the department name in contact.name.text."

// * extension[qualification].extension:code.uri = "code"
// * extension[qualification].extension:code.value[x]= service.accreditations

Mapping: HSDSOrganizationToHSDS
Source: HSDSOrganization
Target:   "HSDS"
Id:       hsds
Title:    "HSDS"
Description: "This section describes the way HSDS version 2.0.1 elements are mapped from HSDS tables to the FHIR Organization profile. The left hand column represents the FHIR Organization element name, the right column contains the HSDS table.element followed by its description within parenthesis. Comments related to the mapping may follow the HSDS element description."
* id  -> "organization.id	(Each organization must have a unique identifier.)"
* meta  -> "metadata	(The HSDS metadata table contains a record of the changes that have been made to the data in order to maintain provenance information.)"
* meta.lastUpdated  -> "metadata.last_action_date (The date when data was changed.) Since there may be more than one metadata record for each organization, we need use max(last_action_date) from metadata where (FHIR) Organization.id = (HSDS) metadata.resource_id."
* extension[qualification]  -> "Service level accreditations need to be aggregated at the Organization level. The Plan-Net extension (http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/qualification) requires a minimum of two  of the three parameters: identifier, code, issuer, status, period, whereValid. HSDS does not have that source content (except that whereValid could be derived from an address associated with this location. But that will not always be accurate). This Plan-Net extension is optional, so this is documented as GAP in HSDS and will have to be resolved by maintaining a separate 'accreditation' entity with required details. Licenses could also be included in that new HSDS entity. Current thought is to default the value associated with extension[qualification]:code.url = 'code' and map extension[qualification]:code.value[x] =  service.accreditations	(Details of any accreditations. Accreditation is the formal evaluation of an organization or program against best practice standards set by an accrediting organization.)"
* extension[org-description]  -> "organization.description (A brief summary about the organization.) It can contain markup such as HTML or Markdown.  This extension is not needed but is a question to pose to PA WG and the Plan-net IG. HSDS organization.description can be mapped to this extension but will also be mapped to Location.text."
// * Slices for identifier  -> "The closest to a business identifier for an Organization in HSDS is considered the organization.tax id (A government issued identifier used for the purpose of tax administration). For the purpose of this IG, tax_id is the business identifier and the official use for for Organization. HSDS organization.tax_status (Government assigned tax designation for tax-exempt organizations.)"
* identifier.id  -> "This FHIR element is the business identifier for the organization. This element is optional and can be omitted from the mapping."
* identifier.use  -> "FHIR Organization.identifier.use allows an appropriate identifier for a particular context of use to be selected from a set of business identifiers associated with an organization. Because the closest business identifier in HSDS is organization.tax id (A government issued identifier used for the purpose of tax administration). For the purpose of this IG, tax_id is considered the business identifier for Organization and the official use for the organization's business identifier. This element will be populated with a default value 'official' drawn from the code system IdentifierUse http://hl7.org/fhir/identifier-use"
* identifier.type -> "This FHIR element represents a code used to specify the specific purpose for an identifier. For this IG, because the closest business identifier is organization.tax id in HSDS (Organization.identifier), the value for this element will default to ‘TAX’ drawn from the IdentifierType code system – http://terminology.hl7.org/CodeSystem/v2-0203 [an HL7-defined code system of concepts specifying type of identifier]."
* identifier.system -> "GAP in HSDS, unless HSDS organization.tax_status (Government assigned tax designation for tax-exempt organizations) contains the appropriate data to map to this FHIR element that establishes the namespace for identifier.value, a URL that describes a value that is unique.  This system is not needed as the only business identifier associated with an Organization is the tax ID. The namespace I've found for the U.S. IRS is urn:us:gov:irs:, however unsure whether there is a common namespace in the U.S defined for tax id."
* identifier.value  -> "organization.tax_id (A government issued identifier used for the purpose of tax administration.) During the original review with OpenReferral, Greg Bloom indicates tax id is as close to a business identifier that Community-Based Organizations have at this time."
* identifier.period  -> "organization.year_incorporated (The year in which the organization was legally formed.)  HSDS organization.year_incorporated may not be the same as when the TAX ID was issued (especially if company merged or split). Leave mapped to organization.year_incororated for now. Technically this is a GAP in FHIR and should be added as an extension, then potentially recommend addition to FHIR Organization Resource (as Organizations should have start and end date)."
* identifier.assigner -> "GAP in HSDS. The assigner for TAX id could be corresponding government entity (will depend on the country of the organization in HSDS). HSDS does not have that data in its source and given that it is not required in the Plan-net profile, this element is optional." 
* active  -> "This is a GAP in the HSDS but is a required element in FHIR. In HSDS,  services are associated with a status (service.status defined as The current status of the service.) The service table status element contains information other than active, inactive which must be resolved. For the purpose of this Implementation Guide, FHIR Organization.active will default to true."
* type -> "GAP in HSDS. This is a required FHIR CodeableConcept element where codes SHALL be taken from the extensible value set Organization Type http://hl7.org/fhir/us/davinci-pdex-plan-net/ValueSet/OrgTypeVS. The code atyprv used for Providers that do not provide healthcare, and this field will default to 'atyprv'." 
* name  -> "organization.name	(The official or public name of the organization.)"
* alias  -> "organization.alternate_name	(Alternative or commonly used name for the organization.) Since alias is an array (list) in FHIR, this is mapped to the first position of the list."
* telecom.extension[contactpoint-availabletime]  -> "There is no equivalent mapping to Organization.telecom.extension:contactpoint-availabletime from HSDS since the HSDS schedule table contains details of when a service or location is open, and is not (directly) associated with an Organization. Impementation Comment: HSDS Schedule table can be mapped to HealthcareService.availableTime. This is not a required element in the parent Plan-net profile, so should be dropped from the profile."
* telecom.extension[via-intermediary]  -> "In FHIR this represents a reference to an alternative point of contact. HSDS does not have the source data to represent 'intermediary' as that implies some sort of organizational relationship. HSDS contact table data are more appropriately mapped to the PractitionerRole resource. Since HSDS does not have that source data and because this extension is optional in the Plan-net profile, it can be ignored."
* telecom.system -> "phone.type (Indicates the type of phone service, drawing from the RFC6350 list of types (text (for SMS), voice, fax, cell, video, pager, textphone). This FHIR element bound to the ContactPointSystem value set, http://hl7.org/fhir/R4/valueset-contact-point-system.html  phone | fax | email | pager | url | sms | other. Constrain the default values of system = 'phone' or 'email' or 'url' which requires a new value set"  
* telecom.value  -> "For Phone: phone.number (The phone number.) where phone.type = voice and phone.organization_id (The identifier of the organization for which this is the phone number.) = organization.id (use latest if multiple). For Email: organization.email. For URL: organization.url"
* telecom.use -> "GAP in HSDS. May be considered as GAP in HSDS but best to default this to 'work' drawn from the ContactPointUse value set http://hl7.org/fhir/R4/valueset-contact-point-use.html"
* telecom.rank -> "GAP in HSDS. In FHIR, used to specify a preferred order in which to use a set of contacts. ContactPoints with lower rank values are more preferred than those with higher rank values. The parent Plan-net profile indicates this is a Must Support element but is optional, so it can be omitted from the profile."
* telecom.period -> "GAP in HSDS. In FHIR, captures the time period when the contact point was/is in use. This is not a required element in the profile so it can be dropped. Most source  systems will not have date ranges for telecom."
* address  -> "In HSDS v.2.0, the Location table is used to capture address details associated with locations that are part of that organization. Two HSDS tables are used, one for postal_address, the other for physical_address. In a future HSDS update, these tables will be collapsed, assumably along with a new type field to distinguish the type of address, but the following elements reflect mapping to both tables."
* address.id  -> "physical_address.id, postal_address.id (Each postal/physical address must have a unique identifier) associated with the location.id where FHIR Organization.id is equal to HSDS location.organization_id. e.g. Reference(Location). Implementer comments: It may be possible to populate the FHIR profile.id from physical_address and postal_address but it's generally better avoid exposing internal ids (just resource level ids may be exception just to link back to the source system)."
* address.extension[geolocation] -> "Mapped to Location.latitude (coordinate of location expressed in decimal degrees in WGS84 datum) and Location.longitute (X coordinate of location expressed in decimal degrees in WGS84 datum) associated with the location.id where FHIR organization.id is equal to HSDS location.organization_id. Reference(Location)"
* address.use  -> "GAP in HSDS. This FHIR element describes the purpose for this address, and allows an appropriate address to be chosen from a list of many. Implementer comment: It is best to default this to 'work' drawn from the AddressUse value set http://hl7.org/fhir/R4/valueset-address-use.html"
* address.type -> "GAP in HSDS. Once HSDS is updated to collapse the separate tables used for postal versus physical address, a new HSDS address_type element will map to this FHIR element that distinguishes between physical addresses (those you can visit) and mailing addresses (e.g. PO Boxes and care-of addresses). Reference(Location)"
* address.text -> "Concatentation of the appropriate HSDS address elements (all or some of the following - HSDS postal/physical address_1, city, region, state_province, postal_code, country) depending on whether the displayed address should be the postal versus physical address. In FHIR, this element specifies the entire address as it should be displayed e.g. on a postal label. This may be provided instead of or as well as the specific parts."
* address.line  -> "physical_address.address_1, postal_address.address_1 (The first line(s) of the address, including office, building number and street.) Reference(Location)"
* address.city  -> "physical_address.city, postal_address.city (The city in which the address is located.) Reference(Location)"
* address.district  -> "postal_address.location_region, physical_address.location_region (The region in which the address is located (optional).) Reference(Location)"
* address.state  -> "physical_address.state_province,postal_address.state_province (The state in which the address is located.) Reference(Location)"
* address.postalCode  -> "postal_address.postal_code, physical_address.postal_code (The postal code for the address.) Reference(Location)"
* address.country  -> "postal_address.country, physical_address.country (The country in which the address is located. This should be given as an ISO 3361-1 country code (two letter abbreviation).)	Reference(Location)"
* address.period  -> "GAP in HSDS. This FHIR element represents the time period when the address was in use for the organization."
* partOf  -> "GAP	There is no concept of organization affiliation in HSDS unless the program table is intended for a similar usage."
* contact  -> "contact Table The HSDS contact table contains details of the named contacts for services and organizations. Need to map at minimum the HSDS phone.number where HSDS phone.organization_ID = Organization.id" 
* contact.extension  -> "contact.department (The department that the person is part of.) within the context of Reference(Organization). Proposed publishing a new StructureDefinition for this extension, e.g., http://hl7.org/fhir/us/FHIR-IG-Human-Services-Directory/StructureDefinition/contact-department"
* contact.purpose  -> "GAP In HSDS. In FHIR, this element is used to indicate the purpose of which the contact can be reached. Codes are to be drawn from the extensible ContactEntityType value set http://hl7.org/fhir/ValueSet/contactentity-type, and new codes could be added if none in this value set are applicable. At the same time, this is an optional element in FHIR so could be ignored."
* contact.name  -> "contact.name (The name of the person.)	Reference(Organization)"
* contact.telecom -> "This structure is used to associate contact detail information (telephone number, email address) by which the party can be contacted.  Uses the FHIR ContactPoint data type, http://hl7.org/fhir/R4/datatypes.html#ContactPoint"
* contact.telecom.extension[contactpoint-availabletime] -> "GAP in HSDS. A FHIR extension representing the days and times a contact point is avaialble. HSDS schedule table data can be mapped to HealthcareService.availableTime (as well as could be mapped to FHIR Schedule resources). It isn't appropriate to populate HSDS service_at_location level data (service + location level) to the Organization contact level telecom extension. This extension is not required in the base Plan-net profile, so it can be ignored."
* contact.telecom.extension[via-intermediary] -> "HSDS lacks the source data to represent 'via-intermediary' as that would imply some sort of organizational relationship. HSDS contacts are more appropriately mapped to the PractitionerRole resource. This is not a required extension in Plan-Net, so this can be ignored."
* contact.telecom.system -> "Set the default value of system = 'phone' or 'email' drawn from value set http://hl7.org/fhir/R4/valueset-contact-point-system.html (required binding)"
* contact.telecom.value  -> "The phone number to be used for a contact and not the organization. For Phone: Phone.phone_number where type = 'voice' and phone.contact_id = contact.id (use latest if multiple); For Email: map HSDS contact.email"
* contact.telecom.use  -> "GAP In HSDS. identifies the purpose for the contact point. Default to 'work' drawn from the ContactPointUse value set http://hl7.org/fhir/ValueSet/contact-point-use (required binding)"
* contact.telecom.rank -> "GAP in HSDS. This is a Must Support though optional element so can be ignored."
* contact.telecom.period -> "GAP in HSDS. In FHIR, specifies a preferred order in which to use a set of contacts. This is not a required or Must Support element in the Plan-Net profile, so it can be ignored. Most source  systems will not have date ranges for telecom."
* contact.address -> "GAP in HSDs. May need to keep track of a contact party's address for contacting, billing or reporting requirements."
* endpoint -> "Technical endpoints providing access to services operated for the organization. This is for technical implementation of web services for the organiation and it is not for source specific business data. It is marked as Must Support though optional in the Plan-Net profile. At this point no specific organization specific web services identified so it may be ignored."

