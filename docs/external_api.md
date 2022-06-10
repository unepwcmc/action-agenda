## Params

```per_page=10  # default 10```

```page=5       # default 1```

```updated_after=2022-06-03       # default nil, accepts valid datetime formats https://ruby-doc.org/stdlib-2.6.1/libdoc/date/rdoc/DateTime.html```

## Endpoint

```https://www.naturecommitments.org/api/v1/commitments?per_page=10&page=5&updated_after=2022-06-03```


## JSON structure

```json
[
  {
    "id": 11,
    "latitude": 55.37911,
    "longitude": -110.308466,
    "current_area_ha": 0,
    "committed_year": "2020",
    "implementation_year": "2021",
    "name": "The name of the commitment",
    "description": "A description of the commitment",
    "stage": "A string, either In progress/Committed/Implemented fully",
    "responsible_group": "A string describing the responsible group",
    "duration_years": "more than 25 years",
    "area_owner_and_role": "A string describing the owner and their role if the are does not belong to the group/person making the commitment",
    "created_at": Wed, 18 May 2022 14:43:33 UTC +00:00,
    "updated_at": Wed, 18 May 2022 14:43:33 UTC +00:00,
    "managers": [
      {
        "id": 2,
        "name": "Indigenous peoples"
      }
    ],
    "actions": [
      {
        "id": 4,
        "name": "Education or awareness-raising"
      }
    ],
    "countries": [
      {
        "id": 38,
        "name": "Canada",
        "iso": "CA"
      },
      {
        "id": 233,
        "name": "United States of America",
        "iso": "US"
      }
    ],
    "objectives": [
      {
        "id": 1,
        "name": "Sustainable use"
      }
    ],
    "threats": [
      {
        "id": 14,
        "name": "Invasive species"
      }
    ],
    "links": [
      {
        "id": 40,
        "url": "https://www.a-url.com"
      }
    ]
  }
]
```

## Associated records

The data below are provided for reference and are included in the API where associated with a particular commitment - the API does not provide an index of these associations

### Managers

```json
[
  {
    "id": 1,
    "name": "Local communities"
  },
  {
    "id": 2,
    "name": "Indigenous peoples"
  },
  {
    "id": 3,
    "name": "Non-profit organisation"
  },
  {
    "id": 4,
    "name": "For-profit organisation"
  },
  {
    "id": 5,
    "name": "Sub-national government"
  },
  {
    "id": 6,
    "name": "Joint governance"
  },
  {
    "id": 7,
    "name": "Individual landowners"
  },
  {
    "id": 8,
    "name": "Collaborative governance"
  },
  {
    "id": 9,
    "name": "Other"
  }
]
```

### Threats

```json
[
  {
    "id": 1,
    "name": "Residential or commercial development"
  },
  {
    "id": 2,
    "name": "Agriculture or aquaculture"
  },
  {
    "id": 3,
    "name": "Energy production or mining"
  },
  {
    "id": 4,
    "name": "Transportation or service corridors"
  },
  {
    "id": 5,
    "name": "Biological resource use"
  },
  {
    "id": 6,
    "name": "Human intrusions and disturbance"
  },
  {
    "id": 7,
    "name": "Natural system modifications"
  },
  {
    "id": 8,
    "name": "Invasive species, genetic threats, disease threats"
  },
  {
    "id": 9,
    "name": "Pollution"
  },
  {
    "id": 10,
    "name": "Geological events"
  },
  {
    "id": 11,
    "name": "Climate change or severe weather"
  },
  {
    "id": 12,
    "name": "Other"
  },
  {
    "id": 13,
    "name": "Natural systems modifications"
  },
  {
    "id": 14,
    "name": "Invasive species"
  }
]
```

### Actions

```json
[
  {
    "id": 1,
    "name": "Protection of land/water"
  },
  {
    "id": 2,
    "name": "Management of land/water"
  },
  {
    "id": 3,
    "name": "Species management"
  },
  {
    "id": 4,
    "name": "Education or awareness-raising"
  },
  {
    "id": 5,
    "name": "Other"
  }
]
```

