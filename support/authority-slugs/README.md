# Original Implementation found at: https://github.com/JordanHatch/authority-slugs

# Authority Slug Generator

Iterates over each local authority from Mapit and creates a JSON file mapping the authority's slug to the its SNAC and GSS code.

Run with:

    ruby generate.rb

Select the authorities to retrieve within the method named 'authority_types' in generate.rb

Convert the authorities.json file to csv with:

   ruby convert_json_to_csv.rb

Output files:

    authorities.csv
    authorities.json

    authorities_all.json contains all extracted local authorities