### Objectives

```json
[
  {
    "id": 1,
    "name": "Sustainable use"
  }, 
  {
    "id": 2,
    "name": "Biodiversity conservation"
  }, 
  {
    "id": 3,
    "name": "Equitable sharing of benefits from genetic resources"
  }, 
  {
    "id": 4,
    "name": "Restoration"
  }, 
  {
    "id": 5,
    "name": "Climate change adaptation or mitigation"
  }, 
  {
    "id": 6,
    "name": "Preservation of cultural values"
  }, 
  {
    "id": 7,
    "name": "Preservation of spiritual values"
  }, 
  {
    "id": 8,
    "name": "Preservation of traditional livelihoods"
  }, 
  {
    "id": 9,
    "name": "Recreation"
  }, 
  {
    "id": 10,
    "name": "Academic research"
  }, 
  {
    "id": 11,
    "name": "Other (e.g. ecosystem services)"
  }, 
  {
    "id": 12,
    "name": "Climate change mitigation"
  }, 
  {
    "id": 13,
    "name": "Certification of products"
  }, 
  {
    "id": 14,
    "name": "Other"}
]
```

### Countries

```json
[
  {
    "id": 1,
    "name": "Global",
    "iso": "--"
  },
  {
    "id": 4,
    "name": "Afghanistan",
    "iso": "AF"
  },
  {
    "id": 6,
    "name": "Anguilla",
    "iso": "AI"
  },
  {
    "id": 9,
    "name": "Angola",
    "iso": "AO"
  },
  {
    "id": 11,
    "name": "American Samoa",
    "iso": "AS"
  },
  {
    "id": 14,
    "name": "Aruba",
    "iso": "AW"
  },
  {
    "id": 17,
    "name": "Bosnia and Herzegovina",
    "iso": "BA"
  },
  {
    "id": 19,
    "name": "Bangladesh",
    "iso": "BD"
  },
  {
    "id": 22,
    "name": "Bulgaria",
    "iso": "BG"
  },
  {
    "id": 24,
    "name": "Burundi",
    "iso": "BI"
  },
  {
    "id": 27,
    "name": "Bermuda",
    "iso": "BM"
  },
  {
    "id": 29,
    "name": "Bolivia (Plurinational State of)",
    "iso": "BO"
  },
  {
    "id": 31,
    "name": "Brazil",
    "iso": "BR"
  },
  {
    "id": 34,
    "name": "Bouvet Island",
    "iso": "BV"
  },
  {
    "id": 36,
    "name": "Belarus",
    "iso": "BY"
  },
  {
    "id": 39,
    "name": "Cocos (Keeling) Islands",
    "iso": "CC"
  },
  {
    "id": 42,
    "name": "Congo",
    "iso": "CG"
  },
  {
    "id": 44,
    "name": "Côte d’Ivoire",
    "iso": "CI"
  },
  {
    "id": 46,
    "name": "Chile",
    "iso": "CL"
  },
  {
    "id": 49,
    "name": "Colombia",
    "iso": "CO"
  },
  {
    "id": 51,
    "name": "Cuba",
    "iso": "CU"
  },
  {
    "id": 54,
    "name": "Christmas Island",
    "iso": "CX"
  },
  {
    "id": 56,
    "name": "Czech Republic",
    "iso": "CZ"
  },
  {
    "id": 59,
    "name": "Denmark",
    "iso": "DK"
  },
  {
    "id": 62,
    "name": "Algeria",
    "iso": "DZ"
  },
  {
    "id": 64,
    "name": "Estonia",
    "iso": "EE"
  },
  {
    "id": 67,
    "name": "Eritrea",
    "iso": "ER"
  },
  {
    "id": 69,
    "name": "Ethiopia",
    "iso": "ET"
  },
  {
    "id": 72,
    "name": "Falkland Islands (Malvinas)",
    "iso": "FK"
  },
  {
    "id": 74,
    "name": "Faroe Islands",
    "iso": "FO"
  },
  {
    "id": 77,
    "name": "United Kingdom of Great Britain and Northern Ireland",
    "iso": "GB"
  },
  {
    "id": 79,
    "name": "Georgia",
    "iso": "GE"
  },
  {
    "id": 82,
    "name": "Ghana",
    "iso": "GH"
  },
  {
    "id": 84,
    "name": "Greenland",
    "iso": "GL"
  },
  {
    "id": 87,
    "name": "Guadeloupe",
    "iso": "GP"
  },
  {
    "id": 89,
    "name": "Greece",
    "iso": "GR"
  },
  {
    "id": 92,
    "name": "Guam",
    "iso": "GU"
  },
  {
    "id": 95,
    "name": "Hong Kong, SAR China",
    "iso": "HK"
  },
  {
    "id": 97,
    "name": "Honduras",
    "iso": "HN"
  },
  {
    "id": 100,
    "name": "Hungary",
    "iso": "HU"
  },
  {
    "id": 102,
    "name": "Ireland",
    "iso": "IE"
  },
  {
    "id": 105,
    "name": "India",
    "iso": "IN"
  },
  {
    "id": 107,
    "name": "Iraq",
    "iso": "IQ"
  },
  {
    "id": 110,
    "name": "Italy",
    "iso": "IT"
  },
  {
    "id": 112,
    "name": "Jamaica",
    "iso": "JM"
  },
  {
    "id": 115,
    "name": "Kenya",
    "iso": "KE"
  },
  {
    "id": 118,
    "name": "Kiribati",
    "iso": "KI"
  },
  {
    "id": 120,
    "name": "Saint Kitts and Nevis",
    "iso": "KN"
  },
  {
    "id": 123,
    "name": "Kuwait",
    "iso": "KW"
  },
  {
    "id": 125,
    "name": "Kazakhstan",
    "iso": "KZ"
  },
  {
    "id": 127,
    "name": "Lebanon",
    "iso": "LB"
  },
  {
    "id": 130,
    "name": "Sri Lanka",
    "iso": "LK"
  },
  {
    "id": 132,
    "name": "Lesotho",
    "iso": "LS"
  },
  {
    "id": 135,
    "name": "Latvia",
    "iso": "LV"
  },
  {
    "id": 137,
    "name": "Morocco",
    "iso": "MA"
  },
  {
    "id": 140,
    "name": "Montenegro",
    "iso": "ME"
  },
  {
    "id": 142,
    "name": "Madagascar",
    "iso": "MG"
  },
  {
    "id": 145,
    "name": "Mali",
    "iso": "ML"
  },
  {
    "id": 147,
    "name": "Mongolia",
    "iso": "MN"
  },
  {
    "id": 150,
    "name": "Martinique",
    "iso": "MQ"
  },
  {
    "id": 152,
    "name": "Montserrat",
    "iso": "MS"
  },
  {
    "id": 155,
    "name": "Maldives",
    "iso": "MV"
  },
  {
    "id": 157,
    "name": "Mexico",
    "iso": "MX"
  },
  {
    "id": 160,
    "name": "Namibia",
    "iso": "NA"
  },
  {
    "id": 162,
    "name": "Niger",
    "iso": "NE"
  },
  {
    "id": 165,
    "name": "Nicaragua",
    "iso": "NI"
  },
  {
    "id": 167,
    "name": "Norway",
    "iso": "NO"
  },
  {
    "id": 170,
    "name": "Niue",
    "iso": "NU"
  },
  {
    "id": 172,
    "name": "Oman",
    "iso": "OM"
  },
  {
    "id": 175,
    "name": "French Polynesia",
    "iso": "PF"
  },
  {
    "id": 178,
    "name": "Pakistan",
    "iso": "PK"
  },
  {
    "id": 2,
    "name": "Andorra",
    "iso": "AD"
  },
  {
    "id": 3,
    "name": "United Arab Emirates",
    "iso": "AE"
  },
  {
    "id": 5,
    "name": "Antigua and Barbuda",
    "iso": "AG"
  },
  {
    "id": 7,
    "name": "Albania",
    "iso": "AL"
  },
  {
    "id": 8,
    "name": "Armenia",
    "iso": "AM"
  },
  {
    "id": 10,
    "name": "Argentina",
    "iso": "AR"
  },
  {
    "id": 12,
    "name": "Austria",
    "iso": "AT"
  },
  {
    "id": 182,
    "name": "Puerto Rico",
    "iso": "PR"
  },
  {
    "id": 184,
    "name": "Portugal",
    "iso": "PT"
  },
  {
    "id": 187,
    "name": "Qatar",
    "iso": "QA"
  },
  {
    "id": 189,
    "name": "Romania",
    "iso": "RO"
  },
  {
    "id": 192,
    "name": "Rwanda",
    "iso": "RW"
  },
  {
    "id": 194,
    "name": "Solomon Islands",
    "iso": "SB"
  },
  {
    "id": 197,
    "name": "Sweden",
    "iso": "SE"
  },
  {
    "id": 200,
    "name": "Slovenia",
    "iso": "SI"
  },
  {
    "id": 202,
    "name": "Slovakia",
    "iso": "SK"
  },
  {
    "id": 204,
    "name": "San Marino",
    "iso": "SM"
  },
  {
    "id": 207,
    "name": "Suriname",
    "iso": "SR"
  },
  {
    "id": 209,
    "name": "São Tomé and Príncipe",
    "iso": "ST"
  },
  {
    "id": 212,
    "name": "Syrian Arab Republic",
    "iso": "SY"
  },
  {
    "id": 214,
    "name": "Turks and Caicos Islands",
    "iso": "TC"
  },
  {
    "id": 217,
    "name": "Togo",
    "iso": "TG"
  },
  {
    "id": 219,
    "name": "Tajikistan",
    "iso": "TJ"
  },
  {
    "id": 221,
    "name": "Timor-Leste",
    "iso": "TL"
  },
  {
    "id": 224,
    "name": "Tonga",
    "iso": "TO"
  },
  {
    "id": 227,
    "name": "Tuvalu",
    "iso": "TV"
  },
  {
    "id": 229,
    "name": "United Republic of Tanzania",
    "iso": "TZ"
  },
  {
    "id": 231,
    "name": "Uganda",
    "iso": "UG"
  },
  {
    "id": 234,
    "name": "Uruguay",
    "iso": "UY"
  },
  {
    "id": 236,
    "name": "Vatican City",
    "iso": "VA"
  },
  {
    "id": 238,
    "name": "Venezuela (Bolivarian Republic of)",
    "iso": "VE"
  },
  {
    "id": 241,
    "name": "Viet Nam",
    "iso": "VN"
  },
  {
    "id": 243,
    "name": "Wallis and Futuna",
    "iso": "WF"
  },
  {
    "id": 245,
    "name": "Yemen",
    "iso": "YE"
  },
  {
    "id": 248,
    "name": "Zambia",
    "iso": "ZM"
  },
  {
    "id": 13,
    "name": "Australia",
    "iso": "AU"
  },
  {
    "id": 15,
    "name": "Åland Islands",
    "iso": "AX"
  },
  {
    "id": 16,
    "name": "Azerbaijan",
    "iso": "AZ"
  },
  {
    "id": 18,
    "name": "Barbados",
    "iso": "BB"
  },
  {
    "id": 20,
    "name": "Belgium",
    "iso": "BE"
  },
  {
    "id": 21,
    "name": "Burkina Faso",
    "iso": "BF"
  },
  {
    "id": 23,
    "name": "Bahrain",
    "iso": "BH"
  },
  {
    "id": 25,
    "name": "Benin",
    "iso": "BJ"
  },
  {
    "id": 26,
    "name": "Saint Barthélemy",
    "iso": "BL"
  },
  {
    "id": 28,
    "name": "Brunei Darussalam",
    "iso": "BN"
  },
  {
    "id": 30,
    "name": "Bonaire, Sint Eustatius, and Saba",
    "iso": "BQ"
  },
  {
    "id": 32,
    "name": "Bahamas",
    "iso": "BS"
  },
  {
    "id": 33,
    "name": "Bhutan",
    "iso": "BT"
  },
  {
    "id": 35,
    "name": "Botswana",
    "iso": "BW"
  },
  {
    "id": 37,
    "name": "Belize",
    "iso": "BZ"
  },
  {
    "id": 38,
    "name": "Canada",
    "iso": "CA"
  },
  {
    "id": 40,
    "name": "Democratic Republic of the Congo",
    "iso": "CD"
  },
  {
    "id": 41,
    "name": "Central African Republic",
    "iso": "CF"
  },
  {
    "id": 43,
    "name": "Switzerland",
    "iso": "CH"
  },
  {
    "id": 45,
    "name": "Cook Islands",
    "iso": "CK"
  },
  {
    "id": 47,
    "name": "Cameroon",
    "iso": "CM"
  },
  {
    "id": 48,
    "name": "China",
    "iso": "CN"
  },
  {
    "id": 50,
    "name": "Costa Rica",
    "iso": "CR"
  },
  {
    "id": 52,
    "name": "Cabo Verde",
    "iso": "CV"
  },
  {
    "id": 53,
    "name": "Curaçao",
    "iso": "CW"
  },
  {
    "id": 55,
    "name": "Cyprus",
    "iso": "CY"
  },
  {
    "id": 57,
    "name": "Germany",
    "iso": "DE"
  },
  {
    "id": 58,
    "name": "Djibouti",
    "iso": "DJ"
  },
  {
    "id": 60,
    "name": "Dominica",
    "iso": "DM"
  },
  {
    "id": 61,
    "name": "Dominican Republic",
    "iso": "DO"
  },
  {
    "id": 63,
    "name": "Ecuador",
    "iso": "EC"
  },
  {
    "id": 65,
    "name": "Egypt",
    "iso": "EG"
  },
  {
    "id": 66,
    "name": "Western Sahara",
    "iso": "EH"
  },
  {
    "id": 68,
    "name": "Spain",
    "iso": "ES"
  },
  {
    "id": 70,
    "name": "Finland",
    "iso": "FI"
  },
  {
    "id": 71,
    "name": "Fiji",
    "iso": "FJ"
  },
  {
    "id": 73,
    "name": "Federated States of Micronesia",
    "iso": "FM"
  },
  {
    "id": 75,
    "name": "France",
    "iso": "FR"
  },
  {
    "id": 76,
    "name": "Gabon",
    "iso": "GA"
  },
  {
    "id": 78,
    "name": "Grenada",
    "iso": "GD"
  },
  {
    "id": 80,
    "name": "French Guiana",
    "iso": "GF"
  },
  {
    "id": 81,
    "name": "Guernsey",
    "iso": "GG"
  },
  {
    "id": 83,
    "name": "Gibraltar",
    "iso": "GI"
  },
  {
    "id": 85,
    "name": "Gambia",
    "iso": "GM"
  },
  {
    "id": 86,
    "name": "Guinea",
    "iso": "GN"
  },
  {
    "id": 88,
    "name": "Equatorial Guinea",
    "iso": "GQ"
  },
  {
    "id": 90,
    "name": "South Georgia and the South Sandwich Islands",
    "iso": "GS"
  },
  {
    "id": 91,
    "name": "Guatemala",
    "iso": "GT"
  },
  {
    "id": 93,
    "name": "Guinea-Bissau",
    "iso": "GW"
  },
  {
    "id": 94,
    "name": "Guyana",
    "iso": "GY"
  },
  {
    "id": 96,
    "name": "Heard Island and McDonald Islands",
    "iso": "HM"
  },
  {
    "id": 98,
    "name": "Croatia",
    "iso": "HR"
  },
  {
    "id": 99,
    "name": "Haiti",
    "iso": "HT"
  },
  {
    "id": 101,
    "name": "Indonesia",
    "iso": "ID"
  },
  {
    "id": 103,
    "name": "Israel",
    "iso": "IL"
  },
  {
    "id": 104,
    "name": "Isle of Man",
    "iso": "IM"
  },
  {
    "id": 106,
    "name": "British Indian Ocean Territory",
    "iso": "IO"
  },
  {
    "id": 108,
    "name": "Iran (Islamic Republic Of)",
    "iso": "IR"
  },
  {
    "id": 109,
    "name": "Iceland",
    "iso": "IS"
  },
  {
    "id": 111,
    "name": "Jersey",
    "iso": "JE"
  },
  {
    "id": 113,
    "name": "Jordan",
    "iso": "JO"
  },
  {
    "id": 114,
    "name": "Japan",
    "iso": "JP"
  },
  {
    "id": 116,
    "name": "Kyrgyzstan",
    "iso": "KG"
  },
  {
    "id": 117,
    "name": "Cambodia",
    "iso": "KH"
  },
  {
    "id": 119,
    "name": "Comoros",
    "iso": "KM"
  },
  {
    "id": 121,
    "name": "Democratic People's Republic Of Korea",
    "iso": "KP"
  },
  {
    "id": 122,
    "name": "Republic Of Korea",
    "iso": "KR"
  },
  {
    "id": 124,
    "name": "Cayman Islands",
    "iso": "KY"
  },
  {
    "id": 126,
    "name": "Lao People's Democratic Republic",
    "iso": "LA"
  },
  {
    "id": 128,
    "name": "Saint Lucia",
    "iso": "LC"
  },
  {
    "id": 129,
    "name": "Liechtenstein",
    "iso": "LI"
  },
  {
    "id": 131,
    "name": "Liberia",
    "iso": "LR"
  },
  {
    "id": 133,
    "name": "Lithuania",
    "iso": "LT"
  },
  {
    "id": 134,
    "name": "Luxembourg",
    "iso": "LU"
  },
  {
    "id": 136,
    "name": "Libya",
    "iso": "LY"
  },
  {
    "id": 138,
    "name": "Monaco",
    "iso": "MC"
  },
  {
    "id": 139,
    "name": "Republic of Moldova",
    "iso": "MD"
  },
  {
    "id": 141,
    "name": "Saint Martin",
    "iso": "MF"
  },
  {
    "id": 143,
    "name": "Marshall Islands",
    "iso": "MH"
  },
  {
    "id": 144,
    "name": "The Republic of North Macedonia",
    "iso": "MK"
  },
  {
    "id": 146,
    "name": "Myanmar",
    "iso": "MM"
  },
  {
    "id": 148,
    "name": "Macau, SAR China",
    "iso": "MO"
  },
  {
    "id": 149,
    "name": "Northern Mariana Islands",
    "iso": "MP"
  },
  {
    "id": 151,
    "name": "Mauritania",
    "iso": "MR"
  },
  {
    "id": 153,
    "name": "Malta",
    "iso": "MT"
  },
  {
    "id": 154,
    "name": "Mauritius",
    "iso": "MU"
  },
  {
    "id": 156,
    "name": "Malawi",
    "iso": "MW"
  },
  {
    "id": 158,
    "name": "Malaysia",
    "iso": "MY"
  },
  {
    "id": 159,
    "name": "Mozambique",
    "iso": "MZ"
  },
  {
    "id": 161,
    "name": "New Caledonia",
    "iso": "NC"
  },
  {
    "id": 163,
    "name": "Norfolk Island",
    "iso": "NF"
  },
  {
    "id": 164,
    "name": "Nigeria",
    "iso": "NG"
  },
  {
    "id": 166,
    "name": "Netherlands",
    "iso": "NL"
  },
  {
    "id": 168,
    "name": "Nepal",
    "iso": "NP"
  },
  {
    "id": 169,
    "name": "Nauru",
    "iso": "NR"
  },
  {
    "id": 171,
    "name": "New Zealand",
    "iso": "NZ"
  },
  {
    "id": 173,
    "name": "Panama",
    "iso": "PA"
  },
  {
    "id": 174,
    "name": "Peru",
    "iso": "PE"
  },
  {
    "id": 176,
    "name": "Papua New Guinea",
    "iso": "PG"
  },
  {
    "id": 177,
    "name": "Philippines",
    "iso": "PH"
  },
  {
    "id": 179,
    "name": "Poland",
    "iso": "PL"
  },
  {
    "id": 180,
    "name": "Saint Pierre and Miquelon",
    "iso": "PM"
  },
  {
    "id": 181,
    "name": "Pitcairn Islands",
    "iso": "PN"
  },
  {
    "id": 183,
    "name": "Palestine, State of",
    "iso": "PS"
  },
  {
    "id": 185,
    "name": "Palau",
    "iso": "PW"
  },
  {
    "id": 186,
    "name": "Paraguay",
    "iso": "PY"
  },
  {
    "id": 188,
    "name": "Réunion",
    "iso": "RE"
  },
  {
    "id": 190,
    "name": "Serbia",
    "iso": "RS"
  },
  {
    "id": 191,
    "name": "Russian Federation",
    "iso": "RU"
  },
  {
    "id": 193,
    "name": "Saudi Arabia",
    "iso": "SA"
  },
  {
    "id": 195,
    "name": "Seychelles",
    "iso": "SC"
  },
  {
    "id": 196,
    "name": "Sudan",
    "iso": "SD"
  },
  {
    "id": 198,
    "name": "Singapore",
    "iso": "SG"
  },
  {
    "id": 199,
    "name": "Saint Helena, Ascension and Tristan da Cunha",
    "iso": "SH"
  },
  {
    "id": 201,
    "name": "Svalbard and Jan Mayen Islands",
    "iso": "SJ"
  },
  {
    "id": 203,
    "name": "Sierra Leone",
    "iso": "SL"
  },
  {
    "id": 205,
    "name": "Senegal",
    "iso": "SN"
  },
  {
    "id": 206,
    "name": "Somalia",
    "iso": "SO"
  },
  {
    "id": 208,
    "name": "South Sudan",
    "iso": "SS"
  },
  {
    "id": 210,
    "name": "El Salvador",
    "iso": "SV"
  },
  {
    "id": 211,
    "name": "Sint Maarten",
    "iso": "SX"
  },
  {
    "id": 213,
    "name": "Eswatini, the Kingdom of",
    "iso": "SZ"
  },
  {
    "id": 215,
    "name": "Chad",
    "iso": "TD"
  },
  {
    "id": 216,
    "name": "Terres australes et antarctiques françaises",
    "iso": "TF"
  },
  {
    "id": 218,
    "name": "Thailand",
    "iso": "TH"
  },
  {
    "id": 220,
    "name": "Tokelau",
    "iso": "TK"
  },
  {
    "id": 222,
    "name": "Turkmenistan",
    "iso": "TM"
  },
  {
    "id": 223,
    "name": "Tunisia",
    "iso": "TN"
  },
  {
    "id": 225,
    "name": "Turkey",
    "iso": "TR"
  },
  {
    "id": 226,
    "name": "Trinidad and Tobago",
    "iso": "TT"
  },
  {
    "id": 228,
    "name": "Taiwan, Province of China",
    "iso": "TW"
  },
  {
    "id": 230,
    "name": "Ukraine",
    "iso": "UA"
  },
  {
    "id": 232,
    "name": "United States Minor Outlying Islands",
    "iso": "UM"
  },
  {
    "id": 233,
    "name": "United States of America",
    "iso": "US"
  },
  {
    "id": 235,
    "name": "Uzbekistan",
    "iso": "UZ"
  },
  {
    "id": 237,
    "name": "Saint Vincent and the Grenadines",
    "iso": "VC"
  },
  {
    "id": 239,
    "name": "British Virgin Islands",
    "iso": "VG"
  },
  {
    "id": 240,
    "name": "United States Virgin Islands",
    "iso": "VI"
  },
  {
    "id": 242,
    "name": "Vanuatu",
    "iso": "VU"
  },
  {
    "id": 244,
    "name": "Samoa",
    "iso": "WS"
  },
  {
    "id": 246,
    "name": "Mayotte",
    "iso": "YT"
  },
  {
    "id": 247,
    "name": "South Africa",
    "iso": "ZA"
  },
  {
    "id": 249,
    "name": "Zimbabwe",
    "iso": "ZW"
  }
]
```